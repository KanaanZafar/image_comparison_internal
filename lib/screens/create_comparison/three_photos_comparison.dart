import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_comparison/components/large_image_tile.dart';
import 'package:image_comparison/components/side_action_bar_horizontal.dart';
import 'package:image_comparison/stores/create_comparison_store.dart';
import 'package:image_comparison/utils/helper.dart';
import 'package:image_comparison/utils/size_config.dart';
import 'package:provider/provider.dart';

class ThreePhotosComparison extends StatefulWidget {
  @override
  _ThreePhotosComparisonState createState() => _ThreePhotosComparisonState();
}

class _ThreePhotosComparisonState extends State<ThreePhotosComparison> {
  double imageHeight;
  double imageWidth;

  @override
  void initState() {
    setOrientationHorizontal();
    double x = SizeConfig.screenHeight / 10;
    imageWidth = (3 * (x)) - (SizeConfig.blockSizeVertical * 2);
    imageHeight = SizeConfig.screenWidth - x;
    super.initState();
  }

  @override
  void dispose() {
    setOrientationVertical();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(),
            LargeImageTile(
              width: imageWidth,
              height: SizeConfig.screenWidth
            ),
            LargeImageTile(
              width: imageWidth,
              height: SizeConfig.screenWidth
            ),
            LargeImageTile(
              width: imageWidth,
              height: SizeConfig.screenWidth
            ),
            SideActionBarHorizontal(
              photoHeight: imageHeight / 3,
              photoWidth: imageWidth / 3,
            ),
          ],
        ),
      ),
    );
  }
}
