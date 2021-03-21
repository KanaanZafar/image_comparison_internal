import 'package:flutter/material.dart';
import 'package:image_comparison/components/banner_ad_widget.dart';
import 'package:image_comparison/components/dialogs.dart';
import 'package:image_comparison/components/small_image_tile.dart';
import 'package:image_comparison/models/album.dart';
import 'package:image_comparison/screens/create_comparison/four_photos_comparison.dart';
import 'package:image_comparison/screens/create_comparison/three_photos_comparison.dart';
import 'package:image_comparison/screens/create_comparison/two_photos_comparison.dart';
import 'package:image_comparison/stores/create_comparison_store.dart';
import 'package:image_comparison/utils/helper.dart';
import 'package:image_comparison/utils/iFavorites_colors.dart';
import 'package:image_comparison/utils/size_config.dart';
import 'package:provider/provider.dart';

class PhotosOfAlbum extends StatefulWidget {
  final Album album;

  PhotosOfAlbum({this.album});

  @override
  _PhotosOfAlbumState createState() => _PhotosOfAlbumState();
}

class _PhotosOfAlbumState extends State<PhotosOfAlbum> {
  CreateComparisonStore createComparisonStore;

  @override
  void initState() {
    createComparisonStore =
        Provider.of<CreateComparisonStore>(context, listen: false);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.album.albumName,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: IfavoirtesColors.primaryColor,
        centerTitle: false,
        automaticallyImplyLeading: true,

      ),
      body: Stack(
        children: [
          Container(
            height: SizeConfig.screenHeight,
            child: CustomScrollView(
              slivers: [
                SliverGrid(
                  delegate: SliverChildBuilderDelegate((ctx, index) {
                    return GestureDetector(
                        onTap: () {
                          int assetIndex = createComparisonStore.assetEntities
                              .indexWhere((element) =>
                                  element.id ==
                                  widget.album.photosInAlbum[index].id);
                          if (assetIndex < 0) {
                            createComparisonStore.assetEntities
                                .add(widget.album.photosInAlbum[index]);
                          } else {
                            createComparisonStore.assetEntities
                                .removeAt(assetIndex);
                          }
                          setState(() {});
                        },
                        child: SmallImageTile(
                          widget.album.photosInAlbum[index],
                          isSelected: createComparisonStore.assetEntities
                              .contains(widget.album.photosInAlbum[index]),
                        ));
                  }, childCount: widget.album.photosInAlbum.length),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 2,
                    crossAxisSpacing: 2,
                  ),
                )
              ],
            ),
          ),
          bottomController(),
        ],
      ),
    );
  }

  Widget bottomController() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: SizeConfig.screenWidth,
          color: Colors.black,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /*   IconButton(
                  icon: Container(
                    height: 10,
                    width: 20,
                    color: Colors.yellow,
                  ),
                  onPressed: () {
//                    proceedToComparison(ComparisonType.fourPhotos);
                  }), */
              SizedBox(
                width: 10,
              ),
              IconButton(
                  icon: Container(
                    width: 10,
                    height: 20,
                    color: Colors.orange,
                  ),
                  onPressed: () {
                    proceedToComparison(ComparisonType.threePhotos);
                  }),
              SizedBox(
                width: 10,
              ),
              /* IconButton(
                  icon: Container(
                    width: 10,
                    height: 25,
                    color: Colors.amber,
                  ),
                  onPressed: () {
//                    proceedToComparison(ComparisonType.twoPhotos);
                  }) */
            ],
          ),
        ),
        /* Container(
          height: 50,
          color: Colors.grey,
          child: Center(
              child: Text(
            "Banner ad will be here",
            style: TextStyle(color: Colors.white),
          )),
        ), */
        BannerAdWidget(),
      ],
    );
  }

  proceedToComparison(ComparisonType comparisonType) {
    if (createComparisonStore.assetEntities.length < 2) {
      showDialogWithOkayButton(context, "Please select more than 1 photo");
      return;
    }
    createComparisonStore.updateComparisonType(comparisonType);
    if (comparisonType == ComparisonType.twoPhotos) {
      navigate(TwoPhotosComparison());
    } else if (comparisonType == ComparisonType.threePhotos) {
      navigate(ThreePhotosComparison());
    } else {
      navigate(FourPhotosComparison());
    }
  }

  navigate(Widget widget) async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => widget));
    createComparisonStore.clearStore();
    setState(() {});
  }
}
