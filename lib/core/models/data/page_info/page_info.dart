import 'package:json_annotation/json_annotation.dart';

part 'page_info.g.dart';

@JsonSerializable(createToJson: false)
class PageInfo {
  final int count;
  final int cursor;
  final bool hasNextPage;

  const PageInfo({
    this.count,
    this.cursor,
    this.hasNextPage,
  });

  factory PageInfo.fromJson(Map<String, dynamic> json) =>
      _$PageInfoFromJson(json);
}
