import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:pubgm_info/models/ad_manager.dart';
import 'package:pubgm_info/models/auth.dart';
import 'package:pubgm_info/models/coin_provider.dart';
import 'package:pubgm_info/screens/coins.dart';
import 'package:pubgm_info/widgets/category_list_item.dart';
import 'package:pubgm_info/widgets/drawer.dart';

enum ViewState {
  listView,
  gridView,
}

class CategoryList extends StatefulWidget {
  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  var isLoading = true;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  ViewState currentViewState = ViewState.listView;

  Future loadTempData() {
    var tempData = rootBundle
        .loadString("assets/pubgdata.json")
        .then((value) => jsonDecode(value));
    return tempData;
  }

  Future<Map<String, Object>> loadMainData() async {
    var mainData = await loadTempData();
    return mainData;
  }

  @override
  void initState() {
    super.initState();
    AdManagement.showBannerAd();
  }

  @override
  Widget build(BuildContext context) {
    var coinData = Provider.of<CoinProvider>(context);
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.account_circle_rounded),
            onPressed: () {
              scaffoldKey.currentState.openDrawer();
            }),
        actions: [
          IconButton(
            icon: Icon(Icons.monetization_on),
            onPressed: () {
              Navigator.of(context).pushNamed(CoinScreen.routeName);
            },
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(CoinScreen.routeName);
            },
            child: Container(
              child: Text(
                coinData.coins.toString(),
                style: TextStyle(fontSize: 18),
              ),
              alignment: Alignment.center,
            ),
          ),
          SizedBox(width: 10),
        ],
        title: Text(
          "PUBGM Info",
          style: TextStyle(fontFamily: "Montserrat", fontSize: 25),
        ),
      ),
      drawer: CustomDrawer(),
      body: FutureBuilder(
        builder: (context, snapshot) {
          while (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemBuilder: (ctx, index) {
              var wCategory = snapshot.data["weaponcategory"];
              var oCategory = snapshot.data["outfitcategory"];
              var vCategory = snapshot.data["vehiclecategory"];
              return CategoryListTile(
                  snapshot.data[snapshot.data.keys.toList()[index]],
                  snapshot.data.keys.toList()[index],
                  wCategory,
                  oCategory,
                  vCategory,
                  index);
            },
            itemCount: snapshot.data.keys.toList().length,
          );
        },
        future: loadMainData(),
      ),
    );
  }
}
