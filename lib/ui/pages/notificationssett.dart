import 'package:flutter/material.dart';
import 'package:vibeus/ui/constants.dart';

class Notisett extends StatefulWidget {
  @override
  _NotisettState createState() => _NotisettState();
}

class _NotisettState extends State<Notisett> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        backgroundColor: backgroundColor,
        title: Text("Notification",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            )),
      ),
      body: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ListTile(
                title: Text('Push Notification',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text('Pause all Notification'),
                    trailing:
                        Switch(value: false, onChanged: (paueNotification) {}),
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text('Pause Like Notification'),
                    trailing:
                        Switch(value: false, onChanged: (paueNotification) {}),
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text('Pause Matches Norification'),
                    trailing:
                        Switch(value: false, onChanged: (paueNotification) {}),
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text('Pause Message Notification'),
                    trailing:
                        Switch(value: false, onChanged: (paueNotification) {}),
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}
