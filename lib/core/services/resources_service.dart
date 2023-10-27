import 'package:fostershare/app/locator.dart';
import 'package:fostershare/core/models/data/resource_category/resource_category.dart';
import 'package:fostershare/core/models/data/resource_feed/resource_feed.dart';
import 'package:fostershare/core/services/auth/auth_service.dart';
import 'package:fostershare/core/services/graphql/auth/auth_graphql_service.dart';
import 'package:fostershare/core/services/graphql/guest/guest_graphql_service.dart';
import 'package:fostershare/core/services/logger_service.dart';
import 'package:graphql/client.dart';

class ResourcesService {
  final _authGraphQLService = locator<AuthGraphQLService>();
  final _authService = locator<AuthService>();
  final _guestGraphQLService = locator<GuestGraphQLService>();
  final _loggerService = locator<LoggerService>();

  Future<ResourceFeed> resourceFeed() async {
    _loggerService.info("ResourcesService - resourceFeed()");

    QueryResult result;

    if (_authService.signedIn) {
      result = await _authGraphQLService.resourceFeed();
    } else {
      result = await _guestGraphQLService.resourceFeed();
    }

    return ResourceFeed.fromJson(result.data);
  }

  Future<ResourceCategory> resourceCategory(String id) async {
    final QueryResult result = await _guestGraphQLService.resourceCategory(id);

    return ResourceCategory.fromJson(result.data["resourceCategory"]);
  }
}
