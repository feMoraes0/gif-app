import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gif_app/ui/git_page.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';

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
          "https://api.giphy.com/v1/gifs/search?api_key=GXnerKPsKLwJxgzPl8xNKkdHpWa6imVj&q=$_search&limit=19&offset=$_offset&rating=G&lang=en");
    }

    return json.decode(response.body);
  }

  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      itemCount: (this._search == null)
          ? snapshot.data["data"].length
          : snapshot.data["data"].length + 1,
      itemBuilder: (context, index) {
        if (this._search != null && index == snapshot.data["data"].length) {
          return GestureDetector(
            onTap: () {
              setState(() {
                this._offset += 19;
              });
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 70,
                ),
                Text(
                  "More...",
                  style: TextStyle(
                    fontSize: 22.0,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          );
        }
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => GifPage(
                  gifData: snapshot.data["data"][index],
                ),
              ),
            );
          },
          onLongPress: () {
            Share.share(snapshot.data["data"][index]["images"]["fixed_height"]["url"]);
          },
          child: Image.network(
            snapshot.data["data"][index]["images"]["fixed_height"]["url"],
            height: 300,
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network(
          "https://developers.giphy.com/static/img/dev-logo-lg.7404c00322a8.gif",
        ),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              onSubmitted: (String value) {
                setState(() {
                  this._search = value;
                  this._offset = 0;
                });
              },
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
          Expanded(
            child: FutureBuilder(
              future: this._getSearch(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 5.0,
                      ),
                    );
                  default:
                    if (snapshot.hasError)
                      return Container();
                    else
                      return this._createGifTable(context, snapshot);
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
