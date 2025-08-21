import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uber_eats/Add_address/add_address.dart';
import 'package:uber_eats/Payment_methods/new_payment.dart';
import 'package:uber_eats/Utils/utils.dart';
import 'package:uber_eats/model/cart.dart';

class GroceriesCartScreen extends StatefulWidget {
  const GroceriesCartScreen({Key? key}) : super(key: key);

  @override
  State<GroceriesCartScreen> createState() => _GroceriesCartScreenState();
}

class _GroceriesCartScreenState extends State<GroceriesCartScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String formattedAddress = '';
  late DateTime _selectedDate = DateTime.now();
  bool isStandardDeliverySelected = true;
  User? _user;
  late double discountprice = 0.0;
  late String promecodetext = '';

  void removeFromCart(GroceriesCartItem cartItem) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(_user!.uid)
        .collection('GroceriesCart')
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
      GroceriesCartItem cartItem, int quantityChange) async {
    try {
      int newQuantity = cartItem.quantity + quantityChange;
      if (newQuantity > 0) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_user!.uid)
            .collection('GroceriesCart')
            .doc(cartItem.itemId)
            .update({
          'quantity': newQuantity,
        });
      } else {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_user!.uid)
            .collection('GroceriesCart')
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
    CollectionReference groceries =
        FirebaseFirestore.instance.collection('deals');
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(_user!.uid)
            .collection('GroceriesCart')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              formattedAddress.isEmpty) {
            return Shimmer.fromColors(
              period: const Duration(milliseconds: 1500),
              direction: ShimmerDirection.ltr,
              // int loop = 0,
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: 40.0,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            );
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
            List<GroceriesCartItem> cartItems = snapshot.data!.docs
                .map((doc) => GroceriesCartItem.fromFirestore(doc))
                .toList();

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SizedBox(height: 15),
                    // Text(
                    //   "Groceries Cart",
                    //   style: TextStyle(
                    //     fontSize: MediaQuery.of(context).size.width * 0.08,
                    //     color: Colors.black,
                    //     fontFamily: "MonaSans",
                    //     fontWeight: FontWeight.w700,
                    //   ),
                    // ),
                    SizedBox(height: 20),
                    if (formattedAddress.isNotEmpty)
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) {
                                return AnimatedBuilder(
                                  animation: animation,
                                  builder: (context, child) {
                                    return SlideTransition(
                                      position: Tween<Offset>(
                                        begin: const Offset(0, 1),
                                        end: Offset.zero,
                                      ).animate(animation),
                                      child: child,
                                    );
                                  },
                                  child: AddAddressScreen(),
                                );
                              },
                              transitionDuration: Duration(milliseconds: 500),
                            ),
                          );
                        },
                        child: Row(
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
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
                                    Row(
                                      children: [
                                        Text(
                                          "₹ ${cartItem.price.toString()} ",
                                          style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.038,
                                            color: Colors.black,
                                            fontFamily: "Quicksand",
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Text(
                                          "/ ${cartItem.weight.toString()}",
                                          style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.038,
                                            color: Colors.grey.shade300,
                                            fontFamily: "Quicksand",
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
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
                    SizedBox(height: 25),
                    Text(
                      "Add more items",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.040,
                          color: Colors.black,
                          fontFamily: "MonaSans",
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 20),
                    StreamBuilder<QuerySnapshot>(
                      stream: groceries
                          // .orderBy('time', descending: false)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        }

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
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      height: 30.0,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Text('No restaurants found');
                        }
                        return SizedBox(
                          height: MediaQuery.of(context).size.height * 0.26,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              final restaurantData = snapshot.data!.docs[index]
                                  .data() as Map<String, dynamic>;
                              return GestureDetector(
                                onTap: () {
                                  if (restaurantData.containsKey('id')) {
                                  } else {
                                    print(
                                        'Restaurant ID is missing in restaurantData');
                                  }
                                },
                                child: Deals_Card(
                                  groceriesData: restaurantData,
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                    Divider(
                      thickness: 1.5,
                      color: Colors.grey.shade200,
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
                        // Convert GroceriesCartItem to CartSavedItem
                        List<CartSavedItem> convertedItems = cartItems.map((item) => CartSavedItem(
                          itemId: item.itemId,
                          name: item.name,
                          price: item.price,
                          quantity: item.quantity,
                          imageUrl: item.imageUrl,
                          vegnoo: '',  // Not available in GroceriesCartItem
                          addonprice: 0.0,  // Not available in GroceriesCartItem
                          weight: item.weight,
                          Restauranname: 'Grocery Store',  // Default for groceries
                          restaurantloaction: '',  // Not available
                          restaurantlatitude: '',  // Not available
                          restaurantlongtude: '',  // Not available
                        )).toList();
                        
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => upi_payment(
                                    totalPrice: _FoodcalculateofferTotalPrice(cartItems),
                                    discountprice: 0,
                                    cartItems: convertedItems))));
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
    List<GroceriesCartItem> cartItems,
  ) {
    double Price = 0;
    double totalprice = 0;
    for (final cartItem in cartItems) {
      Price +=  cartItem.quantity;
      totalprice = Price - discountprice + 40 + 20;
    }
    return totalprice;
  }

  double _FoodcalculateTotalPrice(
    List<GroceriesCartItem> cartItems,
  ) {
    double totalPrice = 0;
    for (final cartItem in cartItems) {
      totalPrice +=  cartItem.quantity;
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
                                  // ❤️
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

class Deals_Card extends StatefulWidget {
  final Map<String, dynamic> groceriesData;

  const Deals_Card({super.key, required this.groceriesData});

  @override
  State<Deals_Card> createState() => _Deals_CardState();
}

class _Deals_CardState extends State<Deals_Card> {
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
        double totalItemPrice = widget.groceriesData['price'];
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
          // If item doesn't exist in cart, add it with the quantity set to quantityChange
          await FirebaseFirestore.instance
              .collection('users')
              .doc(_user!.uid)
              .collection('GroceriesCart')
              .doc(widget.groceriesData['id'])
              .set({
            'itemid': widget.groceriesData['id'],
            'itemimage': widget.groceriesData['imageUrl'],
            'itemname': widget.groceriesData['name'],
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
        // decoration: BoxDecoration(
        //     color: Colors.white,
        //     border: Border.all(width: 1, color: Colors.grey.shade300),
        //     borderRadius: BorderRadius.circular(10),
        //     boxShadow: [
        //       BoxShadow(
        //           offset: Offset(1, 2),
        //           color: Colors.grey.shade200,
        //           spreadRadius: 2,
        //           blurRadius: 3)
        //     ]),
        child: Column(
          children: [
            Container(
              width: width * 0.3,
              height: width * 0.3,
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
                            widget.groceriesData['imageUrl'],
                          ),
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 10,
                    top: 0,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          "assets/Offers/offer_tag.png",
                          scale: 2.5,
                        ),
                        Center(
                          child: Text(
                            "${widget.groceriesData['offers']}%\noff",
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.028,
                                color: Colors.black,
                                fontFamily: "Quicksand",
                                fontWeight: FontWeight.w800),
                          ),
                        )
                      ],
                    ),
                  ),
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
                          return Shimmer_loading();
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
                                        0.20,
                                    height: 25,
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
                                        width: 30,
                                        height: 30,
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
              width: width * 0.3,
              height: width * 0.2,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5),
                  Text(
                    '${widget.groceriesData['name'].split(' ').take(4).join(' ')}',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.035,
                        color: Colors.black,
                        fontFamily: "Quicksand",
                        fontWeight: FontWeight.w900),
                  ),
                  Text(
                    "₹${widget.groceriesData['price']}/ ${widget.groceriesData['weight']}",
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.032,
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
