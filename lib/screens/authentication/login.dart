import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soteriax/screens/authentication/userLogins/headlifeguard_login.dart';
import 'package:soteriax/screens/authentication/userLogins/lifeguard_login.dart';
import 'package:soteriax/services/auth_services.dart';

class Login extends StatefulWidget {

  @override
  _LoginState createState() => _LoginState();

}

class _LoginState extends State<Login> {

  final _formkey=GlobalKey<FormState>();
  bool loading=false;

  String email='';
  String password='';
  String error='';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange.shade900,
          elevation: 0,
          bottom: const TabBar(
              tabs: [
                Tab(text: "Lifeguard Login" ),
                Tab(text: "Head Lifeguard Login",),
              ],
          ),
        ),
        body: const TabBarView(
          children: [
            LifeguardLogin(),
            HeadLifeguardLogin(),
          ]
        )
      ),
    );
  }
}
