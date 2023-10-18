// ignore_for_file: file_names, camel_case_types, library_private_types_in_public_api, use_build_context_synchronously, avoid_print
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:ionicons/ionicons.dart';
import 'package:uber_eats/Pages/Cart_page.dart';
import 'package:uber_eats/Utils/utils.dart';

class RestaurantDetailsPage extends StatefulWidget {
  final String restaurantId;

  const RestaurantDetailsPage({super.key, required this.restaurantId});

  @override
  _RestaurantDetailsPageState createState() => _RestaurantDetailsPageState();
}

class _RestaurantDetailsPageState extends State<RestaurantDetailsPage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _user;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
  }

  Stream<QuerySnapshot> getMenuItemsStream() {
    return FirebaseFirestore.instance
        .collection('Restaurants')
        .doc(widget.restaurantId)
        .collection('menuItems')
        .snapshots();
  }

  Future<void> addToCart(Map<String, dynamic> itemData) async {
    try {
      if (_user != null) {
        await firestore
            .collection('users')
            .doc(_user!.uid)
            .collection('cart')
            .add({
          'itemID': itemData['itemId'],
          'itemimage': itemData['itemImageUrl'],
          'itemname': itemData['name'],
          'itemprice': itemData['price'],
          'timestamp': FieldValue.serverTimestamp()
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Item added to cart'),
          ),
        );
        print('Item added to cart successfully!');
      } else {
        print('User is not authenticated. Cannot add to cart.');
      }
    } catch (e) {
      print('Error adding item to cart: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const CartScreen()));
        },
        backgroundColor: Colors.amber.shade800,
        child: const Icon(
          Icons.shopping_basket_outlined,
          size: 40,
        ),
      ),
      backgroundColor: Colors.grey.shade200,
      body: StreamBuilder<DocumentSnapshot>(
        stream: firestore
            .collection('Restaurants')
            .doc(widget.restaurantId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (!snapshot.hasData) {
            return const Text('Restaurant data not available');
          }

          final restaurantData = snapshot.data!.data() as Map<String, dynamic>;
          final String restaurantName = restaurantData['name'];
          final String restaurantImage = restaurantData['imageUrl'];

          return NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  leading: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      size: 30,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  backgroundColor: Colors.white,
                  elevation: 10,
                  collapsedHeight: 60,
                  shadowColor: Colors.grey,
                  expandedHeight: 250,
                  floating: false,
                  pinned: true,
                  // title: Text('${restaurantName} '),
                  flexibleSpace:
                      // color: Colors.black,
                      // child:
                      FlexibleSpaceBar(
                    titlePadding: const EdgeInsets.symmetric(horizontal: 0),
                    title: Text(
                      restaurantName,
                      style: const TextStyle(fontSize: 24, color: Colors.grey),
                    ),
                    centerTitle: true,
                    background: Image.network(
                      restaurantImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              ];
            },
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(15),
                          bottomLeft: Radius.circular(15)),
                      color: Colors.grey.shade300,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 20),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 100,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const SizedBox(width: 10),
                                const Icon(
                                  Icons.stars,
                                  color: Colors.green,
                                ),
                                Text(
                                  "${restaurantData['rating']} (14K+ rating)",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                const SizedBox(width: 5),
                                const Icon(
                                  Ionicons.alert_circle_outline,
                                  size: 18,
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  "₹200 for two",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                )
                              ],
                            ),
                            const SizedBox(height: 10),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Divider(
                                thickness: 2,
                                height: 3,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        "Outlet",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                        capitalize(restaurantData['address']),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Icon(
                                        Icons.arrow_drop_down,
                                        color: Colors.orange,
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Text(
                                        "${restaurantData["time"]} mins",
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(width: 20),
                                      const Location(),
                                      const Icon(
                                        Icons.arrow_drop_down,
                                        color: Colors.orange,
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Divider(
                                thickness: 2,
                                height: 3,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const SizedBox(width: 10),
                                Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          width: 1,
                                          color: Colors.grey.shade900)),
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    Icons.delivery_dining,
                                    color: Colors.amber,
                                    size: 25,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                const Text(
                                  "5.5 km",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                const SizedBox(width: 5),
                                Container(
                                  width: 2,
                                  height: 18,
                                  decoration:
                                      const BoxDecoration(color: Colors.grey),
                                ),
                                const SizedBox(width: 5),
                                const Text("Free Delivery on your order"),
                                const Expanded(child: SizedBox())
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(width: 3, color: Colors.grey),
                          borderRadius: BorderRadius.circular(20)),
                      width: MediaQuery.of(context).size.width,
                      height: 80,
                      child: Row(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset("assets/utiles/Offers-1.png"),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            verticalDirection: VerticalDirection.down,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text("50% off upto ₹100",
                                  style: TextStyle(
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "USE WELCOME50 ",
                                    style: TextStyle(
                                        letterSpacing: 1,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                  Container(
                                    width: 2,
                                    height: 18,
                                    decoration:
                                        const BoxDecoration(color: Colors.grey),
                                  ),
                                  const SizedBox(width: 5),
                                  const Text(
                                    "ABOVE ₹149",
                                    style: TextStyle(
                                        letterSpacing: 1,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  )
                                ],
                              ),
                            ],
                          ),
                          const Expanded(child: SizedBox())
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 6,
                        height: 1,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "MENU",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              letterSpacing: 2),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 6,
                        height: 1,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        const SizedBox(width: 10),
                        InkWell(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                // Setting the elevation to 0 to make the snack bar flat
                                elevation: 0,
                                content: Card(
                                  // Rounding the border of the card
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  // Setting the clipping behavior for the card
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  elevation: 1,
                                  child: Container(
                                    // Adding padding to the conta iner
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child: Row(
                                      children: [
                                        // Adding space to the left side
                                        const SizedBox(width: 5),
                                        const Expanded(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[Text("Pressed")],
                                          ),
                                        ),
                                        // Adding a vertical line between the product name and the undo button
                                        Container(
                                            color: Colors.grey,
                                            height: 35,
                                            width: 1,
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 5)),
                                        SnackBarAction(
                                          // Displaying the undo button
                                          label: "UNDO",
                                          textColor: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          // Callback function for when the undo button is pressed
                                          onPressed: () {},
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // Setting the background color to transparent
                                backgroundColor: Colors.transparent,
                                // Setting the duration for how long the snack bar should be visible
                                duration: const Duration(seconds: 3),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: Colors.grey.shade300, width: 2),
                              color: Colors.white,
                            ),
                            width: 110,
                            height: 35,
                            child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.sort_sharp),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Text(
                                    "Bestseller",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                ]),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: Colors.grey.shade300, width: 2),
                            color: Colors.white,
                          ),
                          width: 100,
                          height: 35,
                          child: const Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.star_purple500_rounded,
                                  color: Colors.amber,
                                ),
                                Text(
                                  "Top rated",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: Colors.grey.shade300, width: 2),
                            color: Colors.white,
                          ),
                          width: 100,
                          height: 40,
                          child: const Center(
                            child: Text(
                              "Great Offers",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: Colors.grey.shade300, width: 2),
                              color: Colors.white,
                            ),
                            width: 100,
                            height: 40,
                            child: const Center(
                              child: Text(
                                "Rating 4.0+",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () {},
                          splashColor: Colors.amber,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: Colors.grey.shade300, width: 2),
                              color: Colors.white,
                            ),
                            width: 150,
                            height: 40,
                            child: const Center(
                              child: Text(
                                "Previously Ordered",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: Colors.grey.shade300, width: 2),
                            color: Colors.white,
                          ),
                          width: 80,
                          height: 40,
                          child: const Center(
                            child: Text(
                              "Pure Veg",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      "Recommeneded",
                      style: TextStyle(
                          letterSpacing: 1,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: getMenuItemsStream(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Text('No items found for this restaurant');
                      }

                      final itemDocs = snapshot.data!.docs;
                      final List<Map<String, dynamic>> itemDataList = itemDocs
                          .map(
                            (doc) => doc.data() as Map<String, dynamic>,
                          )
                          .toList();

                      return Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: itemDataList.length,
                            physics:
                                const NeverScrollableScrollPhysics(), // Disable scrolling in the ListView
                            itemBuilder: (context, index) {
                              final itemData = itemDataList[index];
                              return ItemsCard(
                                  itemData: itemData,
                                  onAddToCart: () {
                                    addToCart(itemData);
                                  });
                            },
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(
                    height: 50,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ItemsCard extends StatefulWidget {
  final Map<String, dynamic> itemData;
  final VoidCallback onAddToCart;

  const ItemsCard({Key? key, required this.itemData, required this.onAddToCart})
      : super(key: key);

  @override
  State<ItemsCard> createState() => _ItemsCardState();
}

class _ItemsCardState extends State<ItemsCard> {
  final Random _random = Random();
  int _randomNumber = 0;
  int _quantity = 1;

  void _generateRandomNumber() {
    setState(() {
      _randomNumber = _random.nextInt(900) + 100;
    });
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _user;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
    _generateRandomNumber();
  }

  Future<void> addToCart(int quantityChange) async {
    try {
      if (_user != null) {
        final existingCartItem = await FirebaseFirestore.instance
            .collection('users')
            .doc(_user!.uid)
            .collection('cart')
            .doc(widget.itemData['itemId'])
            .get();

        if (existingCartItem.exists) {
          // If the item is already in the cart, update the quantity
          final currentQuantity = existingCartItem.data()!['quantity'] ?? 0;
          await FirebaseFirestore.instance
              .collection('users')
              .doc(_user!.uid)
              .collection('cart')
              .doc(widget.itemData['itemId'])
              .update({
            'quantity': currentQuantity + quantityChange,
          });
          setState(() {
            _quantity =
                currentQuantity + quantityChange; // Update the local quantity
          });
        } else {
          // If the item is not in the cart, add it with the quantity
          await FirebaseFirestore.instance
              .collection('users')
              .doc(_user!.uid)
              .collection('cart')
              .doc(widget.itemData['itemId'])
              .set({
            'itemID': widget.itemData['itemId'],
            'itemimage': widget.itemData['itemImageUrl'],
            'itemname': widget.itemData['name'],
            'itemprice': widget.itemData['price'],
            'quantity': quantityChange, // Set the initial quantity
            'timestamp': FieldValue.serverTimestamp(),
          });
          setState(() {
            _quantity = quantityChange; // Update the local quantity
          });
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Item added to cart'),
          ),
        );
        print('Item added to cart successfully!');
      } else {
        print('User is not authenticated. Cannot add to cart.');
      }
    } catch (e) {
      print('Error adding item to cart: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final itemName = widget.itemData['name'];
    final itemPrice = widget.itemData['price'];
    final itemDescription = widget.itemData['description'];
    final itemRating = widget.itemData['rating'];

    final itemimage = widget.itemData['itemImageUrl'];

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      shadowColor: Colors.grey,
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 200,
        child: Stack(
          children: [
            Positioned(
              left: 20,
              top: 5,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        const Center(
                            child: Icon(Icons.arrow_drop_down_outlined)),
                        const SizedBox(
                          width: 5,
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: 40,
                          height: 20,
                          decoration: BoxDecoration(
                              color: Colors.amber.shade800,
                              borderRadius: BorderRadius.circular(5)),
                          child: const Text(
                            "Bestseller",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 8),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      capitalize(itemName),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Container(
                          color: Colors.amber.shade100.withOpacity(0.7),
                          child: RatingBar.builder(
                            initialRating: itemRating.toDouble(),
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 20,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 1.0),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              // Handle rating updates if needed
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text("$_randomNumber rating"),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      "₹$itemPrice",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      itemDescription,
                      style: const TextStyle(fontSize: 14),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              width: 50,
            ),
            Positioned(
              right: 10,
              top: 20,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  // image: DecorationImage(
                  //     image: NetworkImage(itemimage), fit: BoxFit.cover),
                ),
                width: 150,
                height: 160,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                            image: NetworkImage(itemimage), fit: BoxFit.cover),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.pink.shade100.withOpacity(0.8),
                            border: Border.all(
                                width: 2, color: Colors.pink.shade400),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        width: 150,
                        height: 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                // Decrease the quantity by 1
                                if (_quantity > 1) {
                                  addToCart(-1);
                                }
                              },
                            ),
                            Text(
                              _quantity
                                  .toString(), // Display the current quantity
                              style: TextStyle(
                                  color: Colors.pink.shade400, fontSize: 18),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                // Increase the quantity by 1
                                addToCart(1);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
