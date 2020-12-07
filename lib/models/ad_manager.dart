import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/painting.dart';

class AdManagement {
  static String appId = "ca-app-pub-3388596014632343~8043577174";
  static String bannerId = "ca-app-pub-3388596014632343/6696790193";
  static String interstitialId = "ca-app-pub-3388596014632343/3691368812";
  static String rewardId = "ca-app-pub-3388596014632343/1663971276";

  static const String testDevice = '44D7E32E7BA74AB16153BD4933ECDFAF';

  static BannerAd homePageBanner;
  static InterstitialAd productInfoAd;
  static RewardedVideoAd rewardedAd;

  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    testDevices: testDevice != null ? <String>[testDevice] : null,
    keywords: <String>['flutterio', 'beautiful apps'],
    contentUrl: 'https://flutter.io',
    childDirected: true,
    nonPersonalizedAds: true,
  );

  static BannerAd loadBannerAd() {
    return BannerAd(
      adUnitId: bannerId,
      size: AdSize.fullBanner,
      targetingInfo: targetingInfo,
    );
  }

  static InterstitialAd loadInterAds() {
    return InterstitialAd(
      adUnitId: interstitialId,
      targetingInfo: targetingInfo,
    );
  }

  static showBannerAd() {
    homePageBanner = loadBannerAd();
    homePageBanner
      ..load()
      ..show(anchorType: AnchorType.bottom);
  }

  static showInterstitialAd() async {
    productInfoAd = loadInterAds();
    productInfoAd
      ..load()
      ..show();
  }

  static showRewardAds() {
    rewardedAd = RewardedVideoAd.instance;
    rewardedAd..load(adUnitId: rewardId, targetingInfo: targetingInfo);
    rewardedAd
      ..listener = (RewardedVideoAdEvent event,
          {int rewardAmount, String rewardType}) {};
  }
}
