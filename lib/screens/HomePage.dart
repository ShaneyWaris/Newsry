import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:food_management_system/Constants.dart';
import 'package:food_management_system/Model/newsInfo.dart';
import 'package:food_management_system/NewsAPI_Service/api_manager.dart';
import 'package:food_management_system/Widgets/bottom_tabs.dart';
import 'package:food_management_system/screens/Settings.dart';
import 'package:food_management_system/screens/calender_scheduler.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
class HomePage extends StatefulWidget {
  User? user;

  HomePage({this.user});

  @override
  _HomePageState createState() => _HomePageState(user);
}

class _HomePageState extends State<HomePage> {
  User? user;
  Future<NewsModel>? _newsModel;

  @override
  void initState() {
    _newsModel = API_Manager().getNews();
    super.initState();
  }

  _HomePageState(this.user);

  // Alert Dialog to display the logout confirmation message!
  Future<void> _alertDialogBuilder() async {
    return showDialog(
        useSafeArea: true,
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Hey!!"),
            content: Container(
              child: Text("Do you really wants to logged out?"),
            ),
            actions: [
              FlatButton(
                  onPressed: () async {
                    FocusScope.of(context).unfocus();
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushNamed(context, '/SignIn');
                  },
                  child: Text("Yes")),
              SizedBox.fromSize(
                size: Size(10, 10),
              ),
              FlatButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    Navigator.pop(context);
                  },
                  child: Text("No")),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 10,
        shadowColor: Colors.grey,
        title: Text("NewsZilla", style: TextStyle(color: Colors.black)),
        // centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 7),
            child: IconButton(
              icon: Icon(
                Icons.settings,
                color: Colors.black,
              ),
              onPressed: () async {
                Navigator.pushNamed(context, '/settings');
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: IconButton(
              autofocus: false,
              icon: Icon(
                Icons.logout,
                color: Colors.black,
              ),
              onPressed: () async {
                _alertDialogBuilder();
              },
            ),
          )
        ],
      ),
      body: Container(
        child: FutureBuilder<NewsModel>(
          future: _newsModel,
          builder: (context, snapshot) {
            print("!!!!!!!!!!!!!!!! ${snapshot.hasData}");
            if (snapshot.hasData) {
              return Swiper(
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data!.articles.length,
                  itemBuilder: (context, index) {
                    var article = snapshot.data!.articles[index];
                    var formattedTime = DateFormat('dd MMM - HH:mm')
                        .format(article.publishedAt);
                    return Container(
                      // height: 50,
                      margin: const EdgeInsets.all(12),
                      child: Column(
                        children: <Widget>[
                          // image
                          InkWell(
                            onTap: ()async {
                              print("hello");
                              var url = article.url;
                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                            child: Card(
                              elevation: 15,
                              shadowColor: Colors.grey,
                              clipBehavior: Clip.antiAlias,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: AspectRatio(
                                  aspectRatio: 1,
                                  child: Image.network(
                                    article.urlToImage,
                                    fit: BoxFit.cover,
                                  )),
                            ),
                          ),
                          SizedBox(height: 16),
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(formattedTime),
                                  SizedBox(height: 5),
                                  Text(
                                    article.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                      article.description
                                          .replaceAll("\n", " ")
                                          .replaceAll("\r", " ")
                                          .replaceAll("<ol>", " ")
                                          .replaceAll("<li>", " ")
                                          .replaceAll("</li>", " ")
                                          .replaceAll("</ol>", " ")
                                          .replaceAll("  ", " "),
                                      maxLines: 5,
                                      overflow: TextOverflow.ellipsis,
                                    ),

                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  });
            } else
              return Center(
                  child: CircularProgressIndicator(
                color: Colors.black,
              ));
          },
        ),
      ),
    );
  }
}
