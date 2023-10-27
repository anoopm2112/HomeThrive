import 'package:json_annotation/json_annotation.dart';

part 'cursor_page_info.g.dart';

@JsonSerializable(createToJson: false)
class CursorPageInfo {
  final int count;
  final String cursor;
  final bool hasNextPage;

  const CursorPageInfo({
    this.count,
    this.cursor,
    this.hasNextPage,
  });

  factory CursorPageInfo.fromJson(Map<String, dynamic> json) =>
      _$CursorPageInfoFromJson(json);
}
