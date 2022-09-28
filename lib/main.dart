import 'package:advertisement/banner.dart';
import 'package:advertisement/interads.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(MaterialApp(home: interads(),));
}
const int maxFailedLoadAttempts = 3;

class ads extends StatefulWidget {
  const ads({Key? key}) : super(key: key);

  @override
  State<ads> createState() => _adsState();
}

class _adsState extends State<ads> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ADS"),),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                return banner();
              },));
            }, child: Text("Banner Ads"))
          ],
        ),
      ),
    );
  }
}
