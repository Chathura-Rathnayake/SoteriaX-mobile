import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soteriax/models/lifeguard.dart';
import 'package:soteriax/screens/authentication/authentication.dart';
import 'package:soteriax/screens/home/mainMenu.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final user=Provider.of<Sys_user?>(context);
    if(user!=null){
     return MainMenu();
    }else{
      return AuthenticationState();
    }
  }
}
