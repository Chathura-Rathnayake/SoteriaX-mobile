import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soteriax/screens/custom_widgets/drawer_widgets/alert_code_drawer.dart';
import 'package:soteriax/screens/custom_widgets/drawer_widgets/audio_stream_drawer.dart';
import 'package:soteriax/screens/custom_widgets/drawer_widgets/drop_resttube_drawer.dart';
import 'package:soteriax/screens/custom_widgets/drawer_widgets/emmit_audio_drawer.dart';
import 'package:soteriax/screens/custom_widgets/operation_btn.dart';
import 'package:soteriax/screens/home/main_menu.dart';

class LiveOperations extends StatefulWidget {
  const LiveOperations({Key? key}) : super(key: key);

  @override
  _LiveOperationsState createState() => _LiveOperationsState();

}



class _LiveOperationsState extends State<LiveOperations> {
  final GlobalKey<ScaffoldState> _scaffoldKey=GlobalKey<ScaffoldState>();

  int? type;

  @override
  void initState() {
    // TODO: implement initState
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp
    ]);
    super.dispose();
  }
  // final _formkey=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    // Widget dr=DropRTDrawer as Widget;
    void showDrawerWithBtns(){
      _scaffoldKey.currentState!.openEndDrawer();
    }

    void setType(int type){
      setState(() {
        this.type=type;
      });
    }
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: type==2 ? DropRTDrawer() : type==1 ? AudioStreamDrawer() : type==4 ? AlertCodeDrawer() : EmmitAudioDrawer(isEmmitSuccesful: true) ,
        appBar: AppBar(
          leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back)),
          actions: [
            Container(),
            ],
          elevation: 0.0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.orange.shade800,
                    Colors.orange.shade700,
                  ]),
            ),
          ),
        ),
        body: SafeArea(
          child: Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.60,
                color: Colors.black,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      height: 20,
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: Text(
                        "Live",
                        style: TextStyle(color: Colors.black),
                      ),
                    )
                  ],
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(2),
                  width: MediaQuery.of(context).size.width * 0.40,
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        height: 25,
                        width: double.infinity,
                        color: Colors.red[300],
                        child: Text(
                          "Current Status: Reached Victim",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      OperationBtn(btnText: "EMMIT AUDIO", btnImage: "sound_icon", onClicked: showDrawerWithBtns, setType: setType, type: 3,),
                      OperationBtn(btnText: "DROP REST-TUBE", btnImage: "lb_drop_icon", onClicked: showDrawerWithBtns, setType: setType, type: 2,),
                      OperationBtn(btnText: "AUDIO STREAM", btnImage: "mic_icon", onClicked: showDrawerWithBtns, setType: setType, type: 1,),
                      OperationBtn(btnText: "CONTACT HEAD \nLIFEGUARD", btnImage: "alarm_bulb_icon", onClicked: showDrawerWithBtns, setType: setType, type: 4,),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
