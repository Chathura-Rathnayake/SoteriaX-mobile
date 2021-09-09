import 'package:flutter/material.dart';
import 'package:soteriax/database/help_request_database.dart';


class HelpRequests extends StatefulWidget {
  const HelpRequests({Key? key}) : super(key: key);

  @override
  _HelpRequestsState createState() => _HelpRequestsState();
}

class _HelpRequestsState extends State<HelpRequests> {
  final _formKey=GlobalKey<FormState>();
  String? name;
  String? age;
  String? formType;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade800,
        title: Center(child: Text("Help Request")),
      ),
      body: Container(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20,),
                  Text("Help Request Form", style: TextStyle(fontSize: 20), ),
                  SizedBox(height: 30,),
                  Row(
                    children: [
                      Text("Select a form type"),
                      SizedBox(width: 20,),
                      DropdownButton<String>(
                        value: formType,
                        icon: const Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        style: const TextStyle(
                            color: Colors.orange
                        ),
                        underline: Container(
                          height: 2,
                          color: Colors.orange,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            formType = newValue!;
                          });
                        },
                        items: <String>['Help Request', 'Suggestion', 'Complaints']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        })
                            .toList(),
                      ),
                    ],
                  ),
                  Container(
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: "Name",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (val) => val=="" ? 'Please enter name' : null,
                          onChanged: (val){
                            name=val;
                          },
                        ),
                        SizedBox(height: 30,),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: "Age",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (val) => val=="" ? 'Please enter age' : null,
                          onChanged: (val){
                            age=val;
                          },
                        ),
                        MaterialButton(
                            onPressed: (){
                              if(_formKey.currentState!.validate()){
                                //call firebase to add record
                                print('button pressed: $name $age');
                                HelpRequestDB().addRequest(name!, age!);
                              }else{
                                print('not validated');
                              }
                            },
                            color: Colors.orange,
                            child: Text('Button'),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
