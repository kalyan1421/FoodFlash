// ignore_for_file: file_names, non_constant_identifier_names, unused_element, unused_local_variable
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class RestaurantForm extends StatefulWidget {
  const RestaurantForm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RestaurantFormState createState() => _RestaurantFormState();
}

class _RestaurantFormState extends State<RestaurantForm> {
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();
  final _formKey4 = GlobalKey<FormState>();
  final _formKey5 = GlobalKey<FormState>();
  final _formKey6 = GlobalKey<FormState>();
  final _formKey7 = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();
  final TextEditingController ratingController = TextEditingController();
  final TextEditingController textController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController vegornon = TextEditingController();
  final TextEditingController subtitle = TextEditingController();
  final TextEditingController categore = TextEditingController();
  final TextEditingController locationlongtude = TextEditingController();
  final TextEditingController locationlatitude = TextEditingController();

  //=============FIRST ITEM CONTROLLER
  final TextEditingController F_item_nameController = TextEditingController();
  final TextEditingController F_item_priceController = TextEditingController();
  final TextEditingController F_item_ratingController = TextEditingController();
  final TextEditingController F_item_descriptionController =
      TextEditingController();
  final TextEditingController F_item_imageurlController =
      TextEditingController();
  final TextEditingController F_item_vegornonController =
      TextEditingController();

  //=============SECOND ITEM CONTROLLS
  final TextEditingController S_item_nameController = TextEditingController();
  final TextEditingController S_item_priceController = TextEditingController();
  final TextEditingController S_item_ratingController = TextEditingController();
  final TextEditingController S_item_descriptionController =
      TextEditingController();
  final TextEditingController S_item_imageurlController =
      TextEditingController();
  final TextEditingController S_item_vegornonController =
      TextEditingController();

  //=============Third ITEM CONTROLLS
  final TextEditingController T_item_nameController = TextEditingController();
  final TextEditingController T_item_priceController = TextEditingController();
  final TextEditingController T_item_ratingController = TextEditingController();
  final TextEditingController T_item_descriptionController =
      TextEditingController();
  final TextEditingController T_item_imageurlController =
      TextEditingController();
  final TextEditingController T_item_vegornonController =
      TextEditingController();
  //=============Fourth ITEM CONTROLLS
  final TextEditingController Four_item_nameController =
      TextEditingController();
  final TextEditingController Four_item_priceController =
      TextEditingController();
  final TextEditingController Four_item_ratingController =
      TextEditingController();
  final TextEditingController Four_item_descriptionController =
      TextEditingController();
  final TextEditingController Four_item_imageurlController =
      TextEditingController();
  final TextEditingController Four_item_vegornonController =
      TextEditingController();
  //=============Fiveth ITEM CONTROLLS
  final TextEditingController Five_item_nameController =
      TextEditingController();
  final TextEditingController Five_item_priceController =
      TextEditingController();
  final TextEditingController Five_item_ratingController =
      TextEditingController();
  final TextEditingController Five_item_descriptionController =
      TextEditingController();
  final TextEditingController Five_item_imageurlController =
      TextEditingController();
  final TextEditingController Five_item_vegornonController =
      TextEditingController();
  //=============Sixth ITEM CONTROLLS
  final TextEditingController Six_item_nameController = TextEditingController();
  final TextEditingController Six_item_priceController =
      TextEditingController();
  final TextEditingController Six_item_ratingController =
      TextEditingController();
  final TextEditingController Six_item_descriptionController =
      TextEditingController();
  final TextEditingController Six_item_imageurlController =
      TextEditingController();
  final TextEditingController Six_item_vegornonController =
      TextEditingController();

  File? selectedImage;
  File? _selectedF_ItemImage;
  File? _selectedS_ItemImage;
  File? _selectedT_ItemImage;
  File? _selected4_ItemImage;
  File? _selected5_ItemImage;
  File? _selected6_ItemImage;
  final picker = ImagePicker();
  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickF_Item_Image() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedF_ItemImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _pick2_Item_Image() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedS_ItemImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _pick3_Item_Image() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedT_ItemImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _pick4_Item_Image() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selected4_ItemImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _pick5_Item_Image() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selected5_ItemImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _pick6_Item_Image() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selected6_ItemImage = File(pickedFile.path);
      });
    }
  }

  Future<void> addRestaurantToFirestore(
      String name,
      String address,
      String imageUrl,
      String rating,
      String text,
      String time,
      String F_Itemname,
      F_itemrating,
      F_itemprice,
      F_itemDescrition,
      File? F_imageUrl,
      String S_Itemname,
      S_itemrating,
      S_itemprice,
      S_itemDescrition,
      File? S_imageUrl,
      String T_Itemname,
      T_itemrating,
      T_itemprice,
      T_itemDescrition,
      File? T_imageUrl,
      String Five_Itemname,
      Fiive_itemrating,
      Five_itemprice,
      Five_itemDescrition,
      File? Five_imageUrl,
      String Four_Itemname,
      Four_itemrating,
      Four_itemprice,
      Four_itemDescrition,
      File? Four_imageUrl) async {
    CollectionReference restaurants =
        FirebaseFirestore.instance.collection('Restaurants');

    try {
      var uuid = const Uuid();
      String restaurantId = uuid.v4();
      String menuItemId = uuid.v4();
      String menuItemId2 = uuid.v4();
      String menuItemId3 = uuid.v4();
      String menuItemId4 = uuid.v4();
      String menuItemId5 = uuid.v4();
      String menuItemId6 = uuid.v4();
      final Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('restautrant_images/$restaurantId');
      UploadTask uploadTask = storageRef.putFile(selectedImage!);
      await uploadTask.whenComplete(
        () async {
          final String imageDownloadURL = await storageRef.getDownloadURL();
          await restaurants.doc(restaurantId).set(
            {
              'restaurantId': restaurantId,
              "vegornon": vegornon.text,
              'name': name,
              'address': address,
              'imageUrl': imageDownloadURL,
              'rating': rating,
              'text': text,
              'time': time,
              "subtitle": subtitle.text,
              "longtude": locationlongtude.text,
              "latitude": locationlatitude.text,
              "categories": categore.text
            },
          );
          final Reference itemStorageRef1 =
              FirebaseStorage.instance.ref().child('item_images/$menuItemId');
          UploadTask itemUploadTask1 = itemStorageRef1.putFile(F_imageUrl!);
          TaskSnapshot itemSnapshot1 = await itemUploadTask1;
          final String itemImageDownloadURL1 =
              await itemSnapshot1.ref.getDownloadURL();

          // Upload image for the second item
          final Reference itemStorageRef2 =
              FirebaseStorage.instance.ref().child('item_images/$menuItemId2');
          UploadTask itemUploadTask2 = itemStorageRef2.putFile(S_imageUrl!);
          TaskSnapshot itemSnapshot2 = await itemUploadTask2;
          final String itemImageDownloadURL2 =
              await itemSnapshot2.ref.getDownloadURL();

          // Upload image for the third item
          final Reference itemStorageRef3 =
              FirebaseStorage.instance.ref().child('item_images/$menuItemId3');
          UploadTask itemUploadTask3 = itemStorageRef3.putFile(T_imageUrl!);
          TaskSnapshot itemSnapshot3 = await itemUploadTask3;
          final String itemImageDownloadURL3 =
              await itemSnapshot3.ref.getDownloadURL();

          // Upload image for the fourth item
          final Reference itemStorageRef4 =
              FirebaseStorage.instance.ref().child('item_images/$menuItemId4');
          UploadTask itemUploadTask4 = itemStorageRef4.putFile(Four_imageUrl!);
          TaskSnapshot itemSnapshot4 = await itemUploadTask4;
          final String itemImageDownloadURL4 =
              await itemSnapshot4.ref.getDownloadURL();

          final CollectionReference menuItemsCollection =
              restaurants.doc(restaurantId).collection('menuItems');
          await menuItemsCollection.doc(menuItemId).set(
            {
              'itemId': menuItemId,
              'name': F_Itemname,
              'price': double.tryParse(F_item_priceController.text) ?? 0.0,
              'description': F_item_descriptionController.text,
              'rating': double.tryParse(F_item_ratingController.text) ?? 0.0,
              'itemImageUrl': itemImageDownloadURL1,
              "vegornon": F_item_vegornonController.text
            },
          );
          //SECOND ITEMS
          await menuItemsCollection.doc(menuItemId2).set(
            {
              'itemId': menuItemId2,
              'name': F_Itemname,
              'price': double.tryParse(S_item_priceController.text) ?? 0.0,
              'description': S_item_descriptionController.text,
              'rating': double.tryParse(S_item_ratingController.text) ?? 0.0,
              'itemImageUrl': itemImageDownloadURL2,
              "vegornon": S_item_vegornonController.text
            },
          );
          //THIRD ITEM
          await menuItemsCollection.doc(menuItemId3).set(
            {
              'itemId': menuItemId3,
              'name': T_Itemname,
              'price': double.tryParse(T_item_priceController.text) ?? 0.0,
              'description': T_item_descriptionController.text,
              'rating': double.tryParse(T_item_ratingController.text) ?? 0.0,
              'itemImageUrl': itemImageDownloadURL3,
              "vegornon": T_item_vegornonController.text
            },
          );
          //Fouth ITEM
          await menuItemsCollection.doc(menuItemId4).set(
            {
              'itemId': menuItemId4,
              'name': Four_Itemname,
              'price': double.tryParse(Four_item_priceController.text) ?? 0.0,
              'description': Four_item_descriptionController.text,
              'rating': double.tryParse(Four_item_ratingController.text) ?? 0.0,
              'itemImageUrl': itemImageDownloadURL4,
              "vegornon": Four_item_vegornonController.text
            },
          );
          //Fivth ITEM
          final Reference itemStorageRef5 =
              FirebaseStorage.instance.ref().child('item_images/$menuItemId5');
          UploadTask itemUploadTask5 = itemStorageRef5.putFile(Five_imageUrl!);
          TaskSnapshot itemSnapshot5 = await itemUploadTask5;
          final String itemImageDownloadURL5 =
              await itemSnapshot5.ref.getDownloadURL();
          await menuItemsCollection.doc(menuItemId5).set(
            {
              'itemId': menuItemId5,
              'name': Five_Itemname,
              'price': double.tryParse(Five_item_priceController.text) ?? 0.0,
              'description': Five_item_descriptionController.text,
              'rating': double.tryParse(Five_item_ratingController.text) ?? 0.0,
              'itemImageUrl': itemImageDownloadURL5,
              "vegornon": Five_item_vegornonController.text
            },
          );
          final Reference itemStorageRef6 =
              FirebaseStorage.instance.ref().child('item_images/$menuItemId6');
          UploadTask itemUploadTask6 = itemStorageRef6.putFile(Five_imageUrl);
          TaskSnapshot itemSnapshot6 = await itemUploadTask6;
          final String itemImageDownloadURL6 =
              await itemSnapshot5.ref.getDownloadURL();
          await menuItemsCollection.doc(menuItemId6).set(
            {
              'itemId': menuItemId6,
              'name': Five_Itemname,
              'price': double.tryParse(Six_item_priceController.text) ?? 0.0,
              'description': Six_item_descriptionController.text,
              'rating': double.tryParse(Six_item_ratingController.text) ?? 0.0,
              'itemImageUrl': itemImageDownloadURL6,
              "vegornon": Six_item_vegornonController.text
            },
          );
        },
      );
    } catch (e) {
      // ignore: avoid_print
      print('Error adding restaurant to Firestore: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        // backgroundColor: Colors.blue.shade100,
        body: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            reverse: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Card(
                      borderOnForeground: false,
                      elevation: 20,
                      shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0),
                        side:
                            BorderSide(color: Colors.blue.shade700, width: 2.0),
                      ),
                      margin: const EdgeInsets.all(20),
                      child: SizedBox(
                        width: (MediaQuery.of(context).size.width) * 0.9,
                        height: MediaQuery.of(context).size.height * 1.2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              "ADD RESTAURANT",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                  color: Colors.blue),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextFormField(
                                      controller: nameController,
                                      decoration: const InputDecoration(
                                        icon: Icon(Icons.text_format_rounded),
                                        label: Text("Restaurant Name"),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter Restaurant Address';
                                        }
                                        return null; // Return null for valid input.
                                      },
                                    ),

                                    const SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                      controller: addressController,
                                      decoration: const InputDecoration(
                                        icon: Icon(
                                          Icons.location_on,
                                        ),
                                        label: Text("Restaurant Address"),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter Restaurant Address';
                                        }
                                        return null; // Return null for valid input.
                                      },
                                      // onSaved: (value) {
                                      //   addressController = value;
                                      // },
                                    ),
                                    TextFormField(
                                      controller: locationlatitude,
                                      decoration: const InputDecoration(
                                        icon: Icon(
                                          Icons.location_on,
                                        ),
                                        label:
                                            Text("Restaurant locationlatitude"),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter Restaurant Address';
                                        }
                                        return null; // Return null for valid input.
                                      },
                                      // onSaved: (value) {
                                      //   addressController = value;
                                      // },
                                    ),
                                    TextFormField(
                                      controller: locationlongtude,
                                      decoration: const InputDecoration(
                                        icon: Icon(
                                          Icons.location_on,
                                        ),
                                        label:
                                            Text("Restaurant locationlongtude"),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter Restaurant Address';
                                        }
                                        return null; // Return null for valid input.
                                      },
                                      // onSaved: (value) {
                                      //   addressController = value;
                                      // },
                                    ),
                                    TextFormField(
                                      controller: subtitle,
                                      decoration: const InputDecoration(
                                        icon: Icon(
                                          Icons.location_on,
                                        ),
                                        label: Text("Restaurant subtitle"),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter Restaurant Address';
                                        }
                                        return null; // Return null for valid input.
                                      },
                                      // onSaved: (value) {
                                      //   addressController = value;
                                      // },
                                    ),
                                    TextFormField(
                                      controller: vegornon,
                                      decoration: const InputDecoration(
                                        icon: Icon(
                                          Icons.location_on,
                                        ),
                                        label: Text("Restaurant vegornon"),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter Restaurant Address';
                                        }
                                        return null; // Return null for valid input.
                                      },
                                      // onSaved: (value) {
                                      //   addressController = value;
                                      // },
                                    ),
                                    TextFormField(
                                      controller: categore,
                                      decoration: const InputDecoration(
                                        icon: Icon(
                                          Icons.location_on,
                                        ),
                                        label: Text("Restaurant vegornon"),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter Restaurant Address';
                                        }
                                        return null; // Return null for valid input.
                                      },
                                      // onSaved: (value) {
                                      //   addressController = value;
                                      // },
                                    ),

                                    const SizedBox(
                                      height: 10,
                                    ),

                                    TextFormField(
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                              decimal: true),
                                      maxLength: 3,
                                      controller: ratingController,
                                      decoration: const InputDecoration(
                                        icon: Icon(
                                          Icons.star,
                                        ),
                                        helperText: "Type in decimal ",
                                        label: Text("Rating"),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter Restaurant Rating';
                                        }
                                        return null; // Return null for valid input.
                                      },
                                    ),

                                    TextFormField(
                                      controller: textController,
                                      decoration: const InputDecoration(
                                        icon: Icon(
                                          Icons.delivery_dining_sharp,
                                        ),
                                        helperText: "Free or Not",
                                        label: Text("Delivery Type"),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter Restaurant Delivery Type';
                                        }
                                        return null; // Return null for valid input.
                                      },
                                    ),
                                    TextFormField(
                                      controller: timeController,
                                      decoration: const InputDecoration(
                                        icon: Icon(
                                          Icons.av_timer_rounded,
                                        ),
                                        helperText: "In mins",
                                        label: Text("Delivery Time"),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter Restaurant Delivery Time';
                                        }
                                        return null; // Return null for valid input.
                                      },
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    //Image picker
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          onTap: _pickImage,
                                          child: Container(
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                color: Colors.blue[500],
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            width: 200,
                                            height: 40,
                                            child: const Text(
                                              'Upload Restaurant images',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 0,
                                        ),
                                        selectedImage == null
                                            ? const Text(
                                                'Upload Restaurant images')
                                            : Image.file(
                                                selectedImage!,
                                                width: 50,
                                                height: 50,
                                                fit: BoxFit.cover,
                                              ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (selectedImage != null) {
                                  String name = nameController.text;
                                  String address = addressController.text;
                                  String imageUrl = imageUrlController.text;
                                  String rating = ratingController.text;
                                  String text = textController.text;
                                  String time = timeController.text;
                                  String F_Itemname =
                                      F_item_nameController.text;
                                  String F_itemprice =
                                      F_item_priceController.text;
                                  String F_itemDescrition =
                                      F_item_descriptionController.text;
                                  String F_itemrating =
                                      F_item_ratingController.text;
                                  String F_imageUrl =
                                      F_item_imageurlController.text;
                                  String S_Itemname =
                                      S_item_nameController.text;
                                  String S_itemprice =
                                      S_item_priceController.text;
                                  String S_itemDescrition =
                                      S_item_descriptionController.text;
                                  String S_itemrating =
                                      S_item_ratingController.text;
                                  String S_imageUrl =
                                      S_item_imageurlController.text;
                                  String T_Itemname =
                                      T_item_nameController.text;
                                  String T_itemprice =
                                      T_item_priceController.text;
                                  String T_itemDescrition =
                                      T_item_descriptionController.text;
                                  String T_itemrating =
                                      T_item_ratingController.text;
                                  String T_imageUrl =
                                      T_item_imageurlController.text;
                                  String Four_Itemname =
                                      Four_item_nameController.text;
                                  String Four_itemprice =
                                      Four_item_priceController.text;
                                  String Four_itemDescrition =
                                      Four_item_descriptionController.text;
                                  String Four_itemrating =
                                      Four_item_ratingController.text;
                                  String Four_imageUrl =
                                      T_item_imageurlController.text;
                                  String Five_Itemname =
                                      Five_item_nameController.text;
                                  String Five_itemprice =
                                      Five_item_priceController.text;
                                  String Five_itemDescrition =
                                      Five_item_descriptionController.text;
                                  String Five_itemrating =
                                      Five_item_ratingController.text;
                                  String Five_imageUrl =
                                      Five_item_imageurlController.text;

                                  if (_formKey.currentState!.validate() &&
                                      _formKey2.currentState!.validate() &&
                                      _formKey3.currentState!.validate() &&
                                      _formKey4.currentState!.validate() &&
                                      _formKey5.currentState!.validate() &&
                                      _formKey6.currentState!.validate()) {
                                    // All controllers are filled, proceed to add the restaurant to Firestore.
                                    addRestaurantToFirestore(
                                        name,
                                        address,
                                        imageUrl,
                                        rating,
                                        text,
                                        time,
                                        F_Itemname,
                                        F_itemrating,
                                        F_itemprice,
                                        F_itemDescrition,
                                        _selectedF_ItemImage,
                                        S_Itemname,
                                        S_itemrating,
                                        S_itemprice,
                                        S_itemDescrition,
                                        _selectedS_ItemImage,
                                        T_Itemname,
                                        T_itemrating,
                                        T_itemprice,
                                        T_itemDescrition,
                                        _selectedT_ItemImage,
                                        Five_Itemname,
                                        Five_itemrating,
                                        Five_itemprice,
                                        Five_itemDescrition,
                                        _selected4_ItemImage,
                                        Four_Itemname,
                                        Four_itemrating,
                                        Four_itemprice,
                                        Four_itemDescrition,
                                        _selected5_ItemImage);
                                    // ScaffoldMessenger.of(context).showSnackBar(
                                    //     const SnackBar(
                                    //         content:
                                    //             Text("Restaurant Successfull")));
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text("Please fill in all fields"),
                                      ),
                                    );
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          "Please Upload Restaurant Image"),
                                    ),
                                  );
                                }
                              },
                              child: const Text('Add Restaurant'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      borderOnForeground: false,
                      elevation: 20,
                      shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0),
                        side:
                            BorderSide(color: Colors.blue.shade700, width: 2.0),
                      ),
                      margin: const EdgeInsets.all(20),
                      child: SingleChildScrollView(
                        child: SizedBox(
                          width: (MediaQuery.of(context).size.width) * 0.9,
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        width: 1, color: Colors.grey)),
                                child: const Text(
                                  "2",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              // Text("1")
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Form(
                                  key: _formKey7,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextFormField(
                                          controller: Six_item_nameController,
                                          decoration: const InputDecoration(
                                            icon: Icon(
                                              Icons.food_bank_outlined,
                                              size: 30,
                                            ),
                                            label: Text("Item Name"),
                                          )),
                                      TextFormField(
                                          controller:
                                              Six_item_vegornonController,
                                          decoration: const InputDecoration(
                                            icon: Icon(
                                              Icons.food_bank_outlined,
                                              size: 30,
                                            ),
                                            label: Text("Itemveg or non"),
                                          )),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),

                                      TextFormField(
                                        keyboardType: const TextInputType
                                            .numberWithOptions(decimal: true),
                                        maxLength: 3,
                                        controller: Six_item_priceController,
                                        decoration: const InputDecoration(
                                          icon: Icon(
                                            Icons.currency_rupee,
                                          ),
                                          helperText: "Type in rupees ",
                                          label: Text("Price of Item"),
                                        ),
                                      ),
                                      TextFormField(
                                        keyboardType: const TextInputType
                                            .numberWithOptions(decimal: true),
                                        maxLength: 3,
                                        controller: Six_item_ratingController,
                                        decoration: const InputDecoration(
                                          icon: Icon(
                                            Icons.star,
                                          ),
                                          helperText: "Type in decimal ",
                                          label: Text("Rating"),
                                        ),
                                      ),
                                      TextFormField(
                                        controller:
                                            Six_item_descriptionController,
                                        decoration: const InputDecoration(
                                          icon: Icon(
                                            Icons.notes_outlined,
                                          ),
                                          label: Text("Description"),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      //Image picker
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: _pick6_Item_Image,
                                            child: Container(
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                color: Colors.blue[500],
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              width: 200,
                                              height: 40,
                                              child: const Text(
                                                'Upload Food items images',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 3,
                                          ),
                                          _selected6_ItemImage == null
                                              ? const Text(
                                                  'Upload Food \nitems images')
                                              : Image.file(
                                                  _selected6_ItemImage!,
                                                  width: 100,
                                                  height: 100,
                                                  fit: BoxFit.cover,
                                                ),
                                        ],
                                      ),

                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 15),
                Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "ADD ITEMS",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: Colors.blue),
                      ),
                    ),
                    Card(
                      borderOnForeground: false,
                      elevation: 20,
                      shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0),
                        side:
                            BorderSide(color: Colors.blue.shade700, width: 2.0),
                      ),
                      margin: const EdgeInsets.all(20),
                      child: SingleChildScrollView(
                        child: SizedBox(
                          width: (MediaQuery.of(context).size.width) * 0.9,
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        width: 1, color: Colors.grey)),
                                child: const Text(
                                  "1",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              // Text("1")
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Form(
                                  key: _formKey2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextFormField(
                                        controller: F_item_nameController,
                                        decoration: const InputDecoration(
                                          icon: Icon(
                                            Icons.food_bank_outlined,
                                            size: 30,
                                          ),
                                          label: Text("Item Name"),
                                        ),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Please enter Item name";
                                          }
                                          return null;
                                        },
                                      ),
                                      TextFormField(
                                        controller: F_item_vegornonController,
                                        decoration: const InputDecoration(
                                          icon: Icon(
                                            Icons.food_bank_outlined,
                                            size: 30,
                                          ),
                                          label: Text("vegornon"),
                                        ),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Please enter Item name";
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 10),
                                      const SizedBox(height: 10),

                                      TextFormField(
                                        keyboardType: const TextInputType
                                            .numberWithOptions(decimal: true),
                                        maxLength: 3,
                                        controller: F_item_priceController,
                                        decoration: const InputDecoration(
                                          icon: Icon(
                                            Icons.currency_rupee,
                                          ),
                                          helperText: "Type in rupees ",
                                          label: Text("Price of Item"),
                                        ),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Please enter Item Price";
                                          }
                                          return null;
                                        },
                                      ),
                                      TextFormField(
                                        keyboardType: const TextInputType
                                            .numberWithOptions(decimal: true),
                                        maxLength: 3,
                                        controller: F_item_ratingController,
                                        decoration: const InputDecoration(
                                          icon: Icon(
                                            Icons.star,
                                          ),
                                          helperText: "Type in decimal ",
                                          label: Text("Rating"),
                                        ),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Please enter Item Rating";
                                          }
                                          return null;
                                        },
                                      ),
                                      TextFormField(
                                        controller:
                                            F_item_descriptionController,
                                        decoration: const InputDecoration(
                                          icon: Icon(
                                            Icons.notes_outlined,
                                          ),
                                          label: Text("Description"),
                                        ),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Please enter Item Description";
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      //Image picker
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: _pickF_Item_Image,
                                            child: Container(
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  color: Colors.blue[500],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              width: 200,
                                              height: 40,
                                              child: const Text(
                                                'Upload Food items images',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 3,
                                          ),
                                          _selectedF_ItemImage == null
                                              ? const Text(
                                                  'Upload Food \nitems images')
                                              : Image.file(
                                                  _selectedF_ItemImage!,
                                                  width: 100,
                                                  height: 100,
                                                  fit: BoxFit.cover,
                                                ),
                                        ],
                                      ),

                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Card(
                      borderOnForeground: false,
                      elevation: 20,
                      shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0),
                        side:
                            BorderSide(color: Colors.blue.shade700, width: 2.0),
                      ),
                      margin: const EdgeInsets.all(20),
                      child: SingleChildScrollView(
                        child: SizedBox(
                          width: (MediaQuery.of(context).size.width) * 0.9,
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        width: 1, color: Colors.grey)),
                                child: const Text(
                                  "2",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              // Text("1")
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Form(
                                  key: _formKey3,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextFormField(
                                          controller: S_item_nameController,
                                          decoration: const InputDecoration(
                                            icon: Icon(
                                              Icons.food_bank_outlined,
                                              size: 30,
                                            ),
                                            label: Text("Item Name"),
                                          )),
                                      TextFormField(
                                          controller: S_item_vegornonController,
                                          decoration: const InputDecoration(
                                            icon: Icon(
                                              Icons.food_bank_outlined,
                                              size: 30,
                                            ),
                                            label: Text("Itemveg or non"),
                                          )),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),

                                      TextFormField(
                                        keyboardType: const TextInputType
                                            .numberWithOptions(decimal: true),
                                        maxLength: 3,
                                        controller: S_item_priceController,
                                        decoration: const InputDecoration(
                                          icon: Icon(
                                            Icons.currency_rupee,
                                          ),
                                          helperText: "Type in rupees ",
                                          label: Text("Price of Item"),
                                        ),
                                      ),
                                      TextFormField(
                                        keyboardType: const TextInputType
                                            .numberWithOptions(decimal: true),
                                        maxLength: 3,
                                        controller: S_item_ratingController,
                                        decoration: const InputDecoration(
                                          icon: Icon(
                                            Icons.star,
                                          ),
                                          helperText: "Type in decimal ",
                                          label: Text("Rating"),
                                        ),
                                      ),
                                      TextFormField(
                                        controller:
                                            S_item_descriptionController,
                                        decoration: const InputDecoration(
                                          icon: Icon(
                                            Icons.notes_outlined,
                                          ),
                                          label: Text("Description"),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      //Image picker
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: _pick2_Item_Image,
                                            child: Container(
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                color: Colors.blue[500],
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              width: 200,
                                              height: 40,
                                              child: const Text(
                                                'Upload Food items images',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 3,
                                          ),
                                          _selectedS_ItemImage == null
                                              ? const Text(
                                                  'Upload Food \nitems images')
                                              : Image.file(
                                                  _selectedS_ItemImage!,
                                                  width: 100,
                                                  height: 100,
                                                  fit: BoxFit.cover,
                                                ),
                                        ],
                                      ),

                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Card(
                      borderOnForeground: false,
                      elevation: 20,
                      shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0),
                        side:
                            BorderSide(color: Colors.blue.shade700, width: 2.0),
                      ),
                      margin: const EdgeInsets.all(20),
                      child: SingleChildScrollView(
                        child: SizedBox(
                          width: (MediaQuery.of(context).size.width) * 0.9,
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        width: 1, color: Colors.grey)),
                                child: const Text(
                                  "2",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              // Text("1")
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Form(
                                  key: _formKey5,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextFormField(
                                          controller: T_item_nameController,
                                          decoration: const InputDecoration(
                                            icon: Icon(
                                              Icons.food_bank_outlined,
                                              size: 30,
                                            ),
                                            label: Text("Item Name"),
                                          )),
                                      TextFormField(
                                          controller: T_item_vegornonController,
                                          decoration: const InputDecoration(
                                            icon: Icon(
                                              Icons.food_bank_outlined,
                                              size: 30,
                                            ),
                                            label: Text("Item Veg or non"),
                                          )),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),

                                      TextFormField(
                                        keyboardType: const TextInputType
                                            .numberWithOptions(decimal: true),
                                        maxLength: 3,
                                        controller: T_item_priceController,
                                        decoration: const InputDecoration(
                                          icon: Icon(
                                            Icons.currency_rupee,
                                          ),
                                          helperText: "Type in rupees ",
                                          label: Text("Price of Item"),
                                        ),
                                      ),
                                      TextFormField(
                                        keyboardType: const TextInputType
                                            .numberWithOptions(decimal: true),
                                        maxLength: 3,
                                        controller: T_item_ratingController,
                                        decoration: const InputDecoration(
                                          icon: Icon(
                                            Icons.star,
                                          ),
                                          helperText: "Type in decimal ",
                                          label: Text("Rating"),
                                        ),
                                      ),
                                      TextFormField(
                                        controller:
                                            T_item_descriptionController,
                                        decoration: const InputDecoration(
                                          icon: Icon(
                                            Icons.notes_outlined,
                                          ),
                                          label: Text("Description"),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      //Image picker
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: _pick3_Item_Image,
                                            child: Container(
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  color: Colors.blue[500],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              width: 200,
                                              height: 40,
                                              child: const Text(
                                                'Upload Food items images',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 3,
                                          ),
                                          _selectedT_ItemImage == null
                                              ? const Text(
                                                  'Upload Food \nitems images')
                                              : Image.file(
                                                  _selectedT_ItemImage!,
                                                  width: 100,
                                                  height: 100,
                                                  fit: BoxFit.cover,
                                                ),
                                        ],
                                      ),

                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Card(
                      borderOnForeground: false,
                      elevation: 20,
                      shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0),
                        side:
                            BorderSide(color: Colors.blue.shade700, width: 2.0),
                      ),
                      margin: const EdgeInsets.all(20),
                      child: SingleChildScrollView(
                        child: SizedBox(
                          width: (MediaQuery.of(context).size.width) * 0.9,
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        width: 1, color: Colors.grey)),
                                child: const Text(
                                  "2",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              // Text("1")
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Form(
                                  key: _formKey6,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextFormField(
                                          controller: Four_item_nameController,
                                          decoration: const InputDecoration(
                                            icon: Icon(
                                              Icons.food_bank_outlined,
                                              size: 30,
                                            ),
                                            label: Text("Item Name"),
                                          )),
                                      TextFormField(
                                          controller:
                                              Four_item_vegornonController,
                                          decoration: const InputDecoration(
                                            icon: Icon(
                                              Icons.food_bank_outlined,
                                              size: 30,
                                            ),
                                            label: Text("Item Name"),
                                          )),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),

                                      TextFormField(
                                        keyboardType: const TextInputType
                                            .numberWithOptions(decimal: true),
                                        maxLength: 3,
                                        controller: Four_item_priceController,
                                        decoration: const InputDecoration(
                                          icon: Icon(
                                            Icons.currency_rupee,
                                          ),
                                          helperText: "Type in rupees ",
                                          label: Text("Price of Item"),
                                        ),
                                      ),
                                      TextFormField(
                                        keyboardType: const TextInputType
                                            .numberWithOptions(decimal: true),
                                        maxLength: 3,
                                        controller: Four_item_ratingController,
                                        decoration: const InputDecoration(
                                          icon: Icon(
                                            Icons.star,
                                          ),
                                          helperText: "Type in decimal ",
                                          label: Text("Rating"),
                                        ),
                                      ),
                                      TextFormField(
                                        controller:
                                            Four_item_descriptionController,
                                        decoration: const InputDecoration(
                                          icon: Icon(
                                            Icons.notes_outlined,
                                          ),
                                          label: Text("Description"),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      //Image picker
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: _pick4_Item_Image,
                                            child: Container(
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  color: Colors.blue[500],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              width: 200,
                                              height: 40,
                                              child: const Text(
                                                'Upload Food items images',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 3,
                                          ),
                                          _selected4_ItemImage == null
                                              ? const Text(
                                                  'Upload Food \nitems images')
                                              : Image.file(
                                                  _selected4_ItemImage!,
                                                  width: 100,
                                                  height: 100,
                                                  fit: BoxFit.cover,
                                                ),
                                        ],
                                      ),

                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Card(
                      borderOnForeground: false,
                      elevation: 20,
                      shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0),
                        side:
                            BorderSide(color: Colors.blue.shade700, width: 2.0),
                      ),
                      margin: const EdgeInsets.all(20),
                      child: SingleChildScrollView(
                        child: SizedBox(
                          width: (MediaQuery.of(context).size.width) * 0.9,
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        width: 1, color: Colors.grey)),
                                child: const Text(
                                  "2",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              // Text("1")
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Form(
                                  key: _formKey4,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextFormField(
                                          controller: Five_item_nameController,
                                          decoration: const InputDecoration(
                                            icon: Icon(
                                              Icons.food_bank_outlined,
                                              size: 30,
                                            ),
                                            label: Text("Item Name"),
                                          )),
                                      TextFormField(
                                          controller:
                                              Five_item_vegornonController,
                                          decoration: const InputDecoration(
                                            icon: Icon(
                                              Icons.food_bank_outlined,
                                              size: 30,
                                            ),
                                            label: Text("Item veg or non"),
                                          )),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),

                                      TextFormField(
                                        keyboardType: const TextInputType
                                            .numberWithOptions(decimal: true),
                                        maxLength: 3,
                                        controller: Five_item_priceController,
                                        decoration: const InputDecoration(
                                          icon: Icon(
                                            Icons.currency_rupee,
                                          ),
                                          helperText: "Type in rupees ",
                                          label: Text("Price of Item"),
                                        ),
                                      ),
                                      TextFormField(
                                        keyboardType: const TextInputType
                                            .numberWithOptions(decimal: true),
                                        maxLength: 3,
                                        controller: Five_item_ratingController,
                                        decoration: const InputDecoration(
                                          icon: Icon(
                                            Icons.star,
                                          ),
                                          helperText: "Type in decimal ",
                                          label: Text("Rating"),
                                        ),
                                      ),
                                      TextFormField(
                                        controller:
                                            Five_item_descriptionController,
                                        decoration: const InputDecoration(
                                          icon: Icon(
                                            Icons.notes_outlined,
                                          ),
                                          label: Text("Description"),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      //Image picker
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: _pick5_Item_Image,
                                            child: Container(
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  color: Colors.blue[500],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              width: 200,
                                              height: 40,
                                              child: const Text(
                                                'Upload Food items images',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 3,
                                          ),
                                          _selected5_ItemImage == null
                                              ? const Text(
                                                  'Upload Food \nitems images')
                                              : Image.file(
                                                  _selected5_ItemImage!,
                                                  width: 100,
                                                  height: 100,
                                                  fit: BoxFit.cover,
                                                ),
                                        ],
                                      ),

                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
