import 'package:flutter/material.dart';

class Error_Page extends StatelessWidget {
  const Error_Page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
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
              IconButton(onPressed: (){}, icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 40,),),
              Padding(
                padding: const EdgeInsets.fromLTRB(20,30,10,10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 30,),
                    Text("Oopss...", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),),
                    SizedBox(height: 20,),
                    Text("Seems like something went wrong", style: TextStyle(fontSize: 20, color: Colors.white),),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 0,horizontal: 40),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topRight: Radius.circular(50),),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: 30,),
                        ],
                      ),
                    ),
                  )
              ),
            ],
          ),
        ),
      ),
    );;
  }
}
