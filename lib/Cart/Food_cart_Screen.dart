// ignore_for_file: unused_field

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uber_eats/Payment_methods/Food_upi_payment.dart';
import 'package:uber_eats/dash_screen.dart';
import 'package:uber_eats/model/cart.dart';

class Food_cart_Screen extends StatefulWidget {
  const Food_cart_Screen({super.key});

  @override
  State<Food_cart_Screen> createState() => _Food_cart_ScreenState();
}

class _Food_cart_ScreenState extends State<Food_cart_Screen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<CartSavedItem> cartItems = [];

  User? _user;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
  }

  double _FoodcalculateTotalPrice(List<CartSavedItem> cartItems) {
    double totalPrice = 0;
    for (final cartItem in cartItems) {
      totalPrice += cartItem.price * cartItem.quantity;
    }
    return totalPrice;
  }

  Future<void> _updateQuantity(
      CartSavedItem cartItem, int quantityChange) async {
    try {
      int newQuantity = cartItem.quantity + quantityChange;
      if (newQuantity > 0) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_user!.uid)
            .collection('cart')
            .doc(cartItem.itemId)
            .update({
          'quantity': newQuantity,
        });
      } else {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_user!.uid)
            .collection('cart')
            .doc(cartItem.itemId)
            .delete();
      }
    } catch (e) {
      print('Error updating quantity: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(_user!.uid)
              .collection('cart')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: const CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('Cart is empty.'));
            }

            List<CartSavedItem> cartItems = snapshot.data!.docs
                .map((doc) => CartSavedItem.fromFirestore(doc))
                .toList();
            return Stack(
              alignment: AlignmentDirectional.topStart,
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(_user!.uid)
                      .collection('cart')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: const CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text('Cart is empty.'));
                    }
                    List<CartSavedItem> cartItems = snapshot.data!.docs
                        .map((doc) => CartSavedItem.fromFirestore(doc))
                        .toList();
                    return Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 5),
                        Text(
                          "ITEM(S)  ADDED",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.notoSerif(
                              fontSize: 18,
                              color: Colors.grey.shade800,
                              letterSpacing: 1),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height - 240,
                          child: ListView.builder(
                            itemCount: cartItems.length,
                            itemBuilder: (context, index) {
                              final cartItem = cartItems[index];
                              return Card(
                                  shadowColor: Colors.grey,
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  color: Colors.white,
                                  child: Container(
                               
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    height: 220,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                cartItem.name,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20),
                                              ),
                                              Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              width: 2,
                                                              color: Colors
                                                                  .indigo
                                                                  .shade300),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          color: Colors
                                                              .indigo.shade200
                                                              .withOpacity(
                                                                  0.5)),
                                                      width: 80,
                                                      height: 25,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        IconButton(
                                                          icon: const Icon(
                                                            Icons.remove,
                                                            size: 20,
                                                            color:
                                                                Colors.indigo,
                                                          ),
                                                          onPressed: () {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                                    SnackBar(
                                                              content: const Text(
                                                                  "Item Removed"),
                                                              duration:
                                                                  const Duration(
                                                                      seconds:
                                                                          1),
                                                              backgroundColor:
                                                                  Colors.indigo
                                                                      .shade600,
                                                              behavior:
                                                                  SnackBarBehavior
                                                                      .floating,
                                                            ));

                                                            _updateQuantity(
                                                                cartItem, -1);
                                                          },
                                                        ),
                                                        Text(
                                                          cartItem.quantity
                                                              .toString(),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 14),
                                                        ),
                                                        IconButton(
                                                          icon: const Icon(
                                                            Icons.add,
                                                            size: 20,
                                                            color:
                                                                Colors.indigo,
                                                          ),
                                                          onPressed: () {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                                    SnackBar(
                                                              content: Text(
                                                                  " Added one more Quantity "),
                                                              duration:
                                                                  Duration(
                                                                      seconds:
                                                                          1),
                                                              backgroundColor:
                                                                  Colors.indigo
                                                                      .shade600,
                                                              behavior:
                                                                  SnackBarBehavior
                                                                      .floating,
                                                            ));
                                                            _updateQuantity(
                                                                cartItem, 1);
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ]),
                                            ],
                                          ),
                                          Text(
                                              'Quantity: ${cartItem.quantity.toString()}'),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                              '₹ ${cartItem.price.toStringAsFixed(2)}'),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          const Divider(
                                            thickness: 2,
                                          ),
                                          SizedBox(height: 10),
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const MyHomePage(),
                                                ),
                                              );
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Icon(Icons
                                                    .add_circle_outline_rounded),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                const Text("Add more items "),
                                                const Spacer(),
                                                Icon(Icons
                                                    .arrow_forward_ios_outlined),
                                                SizedBox(width: 5)
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 15),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Icon(Icons.edit_document),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              const Text(
                                                  "Add cooking instructions"),
                                              // Text(
                                              // 'Total Price: ₹ ${_calculateTotalPrice(cartItems).toStringAsFixed(2)}'),
                                              const Spacer(),
                                              Icon(Icons
                                                  .arrow_forward_ios_outlined),
                                              SizedBox(width: 5)
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ));
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
                // )
                Positioned(
                  bottom: 0,
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    width: MediaQuery.of(context).size.width,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child: Row(
                                      children: [
                                        Icon(Icons.payment),
                                        Text("Pay using"),
                                        Icon(Icons.arrow_drop_up_outlined),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 0),
                                    child: Text(
                                      "UPI app",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: ((context) => Food_upi_payment(
                                          totalPrice: _FoodcalculateTotalPrice(
                                              cartItems),
                                          cartItems: cartItems)),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: const BoxDecoration(
                                      color: Color.fromARGB(255, 239, 49, 49),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  height: 60,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Center(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "₹${_FoodcalculateTotalPrice(cartItems).toString()}",
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(height: 4),
                                                const Text(
                                                  "TOTAL",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 15),
                                        const Text(
                                          "Place Order",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 1),
                                        ),
                                        const Icon(
                                          Icons.arrow_right,
                                          color: Colors.white,
                                        ),
                                        const Expanded(child: SizedBox())
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 100,
                )
              ],
            );
          }),
    );
  }
}
