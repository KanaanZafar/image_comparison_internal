import 'package:admob_flutter/admob_flutter.dart';
import 'package:facebook_audience_network/ad/ad_banner.dart';
import 'package:flutter/material.dart';
import 'package:image_comparison/utils/ad_ids.dart';
import 'package:image_comparison/utils/size_config.dart';

import '../utils/ad_ids.dart';
import '../utils/size_config.dart';

class BannerAdWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      width: SizeConfig.screenWidth,
      child: FacebookBannerAd(
        bannerSize: BannerSize.STANDARD,
        placementId: AdIds.bannerAdIdPrimary,
        listener: (result, value) {
          print("---++++result: ${result}");
          print("and");
          print("---value: $value");
        },
      ),
    );
    /* return Container(
      color: Colors.black,
      width: SizeConfig.screenWidth,
      child: AdmobBanner(
          adUnitId: AdIds.bannerAdId,
          adSize: AdmobBannerSize.ADAPTIVE_BANNER(
              width: SizeConfig.screenWidth.toInt())),
    ); */
  }
}
