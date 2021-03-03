import 'package:flutter/material.dart';
import 'package:image_comparison/components/large_image_tile.dart';
import 'package:image_comparison/components/side_action_bar_horizontal.dart';
import 'package:image_comparison/utils/size_config.dart';

class FourPhotosComparison extends StatefulWidget {
  @override
  _FourPhotosComparisonState createState() => _FourPhotosComparisonState();
}

class _FourPhotosComparisonState extends State<FourPhotosComparison> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          height: SizeConfig.screenHeight / 2.5,
          color: Colors.green,
          child: Row(
            children: [
              Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          LargeImageTile(),
                          LargeImageTile(),
                        ],
                      ),
                      Row(
                        children: [
                          LargeImageTile(),
                          LargeImageTile()
                        ],
                      )
                    ],
                  )),
              SideActionBarHorizontal(
                // width: 125,
                isVertical: false,
                iconSize: 15,
              )
            ],
          ),
        ),
      ),
    );
  }
}
