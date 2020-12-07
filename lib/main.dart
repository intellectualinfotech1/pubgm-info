import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pubgm_info/models/auth.dart';
import 'package:pubgm_info/models/coin_provider.dart';
import 'package:pubgm_info/models/ad_manager.dart';
import 'package:pubgm_info/screens/auth_screen.dart';
import 'package:pubgm_info/screens/category_info.dart';
import 'package:pubgm_info/screens/category_internal_list_screen.dart';
import 'package:pubgm_info/screens/category_list_screen.dart';
import 'package:pubgm_info/screens/coins.dart';
import 'package:pubgm_info/screens/item_info.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseAdMob.instance.initialize(appId: AdManagement.appId);
  runApp(
    MyApp(),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        // ignore: missing_required_param
        ChangeNotifierProvider<CoinProvider>(
          create: (ctx) => CoinProvider(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) {
          auth.restartAuthentication();
          return MaterialApp(
            title: "PUBGM Info",
            theme: ThemeData(
              primaryColor: Colors.indigo[700],
              accentColor: Colors.cyan,
              fontFamily: "Montserrat",
            ),
            debugShowCheckedModeBanner: false,
            // home: auth.isAuthenticated ? CategoryList() : AuthScreen(),
            home: auth.isAuthenticated ? CategoryList() : AuthScreen(),
            routes: {
              CategoryInfo.routeName: (ctx) => CategoryInfo(),
              CategoryInternal.routeName: (ctx) => CategoryInternal(),
              ItemInfo.routeName: (ctx) => ItemInfo(),
              CoinScreen.routeName: (ctx) => CoinScreen(),
            },
          );
        },
      ),
    );
  }
}
