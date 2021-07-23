import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soteriax/screens/home/live_operation.dart';

class EngageMission extends StatefulWidget {
  const EngageMission({Key? key}) : super(key: key);

  @override
  _EngageMissionState createState() => _EngageMissionState();
}

class _EngageMissionState extends State<EngageMission> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[800],
        title: Text("Engage Mission"),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              SizedBox(height: 40,),
              Image(
                image: AssetImage("assets/icons/try_connection.png"),
                width: 200,
              ),
              SizedBox(height: 30,),
              Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
                        child: Text(
                          "Drone Module Status: ",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Container(
                        color: Colors.green[300],
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                          child: Text(
                            "Live", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
              Container(
                child: Card(
                  margin: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: Image(image: AssetImage("assets/icons/mobile_engagement.png"),),
                      title: Text("No-Engagement"),
                      subtitle: Text("Engagement Status"),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30,),
              MaterialButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>LiveOperations()),);
                },
                color: Colors.orange[800],
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  child: Text("ENGAGE MISSION", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
