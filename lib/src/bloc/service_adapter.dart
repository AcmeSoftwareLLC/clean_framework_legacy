import 'package:clean_framework_legacy/src/defaults/either_service.dart';
import 'package:clean_framework_legacy/src/defaults/json_service.dart';

import '../model/entity.dart';

abstract class ServiceAdapter<E extends Entity, R extends JsonRequestModel,
    M extends JsonResponseModel, S extends EitherService<R, M>> {
  final S _service;

  ServiceAdapter(S service) : _service = service;

  Future<Entity> query(E initialEntity) async {
    final eitherResponse =
        await _service.request(requestModel: createRequest(initialEntity));
    return eitherResponse
        .fold((error) => createEntityWithError(initialEntity, error),
            (responseModel) {
      final errorClearedEntity = initialEntity.merge(errors: <EntityFailure>[]);
      return createEntity(errorClearedEntity as E, responseModel);
    });
  }

  E createEntity(E initialEntity, M responseModel);
  E createEntityWithError(E initialEntity, ServiceFailure error) {
    if (error is NoConnectivityServiceFailure) {
      return initialEntity.merge(errors: [NoConnectivityEntityFailure()]) as E;
    }
    return initialEntity.merge(errors: [GeneralEntityFailure()]) as E;
  }

  // Override if needed.
  R? createRequest(E entity) => null;
}
