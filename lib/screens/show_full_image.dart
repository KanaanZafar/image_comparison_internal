import 'package:flutter/material.dart';
import 'package:image_comparison/stores/create_comparison_store.dart';
import 'package:image_comparison/utils/helper.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_widget/photo_widget.dart';
import 'package:provider/provider.dart';

class ShowFullImage extends StatefulWidget {
  final AssetEntity assetEntity;

  ShowFullImage({this.assetEntity});

  @override
  _ShowFullImageState createState() => _ShowFullImageState();
}

class _ShowFullImageState extends State<ShowFullImage> {
  CreateComparisonStore createComparisonStore;

  @override
  void initState() {
    createComparisonStore =
        Provider.of<CreateComparisonStore>(context, listen: false);
    super.initState();
  }

  @override
  void dispose() {
    if (createComparisonStore.comparisonType == ComparisonType.threePhotos) {
      setOrientationHorizontal();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                child: AssetWidget(
                  asset: widget.assetEntity,
                  thumbSize: 1500,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: IconButton(
                  icon: Icon(
                    Icons.share_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    shareWithOtherApps([widget.assetEntity]);
                  }),
            )
          ],
        ),
      ),
    );
  }
}
