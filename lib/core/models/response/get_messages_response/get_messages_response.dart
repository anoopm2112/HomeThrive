import 'package:fostershare/core/models/data/cursor_page_info/cursor_page_info.dart';
import 'package:fostershare/core/models/data/message/message.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_messages_response.g.dart';

@JsonSerializable(createToJson: false)
class GetMessagesResponse {
  final List<Message> items;
  final CursorPageInfo pageInfo;
  bool get hasMessages => items != null && items.isNotEmpty;

  const GetMessagesResponse({
    this.items,
    this.pageInfo,
  });

  factory GetMessagesResponse.fromJson(Map<String, dynamic> json) =>
      _$GetMessagesResponseFromJson(json);
}
