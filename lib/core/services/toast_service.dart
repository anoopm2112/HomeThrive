import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';

import 'package:fostershare/core/services/navigation_service.dart';
import 'package:fostershare/ui/common/app_colors.dart';
import 'package:oktoast/oktoast.dart';

class ToastService {
  final FToast _toast = FToast();
  ToastService();

  void displayToast(String text) {
    showToast(
      text,
      duration: Duration(seconds: 2),
      position: ToastPosition.bottom,
      backgroundColor: AppColors.orange500,
      radius: 5.0,
      textStyle: TextStyle(fontSize: 24, color: Colors.white),
    );
  }

  void passwordResetRequired({void Function() onDismiss}) {
    var localization = AppLocalizations.current;
    showToastWidget(
      Card(
        color: AppColors.orange500,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.lock),
              SizedBox(width: 8),
              Text(localization.passwordResetRequired),
            ],
          ),
        ),
      ),
      duration: Duration(seconds: 20),
      onDismiss: onDismiss,
    );
  }

  void newCodeSent({void Function() onDismiss}) {
    var localization = AppLocalizations.current;
    showToast(
      localization.newCodeSent,
      duration: Duration(seconds: 2),
      position: ToastPosition.center,
      backgroundColor: AppColors.orange500,
      radius: 5.0,
      textStyle: TextStyle(fontSize: 32, color: Colors.white),
      onDismiss: onDismiss,
    );
  }

  void sendInvitiation(void Function() onDismiss) {
    var localization = AppLocalizations.current;
    showToast(
      localization.errorSendingInvite,
      duration: Duration(seconds: 2),
      position: ToastPosition.center,
      backgroundColor: AppColors.orange500,
      radius: 5.0,
      textStyle: TextStyle(fontSize: 32, color: Colors.white),
      onDismiss: onDismiss,
    );
  }

  void profileUpdated(void Function() onDismiss) {
    var localization = AppLocalizations.current;
    showToast(
      localization.profileUpdated,
      duration: Duration(seconds: 2),
      position: ToastPosition.center,
      backgroundColor: AppColors.orange500,
      radius: 5.0,
      textStyle: TextStyle(fontSize: 32, color: Colors.white),
      onDismiss: onDismiss,
    );
  }

  void profileUpdateError(void Function() onDismiss) {
    var localization = AppLocalizations.current;
    showToast(
      localization.errorUpdatingProfile,
      duration: Duration(seconds: 2),
      position: ToastPosition.center,
      backgroundColor: AppColors.orange500,
      radius: 5.0,
      textStyle: TextStyle(fontSize: 32, color: Colors.white),
      onDismiss: onDismiss,
    );
  }

  void passwordChanged(void Function() onDismiss) {
    var localization = AppLocalizations.current;
    showToast(
      localization.profileSuccessfullyChanged,
      duration: Duration(seconds: 2),
      position: ToastPosition.center,
      backgroundColor: AppColors.orange500,
      radius: 5.0,
      textStyle: TextStyle(fontSize: 32, color: Colors.white),
      onDismiss: onDismiss,
    );
  }

  void passwordChangeError(void Function() onDismiss) {
    var localization = AppLocalizations.current;
    showToast(
      localization.errorChangingPassword,
      duration: Duration(seconds: 2),
      position: ToastPosition.center,
      backgroundColor: AppColors.orange500,
      radius: 5.0,
      textStyle: TextStyle(fontSize: 32, color: Colors.white),
      onDismiss: onDismiss,
    );
  }

  void test(void Function() onDismiss) {
    print(
        "CONTEXT: ${NavigationService.navigatorKey.currentState.overlay.context}");
    // _toast.init(NavigationService.navigatorKey.currentState.overlay.context);
    // print(Overlay.of(
    //     NavigationService.navigatorKey.currentState.overlay.context));
    // _toast.showToast(child: Text("HELLLOOOO"));
    // _toast.init(NavigationService.navigatorKey.currentContext);
    // print("NAV: ${NavigationService.navigatorKey.currentContext}");
    var localization = AppLocalizations.current;
    showToast(
      localization.inviteSent,
      duration: Duration(seconds: 2),
      position: ToastPosition.center,
      backgroundColor: AppColors.orange500,
      radius: 5.0,
      textStyle: TextStyle(fontSize: 32, color: Colors.white),
      onDismiss: onDismiss,
    );
    // showToastWidget(
    //   Card(
    //     color: AppColors.orange500,
    //     child: Padding(
    //       padding: const EdgeInsets.all(16),
    //       child: Row(
    //         children: [
    //           Icon(Icons.lock),
    //           SizedBox(width: 8),
    //           Text("Password Reset Required"),
    //         ],
    //       ),
    //     ),
    //   ),
    //   duration: Duration(seconds: 5),
    //   onDismiss: () {
    //     print(
    //         "the toast dismiss"); // the method will be called on toast dismiss.
    //   },
    // );
    //   Toast.show(
    //       "Toast plugin app", NavigationService.navigatorKey.currentState.context,
    //       duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    //   // _toast.showToast(
    //   //   child: Builder(
    //   //     builder: (
    //   //       context,
    //   //     ) {
    //   //       _toast.init(context);
    //   //       return Text("HELLO");
    //   //     },
    //   //   ),
    //   //   gravity: ToastGravity.BOTTOM,
    //   //   toastDuration: Duration(seconds: 2),
    //   // );
    // }
  }
}
