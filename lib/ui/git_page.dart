import 'package:flutter/material.dart';

class GifPage extends StatelessWidget {

  final Map gifData;

  const GifPage({Key key, this.gifData}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(this.gifData["title"]),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Image.network(this.gifData["images"]["fixed_height"]["url"]),
      ),
    );
  }
}