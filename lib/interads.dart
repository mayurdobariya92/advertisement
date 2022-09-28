import 'dart:io';

import 'package:advertisement/banner.dart';
import 'package:advertisement/rewardads.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'app_lifecycle_reactor.dart';
import 'app_open_ad_manager.dart';
import 'main.dart';

class interads extends StatefulWidget {
  const interads({Key? key}) : super(key: key);

  @override
  State<interads> createState() => _interadsState();
}

class _interadsState extends State<interads> {


    static final AdRequest request = AdRequest(
  keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,
  );

  InterstitialAd ? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;

  int inter =0;

    late AppLifecycleReactor _appLifecycleReactor;

  @override
  void initState() {
  super.initState();

  AppOpenAdManager appOpenAdManager = AppOpenAdManager()..loadAd();
  _appLifecycleReactor = AppLifecycleReactor(
      appOpenAdManager: appOpenAdManager);
  _appLifecycleReactor.listenToAppStateChanges();

  _createInterstitialAd();

  }

  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: Platform.isAndroid
            ? 'ca-app-pub-3940256099942544/1033173712'
            : 'ca-app-pub-3940256099942544/4411468910',
        request: request,
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('$ad loaded');
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            _interstitialAd!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
            _numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
            if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
              _createInterstitialAd();
            }
          },
        ));
  }

  void _showInterstitialAd() {
    if (_interstitialAd == null) {
      if (inter==1)
        {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return banner();
          },));
        }
      // else if (inter==2)
      // {
      //   Navigator.push(context, MaterialPageRoute(builder: (context) {
      //     return native();
      //   },));
      // }
      else if (inter==3)
      {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return rewardads();
        },));
      }
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        if (inter==1)
        {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return banner();
          },));
        }
        // else if (inter==2)
        // {
        //   Navigator.push(context, MaterialPageRoute(builder: (context) {
        //     return native();
        //   },));
        // }
        else if (inter==3)
        {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return rewardads();
          },));
        }
        _createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createInterstitialAd();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Inter Ads"),),
      body: Column(
        children: [
          ElevatedButton(onPressed: () {
            inter=1;
            _showInterstitialAd();
          }, child: Text("Banner")),
          ElevatedButton(onPressed: () {
            inter=2;
            _showInterstitialAd();
          }, child: Text("Native")),

          ElevatedButton(onPressed: () {
            inter=3;
            _showInterstitialAd();
          }, child: Text("Reward"))
        ],
      ),
    );
  }
}
