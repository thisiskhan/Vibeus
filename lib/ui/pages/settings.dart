import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vibeus/bloc/authentication/authentication_bloc.dart';
import 'package:vibeus/bloc/authentication/authentication_event.dart';
import 'package:vibeus/ui/constants.dart';
import 'package:vibeus/ui/pages/ProfileVerification.dart';
import 'package:vibeus/ui/pages/aboutsett.dart';
import 'package:vibeus/ui/pages/notificationssett.dart';


class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: backgroundColor,
          iconTheme: IconThemeData(color: Colors.black),
          centerTitle: true,
          title: Text(
            "Settings",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ListTile(
                title: Text(
                  "Profile Verification",
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                leading: Icon(
                  Icons.account_circle_outlined,
                  size: 25,
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfileSettings()));
                },
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 25,
                  color: Colors.grey,
                ),
              ),
              // ListTile(
              //   title: Text(
              //     "Notifications",
              //     style: TextStyle(
              //         color: Colors.grey,
              //         fontWeight: FontWeight.bold,
              //         fontSize: 20),
              //   ),
              //   leading: Icon(
              //     Icons.notifications_outlined,
              //     size: 25,
              //   ),
              //   onTap: () {
              //     Navigator.push(context,
              //         MaterialPageRoute(builder: (context) => Notisett()));
              //   },
              //   trailing: Icon(
              //     Icons.arrow_forward_ios,
              //     size: 25,
              //     color: Colors.grey,
              //   ),
              // ),
         
              ListTile(
                title: Text(
                  "About",
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                leading: Icon(
                  Icons.info_outline,
                  size: 25,
                ),
                onTap: () {
                   Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => About()));
                },
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 25,
                  color: Colors.grey,
                ),
              ),
    
            
              ListTile(
                title: Text(
                  "LogOut",
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                leading: Icon(Icons.exit_to_app),
                onTap: () {
                  BlocProvider.of<AuthenticationBloc>(context)
                      .add(LoggedOut());
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text(
                  "Delete Account",
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                leading: Icon(
                  Icons.delete,
                ),
                onTap: () {},
              )
            ],
          ),
        ));
  }
}



class Policies extends StatefulWidget {
  @override
  _PoliciesState createState() => _PoliciesState();
}

class _PoliciesState extends State<Policies> {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}