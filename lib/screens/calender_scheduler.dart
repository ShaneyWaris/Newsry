import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../Constants.dart';

class MyCalender extends StatefulWidget {

  @override
  _MyCalenderState createState() => _MyCalenderState();
}

class _MyCalenderState extends State<MyCalender> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Schedule your mess attendence!",
          style: Constants.boldHeading,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back, color: Colors.black,),
          onPressed: () {
            Navigator.pop(context);
            },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SfCalendar(
            view: CalendarView.month,
            headerStyle: CalendarHeaderStyle(
                textStyle: TextStyle(color: Colors.black, fontSize: 20),
                textAlign: TextAlign.center,
                backgroundColor: Colors.grey),
            ),
          ),
        ),
      );
  }
}
