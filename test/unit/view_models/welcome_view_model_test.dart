// import 'package:flutter_test/flutter_test.dart';
// import 'package:fostershare/app/router/app_router.gr.dart';
// import 'package:fostershare/core/services/navigation_service.dart';
// import 'package:fostershare/ui/views/welcome/welcome_view_model.dart';
// import 'package:mockito/mockito.dart';

// import '../mock/mock_services.dart';

// main() {
//   group('WelcomeViewModelTest -', () {
//     setUpAll(registerServices);
//     tearDownAll(unregisterServices);

//     group("onContinueWithoutAccount -", () {
//       test(
//           "When called, should replace the navigation stack with the bottom navigation view using the navigation service",
//           () {
//         final NavigationService _mockNavigationService =
//             getAndRegisterNavigationServiceMock();

//         final model = WelcomeViewModel();
//         model.onContinueWithoutAccount();

//         verify(_mockNavigationService.replaceWith(Routes.bottomNavView));
//       });
//     });

//     group("onLogin -", () {
//       test(
//           "When called, should navigate to the loginView using the navigationService",
//           () {
//         final _mockNavigationService = getAndRegisterNavigationServiceMock();

//         final model = WelcomeViewModel();
//         model.onLogin();

//         verify(_mockNavigationService.navigateTo(Routes.loginView));
//       });
//     });
//   });
// }
