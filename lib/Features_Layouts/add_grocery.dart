import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class AddGroceryScreen extends StatefulWidget {
  @override
  _AddGroceryScreenState createState() => _AddGroceryScreenState();
}

class _AddGroceryScreenState extends State<AddGroceryScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController imageUrlController = TextEditingController();
  TextEditingController kgController = TextEditingController();

  File? _imageFile;

  Future<void> _uploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });

      final Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('grocery_images')
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

      final UploadTask uploadTask = storageReference.putFile(_imageFile!);
      final TaskSnapshot downloadUrl = (await uploadTask);
      final String url = await downloadUrl.ref.getDownloadURL();

      setState(() {
        imageUrlController.text = url;
      });
    }
  }
void _addGrocery() async {
  // Generate a unique ID for the grocery item
  String itemId = Uuid().v4();

  FirebaseFirestore.instance.collection('deals').doc(itemId).set({
    'id': itemId,
    'name': nameController.text,
    'price': double.parse(priceController.text),
    'imageUrl': "imageUrlController.text",
    'weight': kgController.text,
  }).then((_) {
    // Clear the text fields after adding grocery
    nameController.clear();
    priceController.clear();
    imageUrlController.clear();
    kgController.clear();
    
    // Show a snackbar or navigate to a different screen to indicate success
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Grocery added successfully!'),
    ));
  }).catchError((error) {
    // Handle errors
    print('Failed to add grocery: $error');
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Grocery'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 12.0),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Price'),
            ),
            SizedBox(height: 12.0),
            TextField(
              controller: kgController,
              decoration: InputDecoration(labelText: 'KG or Grams'),
            ),
            SizedBox(height: 12.0),
            TextField(
              controller: imageUrlController,
              decoration: InputDecoration(labelText: 'Image URL'),
            ),
            SizedBox(height: 12.0),
            // TextField(
            //   controller: idController,
            //   decoration: InputDecoration(labelText: 'ID'),
            // ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: _uploadImage,
              child: Text('Upload Image'),
            ),
            SizedBox(height: 12.0),
            _imageFile != null
                ? Image.file(
                    _imageFile!,
                    height: 150,
                  )
                : SizedBox.shrink(),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: _addGrocery,
              child: Text('Add Grocery'),
            ),
          ],
        ),
      ),
    );
  }
}
