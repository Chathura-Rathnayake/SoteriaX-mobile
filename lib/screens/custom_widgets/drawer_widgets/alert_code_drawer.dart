import 'package:flutter/material.dart';
import 'package:soteriax/screens/custom_widgets/list_widgets/tiles/code_tile.dart';

class AlertCodeDrawer extends StatefulWidget {
  const AlertCodeDrawer({Key? key}) : super(key: key);

  @override
  _AlertCodeDrawerState createState() => _AlertCodeDrawerState();
}

class _AlertCodeDrawerState extends State<AlertCodeDrawer> {
  String? searchCode='';
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                color: Colors.orange.shade600,
                height: 80,
                padding: EdgeInsets.only(top: 30, left: 5),
                width: double.infinity,
                child: Row(
                  children: [
                    IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.keyboard_arrow_left, color: Colors.white,)),
                    SizedBox(width: 30,),
                    Text("Send Coded Alerts", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16), ),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1.0),
                child:Container(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: TextFormField(
                            decoration: InputDecoration(
                                hintText: "Search Codes...",
                                prefixIcon: Icon(Icons.search),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                )
                            ),
                            validator: (val)=>val==''? 'Please type in your email' : null,
                            onChanged: (val){
                              searchCode=val;
                            },
                          ),
                        ),
                        CodeTile(codeName: "DRONE FAILURE", code: "305", subTitle: "Drone has failed",),
                        CodeTile(codeName: "TECH FAILURE", code: "401", subTitle: "Technical problem",),
                        CodeTile(codeName: "LOW BATTERY", code: "208", subTitle: "Low Drone Battery Power",),
                        CodeTile(codeName: "DROP PROBLEM", code: "002", subTitle: "Dropping machanism failed",),
                      ]
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
