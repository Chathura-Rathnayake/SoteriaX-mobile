import 'package:flutter/material.dart';
import 'package:soteriax/screens/custom_widgets/operation_btn.dart';
import 'package:soteriax/screens/home/emergency_call.dart';
import 'package:soteriax/screens/shared/timeline.dart';

class ViewOperation extends StatefulWidget {
  const ViewOperation({Key? key}) : super(key: key);

  @override
  _ViewOperationState createState() => _ViewOperationState();
}

class _ViewOperationState extends State<ViewOperation> {
  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> _scaffoldKey=GlobalKey<ScaffoldState>();
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: ProcessTimelinePage(),
      ),
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: (){Navigator.pop(context);},),
        title: Center(child: Text("View Operation" ,style: TextStyle(fontWeight: FontWeight.bold),)),
        backgroundColor: Colors.orange[800],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                color: Colors.orange[800],
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5),
                  child: MaterialButton(
                    onPressed: (){
                      _scaffoldKey.currentState!.openDrawer();
                    },
                    child: Row(
                      children: [
                        Icon(Icons.arrow_back_ios),
                        Text("Mission Progress", style: TextStyle(fontWeight: FontWeight.bold),)
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                height: 20,
                color: Colors.redAccent.shade700,
              ),
              Container(
                child: Row(
                  children: [
                    SizedBox(width: 30,),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                          child: Text("CURRENT STATUS: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                          child: Text("Reached Victim", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
                        )
                      ],
                    ),
                    SizedBox(width: 50,),
                    Image(image: AssetImage("assets/icons/drown_icon.png"), width: 60, height: 60,)
                  ],
                ),
              ),
              Container(
                color: Colors.grey,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text("Live", style: TextStyle(fontWeight: FontWeight.bold),),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height*0.30,
                color: Colors.black,
              ),
              OperationBtn(btnText: "CONTACT EMERGENCY\nSERVICES", btnImage: "alarm_bulb_icon", height: 100, onClicked: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>EmergencyCall()));
              },),
              SizedBox(height: 20,),
              Container(
                padding: EdgeInsets.only(left: 50),
                alignment: Alignment.centerLeft ,
                child: Text("Mission details: ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)),
              SizedBox(height: 10,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text("Start Time: 01:32 PM"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text("Drone Pilot: Susantha perera"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text("Mobile Handler: Amal Dassanayake"),
                  ),
                ],
              )
            ],
          ),

        ),
      ),
    );
  }
}
