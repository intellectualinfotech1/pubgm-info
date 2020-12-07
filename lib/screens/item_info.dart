import 'package:flutter/material.dart';
import 'package:pubgm_info/models/ad_manager.dart';

class ItemInfo extends StatefulWidget {
  static const routeName = "/item-info";

  @override
  _ItemInfoState createState() => _ItemInfoState();
}

class _ItemInfoState extends State<ItemInfo> {
  @override
  void initState() {
    AdManagement.showInterstitialAd();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments as List;
    var categoryName = args[0];
    var category = args[1];
    final item =
        category.where((element) => element["name"] == categoryName).toList();
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(categoryName,),
      // ),
      body: Container(
        height: MediaQuery.of(context).size.height * 0.9,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Hero(tag: categoryName, child: Image.network(item[0]["imgurl"])),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(left: 40, top: 20),
                child: Text(
                  categoryName,
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.w700),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                child: Text(
                  item[0]["description"],
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.justify,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
