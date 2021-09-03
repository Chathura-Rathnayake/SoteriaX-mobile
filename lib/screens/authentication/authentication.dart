import 'package:flutter/material.dart';
import 'package:soteriax/screens/authentication/forgot_password.dart';
import 'package:soteriax/screens/authentication/login.dart';

class AuthenticationState extends StatefulWidget {
  const AuthenticationState({Key? key}) : super(key: key);

  @override
  _AuthenticationStateState createState() => _AuthenticationStateState();
}

class _AuthenticationStateState extends State<AuthenticationState> {

  bool toggle=false;

  void toggleBWScreens(){
    setState(() {
      toggle=!toggle;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(!toggle){
      return Login();
    }else{
      return ForgotPassword();
    }
  }
}
