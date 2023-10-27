import 'package:fostershare/env/env.dart';
import 'package:logger/logger.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class LoggerService {
  final Logger _logger = Logger(
    level: Env.logLevel,
    printer: PrettyPrinter(
      // TODO format well
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 50,
      colors: true,
      printEmojis: true,
      printTime: false,
    ),
  );

  /// Log a message at verbose level
  void verbose(String message) {
    assert(message != null);

    _logger.v(message);

    Sentry.addBreadcrumb(
      Breadcrumb(
        message: message,
      ),
    );
  }

  /// Log a message at debug level
  void debug(String message) {
    assert(message != null);

    _logger.d(message);

    Sentry.addBreadcrumb(
      Breadcrumb(
        level: SentryLevel.debug,
        message: message,
      ),
    );
  }

  /// Log a message at info level
  void info(String message) {
    assert(message != null);

    _logger.i(message);

    Sentry.addBreadcrumb(
      Breadcrumb(
        level: SentryLevel.info,
        message: message,
      ),
    );
  }

  /// Log a message at warning level
  void warn(String message) {
    assert(message != null);

    _logger.w(message);

    Sentry.addBreadcrumb(
      Breadcrumb(
        level: SentryLevel.warning,
        message: message,
      ),
    );
  }

  /// Log a message at error level
  Future<void> error(
    String message, {
    dynamic error,
    StackTrace stackTrace,
  }) async {
    assert(message != null);

    _logger.e(message, error, stackTrace);

    await Sentry.captureException(
      error,
      hint: message,
      stackTrace: stackTrace,
    );
  }

  /// Log a message at fatal level
  Future<void> fatal(
    String message, {
    dynamic error,
    StackTrace stackTrace,
  }) async {
    assert(message != null);

    _logger.wtf(message, error, stackTrace);

    await Sentry.captureException(
      error,
      hint: message,
      stackTrace: stackTrace,
    );
  }
}
