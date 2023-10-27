import 'dart:async';

import 'package:fostershare/app/locator.dart';
import 'package:fostershare/core/models/data/family/family.dart';
import 'package:fostershare/core/models/input/update_profile_input/update_profile_input.dart';
import 'package:fostershare/core/services/auth/auth_service.dart';
import 'package:fostershare/core/services/graphql/auth/auth_graphql_service.dart';
import 'package:fostershare/core/services/logger_service.dart';
import 'package:graphql/client.dart';

class ProfileService {
  final _authGraphQLService = locator<AuthGraphQLService>();
  final _authService = locator<AuthService>();
  final _loggerService = locator<LoggerService>();

  Future<Family> family() async {
    _loggerService.info(
      "ProfileService - family()",
    );

    final QueryResult result = await _authGraphQLService.profile();

    return Family.fromJson(result.data["family"]);
  }

  Future<Family> updateProfile(UpdateProfileInput input) async {
    assert(input != null);
    _loggerService.info("ProfileService - updateProfile()");

    final QueryResult result = await _authGraphQLService.updateProfile(input);

    await _authService.updateCurrentUser(
      notifyListeners: true,
      throwError: true,
    );

    return Family.fromJson(result.data["updateProfile"]);
  }
}
