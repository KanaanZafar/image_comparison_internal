import 'package:photo_manager/photo_manager.dart';

class Album {
  String albumName;
  List<AssetEntity> photosInAlbum;

  Album({this.albumName, this.photosInAlbum});
}
