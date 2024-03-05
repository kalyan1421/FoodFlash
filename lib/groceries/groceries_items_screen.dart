import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:shimmer/shimmer.dart';
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
    final double itemHeight = (size.height - kToolbarHeight - 24) / 4.6;
    final double itemWidth = size.width / 3;
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            elevation: 0,
            pinned: true,
            floating: true,
            collapsedHeight: 100,
            expandedHeight: 100,
            backgroundColor: Colors.white,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: 30,
              ),
            ),
            flexibleSpace: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                        widget.categoryName,
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.06,
                            color: Colors.black,
                            fontFamily: "Quicksand",
                            fontWeight: FontWeight.w900),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => groceries_search_screen(),
                          ),
                        );
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.grey.shade200.withOpacity(0.8),
                        child: Icon(Ionicons.search,
                            color: Colors.black, size: 25),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 20)),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('groceries')
                .doc(widget.category)
                .snapshots(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (!snapshot.hasData) {
                return SliverToBoxAdapter(
                  child: Shimmer_loading(),
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
                      return Product_card(
                        groceriesData: itemData,
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

class Product_card extends StatefulWidget {
  final Map<String, dynamic> groceriesData;

  const Product_card({super.key, required this.groceriesData});

  @override
  State<Product_card> createState() => _Product_cardState();
}

class _Product_cardState extends State<Product_card> {
  int _quantity = 1;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _user;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
  }

  Future<void> addToCart(int quantityChange) async {
    try {
      if (_user != null) {
        final existingCartItem = await FirebaseFirestore.instance
            .collection('users')
            .doc(_user!.uid)
            .collection('GroceriesCart')
            .doc(widget.groceriesData['id'])
            .get();
        double totalItemPrice = widget.groceriesData['price'].toDouble();

        print(existingCartItem.exists);
        if (existingCartItem.exists) {
          final currentQuantity = existingCartItem.data()?['quantity'] ?? 0;
          await FirebaseFirestore.instance
              .collection('users')
              .doc(_user!.uid)
              .collection('GroceriesCart')
              .doc(widget.groceriesData['id'])
              .update({
            'quantity': currentQuantity + quantityChange,
            'totalPrice': totalItemPrice * (currentQuantity + quantityChange),
          });
          if (mounted) {
            setState(() {
              _quantity = currentQuantity + quantityChange;
            });
          }
          print('Quantity updated in cart successfully!');
        } else {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(_user!.uid)
              .collection('GroceriesCart')
              .doc(widget.groceriesData['id'])
              .set({
            'itemid': widget.groceriesData['id'],
            'itemimage': widget.groceriesData['image'],
            'itemname': widget.groceriesData['title'],
            'itemprice': widget.groceriesData['price'],
            "weight": widget.groceriesData['weight'],
            "offers": widget.groceriesData['offers'],
            'quantity': quantityChange,
            'timestamp': FieldValue.serverTimestamp(),
            'totalPrice': totalItemPrice * quantityChange,
            "discount": widget.groceriesData["offers"],
          });
          if (mounted) {
            setState(() {
              _quantity = quantityChange;
            });
          }
          print('Item added to cart successfully!');
        }
      } else {
        print('User is not authenticated. Cannot add to cart.');
      }
    } catch (e) {
      print('Error adding item to cart: $e');
    }
  }

  void removeFromCart() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(_user!.uid)
        .collection('GroceriesCart')
        .doc(widget.groceriesData['id'])
        .delete()
        .then((value) {
      print('Item removed from cart successfully');
    }).catchError((error) {
      print('Failed to remove item from cart: $error');
    });
  }

  @override
  Widget build(BuildContext) {
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            // border: Border.all(width: 1, color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  offset: Offset(1, 2),
                  color: Colors.grey.shade200,
                  spreadRadius: 2,
                  blurRadius: 3)
            ]),
        child: Column(
          children: [
            Container(
              // decoration:
              // BoxDecoration(color: Colors.grey.shade200.withOpacity(0.5)),
              width: width * 0.4,
              height: width * 0.4,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: Stack(
                alignment: AlignmentDirectional.topStart,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                          image: NetworkImage(
                            widget.groceriesData['image'],
                          ),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  widget.groceriesData['offers'] != null
                      ? Positioned(
                          right: 10,
                          top: 0,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Image.asset(
                                "assets/Offers/offer_tag.png",
                                scale: 2.8,
                              ),
                              Center(
                                child: Text(
                                  "${widget.groceriesData['offers']}%\noff",
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.030,
                                      color: Colors.black,
                                      fontFamily: "Quicksand",
                                      fontWeight: FontWeight.w800),
                                ),
                              )
                            ],
                          ),
                        )
                      : Container(),
                  Positioned(
                    right: 10,
                    bottom: 0,
                    child: StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(_user!.uid)
                          .collection('GroceriesCart')
                          .doc(widget.groceriesData['id'])
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Shimmer.fromColors(
                            period: const Duration(milliseconds: 1500),
                            direction: ShimmerDirection.ltr,
                            // int loop = 0,
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: SingleChildScrollView(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 10,
                                      height: 40.0,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        } else {
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            final existingCartItem = snapshot.data;
                            final isItemInDB =
                                existingCartItem?.exists ?? false;
                            int quantity =
                                isItemInDB ? existingCartItem!['quantity'] : 0;

                            return isItemInDB
                                ? Container(
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                              offset: Offset(1, 5),
                                              spreadRadius: 2,
                                              blurRadius: 5,
                                              color: Colors.grey.shade200)
                                        ],
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                    width: MediaQuery.of(context).size.width *
                                        0.25,
                                    height: 30,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(height: 3),
                                        InkWell(
                                          onTap: () {
                                            if (quantity > 1) {
                                              addToCart(-1);
                                            } else {
                                              removeFromCart();
                                            }
                                            showCustomSnackBar(context,
                                                "Item removed from cart");
                                          },
                                          child: Icon(Icons.remove),
                                        ),
                                        Text(
                                          quantity.toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18),
                                        ),
                                        InkWell(
                                          child: const Icon(Icons.add),
                                          onTap: () {
                                            showCustomSnackBar(
                                                context, "Item added to cart");
                                            addToCart(1);
                                          },
                                        ),
                                        SizedBox(height: 3),
                                      ],
                                    ),
                                  )
                                : InkWell(
                                    onTap: () {
                                      addToCart(1);
                                    },
                                    // onTap: _showItemDetails,
                                    child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: 35,
                                        height: 35,
                                        decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                  offset: Offset(1, 5),
                                                  spreadRadius: 2,
                                                  blurRadius: 5,
                                                  color: Colors.grey.shade200)
                                            ],
                                            color: Colors.white,
                                            shape: BoxShape.circle),
                                        child: Icon(
                                          Icons.add,
                                          size: 26,
                                        ),
                                      ),
                                    ),
                                  );
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: width * 0.4,
              height: width * 0.2,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5),
                  Text(
                    '${widget.groceriesData['title'].split(' ').take(4).join(' ')}',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.043,
                      color: Colors.black,
                      fontFamily: "Quicksand",
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  widget.groceriesData['offers'] != null
                      ? Text.rich(
                          TextSpan(
                            // text: 'This item costs ',
                            children: <TextSpan>[
                              new TextSpan(
                                text: "₹${widget.groceriesData['price']}",
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.035,
                                    color: Colors.grey.shade600,
                                    fontFamily: "Quicksand",
                                    decoration: TextDecoration.lineThrough,
                                    fontWeight: FontWeight.w600),
                              ),
                              new TextSpan(
                                text:
                                    "  ₹${widget.groceriesData['price'] - 10}/ ${widget.groceriesData['weight']}",
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.035,
                                    color: Colors.grey.shade600,
                                    fontFamily: "Quicksand",
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        )
                      : Text(
                          "₹${widget.groceriesData['price']}/ ${widget.groceriesData['weight']}",
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.035,
                              color: Colors.grey.shade600,
                              fontFamily: "Quicksand",
                              fontWeight: FontWeight.w600),
                        ),

                  // Text(
                  //   "⭐ ${widget.restaurantData['rating']} | $distance | $duration",
                  //   style: TextStyle(
                  //       fontSize: MediaQuery.of(context).size.width * 0.032,
                  //       color: Colors.grey.shade600,
                  //       fontFamily: "Quicksand",
                  //       fontWeight: FontWeight.w600),
                  // )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
