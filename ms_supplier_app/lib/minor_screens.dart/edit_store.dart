import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ms_supplier_app/widgets/appbar_title.dart';
import 'package:ms_supplier_app/widgets/snackbar.dart';
import 'package:ms_supplier_app/widgets/yellow_button.dart';

class EditStore extends StatefulWidget {
  const EditStore({
    super.key,
    required this.data,
  });

  final dynamic data;

  @override
  State<EditStore> createState() => _EditStoreState();
}

class _EditStoreState extends State<EditStore> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  final ImagePicker _picker = ImagePicker();
  XFile? imageLogo;
  XFile? imageCover;
  dynamic _pickedImageError;
  late String storeName;
  late String phone;
  late String storeLogo;
  late String coverImage;
  bool processing = false;

  pickStoreLogo() async {
    try {
      final pickedStoreLogo = await _picker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 300,
        maxWidth: 300,
        imageQuality: 95,
      );
      setState(() {
        imageLogo = pickedStoreLogo;
      });
    } catch (e) {
      setState(() {
        _pickedImageError = e;
      });
      print(_pickedImageError);
    }
  }

  pickStoreCover() async {
    try {
      final pickedStoreCover = await _picker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 300,
        maxWidth: 300,
        imageQuality: 95,
      );
      setState(() {
        imageCover = pickedStoreCover;
      });
    } catch (e) {
      setState(() {
        _pickedImageError = e;
      });
      print(_pickedImageError);
    }
  }

  Future uploadStoreLogo() async {
    if (imageLogo != null) {
      try {
        firebase_storage.Reference ref = firebase_storage
            .FirebaseStorage.instance
            .ref('supp-images/${widget.data['email']}.jpg');

        final metadata =
            firebase_storage.SettableMetadata(contentType: 'image/jpeg');

        await ref.putFile(File(imageLogo!.path), metadata);

        storeLogo = await ref.getDownloadURL();
      } catch (e) {
        print(e);
      }
    } else {
      storeLogo = widget.data['storelogo'];
    }
  }

  Future uploadCoverImage() async {
    if (imageCover != null) {
      try {
        firebase_storage.Reference ref2 = firebase_storage
            .FirebaseStorage.instance
            .ref('supp-images/${widget.data['email']}.jpg-cover');

        final metadata =
            firebase_storage.SettableMetadata(contentType: 'image/jpeg');

        await ref2.putFile(File(imageCover!.path), metadata);

        coverImage = await ref2.getDownloadURL();
      } catch (e) {
        print(e);
      }
    } else {
      coverImage = widget.data['coverimage'];
    }
  }

  editStoreData() async {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('suppliers')
          .doc(FirebaseAuth.instance.currentUser!.uid);
      transaction.update(documentReference, {
        'storename': storeName,
        'phone': phone,
        'storelogo': storeLogo,
        'coverimage': coverImage,
      });
    }).whenComplete(() => Navigator.of(context).pop());
  }

  saveChanges() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      setState(() {
        processing = true;
      });
      await uploadStoreLogo().whenComplete(() async {
        await uploadCoverImage().whenComplete(() => editStoreData());
      });
    } else {
      MyMessageHandler.showSnackbar(_scaffoldKey, 'Please fill all Fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        appBar: AppBar(
          title: const AppBarTitle(title: 'Edit Store'),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Column(
                  children: [
                    const Text(
                      'Store Logo',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage:
                              NetworkImage(widget.data['storelogo']),
                        ),
                        Column(
                          children: [
                            YellowButton(
                              label: 'Change',
                              onPressed: pickStoreLogo,
                              width: 0.25,
                            ),
                            const SizedBox(height: 10),
                            imageLogo == null
                                ? const SizedBox()
                                : YellowButton(
                                    label: 'Reset',
                                    onPressed: () {
                                      setState(() {
                                        imageLogo = null;
                                      });
                                    },
                                    width: 0.25,
                                  ),
                          ],
                        ),
                        imageLogo == null
                            ? const SizedBox()
                            : CircleAvatar(
                                radius: 60,
                                backgroundImage:
                                    FileImage(File(imageLogo!.path)),
                              ),
                      ],
                    ),
                    const Padding(
                        padding: EdgeInsets.all(16),
                        child: Divider(
                          color: Colors.yellow,
                          thickness: 2.5,
                        ))
                  ],
                ),
                Column(
                  children: [
                    const Text(
                      'Store Cover',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage:
                              NetworkImage(widget.data['coverimage']),
                        ),
                        Column(
                          children: [
                            YellowButton(
                              label: 'Change',
                              onPressed: pickStoreCover,
                              width: 0.25,
                            ),
                            const SizedBox(height: 10),
                            imageCover == null
                                ? const SizedBox()
                                : YellowButton(
                                    label: 'Reset',
                                    onPressed: () {
                                      setState(() {
                                        imageCover = null;
                                      });
                                    },
                                    width: 0.25,
                                  ),
                          ],
                        ),
                        imageCover == null
                            ? const SizedBox()
                            : CircleAvatar(
                                radius: 60,
                                backgroundImage:
                                    FileImage(File(imageCover!.path)),
                              ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Divider(
                        color: Colors.yellow,
                        thickness: 2.5,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Enter Store Name';
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      storeName = newValue!;
                    },
                    initialValue: widget.data['storename'],
                    decoration: textFormDecoration.copyWith(
                      labelText: 'Store Name',
                      hintText: 'Enter Store Name',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Enter Phone No.';
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      phone = newValue!;
                    },
                    initialValue: widget.data['phone'],
                    decoration: textFormDecoration.copyWith(
                      labelText: 'Phone',
                      hintText: 'Enter Phone No.',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 22,
                    horizontal: 4,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      YellowButton(
                        label: 'Cancel',
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        width: 0.25,
                      ),
                      processing == true
                          ? YellowButton(
                              label: 'Please wait...',
                              onPressed: () {
                                null;
                              },
                              width: 0.50,
                            )
                          : YellowButton(
                              label: 'Save Changes',
                              onPressed: saveChanges,
                              width: 0.50,
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
