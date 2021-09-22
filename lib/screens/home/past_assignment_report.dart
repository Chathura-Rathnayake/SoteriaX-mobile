
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:soteriax/database/past_assignments_database_services.dart';
import 'package:soteriax/screens/shared/display_timeline.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
class PastAssignmentReport extends StatefulWidget {
  PastAssignmentReport({required this.assignmentId});

  String assignmentId;

  @override
  _PastAssignmentReportState createState() => _PastAssignmentReportState();
}


class _PastAssignmentReportState extends State<PastAssignmentReport> {

  late List<GDPdata> _chartData;
  late TooltipBehavior _tooltipBehaviour;

  @override
  void initState() {
    _tooltipBehaviour=TooltipBehavior(enable: true);
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> _scaffoldKey=GlobalKey<ScaffoldState>();
    return Scaffold(
      key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Assignment Details"),
          backgroundColor: Colors.orange.shade700,
          elevation: 0,
        ),
      body: FutureBuilder(
        future: PastAssignmentDB().getPastAssignment(widget.assignmentId),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot?> snapshot){
          switch(snapshot.connectionState){
            case ConnectionState.waiting:
              return CircularProgressIndicator();
            default:
              if(snapshot.hasError){
                return Container(child: Text("Error getting assignment: ${snapshot.error}"),);
              }else if(snapshot.hasData){
                if(snapshot.data==null){
                  return Container(child: Text("No data retrieved"),);
                }else{
                  var assignment=snapshot.data!;
                  _chartData = getChartData(assignment);
                  _tooltipBehaviour=TooltipBehavior(enable: true);
                  return SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SfCircularChart(
                            title: ChartTitle(text: "Timing in training operation steps", textStyle: TextStyle(fontWeight: FontWeight.bold)),
                            legend: Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
                            tooltipBehavior: _tooltipBehaviour,
                            series: <CircularSeries>[
                              PieSeries<GDPdata,String>(
                                dataSource: _chartData,
                                xValueMapper: (GDPdata data,_) =>data.continent,
                                yValueMapper: (GDPdata data,_) => data.gdp,
                                //dataLabelSettings: DataLabelSettings(isVisible:true),
                                enableTooltip: true,
                              )
                            ],

                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            child: TextFormField(
                              readOnly: true,
                              initialValue: "${assignment.id}",
                              decoration: InputDecoration(
                                icon: Icon(Icons.code,
                                    size: 30, color: Colors.orange.shade900),
                                labelText: 'Assignment Id',
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            child: TextFormField(
                              readOnly: true,
                              initialValue: "${assignment.get('title')}",
                              decoration: InputDecoration(
                                icon: Icon(Icons.title,
                                    size: 30, color: Colors.orange.shade900),
                                labelText: 'Title',
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            child: TextFormField(
                              readOnly: true,
                              initialValue: "${assignment.get('summary')}",
                              decoration: InputDecoration(
                                icon: Icon(Icons.description,
                                    size: 30, color: Colors.orange.shade900),
                                labelText: 'Summary',
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            child: TextFormField(
                              readOnly: true,
                              initialValue: "${assignment.get('participants')['dronePilotName']}",
                              decoration: InputDecoration(
                                icon: Icon(Icons.flight_takeoff,
                                    size: 30, color: Colors.orange.shade900),
                                labelText: 'Drone Pilot',
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            child: TextFormField(
                              readOnly: true,
                              initialValue: "${assignment.get('participants')['mobileHandelerName']}",
                              decoration: InputDecoration(
                                icon: Icon(Icons.send_to_mobile,
                                    size: 30, color: Colors.orange.shade900),
                                labelText: 'Package Handler',
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            child: TextFormField(
                              readOnly: true,
                              initialValue: "${assignment.get('participants')['swimmerName']}",
                              decoration: InputDecoration(
                                icon: Icon(FontAwesomeIcons.swimmer,
                                    size: 30, color: Colors.orange.shade900),
                                labelText: 'Swimmer',
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            child: TextFormField(
                              readOnly: true,
                              initialValue: "${assignment.get('seaCondition')}",
                              decoration: InputDecoration(
                                icon: Icon(FontAwesomeIcons.cloud,
                                    size: 30, color: Colors.orange.shade900),
                                labelText: 'Sea condition',
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            child: TextFormField(
                              readOnly: true,
                              initialValue: "${assignment.get('date')}",
                              decoration: InputDecoration(
                                icon: Icon(Icons.date_range_outlined,
                                    size: 30, color: Colors.orange.shade900),
                                labelText: 'Date',
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            child: TextFormField(
                              readOnly: true,
                              initialValue: "${assignment.get('startTime')}",
                              decoration: InputDecoration(
                                icon: Icon(Icons.timer,
                                    size: 30, color: Colors.orange.shade900),
                                labelText: 'Start Time',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              }else{
                return Container(child: Text("No data retrieved"),);
              }
          }
        },
      ),
    );
  }
  List<GDPdata> getChartData(DocumentSnapshot assignment){
    int first=0;
    if(assignment.get('trainingTimes')[1]!=""){
      first=Timestamp.fromMillisecondsSinceEpoch(assignment.get('trainingTimes')[1]).seconds;
    }
    int second=0;
    if(assignment.get('trainingTimes')[2]!=""){
      second=Timestamp.fromMillisecondsSinceEpoch(assignment.get('trainingTimes')[2]).seconds;
    }
    int third=0;
    if(assignment.get('trainingTimes')[3]!=""){
      third=Timestamp.fromMillisecondsSinceEpoch(assignment.get('trainingTimes')[3]).seconds;
    }
    int fourth=0;
    if(assignment.get('trainingTimes')[4]!=""){
      fourth=Timestamp.fromMillisecondsSinceEpoch(assignment.get('trainingTimes')[4]).seconds;
    }
    // String  first=assignment.get('trainingTimes')[1];
    // String  second=assignment.get('trainingTimes')[2];
    // String  third=assignment.get('trainingTimes')[3];
    // String  fourth=assignment.get('trainingTimes')[4];
    final List<GDPdata> chartData = [
      //GDPdata("Mission initiated", assignment.get('trainingTimes')[0]),
      GDPdata("UAV reached",first),
      GDPdata("Restube droped",second-first),
      GDPdata("Lifeguard reached",third-second),
      GDPdata("Rescue completed",fourth-third),
    ];
    return chartData;
  }
}

class GDPdata{
  GDPdata(this.continent,this.gdp);
  final String continent;
  final int gdp;
}


