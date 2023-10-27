// import 'package:flutter_test/flutter_test.dart';
// import 'package:fostershare/app/router/app_router.gr.dart';
// import 'package:fostershare/core/services/auth/auth_service.dart';
// import 'package:fostershare/core/services/navigation_service.dart';
// import 'package:fostershare/ui/views/start_up/start_up_view_model.dart';
// import 'package:mockito/mockito.dart';

// import '../mock/mock_services.dart';

// main() {
//   group('StartUpViewTest -', () {
//     setUpAll(registerServices);
//     tearDownAll(unregisterServices);

//     group("onModelReady -", () {
//       test("When called, auth service should be initalized", () async {
//         final AuthService _mockAuthService = getAndRegisterAuthServiceMock();

//         final model = StartUpViewModel();
//         await model.onModelReady();

//         verify(_mockAuthService.init());
//       });

//       test("When isSignedIn is false, should clear and show WelcomeView",
//           () async {
//         final NavigationService _mockNavigationService =
//             getAndRegisterNavigationServiceMock();

//         final model = StartUpViewModel();
//         await model.onModelReady();

//         verify(_mockNavigationService.clearStackAndShow(Routes.welcomeView));
//       });

//       test("When isSignedIn is true, should clear and show BottomNavView",
//           () async {
//         getAndRegisterAuthServiceMock(isSignedIn: true);
//         final NavigationService _mockNavigationService =
//             getAndRegisterNavigationServiceMock();

//         final model = StartUpViewModel();
//         await model.onModelReady();

//         verify(_mockNavigationService.clearStackAndShow(Routes.bottomNavView));
//       });
//     });
//   });
// }
