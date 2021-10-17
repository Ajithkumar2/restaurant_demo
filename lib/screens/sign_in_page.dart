import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_demo/screens/verify_phone_page.dart';
import 'package:restaurant_demo/service/firebase_service.dart';
import 'package:restaurant_demo/utlis/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // OutlineInputBorder border = OutlineInputBorder(
    //     borderSide: BorderSide(color: Constants.kBorderColor, width: 3.0));
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Constants.kPrimaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 400,
              child: Center(
                child: Image.asset(
                  "assets/images/firebase_logo.png",
                  width: 100,
                  height: 100,
                ),
              ),
            ),
            SizedBox(height: size.height * 0.01),
            GoogleSignIn(),
          ],
        ),
      ),
    );
  }
}

class GoogleSignIn extends StatefulWidget {
  GoogleSignIn({Key? key}) : super(key: key);

  @override
  _GoogleSignInState createState() => _GoogleSignInState();
}

class _GoogleSignInState extends State<GoogleSignIn> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return !isLoading
        ? Column(
            children: [
              SizedBox(
                width: size.width * 0.8,
                height: size.height * 0.07,
                child: ElevatedButton(
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: ClipOval(
                          child: Image.asset(
                            "assets/images/google_logo.png",
                            width: 24,
                            height: 24,
                          ),
                        ),
                      ),
                      const Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Google",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      )
                    ],
                  ),
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    FirebaseService service = FirebaseService();
                    try {
                      await service.signInwithGoogle();
                      Navigator.pushNamedAndRemoveUntil(
                          context, Constants.homeNavigate, (route) => false);
                    } catch (e) {
                      if (e is FirebaseAuthException) {
                        showMessage(e.message!);
                      }
                    }
                    setState(() {
                      isLoading = false;
                    });
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30))),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: size.width * 0.8,
                height: size.height * 0.07,
                child: ElevatedButton(
                  child: Stack(
                    children: const [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Icon(
                          Icons.call,
                          color: Colors.white,
                          size: 24.0,
                        ),
                      ),
                      Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Phone",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ))
                    ],
                  ),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.green),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)))),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => VerifyPhone()));
                  },
                ),
              )
            ],
          )
        : const CircularProgressIndicator();
  }

  void showMessage(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(message),
            actions: [
              TextButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
