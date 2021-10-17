import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:restaurant_demo/models/cart.dart';
import 'navigation/navigate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  User? user = FirebaseAuth.instance.currentUser;

  runApp(
      ChangeNotifierProvider(create: (context) => Cart(), child: MyApp(user)));
}

class MyApp extends StatefulWidget {
  User? user;

  MyApp(this.user, {Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final check = widget.user;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: check == null ? '/sign-in' : "/home",
      routes: Navigate.routes,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
