import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soteriax/models/lifeguard.dart';
import 'package:soteriax/screens/initialization/error_page.dart';
import 'package:soteriax/screens/initialization/init_loading.dart';
import 'package:soteriax/screens/wrapper.dart';
import 'package:soteriax/services/auth_services.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //default init and error state to false
  bool _initialized=false;
  bool _error=false;

  void initializeFlutterFire() async{
    try{
      //await for firebase to be initalized and set init state to true when it does
      await Firebase.initializeApp();
      setState(() {
        _initialized=true;
      });
    }catch(e){
      setState(() {
        _error=true;
        print(e.toString());
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(_error){
        return MaterialApp(debugShowCheckedModeBanner: false, home: Error_Page());
    }
    if(!_initialized){
      return MaterialApp(debugShowCheckedModeBanner: false, home: LoadingSpinner());
    }

    return MultiProvider(
      providers: [
          ChangeNotifierProvider<AuthService>.value(value: AuthService()),
          StreamProvider<Sys_user?>.value(
          value: AuthService().authStateChanges,
          initialData: null,
          ),
      ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Wrapper()
          )
      );

  }
}







