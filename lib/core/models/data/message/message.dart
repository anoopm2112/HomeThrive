import 'package:json_annotation/json_annotation.dart';

import 'package:fostershare/core/models/data/enums/enums.dart';

part 'message.g.dart';

@JsonSerializable(createToJson: false)
class Message {
  final String id;
  final DateTime createdAt;
  final MessageStatus status;
  final String title;
  final String body;

  const Message({
    this.id,
    this.createdAt,
    this.status,
    this.title,
    this.body,
  });

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  Message copyWith({
    String id,
    DateTime createdAt,
    MessageStatus status,
    String title,
    String body,
  }) {
    return Message(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      title: title ?? this.title,
      body: body ?? this.body,
    );
  }
}
