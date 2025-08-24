// ignore_for_file: file_names, camel_case_types, avoid_print, prefer_const_constructors, avoid_types_as_parameter_names, non_constant_identifier_names

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ionicons/ionicons.dart';
import 'package:uber_eats/Add_address/add_address.dart';
import 'package:uber_eats/Features_Layouts/search_bar.dart';
import 'package:uber_eats/Screens/RestaurantDetailsPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uber_eats/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:uber_eats/dash_screen.dart';
import 'package:uber_eats/groceries/groceries_search_screen.dart';

class RestaurantList extends StatefulWidget {
  const RestaurantList({super.key});

  @override
  State<RestaurantList> createState() => _RestaurantListState();
}

class _RestaurantListState extends State<RestaurantList> {
  String? formattedAddress;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    fetchRecentAddressData();
  }

  void fetchRecentAddressData() async {
    String userId = user!.uid;

    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .collection('addresses')
              .orderBy('createdAt', descending: true)
              .limit(1)
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot<Map<String, dynamic>> docSnapshot =
            querySnapshot.docs.first;
        Map<String, dynamic> data = docSnapshot.data()!;
        // print('Data from document: $data');
        if (data.containsKey('formattedAddress')) {
          String fullAddress = data['formattedAddress'];
          String truncatedAddress = fullAddress.substring(0, 20);
          setState(() {
            formattedAddress = truncatedAddress;
          });
        } else {
          print('formattedAddress field not found in document');
        }
      } else {
        print('No documents found in the addresses subcollection');
      }
    } catch (e) {
      print('Error fetching recent address data: $e');
    }
  }

  final List<String> assetPaths = [
    'assets/homepage/banner/banner1.jpg',
    'assets/homepage/banner/banner2.jpg',
    'assets/homepage/banner/banner3.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    CollectionReference restaurants =
        FirebaseFirestore.instance.collection('Restaurants');
    CollectionReference groceries =
        FirebaseFirestore.instance.collection('deals');
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 55),

                      //INTRO - Location - Profile image-----
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
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
                                  transitionDuration:
                                      Duration(milliseconds: 500),
                                ),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Delivery Now",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade400,
                                      fontFamily: "Quicksand",
                                      fontWeight: FontWeight.w800),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "${formattedAddress}",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                          fontFamily: "Quicksand",
                                          fontWeight: FontWeight.bold),
                                    ),
                                    GestureDetector(
                                      onTap: () {},
                                      child: Icon(
                                        Icons.keyboard_arrow_down_sharp,
                                        size: 30,
                                        color: Colors.black,
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: CircleAvatar(
                              backgroundColor:
                                  Colors.grey.shade200.withOpacity(0.8),
                              child: Icon(Ionicons.person_outline,
                                  color: Colors.black, size: 25),
                            ),
                          ),
                        ],
                      ),
                      // const Padding(
                      //   padding: EdgeInsets.all(8.0),
                      //   child: Intro_Widget(),
                      // ),
                      SizedBox(height: 20),
                      //SEARCH BAR-----------------------
                      const SearchBar(),
                      SizedBox(height: 20),
                      //LOGO----------------------
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Dash_board(selectindex: 1)));
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              width: MediaQuery.of(context).size.width * 0.30,
                              height: 120,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Food",
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.05,
                                                color: Colors.black,
                                                fontFamily: "Quicksand",
                                                fontWeight: FontWeight.w800),
                                          ),
                                          Text(
                                            "Up to 60% off",
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.030,
                                                color: Colors.black,
                                                fontFamily: "Quicksand",
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // SizedBox(height: 10),
                                  Image.asset(
                                    "assets/homepage/Delivery.png",
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      Dash_board(selectindex: 2),
                                ),
                              );
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.30,
                              height: 120,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 5),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Mart",
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.05,
                                                color: Colors.black,
                                                fontFamily: "Quicksand",
                                                fontWeight: FontWeight.w800),
                                          ),
                                          Text(
                                            "Instant Grocery",
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.030,
                                                color: Colors.black,
                                                fontFamily: "Quicksand",
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // SizedBox(height: 10),
                                  Image.asset(
                                    "assets/homepage/Food.png",
                                    width: MediaQuery.of(context).size.width *
                                        0.25,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Dash_board(selectindex: 0)));
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.28,
                                height: 120,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200.withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 5),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Dine in ",
                                              style: TextStyle(
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.05,
                                                  color: Colors.black,
                                                  fontFamily: "Quicksand",
                                                  fontWeight: FontWeight.w800),
                                            ),
                                            Text(
                                              "Special offers",
                                              style: TextStyle(
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.030,
                                                  color: Colors.black,
                                                  fontFamily: "Quicksand",
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Image.asset(
                                      "assets/homepage/dinein.png",
                                      width: MediaQuery.of(context).size.width *
                                          0.14,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 30),
                      SizedBox(
                        height: 200,
                        child: Swiper(
                          itemCount: assetPaths.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage(
                                    assetPaths[index],
                                  ),
                                ),
                              ),
                              // child:
                            );
                          },
                          autoplay: true,
                          pagination: SwiperPagination(),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Popular Restaurants ",
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.black,
                          fontFamily: "Quicksand",
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 15)),
              SliverToBoxAdapter(
                child: StreamBuilder<QuerySnapshot>(
                    stream: restaurants
                        .orderBy('time', descending: false)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Shimmer_loading();
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Text('No restaurants found');
                      }
                      return Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.31,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              final restaurantData = snapshot.data!.docs[index]
                                  .data() as Map<String, dynamic>;
                              return GestureDetector(
                                onTap: () {
                                  if (restaurantData
                                      .containsKey('restaurantId')) {
                                    final String restaurantId =
                                        restaurantData['restaurantId'];
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            RestaurantDetailsPage(
                                          restaurantId: restaurantId,
                                        ),
                                      ),
                                    );
                                  } else {
                                    print(
                                        'Restaurant ID is missing in restaurantData');
                                  }
                                },
                                child: RestaurantCard(
                                  restaurantData: restaurantData,
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    }),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "Deals on Grocery",
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontFamily: "Quicksand",
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 15)),
              SliverToBoxAdapter(
                child: StreamBuilder<QuerySnapshot>(
                    stream: groceries
                        // .orderBy('time', descending: false)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Shimmer_loading();
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Text('No restaurants found');
                      }
                      return Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.width * 0.64,
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
                        ),
                      );
                    }),
              ),
              SliverToBoxAdapter(
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(height: 50),
                      Text("End of Page"),
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class RestaurantCard extends StatefulWidget {
  final Map<String, dynamic> restaurantData;

  const RestaurantCard({super.key, required this.restaurantData});

  @override
  State<RestaurantCard> createState() => _RestaurantCardState();
}

class _RestaurantCardState extends State<RestaurantCard> {
  bool isFavorite = false;
  bool ismenuTap = false;
  bool Favorite = false;
  final user = FirebaseAuth.instance.currentUser;
  void toggleFavorite() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userId = user.uid;

        final restaurantId = widget.restaurantData['restaurantId'];

        final favoriteRef = FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('favorites')
            .doc(restaurantId);

        final isFavorite = await favoriteRef.get();

        if (isFavorite.exists) {
          await favoriteRef.delete();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Removed from favorites'),
            duration: Duration(seconds: 1),
            backgroundColor: Colors.red.shade400,
            behavior: SnackBarBehavior.floating,
          ));
        } else {
          await favoriteRef.set({
            'restaurantId': restaurantId,
            'timestamp': FieldValue.serverTimestamp(),
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Added to favorites'),
            duration: Duration(seconds: 1),
            backgroundColor: Colors.red.shade400,
            behavior: SnackBarBehavior.floating,
          ));
        }
      } else {
        print('User is not authenticated. Cannot toggle favorite.');
      }
    } catch (e) {
      print('Error toggling favorite: $e');
    }
  }

  void menuRestaurant() {
    setState(() {
      ismenuTap = !ismenuTap;
    });
  }

  bool _isMounted = false; // Track if the widget is mounted or not

  @override
  void initState() {
    super.initState();
    _isMounted = true;

    _calculateDistanceAndTime();
  }

  void checkfavorite() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userId = user.uid;

        final restaurantId = widget.restaurantData['restaurantId'];

        final favoriteRef = FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('favorites')
            .doc(restaurantId);

        final isFavorite = await favoriteRef.get();

        if (isFavorite.exists) {
          // Remove from favorites if already exists
          await favoriteRef.delete();
          setState(() {
            Favorite = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Removed from favorites'),
            duration: Duration(seconds: 1),
            backgroundColor: Colors.red.shade400,
            behavior: SnackBarBehavior.floating,
          ));
        } else {
          // Add to favorites if not exists
          await favoriteRef.set({
            'restaurantId': restaurantId,
            'timestamp': FieldValue.serverTimestamp(),
          });
          setState(() {
            this.isFavorite = true;
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Added to favorites'),
            duration: Duration(seconds: 1),
            backgroundColor: Colors.red.shade400,
            behavior: SnackBarBehavior.floating,
          ));
        }
      } else {
        print('User is not authenticated. Cannot toggle favorite.');
      }
    } catch (e) {
      print('Error toggling favorite: $e');
    }
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  String distance = '';
  String duration = '';

  Future<void> _calculateDistanceAndTime() async {
    Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    double startLatitude = currentPosition.latitude;
    double startLongitude = currentPosition.longitude;

    double destinationLatitude =
        double.parse(widget.restaurantData["latitude"]);
    double destinationLongitude =
        double.parse(widget.restaurantData["longtude"]);
    double distanceInMeters = await Geolocator.distanceBetween(startLatitude,
        startLongitude, destinationLatitude, destinationLongitude);

    int timeInSeconds = (distanceInMeters / 5).round();

    if (_isMounted) {
      setState(() {
        if (distanceInMeters > 1000) {
          distance = '${(distanceInMeters / 1000).toStringAsFixed(2)} km';
        } else {
          distance = '1.5 km';
        }

        if (timeInSeconds > 1000) {
          duration = '${(timeInSeconds / 60).toStringAsFixed(0)} mins';
        } else {
          duration = '10 mins';
        }
      });
    }
  }

  @override
  Widget build(BuildContext) {
    final width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          width: width * 0.4,
          height: width * 0.4,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          child: Stack(
            alignment: AlignmentDirectional.topStart,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    image: NetworkImage(
                      widget.restaurantData['imageUrl'],
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                  right: 5,
                  top: 5,
                  child: InkWell(
                    onTap: () {
                      toggleFavorite();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .doc(user!.uid)
                              .collection('favorites')
                              .doc(widget.restaurantData['restaurantId'])
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

                                return isItemInDB
                                    ? Icon(
                                        Icons.favorite,
                                        size: 22,
                                        color: Colors.red,
                                      )
                                    : Icon(
                                        Icons.favorite_border_sharp,
                                        size: 22,
                                        color: Colors.black,
                                      );
                              }
                            }
                          },
                        ),
                      ),
                    ),
                  ))
            ],
          ),
        ),
        Container(
          width: width * 0.4,
          height: width * 0.2,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 5),
              Text(
                widget.restaurantData['name'],
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.040,
                    color: Colors.black,
                    fontFamily: "Quicksand",
                    fontWeight: FontWeight.w900),
              ),
              Text(
                "${widget.restaurantData['subtitle']}",
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.032,
                    color: Colors.grey.shade600,
                    fontFamily: "Quicksand",
                    fontWeight: FontWeight.w600),
              ),
              Text(
                "⭐ ${widget.restaurantData['rating']} | $distance | $duration",
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.032,
                    color: Colors.grey.shade600,
                    fontFamily: "Quicksand",
                    fontWeight: FontWeight.w600),
              )
            ],
          ),
        )
      ],
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
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(width: 1, color: Colors.grey.shade300),
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
                                    MediaQuery.of(context).size.width * 0.035,
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
                    widget.groceriesData['name'],
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.040,
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

class SearchBar extends StatefulWidget {
  const SearchBar({super.key});

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RestaurantSearchScreen(),
            ));
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.grey.shade200.withOpacity(0.4),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            // BoxShadow(
            //   color: Colors.grey.withOpacity(0.5),
            //   spreadRadius: 2,
            //   blurRadius: 2,
            //   offset: const Offset(0, 3),
            // ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  width: 10,
                ),
                const Icon(Ionicons.search_outline,
                    color: Colors.black, size: 30),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => groceries_search_screen(),
                        ));
                  },
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        AnimatedTextKit(
                          animatedTexts: [
                            RotateAnimatedText(
                              'Search "Cake"',
                              duration: const Duration(seconds: 2),
                              textStyle: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            ),
                            RotateAnimatedText(
                              'Search "tiffin"',
                              duration: const Duration(seconds: 2),
                              textStyle: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            ),
                            RotateAnimatedText(
                              'Search "Burger"',
                              duration: const Duration(seconds: 2),
                              textStyle: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                          isRepeatingAnimation: true,
                          repeatForever: true,
                        ),
                      ],
                    ),
                  ),
                ),
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
                    Icons.mic,
                    color: Colors.black,
                    size: 28,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
