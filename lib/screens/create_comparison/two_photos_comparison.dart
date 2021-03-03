import 'package:flutter/material.dart';
import 'package:image_comparison/components/large_image_tile.dart';
import 'package:image_comparison/components/side_action_bar_horizontal.dart';
import 'package:image_comparison/utils/size_config.dart';

class TwoPhotosComparison extends StatefulWidget {
  @override
  _TwoPhotosComparisonState createState() => _TwoPhotosComparisonState();
}

class _TwoPhotosComparisonState extends State<TwoPhotosComparison> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: SizeConfig.screenHeight / 1.25,
              width: SizeConfig.screenWidth,
              child: Row(
                children: [
                  LargeImageTile(
                    edgeInsets: EdgeInsets.only(right: 1.0),
                  ),
                  LargeImageTile(
                    edgeInsets: EdgeInsets.only(left: 1.0),
                  )
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: SideActionBarHorizontal(
                  // width: SizeConfig.screenWidth,
                  isVertical: true,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
