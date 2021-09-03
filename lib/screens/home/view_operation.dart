import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soteriax/database/view_operations_database_services.dart';
import 'package:soteriax/screens/custom_widgets/navigate_button.dart';
import 'package:soteriax/screens/custom_widgets/operation_status_tile.dart';
import 'package:soteriax/screens/home/main_menu.dart';
import 'package:soteriax/screens/home/viewOp/no_current_operation.dart';
import 'package:soteriax/screens/home/viewOp/waiting_operation_response.dart';
import 'package:soteriax/screens/shared/timeline.dart';
import 'package:video_player/video_player.dart';

class ViewOperation extends StatefulWidget {
  const ViewOperation({Key? key}) : super(key: key);

  @override
  _ViewOperationState createState() => _ViewOperationState();
}

class _ViewOperationState extends State<ViewOperation> {

  late VideoPlayerController _videoPlayerController;
  late Future<Map?> _currentLiveOp;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentLiveOp=ViewOperationDBServices().getCurrentLiveOp();
    _videoPlayerController=VideoPlayerController.network(
        'https://github.com/husseyhh/soteriaX_videos/raw/main/example_footage/soteriaX_trimmed_2.mp4')
    ..initialize().then((_) {
      _videoPlayerController.play();
      _videoPlayerController.setLooping(true);
      setState(() {

      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> _scaffoldKey=GlobalKey<ScaffoldState>();
    return FutureBuilder<Map?>(
        future: _currentLiveOp,
        builder: (BuildContext context, AsyncSnapshot<Map?> snapshot){
          switch(snapshot.connectionState){
            case ConnectionState.waiting:
              return WaitingOpResponse();
            default:
              if(snapshot.hasError){
                return Scaffold(
                  appBar: AppBar(backgroundColor: Colors.orange[800], title: Text("View Operation"),),
                  body: Container(child: Center(child: Text("Error: ${snapshot.error}"))));
              }else{
                if(snapshot.data==null){
                  return NoCurrentOP();
                }else{
                  print("hera");
                  print(snapshot.data!['currentOp'].data().toString());
                  return Scaffold(
                    key: _scaffoldKey,
                    drawer: Drawer(
                      child: ProcessTimelinePage(operationId: snapshot.data!["currentOp"].id, operationFlag: snapshot.data!['opFlag']),
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
                          mainAxisAlignment: MainAxisAlignment.center,
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
                            OperationStatusTile(operationId: snapshot.data!["currentOp"].id),
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
                              child: Center(
                                child: _videoPlayerController.value.isInitialized ? AspectRatio(
                                  aspectRatio: _videoPlayerController.value.aspectRatio,
                                  child: VideoPlayer(_videoPlayerController),)
                                    : Container(
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                              ),
                            ),
                            StreamBuilder<DocumentSnapshot?>(
                                stream: snapshot.data!["opFlag"]=="live" ? ViewOperationDBServices(operationId: snapshot.data!["currentOp"].id).currentLiveOpdata : ViewOperationDBServices(operationId: snapshot.data!["currentOp"].id).currentTrainingOpdata,
                                builder: (context, snap){
                                  if(snap.hasData){
                                    if (snap.data!.get("operationStatus")!="live") {
                                      return Container(
                                        padding: EdgeInsets.only(top: 5),
                                        child: Column(
                                          children: [
                                            Text(
                                              "Operation has ended",
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(fontSize: 20, color: Colors.red, fontWeight: FontWeight.bold),
                                            ),
                                            MaterialButton(
                                              color: Colors.red.shade900,
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => MainMenu()),
                                                );
                                              },
                                              child: Text(
                                                "Return Main Menu",
                                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    }else{
                                      return Container();//empty container
                                    }
                                  }else{
                                    return Container();//empty container
                                  }
                                }
                            ),
                            NavigationButton(image: "alarm_bulb_icon", title: "CONTACT EMERGENCY SERVICES", onPressedFunFlag: 3,),
                            SizedBox(height: 20,),
                            Container(
                                padding: EdgeInsets.only(left: 50),
                                alignment: Alignment.centerLeft ,
                                child: Text("Mission details: ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)
                            ),
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
          }
        }
      );
  }
}
