import 'package:fostershare/app/locator.dart';
import 'package:fostershare/core/models/data/message/message.dart';
import 'package:fostershare/core/models/input/get_messages_input/get_messages_input.dart';
import 'package:fostershare/core/models/input/mark_messages_as_read_input/mark_messages_as_read_input.dart';
import 'package:fostershare/core/models/response/get_messages_response/get_messages_response.dart';
import 'package:fostershare/core/services/graphql/auth/auth_graphql_service.dart';
import 'package:fostershare/core/services/logger_service.dart';
import 'package:graphql/client.dart';

class MessagesService {
  final _authGraphQLService = locator<AuthGraphQLService>();

  final _loggerService = locator<LoggerService>();

  Future<GetMessagesResponse> messages(GetMessagesInput input) async {
    _loggerService.info("MessagesService - messages()");

    final QueryResult result = await _authGraphQLService.messages(input);

    return GetMessagesResponse.fromJson(result.data["messages"]);
  }

  Future<List<Message>> markMessagesAsRead(
      MarkMessagesAsReadInput input) async {
    _loggerService.info("MessagesService - messages()");

    final QueryResult result =
        await _authGraphQLService.markMesssagesAsRead(input);

    final List<Message> messages = <Message>[];
    final messagesJson = result.data["markMessagesAsRead"] as List<dynamic>;
    for (var messageJson in messagesJson) {
      messages.add(Message.fromJson(messageJson));
    }
    return messages;
  }
}
