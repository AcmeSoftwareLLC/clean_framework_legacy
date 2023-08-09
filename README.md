# Clean Framework

[![pub package](https://img.shields.io/pub/v/clean_framework.svg?include_prereleases)](https://pub.dartlang.org/packages/clean_framework)
[![licence](https://img.shields.io/badge/licence-BSD-brightgreen.svg)](https://github.com/MattHamburger/clean_framework/blob/master/LICENSE)

Clean Architecture components library, inspired on the guidelines created by Uncle Bob.

## Learning Resources

1. [Introduction](https://github.com/MattHamburger/clean_framework/blob/master/doc/introduction.pdf), to understand the relationship between the components
of the framework.
2. [Navigating with CFRouter](https://github.com/MattHamburger/clean_framework/blob/master/doc/routing.md), to start using high level Navigator 2.0 APIs bundled with Clean Framework.
3. [Mockoon Installation](https://github.com/MattHamburger/clean_framework/blob/master/doc/mockoon.md), since the tests in the example folder require
an instance of Mockoon running.


## Installation

### 1. Depend on it

Add this to your package's pubspec.yaml file:
```yaml
dependencies:
    clean_framework_legacy: ^1.0.0
```

### 2. Install it

You can install packages from the command line:
with Flutter:
```bash
$ flutter pub get
```
Alternatively, your editor might support `flutter pub get`. Check the docs for your editor to learn more.

### 3. Import it

Now in your Dart code, you can use:
```dart
import 'package:clean_framework_legacy/clean_framework.dart';
```

## Folder Structure

Whatever name is used for `feature_name` can replace `feature` in the file names of the feature's directory
```
lib
|-- feature_name
|   |-- api
|   |   |-- feature_service.dart
|   |   |-- feature_service_request.dart
|   |   |-- feature_service_response.dart
|   |-- bloc
|   |   |-- feature_bloc.dart
|   |   |-- feature_service_adapter.dart
|   |   |-- feature_usecase.dart
|   |-- model
|   |   |-- feature_entity.dart
|   |   |-- feature_view_model.dart
|   |-- ui
|   |   |-- feature_widget.dart
|   |   |-- feature_presenter.dart
|   |   |-- feature_screen.dart
locator.dart
main.dart
```

## Layers

### API

The *API* module defines the logic for your API services, request, and response. The module defines the logic for REST API request and response that will be consumed by the *Bloc*.


#### Service

* Every *Feature Service* class should extend *EitherService<JsonRequestModel, JsonResponseModel>* from `clean_framework_defaults.dart`

#### ServiceRequest

* Every *Feature ServiceRequest* class should extend *Equatable* and implement *JsonRequestModel* from `clean_framework_defaults.dart`

##### ServiceResponse

* Every *Feature ServiceResponse* class should extend *Equatable* and implement *JsonResponseModel* from `clean_framework_defaults.dart`

### Bloc

The *Bloc* module represents the logic of data flow within the application. It is the middle layer between the *API* and *UI* layers. The *Bloc* is responsible for updating the pipe when the data changes.

#### Bloc Class

* Every *Feature Bloc* class should extend *Bloc* from `clean_framework.dart`
* Responsible for updating the *ViewModel* as the data coming from the API changes

#### ServiceAdapter

* Every *Feature ServiceAdapter* should extend *ServiceAdapter* from `clean_framework.dart`
* Responsible for connecting the contents of the *API* and the *UseCase*
* Called when a *UseCase* requests data or sends data

#### UseCase

* Every *Feature UseCase* should extend *UseCase* from `clean_framework.dart`
* Contains app-specific rules/commands
* Responsible for the flow of data within the app

### Model

The *Model* module defines the business logic of the application. This module consists of two main classes: *Entity* and *ViewModel*. The *Entity* class determines how the model class will be represented in the *Repository (in locator.dart)*. The *ViewModel* class represents how the data is passed through to the UI. The *Presenter* passes the *ViewModel* to the *Screen* when the *Presenter* is called in the *Widget*.

#### Entity

* Every *Feature Entity* class should extend *Entity* from `clean_framework.dart`
* Made up of classes that represent the data in the *Repository*

#### ViewModel

* Every *Feature ViewModel* class should extend *ViewModel* from `clean_framework.dart`
* Made up of classes that represent how the data is presented to the UI

### UI

The *UI* module is responsible for all things UI, from triggering the bloc to update the UI, to painting the screen with data send from the UI.

#### Widget

* Every *Feature Widget* should extend *StatelessWidget*
* Responsible for kickstarting the *Bloc* and return the *Presenter*
* Is called in `main.dart` when the feature is the first screen, or in a Navigator when switching to that feature

#### Presenter

* Every *Feature Presenter* should extend *Presenter* from `clean_framework.dart`
* Responsible for calling appropriate methods as data reaches different stages

#### Screen
* Every *Feature Screen* should extend *Screen* from `clean_framework.dart`
* Responsible for building UI widgets; should not include any logic other than UI