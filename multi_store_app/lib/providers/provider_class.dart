class Product {
  String documentId;
  String name;
  double price;
  int qty = 1;
  int qunty;
  String imagesUrl;
  String suppId;
  Product({
    required this.documentId,
    required this.name,
    required this.price,
    required this.qty,
    required this.qunty,
    required this.imagesUrl,
    required this.suppId,
  });

  void increase() {
    qty ++;
  }

  void decrease() {
    qty --;
  }

  Map<String, dynamic> toMap() {
    return {
      'documentId': documentId,
      'name': name,
      'price': price,
      'qty': qty,
      'qunty': qunty,
      'imageUrl': imagesUrl,
      'suppId': suppId
    };
  }

  @override
  String toString() {
    return 'Product(name: $name, price: $price, qty: $qty, qunty: $qunty, imageUrl: $imagesUrl)';
  }
}