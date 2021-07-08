import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soteriax/screens/login.dart';

void main() {
  runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Login(),
      ),
  );
}

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 30),
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              colors: [
                Colors.orange.shade900,
                Colors.orange.shade700,
                Colors.orange.shade500
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 80,),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Login",
                      style: TextStyle(fontSize: 40, color: Colors.white,),
                    ),
                    SizedBox(height: 10,),
                    Text("Welcome Back",
                      style: TextStyle(fontSize: 18, color: Colors.white,),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 10,),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 60,),
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [BoxShadow(
                                color: Color.fromRGBO(225, 95, 27, 3),
                                blurRadius: 20,
                                offset: Offset(0,10)
                              )],
                            ),
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: "Email",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [BoxShadow(
                                  color: Color.fromRGBO(225, 95, 27, 3),
                                  blurRadius: 20,
                                  offset: Offset(0,10)
                              )],
                            ),
                            child: TextField(
                              decoration: InputDecoration(
                                  hintText: "Password",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none
                              ),
                            ),
                          ),
                          SizedBox(height: 40,),
                          Text("Forgot Password?",
                          style: TextStyle(color: Colors.grey,),),
                          SizedBox(height: 40,),
                          Container(
                            height: 50,
                            margin: EdgeInsets.symmetric(horizontal: 50),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.orange.shade900,
                              ),
                            child: Center(
                              child: Text("Login",
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), ),
                            ),
                          ),
                          SizedBox(height: 30,),
                          Text("Continue with Social Media",
                            style: TextStyle(color: Colors.grey,),),
                          SizedBox(height: 30,),
                          Row(
                            children: <Widget>[
                              Expanded(
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Colors.blue,
                                    ),
                                    child: Center(
                                      child: Text("Facebook",
                                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), ),
                                    ),
                                  )
                              ),
                              SizedBox(width: 30,),
                              Expanded(
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Colors.black,
                                    ),
                                    child: Center(
                                      child: Text("Github",
                                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), ),
                                    ),
                                  )
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ),
    );
  }
}


