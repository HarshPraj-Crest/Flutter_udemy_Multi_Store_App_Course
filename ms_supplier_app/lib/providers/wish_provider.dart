import 'package:flutter/material.dart';
import 'package:ms_supplier_app/providers/provider_class.dart';

class Wish extends ChangeNotifier {
  final List<Product> _list = [];
  List<Product> get getWishItems {
    return _list;
  }

   int get count {
    return _list.length;
  }

  Future<void> addWishItem(
    String name,
    double price,
    int qty,
    int qunty,
    String imagesUrl,
    String documentId,
    String suppId,
    
  ) async {
    final product = Product(
      name: name,
      price: price,
      qty: qty,
      qunty: qunty,
      imagesUrl: imagesUrl,
      documentId: documentId,
      suppId: suppId,
    );
    _list.add(product);
    notifyListeners();
  }

  void removeItem(Product product) {
    _list.remove(product);
    notifyListeners();
  }

  void clearWishlist() {
    _list.clear();
    notifyListeners();
  }

  void removeWishItem (String id) {
    _list.removeWhere((element) => element.documentId == id);
    notifyListeners(); 
  }
}
