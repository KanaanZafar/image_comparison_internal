import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_comparison/components/large_image_tile.dart';
import 'package:image_comparison/components/side_action_bar_horizontal.dart';
import 'package:image_comparison/stores/create_comparison_store.dart';
import 'package:image_comparison/utils/helper.dart';
import 'package:image_comparison/utils/size_config.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import 'package:image_comparison/components/dialogs.dart' as Dialogs;
import 'package:flutter/services.dart';
class ThreePhotosComparison extends StatefulWidget {
  @override
  _ThreePhotosComparisonState createState() => _ThreePhotosComparisonState();
}

class _ThreePhotosComparisonState extends State<ThreePhotosComparison> {
  double imageHeight;
  double imageWidth;
  CreateComparisonStore createComparisonStore;

  @override
  void initState() {
    hideStatusBar();
    createComparisonStore =
        Provider.of<CreateComparisonStore>(context, listen: false);
    double x = SizeConfig.screenHeight / 10;
    imageWidth = (3 * (x)) - (SizeConfig.blockSizeVertical * 2);
    imageHeight = SizeConfig.screenWidth - x;
    super.initState();
  }

  @override
  void dispose() async {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await navigateBack();
        return;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(),
                  LargeImageTile(
                      width: imageWidth, height: SizeConfig.screenWidth),
                  LargeImageTile(
                      width: imageWidth, height: SizeConfig.screenWidth),
                  LargeImageTile(
                      width: imageWidth, height: SizeConfig.screenWidth),
                  SideActionBarHorizontal(
                    photoHeight: imageHeight / 3,
                    photoWidth: imageWidth / 3,
                  ),
                ],
              ),
              PositionedDirectional(
                  top: 10,
                  start: 10,
                  child: IconButton(
                    icon: Icon(
                      Icons.share_rounded,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      List<AssetEntity> favorites =
                          Provider.of<CreateComparisonStore>(context,
                                  listen: false)
                              .favoriteAssetEntities;
                      if (favorites.isNotEmpty) {
                        shareWithOtherApps(favorites);
                      } else {
                        Dialogs.showDialogWithOkayButton(
                            context, "Please favorite any image first");
                      }
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }

  navigateBack() async {
    createComparisonStore.clearStore();
    setState(() {});
    await setOrientationVertical();
    Navigator.pop(context);
  }

  hideStatusBar() async {
    await SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    setOrientationHorizontal();

  }
}
