import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:fostershare/core/models/data/enums/enums.dart';
import 'package:package_info/package_info.dart';

class AppService {
  PackageInfo _packageInfo;
  PackageInfo get packageInfo => this._packageInfo;
  AppPlatform get platform =>
      Platform.isIOS ? AppPlatform.ios : AppPlatform.android;

  Future<void> init() async {
    await Firebase.initializeApp();
    this._packageInfo = await PackageInfo.fromPlatform();
  }
}
