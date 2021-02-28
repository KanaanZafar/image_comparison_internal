import 'package:flutter/material.dart';
import 'package:image_comparison/utils/constants.dart';
import 'package:image_comparison/utils/helper.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_widget/photo_widget.dart';

class ShowFullImage extends StatefulWidget {
  final AssetEntity assetEntity;

  ShowFullImage({this.assetEntity});

  @override
  _ShowFullImageState createState() => _ShowFullImageState();
}

class _ShowFullImageState extends State<ShowFullImage> {
  @override
  void dispose() {
    setOrientationHorizontal();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Constants.fullImage,
        ),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: AssetWidget(
        asset: widget.assetEntity,
        thumbSize: 1500,
      ),
    );
  }
}
