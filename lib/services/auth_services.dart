import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:soteriax/models/lifeguard.dart';

class AuthService with ChangeNotifier{

  bool _isLoading=false;
  String _errorMessage="";
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  void setLoading(val){
    _isLoading=val;
    notifyListeners();
  }

  void setMessage(message){
    _errorMessage=message;
    notifyListeners();
  }

  final FirebaseAuth _auth=FirebaseAuth.instance;

  Sys_user? _Sys_UserFromFirebaseUser(User? user){
    if(user==null){
      return null;
    }else{
      return Sys_user(uid: user.uid, email: user.email);
    }
  }

  Future signInWithEmailAndPassword(String email, String password) async{
    setLoading(true);
    try{
      UserCredential result=await _auth.signInWithEmailAndPassword(email: email, password: password);
      setLoading(false);
      return _Sys_UserFromFirebaseUser(result.user);
    }on SocketException{
      setLoading(false);
      setMessage("No internet, please check your internet connection");
    }
    on FirebaseAuthException catch(e){
      setLoading(false);
      setMessage(e.message);
    }
    notifyListeners();
  }

  Future<void> signOut() async{
    try{
      return await _auth.signOut();
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  Future requestResetPassword(String email) async{
    setLoading(true);
    try{
      await _auth.sendPasswordResetEmail(email: email);
      setLoading(false);
    }on SocketException{
      setLoading(false);
      setMessage("No internet, Please check your internet connection");
    }on FirebaseAuthException catch(e){
      setLoading(false);
      setMessage(e.message);
    }
    notifyListeners();
  }



  //stream for user auth state changes
  Stream<Sys_user?> get authStateChanges => _auth.idTokenChanges().map((user) => _Sys_UserFromFirebaseUser(user));


}