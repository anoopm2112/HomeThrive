import 'package:logger/logger.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

part '.env.dart';

class Env {
  Env._();

  // Environment
  static const String environment = _Env.environment;

  // API
  static final Uri baseGuestApiUrl = _Env.baseGuestApiUrl;
  static final Uri baseAuthApiUrl = _Env.baseAuthApiUrl;

  // Static Links
  static final Uri faqUrl = _Env.faqUrl;
  static final Uri miracleFoundationEmail = _Env.miracleFoundationEmail;

  // Sentry
  static final Uri sentryDsn = _Env.sentryDsn;
  static const SentryLevel sentryLevel = _Env.sentryLevel;

  // Logging
  static const Level logLevel = _Env.logLevel;
}
