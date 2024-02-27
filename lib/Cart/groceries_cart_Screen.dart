// ignore_for_file: unused_field

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:uber_eats/Provider/groceries_provider.dart';
import 'package:uber_eats/dash_screen.dart';
import 'package:uber_eats/model/cart.dart';

import '../Payment_methods/Grocery_upi_payment.dart';

class GroceriesCartScreen extends StatefulWidget {
  @override
  State<GroceriesCartScreen> createState() => _GroceriesCartScreenState();
}

class _GroceriesCartScreenState extends State<GroceriesCartScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<CartSavedItem> cartItems = [];

  User? _user;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
  }

  Future<void> updateQuantity(
      Map<String, dynamic> cartItem, int quantityChange) async {
    final user = _auth.currentUser;

    try {
      if (user != null) {
        int newQuantity = cartItem['quantity'] + quantityChange;
        if (newQuantity > 0) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('GroceriesCart')
              .doc(cartItem['id'])
              .update({
            'quantity': newQuantity,
          });
        } else {
          // Remove the item from the cart
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('GroceriesCart')
              .doc(cartItem['id'])
              .delete();
        }
      }
    } catch (e) {
      print('Error updating quantity: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.read<GroceriesCart>();

    return Scaffold(
      body: FutureBuilder(
        future: cartProvider.fetchCartItems(),
        builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('Your groceries cart is empty.'),
            );
          } else {
            List<Map<String, dynamic>>? cartItems = snapshot.data;

            double totalCartPrice =
                cartProvider.GroceriesCalculateTotalPrice(cartItems!);

            return Stack(children: [
              Column(
                children: [
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
                            borderRadius: BorderRadius.circular(10),
                          ),
                          color: Colors.white,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: 220,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        cartItem['name']
                                            .split(' ')
                                            .take(3)
                                            .join(' '),
                                        style: const TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                        maxLines: 1,
                                      ),

                                      // Text(
                                      //   cartItem['itemid'],
                                      //   style: const TextStyle(
                                      //     fontWeight: FontWeight.bold,
                                      //     fontSize: 20,
                                      //   ),
                                      // ),
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                width: 2,
                                                color: Colors.indigo.shade300,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: Colors.indigo.shade200
                                                  .withOpacity(0.5),
                                            ),
                                            width: 80,
                                            height: 25,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.remove,
                                                  size: 20,
                                                  color: Colors.indigo,
                                                ),
                                                onPressed: () {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                    content: const Text(
                                                        "Item Removed"),
                                                    duration: const Duration(
                                                        seconds: 1),
                                                    backgroundColor:
                                                        Colors.indigo.shade600,
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                  ));
                                                  cartProvider.updateCartItem(
                                                      cartItem['itemid'],
                                                      cartItem['quantity'] - 1);
                                                  // updateQuantity(cartItem, -1);
                                                },
                                              ),
                                              Text(
                                                cartItem['quantity'].toString(),
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.add,
                                                  size: 20,
                                                  color: Colors.indigo,
                                                ),
                                                onPressed: () {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                    content: Text(
                                                        " Added one more Quantity "),
                                                    duration: const Duration(
                                                        seconds: 1),
                                                    backgroundColor:
                                                        Colors.indigo.shade600,
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                  ));
                                                  cartProvider.updateCartItem(
                                                      cartItem['itemid'],
                                                      cartItem['quantity'] + 1);
                                                  // updateQuantity(cartItem, 1);
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Text('Quantity: ${cartItem['quantity']}'),
                                  const SizedBox(height: 5),
                                  Text(
                                      '₹ ${cartItem['itemprice'].toStringAsFixed(2)}'),
                                  const SizedBox(height: 5),
                                  const Divider(
                                    thickness: 2,
                                  ),
                                  SizedBox(height: 10),
                                  InkWell(
                                    onTap: () {
Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MyHomePage(selectindex: 2)));
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: const [
                                        Icon(
                                          Icons.add_circle_outline_rounded,
                                        ),
                                        SizedBox(width: 5),
                                        Text("Add more items "),
                                        Spacer(),
                                        Icon(
                                          Icons.arrow_forward_ios_outlined,
                                        ),
                                        SizedBox(width: 5),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 15),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: const [
                                      Icon(
                                        Icons.edit_document,
                                      ),
                                      SizedBox(width: 5),
                                      Text("Add cooking instructions"),
                                      Spacer(),
                                      Icon(
                                        Icons.arrow_forward_ios_outlined,
                                      ),
                                      SizedBox(width: 5),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 0,
                left: 0,
                child: Column(
                  children: [
                    Text('Total Price: ₹$totalCartPrice'),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Groceries_upi_payment(),
                          ),
                        );
                      },
                      child: Text('Proceed to Payment'),
                    ),
                  ],
                ),
              ),
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
                                    builder: ((context) =>
                                        Groceries_upi_payment()),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 239, 49, 49),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                width: MediaQuery.of(context).size.width * 0.6,
                                height: 60,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
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
                                                "₹${totalCartPrice}",
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
            ]);
          }
        },
      ),
    );
  }
}
