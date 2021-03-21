import 'package:flutter/material.dart';
import 'package:image_comparison/utils/iFavorites_colors.dart';
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
            color: isSelected ? Colors.white : Colors.transparent,
            child: Center(
              child: isSelected
                  ? Icon(
                      Icons.check_box,
                      color: IfavoirtesColors.primaryColor,
//                      size: 15,
                    )
                  : Icon(Icons.check_box_outline_blank, color: Colors.white,),
            ),
          ),
        ),
      ],
    );
  }
}
