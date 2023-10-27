import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'cursor_pagination_input.g.dart';

@JsonSerializable(createFactory: false)
class CursorPaginationInput {
  final String cursor;
  final int limit;

  const CursorPaginationInput({
    this.cursor,
    @required this.limit,
  }) : assert(limit != null);

  void toJson() => _$CursorPaginationInputToJson(this);
}
