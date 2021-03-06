import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soteriax/services/auth_services.dart';

class ForgotPassword extends StatefulWidget {

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formkey=GlobalKey<FormState>();


  String email='';
  String error='';

  @override
  Widget build(BuildContext context) {
    //provider to listen for notifiers on authServices
    final _auth = Provider.of<AuthService>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade900,
        elevation: 0,
      ),
      body: SafeArea(
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
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20,30,10,10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 30,),
                      Text("Forgot Password", style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: Colors.white),),
                      SizedBox(height: 20,),
                      Text("Reset your password", style: TextStyle(fontSize: 20, color: Colors.white),),
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
                            SizedBox(height: 60,),
                            TextFormField(
                              decoration: InputDecoration(
                                  hintText: "Email",
                                  prefixIcon: Icon(Icons.mail),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )
                              ),
                              validator: (val)=>val==''? 'Please type in your email' : null,
                              onChanged: (val){
                                email=val;
                              },
                            ),
                            SizedBox(height: 30,),
                            MaterialButton(
                              onPressed: () async{
                                if(_formkey.currentState!.validate()){
                                  try {
                                    await _auth.requestResetPassword(email);
                                  } catch(e){
                                    print(e);
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
                                "Request Reset",
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white),
                              ),
                            ),
                            SizedBox(height: 30,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Request link will be sent to your email.\n Please click the link and reset your\n password",
                                  style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold,),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                            SizedBox(height: 10,),
                            if(_auth.fPwdMessage!="")
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5 ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                ),
                                child: ListTile(
                                  title: Text(_auth.fPwdMessage, style: TextStyle(color: Colors.red[900], fontSize: 14), ),
                                  leading: Icon(Icons.error, color: Colors.red[900],),
                                  trailing: IconButton(
                                    icon: Icon(Icons.close),
                                    onPressed: (){
                                      _auth.setFPwdMessage("");
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
      ),
    );
  }
}

