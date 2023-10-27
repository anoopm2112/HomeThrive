import 'package:fostershare/core/models/data/child/child.dart';
import 'package:meta/meta.dart';

String childLogStorageKey({
  @required Child child,
  @required DateTime date,
}) {
  assert(child != null && child.id != null);
  assert(date != null);

  if (date.isUtc) {
    date = date.toLocal().startOfDateLocal();
  } else {
    date = date.startOfDateLocal();
  }

  final DateTime startOfDateUTC = date.toUtc();

  return "${child.id}_${startOfDateUTC.year}-${startOfDateUTC.month}-${startOfDateUTC.day}";
}

String childLogMapKey({
  @required Child child,
  @required DateTime date,
}) {
  assert(child != null && child.id != null);
  assert(date != null);

  return "${child.id}${date.year}${date.month}${date.day}";
}

String prevChildLogMapKey({
  @required DateTime date,
}) {
  assert(date != null);

  if (date.isUtc) {
    date = date.toLocal().startOfDateLocal();
  } else {
    date = date.startOfDateLocal();
  }

  final DateTime startOfDateUTC = date.toUtc();

  return "${startOfDateUTC.year}-${startOfDateUTC.month}-${startOfDateUTC.day}";
}

extension DateTimeExtensions on DateTime {
  DateTime startOfDateLocal() {
    return DateTime(this.year, this.month, this.day);
  }

  DateTime toDate() {
    return DateTime(this.year, this.month, this.day);
  }

  DateTime toUTCDate() {
    return DateTime.utc(this.year, this.month, this.day);
  }

  String startOfDateUTCYMD() {
    final DateTime startOfDateUTC = this.startOfDateLocal().toUtc();
    return "${startOfDateUTC.year}${startOfDateUTC.month}${startOfDateUTC.day}";
  }
}
