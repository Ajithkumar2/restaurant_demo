import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:restaurant_demo/screens/home.dart';
import 'package:restaurant_demo/screens/sign_in_page.dart';
import 'package:restaurant_demo/screens/verify_phone_page.dart';

class Navigate {
  static Map<String, Widget Function(BuildContext)> routes = {
    '/sign-in': (context) => SignInPage(),
    '/home': (context) => const HomePage(),
    '/otp-page': (context) => VerifyPhone(),
  };
}
