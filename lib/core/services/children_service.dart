import 'package:fostershare/app/locator.dart';
import 'package:fostershare/core/models/data/child/child.dart';
import 'package:fostershare/core/models/data/child_log/child_log.dart';
import 'package:fostershare/core/models/data/child_log_image/child_log_image.dart';
import 'package:fostershare/core/models/data/child_log_note/child_log_note.dart';
import 'package:fostershare/core/models/data/children_summary/children_summary.dart';
import 'package:fostershare/core/models/input/create_child_log_image_input/create_child_log_image_input.dart';
import 'package:fostershare/core/models/input/create_child_log_input/create_child_log_input.dart';
import 'package:fostershare/core/models/input/create_child_log_note/create_child_log_note_input.dart';
import 'package:fostershare/core/models/input/get_child_logs_input/get_child_logs_input.dart';
import 'package:fostershare/core/models/input/get_children_logs/get_children_logs_input.dart';
import 'package:fostershare/core/models/input/update_child_input/update_child_input.dart';
import 'package:fostershare/core/models/input/update_child_log_input/update_child_log_input.dart';
import 'package:fostershare/core/models/input/update_child_nickname_input/update_child_nickname_input.dart';
import 'package:fostershare/core/models/response/get_child_log_response/get_child_logs_response.dart';
import 'package:fostershare/core/services/graphql/auth/auth_graphql_service.dart';
import 'package:fostershare/core/services/logger_service.dart';
import 'package:graphql/client.dart';

class ChildrenService {
  final _authGraphQLService = locator<AuthGraphQLService>();
  final _loggerService = locator<LoggerService>();

  Future<ChildLog> childLog(GetChildLogInput input) async {
    _loggerService.info("ChildrenService - childLog()");

    final QueryResult result = await _authGraphQLService.childLog(input);

    return ChildLog.fromJson(result.data["childLog"]);
  }

  Future<List<Child>> children() async {
    _loggerService.info("ChildrenService - children()");

    final QueryResult result = await _authGraphQLService.children();

    final List<Child> children = <Child>[];

    final childrenJson = result.data["children"] as List<dynamic>;
    for (var child in childrenJson) {
      children.add(Child.fromJson(child));
    }

    return children;
  }

  Future<GetChildLogsResponse> childrenLogsInput(
    GetChildrenLogsInput input,
  ) async {
    _loggerService.info("ChildrenService - children()");

    final QueryResult result = await _authGraphQLService.childrenLogs(input);

    return GetChildLogsResponse.fromJson(result.data["childrenLogs"]);
  }

  Future<ChildrenSummary> childrenSummary(
    GetChildrenLogsInput input,
  ) async {
    _loggerService.info("ChildrenService - childrenSummary()");

    final QueryResult result = await _authGraphQLService.childrenSummary(input);
    print(result.data);

    return ChildrenSummary.fromJson(result.data);
  }

  Future<ChildLog> createChildLog(CreateChildLogInput input) async {
    _loggerService.info("ChildrenService - createChildLog()");

    final QueryResult result = await _authGraphQLService.createChildLog(input);

    return ChildLog.fromJson(result.data["createChildLog"]);
  }

  Future<ChildLog> updateChildLog(UpdateChildLogInput input) async {
    _loggerService.info("ChildrenService - updateChildLog()");

    final QueryResult result = await _authGraphQLService.updateChildLog(input);

    return ChildLog.fromJson(result.data["updateChildLog"]);
  }

  Future<ChildLogImage> createChildLogImage(
      CreateChildLogImageInput input) async {
    _loggerService.info("ChildrenService - createChildLogImage()");

    final QueryResult result =
        await _authGraphQLService.createChildLogImage(input);

    return ChildLogImage.fromJson(result.data["createChildLogImage"]);
  }

  Future<ChildLogNote> createChildLogNote(CreateChildLogNoteInput input) async {
    _loggerService.info("ChildrenService - createChildLogNote()");

    final QueryResult result =
        await _authGraphQLService.createChildLogNote(input);

    return ChildLogNote.fromJson(result.data["createChildLogNote"]);
  }

  Future<Child> updateChild(UpdateChildInput input) async {
    _loggerService.info("ChildrenService - updateChild()");

    final QueryResult result = await _authGraphQLService.updateChild(input);

    return Child.fromJson(result.data["updateChild"]);
  }

  Future<Child> updateChildNickName(UpdateChildNickNameInput input) async {
    _loggerService.info("ChildrenService - updateChildNickName()");

    final QueryResult result =
        await _authGraphQLService.updateChildNickName(input);

    return Child.fromJson(result.data["updateChildNickname"]);
  }
}
