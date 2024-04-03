import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_store_app/utilities/categ_list.dart';
import 'package:multi_store_app/widgets/snackbar.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

class SuppUploadScreen extends StatefulWidget {
  const SuppUploadScreen({super.key});

  @override
  State<SuppUploadScreen> createState() => _SuppUploadScreenState();
}

class _SuppUploadScreenState extends State<SuppUploadScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  late double price;
  late int quantity;
  late String prdName;
  late String prdDescp;
  late String proId;
  int? discount = 0;
  bool isUploading = false;
  List<String> subCategList = [];
  String maincategValue = 'select category';
  String subCategValue = 'subcategory';

  final ImagePicker _picker = ImagePicker();

  List<XFile> imagesFileList = [];
  List<String> imageUrlList = [];
  dynamic _pickedImageError;

  void pickProductImages() async {
    try {
      final pickedImages = await _picker.pickMultiImage(
        maxHeight: 300,
        maxWidth: 300,
        imageQuality: 95,
      );
      setState(() {
        imagesFileList = pickedImages;
      });
    } catch (e) {
      setState(() {
        _pickedImageError = e;
      });
      print(_pickedImageError);
    }
  }

  Widget previewImages() {
    return ListView.builder(
      itemCount: imagesFileList.length,
      itemBuilder: (context, index) {
        return Image.file(File(imagesFileList[index].path));
      },
    );
  }

  void selectMainCateg(String value) {
    print(value);
    if (value == 'select category') {
      subCategList = [];
    } else if (value == 'men') {
      subCategList = men;
    } else if (value == 'women') {
      subCategList = women;
    } else if (value == 'electronics') {
      subCategList = electronics;
    } else if (value == 'accessories') {
      subCategList = accessories;
    } else if (value == 'shoes') {
      subCategList = shoes;
    } else if (value == 'home & garden') {
      subCategList = homeandgarden;
    } else if (value == 'beauty') {
      subCategList = beauty;
    } else if (value == 'kids') {
      subCategList = kids;
    } else if (value == 'bags') {
      subCategList = bags;
    }
    setState(() {
      maincategValue = value;
      subCategValue = 'subcategory';
    });
  }

  Future<void> uploadImages() async {
    if (maincategValue != 'select category' && subCategValue != 'subcategory') {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        if (imagesFileList.isNotEmpty) {
          try {
            for (var image in imagesFileList) {
              firebase_storage.Reference ref = firebase_storage
                  .FirebaseStorage.instance
                  .ref('products/${path.basename(image.path)}');

              final metadata =
                  firebase_storage.SettableMetadata(contentType: 'image/jpg');

              await ref
                  .putFile(File(image.path), metadata)
                  .whenComplete(() async {
                await ref.getDownloadURL().then((value) {
                  imageUrlList.add(value);
                });
              });
            }
          } catch (e) {
            print(e);
          }
        } else {
          setState(() {
            isUploading = false;
          });
          MyMessageHandler.showSnackbar(
              _scaffoldKey, 'Please pick images first');
        }
      } else {
        setState(() {
          isUploading = false;
        });
        MyMessageHandler.showSnackbar(_scaffoldKey, 'Please fill all fields');
      }
    } else {
      setState(() {
        isUploading = false;
      });
      MyMessageHandler.showSnackbar(_scaffoldKey, 'Please fill categories');
    }
  }

  void uploadData() async {
    if (imageUrlList.isNotEmpty) {
      CollectionReference productRef =
          FirebaseFirestore.instance.collection('products');

      proId = const Uuid().v4();

      await productRef.doc(proId).set({
        'proid': proId,
        'maincateg': maincategValue,
        'subcateg': subCategValue,
        'price': price,
        'instock': quantity,
        'prdname': prdName,
        'prddescp': prdDescp,
        'sid': FirebaseAuth.instance.currentUser!.uid,
        'prdimages': imageUrlList,
        'discount': discount,
      }).whenComplete(() {
        setState(() {
          imagesFileList = [];
          maincategValue = 'select category';
          subCategList = [];
          imageUrlList = [];
        });
        isUploading = false;
        _formKey.currentState!.reset();
      });
    } else {
      print('Images not uploaded.');
    }
  }

  void uploadProduct() async {
    setState(() {
      isUploading = true;
    });

    await uploadImages().whenComplete(() {
      uploadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            reverse: true,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        height: size.width * 0.5,
                        width: size.width * 0.5,
                        color: Colors.blueGrey.shade100,
                        child: imagesFileList.isNotEmpty
                            ? previewImages()
                            : const Center(
                                child: Text(
                                  'You have not \n \n picked images yet !',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: SizedBox(
                          height: size.width * 0.45,
                          width: size.width * 0.45,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  const Text(
                                    '* Select main category',
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 16),
                                  ),
                                  DropdownButton(
                                      iconSize: 30,
                                      iconEnabledColor: Colors.red,
                                      dropdownColor: Colors.yellow.shade200,
                                      value: maincategValue,
                                      items: maincateg
                                          .map<DropdownMenuItem<dynamic>>(
                                              (value) {
                                        return DropdownMenuItem(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      onChanged: (dynamic value) {
                                        selectMainCateg(value);
                                      }),
                                ],
                              ),
                              Column(
                                children: [
                                  const Text(
                                    '* Select sub category',
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 16),
                                  ),
                                  DropdownButton(
                                      iconSize: 30,
                                      menuMaxHeight: 500,
                                      hint: const Text('subcategory'),
                                      iconEnabledColor: Colors.red,
                                      iconDisabledColor: Colors.black,
                                      dropdownColor: Colors.yellow.shade200,
                                      value: subCategValue,
                                      items: subCategList
                                          .map<DropdownMenuItem<dynamic>>(
                                              (value) {
                                        return DropdownMenuItem(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      onChanged: (dynamic value) {
                                        print(value);
                                        setState(() {
                                          subCategValue = value;
                                        });
                                      }),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(
                    color: Colors.yellow,
                    thickness: 2,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.38,
                          child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Pleae enter price';
                                } else if (value.isValidPrice() != true) {
                                  return 'Invalid price';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                price = double.parse(value!);
                              },
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              decoration: textFormDecoration.copyWith(
                                labelText: 'price',
                                hintText: 'price .. \$',
                              )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.38,
                          child: TextFormField(
                              maxLength: 2,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return null;
                                } else if (value.isValidDiscount() != true) {
                                  return 'Invalid discount';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                discount = int.parse(value!);
                              },
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              decoration: textFormDecoration.copyWith(
                                labelText: 'discount',
                                hintText: 'discount .. %',
                              )),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Pleae enter quantity';
                            } else if (value.isValidQuantity() != true) {
                              return 'Please enter valid quantity';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            quantity = int.parse(value!);
                          },
                          keyboardType: TextInputType.number,
                          decoration: textFormDecoration.copyWith(
                            labelText: 'Quantity',
                            hintText: 'Add Quantity',
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Pleae enter product name';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            prdName = value!;
                          },
                          maxLength: 100,
                          maxLines: 3,
                          decoration: textFormDecoration.copyWith(
                            labelText: 'Product name',
                            hintText: 'Enter product name',
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Pleae enter product description';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            prdDescp = value!;
                          },
                          maxLength: 800,
                          maxLines: 5,
                          decoration: textFormDecoration.copyWith(
                            labelText: 'Product description',
                            hintText: 'Enter product description',
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: FloatingActionButton(
                shape: const CircleBorder(),
                onPressed: isUploading
                    ? null
                    : imagesFileList.isEmpty
                        ? pickProductImages
                        : () {
                            setState(() {
                              imagesFileList = [];
                            });
                          },
                backgroundColor: Colors.yellow,
                child: Icon(
                  imagesFileList.isEmpty
                      ? Icons.photo_library
                      : Icons.delete_forever,
                  color: Colors.black,
                ),
              ),
            ),
            isUploading
                ? const FloatingActionButton(
                    shape: CircleBorder(),
                    onPressed: null,
                    backgroundColor: Colors.yellow,
                    child: CircularProgressIndicator(color: Colors.black),
                  )
                : FloatingActionButton(
                    shape: const CircleBorder(),
                    onPressed: uploadProduct,
                    backgroundColor: Colors.yellow,
                    child: const Icon(
                      Icons.upload,
                      color: Colors.black,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

var textFormDecoration = InputDecoration(
  labelText: 'price',
  hintText: 'price .. \$',
  labelStyle: TextStyle(color: Colors.purple.shade900),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(color: Colors.yellow, width: 1),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
  ),
);

extension QuantityValidator on String {
  bool isValidQuantity() {
    return RegExp(r'^[1-9][0-9]*$').hasMatch(this);
  }
}

extension PriceValidator on String {
  bool isValidPrice() {
    return RegExp(r'^\d+(\.\d{1,2})?$').hasMatch(this);
  }
}

extension DiscountValidator on String {
  bool isValidDiscount() {
    return RegExp(r'^([0-9]*)$').hasMatch(this);
  }
}
