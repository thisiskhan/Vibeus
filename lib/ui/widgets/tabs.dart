import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vibeus/models/user.dart';
import 'package:vibeus/repositories/userRepository.dart';
import 'package:vibeus/ui/pages/matches.dart';
import 'package:vibeus/ui/pages/messages.dart';
import 'package:vibeus/ui/pages/search.dart';
import 'package:flutter/material.dart';
import 'package:vibeus/ui/pages/userprofile.dart';
import '../constants.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

User user; //yaha se le raha hai uesrs

final userRefrence = Firestore.instance.collection("users");

class Tabs extends StatefulWidget {
  UserRepository userRepository;
  final userId;
  final User user;

  Tabs({this.userId, this.user, this.userRepository});

  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  String _debugLabelString = "";
  int _page = 0;

  Future<void> notifiyer() async {
    OneSignal.shared.init('e4eeddce-b510-494b-b57d-54cf930e16a1');
    //Remove this method to stop OneSignal Debugging
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    OneSignal.shared.init("YOUR_ONESIGNAL_APP_ID", iOSSettings: {
      OSiOSSettings.autoPrompt: false,
      OSiOSSettings.inAppLaunchUrl: false
    });
    OneSignal.shared
        .setInFocusDisplayType(OSNotificationDisplayType.notification);

// The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    await OneSignal.shared
        .promptUserForPushNotificationPermission(fallbackToSettings: true);

    OneSignal.shared
        .setNotificationReceivedHandler((OSNotification notification) {
      this.setState(() {
        _debugLabelString =
            "Received notification: \n${notification.jsonRepresentation().replaceAll("\\n", "\n")}";
      });
    });

    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      // will be called whenever a notification is opened/button pressed.
    });

    OSPermissionSubscriptionState status =
        await OneSignal.shared.getPermissionSubscriptionState();

    String playerId = status.subscriptionStatus.userId;
    print(playerId);
    Firestore.instance
        .collection('users')
        .document(widget.userId)
        .collection('notifiyerId')
        .document()
        .setData({
      "playerId": playerId,
    });
  }

  @override
  void initState() {
    notifiyer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      Search(
        userId: widget.userId,
        userRepository: widget.userRepository,
      ),
      Matches(
        userId: widget.userId,
      ),
      Messages(
        userId: widget.userId,
      ),
      UserProfile(userRepository: widget.userRepository, userId: widget.userId),
    ];

    return Theme(
      data: ThemeData(
        primaryColor: backgroundColor,
        accentColor: Colors.white,
      ),
      child: Scaffold(
      body: pages[_page],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _page,
          items: [
            BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: Icon(
                Icons.explore_outlined,
                color: Colors.black,
                size: 30.0,
              ),
              // ignore: deprecated_member_use
              title: Text(
                "Explore",
                style: TextStyle(color: Colors.black),
              ),
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: Icon(
                Icons.notifications_outlined,
                color: Colors.black,
                size: 30.0,
              ),
              // ignore: deprecated_member_use
              title: Text(
                "Notifications",
                style: TextStyle(color: Colors.black),
              ),
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: Icon(
                Icons.chat_outlined,
                color: Colors.black,
                size: 30.0,
              ),
              // ignore: deprecated_member_use
              title: Text(
                "Chats",
                style: TextStyle(color: Colors.black),
              ),
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: Icon(
                Icons.account_circle_outlined,
                color: Colors.black,
                size: 30.0,
              ),
              // ignore: deprecated_member_use
              title: Text(
                "Profile",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
          onTap: (context) {
            setState(() {
              _page = context;
            });
          },
        ),
      ),
    );
  }
}

Widget addbottomsheet() {
  return Container(
    height: 100.0,
    //  width: MediaQuery.of(context).size.width,
    margin: EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 20,
    ),
    child: Column(
      children: <Widget>[
        Text(
          'Chose profile photo',
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            FlatButton.icon(
                onPressed: () {
                  //        takePhoto(ImageSource.camera);
                },
                icon: Icon(Icons.camera),
                label: Text("Camera")),
            FlatButton.icon(
                onPressed: () {
                  //     takePhoto(ImageSource.gallery);
                },
                icon: Icon(Icons.image),
                label: Text("Gallery"))
          ],
        ),
      ],
    ),
  );
}
//   void takePhoto(ImageSource source) async {
//   final PickedFile = await _picker.getImage(
//     source: source,
//   );
//   setState(() {
//     _imageFile = PickedFile;
//   });
// }
