import 'package:flutter/material.dart';

class AppConstant {
  AppConstant._();

  static final AppConstant instance = AppConstant._();

  static const String appName = 'Vodth';

  static const Locale fallbackLocale = Locale('en');

  static const supportedLocales = [Locale('en'), Locale('km')];
}
