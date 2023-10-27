import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fostershare/app/router/app_router.gr.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/core/services/analytics_service.dart';
import 'package:fostershare/core/services/navigation_service.dart';
import 'package:fostershare/ui/common/themes.dart';
import 'package:oktoast/oktoast.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: MaterialApp(
        title: "FosterShare",
        theme: Themes.light(),
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          // TODO complete app specific localization and fallback
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.delegate.supportedLocales,
        navigatorKey: NavigationService.navigatorKey,
        onGenerateRoute: AppRouter().onGenerateRoute,
        navigatorObservers: [
          AnalyticsService.analyticsObserver,
        ],
      ),
    );
  }
}
