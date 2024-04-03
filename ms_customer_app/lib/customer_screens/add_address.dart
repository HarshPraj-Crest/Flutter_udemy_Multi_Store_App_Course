 import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ms_customer_app/auth/widgets_auth/customer_signin_text.dart';
import 'package:ms_customer_app/widgets/appbar_title.dart';
import 'package:ms_customer_app/widgets/snackbar.dart';
import 'package:ms_customer_app/widgets/yellow_button.dart';
import 'package:uuid/uuid.dart';

class AddAddress extends StatefulWidget {
  const AddAddress({super.key});

  @override
  State<AddAddress> createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  late String firstName;
  late String lastName;
  late String phone;
  String countryValue = 'Choose Country';
  String stateValue = 'Choose State';
  String cityValue = 'Choose City';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const AppBarTitle(title: 'Add Address'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 30, 30, 10),
                child: Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Pleae enter your first name';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            firstName = value!;
                          },
                          decoration: CustomerSignInText()
                              .buildInputDecoration()
                              .copyWith(
                                labelText: 'First Name',
                                hintText: 'Enter your first name',
                              ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Pleae enter your last name';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            lastName = value!;
                          },
                          decoration: CustomerSignInText()
                              .buildInputDecoration()
                              .copyWith(
                                labelText: 'Last Name',
                                hintText: 'Enter your last name',
                              ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Pleae enter your phone no.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            phone = value!;
                          },
                          decoration: CustomerSignInText()
                              .buildInputDecoration()
                              .copyWith(
                                labelText: 'Phone No.',
                                hintText: 'Enter your phone no.',
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SelectState(
                onCountryChanged: (value) {
                  setState(() {
                    countryValue = value;
                  });
                },
                onStateChanged: (value) {
                  setState(() {
                    stateValue = value;
                  });
                },
                onCityChanged: (value) {
                  setState(() {
                    cityValue = value;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.all(22),
                child: Center(
                  child: YellowButton(
                    label: 'Add New Address',
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (countryValue != 'Choose Country' &&
                            stateValue != 'Choose State' &&
                            cityValue != 'Choose City') {
                          _formKey.currentState!.save();
                          CollectionReference addressRef = FirebaseFirestore
                              .instance
                              .collection('customers')
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .collection('address');
                          var addressId = const Uuid().v4();
                          await addressRef.doc(addressId).set({
                            'addressid': addressId,
                            'firstname': firstName,
                            'lastname': lastName,
                            'phone': phone,
                            'country': countryValue,
                            'state': stateValue,
                            'city': cityValue,
                            'default': true,
                          }).whenComplete(() => Navigator.of(context).pop());
                        } else {
                          MyMessageHandler.showSnackbar(
                              _scaffoldKey, 'Please set your location');
                        }
                      } else {
                        MyMessageHandler.showSnackbar(
                            _scaffoldKey, 'Please fill all fields');
                      }
                    },
                    width: 0.8,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
