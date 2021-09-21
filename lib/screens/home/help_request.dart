import "package:flutter/material.dart";
import 'package:soteriax/database/help_request_database.dart';
import 'package:soteriax/screens/custom_widgets/navigate_button.dart';
import 'package:soteriax/screens/home/view_complaints.dart';
import 'package:soteriax/screens/home/view_helprequests.dart';
import 'package:soteriax/screens/home/view_suggestions.dart';

class helpRequest extends StatefulWidget {
  const helpRequest({Key? key}) : super(key: key);

  @override
  _helpRequestState createState() => _helpRequestState();
}

class _helpRequestState extends State<helpRequest> {
  @override
  final _formKey = GlobalKey<FormState>();
  String? name;
  String? age;
  String? formType;
  String feedbackMsg="";
  bool error=false;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade800,
        title: Center(child: Text("Help")),
      ),
      body: Container(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: SingleChildScrollView(
              child: Column(children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Submit to SoteriaX Team",
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  height: 20,
                ),
                Image(
                  image: AssetImage('assets/icons/soteriax_logo.png'),
                  width: 200,
                  height: 150,
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Text(
                      "Select request type",
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    DropdownButton<String>(
                      value: formType,
                      icon: const Icon(Icons.arrow_downward),
                      iconSize: 24,
                      elevation: 16,
                      style: const TextStyle(color: Colors.black),
                      underline: Container(
                        height: 2,
                        color: Colors.orange,
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          formType = newValue!;
                        });
                      },
                      items: <String>[
                        'Help Request',
                        'Suggestion',
                        'Complaints'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      hintText: "Headline",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                  validator: (value) =>
                      value == '' ? 'Please enter name' : null,
                  onChanged: (value) {
                    name = value;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      hintText: "Message",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                  validator: (value) => value == '' ? 'Please enter age' : null,
                  onChanged: (value) {
                    age = value;
                  },
                  maxLines: 5,
                ),

                SizedBox(
                  height: 20,
                ),
                // TextField(
                //   maxLines: 3,
                //   decoration: InputDecoration(
                //
                //   ),
                // ),
                MaterialButton(
                  onPressed: () async{
                    if (_formKey.currentState!.validate()) {
                      print("Button pressed: $name $age");
                      var didSubmit;
                      didSubmit=await HelpRequestDBServices()
                          .addRequest(name!, age!, formType!);
                      if(didSubmit==true){
                        setState(() {
                          feedbackMsg="Form successfully submitted";
                          error=false;
                        });
                      }else{
                        setState(() {
                          feedbackMsg="Something went wrong";
                          error=true;
                        });
                      }
                    } else {
                      print("Not validated");
                    }
                  },
                  // color: Colors.orange,
                  child: Text(
                    "Submit",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  height: 50,
                  minWidth: double.maxFinite,
                  color: Colors.orange.shade800,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                if(feedbackMsg!="")
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5 ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                    child: ListTile(
                      title: Text(feedbackMsg, style: TextStyle(color: Colors.blue[900], fontSize: 14), ),
                      leading: Icon(error ? Icons.error :Icons.notifications, color: error ? Colors.red[900]: Colors.blue[900],),
                      trailing: IconButton(
                        icon: Icon(Icons.close),
                        onPressed: (){
                          setState(() {
                            feedbackMsg="";
                          });
                        },
                      ),
                    ),
                  ),
                SizedBox(height: 5,),
                NavigationButton(title: "View Suggestions", image: "Help Request", onPressedFunFlag: 4),
                NavigationButton(title: "View Complaints", image: "Complaint", onPressedFunFlag: 5),
                NavigationButton(title: "View Help Requests", image: "Suggestion", onPressedFunFlag: 6),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
