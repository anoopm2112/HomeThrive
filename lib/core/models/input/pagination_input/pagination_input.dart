import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'pagination_input.g.dart';

@JsonSerializable(createFactory: false)
class PaginationInput {
  final int cursor;
  final int limit;

  const PaginationInput({
    this.cursor,
    @required this.limit,
  }) : assert(limit != null);

  void toJson() => _$PaginationInputToJson(this);
}
