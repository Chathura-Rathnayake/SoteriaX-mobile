import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DropRTDrawer extends StatefulWidget {
  DropRTDrawer({this.title, this.type});
  String? title='';
  int? type;

  @override
  _DropRTDrawerState createState() => _DropRTDrawerState();
}

class _DropRTDrawerState extends State<DropRTDrawer> {

  int? dropVal;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        child: Column(
          children: [
            Container(
              color: Colors.orange.shade600,
              height: 80,
              padding: EdgeInsets.only(top: 40),
              width: double.infinity,
              child: Text("Drop Package", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16), ),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: Row(
                children: [
                  Icon(CupertinoIcons.arrowtriangle_right_fill, color: Colors.lightGreen[100],),
                  SizedBox(width: 20,),
                  Icon(CupertinoIcons.arrowtriangle_right_fill, color: Colors.lightGreen[300], size: 30,),
                  SizedBox(width: 20,),
                  Icon(CupertinoIcons.arrowtriangle_right_fill, color: Colors.lightGreen[600], size: 40,),
                  SizedBox(width: 20,),
                  Text("Drop", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.lightGreen[900]),),
                ],
              ),
            ),
            Slider(
              min: 100,
              max: 900,
              divisions: 8,
              activeColor: Colors.lightGreen[dropVal??100],
              inactiveColor: Colors.lightGreen,
              value: (dropVal ?? 100).toDouble(),
              onChanged: (val){
                setState(() {
                  dropVal=val.round();
                  print(dropVal);
                });
              }
            ),
            SizedBox(height: 20,),
            if(dropVal==900)
              RaisedButton.icon(
                onPressed: (){},
                color: Colors.lightGreen[900],
                icon: Icon(Icons.arrow_drop_down, size: 30, color: Colors.white,),
                label: Text("DROP", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),)
              ),
            SizedBox(height: 20,),
            MaterialButton(
                child: Text("BACK", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
                onPressed: (){
                  Navigator.pop(context);
                },
                minWidth: 125,
                color: Colors.red[900],
            ),
          ],
        ),
      ),
    );
  }
}
