// ignore_for_file: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class RestaurantForm extends StatefulWidget {
  const RestaurantForm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RestaurantFormState createState() => _RestaurantFormState();
}

class _RestaurantFormState extends State<RestaurantForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();
  final TextEditingController ratingController = TextEditingController();
  final TextEditingController textController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  Future<void> addRestaurantToFirestore(String name, String address,
      String imageUrl, String rating, String text, String time) async {
    CollectionReference restaurants =
        FirebaseFirestore.instance.collection('Restaurant');

    try {
      var uuid = const Uuid();
      String restaurantId = uuid.v4();
      await restaurants.doc(restaurantId).set({
        'name': name,
        'address': address,
        'imageUrl': imageUrl,
        'rating': rating,
        'text': text,
        'time': time,
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Restaurant added to Firestore'),
        ),
      );
    } catch (e) {
      // ignore: avoid_print
      print('Error adding restaurant to Firestore: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error adding restaurant to Firestore'),
        ),
      );
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
          child: Card(
            borderOnForeground: false,
            elevation: 20,
            shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(40.0),
              side: BorderSide(color: Colors.blue.shade700, width: 2.0),
            ),
            margin: const EdgeInsets.all(40),
            child: SizedBox(
              width: (MediaQuery.of(context).size.width) / 1.1,
              height: MediaQuery.of(context).size.height / 1.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "ADD RESTAURANT",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.blue),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                              controller: nameController,
                              decoration: const InputDecoration(
                                icon: Icon(Icons.text_format_rounded),
                                label: Text("Restaurant Name"),
                              )),
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
                          ),
                          TextFormField(
                            controller: imageUrlController,
                            decoration: const InputDecoration(
                              icon: Icon(
                                Icons.image,
                              ),
                              // helperText: "Add ",
                              label: Text("Image URL"),
                            ),
                          ),
                          TextFormField(
                            keyboardType: const TextInputType.numberWithOptions(
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
                          ),
                        ],
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      String name = nameController.text;
                      String address = addressController.text;
                      String imageUrl = imageUrlController.text;
                      String rating = ratingController.text;
                      String text = textController.text;
                      String time = timeController.text;

                      addRestaurantToFirestore(
                          name, address, imageUrl, rating, text, time);
                    },
                    child: const Text('Add Restaurant'),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
