import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

class homePage extends StatefulWidget {
  @override
  _homePageState createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  List usersData;
  final String url = "https://randomuser.me/api/?results=50";
  bool isLoading;

  Future<String> getuserData() async {
    var response = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    List data = jsonDecode(response.body)['results'];
    setState(() {
      this.usersData = data;
      this.isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getuserData();
    this.isLoading = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Random Users"),
      ),
      body: Center(
        child: this.isLoading
            ? CircularProgressIndicator()
            : ListView.builder(
                itemBuilder: (BuildContext context, int i) {
                  return bodyListTile(i);
                },
                itemCount:
                    this.usersData.length == null ? 0 : this.usersData.length,
              ),
      ),
    );
  }

  Widget bodyListTile(int i) {
    return Card(
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(15),
            child: Image.network(
              "${this.usersData[i]["picture"]["thumbnail"]}",
              fit: BoxFit.contain,
              width: 70,
              height: 70,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                textWidgetForBodyListTile(
                  i,
                  "${this.usersData[i]["name"]["first"]} ${this.usersData[i]["name"]["last"]}",
                  16,
                  bold: FontWeight.bold,
                ),
                rowWidgetForBodyListTile(
                  Icons.mail,
                  textWidgetForBodyListTile(
                    i,
                    "${this.usersData[i]["email"]}",
                    13,
                  ),
                ),
                rowWidgetForBodyListTile(
                  Icons.phone,
                  textWidgetForBodyListTile(
                    i,
                    "${this.usersData[i]["phone"]}",
                    13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Row rowWidgetForBodyListTile(IconData leadingIcon, Text textWidget) {
    return Row(
      children: <Widget>[
        Icon(
          leadingIcon,
          size: 18,
        ),
        SizedBox(
          width: 8,
        ),
        textWidget,
      ],
    );
  }

  Text textWidgetForBodyListTile(int i, String text_api, double fontsize,
      {int maxlines = 1, FontWeight bold = null}) {
    return Text(
      text_api,
      style: TextStyle(fontSize: fontsize, fontWeight: bold),
      maxLines: maxlines,
    );
  }
}
