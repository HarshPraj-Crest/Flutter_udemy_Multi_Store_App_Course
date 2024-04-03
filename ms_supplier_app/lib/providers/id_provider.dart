import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IdProvider with ChangeNotifier {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  // late Future<String> documentId;
  late String docId;
  static String _customerId = '';

  String get getData {
    return _customerId;
  }

  setCustomerId(User user) async {
    final SharedPreferences pref = await _prefs;
    pref
        .setString('customerId', user.uid)
        .whenComplete(() => _customerId = user.uid);
    print('customerId was saved into shared preferences');
    notifyListeners();
  }

  clearCustomerId() async {
    final SharedPreferences pref = await _prefs;
    pref.setString('customerId', '').whenComplete(() => _customerId = '');
    print('customerId was removed from shared preferences');
    notifyListeners();
  }

  Future<String> getDocumentId() {
    return _prefs.then((SharedPreferences prefs) {
      return prefs.getString('customerId') ?? '';
    });
  }

  getDocId () async {
    await getDocumentId().then((value) => _customerId = value);
    notifyListeners();
  }
}
