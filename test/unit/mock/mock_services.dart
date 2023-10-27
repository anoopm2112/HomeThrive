// import 'package:fostershare/app/locator.dart';
// import 'package:fostershare/core/services/auth/auth_service.dart';
// import 'package:fostershare/core/services/navigation_service.dart';
// import 'package:fostershare/core/services/resources_service.dart';
// import 'package:mockito/mockito.dart';

// void registerServices() {
//   getAndRegisterAuthServiceMock();
//   getAndRegisterNavigationServiceMock();
//   getAndRegisterResourceServiceMock();
// }

// void unregisterServices() {
//   locator.unregister<AuthService>();
//   locator.unregister<NavigationService>();
//   locator.unregister<ResourcesService>();
// }

// class AuthServiceMock extends Mock implements AuthService {}

// AuthService getAndRegisterAuthServiceMock({
//   bool isSignedIn = false,
// }) {
//   assert(isSignedIn != null);

//   _removeRegistrationIfExists<AuthService>();
//   final AuthService service = AuthServiceMock();

//   when(service.getSignedIn()).thenAnswer((_) => Future.value(isSignedIn));

//   locator.registerSingleton<AuthService>(service);
//   return service;
// }

// class NavigationServiceMock extends Mock implements NavigationService {}

// NavigationService getAndRegisterNavigationServiceMock() {
//   _removeRegistrationIfExists<NavigationService>();
//   final NavigationService service = NavigationServiceMock();
//   locator.registerSingleton<NavigationService>(service);
//   return service;
// }

// class ResourceServiceMock extends Mock implements ResourcesService {}

// ResourcesService getAndRegisterResourceServiceMock() {
//   _removeRegistrationIfExists<ResourcesService>();
//   final ResourcesService service = ResourceServiceMock();
//   locator.registerSingleton<ResourcesService>(service);
//   return service;
// }

// void _removeRegistrationIfExists<T>() {
//   if (locator.isRegistered<T>()) {
//     locator.unregister<T>();
//   }
// }
