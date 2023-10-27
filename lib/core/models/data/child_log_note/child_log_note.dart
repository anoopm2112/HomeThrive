import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'child_log_note.g.dart';

@HiveType(typeId: 4)
@JsonSerializable(createToJson: false)
class ChildLogNote {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime createdAt;

  @HiveField(2)
  final String text;

  const ChildLogNote({
    this.id,
    this.createdAt,
    this.text,
  });

  factory ChildLogNote.fromJson(Map<String, dynamic> json) =>
      _$ChildLogNoteFromJson(json);
}
