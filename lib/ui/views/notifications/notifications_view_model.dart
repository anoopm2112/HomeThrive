import 'package:fostershare/app/locator.dart';
import 'package:fostershare/core/models/data/enums/enums.dart';
import 'package:fostershare/core/models/data/message/message.dart';
import 'package:fostershare/core/models/input/cursor_pagination_input/cursor_pagination_input.dart';
import 'package:fostershare/core/models/input/get_messages_input/get_messages_input.dart';
import 'package:fostershare/core/models/input/mark_messages_as_read_input/mark_messages_as_read_input.dart';
import 'package:fostershare/core/models/response/get_messages_response/get_messages_response.dart';
import 'package:fostershare/core/services/logger_service.dart';
import 'package:fostershare/core/services/messages_service.dart';
import 'package:fostershare/core/services/navigation_service.dart';
import 'package:stacked/stacked.dart';

class NotificationsViewModel extends BaseViewModel {
  final _loggerService = locator<LoggerService>();
  final _messagesService = locator<MessagesService>();
  final _navigationService = locator<NavigationService>();

  GetMessagesResponse _messagesResponse;

  int _index = 0;
  int _limit = 10;

  List<Message> _messages = <Message>[];
  List<Message> get messages => this._messages;

  bool get showNoMessages => this._messages.isEmpty;

  Future<void> loadMessages() async {
    this.setBusy(true);

    try {
      await _fetchMessages();
      _markMessagesAsRead();
    } catch (e, s) {
      _loggerService.error(
        "NotificationsViewModel | loadMessages() - Couldn't load messages",
        error: e,
        stackTrace: s,
      );

      // TODO
    }

    this.setBusy(false);
  }

  Future<void> _fetchMessages() async {
    this._messagesResponse = await _messagesService.messages(
      GetMessagesInput(
        pagination: CursorPaginationInput(
          cursor: this._messagesResponse?.pageInfo?.cursor,
          limit: this._limit,
        ),
      ),
    );

    this._messages.addAll(this._messagesResponse.items);
  }

  void onCardCreated(int index) {
    _index = index;
    if (_index % this._limit == this._limit - 1) {
      _fetchMessages().then(
        (_) {
          notifyListeners();
          _markMessagesAsRead();
        },
      );
    }
  }

  void _markMessagesAsRead() {
    final List<String> loadedUnreadMessagesIds = this
        ._messages
        .where((message) => message.status == MessageStatus.sent)
        .map<String>((message) => message.id)
        .toList();

    _messagesService
        .markMessagesAsRead(
      MarkMessagesAsReadInput(ids: loadedUnreadMessagesIds),
    )
        .then(
      (updatedMessages) {
        final List<Message> messagesToUpdate = this
            ._messages
            .where(
              (message) => updatedMessages.any(
                (updatedMessage) => updatedMessage.id == message.id,
              ),
            )
            .toList();
        print(messagesToUpdate.length);
        messagesToUpdate.forEach(
          (message) {
            this._messages[this._messages.indexOf(message)] = message.copyWith(
              status: MessageStatus.read,
            );
          },
        );
        notifyListeners();
      },
    );
  }

  void onBack() {
    _navigationService.back();
  }
}
