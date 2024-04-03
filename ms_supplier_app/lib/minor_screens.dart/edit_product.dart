import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ms_supplier_app/utilities/categ_list.dart';
import 'package:ms_supplier_app/widgets/red_button.dart';
import 'package:ms_supplier_app/widgets/snackbar.dart';
import 'package:ms_supplier_app/widgets/yellow_button.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;

class EditProduct extends StatefulWidget {
  const EditProduct({
    super.key,
    required this.items,
  });

  final dynamic items;

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
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
  String maincategValue = '';
  String subCategValue = '';

  final ImagePicker _picker = ImagePicker();

  List<XFile> imagesFileList = [];
  List<dynamic> imageUrlList = [];
  dynamic _pickedImageError;

  @override
  void initState() {
    super.initState();
    // Initialize maincategValue and subCategValue with current values
    maincategValue = widget.items['maincateg'];
    subCategValue = widget.items['subcateg'];
    // Call method to set subcategory list based on main category
    selectMainCateg(maincategValue);
  }

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
    if (imagesFileList.isNotEmpty) {
      return ListView.builder(
          itemCount: imagesFileList.length,
          itemBuilder: (context, index) {
            return Image.file(File(imagesFileList[index].path));
          });
    } else {
      return const Center(
        child: Text('you have not \n \n picked images yet !',
            textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
      );
    }
  }

  Widget previewCurrentImages() {
    List<dynamic> itemImages = widget.items['prdimages'];
    return ListView.builder(
      itemCount: itemImages.length,
      itemBuilder: (context, index) {
        return Image.network(itemImages[index].toString());
      },
    );
  }

  void selectMainCateg(String? value) {
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
      maincategValue = value!;
      // Update subCategValue only if it's not 'subcategory'
      if (subCategList.contains(subCategValue)) {
        // If the current subcategory value is valid for the new main category, keep it
        subCategValue = subCategValue;
      } else {
        // Otherwise, reset it to 'subcategory'
        subCategValue = 'subcategory';
      }
    });
  }

  Future uploadImages() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (imagesFileList.isNotEmpty) {
        if (maincategValue != 'select category' &&
            subCategValue != 'subcategory') {
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
          MyMessageHandler.showSnackbar(_scaffoldKey, 'Please fill categories');
        }
      } else {
        imageUrlList = widget.items['prdimages'];
      }
    } else {
      MyMessageHandler.showSnackbar(_scaffoldKey, 'Please fill all fields');
    }
  }

  editProductData() async {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('products')
          .doc(widget.items['proid']);
      transaction.update(documentReference, {
        'maincateg': maincategValue,
        'subcateg': subCategValue,
        'price': price,
        'instock': quantity,
        'prdname': prdName,
        'prddescp': prdDescp,
        'prdimages': imageUrlList,
        'discount': discount,
      });
    }).whenComplete(() => Navigator.of(context).pop());
  }

  saveChanges() async {
    await uploadImages().whenComplete(() => editProductData());
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
              child: Padding(
                padding: const EdgeInsets.fromLTRB(2, 2, 2, 26),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              height: size.width * 0.5,
                              width: size.width * 0.5,
                              color: Colors.blueGrey.shade100,
                              child: previewCurrentImages(),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: SizedBox(
                                height: size.width * 0.45,
                                width: size.width * 0.45,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      children: [
                                        const Text(
                                          'Main category',
                                          style: TextStyle(
                                              color: Colors.red, fontSize: 16),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.all(8),
                                          padding: const EdgeInsets.all(8),
                                          constraints: BoxConstraints(
                                              minWidth: size.width * 0.3),
                                          decoration: BoxDecoration(
                                              color: Colors.yellow,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Center(
                                            child: Text(
                                              widget.items['maincateg'],
                                              style:
                                                  const TextStyle(fontSize: 18),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        const Text(
                                          'Sub category',
                                          style: TextStyle(
                                              color: Colors.red, fontSize: 16),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.all(8),
                                          padding: const EdgeInsets.all(8),
                                          constraints: BoxConstraints(
                                              minWidth: size.width * 0.3),
                                          decoration: BoxDecoration(
                                              color: Colors.yellow,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Center(
                                            child: Text(
                                              widget.items['subcateg'],
                                              style:
                                                  const TextStyle(fontSize: 18),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        ExpandablePanel(
                          header: const Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              'Change Images/Category',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          collapsed: const SizedBox(),
                          expanded: changeImages(size),
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
                                initialValue:
                                    widget.items['price'].toStringAsFixed(2),
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
                                initialValue:
                                    widget.items['discount'].toString(),
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
                            initialValue: widget.items['instock'].toString(),
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
                            initialValue: widget.items['prdname'].toString(),
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
                            initialValue: widget.items['prddescp'].toString(),
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
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            YellowButton(
                              label: 'Cancel',
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              width: 0.25,
                            ),
                            YellowButton(
                              label: 'Save Changes',
                              onPressed: () {
                                saveChanges();
                              },
                              width: 0.50,
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: RedButton(
                              label: 'Delete Item',
                              onPressed: () async {
                                await FirebaseFirestore.instance
                                    .runTransaction((transaction) async {
                                  DocumentReference documentReference =
                                      FirebaseFirestore.instance
                                          .collection('products')
                                          .doc(widget.items['proid']);
                                  transaction.delete(documentReference);
                                }).whenComplete(
                                        () => Navigator.of(context).pop());
                              },
                              width: 0.9),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget changeImages(Size size) {
    return Column(
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
                          style: TextStyle(color: Colors.red, fontSize: 16),
                        ),
                        DropdownButton(
                            iconSize: 30,
                            iconEnabledColor: Colors.red,
                            dropdownColor: Colors.yellow.shade200,
                            value: maincategValue,
                            items: maincateg
                                .map<DropdownMenuItem<dynamic>>((value) {
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
                          style: TextStyle(color: Colors.red, fontSize: 16),
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
                                .map<DropdownMenuItem<dynamic>>((value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (dynamic value) {
                              print(value);
                              setState(() {
                                subCategValue = value.toString();
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
        Padding(
          padding: const EdgeInsets.all(12),
          child: imagesFileList.isNotEmpty
              ? YellowButton(
                  label: 'Reset',
                  onPressed: () {
                    setState(() {
                      imagesFileList = [];
                    });
                  },
                  width: 0.6,
                )
              : YellowButton(
                  label: 'Change Images',
                  onPressed: () {
                    pickProductImages();
                  },
                  width: 0.6,
                ),
        ),
      ],
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
