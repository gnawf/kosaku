import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Farming Tracker'),
      ),
      body: HomePageBody(),
    );
  }
}

class HomePageBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 256.0 + 128.0 + 64.0,
        ),
        child: ListView(
          padding: EdgeInsets.symmetric(
            vertical: 24.0,
            horizontal: 16.0,
          ),
          children: <Widget>[],
        ),
      ),
    );
  }
}
