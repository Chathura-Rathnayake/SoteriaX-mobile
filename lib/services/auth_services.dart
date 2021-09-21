import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:soteriax/database/user_database_services.dart';
import 'package:soteriax/models/lifeguard.dart';

class AuthService with ChangeNotifier {
  bool _isLoading = false;
  String _errorMessageL = "";
  String _errorMessageHL = "";
  String _forgotPwdErrorMessage = "";
  bool get isLoading => _isLoading;
  String get errorMessageL => _errorMessageL;
  String get errorMessageHL => _errorMessageHL;
  String get fPwdMessage => _forgotPwdErrorMessage;

  void setLoading(val) {
    _isLoading = val;
    notifyListeners();
  }

  void setMessageL(message) {
    _errorMessageL = message;
    notifyListeners();
  }

  void setMessageHL(message) {
    _errorMessageHL = message;
    notifyListeners();
  }

  void setFPwdMessage(message) {
    _forgotPwdErrorMessage = message;
    notifyListeners();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Sys_user? _Sys_UserFromFirebaseUser(User? user) {
    if (user == null) {
      return null;
    } else {
      return Sys_user(uid: user.uid, email: user.email);
    }
  }

  Future signInWithEmailAndPassword(
      String email, String password, String userFlag) async {
    setLoading(true);
    if (userFlag == "l") {
      bool isHL = await UserDatabaseService().checkLifeguard(email);
      if (!isHL) {
        setMessageL("The entered email is not registered as a lifeguard");
        setLoading(false);
        return;
      }
    } else {
      bool isL = await UserDatabaseService().checkHeadLifeguard(email);
      if (!isL) {
        setMessageHL("The entered email is not registered as a Head lifeguard");
        setLoading(false);
        return;
      }
    }
    try{
      UserCredential result=await _auth.signInWithEmailAndPassword(email: email.trim(), password: password.trim());
      if(userFlag=="l"){
        await UserDatabaseService(userId: result.user!.uid).getLifeguardData();
      } else {
        await UserDatabaseService(userId: result.user!.uid)
            .getHeadLifeguardData();
      }
      setLoading(false);
    } on SocketException {
      setLoading(false);
      if (userFlag == "l") {
        setMessageL("No internet, please check your internet connection");
      } else {
        setMessageHL("No internet, please check your internet connection");
      }
    } on FirebaseAuthException catch (e) {
      setLoading(false);
      if (userFlag == "l") {
        setMessageL(e.message);
      } else {
        setMessageHL(e.message);
      }
    }
    notifyListeners();
  }

  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future requestResetPassword(String email) async {
    setLoading(true);
    try {
      await _auth.sendPasswordResetEmail(email: email);
      setLoading(false);
    } on SocketException {
      setLoading(false);
      setFPwdMessage("No internet, Please check your internet connection");
    } on FirebaseAuthException catch (e) {
      setLoading(false);
      setFPwdMessage(e.message);
    }
    notifyListeners();
  }

  //stream for user auth state changes
  Stream<Sys_user?> get authStateChanges =>
      _auth.idTokenChanges().map((user) => _Sys_UserFromFirebaseUser(user));
}
