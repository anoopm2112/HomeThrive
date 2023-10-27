import 'package:fostershare/core/services/activity/activity_service.dart';
import 'package:fostershare/core/services/analytics_service.dart';
import 'package:fostershare/core/services/app_service.dart';
import 'package:fostershare/core/services/auth/auth_service.dart';
import 'package:fostershare/core/services/auth_bottom_nav_service.dart';
import 'package:fostershare/core/services/bottom_sheet/bottom_sheet_service.dart';
import 'package:fostershare/core/services/children_service.dart';
import 'package:fostershare/core/services/dialog_service.dart';
import 'package:fostershare/core/services/events_service.dart';
import 'package:fostershare/core/services/family_image_service.dart';
import 'package:fostershare/core/services/graphql/auth/auth_graphql_service.dart';
import 'package:fostershare/core/services/graphql/guest/guest_graphql_service.dart';
import 'package:fostershare/core/services/key_value_storage/key_value_storage_service.dart';
import 'package:fostershare/core/services/logger_service.dart';
import 'package:fostershare/core/services/med_log_service.dart';
import 'package:fostershare/core/services/messages_service.dart';
import 'package:fostershare/core/services/navigation_service.dart';
import 'package:fostershare/core/services/profile_service.dart';
import 'package:fostershare/core/services/push_notifications_service.dart';
import 'package:fostershare/core/services/resources_service.dart';
import 'package:fostershare/core/services/support_service_service.dart';
import 'package:fostershare/core/services/toast_service.dart';
import 'package:fostershare/core/services/recreaction_log_services.dart';
import 'package:fostershare/ui/views/home/auth/auth_home_view_model.dart';
import 'package:fostershare/ui/views/resources/resources_view_model.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  locator.registerLazySingleton<ActivityService>(
    () => ActivityService(),
  );
  locator.registerLazySingleton<AppService>(
    () => AppService(),
  );
  locator.registerLazySingleton<AnalyticsService>(
    () => AnalyticsService(),
  );
  locator.registerLazySingleton<AuthBottomNavService>(
    () => AuthBottomNavService(),
  );
  locator.registerLazySingleton<AuthGraphQLService>(
    () => AuthGraphQLService(),
  );
  locator.registerLazySingleton<AuthService>(
    () => AuthService(),
  );
  locator.registerLazySingleton<BottomSheetService>(
    () => BottomSheetService(),
  );
  locator.registerLazySingleton<ChildrenService>(
    () => ChildrenService(),
  );
  locator.registerLazySingleton<DialogService>(
    () => DialogService(),
  );
  locator.registerLazySingleton<EventsService>(
    () => EventsService(),
  );
  locator.registerLazySingleton<GuestGraphQLService>(
    () => GuestGraphQLService(),
  );
  locator.registerLazySingleton<KeyValueStorageService>(
    () => KeyValueStorageService(),
  );
  locator.registerLazySingleton<LoggerService>(
    () => LoggerService(),
  );
  locator.registerLazySingleton<MessagesService>(
    () => MessagesService(),
  );
  locator.registerLazySingleton<NavigationService>(
    () => NavigationService(),
  );
  locator.registerLazySingleton<PushNotificationsService>(
    () => PushNotificationsService(),
  );
  locator.registerLazySingleton<ProfileService>(
    () => ProfileService(),
  );
  locator.registerLazySingleton<ResourcesService>(
    () => ResourcesService(),
  );
  locator.registerLazySingleton<ToastService>(
    () => ToastService(),
  );

  locator.registerLazySingleton<AuthHomeViewModel>(
    () => AuthHomeViewModel(),
  );
  locator.registerLazySingleton<ResourcesViewModel>(
    () => ResourcesViewModel(),
  );
  locator.registerLazySingleton<FamilyImageService>(
    () => FamilyImageService(),
  );
  locator.registerLazySingleton<SupportServiceService>(
    () => SupportServiceService(),
  );
  locator.registerLazySingleton<MedLogService>(
    () => MedLogService(),
  );
  locator.registerLazySingleton<RecreationLogService>(
    () => RecreationLogService(),
  );
}
