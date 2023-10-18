// ignore_for_file: file_names, use_key_in_widget_constructors, library_private_types_in_public_api, camel_case_types, avoid_print
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:uuid/uuid.dart';

class Restaurant_Form extends StatefulWidget {
  @override
  _Restaurant_FormState createState() => _Restaurant_FormState();
}

class _Restaurant_FormState extends State<Restaurant_Form> {
  File? selectedRestaurantImage;
  List<File?> menuImages = List.generate(5, (_) => null);
  final picker = ImagePicker();

  final TextEditingController restaurantNameController =
      TextEditingController();
  final TextEditingController restaurantAddressController =
      TextEditingController();
  final TextEditingController restaurantRatingController =
      TextEditingController();
  final TextEditingController restaurantTextController =
      TextEditingController();
  final TextEditingController restaurantTimeController =
      TextEditingController();

  List<MenuItemData> menuItems = List.generate(
    5,
    (index) => MenuItemData(
      name: TextEditingController(),
      price: TextEditingController(),
      description: TextEditingController(),
      rating: TextEditingController(),
    ),
  );

  Future<void> _pickImage(int index) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        if (index == -1) {
          selectedRestaurantImage = File(pickedFile.path);
        } else if (index >= 0 && index < 5) {
          menuImages[index] = File(pickedFile.path);
        }
      });
    }
  }

  Future<void> uploadRestaurantAndMenuItems() async {
    try {
      var uuid = const Uuid();
      String restaurantId = uuid.v4();

      // Upload restaurant details
      final Reference restaurantStorageRef = FirebaseStorage.instance
          .ref()
          .child('restaurant_images/$restaurantId');
      UploadTask restaurantUploadTask =
          restaurantStorageRef.putFile(selectedRestaurantImage!);
      TaskSnapshot restaurantSnapshot = await restaurantUploadTask;
      final String restaurantImageDownloadURL =
          await restaurantSnapshot.ref.getDownloadURL();

      final CollectionReference restaurantsCollection =
          FirebaseFirestore.instance.collection('Restaurants');
      await restaurantsCollection.doc(restaurantId).set(
        {
          'restaurantId': restaurantId,
          'name': restaurantNameController.text,
          'address': restaurantAddressController.text,
          'imageUrl': restaurantImageDownloadURL,
          'rating': restaurantRatingController.text,
          'text': restaurantTextController.text,
          'time': restaurantTimeController.text,
        },
      );

      // Upload menu items
      final CollectionReference menuItemsCollection =
          restaurantsCollection.doc(restaurantId).collection('menuItems');

      for (int i = 0; i < 5; i++) {
        String menuItemId = uuid.v4();
        final Reference itemStorageRef =
            FirebaseStorage.instance.ref().child('item_images/$menuItemId');
        UploadTask itemUploadTask = itemStorageRef.putFile(menuImages[i]!);
        TaskSnapshot itemSnapshot = await itemUploadTask;
        final String itemImageDownloadURL =
            await itemSnapshot.ref.getDownloadURL();

        await menuItemsCollection.doc(menuItemId).set(
          {
            'itemId': menuItemId,
            'name': menuItems[i].name.text,
            'price': double.tryParse(menuItems[i].price.text) ?? 0.0,
            'description': menuItems[i].description.text,
            'rating': double.tryParse(menuItems[i].rating.text) ?? 0.0,
            'itemImageUrl': itemImageDownloadURL,
          },
        );
      }
    } catch (e) {
      print('Error adding restaurant and menu items: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant Menu Upload'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Column(
                children: [
                  if (selectedRestaurantImage != null)
                    Image.file(
                      selectedRestaurantImage!,
                      height: 100,
                      width: 100,
                    ),
                  ElevatedButton(
                    onPressed: () => _pickImage(-1),
                    child: const Text('Select Restaurant Image'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: restaurantNameController,
              decoration: const InputDecoration(labelText: 'Restaurant Name'),
            ),
            TextField(
              controller: restaurantAddressController,
              decoration:
                  const InputDecoration(labelText: 'Restaurant Address'),
            ),
            TextField(
              controller: restaurantRatingController,
              decoration: const InputDecoration(labelText: 'Restaurant Rating'),
            ),
            TextField(
              controller: restaurantTextController,
              decoration: const InputDecoration(labelText: 'Restaurant Text'),
            ),
            TextField(
              controller: restaurantTimeController,
              decoration: const InputDecoration(labelText: 'Restaurant Time'),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Menu Items:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            for (int i = 0; i < 5; i++)
              Column(
                children: [
                  TextField(
                    controller: menuItems[i].name,
                    decoration:
                        InputDecoration(labelText: 'Item ${i + 1} Name'),
                  ),
                  TextField(
                    controller: menuItems[i].price,
                    decoration:
                        InputDecoration(labelText: 'Item ${i + 1} Price'),
                  ),
                  TextField(
                    controller: menuItems[i].description,
                    decoration:
                        InputDecoration(labelText: 'Item ${i + 1} Description'),
                  ),
                  TextField(
                    controller: menuItems[i].rating,
                    decoration:
                        InputDecoration(labelText: 'Item ${i + 1} Rating'),
                  ),
                  if (menuImages[i] != null)
                    Image.file(
                      menuImages[i]!,
                      height: 100,
                      width: 100,
                    ),
                  ElevatedButton(
                    onPressed: () => _pickImage(i),
                    child: Text('Select Item ${i + 1} Image'),
                  ),
                ],
              ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                uploadRestaurantAndMenuItems();
              },
              child: const Text('Upload Restaurant and Menu Items'),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuItemData {
  final TextEditingController name;
  final TextEditingController price;
  final TextEditingController description;
  final TextEditingController rating;

  MenuItemData({
    required this.name,
    required this.price,
    required this.description,
    required this.rating,
  });
}
