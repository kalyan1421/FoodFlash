// // ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottie/lottie.dart';
import 'package:uber_eats/Payment_methods/new_payment.dart';
import 'package:uber_eats/Utils/utils.dart';
import 'package:uber_eats/model/cart.dart';

class Food_Cart_screen extends StatefulWidget {
  const Food_Cart_screen({Key? key}) : super(key: key);

  @override
  State<Food_Cart_screen> createState() => _Food_Cart_screenState();
}

class _Food_Cart_screenState extends State<Food_Cart_screen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String formattedAddress = '';
  late DateTime _selectedDate = DateTime.now();
  bool isStandardDeliverySelected = true;
  User? _user;
  late double discountprice = 0.0;
  late String promecodetext = '';

  void removeFromCart(CartSavedItem cartItem) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(_user!.uid)
        .collection('cart')
        .doc(cartItem.itemId)
        .delete()
        .then((value) {})
        .catchError((error) {
      print("Error removing item from cart: $error");
    });
  }

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
    fetchLatestAddress();
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

  void fetchLatestAddress() async {
    if (_user != null) {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(_user!.uid)
          .collection('addresses')
          .orderBy('createdAt', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        Map<String, dynamic> data = snapshot.docs.first.data();
        formattedAddress = data['formattedAddress'];
        if (mounted) {
          setState(() {});
        }
      } else {
        print('No address found for the user.');
      }
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
          if (snapshot.connectionState == ConnectionState.waiting ||
              formattedAddress.isEmpty) {
            return Shimmer_loading();
          } else if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Your cart is empty",
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.08,
                      color: Colors.black,
                      fontFamily: "MonaSans",
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    "Your have no item in your cart",
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                      color: Colors.grey.shade600,
                      fontFamily: "MonaSans",
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    "Let's go add items ",
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                      color: Colors.grey.shade600,
                      fontFamily: "MonaSans",
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Lottie.asset('assets/Offers/empty-cart.json',
                      // fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.5),
                ],
              ),
            );
          } else {
            List<CartSavedItem> cartItems = snapshot.data!.docs
                .map((doc) => CartSavedItem.fromFirestore(doc))
                .toList();

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15),
                    Text(
                      "Cart",
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.08,
                        color: Colors.black,
                        fontFamily: "MonaSans",
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 20),
                    // Display user's location only if formattedAddress is not empty
                    if (formattedAddress.isNotEmpty)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Ionicons.location_outline,
                            size: 35,
                          ),
                          SizedBox(width: 10),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Delivery Address",
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.04,
                                    color: Colors.black,
                                    fontFamily: "MonaSans",
                                    fontWeight: FontWeight.w600),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: Text(
                                  formattedAddress,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.035,
                                    color: Colors.grey.shade600,
                                    fontFamily: "Quicksand",
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Expanded(child: SizedBox()),
                          Icon(
                            Icons.arrow_forward_ios_sharp,
                            size: 20,
                          )
                        ],
                      ),
                    SizedBox(height: 20),
                    Divider(
                      thickness: 2,
                      color: Colors.grey.shade300,
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          "Items in your cart",
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.045,
                              color: Colors.black,
                              fontFamily: "MonaSans",
                              letterSpacing: 0.5,
                              fontWeight: FontWeight.w900),
                        ),
                        Expanded(child: SizedBox()),
                        Text(
                          "+ Add more items",
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.035,
                              color: Colors.green,
                              fontFamily: "MonaSans",
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final cartItem = cartItems[index];
                        return Container(
                          // color: Colors.amber,
                          width: MediaQuery.of(context).size.width,
                          height: 100,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(cartItem.imageUrl),
                                      ),
                                    ),
                                  ),
                                  if (cartItem.vegnoo == 'non')
                                    Positioned(
                                      bottom: 10,
                                      left: 5,
                                      child: Container(
                                          alignment: Alignment.center,
                                          width: 18,
                                          height: 18,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(2),
                                              border: Border.all(
                                                  width: 2, color: Colors.red),
                                              color: Colors.white),
                                          child: Container(
                                            width: 10,
                                            height: 10,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.red),
                                          )),
                                    )
                                  else
                                    Positioned(
                                      bottom: 10,
                                      left: 5,
                                      child: Container(
                                          alignment: Alignment.center,
                                          width: 18,
                                          height: 18,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(2),
                                              border: Border.all(
                                                  width: 2,
                                                  color: Colors.green),
                                              color: Colors.white),
                                          child: Container(
                                            width: 10,
                                            height: 10,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.green),
                                          )),
                                    ),
                                ],
                              ),
                              SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      cartItem.name,
                                      style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.038,
                                        color: Colors.black,
                                        fontFamily: "Quicksand",
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      "₹ ${cartItem.price.toString()}",
                                      style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.038,
                                        color: Colors.grey.shade400,
                                        fontFamily: "Quicksand",
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(child: SizedBox()),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                    width: MediaQuery.of(context).size.width *
                                        0.22,
                                    height: 30,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(height: 3),
                                        InkWell(
                                          onTap: () {
                                            if (cartItem.quantity > 1) {
                                              _updateQuantity(cartItem, -1);
                                            } else {
                                              removeFromCart(cartItem);
                                            }
                                            // showCustomSnackBar(context,
                                            //     "Item removed from cart");
                                          },
                                          child: Icon(
                                            Icons.remove,
                                            size: 25,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          "${cartItem.quantity}",
                                          // _quantity.toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16),
                                        ),
                                        InkWell(
                                          child: const Icon(
                                            Icons.add,
                                            size: 25,
                                            color: Colors.black,
                                          ),
                                          onTap: () {
                                            _updateQuantity(cartItem, 1);
                                            // showCustomSnackBar(
                                            //     context, "Item added to cart");
                                            // addToCart(1);
                                          },
                                        ),
                                        SizedBox(height: 3),
                                      ],
                                    ),
                                  ),
                                  Expanded(child: SizedBox()),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      alignment: Alignment.centerLeft,
                      width: MediaQuery.of(context).size.width,
                      height: 45,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(5)),
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Add cooking instructions",
                          hintStyle: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.035,
                              color: Colors.black54,
                              fontFamily: "Quicksand",
                              fontWeight: FontWeight.w600),
                        ),
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.035,
                            color: Colors.black54,
                            fontFamily: "Quicksand",
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Delivery Time",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.045,
                          color: Colors.black,
                          fontFamily: "MonaSans",
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.w900),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                isStandardDeliverySelected = true;
                              });
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.42,
                              height: 60,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1.5,
                                  color: isStandardDeliverySelected
                                      ? Colors.black
                                      : Colors.grey.shade200,
                                ),
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Ionicons.time_outline,
                                    size: 30,
                                  ),
                                  SizedBox(width: 5),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Standard",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontFamily: "MonaSans",
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      Text(
                                        "25-30 mins",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade500,
                                          fontFamily: "MonaSans",
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 10)
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                isStandardDeliverySelected = false;
                              });
                              _showDateTimePicker(context);
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.42,
                              height: 60,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1.5,
                                    color: isStandardDeliverySelected
                                        ? Colors.grey.shade200
                                        : Colors.black,
                                  ),
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Ionicons.calendar_outline,
                                      size: 26,
                                    ),
                                    SizedBox(width: 5),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Schedule",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontFamily: "MonaSans",
                                              fontWeight: FontWeight.w800),
                                        ),
                                        Text(
                                          _selectedDate != DateTime.now()
                                              ? 'Selected time: \n ${DateFormat('hh:mm a').format(_selectedDate)}'
                                              : 'Select time',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade500,
                                            fontFamily: "MonaSans",
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 10)
                                  ]),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 25),
                    Divider(
                      thickness: 1,
                      color: Colors.grey.shade300,
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: InkWell(
                        onTap: () {
                          _showDeliveryInstructions(context);
                        },
                        child: Row(
                          children: [
                            Icon(
                              Ionicons.layers_outline,
                              size: 35,
                            ),
                            SizedBox(width: 15),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Delivery Instructions",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontFamily: "MonaSans",
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  "Leave At Door",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade500,
                                    fontFamily: "Quicksand",
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              ],
                            ),
                            Expanded(child: SizedBox()),
                            Icon(
                              Icons.arrow_forward_ios_sharp,
                              size: 20,
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Divider(
                      thickness: 1,
                      color: Colors.grey.shade300,
                    ),
                    SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        _showPromoCodeEntry(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            Icon(
                              Ionicons.pricetag_outline,
                              size: 35,
                            ),
                            SizedBox(width: 15),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Prome code apply",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontFamily: "MonaSans",
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (discountprice == 0.0)
                                  Text(
                                    "Apply Coupon",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.green,
                                      fontFamily: "Quicksand",
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                if (discountprice > 0.0)
                                  Row(
                                    children: [
                                      Text(
                                        "$promecodetext",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.green,
                                          fontFamily: "Quicksand",
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(width: 3),
                                      Text(
                                        "₹ $discountprice",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontFamily: "Quicksand",
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        "Coupon Saving",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey.shade500,
                                          fontFamily: "Quicksand",
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  )
                              ],
                            ),
                            Expanded(child: SizedBox()),
                            Icon(
                              Icons.arrow_forward_ios_sharp,
                              size: 20,
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Divider(
                      thickness: 1,
                      color: Colors.grey.shade300,
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Bill Deatils",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.045,
                          color: Colors.black,
                          fontFamily: "Quicksand",
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.w900),
                    ),
                    SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Subtotal",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade500,
                              fontFamily: "Quicksand",
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "₹${_FoodcalculateTotalPrice(cartItems).toString()}",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontFamily: "Quicksand",
                              letterSpacing: 1,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Promocode",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade500,
                              fontFamily: "Quicksand",
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "- $discountprice",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.green,
                              fontFamily: "Quicksand",
                              letterSpacing: 1,
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Delivery free",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade500,
                              fontFamily: "Quicksand",
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "20.0",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontFamily: "Quicksand",
                              letterSpacing: 1,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Taxs & other fees",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade500,
                              fontFamily: "Quicksand",
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "40.0",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontFamily: "Quicksand",
                              letterSpacing: 1,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Total",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontFamily: "Quicksand",
                              fontWeight: FontWeight.w700),
                        ),
                        Text(
                          "₹${_FoodcalculateofferTotalPrice(cartItems).toString()}",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontFamily: "Quicksand",
                              letterSpacing: 1,
                              fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => My_1HomePage())));
                        //     upi_payment(
                        //         totalPrice:
                        //             _FoodcalculateofferTotalPrice(cartItems),
                        //         discountprice: discountprice,
                        //         cartItems: cartItems)),
                        //   ),
                        // );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          "Make Payment",
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                            color: Colors.white,
                            fontFamily: "MonaSans",
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        width: MediaQuery.of(context).size.width,
                        height: 45,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(5)),
                      ),
                    ),
                    SizedBox(height: 20)
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Future<void> _showDateTimePicker(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 30)),
    );

    if (pickedDate != null) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void _showDeliveryInstructions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Text('Delivery Instructions'),
        );
      },
    );
  }

  double _FoodcalculateofferTotalPrice(
    List<CartSavedItem> cartItems,
  ) {
    double Price = 0;
    double totalprice = 0;
    for (final cartItem in cartItems) {
      Price += cartItem.addonprice * cartItem.quantity;
      totalprice = Price - discountprice + 40 + 20;
    }
    return totalprice;
  }

  double _FoodcalculateTotalPrice(
    List<CartSavedItem> cartItems,
  ) {
    double totalPrice = 0;
    for (final cartItem in cartItems) {
      totalPrice += cartItem.addonprice * cartItem.quantity;
    }
    return totalPrice;
  }

  void _applyBankOffer(
      BuildContext context, double discountAmount, String promecode) {
    setState(() {
      discountprice = discountAmount;
      promecodetext = promecode;
    });
    Navigator.pop(context);
  }

  void _showPromoCodeEntry(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              height: MediaQuery.of(context).size.height * 0.8,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back,
                          size: 35,
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        "Coupons",
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.08,
                            color: Colors.black,
                            fontFamily: "Quicksand",
                            fontWeight: FontWeight.w900),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            alignment: Alignment.centerLeft,
                            width: MediaQuery.of(context).size.width * 0.7,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                            ),
                            child: TextField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Enter coupons",
                                hintStyle: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.035,
                                    color: Colors.black54,
                                    fontFamily: "Quicksand",
                                    fontWeight: FontWeight.w600),
                              ),
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.045,
                                  color: Colors.black54,
                                  fontFamily: "Quicksand",
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              alignment: Alignment.center,
                              height: 50,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      bottomRight: Radius.circular(10))),
                              child: Text(
                                "Apply",
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.045,
                                    color: Colors.white,
                                    fontFamily: "Quicksand",
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Available coupons",
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.045,
                            color: Colors.black,
                            fontFamily: "MonaSans",
                            fontWeight: FontWeight.w800),
                      ),
                      SizedBox(height: 20),
                      InkWell(
                        onTap: () {
                          _applyBankOffer(context, 100, "50%FOOD");
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Lottie.asset('assets/Offers/offer_animation.json',
                                // fit: BoxFit.cover,
                                width: MediaQuery.of(context).size.height * 0.1,
                                height:
                                    MediaQuery.of(context).size.height * 0.1),
                            // Image.network(
                            // "https://5.imimg.com/data5/RE/SP/EN/SELLER-95153528/hdfc-logo.png",),
                            SizedBox(width: 10),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(6)),
                                  child: Text(
                                    "50%FOOD",
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.030,
                                        color: Colors.black87,
                                        fontFamily: "Quicksand",
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                SizedBox(height: 3),
                                Text(
                                  "50% off up to ₹ 150",
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.035,
                                      color: Colors.black,
                                      letterSpacing: .5,
                                      fontFamily: "Quicksand",
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(height: 3),
                                InkWell(
                                    onTap: () {
                                      print("Details");
                                    },
                                    child: Row(
                                      children: [
                                        Text(
                                          "View Details",
                                          style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.032,
                                              color: Colors.black,
                                              fontFamily: "Quicksand",
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Icon(
                                          Icons.keyboard_arrow_down,
                                          size: 25,
                                        )
                                      ],
                                    ))
                              ],
                            ),
                            Expanded(child: SizedBox()),
                            InkWell(
                              onTap: () {
                                _applyBankOffer(context, 100, "50%FOOD");
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  "Apply",
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.045,
                                      color: Colors.green,
                                      fontFamily: "MonaSans",
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Divider(
                        thickness: 1.5,
                        color: Colors.grey.shade300,
                      ),
                      SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                          _applyBankOffer(context, 80, "HDFCBANK");
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(15),
                              width: MediaQuery.of(context).size.height * 0.1,
                              height: MediaQuery.of(context).size.height * 0.1,
                              decoration: BoxDecoration(
                                  // image: DecorationImage(
                                  //     image: NetworkImage(
                                  //         "https://5.imimg.com/data5/RE/SP/EN/SELLER-95153528/hdfc-logo.png"),
                                  //     scale: 10),
                                  ),
                              child: Image.network(
                                "https://5.imimg.com/data5/RE/SP/EN/SELLER-95153528/hdfc-logo.png",
                              ),
                            ),
                            SizedBox(width: 10),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(6)),
                                  child: Text(
                                    "HDFCBANK",
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.030,
                                        color: Colors.black87,
                                        fontFamily: "Quicksand",
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                SizedBox(height: 3),
                                Text(
                                  "40% off up to ₹ 80",
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.035,
                                      color: Colors.black,
                                      letterSpacing: .5,
                                      fontFamily: "Quicksand",
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(height: 3),
                                InkWell(
                                    onTap: () {
                                      print("Details");
                                    },
                                    child: Row(
                                      children: [
                                        Text(
                                          "View Details",
                                          style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.032,
                                              color: Colors.black,
                                              fontFamily: "Quicksand",
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Icon(
                                          Icons.keyboard_arrow_down,
                                          size: 25,
                                        )
                                      ],
                                    ))
                              ],
                            ),
                            Expanded(child: SizedBox()),
                            InkWell(
                              onTap: () {
                                _applyBankOffer(context, 80, "HDFCBANK");
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  "Apply",
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.045,
                                      color: Colors.green,
                                      fontFamily: "MonaSans",
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Divider(
                        thickness: 1.5,
                        color: Colors.grey.shade300,
                      ),
                      SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                          _applyBankOffer(context, 120, "SBIBANK");
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(15),
                              width: MediaQuery.of(context).size.height * 0.1,
                              height: MediaQuery.of(context).size.height * 0.1,
                              decoration: BoxDecoration(
                                  // image: DecorationImage(
                                  //     image: NetworkImage(
                                  //         "https://5.imimg.com/data5/RE/SP/EN/SELLER-95153528/hdfc-logo.png"),
                                  //     scale: 10),
                                  ),
                              child: Image.network(
                                "https://www.goodreturns.in/img/2016/10/sbi-logo-07-1475818362.jpg",
                              ),
                            ),
                            SizedBox(width: 10),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(6)),
                                  child: Text(
                                    "SBIBANK",
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.030,
                                        color: Colors.black87,
                                        fontFamily: "Quicksand",
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                SizedBox(height: 3),
                                Text(
                                  "45% off up to ₹ 120",
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.035,
                                      color: Colors.black,
                                      letterSpacing: .5,
                                      fontFamily: "Quicksand",
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(height: 3),
                                InkWell(
                                    onTap: () {
                                      print("Details");
                                    },
                                    child: Row(
                                      children: [
                                        Text(
                                          "View Details",
                                          style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.032,
                                              color: Colors.black,
                                              fontFamily: "Quicksand",
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Icon(
                                          Icons.keyboard_arrow_down,
                                          size: 25,
                                        )
                                      ],
                                    ))
                              ],
                            ),
                            Expanded(child: SizedBox()),
                            InkWell(
                              onTap: () {
                                _applyBankOffer(context, 60, "PAYTM");
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  "Apply",
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.045,
                                      color: Colors.green,
                                      fontFamily: "MonaSans",
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Divider(
                        thickness: 1.5,
                        color: Colors.grey.shade300,
                      ),
                      SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                          _applyBankOffer(context, 120, "SBIBANK");
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(15),
                              width: MediaQuery.of(context).size.height * 0.1,
                              height: MediaQuery.of(context).size.height * 0.1,
                              decoration: BoxDecoration(
                                  // image: DecorationImage(
                                  //     image: NetworkImage(
                                  //         "https://5.imimg.com/data5/RE/SP/EN/SELLER-95153528/hdfc-logo.png"),
                                  //     scale: 10),
                                  ),
                              child: Image.network(
                                "https://static.vecteezy.com/system/resources/previews/020/190/704/original/paytm-logo-paytm-icon-free-free-vector.jpg",
                              ),
                            ),
                            SizedBox(width: 10),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(6)),
                                  child: Text(
                                    "SBIBANK",
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.030,
                                        color: Colors.black87,
                                        fontFamily: "Quicksand",
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                SizedBox(height: 3),
                                Text(
                                  "30% off up to ₹ 60",
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.035,
                                      color: Colors.black,
                                      letterSpacing: .5,
                                      fontFamily: "Quicksand",
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(height: 3),
                                InkWell(
                                    onTap: () {
                                      print("Details");
                                    },
                                    child: Row(
                                      children: [
                                        Text(
                                          "View Details",
                                          style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.032,
                                              color: Colors.black,
                                              fontFamily: "Quicksand",
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Icon(
                                          Icons.keyboard_arrow_down,
                                          size: 25,
                                        )
                                      ],
                                    ))
                              ],
                            ),
                            Expanded(child: SizedBox()),
                            InkWell(
                              onTap: () {
                                _applyBankOffer(context, 60, "PAYTM");
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  "Apply",
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.045,
                                      color: Colors.green,
                                      fontFamily: "MonaSans",
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:uber_eats/Payment_methods/Food_upi_payment.dart';
// import 'package:uber_eats/dash_screen.dart';
// import 'package:uber_eats/model/cart.dart';

// class Food_cart_Screen extends StatefulWidget {
//   const Food_cart_Screen({super.key});

//   @override
//   State<Food_cart_Screen> createState() => _Food_cart_ScreenState();
// }

// class _Food_cart_ScreenState extends State<Food_cart_Screen> {
//   final FirebaseFirestore firestore = FirebaseFirestore.instance;

//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   List<CartSavedItem> cartItems = [];

//   User? _user;

//   @override
//   void initState() {
//     super.initState();
//     _user = _auth.currentUser;
//   }

//   double _FoodcalculateTotalPrice(List<CartSavedItem> cartItems) {
//     double totalPrice = 0;
//     for (final cartItem in cartItems) {
//       totalPrice += cartItem.price * cartItem.quantity;
//     }
//     return totalPrice;
//   }

//   Future<void> _updateQuantity(
//       CartSavedItem cartItem, int quantityChange) async {
//     try {
//       int newQuantity = cartItem.quantity + quantityChange;
//       if (newQuantity > 0) {
//         await FirebaseFirestore.instance
//             .collection('users')
//             .doc(_user!.uid)
//             .collection('cart')
//             .doc(cartItem.itemId)
//             .update({
//           'quantity': newQuantity,
//         });
//       } else {
//         await FirebaseFirestore.instance
//             .collection('users')
//             .doc(_user!.uid)
//             .collection('cart')
//             .doc(cartItem.itemId)
//             .delete();
//       }
//     } catch (e) {
//       print('Error updating quantity: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: StreamBuilder<QuerySnapshot>(
//           stream: FirebaseFirestore.instance
//               .collection('users')
//               .doc(_user!.uid)
//               .collection('cart')
//               .snapshots(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return Center(child: const CircularProgressIndicator());
//             }
//             if (snapshot.hasError) {
//               return Center(child: Text('Error: ${snapshot.error}'));
//             }
//             if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//               return const Center(child: Text('Cart is empty.'));
//             }

//             List<CartSavedItem> cartItems = snapshot.data!.docs
//                 .map((doc) => CartSavedItem.fromFirestore(doc))
//                 .toList();
//             return Stack(
//               alignment: AlignmentDirectional.topStart,
//               children: [
//                 StreamBuilder<QuerySnapshot>(
//                   stream: FirebaseFirestore.instance
//                       .collection('users')
//                       .doc(_user!.uid)
//                       .collection('cart')
//                       .snapshots(),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return Center(child: const CircularProgressIndicator());
//                     }
//                     if (snapshot.hasError) {
//                       return Text('Error: ${snapshot.error}');
//                     }
//                     if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                       return const Center(child: Text('Cart is empty.'));
//                     }
//                     List<CartSavedItem> cartItems = snapshot.data!.docs
//                         .map((doc) => CartSavedItem.fromFirestore(doc))
//                         .toList();
//                     return Column(
//                       // mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         SizedBox(height: 5),
//                         Text(
//                           "ITEM(S)  ADDED",
//                           textAlign: TextAlign.center,
//                           style: GoogleFonts.notoSerif(
//                               fontSize: 18,
//                               color: Colors.grey.shade800,
//                               letterSpacing: 1),
//                         ),
//                         SizedBox(
//                           height: MediaQuery.of(context).size.height - 240,
//                           child: ListView.builder(
//                             itemCount: cartItems.length,
//                             itemBuilder: (context, index) {
//                               final cartItem = cartItems[index];
//                               return Card(
//                                   shadowColor: Colors.grey,
//                                   elevation: 5,
//                                   shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(10)),
//                                   color: Colors.white,
//                                   child: Container(
                               
//                                     width:
//                                         MediaQuery.of(context).size.width * 0.8,
//                                     height: 220,
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                         children: [
//                                           Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               Text(
//                                                 cartItem.name,
//                                                 style: const TextStyle(
//                                                     fontWeight: FontWeight.bold,
//                                                     fontSize: 20),
//                                               ),
//                                               Stack(
//                                                   alignment: Alignment.center,
//                                                   children: [
//                                                     Container(
//                                                       decoration: BoxDecoration(
//                                                           border: Border.all(
//                                                               width: 2,
//                                                               color: Colors
//                                                                   .indigo
//                                                                   .shade300),
//                                                           borderRadius:
//                                                               BorderRadius
//                                                                   .circular(5),
//                                                           color: Colors
//                                                               .indigo.shade200
//                                                               .withOpacity(
//                                                                   0.5)),
//                                                       width: 80,
//                                                       height: 25,
//                                                     ),
//                                                     Row(
//                                                       mainAxisAlignment:
//                                                           MainAxisAlignment
//                                                               .spaceEvenly,
//                                                       crossAxisAlignment:
//                                                           CrossAxisAlignment
//                                                               .center,
//                                                       children: [
//                                                         IconButton(
//                                                           icon: const Icon(
//                                                             Icons.remove,
//                                                             size: 20,
//                                                             color:
//                                                                 Colors.indigo,
//                                                           ),
//                                                           onPressed: () {
//                                                             ScaffoldMessenger
//                                                                     .of(context)
//                                                                 .showSnackBar(
//                                                                     SnackBar(
//                                                               content: const Text(
//                                                                   "Item Removed"),
//                                                               duration:
//                                                                   const Duration(
//                                                                       seconds:
//                                                                           1),
//                                                               backgroundColor:
//                                                                   Colors.indigo
//                                                                       .shade600,
//                                                               behavior:
//                                                                   SnackBarBehavior
//                                                                       .floating,
//                                                             ));

//                                                             _updateQuantity(
//                                                                 cartItem, -1);
//                                                           },
//                                                         ),
//                                                         Text(
//                                                           cartItem.quantity
//                                                               .toString(),
//                                                           style: TextStyle(
//                                                               color:
//                                                                   Colors.black,
//                                                               fontSize: 14),
//                                                         ),
//                                                         IconButton(
//                                                           icon: const Icon(
//                                                             Icons.add,
//                                                             size: 20,
//                                                             color:
//                                                                 Colors.indigo,
//                                                           ),
//                                                           onPressed: () {
//                                                             ScaffoldMessenger
//                                                                     .of(context)
//                                                                 .showSnackBar(
//                                                                     SnackBar(
//                                                               content: Text(
//                                                                   " Added one more Quantity "),
//                                                               duration:
//                                                                   Duration(
//                                                                       seconds:
//                                                                           1),
//                                                               backgroundColor:
//                                                                   Colors.indigo
//                                                                       .shade600,
//                                                               behavior:
//                                                                   SnackBarBehavior
//                                                                       .floating,
//                                                             ));
//                                                             _updateQuantity(
//                                                                 cartItem, 1);
//                                                           },
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ]),
//                                             ],
//                                           ),
//                                           Text(
//                                               'Quantity: ${cartItem.quantity.toString()}'),
//                                           const SizedBox(
//                                             height: 5,
//                                           ),
//                                           Text(
//                                               '₹ ${cartItem.price.toStringAsFixed(2)}'),
//                                           const SizedBox(
//                                             height: 5,
//                                           ),
//                                           const Divider(
//                                             thickness: 2,
//                                           ),
//                                           SizedBox(height: 10),
//                                           InkWell(
//                                             onTap: () {
//                                               Navigator.push(
//                                                 context,
//                                                 MaterialPageRoute(
//                                                   builder: (context) =>
//                                                       const MyHomePage(),
//                                                 ),
//                                               );
//                                             },
//                                             child: Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment
//                                                       .spaceBetween,
//                                               children: [
//                                                 const Icon(Icons
//                                                     .add_circle_outline_rounded),
//                                                 const SizedBox(
//                                                   width: 5,
//                                                 ),
//                                                 const Text("Add more items "),
//                                                 const Spacer(),
//                                                 Icon(Icons
//                                                     .arrow_forward_ios_outlined),
//                                                 SizedBox(width: 5)
//                                               ],
//                                             ),
//                                           ),
//                                           SizedBox(height: 15),
//                                           Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               const Icon(Icons.edit_document),
//                                               const SizedBox(
//                                                 width: 5,
//                                               ),
//                                               const Text(
//                                                   "Add cooking instructions"),
//                                               // Text(
//                                               // 'Total Price: ₹ ${_calculateTotalPrice(cartItems).toStringAsFixed(2)}'),
//                                               const Spacer(),
//                                               Icon(Icons
//                                                   .arrow_forward_ios_outlined),
//                                               SizedBox(width: 5)
//                                             ],
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                   ));
//                             },
//                           ),
//                         ),
//                       ],
//                     );
//                   },
//                 ),
//                 // )
//                 Positioned(
//                   bottom: 0,
//                   child: Container(
//                     alignment: Alignment.bottomCenter,
//                     width: MediaQuery.of(context).size.width,
//                     height: 80,
//                     decoration: BoxDecoration(
//                       color: Colors.grey.shade200,
//                       borderRadius: const BorderRadius.only(
//                         topLeft: Radius.circular(15),
//                         topRight: Radius.circular(15),
//                       ),
//                     ),
//                     child: Column(
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             const SizedBox(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Padding(
//                                     padding: EdgeInsets.symmetric(
//                                         horizontal: 10, vertical: 5),
//                                     child: Row(
//                                       children: [
//                                         Icon(Icons.payment),
//                                         Text("Pay using"),
//                                         Icon(Icons.arrow_drop_up_outlined),
//                                       ],
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: EdgeInsets.symmetric(
//                                         horizontal: 10, vertical: 0),
//                                     child: Text(
//                                       "UPI app",
//                                       style: TextStyle(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 10, vertical: 10),
//                               child: InkWell(
//                                 onTap: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: ((context) => Food_upi_payment(
//                                           totalPrice: _FoodcalculateTotalPrice(
//                                               cartItems),
//                                           cartItems: cartItems)),
//                                     ),
//                                   );
//                                 },
//                                 child: Container(
//                                   decoration: const BoxDecoration(
//                                       color: Color.fromARGB(255, 239, 49, 49),
//                                       borderRadius: BorderRadius.all(
//                                           Radius.circular(15))),
//                                   width:
//                                       MediaQuery.of(context).size.width * 0.6,
//                                   height: 60,
//                                   child: Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 5),
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Padding(
//                                           padding: const EdgeInsets.all(5.0),
//                                           child: Center(
//                                             child: Column(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.center,
//                                               children: [
//                                                 Text(
//                                                   "₹${_FoodcalculateTotalPrice(cartItems).toString()}",
//                                                   style: const TextStyle(
//                                                     fontSize: 18,
//                                                     color: Colors.white,
//                                                     fontWeight: FontWeight.bold,
//                                                   ),
//                                                 ),
//                                                 SizedBox(height: 4),
//                                                 const Text(
//                                                   "TOTAL",
//                                                   style: TextStyle(
//                                                       color: Colors.white,
//                                                       fontSize: 12),
//                                                 )
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                         const SizedBox(width: 15),
//                                         const Text(
//                                           "Place Order",
//                                           style: TextStyle(
//                                               color: Colors.white,
//                                               fontSize: 18,
//                                               fontWeight: FontWeight.w600,
//                                               letterSpacing: 1),
//                                         ),
//                                         const Icon(
//                                           Icons.arrow_right,
//                                           color: Colors.white,
//                                         ),
//                                         const Expanded(child: SizedBox())
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             )
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 100,
//                 )
//               ],
//             );
//           }),
//     );
//   }
// }
