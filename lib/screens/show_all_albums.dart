import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_comparison/blocs/show_gallery/show_gallery_bloc.dart';
import 'package:image_comparison/components/album_tile.dart';
import 'package:image_comparison/components/banner_ad_widget.dart';
import 'package:image_comparison/models/album.dart';
import 'package:image_comparison/utils/ad_ids.dart';
import 'package:image_comparison/utils/constants.dart';
import 'package:image_comparison/utils/helper.dart';
import 'package:image_comparison/utils/iFavorites_colors.dart';
import 'package:image_comparison/utils/interstatial.dart';
import 'package:image_comparison/utils/size_config.dart';

class ShowAllAlbumsScreen extends StatefulWidget {
  @override
  _ShowAllAlbumsScreenState createState() => _ShowAllAlbumsScreenState();
}

class _ShowAllAlbumsScreenState extends State<ShowAllAlbumsScreen> {
  @override
  ShowGalleryBloc showGalleryBloc;

  @override
  void initState() {
    showGalleryBloc = ShowGalleryBloc();
    showGalleryBloc.add(FetchAllAlbums());

    super.initState();
  }

  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Constants.iFavorites,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: IfavoirtesColors.primaryColor,
        centerTitle: true,
        automaticallyImplyLeading: false,
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
      body: BlocConsumer(
        cubit: showGalleryBloc,
        listener: (context, state) {},
        builder: (context, state) {
          if (state is FetchingGalleryPhotos) {
            return Center(
              child: CupertinoActivityIndicator(),
            );
          }
          if (state is AllAlbumsFetched) {
            if (state.albums.isEmpty) {
              return Center(
                child: Text("No album found"),
              );
            }
            return photosFoundState(state.albums);
          }
          if (state is PaymentMessageState) {
            return Center(
              child: Text(
                state.message,
                style: TextStyle(color: Colors.black),
              ),
            );
          }
          return Center(child: Text(""));
        },
      ),
    );
  }

  Widget photosFoundState(List<Album> albums) {
    return Stack(
      children: [
        Container(
          height: SizeConfig.screenHeight,
          child: CustomScrollView(
            slivers: [
              SliverGrid(
                delegate: SliverChildBuilderDelegate((context, index) {
                  Album album = albums[index];
                  return AlbumTile(
                    album: album,
                  );
                }, childCount: albums.length),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 2,
                  crossAxisSpacing: 2,
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  height: 60,
                  color: Colors.transparent,
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: BannerAdWidget(),
        )
      ],
    );
  }
}
