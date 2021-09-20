import 'package:flutter/material.dart';
import 'package:soteriax/database/current_assignment_database_services.dart';
import 'package:soteriax/screens/custom_widgets/list_widgets/lists/suggestion_list.dart';
import 'package:soteriax/screens/custom_widgets/list_widgets/tiles/current_assignment_item.dart';

class ViewSuggestions extends StatefulWidget {
  const ViewSuggestions({Key? key}) : super(key: key);

  @override
  _ViewSuggestionsState createState() => _ViewSuggestionsState();
}

class _ViewSuggestionsState extends State<ViewSuggestions> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[800],
        title: Text("All Help Requests"),
      ),
      body: Container(
        child: ViewSuggestionsList(),
      ),
    );
  }
}
