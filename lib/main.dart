import 'package:flutter/material.dart';
import 'package:fostershare/app/app.dart';
import 'package:fostershare/app/locator.dart';
import 'package:fostershare/env/env.dart';
import 'package:sentry_flutter/sentry_flutter.dart' as sentry;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  sentry.SentryFlutter.init(
    (options) {
      options
        ..dsn = Env.sentryDsn.toString()
        ..environment = Env.environment
        ..diagnosticLevel = Env.sentryLevel;
    },
    appRunner: () => runApp(
      App(),
    ),
  );
}
