import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_widget/photo_widget.dart';

class SmallImageTile extends StatelessWidget {
  final AssetEntity assetEntity;
  final bool isSelected;

  SmallImageTile(this.assetEntity, {this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        AssetWidget(
          asset: assetEntity,
          thumbSize: 300,
        ),
        PositionedDirectional(
          start: 5,
          top: 5,
          child: Container(
            height: 20,
            width: 20,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black),
            ),
            child: Center(
              child: isSelected
                  ? Icon(
                      Icons.check,
                      color: Colors.grey,
                      size: 15,
                    )
                  : Container(),
            ),
          ),
        ),
      ],
    );
  }
}
