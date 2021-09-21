
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
      drawer: Drawer(child: DisplayTimeline()),
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
                            title: ChartTitle(text: "Timing in training operation steps"),
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
                          Row(
                            children: [
                              Text("Assignment Id: ${assignment.id}",
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                overflow: TextOverflow.clip,
                              ),

                            ],
                          ),
                          SizedBox(height: 20,),
                          Text("Title: ${assignment.get('title')}",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),SizedBox(height: 20,),
                          Text("Summary: ${assignment.get('summary')}",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 20,),
                          Text("Drone Pilot: ${assignment.get('participants')['dronePilotName']}",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 20,),
                          Text("Package Handler: ${assignment.get('participants')['mobileHandelerName']}",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 20,),
                          Text("Swimmer: ${assignment.get('participants')['swimmerName']}",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 20,),
                          Text("Sea condition: ${assignment.get('seaCondition')}",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 20,),
                          Text("Date: ${assignment.get('date')}",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 20,),
                          Text("Start time: ${assignment.get('startTime')}",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
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


