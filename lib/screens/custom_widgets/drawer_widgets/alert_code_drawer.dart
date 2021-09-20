import 'package:flutter/material.dart';
import 'package:soteriax/screens/custom_widgets/list_widgets/tiles/code_tile.dart';

class AlertCodeDrawer extends StatefulWidget {
  AlertCodeDrawer({required this.operationId, required this.operationType});
  final String operationType;
  final String operationId;

  @override
  _AlertCodeDrawerState createState() => _AlertCodeDrawerState();
}

class _AlertCodeDrawerState extends State<AlertCodeDrawer> {
  String? searchCode = '';
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
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.keyboard_arrow_left,
                          color: Colors.white,
                        )),
                    SizedBox(
                      width: 30,
                    ),
                    Text(
                      "Send Coded Alerts",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1.0),
                child: Container(
                  child: Column(children: [
                    CodeTile(
                        codeName: "DRONE FAILURE",
                        code: "001",
                        subTitle: "Drone has failed",
                        operationID: widget.operationId,
                        endpoint: "0",
                        operationType: widget.operationType,),
                    CodeTile(
                        codeName: "TECH FAILURE",
                        code: "002",
                        subTitle: "Technical problem",
                        operationID: widget.operationId,
                        endpoint: "0",
                        operationType: widget.operationType),
                    CodeTile(
                        codeName: "LOW BATTERY",
                        code: "003",
                        subTitle: "Low Drone Battery Power",
                        operationID: widget.operationId,
                        endpoint: "0",
                        operationType: widget.operationType),
                    CodeTile(
                        codeName: "DROP PROBLEM",
                        code: "004",
                        subTitle: "Dropping machanism failed",
                        operationID: widget.operationId,
                        endpoint: "0",
                        operationType: widget.operationType),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
