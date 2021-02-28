import 'package:flutter/foundation.dart' show ChangeNotifier;
import 'package:photo_manager/photo_manager.dart';

class CreateComparisonStore extends ChangeNotifier {
  List<AssetEntity> _assetEntities = List<AssetEntity>();
  List<AssetEntity> _acceptedEntities = List<AssetEntity>();
  List<AssetEntity> _temporarilyDeleted = List<AssetEntity>();
  List<AssetEntity> _favoriteAssetEntities = List<AssetEntity>();
  bool _isSaving = false;

  List<AssetEntity> get assetEntities {
    return _assetEntities;
  }

  List<AssetEntity> get acceptedEntities {
    return _acceptedEntities;
  }

  List<AssetEntity> get temporarilyDeleted {
    return _temporarilyDeleted;
  }

  List<AssetEntity> get favoriteAssetEntities {
    return _favoriteAssetEntities;
  }

  bool get isSaving {
    return _isSaving;
  }

  acceptAnEntity(AssetEntity assetEntity) {
    _acceptedEntities.add(assetEntity);
    _assetEntities.removeWhere((element) => element.id == assetEntity.id);
    notifyListeners();
  }

  restoreTemporarilyDeleted() {
    for (int i = 0; i < _temporarilyDeleted.length; i++) {
      _assetEntities.add(_temporarilyDeleted[i]);
    }
    _temporarilyDeleted.clear();

    notifyListeners();
  }

  updateIsSaving(bool value) {
    _isSaving = value;
    notifyListeners();
  }
}
