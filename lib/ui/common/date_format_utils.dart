import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

String formattedMMMyTimeRange({
  @required DateTime startsAt,
  @required DateTime endsAt,
  String locale, // TODO check
}) {
  if (startsAt == null || endsAt == null) {
    return "";
  }
  assert(startsAt != null);
  assert(endsAt != null);

  final abbrMonthDay = DateFormat.MMMd().format(startsAt.toLocal());
  return "$abbrMonthDay, ${formattedTimeRange(
    startsAt: startsAt,
    endsAt: endsAt,
    locale: locale,
  )}";
}

String formattedyMMMd(
  DateTime date, [
  String locale, // Look into
]) {
  if (date == null) {
    return "";
  }
  // assert(date != null);

  return DateFormat.yMMMd().format(date.toLocal());
}

String formattedSlashedDate(
  DateTime date, [
  String locale, // Look into
]) {
  assert(date != null);

  return DateFormat(
          "${DateFormat.NUM_MONTH}/${DateFormat.DAY}/${DateFormat.YEAR}")
      .format(date.toLocal());
}

String formattedTimeRange({
  @required DateTime startsAt,
  DateTime endsAt,
  String locale, // TODO check
}) {
  if (startsAt == null) {
    return "";
  }
  //assert(startsAt != null);

  String formattedTimeRange;
  if (endsAt != null) {
    formattedTimeRange =
        "${formattedHm(startsAt, locale)} - ${formattedHm(endsAt, locale)}";
  } else {
    formattedTimeRange = formattedHm(startsAt, locale);
  }

  return formattedTimeRange;
}

String formattedHm(DateTime date, [String locale]) {
  return DateFormat(DateFormat.HOUR_MINUTE)
      .format(date.toLocal())
      .toLowerCase();
}
