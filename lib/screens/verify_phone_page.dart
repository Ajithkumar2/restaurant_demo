import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:restaurant_demo/utlis/constants.dart';

class VerifyPhone extends StatefulWidget {
  @override
  _verifyState createState() => _verifyState();
}

class _verifyState extends State<VerifyPhone> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController otpCode = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  OutlineInputBorder border = const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black54, width: 3.0));

  bool isLoading = false;
  String verificationId = "";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Verify OTP"),
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.blue),
      ),
      body: Center(
        child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: size.width * 0.8,
                  child: TextFormField(
                      keyboardType: TextInputType.phone,
                      controller: phoneNumber,
                      decoration: InputDecoration(
                        labelText: "Enter Phone",
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 10.0),
                        border: border,
                      )),
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                !isLoading
                    ? SizedBox(
                        width: size.width * 0.8,
                        child: OutlinedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                isLoading = true;
                              });
                              await phoneSignIn(phoneNumber: phoneNumber.text);
                              // Navigator.pushNamedAndRemoveUntil(context, Constants.homeNavigate, (route) => false);
                            }
                          },
                          child: const Text("Send OTP"),
                          style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Constants.kPrimaryColor),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Constants.kBlackColor),
                              side: MaterialStateProperty.all<BorderSide>(
                                  BorderSide.none)),
                        ),
                      )
                    : const CircularProgressIndicator(),
                SizedBox(
                  height: size.height * 0.01,
                ),
                SizedBox(
                  width: size.width * 0.8,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: otpCode,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Enter Otp",
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 10.0),
                      border: border,
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(bottom: size.height * 0.05)),
                SizedBox(
                  width: size.width * 0.8,
                  child: OutlinedButton(
                      onPressed: () {
                        PhoneAuthCredential credential =
                            PhoneAuthProvider.credential(
                                verificationId: verificationId,
                                smsCode: otpCode.text.trim());
                        _onVerificationCompleted(credential);
                      },
                      child: const Text("Verify OTP"),
                      style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(
                              Constants.kPrimaryColor),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Constants.kBlackColor),
                          side: MaterialStateProperty.all<BorderSide>(
                              BorderSide.none))),
                ),
              ],
            )),
      ),
    );
  }

  Future<void> phoneSignIn({required String phoneNumber}) async {
    await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: _onVerificationCompleted,
        verificationFailed: _onVerificationFailed,
        codeSent: _onCodeSent,
        codeAutoRetrievalTimeout: _onCodeTimeout);
  }

  void showMessage(String errorMessage) {
    showDialog(
        context: context,
        builder: (BuildContext builderContext) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(errorMessage),
            actions: [
              TextButton(
                child: Text("Ok"),
                onPressed: () async {
                  Navigator.of(builderContext).pop();
                },
              )
            ],
          );
        }).then((value) {
      setState(() {
        isLoading = false;
      });
    });
  }

  _onVerificationCompleted(PhoneAuthCredential authCredential) async {
    print("verification completed ${authCredential.smsCode}");
    try {
      await _auth.signInWithCredential(authCredential);

      Navigator.pushNamedAndRemoveUntil(
          context, Constants.homeNavigate, (route) => false);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'provider-already-linked') {
        await _auth.signInWithCredential(authCredential);
      }
      print("otp verification failed...$e");
    }
  }

  signIn(verificationId, smsCode) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: smsCode);
    FirebaseAuth.instance.signInWithCredential(credential);
  }

  _onVerificationFailed(FirebaseAuthException exception) {
    if (exception.code == 'invalid-phone-number') {
      showMessage("The phone number entered is invalid!");
    }
  }

  _onCodeSent(String verificationId, int? forceResendingToken) {
    this.verificationId = verificationId;
    // ignore: avoid_print
    print(forceResendingToken);
    print("code sent");
    setState(() {
      isLoading = false;
    });
  }

  _onCodeTimeout(String timeout) {
    return null;
  }
}
