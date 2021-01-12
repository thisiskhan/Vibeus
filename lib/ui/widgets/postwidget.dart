
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vibeus/models/user.dart';
import 'package:vibeus/repositories/userRepository.dart';
import 'package:vibeus/ui/widgets/tabs.dart';

// ignore: must_be_immutable
class Post extends StatefulWidget {
  UserRepository userRepository;
  final String postId;
  final String location;
  final String discription;
  final String postuserId;
  final String url;
 // final String timestamp;
  Post(
      {this.postId,
      this.location,
      this.discription,
      this.postuserId,
      this.url,
 //     this.timestamp,
      this.userRepository});

  factory Post.fromDocument(DocumentSnapshot documentSnapshot) {
    return Post(
      postId: documentSnapshot['postId'],
      location: documentSnapshot['location'],
      discription: documentSnapshot['discription'],
      postuserId: documentSnapshot['postuserId'],
   //   timestamp: documentSnapshot['timestamp'],
      url: documentSnapshot['url'],
    );
  }

  @override
  _PostState createState() => _PostState(
      postId: this.postId,
      discription: this.discription,
      location: this.location,
      postuserId: this.postuserId,
      url: this.url);
}

class _PostState extends State<Post> {
  final String postId;
  final String location;
  final String discription;
  final String postuserId;
  final String url;

  _PostState(
      {this.postId,
      this.location,
      this.discription,
      this.postuserId,
      this.url});

  String currentUserUid;

  @override
  void initState() {
    super.initState();

    gteCurrentUserId();
  }

  gteCurrentUserId() async {
    String postuserId = await widget.userRepository.getUser();
    setState(() {
      currentUserUid = postuserId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          createPostHead(),
          createPostImage(),
          cretaePostFooter(),
        ],
      ),
    );
  }

  createPostHead() {
    CollectionReference users = Firestore.instance.collection('users');
    return FutureBuilder(
        future: users.document(postuserId).get(),
        builder: (context, dataSnapshot) {
          if (!dataSnapshot.data) {
            return Center(
                child: CircularProgressIndicator(
              backgroundColor: Colors.black,
            ));
          }
          if (dataSnapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data = dataSnapshot.data.data;
        //    User user = User.fromDocument(dataSnapshot.data);
            bool isPostOwner = currentUserUid == postuserId;
            return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage("${data['photoUrl']}"),
                ),
                title: Text("${data['name']}"),
                subtitle: Text(
                  location,
                  style: TextStyle(color: Colors.grey),
                ),
                trailing: isPostOwner
                    ? IconButton(
                        icon: Icon(
                          Icons.more_vert,
                          color: Colors.black,
                        ),
                        onPressed: () {})
                    : null);
          }
          return Center(
              child: CircularProgressIndicator(
            backgroundColor: Colors.black,
          ));
        });
  }

  createPostImage() {
    return GestureDetector(
      onDoubleTap: () => print("liked"),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.network(url),
        ],
      ),
    );
  }

  cretaePostFooter() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 40, left: 20),
              child: Text(
                discription,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        )
      ],
    );
  }
}
