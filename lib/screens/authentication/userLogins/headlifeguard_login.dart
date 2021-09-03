import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soteriax/screens/initialization/init_loading.dart';
import 'package:soteriax/services/auth_services.dart';

import '../forgot_password.dart';

class HeadLifeguardLogin extends StatefulWidget {
  const HeadLifeguardLogin({Key? key}) : super(key: key);

  @override
  _HeadLifeguardLoginState createState() => _HeadLifeguardLoginState();
}

class _HeadLifeguardLoginState extends State<HeadLifeguardLogin> {
  final _formkey=GlobalKey<FormState>();
  bool loading=false;

  String email='';
  String password='';
  String error='';

  @override
  Widget build(BuildContext context) {
    //provider to listen on authServices
    final _auth = Provider.of<AuthService>(context);
    return loading ? LoadingSpinner() : SafeArea(
      child: Form(
        key: _formkey,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                colors: [
                  Colors.orange.shade900,
                  Colors.orange.shade500,
                  Colors.orange.shade400
                ]
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20,50,10,10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Login", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),),
                    SizedBox(height: 20,),
                    Text("Welcome back", style: TextStyle(fontSize: 20, color: Colors.white),),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 0,horizontal: 40),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topRight: Radius.circular(50),),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: 60),
                          TextFormField(
                            decoration: InputDecoration(
                                hintText: "Email",
                                prefixIcon: Icon(Icons.email),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )
                            ),
                            validator: (val)=>val=='' ? 'Please enter a email' : null,
                            onChanged: (val){
                              email=val;
                            },
                          ),
                          SizedBox(height: 30,),
                          TextFormField(
                            obscureText: true,
                            decoration: InputDecoration(
                                hintText: "Password",
                                prefixIcon: Icon(Icons.vpn_key),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )
                            ),
                            validator: (val)=>val!.length<6 ? 'Enter a password with 6 chars long' : null,
                            onChanged: (val){
                              password=val;
                            },
                          ),
                          SizedBox(height: 30,),
                          MaterialButton(
                            onPressed: () async{
                              if(_formkey.currentState!.validate()){
                                setState(() {
                                  loading=true;
                                });
                                dynamic result=await _auth.signInWithEmailAndPassword(email, password, "hl");
                                if(result==null){
                                  setState(() {
                                    error="Please enter a valid email";
                                    loading=false;
                                  });
                                }
                              }
                            },
                            height: 70,
                            minWidth: double.infinity,
                            color: Colors.orange.shade800,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              "Login",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white),
                            ),
                          ),
                          SizedBox(height: 30,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Forgot Password? ", style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold),),
                              TextButton(
                                  onPressed: (){
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context)=>ForgotPassword())
                                    );
                                  },
                                  child: Text("Click Here", style: TextStyle(color: Colors.orange.shade800, fontSize: 18, fontWeight: FontWeight.bold),)
                              ),
                            ],
                          ),
                          SizedBox(height: 10,),
                          if(_auth.errorMessageHL!="")
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5 ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                              ),
                              child: ListTile(
                                title: Text(_auth.errorMessageHL, style: TextStyle(color: Colors.red[900], fontSize: 14), ),
                                leading: Icon(Icons.error, color: Colors.red[900],),
                                trailing: IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: (){
                                    _auth.setMessageHL("");
                                  },
                                ),
                              ),
                            )
                        ],
                      ),
                    ),
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
