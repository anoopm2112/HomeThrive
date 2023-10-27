import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'get_events_input.g.dart';

@JsonSerializable(createFactory: false)
class GetEventsInput {
  @JsonKey(nullable: false)
  final DateTime fromDate;

  @JsonKey(nullable: false)
  final DateTime toDate;

  GetEventsInput({
    @required this.fromDate,
    @required this.toDate,
  })  : assert(fromDate != null),
        assert(toDate != null);

  void toJson() => _$GetEventsInputToJson(this);
}
