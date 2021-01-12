import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vibeus/ui/constants.dart';
import 'package:transparent_image/transparent_image.dart';

class ViewPost extends StatefulWidget {
  @override
  _ViewPostState createState() => _ViewPostState();
}

class _ViewPostState extends State<ViewPost> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: backgroundColor,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("Posts",
               style: TextStyle(
                 color: Colors.black
               ),      
        ),
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection('postImageURLs').snapshots(),
        builder: (context, snapshot) {
          return !snapshot.hasData
              ? Center(
                child: CircularProgressIndicator(),
              )
              : Container(
                padding: EdgeInsets.all(4),
                  child: GridView.builder(
                    itemCount: snapshot.data.documents.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3),
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.all(3),
                          child: FadeInImage.memoryNetwork(
                              placeholder: kTransparentImage,
                              image: snapshot.data.documents[index].get('url')),
                        );
                      }),
                );
        },
      ),
    );
  }
}
