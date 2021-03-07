import 'package:flutter/material.dart';
import 'package:image_comparison/stores/create_comparison_store.dart';
import 'package:image_comparison/utils/size_config.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_widget/photo_widget.dart';
import 'package:provider/provider.dart';
import 'package:image_comparison/utils/helper.dart' as Helper;
import 'package:image_comparison/components/dialogs.dart' as Dialogs;

class SideActionBarHorizontal extends StatelessWidget {
  final double photoWidth;
  final double photoHeight;
  final bool isVertical;
  final double iconSize;

  SideActionBarHorizontal(
      {this.photoHeight,
      this.photoWidth,
      this.isVertical = false,
      this.iconSize = 20});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: photoWidth,
      height: isVertical ? null : SizeConfig.screenHeight,
      color: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                  child: Icon(
                    Icons.extension,
                    size: iconSize,
                    color: Colors.white,
                  ),
                  onTap: () {
                    saveIntoGallery(
                        Provider.of<CreateComparisonStore>(context,
                                listen: false)
                            .acceptedEntities,
                        context);
                  }),
              InkWell(
                  child: Icon(
                    Icons.favorite,
                    size: iconSize,
                    color: Colors.pink,
                  ),
//                  iconSize: iconSize,
                  onTap: () {

                    saveIntoGallery(
                        Provider.of<CreateComparisonStore>(context,
                                listen: false)
                            .favoriteAssetEntities,
                        context,
                        message: "No favorite image selected"); 
                  }),
              InkWell(
                  child: Icon(
                    Icons.description,
                    color: Colors.white,
                    size: iconSize,
                  ),
                  onTap: () {
                    CreateComparisonStore createComparisonStore =
                        Provider.of<CreateComparisonStore>(context,
                            listen: false);
                    createComparisonStore.restoreTemporarilyDeleted();
                  })
            ],
          ),
          Expanded(
              child: ListView.builder(
            scrollDirection: isVertical ? Axis.horizontal : Axis.vertical,
            itemBuilder: (context, index) {
              return Padding(
                  padding: isVertical
                      ? EdgeInsets.symmetric(horizontal: 5)
                      : EdgeInsets.symmetric(vertical: 5),
                  child: Container(
//                    height: photoHeight,
                    width: photoWidth,
                    child: Draggable(
                        axis: isVertical ? null : Axis.horizontal,
                        affinity: isVertical ? Axis.vertical : Axis.horizontal,
                        feedback: AssetWidget(
                            asset: Provider.of<CreateComparisonStore>(context)
                                .assetEntities[index]),
                        child: AssetWidget(
                            asset: Provider.of<CreateComparisonStore>(context)
                                .assetEntities[index]),
                        childWhenDragging: AssetWidget(
                            asset: Provider.of<CreateComparisonStore>(context)
                                .assetEntities[index]),
                        data: Provider.of<CreateComparisonStore>(context,
                                listen: false)
                            .assetEntities[index]),
                  ));
            },
            itemCount: Provider.of<CreateComparisonStore>(context)
                .assetEntities
                .length,
          ))
        ],
      ),
    );
  }

  saveIntoGallery(List<AssetEntity> assetEntities, BuildContext context,
      {String message = 'No image to export'}) async {
    if (assetEntities.isEmpty) {
      Dialogs.showDialogWithOkayButton(context, message);
      return;
    }

    CreateComparisonStore createComparisonStore =
        Provider.of<CreateComparisonStore>(context, listen: false);

    try {
      createComparisonStore.updateIsSaving(true);
      await Helper.saveIntoLocalDirectory(assetEntities);
      createComparisonStore.updateIsSaving(false);
      Dialogs.showDialogWithOkayButton(context, "Images saved successfully");
    } catch (e) {
      print("-------e: ${e.toString()}");
      createComparisonStore.updateIsSaving(false);
      Dialogs.showDialogWithOkayButton(
          context, "error occurred: ${e.toString()}");
    }
  }
}
