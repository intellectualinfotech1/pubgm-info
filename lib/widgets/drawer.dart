import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pubgm_info/models/auth.dart';

// ignore: must_be_immutable
class CustomDrawer extends StatelessWidget {
  String userData;

  void getUserData(BuildContext context) {
    var auth = Provider.of<Auth>(context);
    userData = auth.userEmail;
  }

  @override
  Widget build(BuildContext context) {
    getUserData(context);
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            color: Theme.of(context).primaryColor,
            padding: EdgeInsets.symmetric(vertical: 50),
            alignment: Alignment.center,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(
                    Icons.account_circle_rounded,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    userData,
                    style: TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: 25,
                        fontWeight: FontWeight.w300,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
              leading: Icon(Icons.logout),
              title: Text(
                "Log Out",
                style: TextStyle(fontFamily: "Montserrat"),
              ),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              onTap: () {
                var auth = Provider.of<Auth>(context, listen: false);
                auth.logOut();
              }),
        ],
      ),
    );
  }
}
