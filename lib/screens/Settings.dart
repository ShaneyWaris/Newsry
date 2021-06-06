import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  List languages = [
    'English',
    'Hindi',
    'Marathi'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
        ),
      ),
      body: ListView(children: [
        Form(
          // key: _one,
          child: Column(
            children: [
              // TextFormField(
              //   decoration: InputDecoration(
              //       prefixIcon: Icon(
              //         Icons.email,
              //       ),
              //       focusColor: Color(0xFFF2F2F2),
              //       fillColor: Colors.grey,
              //       border: OutlineInputBorder(),
              //       labelText: "Email",
              //       contentPadding: EdgeInsets.symmetric(
              //         horizontal: 24.0,
              //         vertical: 20.0,
              //       )),
              // ),
              // DropdownButton(
              //   value: languages,
              //   onChanged: (newValue) {},
              //   hint: Text("select text"),
              //   items: languages.map((valueItem) {
              //     return DropdownMenuItem(
              //       child: Text(valueItem),
              //       value: valueItem,
              //     );
              //   }).toList(),
              // )
            ],
          ),
        )
      ]),
    );
    ;
  }
}
