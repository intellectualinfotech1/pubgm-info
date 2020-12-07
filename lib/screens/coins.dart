import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pubgm_info/models/auth.dart';
import 'package:pubgm_info/models/coin_provider.dart';
import 'package:pubgm_info/models/ad_manager.dart';
import 'package:firebase_admob/firebase_admob.dart';

class CoinScreen extends StatefulWidget {
  static const routeName = "/coins";

  @override
  State<StatefulWidget> createState() {
    return CoinScreenState();
  }
}

class CoinScreenState extends State<CoinScreen> {
  @override
  Widget build(BuildContext context) {
    var coinProv = Provider.of<CoinProvider>(context);
    var currentCoins = coinProv.coins;
    return Scaffold(
      appBar: AppBar(
        title: Text("Coins"),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height * 0.79,
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.only(left: 40),
              title: Text(
                currentCoins.toString(),
                style: TextStyle(fontSize: 30),
              ),
              leading: Icon(
                Icons.monetization_on,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              animationDuration: Duration(seconds: 5),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Text("Watch Ads to earn 10 coins !!!"),
              color: Colors.indigo[700],
              textColor: Colors.white,
              padding: EdgeInsets.all(15),
              onPressed: () async {
                var rewardedAd = RewardedVideoAd.instance;
                rewardedAd
                  ..load(
                      adUnitId: AdManagement.rewardId,
                      targetingInfo: AdManagement.targetingInfo);
                rewardedAd
                  ..listener = (RewardedVideoAdEvent event,
                      {int rewardAmount, String rewardType}) {
                    if (event == RewardedVideoAdEvent.rewarded) {
                      coinProv.increaseAmount(10);
                    }
                  };
                var didShow = await rewardedAd.show();
              },
            )
          ],
        ),
      ),
    );
  }
}
