// ignore_for_file: avoid_print

import 'package:ms_supplier_app/providers/provider_class.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class SQLHelper {
  /////////////////////////////////
  ///////// GET DATABSE //////////
  ///////////////////////////////
  static Database? _database;
  static get getDatabase async {
    if (_database != null) return _database;
    _database = await initDatabase();
    return _database;
  }

  //////////////////////////////////////////////
  //////////// INITIALIZE DATABASE ////////////
//////////////////////////////////////////////
//////////// CREATE & UPGRADE ///////////////

  static Future<Database> initDatabase() async {
    String path = p.join(await getDatabasesPath(), 'shopping_database.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  static Future _onCreate(Database db, int verstion) async {
    Batch batch = db.batch();
    batch.execute('''
CREATE TABLE cart_items (
  documentId TEXT PRIMARY KEY,
  name TEXT,
  price DOUBLE,
  qty INTEGER,
  qunty INTEGER,
  imageUrl TEXT,
  suppId TEXT
)
''');

    batch.execute('''
CREATE TABLE wish_items (
  documentId TEXT PRIMARY KEY,
  name TEXT,
  price DOUBLE,
  qty INTEGER,
  qunty INTEGER,
  imageUrl TEXT,
  suppId TEXT
)
''');
    batch.commit();

    print('on create was called');
  }

  //////////////////////////////////////////////
  /////// INSERT DATA INTO DATABASE ///////////
//////////////////////////////////////////////
  static Future insertItem(Product product) async {
    Database db = await getDatabase;

    await db.insert(
      'cart_items',
      product.toMap(),
    );

    print(await db.query('cart_items'));
  }

  // static Future insertWishItem(Product product) async {
  //   Database db = await getDatabase;

  //   await db.insert(
  //     'wish_items',
  //     product.toMap(),
  //   );

  //   print(await db.query('wish_items'));
  // }


  //////////////////////////////////////////////////////
  /////////////// RETREIVE DATA FROM DATABASE /////////
//////////////////////////////////////////////////////
  static Future<List<Map>> loadItems() async {
    Database db = await getDatabase;
    return await db.query('cart_items');
  }

  //////////////////////////////////////////////////////
  /////////////// UPDATE DATA IN DATABASE /////////////
//////////////////////////////////////////////////////

  static Future updateItem(Product newProduct, String status) async {
    Database db = await getDatabase;
    await db.rawUpdate('UPDATE cart_items SET qty = ? WHERE documentId = ?', [
      status == 'increment' ? newProduct.qty + 1 : newProduct.qty - 1,
      newProduct.documentId
    ]);
  }

  //////////////////////////////////////////////////////
  //////////////// DELETE DATA FROM DATABASE //////////
  ////////////////////////////////////////////////////

  static Future deleteItem(String id) async {
    Database db = await getDatabase;
    await db.delete('cart_items', where: 'documentId = ?', whereArgs: [id]);
  }

  static Future deleteAllItems() async {
    Database db = await getDatabase;
    await db.rawDelete('DELETE FROM cart_items');
  }

  // static Future deleteWishItem(String id) async {
  //   Database db = await getDatabase;
  //   await db.delete('wish_items', where: 'documentId = ?', whereArgs: [id]);
  // }

  // static Future deleteAllWishItems() async {
  //   Database db = await getDatabase;
  //   await db.rawDelete('DELETE FROM wish_items');
  // }
}
