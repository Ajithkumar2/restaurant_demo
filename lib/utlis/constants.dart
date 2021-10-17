import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Constants {
  //colors
  static const kPrimaryColor = Color(0xFFFFFFFF);
  static const kGreyColor = Color(0xFFEEEEEE);
  static const kBlackColor = Color(0xFF000000);
  static const kDarkGreyColor = Color(0xFF9E9E9E);
  static const kDarkBlueColor = Color(0xFF6057FF);
  static const kBorderColor = Color(0xFFEFEFEF);

  //navigate
  static const signInNavigate = '/sign-in';
  static const homeNavigate = '/home';
  static const otpNavigate = '/otp-page';

  static const statusBarColor = SystemUiOverlayStyle(
      statusBarColor: Constants.kPrimaryColor,
      statusBarIconBrightness: Brightness.dark);
}
