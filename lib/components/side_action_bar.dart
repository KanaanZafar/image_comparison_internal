import 'package:flutter/material.dart';
import 'package:image_comparison/stores/create_comparison_store.dart';
import 'package:image_comparison/utils/size_config.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_widget/photo_widget.dart';
import 'package:provider/provider.dart';
import 'package:image_comparison/utils/helper.dart' as Helper;
import 'package:image_comparison/components/dialogs.dart' as Dialogs;

class SideActionBar extends StatelessWidget {
  final double width;

  SideActionBar({this.width = 150});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: SizeConfig.screenHeight,
      color: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                  icon: Icon(
                    Icons.extension,
                    size: 15,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    saveIntoGallery(
                        Provider.of<CreateComparisonStore>(context,
                                listen: false)
                            .acceptedEntities,
                        context);
                  }),
              IconButton(
                  icon: Icon(
                    Icons.favorite,
                    size: 15,
                    color: Colors.pink,
                  ),
                  onPressed: () {
                    saveIntoGallery(
                        Provider.of<CreateComparisonStore>(context,
                                listen: false)
                            .favoriteAssetEntities,
                        context,
                        message: "No favorite image selected");
                  }),
              IconButton(
                  icon: Icon(
                    Icons.description,
                    size: 15,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    CreateComparisonStore createComparisonStore =
                        Provider.of<CreateComparisonStore>(context,
                            listen: false);
                    createComparisonStore.restoreTemporarilyDeleted();
                  })
            ],
          ),
          Expanded(
              child: ListView.builder(
            itemBuilder: (context, index) {
              return Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Draggable(
                      axis: Axis.horizontal,
                      affinity: Axis.horizontal,
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
                          .assetEntities[index]));
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
