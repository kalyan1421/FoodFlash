import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart'; // Temporarily disabled
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:uber_eats/dash_screen.dart';

class Other_PickLocation extends StatefulWidget {
  Other_PickLocation({Key? key}) : super(key: key);

  static final kInitialPosition = LatLng(-33.8567844, 151.213108);

  final GoogleMapsFlutterPlatform mapsImplementation =
      GoogleMapsFlutterPlatform.instance;

  @override
  _Other_PickLocationState createState() => _Other_PickLocationState();
}

class _Other_PickLocationState extends State<Other_PickLocation> {
  String? selectedPlace; // Simplified version for temporary fix
  String placeId = '';
  bool _mapsInitialized = false;

  final TextEditingController houseNumberController = TextEditingController();
  final TextEditingController FloornumberController = TextEditingController();
  final TextEditingController apartmentNameController = TextEditingController();
  final TextEditingController HowreachController = TextEditingController();
  final TextEditingController phonenumberController = TextEditingController();

  final TextEditingController cityController = TextEditingController();
  String addressType = 'Home';
  void initRenderer() {
    if (_mapsInitialized) return;
    setState(() {
      _mapsInitialized = true;
    });
  }
  // @override
  // void initState() {
  //   super.initState();
  //   User? user = FirebaseAuth.instance.currentUser;
  // }

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Country selectedCountry = Country(
    phoneCode: "91",
    countryCode: "IN",
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: "India",
    example: "India",
    displayName: "India",
    displayNameNoCountryCode: "IN",
    e164Key: "",
  );
  String phonenumber = "";
  bool _isLoading = false;

  void _saveAddressToFirebase(String phonenumber) async {
    if (selectedPlace == null) {
      print("Error: No place selected");
      return;
    }
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      User? user = FirebaseAuth.instance.currentUser;
      if (user != null && selectedPlace != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('addresses')
            .add({
          'addressType': addressType,
          'latitude': 0.0, // Placeholder - place picker disabled
          'longitude': 0.0, // Placeholder - place picker disabled
          'formattedAddress': cityController.text,
          'houseNumber': houseNumberController.text,
          'floorNumber': FloornumberController.text,
          'apartmentName': apartmentNameController.text,
          'howToReach': HowreachController.text,
          'phoneNumber': phonenumber,
          'createdAt': FieldValue.serverTimestamp(),
        });

        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => Dash_board(selectindex: 0)));
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // PlacePicker temporarily disabled - using basic map instead
          Container(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_on, size: 64, color: Colors.red),
                  SizedBox(height: 16),
                  Text(
                    'Place Picker temporarily disabled',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Please enter address manually below',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ),
          // if (selectedPlace != null) // Temporarily disabled
            DraggableScrollableSheet(
              initialChildSize: 0.3,
              minChildSize: 0.1,
              maxChildSize: 0.9,
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              // height: 60,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Location Details:",
                                    style: TextStyle(
                                        fontSize: 22,
                                        color: Colors.black,
                                        fontFamily: "Quicksand-Bold",
                                        fontWeight: FontWeight.bold),
                                  ),
                                  InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectedPlace = null;
                                        });
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: 80,
                                        height: 35,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: const Color.fromRGBO(
                                                    0, 0, 0, 0.451),
                                                width: 1.5),
                                            // color: Colors.grey,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Text(
                                          "Change ",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                              fontFamily: "Quicksand-Bold",
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ))
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              cityController.text,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontFamily: "Quicksand-Bold",
                                  fontWeight: FontWeight.w400),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "House /Flat number",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontFamily: "Quicksand-Bold",
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5),
                            TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter house number';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: "House number",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 10.0),
                              ),
                              controller: houseNumberController,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Floor number",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontFamily: "Quicksand-Bold",
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5),
                            TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter Floor number';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: "Floor number",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal:
                                        10.0), // Adjust padding as needed
                              ),
                              controller: FloornumberController,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Apartment/ Building name",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontFamily: "Quicksand-Bold",
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5),
                            TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter Apartment/ Building name';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: "Apartment/ Building name",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal:
                                        10.0), // Adjust padding as needed
                              ),
                              controller: apartmentNameController,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "How to reach",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontFamily: "Quicksand-Bold",
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5),
                            TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter to reach your home';
                                }
                                return null;
                              },
                              maxLines: 3,
                              decoration: InputDecoration(
                                hintText: "How to reach",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal:
                                        10.0), // Adjust padding as needed
                              ),
                              controller: HowreachController,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Contact number",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontFamily: "Quicksand-Bold",
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5),
                            TextFormField(
                              maxLength: 10,
                              cursorColor: Colors.purple,
                              controller: phonenumberController,
                              style: const TextStyle(
                                fontFamily: 'Quicksand-SemiBold',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              onFieldSubmitted: (value) {
                                if (value.length == 0) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          Text('Please enter mobile number'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                } else if (value.length < 10) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          ' Mobile number must be at least 10 digits'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                } else if (phonenumberController.text.length ==
                                    10) {}
                              },
                              onChanged: (value) {
                                setState(() {
                                  phonenumberController.text = value;
                                  phonenumber = value;
                                });
                              },
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: "Enter phone number",
                                hintStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  color: Colors.grey.shade600,
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                // enabledBorder: OutlineInputBorder(
                                //   borderRadius: BorderRadius.circular(10),
                                //   borderSide:
                                //       const BorderSide(color: Colors.black12),
                                // ),
                                // focusedBorder: OutlineInputBorder(
                                //   borderRadius: BorderRadius.circular(10),
                                //   borderSide:
                                //       const BorderSide(color: Colors.black12),
                                // ),
                                prefixIcon: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: () {
                                      showCountryPicker(
                                        context: context,
                                        countryListTheme:
                                            const CountryListThemeData(
                                          bottomSheetHeight: 550,
                                        ),
                                        onSelect: (value) {
                                          setState(() {
                                            selectedCountry = value;
                                          });
                                        },
                                      );
                                    },
                                    child: Text(
                                      "${selectedCountry.flagEmoji} + ${selectedCountry.phoneCode}",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                suffixIcon:
                                    phonenumberController.text.length > 9
                                        ? Container(
                                            height: 30,
                                            width: 30,
                                            margin: const EdgeInsets.all(10.0),
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.green,
                                            ),
                                            child: const Icon(
                                              Icons.done,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          )
                                        : null,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a phone number';
                                }
                                if (value.length < 10) {
                                  return 'Phone number must be at least 10 digits';
                                }
                                return null; // Return null if the validation is successful
                              },
                            ),
                            SizedBox(height: 15),
                            Text(
                              "AddressType",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontFamily: "Quicksand-Bold",
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                buildAddressTypeContainer("Home", addressType),
                                buildAddressTypeContainer("Work", addressType),
                                buildAddressTypeContainer("Other", addressType),
                              ],
                            ),
                            SizedBox(height: 20),
                            InkWell(
                              onTap: () {
                                _saveAddressToFirebase(phonenumber);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width,
                                height: 50,
                                decoration: BoxDecoration(
                                    color: Colors.black87,
                                    borderRadius: BorderRadius.circular(10)),
                                child: _isLoading
                                    ? Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      )
                                    : Text(
                                        "Add Address",
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontFamily: "Quicksand-Bold",
                                            fontWeight: FontWeight.w500),
                                      ),
                              ),
                            ),
                            SizedBox(height: 10),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  selectedPlace = null;
                                });
                              },
                              child: Container(
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width,
                                height: 50,
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Text(
                                  "Cancle",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontFamily: "Quicksand-Bold",
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget buildAddressTypeContainer(String type, String selectedType) {
    final isSelected = type == selectedType;
    final color = isSelected ? Colors.green : Colors.grey;

    return GestureDetector(
      onTap: () {
        setState(() {
          addressType = type;
        });
      },
      child: Container(
        alignment: Alignment.center,
        height: 40,
        margin: EdgeInsets.only(right: 10),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: color),
          borderRadius: BorderRadius.circular(10),
          color: isSelected ? color.withOpacity(0.2) : Colors.transparent,
        ),
        child: Text(
          type,
          style: TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontFamily: "Quicksand-Bold",
              fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
}
