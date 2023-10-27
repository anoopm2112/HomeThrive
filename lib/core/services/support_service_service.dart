import 'package:fostershare/app/locator.dart';
import 'package:fostershare/core/models/data/support_service/support_service.dart';
import 'package:fostershare/core/models/input/get_support_service_input/get_support_service_input.dart';
import 'package:fostershare/core/models/input/get_support_services_input/get_support_services_input.dart';
import 'package:fostershare/core/models/response/get_support_services_response/get_support_services_response.dart';
import 'package:fostershare/core/services/graphql/auth/auth_graphql_service.dart';
import 'package:fostershare/core/services/logger_service.dart';
import 'package:graphql/client.dart';

class SupportServiceService {
  final _authGraphQLService = locator<AuthGraphQLService>();
  final _loggerService = locator<LoggerService>();

  Future<SupportService> getSupportService(GetSupportServiceInput input) async {
    _loggerService.info("SupportServiceService - getSupportService()");

    QueryResult result = await _authGraphQLService.supportService(input);
    return SupportService.fromJson(result.data["supportService"]);
  }

  Future<GetSupportServicesResponse> getSupportServices(
      GetSupportServicesInput input) async {
    _loggerService.info("SupportServiceService - getSupportServices()");

    QueryResult result = await _authGraphQLService.supportServices(input);
    return GetSupportServicesResponse.fromJson(result.data["supportServices"]);
  }
}
