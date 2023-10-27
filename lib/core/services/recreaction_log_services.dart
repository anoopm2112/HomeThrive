import 'package:fostershare/app/locator.dart';
import 'package:fostershare/core/models/data/child/child.dart';
import 'package:fostershare/core/models/data/recreation_log/recreation_log.dart';
import 'package:fostershare/core/models/input/get_recreation_logs_input/get_recreation_logs_input.dart';
import 'package:fostershare/core/models/input/get_recreation_log_input/get_recreation_log_input.dart';
import 'package:fostershare/core/models/input/create_recreation_log_input/create_recreation_log_input.dart';
import 'package:fostershare/core/models/response/get_recreation_logs_response/get_recreation_logs_response.dart';
import 'package:fostershare/core/services/graphql/auth/auth_graphql_service.dart';
import 'package:fostershare/core/services/logger_service.dart';
import 'package:graphql/client.dart';

class RecreationLogService {
  final _authGraphQLService = locator<AuthGraphQLService>();
  final _loggerService = locator<LoggerService>();

  Future<RecreationLog> getSupportService(GetRecreationLogInput input) async {
    _loggerService.info("RecreationLogService - getRecreationLog()");

    QueryResult result = await _authGraphQLService.recreationLog(input);
    return RecreationLog.fromJson(result.data["recreationLog"]);
  }

  Future<GetRecreationLogsResponse> recreationLogs(
    GetRecreationLogsInput input,
  ) async {
    _loggerService.info("ReacreationLogService - recreationLogs()");

    final QueryResult result = await _authGraphQLService.recreationLogs(input);

    return GetRecreationLogsResponse.fromJson(result.data["recreationLogs"]);
  }

  Future<RecreationLog> createRecreationLog(
      CreateRecreationLogInput input) async {
    _loggerService.info("ChildrenService - createRecLog()");

    final QueryResult result =
        await _authGraphQLService.createRecreationLog(input);

    return RecreationLog.fromJson(result.data["createReacreationLog"]);
  }
}
