// The converter and the table are the same as the previous step.
import 'dart:convert';

import 'package:drift/drift.dart';

class StringListConverter extends TypeConverter<List<String>, String>
    with JsonTypeConverter2<List<String>, String, List<dynamic>> {
  const StringListConverter();

  @override
  List<String> fromSql(String fromDb) {
    // Convert the string from the database back to a List<String>
    if (fromDb.isEmpty) {
      return [];
    }
    return (jsonDecode(fromDb) as List).map((e) => e as String).toList();
  }

  @override
  String toSql(List<String> value) {
    // Convert the List<String> to a string to store in the database
    return jsonEncode(value);
  }


  @override
  List<String> fromJson(List<dynamic> json) {
    // Convert the JSON data to a List<String>
    return json.map((e) => e as String).toList();
  }

  @override
  List<dynamic> toJson(List<String> value) {
    // Convert the List<String> to a JSON list
    return value;
  }
}
