T extractRequiredField<T>(Map<String, dynamic> json, String field) {
  if (json[field] == null || (json[field] is String && json[field].isEmpty))
    throw MissingRequiredFieldException(field);
  return json[field];
}

T extractRequiredObject<T>(Map<String, dynamic> json, String field,
    Function(Map<String, dynamic>) parseCallback) {
  if (json[field] == null) throw MissingRequiredFieldException(field);
  if (!(json[field] is Map<String, dynamic>))
    throw FieldIsNotAnObjectException(field);
  return parseCallback(json[field]);
}

List<T> extractRequiredList<T>(Map<String, dynamic> json, String field,
    Function(Map<String, dynamic>) parseCallback) {
  if (json[field] == null) throw MissingRequiredFieldException(field);
  if (!(json[field] is List)) throw FieldIsNotAListException(field);
  return parseCallback(json[field]);
}

List<T> extractRequiredNonEmptyList<T>(Map<String, dynamic> json, String field,
    Function(Map<String, dynamic>) parseCallback) {
  final List list = extractRequiredList(json, field, parseCallback);
  if (list.isEmpty) throw FieldIsAnEmptyListException(field);
  return parseCallback(json[field]);
}

T extractOptionalField<T>(
    Map<String, dynamic> json, String field, T defaultValue) {
  return json[field] ?? defaultValue;
}

class MissingRequiredFieldException implements Exception {
  final String field;
  const MissingRequiredFieldException(this.field);

  @override
  String toString() => 'Missing Required Field: $field';
}

class FieldIsNotAnObjectException implements Exception {
  final String field;
  const FieldIsNotAnObjectException(this.field);

  @override
  String toString() => 'Field is not an Object: $field';
}

class FieldIsNotAListException implements Exception {
  final String field;
  const FieldIsNotAListException(this.field);

  @override
  String toString() => 'Field is not a List: $field';
}

class FieldIsAnEmptyListException implements Exception {
  final String field;
  const FieldIsAnEmptyListException(this.field);

  @override
  String toString() => 'Field is an empty List: $field';
}
