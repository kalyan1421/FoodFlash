// ignore_for_file: camel_case_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Search_bar_screen extends StatefulWidget {
  const Search_bar_screen({super.key});

  @override
  State<Search_bar_screen> createState() => _Search_bar_screenState();
}

class _Search_bar_screenState extends State<Search_bar_screen> {

  // List _item
  CollectionReference restaurants =
      FirebaseFirestore.instance.collection('Restaurants_1');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 45,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              // height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5), // Shadow color
                          spreadRadius: 2, // Spread radius
                          blurRadius: 2, // Blur radius
                          offset:
                              const Offset(0, 2), // Offset in the Y direction
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(
                              width: 5,
                            ),
                            IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(Icons.arrow_back_ios_new_sharp,
                                    color: Colors.blue, size: 25)),
                            const SizedBox(
                              width: 15,
                            ),
                            const SizedBox(
                              width: 200.0, // Set your desired width
                              child: TextField( 
                                autofocus: true, 
                                decoration: InputDecoration(
                                  hintText: "Restaurant name or a dish....",
                                  border: InputBorder.none,
                                ),
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 1,
                              height: 40,
                              color: Colors.grey.shade300.withOpacity(.8),
                            ),
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.mic_none_outlined,
                                  color: Colors.blue,
                                  size: 28,
                                )),
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  // DropdownButton(items: _items, onChanged: (){}), 
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Delivery",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 26),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Dining",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 26),
                        ),
                      ),
                      const SizedBox(),
                    ],
                  ),
                  const Divider(
                    height: 5,
                    thickness: 3,
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "PAST SEARCHES",
                        style: TextStyle(
                            letterSpacing: 1,
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Clear",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          // Search_data(restaurantData: snapshot.data!.docs[Index].data()
                            // as Map<String, dynamic>,)
        ],
      ),
    );
  }
}
