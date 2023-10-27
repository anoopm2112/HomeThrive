import 'package:fostershare/core/models/data/enums/enums.dart';
import 'package:json_annotation/json_annotation.dart';

part 'event.g.dart';

@JsonSerializable(createToJson: false)
class Event {
  final String id;
  final DateTime createdAt;
  final DateTime updateAt;
  final DateTime startsAt;
  final DateTime endsAt;
  final EventParticipantStatus status;
  final String eventType;
  final String title;
  final String description;
  final Uri image;
  final String venue;
  final String address;
  final double latitutde;
  final double longitude;

  const Event({
    this.id,
    this.createdAt,
    this.updateAt,
    this.startsAt,
    this.endsAt,
    this.status,
    this.eventType,
    this.title,
    this.description,
    this.image,
    this.venue,
    this.address,
    this.latitutde,
    this.longitude,
  });

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
}
