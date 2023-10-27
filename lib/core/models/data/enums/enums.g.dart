// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enums.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MoodRatingAdapter extends TypeAdapter<MoodRating> {
  @override
  final int typeId = 1;

  @override
  MoodRating read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return MoodRating.hardDay;
      case 1:
        return MoodRating.soso;
      case 2:
        return MoodRating.average;
      case 3:
        return MoodRating.good;
      case 4:
        return MoodRating.great;
      default:
        return null;
    }
  }

  @override
  void write(BinaryWriter writer, MoodRating obj) {
    switch (obj) {
      case MoodRating.hardDay:
        writer.writeByte(0);
        break;
      case MoodRating.soso:
        writer.writeByte(1);
        break;
      case MoodRating.average:
        writer.writeByte(2);
        break;
      case MoodRating.good:
        writer.writeByte(3);
        break;
      case MoodRating.great:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MoodRatingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ChildBehaviorAdapter extends TypeAdapter<ChildBehavior> {
  @override
  final int typeId = 2;

  @override
  ChildBehavior read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ChildBehavior.bedWetting;
      case 1:
        return ChildBehavior.agression;
      case 2:
        return ChildBehavior.food;
      case 3:
        return ChildBehavior.depression;
      case 4:
        return ChildBehavior.anxiety;
      case 5:
        return ChildBehavior.schoolIssues;
      case 6:
        return ChildBehavior.other;
      default:
        return null;
    }
  }

  @override
  void write(BinaryWriter writer, ChildBehavior obj) {
    switch (obj) {
      case ChildBehavior.bedWetting:
        writer.writeByte(0);
        break;
      case ChildBehavior.agression:
        writer.writeByte(1);
        break;
      case ChildBehavior.food:
        writer.writeByte(2);
        break;
      case ChildBehavior.depression:
        writer.writeByte(3);
        break;
      case ChildBehavior.anxiety:
        writer.writeByte(4);
        break;
      case ChildBehavior.schoolIssues:
        writer.writeByte(5);
        break;
      case ChildBehavior.other:
        writer.writeByte(6);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChildBehaviorAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
