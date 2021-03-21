import 'package:flutter/material.dart';
import 'package:image_comparison/models/album.dart';
import 'package:image_comparison/screens/photos_of_album.dart';
import 'package:photo_widget/photo_widget.dart';

class AlbumTile extends StatelessWidget {
  final Album album;

  AlbumTile({this.album});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PhotosOfAlbum(
                      album: album,
                    )));
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          AssetWidget(
            asset: album.photosInAlbum.first,
            thumbSize: 500,
          ),
          PositionedDirectional(
            bottom: 5,
            start: 5,
            child: Text(
              album.albumName,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
