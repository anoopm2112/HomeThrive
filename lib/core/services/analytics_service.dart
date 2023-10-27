import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:meta/meta.dart';

class AnalyticsService {
  static final FirebaseAnalytics _firebaseAnalytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver analyticsObserver =
      FirebaseAnalyticsObserver(
    analytics: _firebaseAnalytics,
  );

  void logLogin() {
    _firebaseAnalytics.logLogin(loginMethod: "email");
  }

  void logProfileViewAction({@required String action}) {
    _firebaseAnalytics.logEvent(
      name: "profile_view_action",
      parameters: {
        "action": action,
      },
    );
  }

  void logSignOut() {
    _firebaseAnalytics.logEvent(name: "sign_out");
  }

  void logWelcomeViewAction({@required String action}) {
    _firebaseAnalytics.logEvent(
      name: "welcome_view_action",
      parameters: {
        "action": action,
      },
    );
  }
}
