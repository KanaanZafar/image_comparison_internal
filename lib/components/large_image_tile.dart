import 'package:flutter/material.dart';
import 'package:image_comparison/screens/show_full_image.dart';
import 'package:image_comparison/stores/create_comparison_store.dart';
import 'package:image_comparison/utils/helper.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_widget/photo_widget.dart';
import 'package:provider/provider.dart';

class LargeImageTile extends StatefulWidget {
  final EdgeInsets edgeInsets;
  final double height;
  final double width;

  LargeImageTile({this.edgeInsets, this.height, this.width});

  @override
  _LargeImageTileState createState() => _LargeImageTileState();
}

class _LargeImageTileState extends State<LargeImageTile> {
  AssetEntity assetEntity;
  CreateComparisonStore createComparisonStore;
  bool isFavorite = false;

  @override
  void initState() {
    createComparisonStore =
        Provider.of<CreateComparisonStore>(context, listen: false);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.edgeInsets ??
          EdgeInsets.zero, //EdgeInsets.symmetric(horizontal: 1, vertical: 2),
      child: DragTarget(
        builder: (context, data, rejectedData) {
          return assetEntity == null
              ? Container(
                  width: widget.width,
                  height: widget.height,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black)),
                  child: Center(
                    child: Text(
                      "Drag and drop an image here",
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    showInFullScreen();
                  },
                  child: Container(
                    height: widget.height,
                    width: widget.width,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        FittedBox(
                          fit: BoxFit.contain,
                          child: AssetWidget(
                            asset: assetEntity,
                            thumbSize: 2000,
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                  icon: Icon(
                                    Icons.close_sharp,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    createComparisonStore.temporarilyDeleted
                                        .add(assetEntity);
                                    createComparisonStore.acceptedEntities
                                        .removeWhere((element) =>
                                            assetEntity.id == element.id);
                                    createComparisonStore.assetEntities
                                        .removeWhere((element) =>
                                            element.id == assetEntity.id);
                                    assetEntity = null;
                                    setState(() {});
                                  }),
                              IconButton(
                                  icon: Icon(
                                    createComparisonStore.favoriteAssetEntities
                                                .indexWhere((element) =>
                                                    element.id ==
                                                    assetEntity.id) <
                                            0
                                        ? Icons.favorite_border
                                        : Icons.favorite,
                                    color: Colors.pink,
                                  ),
                                  onPressed: () {
                                    int assetIndex = createComparisonStore
                                        .favoriteAssetEntities
                                        .indexWhere((element) =>
                                            element.id == assetEntity.id);
                                    if (assetIndex < 0) {
                                      createComparisonStore
                                          .favoriteAssetEntities
                                          .add(assetEntity);
                                    } else {
                                      createComparisonStore
                                          .favoriteAssetEntities
                                          .removeAt(assetIndex);
                                    }

                                    setState(() {});
                                  }),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
        },
        onAccept: (AssetEntity data) {
          if (assetEntity != null) {
            createComparisonStore.acceptedEntities
                .removeWhere((element) => element.id == assetEntity.id);
            createComparisonStore.assetEntities.add(assetEntity);
          }
          setState(() {
            createComparisonStore.acceptAnEntity(data);
            assetEntity = data;
          });
        },
        onWillAccept: (AssetEntity data) {
          return true;
        },
      ),
    );
  }

  showInFullScreen() async {
    if (assetEntity.height >= assetEntity.width) {
      await setOrientationVertical();
    } else {
      await setOrientationHorizontal();
    }
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ShowFullImage(
                  assetEntity: assetEntity,
                )));
  }
}
