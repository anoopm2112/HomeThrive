import 'dart:async';
import 'dart:convert';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:fostershare/app/locator.dart';
import 'package:fostershare/core/models/type/current_user.dart';
import 'package:fostershare/core/services/logger_service.dart';
import 'package:fostershare/core/services/push_notifications_service.dart';
import 'package:meta/meta.dart';
import 'package:stacked/stacked.dart';

part 'amplify_configuration.dart';

class AuthService with ReactiveServiceMixin {
  final _loggerService = locator<LoggerService>();

  bool _signedIn = false; // TODO
  bool get signedIn => _signedIn;

  CurrentUser _currentUser;
  CurrentUser get currentUser => _currentUser;

  // StreamSubscription _hubSubscription;

  AuthService() {
    Amplify.addPlugin(AmplifyAuthCognito());
    // _hubSubscription = Amplify.Hub.listen([HubChannel.Auth], (hubEvent) async {
    //   _loggerService.info( TODO look into
    //     "AuthService - AuthListner called with ${hubEvent.eventName}",
    //   );
    //   switch (hubEvent.eventName) {
    //     case "SIGNED_IN":
    //       await _setSignedIn(true);
    //       break;
    //     case "SIGNED_OUT":
    //       await _setSignedIn(false);
    //       break;
    //     case "SESSION_EXPIRED":
    //       await _setSignedIn(false);
    //       break;
    //   }
    // })
    //   ..onDone(() {
    //     _hubSubscription.cancel();
    //   });
  }

  Future<void> init() async {
    try {
      await Amplify.configure(_amplifyConfiguration);
    } on AmplifyAlreadyConfiguredException {
      _loggerService.info("AuthService - Amplfy is already configured");
    }
  }

  Future<void> _updateAuth(bool signedIn) async {
    _loggerService.info(
      "AuthService - _updateAuth(signedIn: $signedIn)",
    );

    if (this._signedIn != signedIn) {
      this._signedIn = signedIn;

      if (this._signedIn) {
        await updateCurrentUser();
      } else {
        _currentUser = null;
      }

      notifyListeners();
    }
  }

  Future<void> updateCurrentUser({
    bool notifyListeners = false,
    bool throwError = false,
  }) async {
    try {
      this._currentUser = CurrentUser(
        attributes: await Amplify.Auth.fetchUserAttributes(),
      );
    } catch (e) {
      this._currentUser = null;
      // TODO
      if (throwError) {
        throw e;
      }
    }

    if (notifyListeners) {
      this.notifyListeners();
    }
  }

  Future<String> getIdToken() async {
    _loggerService.info(
      "AuthService - called getIdToken() with signedIn: ${this.signedIn}",
    );

    final CognitoAuthSession authSession = await _fetchAuthSession();

    return authSession.userPoolTokens.idToken;
  }

  Future<bool> getAuthStatus() async {
    _loggerService.info(
      "AuthService - getAuthStatus()",
    );

    final CognitoAuthSession authSession = await _fetchAuthSession();

    return authSession.isSignedIn;
  }

  Future<CognitoAuthSession> _fetchAuthSession() async {
    _loggerService.info(
      "AuthService - _fetchAuthSession()",
    );

    final CognitoAuthSession authSession = await Amplify.Auth.fetchAuthSession(
      options: CognitoSessionOptions(getAWSCredentials: true),
    );

    await _updateAuth(authSession.isSignedIn); // TODO more work

    return authSession;
  }

  Future<SignInResult> loginWithEmailAndPassword({
    @required String email,
    @required String password,
  }) async {
    assert(email != null);
    assert(password != null);
    _loggerService.info("AuthService - loginWithEmailAndPassword()");

    final SignInResult signInResult = await Amplify.Auth.signIn(
      username: email,
      password: password,
    );

    await _updateAuth(signInResult.isSignedIn);

    return signInResult;
  }

  Future<SignInResult> confirmSignInWithPassword({
    @required String newPassword,
  }) async {
    assert(newPassword != null);
    _loggerService.info("AuthService - confirmSignInWithPassword()");

    final SignInResult signInResult = await Amplify.Auth.confirmSignIn(
      confirmationValue: newPassword,
    );

    await _updateAuth(signInResult.isSignedIn);

    return signInResult;
  }

  Future<ResetPasswordResult> resetPassword({@required String email}) async {
    assert(email != null);

    return await Amplify.Auth.resetPassword(
      username: email,
    );
  }

  Future<UpdatePasswordResult> confirmPassword({
    @required String email,
    @required String newPassword,
    @required String confirmationCode,
  }) async {
    assert(email != null);
    assert(newPassword != null);
    assert(confirmationCode != null);

    final UpdatePasswordResult result = await Amplify.Auth.confirmPassword(
      username: email,
      newPassword: newPassword,
      confirmationCode: confirmationCode,
    );

    await _updateAuth(false);

    return result;
  }

  Future<UpdatePasswordResult> changePassword({
    @required String oldPassword,
    @required String newPassword,
  }) async {
    assert(oldPassword != null);
    assert(newPassword != null);

    return await Amplify.Auth.updatePassword(
      oldPassword: oldPassword,
      newPassword: newPassword,
    );
  }

  Future<SignOutResult> signOut() async {
    final _pushNotificationService = locator<PushNotificationsService>();
    final signOutResult = await Amplify.Auth.signOut();
    await _pushNotificationService.onSignOut();
    await _updateAuth(false);
    return signOutResult;
  }
}
