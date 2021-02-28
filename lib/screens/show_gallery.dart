import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_comparison/blocs/show_gallery/show_gallery_bloc.dart';
import 'package:image_comparison/components/dialogs.dart';
import 'package:image_comparison/components/small_image_tile.dart';
import 'package:image_comparison/stores/create_comparison_store.dart';
import 'package:image_comparison/utils/size_config.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:image_comparison/utils/helper.dart';
import 'package:image_comparison/screens/create_comparison/three_photos_comparison.dart';

class ShowGalleryScreen extends StatefulWidget {
  @override
  _ShowGalleryScreenState createState() => _ShowGalleryScreenState();
}

class _ShowGalleryScreenState extends State<ShowGalleryScreen> {
  ShowGalleryBloc showGalleryBloc;
  CreateComparisonStore createComparisonStore;

  @override
  void initState() {
    createComparisonStore =
        Provider.of<CreateComparisonStore>(context, listen: false);
    showGalleryBloc = ShowGalleryBloc();
    showGalleryBloc.add(FetchGalleryPhotos());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener(
        cubit: showGalleryBloc,
        listener: (context, state) {},
        child: BlocBuilder(
          cubit: showGalleryBloc,
          builder: (context, state) {
            if (state is FetchingGalleryPhotos) {
              return loadingView();
            }
            if (state is GalleryPhotosFetched) {
              return photosFetchedView(state.assetEntites);
            }
            if (state is PermissionNotGranted) {
              return permissionNotGranted();
            }
            if (state is FailureState) {
              return failureView(state.error);
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget loadingView() {
    return Center(child: CupertinoActivityIndicator());
  }

  Widget photosFetchedView(List<AssetEntity> assetEntities) {
    if (assetEntities.isEmpty) {
      return Center(
        child: Text("No Photos Found"),
      );
    }
    return Stack(
      children: [
        Container(
          height: SizeConfig.screenHeight,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                title: Text(
                  "Select any images",
                  style: TextStyle(color: Colors.black),
                ),
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
              ),
              SliverGrid(
                delegate: SliverChildBuilderDelegate((ctx, index) {
                  return GestureDetector(
                      onTap: () {
                        int assetIndex = createComparisonStore.assetEntities
                            .indexWhere((element) =>
                                element.id == assetEntities[index].id);
                        if (assetIndex < 0) {
                          createComparisonStore.assetEntities
                              .add(assetEntities[index]);
                        } else {
                          createComparisonStore.assetEntities
                              .removeAt(assetIndex);
                        }
                        setState(() {});
                      },
                      child: SmallImageTile(
                        assetEntities[index],
                        isSelected: createComparisonStore.assetEntities
                            .contains(assetEntities[index]),
                      ));
                }, childCount: assetEntities.length),
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
    );
  }

  Widget permissionNotGranted() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Please Grant Permission First"),
          SizedBox(
            height: 10,
          ),
          RaisedButton(
            onPressed: () {
              showGalleryBloc.add(FetchGalleryPhotos());
            },
            child: Text("Retry"),
          ),
        ],
      ),
    );
  }

  Widget failureView(String error) {
    return Center(
      child: Text(error),
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
              IconButton(
                  icon: Container(
                    height: 5,
                    width: 10,
                    color: Colors.yellow,
                  ),
                  onPressed: () {
                    proceedToComparison(ComparisonType.fourPhotos);
                  }),
              SizedBox(
                width: 10,
              ),
              IconButton(
                  icon: Container(
                    width: 5,
                    height: 10,
                    color: Colors.orange,
                  ),
                  onPressed: () {}),
              SizedBox(
                width: 10,
              ),
              IconButton(
                  icon: Container(
                    width: 5,
                    height: 15,
                    color: Colors.amber,
                  ),
                  onPressed: () {})
            ],
          ),
        ),
        Container(
          height: 50,
          color: Colors.grey,
          child: Center(
              child: Text(
            "Banner ad will be here",
            style: TextStyle(color: Colors.white),
          )),
        ),
      ],
    );
  }

  proceedToComparison(ComparisonType comparisonType) {
    if (createComparisonStore.assetEntities.length < 2) {
      showDialogWithOkayButton(context, "Please select more than 1 photo");
      return;
    }
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ThreePhotosComparison();
    }));
  }
}
