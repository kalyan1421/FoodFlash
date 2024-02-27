// ignore_for_file: file_names, camel_case_types, library_private_types_in_public_api, use_build_context_synchronously, avoid_print, unused_field
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ionicons/ionicons.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uber_eats/Screens/cart_screen.dart';
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
  late String latitude;
  late String longitude;
  bool _isVegOnly = false;
  bool _isNonVegOnly = false;
  bool _isBestSellerOnly = false;
  User? _user;
  String distance = '';
  String duration = '';
  bool _isMounted = false;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
    _isMounted = true;
    getRestaurantLocation(widget.restaurantId).then((value) {
      _calculateDistanceAndTime();
    });
  }

  void toggleFavorite() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userId = user.uid;

        final restaurantId = widget.restaurantId;

        final favoriteRef = FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('favorites')
            .doc(restaurantId);

        final isFavorite = await favoriteRef.get();

        if (isFavorite.exists) {
          // Remove from favorites if already exists
          await favoriteRef.delete();
          // setState(() {
          //   this.isFavorite = false;
          // });
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
          // setState(() {
          //   this.isFavorite = true;
          // });
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

  Future<void> _calculateDistanceAndTime() async {
    Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    double startLatitude = currentPosition.latitude;
    double startLongitude = currentPosition.longitude;

    try {
      double destinationLatitude = double.parse(latitude.trim());
      double destinationLongitude = double.parse(longitude.trim());

      double distanceInMeters = await Geolocator.distanceBetween(startLatitude,
          startLongitude, destinationLatitude, destinationLongitude);

      int timeInSeconds = (distanceInMeters / 5).round();

      setState(() {
        if (distanceInMeters > 1000) {
          distance = '| ${(distanceInMeters / 1000).toStringAsFixed(2)} Km';
        } else {
          distance = '| 1.5 Km';
        }

        if (timeInSeconds > 1000) {
          duration = '| ${(timeInSeconds / 60).toStringAsFixed(0)} mins';
        } else {
          duration = '| 10 mins';
        }
      });
    } catch (e) {
      print('Error parsing latitude or longitude: $e');
    }
  }

  Future<Map<String, dynamic>> getRestaurantLocation(
      String restaurantId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> restaurantSnapshot =
          await FirebaseFirestore.instance
              .collection('Restaurants')
              .doc(restaurantId)
              .get();

      if (restaurantSnapshot.exists) {
        Map<String, dynamic> restaurantData = restaurantSnapshot.data()!;
        setState(() {
          latitude = restaurantData['latitude'];
          longitude = restaurantData['longtude'];
        });

        return {'latitude': latitude, 'longitude': longitude};
      } else {
        return {'latitude': null, 'longitude': null};
      }
    } catch (e) {
      print('Error fetching restaurant location: $e');
      return {'latitude': null, 'longitude': null};
    }
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(context,
      //         MaterialPageRoute(builder: (context) => const CartScreen()));
      //   },
      //   backgroundColor: Colors.amber.shade800,
      //   child: const Icon(
      //     Icons.shopping_basket_outlined,
      //     size: 40,
      //   ),
      // ),
      // bottomNavigationBar: Container(
      //   width: MediaQuery.of(context).size.width,
      //   height: 40,
      //   color: Colors.pink,
      // ),

      backgroundColor: Colors.white,
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
            return Shimmer_loading();
          }

          if (!snapshot.hasData) {
            return const Text('Restaurant data not available');
          }
          final restaurantData = snapshot.data!.data() as Map<String, dynamic>;

          return Stack(children: [
            NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    leading: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Ionicons.arrow_back,
                            color: Colors.black,
                            weight: 100,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    actions: [
                      InkWell(
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
                                  .doc(_user!.uid)
                                  .collection('favorites')
                                  .doc(restaurantData['restaurantId'])
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: Icon(
                                      Icons.favorite_border_sharp,
                                      size: 22,
                                      color: Colors.black,
                                    ),
                                  );
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
                      ),
                      SizedBox(width: 5),
                      InkWell(
                        onTap: () {},
                        child: Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Ionicons.search_outline,
                            color: Colors.black,
                            size: 25,
                          ),
                        ),
                      ),
                      SizedBox(width: 5)
                    ],
                    backgroundColor: Colors.white,
                    // elevation: 10,
                    collapsedHeight: 60,
                    expandedHeight: 250,
                    floating: false,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Image.network(
                        restaurantData['imageUrl'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                ];
              },
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            restaurantData['name'],
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.1,
                                color: Colors.black,
                                fontFamily: "Quicksand",
                                fontWeight: FontWeight.w900),
                          ),
                          SizedBox(height: 2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${restaurantData['subtitle'].split(' ').join(' | ')}",
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.042,
                                    color: Colors.black,
                                    fontFamily: "Quicksand",
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "⭐ ${restaurantData['rating']} (15.1k Rating)",
                                style: TextStyle(
                                    letterSpacing: 0,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.038,
                                    color: Colors.black,
                                    fontFamily: "Quicksand",
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                          SizedBox(height: 2),
                          Text(
                            "${restaurantData['address']}  $distance  $duration",
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.035,
                                color: Colors.grey.shade600,
                                fontFamily: "Quicksand",
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                      SizedBox(height: 20),
                      Divider(thickness: 0.5),
                      SizedBox(height: 20),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                _showFilter();
                              },
                              child: Container(
                                alignment: Alignment.center,
                                // width: 80,
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          offset: Offset(1, 2),
                                          spreadRadius: 1,
                                          blurRadius: 1,
                                          color: Colors.grey.shade100),
                                      BoxShadow(
                                          offset: Offset(2, 0),
                                          spreadRadius: 1,
                                          blurRadius: 1,
                                          color: Colors.grey.shade100)
                                    ],
                                    color: Colors.white,
                                    border: Border.all(
                                        width: 1, color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(10)),
                                height: 40,
                                child: Row(
                                  children: [
                                    SizedBox(width: 3),
                                    Icon(Ionicons.options_outline),
                                    SizedBox(width: 3),
                                    Text(
                                      'Filter',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontFamily: "Quicksand",
                                          fontWeight: FontWeight.w800),
                                    ),
                                    SizedBox(width: 3),
                                    Icon(
                                      Ionicons.caret_down_outline,
                                      size: 18,
                                    ),
                                    SizedBox(width: 5)
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _isVegOnly = !_isVegOnly;
                                  _isNonVegOnly = false;
                                });
                              },
                              child: Container(
                                alignment: Alignment.center,
                                // width: 80,
                                height: 40,
                                child: Row(
                                  children: [
                                    SizedBox(width: 5),
                                    Container(
                                      alignment: Alignment.center,
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(2),
                                          border: Border.all(
                                              width: 3, color: Colors.green),
                                          // color: _isVegOnly
                                          // ? Colors.green
                                          // : Colors.grey),
                                          color: Colors.transparent),
                                      child: Container(
                                        width: 10,
                                        height: 10,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.green),
                                        // color: _isVegOnly
                                        //     ? Colors.green
                                        //     : Colors.grey),
                                      ),
                                    ),
                                    SizedBox(width: 3),
                                    Text(
                                      'Only Veg',
                                      style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.035,
                                          color: Colors.black,
                                          fontFamily: "Quicksand",
                                          fontWeight: FontWeight.w800),
                                    ),
                                    SizedBox(width: 3),
                                    _isVegOnly
                                        ? Icon(
                                            Ionicons.close,
                                            size: 20,
                                          )
                                        : SizedBox(width: 5),
                                    SizedBox(width: 5)
                                  ],
                                ),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        offset: Offset(1, 2),
                                        spreadRadius: 1,
                                        blurRadius: 1,
                                        color: Colors.grey.shade100),
                                    BoxShadow(
                                        offset: Offset(2, 0),
                                        spreadRadius: 1,
                                        blurRadius: 1,
                                        color: Colors.grey.shade100)
                                  ],
                                  border: Border.all(
                                    width: 1,
                                    color: _isVegOnly
                                        ? Colors.pink.shade200
                                        : Colors.grey.shade300,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                  color: _isVegOnly
                                      ? Colors.pink.shade200.withOpacity(0.2)
                                      : Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _isNonVegOnly = !_isNonVegOnly;
                                  _isVegOnly = false;
                                });
                              },
                              child: Container(
                                alignment: Alignment.center,
                                // width: 80,
                                height: 40,
                                child: Row(
                                  children: [
                                    SizedBox(width: 5),
                                    Container(
                                      alignment: Alignment.center,
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(2),
                                          border: Border.all(
                                              width: 3, color: Colors.red),
                                          // color: _isVegOnly
                                          // ? Colors.green
                                          // : Colors.grey),
                                          color: Colors.transparent),
                                      child: Container(
                                        width: 10,
                                        height: 10,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.red),
                                        // color: _isVegOnly
                                        //     ? Colors.green
                                        //     : Colors.grey),
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      'Non Veg',
                                      style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.035,
                                          color: Colors.black,
                                          fontFamily: "Quicksand",
                                          fontWeight: FontWeight.w800),
                                    ),
                                    SizedBox(width: 3),
                                    _isNonVegOnly
                                        ? Icon(
                                            Ionicons.close,
                                            size: 20,
                                          )
                                        : SizedBox(width: 5),
                                    SizedBox(width: 5)
                                  ],
                                ),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        offset: Offset(1, 2),
                                        spreadRadius: 1,
                                        blurRadius: 1,
                                        color: Colors.grey.shade100),
                                    BoxShadow(
                                        offset: Offset(2, 0),
                                        spreadRadius: 1,
                                        blurRadius: 1,
                                        color: Colors.grey.shade100)
                                  ],
                                  border: Border.all(
                                    width: 1,
                                    color: _isNonVegOnly
                                        ? Colors.pink.shade200
                                        : Colors.grey.shade300,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                  color: _isNonVegOnly
                                      ? Colors.pink.shade200.withOpacity(0.2)
                                      : Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Container(
                              alignment: Alignment.center,
                              // width: 80,
                              height: 35,
                              child: Row(
                                children: [
                                  SizedBox(width: 5),
                                  Icon(
                                    Ionicons.star,
                                    size: 20,
                                    color: Colors.amber.shade600,
                                  ),
                                  SizedBox(width: 3),
                                  Text(
                                    'Bestseller',
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.035,
                                        color: Colors.black,
                                        fontFamily: "Quicksand",
                                        fontWeight: FontWeight.w800),
                                  ),
                                  SizedBox(width: 5)
                                ],
                              ),
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        offset: Offset(1, 2),
                                        spreadRadius: 1,
                                        blurRadius: 1,
                                        color: Colors.grey.shade100),
                                    BoxShadow(
                                        offset: Offset(2, 0),
                                        spreadRadius: 1,
                                        blurRadius: 1,
                                        color: Colors.grey.shade100)
                                  ],
                                  color: Colors.white,
                                  border: Border.all(
                                      width: 1, color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            SizedBox(width: 10),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Most Popular",
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.07,
                            color: Colors.black,
                            fontFamily: "Quicksand",
                            letterSpacing: 1,
                            fontWeight: FontWeight.w900),
                      ),
                      StreamBuilder<QuerySnapshot>(
                        stream: getMenuItemsStream(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Shimmer_loading();
                          }
                          if (!snapshot.hasData ||
                              snapshot.data!.docs.isEmpty) {
                            return const Text(
                                'No items found for this restaurant');
                          }
                          final itemDocs = snapshot.data!.docs;
                          List<Map<String, dynamic>> itemDataList = itemDocs
                              .map((doc) => doc.data() as Map<String, dynamic>)
                              .toList();
                          // Apply filters
                          List<Map<String, dynamic>> filteredItemDataList =
                              itemDataList;
                          if (_isVegOnly) {
                            filteredItemDataList = filteredItemDataList
                                .where(
                                    (itemData) => itemData['vegornon'] == 'veg')
                                .toList();
                          }
                          if (_isNonVegOnly) {
                            filteredItemDataList = filteredItemDataList
                                .where(
                                    (itemData) => itemData['vegornon'] == 'non')
                                .toList();
                          }
                          return Column(
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: filteredItemDataList.length,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  final itemData = filteredItemDataList[index];
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ItemsCard(
                                        restaurantName: restaurantData['name'],
                                        itemData: itemData,
                                        restaurantloaction:
                                            restaurantData["address"],
                                        restaurantlatitude:
                                            restaurantData["latitude"],
                                        restaurantlongtude:
                                            restaurantData["longtude"],
                                        onAddToCart: () {
                                          addToCart(itemData);
                                        },
                                      ),
                                      Divider(thickness: 0.5),
                                      // SizedBox(height: 25)
                                    ],
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 30),
                      Align(
                          alignment: Alignment.center,
                          child: Text("You reached at last")),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
                bottom: 10,
                right: 10,
                left: 10,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(_user!.uid)
                      .collection('cart')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  height: 40.0,
                                  color: Colors.white,
                                ),
                                SizedBox(height: 20.0),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  height: 20.0,
                                  color: Colors.white,
                                ),
                                SizedBox(height: 10.0),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  height: 20.0,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    } else {
                      int itemCount = snapshot.data?.docs.length ?? 0;
                      return Visibility(
                        visible: itemCount > 0,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Cart_screen(),
                                ),
                              );
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(5)),
                              height: 55,
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                'View Cart (${itemCount} items)',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ))
          ]);
        },
      ),
    );
  }

  void _showFilter() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        bool isVegChecked = false;
        bool isNonVegChecked = true; // Default value
        double minRating = 4.0; // Default value
        List<String> deliveryTimes = [];
        List<String> priceRanges = [];

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: EdgeInsets.all(10),
              // height: MediaQuery.of(context).size.height * 0.9,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Sort & Filter',
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.08,
                              color: Colors.black,
                              fontFamily: "MonaSans",
                              fontWeight: FontWeight.w900),
                        ),
                        InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              color: Colors.black,
                              Ionicons.close,
                              size: 25,
                            ))
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Veg/Non-veg',
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.042,
                          color: Colors.black,
                          fontFamily: "MonaSans",
                          fontWeight: FontWeight.w800),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: isVegChecked,
                          activeColor: Colors.black,
                          onChanged: (newValue) {
                            setState(() {
                              isVegChecked = newValue!;
                              if (newValue) {
                                isNonVegChecked = false;
                              }
                            });
                          },
                        ),
                        Text(
                          'Pure veg',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                            color: Colors.grey.shade600,
                            fontFamily: "Quicksand",
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 10),
                        Checkbox(
                          value: isNonVegChecked,
                          activeColor: Colors.black,
                          onChanged: (newValue) {
                            setState(() {
                              isNonVegChecked = newValue!;
                              if (newValue) {
                                isVegChecked = false;
                              }
                            });
                          },
                        ),
                        Text(
                          'Non Veg',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                            color: Colors.grey.shade600,
                            fontFamily: "Quicksand",
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Divider(
                      thickness: 1,
                      color: Colors.grey.shade300,
                    ),
                    SizedBox(height: 15),
                    Text(
                      'Rating',
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.042,
                          color: Colors.black,
                          fontFamily: "MonaSans",
                          fontWeight: FontWeight.w800),
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RatingContainer(
                          rating: 3.5,
                          minRating: minRating,
                          onTap: () {
                            setState(() {
                              minRating = 3.5;
                            });
                          },
                        ),
                        RatingContainer(
                          rating: 4.0,
                          minRating: minRating,
                          onTap: () {
                            setState(() {
                              minRating = 4.0;
                            });
                          },
                        ),
                        RatingContainer(
                          rating: 4.5,
                          minRating: minRating,
                          onTap: () {
                            setState(() {
                              minRating = 4.5;
                            });
                          },
                        ),
                        RatingContainer(
                          rating: 5.0,
                          minRating: minRating,
                          onTap: () {
                            setState(() {
                              minRating = 5.0;
                            });
                          },
                        ),
                        SizedBox(
                          width: 10,
                        )
                      ],
                    ),
                    SizedBox(height: 25),
                    Divider(
                      thickness: 1,
                      color: Colors.grey.shade300,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Delivery Time',
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.042,
                          color: Colors.black,
                          fontFamily: "MonaSans",
                          fontWeight: FontWeight.w800),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: deliveryTimes.contains('<30'),
                          onChanged: (checked) {
                            setState(() {
                              if (checked != null && checked) {
                                deliveryTimes.add('<30');
                              } else {
                                deliveryTimes.remove('<30');
                              }
                            });
                          },
                        ),
                        Text(
                          "Less than 30 mins",
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.035,
                            color: Colors.grey.shade600,
                            fontFamily: "Quicksand",
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Checkbox(
                          value: deliveryTimes.contains('<45'),
                          onChanged: (checked) {
                            setState(() {
                              if (checked != null && checked) {
                                deliveryTimes.add('<45');
                              } else {
                                deliveryTimes.remove('<45');
                              }
                            });
                          },
                        ),
                        Text(
                          "Less than 45 mins",
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.035,
                            color: Colors.grey.shade600,
                            fontFamily: "Quicksand",
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: deliveryTimes.contains('<60'),
                          onChanged: (checked) {
                            setState(() {
                              if (checked != null && checked) {
                                deliveryTimes.add('<60');
                              } else {
                                deliveryTimes.remove('<60');
                              }
                            });
                          },
                        ),
                        Text(
                          'Less than 1 hour',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.035,
                            color: Colors.grey.shade600,
                            fontFamily: "Quicksand",
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 40),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          "Apply",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontFamily: "Quicksand-Bold",
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    InkWell(
                      onTap: () {
                        setState(() {
                          isVegChecked = false;
                          isNonVegChecked = false;
                          minRating = 0.0;
                          deliveryTimes.clear();
                          priceRanges.clear();
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        decoration: BoxDecoration(
                            // color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          "Clear all filter",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontFamily: "Quicksand-Bold",
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class ItemsCard extends StatefulWidget {
  final Map<String, dynamic> itemData;
  final VoidCallback onAddToCart;

  final String restaurantName;
  final String restaurantloaction;

  final String restaurantlatitude;
  final String restaurantlongtude;

  const ItemsCard(
      {Key? key,
      required this.itemData,
      required this.onAddToCart,
      required this.restaurantName,
      required this.restaurantloaction,
      required this.restaurantlatitude,
      required this.restaurantlongtude})
      : super(key: key);

  @override
  State<ItemsCard> createState() => _ItemsCardState();
}

class _ItemsCardState extends State<ItemsCard> {
  int _quantity = 1;

  bool _isSpicySelected = false;
  bool _isClassicSelected = false;
  bool _needCutlery = false;
  bool _isKebabSelected = false;
  bool _isCokeSelected = false;
  bool _isSweetSelected = false;
  // bool isItemInDB = false;

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
            .collection('cart')
            .doc(widget.itemData['itemId'])
            .get();
        double totalItemPrice = widget.itemData['price'];
        if (_isKebabSelected) totalItemPrice += 120;
        if (_isCokeSelected) totalItemPrice += 40;
        if (_isSweetSelected) totalItemPrice += 60;
        if (existingCartItem.exists) {
          final currentQuantity = existingCartItem.data()!['quantity'] ?? 0;
          await FirebaseFirestore.instance
              .collection('users')
              .doc(_user!.uid)
              .collection('cart')
              .doc(widget.itemData['itemId'])
              .update({
            'quantity': currentQuantity + quantityChange,
            'totalPrice': totalItemPrice * (currentQuantity + quantityChange),
            'isKebabSelected': _isKebabSelected,
            'isCokeSelected': _isCokeSelected,
            'isSweetSelected': _isSweetSelected,
            "Restauranname": widget.restaurantName
          });
          if (mounted) {
            setState(() {
              _quantity = currentQuantity + quantityChange;
            });
          }
        } else {
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
            'quantity': quantityChange,
            'timestamp': FieldValue.serverTimestamp(),
            'totalPrice': totalItemPrice * quantityChange,
            'isKebabSelected': _isKebabSelected,
            'isCokeSelected': _isCokeSelected,
            'isSweetSelected': _isSweetSelected,
            'vegnon': widget.itemData['vegornon'],
            "Restauranname": widget.restaurantName,
            "restaurantloaction": widget.restaurantloaction,
            "restaurantlatitude": widget.restaurantlatitude,
            "restaurantlongtude": widget.restaurantlongtude,
          });
          if (mounted) {
            setState(() {
              _quantity = quantityChange;
              // isItemInDB = false;
            });
          }
        }

        print('Item added to cart successfully!');
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
        .collection('cart')
        .doc(widget.itemData['itemId'])
        .delete()
        .then((value) {
      print('Item removed from cart successfully');
    }).catchError((error) {
      print('Failed to remove item from cart: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    void _showItemDetails() {
      bool isSpicy = false;
      bool isClassic = false;
      bool addKebab = false;
      bool addCoke = false;
      // bool addons1 = false;
      // bool addons2 = false;
      // bool addons3 = false;
      // bool addons4 = false;
      // bool needCutlery = false;

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
                height: MediaQuery.of(context).size.height * 0.9,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                              color: Colors.white,
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(
                                    widget.itemData["itemImageUrl"]),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 10,
                            top: 10,
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                width: 45,
                                height: 45,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Ionicons.close_outline,
                                  color: Colors.black,
                                  size: 30,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 10.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              capitalize(widget.itemData['name']),
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.06,
                                color: Colors.black,
                                fontFamily: "MonaSans",
                                letterSpacing: 1,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              "₹ ${widget.itemData['price']}",
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.045,
                                color: Colors.black,
                                fontFamily: "MonaSans",
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 5.0),
                            Text(
                              widget.itemData['description'],
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.035,
                                color: Colors.grey.shade500,
                                fontFamily: "Quicksand",
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 10),
                            Divider(thickness: 1),
                            SizedBox(height: 10),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Choice of Preparation",
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.04,
                                          color: Colors.black,
                                          fontFamily: "MonaSans",
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      Text(
                                        "✔️ Required",
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.04,
                                          color: Colors.green,
                                          fontFamily: "MonaSans",
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Container(
                                          alignment: Alignment.center,
                                          width: 18,
                                          height: 18,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(2),
                                              border: Border.all(
                                                  width: 2,
                                                  color: Colors.green),
                                              color: Colors.transparent),
                                          child: Container(
                                            width: 10,
                                            height: 10,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.green),
                                          )),
                                      SizedBox(width: 5),
                                      Text(
                                        'Spicy',
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.04,
                                          color: Colors.grey.shade500,
                                          fontFamily: "MonaSans",
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Expanded(child: SizedBox()),
                                      Checkbox(
                                        activeColor: Colors.black,
                                        value: isSpicy,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            isSpicy = value!;
                                            if (isSpicy && isClassic) {
                                              isClassic = false;
                                              _isSpicySelected = false;
                                            }
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          alignment: Alignment.center,
                                          width: 18,
                                          height: 18,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(2),
                                              border: Border.all(
                                                  width: 2,
                                                  color: Colors.green),
                                              color: Colors.transparent),
                                          child: Container(
                                            width: 10,
                                            height: 10,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.green),
                                          )),
                                      SizedBox(width: 5),
                                      Text(
                                        'Classic',
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.04,
                                          color: Colors.grey.shade500,
                                          fontFamily: "MonaSans",
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Expanded(child: SizedBox()),
                                      Checkbox(
                                        activeColor: Colors.black,
                                        value: isClassic,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            isClassic = value!;
                                            if (isClassic && isSpicy) {
                                              // If both spicy and classic are selected,
                                              // unselect spicy
                                              isSpicy = false;
                                              _isSpicySelected = false;
                                            }
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "Extra Add-ons",
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.04,
                                      color: Colors.black,
                                      fontFamily: "MonaSans",
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Container(
                                          alignment: Alignment.center,
                                          width: 18,
                                          height: 18,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(2),
                                              border: Border.all(
                                                  width: 2, color: Colors.red),
                                              color: Colors.transparent),
                                          child: Container(
                                            width: 10,
                                            height: 10,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.red),
                                          )),
                                      SizedBox(width: 5),
                                      Text(
                                        'Kebab',
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.04,
                                          color: Colors.grey.shade500,
                                          fontFamily: "MonaSans",
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Expanded(child: SizedBox()),
                                      Text(
                                        '₹ 120',
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.035,
                                          color: Colors.black,
                                          fontFamily: "Quicksand",
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Checkbox(
                                        activeColor: Colors.black,
                                        value: addKebab,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            addKebab = value!;
                                            _isKebabSelected = value;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                          alignment: Alignment.center,
                                          width: 18,
                                          height: 18,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(2),
                                              border: Border.all(
                                                  width: 2, color: Colors.red),
                                              color: Colors.transparent),
                                          child: Container(
                                            width: 10,
                                            height: 10,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.red),
                                          )),
                                      SizedBox(width: 5),
                                      Text(
                                        'Coke',
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.04,
                                          color: Colors.grey.shade500,
                                          fontFamily: "MonaSans",
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Expanded(child: SizedBox()),
                                      Text(
                                        '₹ 40',
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.035,
                                          color: Colors.black,
                                          fontFamily: "Quicksand",
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Checkbox(
                                        activeColor: Colors.black,
                                        value: addCoke,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            addCoke = value!;
                                            _isCokeSelected = value;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                addToCart(1);
                                Navigator.pop(context);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  "Add to cart",
                                  style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.04,
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
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      );
    }

    final itemName = widget.itemData['name'];
    final itemPrice = widget.itemData['price'];
    final itemDescription = widget.itemData['description'];
    final itemimage = widget.itemData['itemImageUrl'];

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width * 0.4,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.width * 0.4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  capitalize(itemName),
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.042,
                      color: Colors.black,
                      fontFamily: "Quicksand",
                      fontWeight: FontWeight.w800),
                ),
                Text(
                  itemDescription.length > 65
                      ? '${itemDescription.substring(0, 65)}...'
                      : itemDescription,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.033,
                    color: Colors.grey.shade400,
                    fontFamily: "Quicksand",
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  "₹ ${itemPrice}",
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                      color: Colors.black,
                      fontFamily: "Quicksand",
                      fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
          Expanded(child: SizedBox()),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            width: MediaQuery.of(context).size.width * 0.35,
            height: MediaQuery.of(context).size.width * 0.35,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                        image: NetworkImage(itemimage), fit: BoxFit.cover),
                  ),
                ),
                StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(_user!.uid)
                      .collection('cart')
                      .doc(widget.itemData['itemId'])
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Shimmer_loading();
                    } else {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        final existingCartItem = snapshot.data;
                        final isItemInDB = existingCartItem?.exists ?? false;

                        return isItemInDB
                            ? Positioned(
                                right: 10,
                                bottom: 10,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(25)),
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                  height: 30,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(height: 3),
                                      InkWell(
                                        onTap: () {
                                          if (_quantity > 1) {
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
                                        _quantity.toString(),
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 18),
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
                                ),
                              )
                            : Positioned(
                                right: 5,
                                bottom: 5,
                                child: InkWell(
                                  onTap: _showItemDetails,
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: 35,
                                      height: 35,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle),
                                      child: Icon(
                                        Icons.add,
                                        size: 26,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
