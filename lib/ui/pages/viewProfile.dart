import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vibeus/bloc/search/bloc.dart';
import 'package:vibeus/bloc/search/search_bloc.dart';
import 'package:vibeus/models/user.dart';
import 'package:vibeus/ui/constants.dart';
import 'package:vibeus/ui/pages/ViewPost.dart';


class ViewProfile extends StatefulWidget {
  final String userId;

  ViewProfile({this.userId});

  @override
  _ViewProfileState createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  //final SearchRepository _searchRepository = SearchRepository();
  SearchBloc _searchBloc;
  User _user, _currentUser;
  

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
   CollectionReference users = Firestore.instance.collection('users');



    return FutureBuilder<DocumentSnapshot>(
      future: users.document(widget.userId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
              child: CircularProgressIndicator(
            backgroundColor: Colors.black,
          ));
        }
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data.data;
          return Scaffold(
              appBar: AppBar(
                elevation: 0,
                centerTitle: true,
                title: Text(
                  "my Profile",
                  style: TextStyle(color: Colors.black),
                ),
                backgroundColor: backgroundColor,
                iconTheme: IconThemeData(
                  color: Colors.black,
                ),
              ),
              body: Container(
                color: backgroundColor,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(180),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            //  spreadRadius: 5,
                            //   blurRadius: 20,
                          )
                        ],
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(" https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png"),
                        ),
                      ),
                    ),
                    Container(
                      width: size.width * 0.8,
                      child: Divider(
                        height: size.height * 0.05,
                        color: Colors.black,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        // "$name",
                        // snapshot.data['name'],
                        "" ,

                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    //   Container(
                    //   width: size.width * 0.8,
                    //   child: Divider(
                    //     height: size.height * 0.05,
                    //     color: Colors.black,
                    //   ),
                    // ),
                    Text(
                      // "",
                     """""" ,
                     //+ _user.bio,
                      maxLines: 5,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      width: size.width * 0.8,
                      child: Divider(
                        height: size.height * 0.05,
                        color: Colors.black,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        RaisedButton(
                            color: Colors.red,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "View post",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            onPressed: () {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => EditProile(
                              //             //  userId: widget.userId,
                              //             )));
                            }),
                        RaisedButton(
                            color: Colors.red,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "more..",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ViewPost()));
                            }),
                      ],
                    ),
                    Container(
                      width: size.width * 0.8,
                      child: Divider(
                        height: size.height * 0.05,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ));
        }
        return Center(
            child: CircularProgressIndicator(
          backgroundColor: Colors.black,
        ));
      },
    );
  }
}
