import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _search;
  int _offset = 0;

  void initState() {
    super.initState();
    this._getSearch().then((map) {
      print(map);
    });
  }

  Future<Map> _getSearch() async {
    http.Response response;

    if (_search == null) {
      response = await http.get(
          "https://api.giphy.com/v1/gifs/trending?api_key=GXnerKPsKLwJxgzPl8xNKkdHpWa6imVj&limit=20&rating=G");
    } else {
      response = await http.get(
          "https://api.giphy.com/v1/gifs/search?api_key=GXnerKPsKLwJxgzPl8xNKkdHpWa6imVj&q=$_search&limit=20&offset=$_offset&rating=G&lang=en");
    }

    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network(
            "https://developers.giphy.com/static/img/dev-logo-lg.7404c00322a8.gif"),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Search",
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
                hintStyle: TextStyle(
                  color: Colors.white,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
              ),
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
