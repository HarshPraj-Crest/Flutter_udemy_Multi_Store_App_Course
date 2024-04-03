import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// class FollowingProvider extends ChangeNotifier {
//   List<String> _followedStores = [];

//   List<String> get followedStores => _followedStores;

//    bool isFollowing(String storeId) {
//     return _followedStores.contains(storeId);
//   }

//   void setFollowing(String storeId) {
//     _followedStores.add(storeId);
//     notifyListeners();
//   }

//   void setNotFollowing(String storeId) {
//     _followedStores.remove(storeId);
//     notifyListeners();
//   +-}
// }

class FollowingProvider extends ChangeNotifier {
  final SharedPreferences prefs;

  FollowingProvider({required this.prefs});

  // Method to check if the user is following a store
  bool isFollowing(String storeId) {
    return prefs.getBool(storeId) ?? false;
  }

  // Method to set following state for a store
  void setFollowing(String storeId) {
    prefs.setBool(storeId, true);
    notifyListeners();
  }

  // Method to set not following state for a store
  void setNotFollowing(String storeId) {
    prefs.setBool(storeId, false);
    notifyListeners();
  }

  // void clearFollowedStores() {
  //   // Get all keys
  //   List<String> keys = prefs.getKeys().toList();

  //   // Filter and remove keys related to followed stores
  //   keys.forEach((key) {
  //     if (key.startsWith('followed_store_')) {
  //       prefs.remove(key);
  //     }
  //   });

  //   // Notify listeners after clearing data
  //   notifyListeners();
  // }
}
