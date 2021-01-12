import 'package:vibeus/bloc/search/bloc.dart';
import 'package:vibeus/models/user.dart';
import 'package:vibeus/repositories/searchRepository.dart';
import 'package:vibeus/repositories/userRepository.dart';
import 'package:vibeus/ui/constants.dart';
import 'package:vibeus/ui/pages/addposts.dart';
import 'package:vibeus/ui/pages/settings.dart';
import 'package:vibeus/ui/pages/userprofile.dart';
import 'package:vibeus/ui/widgets/iconWidget.dart';
import 'package:vibeus/ui/widgets/profile.dart';
import 'package:vibeus/ui/widgets/userGender.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';

class Search extends StatefulWidget {
  final String userId;
  UserRepository userRepository;
  final User user;

  Search({this.userId, this.userRepository, this.user});

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final SearchRepository _searchRepository = SearchRepository();
  SearchBloc _searchBloc;
  User _user, _currentUser;
  int difference;
  bool flashactivated = false;

  getDifference(GeoPoint userLocation) async {
    Position position = await Geolocator().getCurrentPosition();

    double location = await Geolocator().distanceBetween(userLocation.latitude,
        userLocation.longitude, position.latitude, position.longitude);

    difference = location.toInt();
  }

  @override
  void initState() {
    _searchBloc = SearchBloc(searchRepository: _searchRepository);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocBuilder<SearchBloc, SearchState>(
      bloc: _searchBloc,
      builder: (context, state) {
        if (state is InitialSearchState) {
          _searchBloc.add(
            LoadUserEvent(userId: widget.userId),
          );
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.blueGrey),
            ),
          );
        }
        if (state is LoadingState) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.blueGrey),
            ),
          );
        }
        if (state is LoadUserState) {
          _user = state.user;
          _currentUser = state.currentUser;

          getDifference(_user.location);
          if (_user.location == null) {
            return Center(
              //   child: coustom(),
              child: Text(
                "No One Here",
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            );
          } else
            return Scaffold(
              appBar: AppBar(
                leading: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Addposts(
                                    user: widget.user,
                                    userId: widget.userId,
                                  )));
                    },
                    child: Icon(Icons.add_box_outlined)),
                elevation: 0,
                backgroundColor: backgroundColor,
                centerTitle: true,
                title: Text(
                  "Vibeus",
                  style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                ),
                actions: <Widget>[
                  IconButton(
                      icon: Icon(Icons.settings),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Settings()));
                      }),
                ],
              ),
              body: profileWidget(
                padding: size.height * 0.035,
                photoHeight: size.height * 0.81,
                photoWidth: size.width * 0.95,
                photo: _user.photo,
                clipRadius: size.height * 0.02,
                containerHeight: size.height * 0.3,
                containerWidth: size.width * 0.9,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          // IconButton(
                          //   icon: Icon(
                          //     Icons.verified,
                          //     color: Colors.blue,
                          //   ),
                          //   onPressed: null,
                          //   tooltip: "Vrified User",
                          // ),
                          userGender(_user.gender),
                          Expanded(
                            child: Text(
                              " " +
                                  _user.name +
                                  ", " +
                                  (DateTime.now().year -
                                          _user.age.toDate().year)
                                      .toString(),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.location_on,
                            color: Colors.white,
                          ),
                          Text(
                            difference != null
                                ? (difference / 1000).floor().toString() +
                                    "km away"
                                : "away",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.05,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          CircleAvatar(
                            backgroundColor: backgroundColor,
                            child: flashactivated
                                ? iconWidget(EvaIcons.flash, () {},
                                    size.height * 0.04, Colors.grey)
                                : iconWidget(EvaIcons.flash, () {
                                    showFlashDialog(context: context);
                                    Navigator.of(context);
                                  }, size.height * 0.04, Colors.yellow),
                          ),
                          CircleAvatar(
                            backgroundColor: backgroundColor,
                            child: iconWidget(Icons.clear, () {
                              _searchBloc
                                  .add(PassUserEvent(widget.userId, _user.uid));
                            }, size.height * 0.04, Colors.blue),
                          ),
                          CircleAvatar(
                            backgroundColor: backgroundColor,
                            child: iconWidget(FontAwesomeIcons.solidHeart, () {
                              _searchBloc.add(
                                SelectUserEvent(
                                    name: _currentUser.name,
                                    photoUrl: _currentUser.photo,
                                    currentUserId: widget.userId,
                                    selectedUserId: _user.uid),
                              );
                            }, size.height * 0.04, Colors.red),
                          ),
                          CircleAvatar(
                            backgroundColor: backgroundColor,
                            child:
                                iconWidget(Icons.account_circle_outlined, () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UserProfile(
                                            userId: _user.uid,
                                            userRepository:
                                                widget.userRepository,
                                          )));
                            }, size.height * 0.04, Colors.blueGrey),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
        } else
          print("error");
        return Scaffold(
          backgroundColor: backgroundColor,
          body: Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.blue,
            ),
          ),
        );
      },
    );
  }

  showFlashDialog(
      {BuildContext context,
      CustomDialogBox Function(BuildContext context) builder}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialogBox(
            title: "VibeusBoost mode",
            descriptions:
                "VibeusBoost mode will help you find more active people on vibeus around you",
            text: "Thanks",
          );
        });

    setState(() {
      flashactivated = true;
    });
  }
}

class CustomDialogBox extends StatefulWidget {
  final String title, descriptions, text;
  final Image img;

  const CustomDialogBox(
      {Key key, this.title, this.descriptions, this.text, this.img})
      : super(key: key);

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  @override
  Widget build(BuildContext context) {
        Size size = MediaQuery.of(context).size;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
        Size size = MediaQuery.of(context).size;
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
              left: Constants.padding,
              top: Constants.avatarRadius + Constants.padding,
              right: Constants.padding,
              bottom: Constants.padding),
          margin: EdgeInsets.only(top: Constants.avatarRadius),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(Constants.padding),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                widget.title,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                widget.descriptions,
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 22,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      widget.text,
                      style: TextStyle(fontSize: 18),
                    )),
              ),
            ],
          ),
        ),
        Positioned(
          left: Constants.padding,
          right: Constants.padding,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: Constants.avatarRadius,
            child: ClipRRect(
                borderRadius:
                    BorderRadius.all(Radius.circular(Constants.avatarRadius)),
                child:iconWidget(EvaIcons.flash, () {},
                                    size.height * 0.08, Colors.yellow)),
          ),
        ),
      ],
    );
  }
}

class Constants {
  Constants._();
  static const double padding = 20;
  static const double avatarRadius = 45;
}
