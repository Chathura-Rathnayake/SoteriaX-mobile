import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soteriax/services/raspberryPi/light.dart';

class FlashLightDrawer extends StatefulWidget {
  const FlashLightDrawer({Key? key}) : super(key: key);

  @override
  _FlashLightDrawerState createState() => _FlashLightDrawerState();
}

class _FlashLightDrawerState extends State<FlashLightDrawer> {
  LightRPI light = LightRPI();
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
                padding: EdgeInsets.only(top: 40),
                width: double.infinity,
                child: Text(
                  "Flash Light",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: Container(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () {
                        light.RPiLighton();
                      },
                      color: Colors.blue[900],
                      iconSize: 60,
                      icon: Icon(
                        Icons.flashlight_on,
                        size: 60,
                      )),
                  SizedBox(
                    width: 40,
                  ),
                  IconButton(
                      onPressed: () {
                        light.RPiLightoff();
                      },
                      color: Colors.red[900],
                      iconSize: 60,
                      icon: Icon(
                        Icons.flashlight_off,
                        size: 60,
                      )),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Toggle Flash-Light",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              MaterialButton(
                child: Text(
                  "BACK",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                minWidth: 125,
                color: Colors.red[900],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
