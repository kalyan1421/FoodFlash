import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:uber_eats/Provider/groceries_provider.dart';
import 'package:uber_eats/Utils/utils.dart';
import 'package:uber_eats/groceries/groceries_search_screen.dart';

class groceries_items_screen extends StatefulWidget {
  final String category;
  final String categoryImage;
  final String categoryName;

  const groceries_items_screen(
      {Key? key,
      required this.category,
      required this.categoryImage,
      required this.categoryName})
      : super(key: key);

  @override
  State<groceries_items_screen> createState() => _groceries_items_screenState();
}

class _groceries_items_screenState extends State<groceries_items_screen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 4.8;
    final double itemWidth = size.width / 3;
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            elevation: 0,
            pinned: true,
            floating: true,
            collapsedHeight: 90,
            expandedHeight: 90,
            backgroundColor: Colors.white,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.indigo,
                size: 30,
              ),
            ),
            actions: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => groceries_search_screen(),
                    ),
                  );
                },
                child: Image.asset(
                  "assets/utiles/search_icon.png",
                  color: Colors.indigo,
                  scale: 25,
                ),
              ),
              SizedBox(width: 15),
              Image.asset(
                "assets/utiles/filter_icon.png",
                color: Colors.indigo,
                scale: 20,
              ),
              SizedBox(width: 10),
            ],
            flexibleSpace: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(child: SizedBox(height: 15)),
                  Text(
                    textAlign: TextAlign.end,
                    widget.categoryName,
                    style: GoogleFonts.lobster(fontSize: 30),
                  ),
                  SizedBox(height: 5),
                ],
              ),
            ),
          ),
          // SliverToBoxAdapter(
          //   child: Column(
          //     children: [
          //       SizedBox(height: 10),
          //       Center(
          //         child: Text(
          //           textAlign: TextAlign.center,
          //           widget.categoryName,
          //           style: GoogleFonts.lobster(fontSize: 30),
          //         ),
          //       ),
          //       SizedBox(height: 25),
          //     ],
          //   ),
          // ),
          SliverToBoxAdapter(child: SizedBox(height: 20)),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('groceries')
                .doc(widget.category)
                .snapshots(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (!snapshot.hasData) {
                return SliverToBoxAdapter(
                  child: CircularProgressIndicator(),
                );
              }
              Map<String, dynamic>? data =
                  snapshot.data!.data() as Map<String, dynamic>?;
              if (data == null || !data.containsKey('items')) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: Text('No items available for ${widget.category}'),
                  ),
                );
              }
              List<dynamic> itemsData = data['items'];
              return SliverPadding(
                padding: const EdgeInsets.all(5.0),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: itemWidth / itemHeight,
                    crossAxisCount: 2,
                    crossAxisSpacing: 5.0,
                    mainAxisSpacing: 5.0,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      Map<String, dynamic> itemData = itemsData[index];
                      return ProductCard(
                        id: itemData['id'],
                        title: itemData['title'],
                        image: itemData['image'],
                        price: itemData['price'].toDouble(),
                        categoryName: widget.categoryName,
                        // addToCart: (quantityChange) {
                        //   addToCart(itemData, quantityChange);
                        // },
                      );
                    },
                    childCount: itemsData.length,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatefulWidget {
  final String id;
  final String title;
  final String image;
  final double price;
  final int initialQuantity;
  final String categoryName;

  const ProductCard({
    Key? key,
    required this.id,
    required this.title,
    required this.image,
    required this.price,
    required this.categoryName,
    this.initialQuantity = 1,
  }) : super(key: key);

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  late int _quantity;

  @override
  void initState() {
    super.initState();
    _quantity = widget.initialQuantity;
    generateRandomNumber();
  }

  int randomValue = 0;
  void generateRandomNumber() {
    final random = Random();
    int randomNumber;

    do {
      randomNumber = random.nextInt(26) + 5;
    } while (randomNumber <= 0 || randomNumber > 30);

    setState(() {
      randomValue = randomNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.read<GroceriesCart>();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 2),
      child: Stack(
        alignment: Alignment.topLeft,
        children: [
          Container(
            decoration: BoxDecoration(
                border: Border.all(
                  width: 0.5,
                  color: Colors.grey.shade300,
                ),
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.shade300,
                      spreadRadius: 2,
                      blurRadius: 3,
                      offset: Offset(0, 2))
                ]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5),
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(image: NetworkImage(widget.image)),
                    ),
                    height: MediaQuery.of(context).size.height * 0.08,
                    // width: 100,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.title.split(' ').take(4).join(' '),
                          style: GoogleFonts.archivo(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          )
                          // TextStyle(
                          //   fontWeight: FontWeight.bold,
                          //   fontSize: 16,
                          // ),
                          ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Text(
                            '₹${widget.price.toString()}0',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          if (widget.categoryName ==
                              'Fresh Fruits & Vegetables')
                            Text(
                              ' for KG',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        cartProvider.addToCart({
                          'id': widget.id,
                          'title': widget.title,
                          'image': widget.image,
                          'price': widget.price,
                        }, _quantity);

                        setState(() {
                          _quantity = 1;
                        });
                        showCustomSnackBar(
                            context, "${widget.title} Item added to Cart");
                      },
                      child: Container(
                        width: 55,
                        height: 25,
                        decoration: BoxDecoration(
                            color: Colors.indigo.shade300.withOpacity(0.3),
                            border: Border.all(
                                width: 1, color: Colors.indigo.shade300),
                            borderRadius: BorderRadius.circular(5)),
                        child: Center(
                          child: Text(
                            "Add",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo),
                          ),
                        ),
                      ),
                    ),
                    Expanded(child: SizedBox()),
                    Row(
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
                  ],
                ),
              ],
            ),
          ),
          // Positioned(
          //   bottom: 165,
          //   right: 120,
          //   child: Stack(
          //     alignment: Alignment.center,
          //     children: [
          //       Image.asset(
          //         "assets/utiles/price_tag_groceies.png",
          //         width: 90,
          //         height: 120,
          //       ),
          //       Positioned(
          //         top: 45,
          //         child: Text(
          //           "${randomValue}%\nOFF",
          //           style: TextStyle(
          //               color: Colors.white,
          //               fontWeight: FontWeight.bold,
          //               fontSize: 10),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
