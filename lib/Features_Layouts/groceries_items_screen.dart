// ignore_for_file: camel_case_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uber_eats/Provider/groceries_provider.dart';

class groceries_items_screen extends StatefulWidget {
  final String category;

  const groceries_items_screen({super.key, required this.category});

  @override
  State<groceries_items_screen> createState() => _groceries_items_screenState();
}

class _groceries_items_screenState extends State<groceries_items_screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products in ${widget.category}'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('groceries')
            .doc(widget.category)
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }

          Map<String, dynamic>? data =
              snapshot.data!.data() as Map<String, dynamic>?;

          if (data == null || !data.containsKey('items')) {
            return Center(
              child: Text('No items available for ${widget.category}'),
            );
          }

          List<dynamic> itemsData = data['items'];

          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 5.0,
                mainAxisSpacing: 5.0,
              ),
              itemCount: itemsData.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> itemData = itemsData[index];
                return ProductCard(
                  title: itemData['title'],
                  image: itemData['image'],
                  price: itemData['price'].toDouble(),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class ProductCard extends StatefulWidget {
  final String title;
  final String image;
  final double price;

  const ProductCard(
      {super.key,
      required this.title,
      required this.image,
      required this.price});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  int _quantity = 1;
  @override
  Widget build(BuildContext context) {
    var cartProvider = Provider.of<GroceriesCart>(context, listen: false);

    return Card(
      elevation: 5.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(image: NetworkImage(widget.image))),
            height: MediaQuery.of(context).size.height * 0.1,
            width: 100,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
                // Text('₹${widget.price.toString()} per KG'),
                Row(
                  children: [
                    const SizedBox(width: 5),
                    Text('₹${widget.price.toString()} \n per KG'),
                    IconButton(
                      onPressed: () {
                        cartProvider.addToCart({
                          'title': widget.title,
                          'image': widget.image,
                          'price': widget.price,
                        }, _quantity);
                      },
                      icon: const Icon(Icons.shopping_cart),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            if (_quantity > 1) {
                              setState(() {
                                _quantity--;
                              });
                            }
                          },
                        ),
                        Text('$_quantity'),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              _quantity++;
                            });
                          },
                        ),
                      ],
                    ),
                    // IconButton(
                    //   icon: const Icon(Icons.shopping_cart),
                    //   onPressed: () {
                    //     // View cart logic
                    //   },
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}