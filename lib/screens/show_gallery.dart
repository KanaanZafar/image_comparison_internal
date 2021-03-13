import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_comparison/blocs/show_gallery/show_gallery_bloc.dart';
import 'package:image_comparison/components/dialogs.dart';
import 'package:image_comparison/components/small_image_tile.dart';
import 'package:image_comparison/screens/create_comparison/four_photos_comparison.dart';
import 'package:image_comparison/screens/create_comparison/two_photos_comparison.dart';
import 'package:image_comparison/stores/create_comparison_store.dart';
import 'package:image_comparison/utils/ad_ids.dart';
import 'package:image_comparison/utils/constants.dart';
import 'package:image_comparison/utils/iFavorites_colors.dart';
import 'package:image_comparison/utils/interstatial.dart';
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
    InterstatialAd.admobInterstitial =
        AdmobInterstitial(adUnitId: AdIds.interstatialAdId);
    InterstatialAd.admobInterstitial.load();
    createComparisonStore =
        Provider.of<CreateComparisonStore>(context, listen: false);
    showGalleryBloc = ShowGalleryBloc();
    showGalleryBloc.add(FetchGalleryPhotos());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
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
            if(state is PaymentMessageState){
              return failureView(state.message);
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
                  "${Constants.iFavorites}",
                  style: TextStyle(color: Colors.white),
                ),
                automaticallyImplyLeading: false,
                backgroundColor: IfavoirtesColors.primaryColor,
                centerTitle: true,
                actions: [
                  IconButton(
                    icon: Icon(
                      Icons.share,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      shareApp();
                    },
                  )
                ],
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
        Container(
          color: Colors.grey,
          child: AdmobBanner(
              adUnitId: AdIds.bannerAdId,
              adSize: AdmobBannerSize.ADAPTIVE_BANNER(
                  width: SizeConfig.screenWidth.toInt())),
        ),
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
    showGalleryBloc.add(FetchGalleryPhotos());
    setState(() {});
  }
}
