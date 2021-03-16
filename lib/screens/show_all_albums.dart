import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_comparison/blocs/show_gallery/show_gallery_bloc.dart';

class ShowAllAlbumsScreen extends StatefulWidget {
  @override
  _ShowAllAlbumsScreenState createState() => _ShowAllAlbumsScreenState();
}

class _ShowAllAlbumsScreenState extends State<ShowAllAlbumsScreen> {
  @override
  ShowGalleryBloc showGalleryBloc;

  @override
  void initState() {
    showGalleryBloc = BlocProvider.of<ShowGalleryBloc>(context);
    showGalleryBloc.add(FetchAllAlbums());
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer(
        cubit: showGalleryBloc,
        listener: (context, state) {},
        builder: (context, state) {
          if (state is FetchingGalleryPhotos) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is AllAlbumsFetched) {
            if (state.assetPathEntities.isEmpty) {
              return Center(
                child: Text("No album found"),
              );
            }
            return Container(
              color: Colors.red,
            );
          }
        },
      ),
    );
  }
}
