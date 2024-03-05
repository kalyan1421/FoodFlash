import 'dart:math';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottie/lottie.dart';
import 'package:uber_eats/Features_Layouts/search_bar.dart';
import 'package:uber_eats/Screens/RestaurantDetailsPage.dart';
import 'package:uber_eats/Tracking/order_traking.dart';
import 'package:uber_eats/Utils/utils.dart';
import 'package:uber_eats/groceries/groceries_search_screen.dart';

class Food_page extends StatefulWidget {
  const Food_page({super.key});

  @override
  State<Food_page> createState() => _Food_pageState();
}

class _Food_pageState extends State<Food_page> {
  String? formattedAddress;
  String? ordertime;
  User? user = FirebaseAuth.instance.currentUser;
  List<double> ratings = [];
  @override
  void initState() {
    super.initState();
    placeOrderAndFetchAddress();
    fetchRecentAddressData();
  }

  Map<String, dynamic>? _orderData;

  void placeOrderAndFetchAddress() async {
    String userId = user!.uid;
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .collection('orders')
              .orderBy('timestamp', descending: true)
              .limit(1)
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot<Map<String, dynamic>> docSnapshot =
            querySnapshot.docs.first;
        Map<String, dynamic> data = docSnapshot.data()!;

        String totalAmount = data['orderId'];
        setState(() {
          ordertime = totalAmount;
        });
        print(ordertime);
      } else {
        print('No documents found in the addresses subcollection');
      }
    } catch (e) {
      print('Error placing order and fetching address: $e');
    }
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

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 55),
                      //INTRO - Location - Profile image-----------------
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
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
                      SizedBox(height: 20),
                      //SEARCH BAR-----------------------
                      const SearchBar(),
                      SizedBox(height: 20),
                      SizedBox(height: 20),
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
                      SizedBox(height: 30),
                      CategoryWidget(
                        images: [
                          "assets/food_images/Burger.png",
                          "assets/food_images/Pizza.png",
                          "assets/food_images/mexican.png",
                          "assets/food_images/Ice-cream.png",
                          "assets/food_images/pasta.png",
                        ],
                        names: [
                          "Burger",
                          "Pizza",
                          "Mexican",
                          "Ice Cream",
                          "Pasta",
                        ],
                      ),
                      SizedBox(height: 10),
                      CategoryWidget(
                        images: [
                          "assets/food_images/Biryani.png",
                          "assets/food_images/Shawarma_.png",
                          "assets/food_images/Thali.png",
                          "assets/food_images/Idli.png",
                          "assets/food_images/Noodles.png",
                        ],
                        names: [
                          "Biryani",
                          "Shawarma",
                          "Thali",
                          "Ice Cream",
                          "Noodles"
                        ],
                      ),
                      SizedBox(height: 30),
                      Text(
                        "Top Rated Restaurants",
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.black,
                          fontFamily: "Quicksand",
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
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
                        height: MediaQuery.of(context).size.height * 0.32,
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
                              child: TopRatedRes(
                                restaurantData: restaurantData,
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "Restaurants To Explore",
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
              SliverToBoxAdapter(child: SizedBox(height: 10)),
              StreamBuilder<QuerySnapshot>(
                stream:
                    restaurants.orderBy('time', descending: false).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return SliverToBoxAdapter(
                        child: Center(child: Text('Error: ${snapshot.error}')));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SliverToBoxAdapter(child: Shimmer_loading());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return SliverToBoxAdapter(
                        child: const Text('No restaurants found'));
                  }

                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        final restaurantData = snapshot.data!.docs[index].data()
                            as Map<String, dynamic>;
                        return GestureDetector(
                          onTap: () {
                            if (restaurantData.containsKey('restaurantId')) {
                              final String restaurantId =
                                  restaurantData['restaurantId'];
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RestaurantDetailsPage(
                                    restaurantId: restaurantId,
                                  ),
                                ),
                              );
                            } else {
                              print(
                                  'Restaurant ID is missing in restaurantData');
                            }
                          },
                          child: ExploreRes(
                            restaurantData: restaurantData,
                          ),
                        );
                      },
                      childCount: snapshot.data!.docs.length,
                    ),
                  );
                },
              ),
            ],
          ),
          if (ordertime != null && ordertime!.isNotEmpty)
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(user!.uid)
                      .collection('orders')
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text('No orders found.'));
                    }
                    final order = snapshot.data!.docs.first.data()
                        as Map<String, dynamic>;

                    // final orderId = order['orderId'];
                    // final timestamp =
                    //     (order['timestamp'] as Timestamp).toDate();
                    // final formattedTimestamp = DateFormat('dd/MM/yyyy, hh:mm a').format(timestamp);
                    // final transactionId = order['transactionId'];
                    // final responseCode = order['responseCode'];
                    // final approvalRefNo = order['approvalRefNo'];
                    // final totalAmount = order['totalAmount'];
                    // final deliveryFree = order['DeliveryFree'];
                    // final payMethod = order['paymethod'];
                    // final taxAndFee = order['Tax&fee'];
                    // final discount = order['discount'];
                    final timestamp =
                        (order['timestamp'] as Timestamp).toDate();
                    print(timestamp);
                    final updatedTimestamp =
                        timestamp.add(Duration(minutes: 30));
                    final orderTimestamp =
                        (order['timestamp'] as Timestamp).toDate();
                    final formattedTimestamp =
                        DateFormat('hh:mm a').format(updatedTimestamp);
                    final now = DateTime.now();
                    final difference = now.difference(orderTimestamp);
                    if (difference.inHours < 1) {
                      // ratings =
                      //     List<double>.filled(snapshot.data!.docs.length, 0.0);
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            top: BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                        ),
                        height: 60,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Lottie.asset(
                                "assets/utiles/Animation - 1709184455102.json",
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Picking up your delivery",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontFamily: "Quicksand",
                                        fontWeight: FontWeight.w900),
                                  ),
                                  Text(
                                    "Arriving at ${formattedTimestamp}",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black45,
                                        fontFamily: "Quicksand",
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              Expanded(child: SizedBox()),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Order_tracking(),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Container(
                                    alignment: Alignment.center,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.green.shade300
                                            .withOpacity(0.8)),
                                    // width: 100,
                                    // height: 40,
                                    child: Text(
                                      "Track order",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontFamily: "Quicksand",
                                          fontWeight: FontWeight.w800),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    } else {
                      return Center(child: SizedBox());
                    }

                    // return SizedBox(
                    //   height: MediaQuery.of(context).size.height - 197,
                    //   child: ListView.builder(
                    //     itemCount: snapshot.data!.docs.length,
                    //     itemBuilder: (context, index) {
                    //       final orderDocument = snapshot.data!.docs[index];
                    //       final orderData =
                    //           orderDocument.data() as Map<String, dynamic>;
                    //       final orderItems =
                    //           orderData['items'] as List<dynamic>;
                    //       ratings = List<double>.filled(
                    //           snapshot.data!.docs.length, 0.0);
                    //       return Align(
                    //         alignment: Alignment.bottomCenter,
                    //         child: Container(
                    //           child: Column(
                    //             children: [
                    //               SizedBox(height: 5),
                    //               Padding(
                    //                 padding: const EdgeInsets.symmetric(
                    //                     horizontal: 10),
                    //                 child: Row(
                    //                   mainAxisAlignment:
                    //                       MainAxisAlignment.spaceBetween,
                    //                   crossAxisAlignment:
                    //                       CrossAxisAlignment.start,
                    //                   children: [
                    //                     Container(
                    //                       width: 100,
                    //                       height: 100,
                    //                       decoration: BoxDecoration(
                    //                         borderRadius:
                    //                             BorderRadius.circular(15),
                    //                         image: DecorationImage(
                    //                           fit: BoxFit.cover,
                    //                           image: NetworkImage(
                    //                               "${orderItems[0]['image']}"),
                    //                         ),
                    //                       ),
                    //                     ),
                    //                     Padding(
                    //                       padding: const EdgeInsets.symmetric(
                    //                           horizontal: 5),
                    //                       child: Column(
                    //                         mainAxisAlignment:
                    //                             MainAxisAlignment.start,
                    //                         crossAxisAlignment:
                    //                             CrossAxisAlignment.start,
                    //                         children: [
                    //                           Text(
                    //                             "${orderItems[0]['restaurantname']}",
                    //                             style: TextStyle(
                    //                                 fontSize:
                    //                                     MediaQuery.of(context)
                    //                                             .size
                    //                                             .height *
                    //                                         0.022,
                    //                                 color: Colors.black,
                    //                                 fontFamily: "Quicksand",
                    //                                 fontWeight:
                    //                                     FontWeight.w900),
                    //                           ),
                    //                           Text(
                    //                             "${orderItems[0]['restaurantloaction']}",
                    //                             style: TextStyle(
                    //                                 fontSize:
                    //                                     MediaQuery.of(context)
                    //                                             .size
                    //                                             .height *
                    //                                         0.015,
                    //                                 color: Colors.grey.shade500,
                    //                                 fontFamily: "Quicksand",
                    //                                 fontWeight:
                    //                                     FontWeight.w500),
                    //                           ),
                    //                           Text(
                    //                             DateFormat(
                    //                                     'dd/MM/yyyy, hh:mm a')
                    //                                 .format(orderDocument[
                    //                                         'timestamp']
                    //                                     .toDate()),
                    //                             style: TextStyle(
                    //                                 fontSize:
                    //                                     MediaQuery.of(context)
                    //                                             .size
                    //                                             .height *
                    //                                         0.015,
                    //                                 color: Colors.grey.shade400,
                    //                                 fontFamily: "Quicksand",
                    //                                 fontWeight:
                    //                                     FontWeight.w500),
                    //                           ),
                    //                         ],
                    //                       ),
                    //                     ),
                    //                     Expanded(child: SizedBox()),
                    //                     Padding(
                    //                       padding: const EdgeInsets.symmetric(
                    //                           horizontal: 5),
                    //                       child: Text(
                    //                         "✔️Delivered",
                    //                         style: TextStyle(
                    //                             color: Colors.green.shade300,
                    //                             fontSize: 14,
                    //                             fontWeight: FontWeight.bold),
                    //                       ),
                    //                     ),
                    //                   ],
                    //                 ),
                    //               ),
                    //               SizedBox(height: 10),
                    //               Padding(
                    //                 padding: const EdgeInsets.symmetric(
                    //                     horizontal: 10),
                    //                 child: Row(
                    //                     // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //                     crossAxisAlignment:
                    //                         CrossAxisAlignment.start,
                    //                     children: [
                    //                       Text(
                    //                         "₹ ${orderDocument['totalAmount'].toString()} ",
                    //                         style: TextStyle(
                    //                             fontSize: MediaQuery.of(context)
                    //                                     .size
                    //                                     .height *
                    //                                 0.016,
                    //                             color: Colors.grey.shade900,
                    //                             fontFamily: "Quicksand",
                    //                             fontWeight: FontWeight.w800),
                    //                       ),
                    //                       Text(
                    //                         '| ${orderItems.length.toString()} items',
                    //                         style: TextStyle(
                    //                             fontSize: MediaQuery.of(context)
                    //                                     .size
                    //                                     .height *
                    //                                 0.016,
                    //                             color: Colors.grey.shade900,
                    //                             fontFamily: "Quicksand",
                    //                             fontWeight: FontWeight.w800),
                    //                       ),
                    //                       Expanded(child: SizedBox()),
                    //                       InkWell(
                    //                         onTap: () {},
                    //                         child: Text(
                    //                           'View Details',
                    //                           style: TextStyle(
                    //                               fontSize:
                    //                                   MediaQuery.of(context)
                    //                                           .size
                    //                                           .height *
                    //                                       0.015,
                    //                               color: Colors.grey.shade800,
                    //                               fontFamily: "Quicksand",
                    //                               fontWeight: FontWeight.w900),
                    //                         ),
                    //                       ),
                    //                     ]),
                    //               ),
                    //               SizedBox(height: 5),
                    //               Divider(
                    //                 thickness: 1.5,
                    //                 color: Colors.grey.shade300,
                    //               )
                    //             ],
                    //           ),
                    //         ),
                    //       );
                    //     },
                    //   ),
                    // );

                    // },
                    // );
                  },
                )),
        ],
      ),
    );
  }
}

class TopRatedRes extends StatefulWidget {
  final Map<String, dynamic> restaurantData;

  const TopRatedRes({super.key, required this.restaurantData});

  @override
  State<TopRatedRes> createState() => _TopRatedResState();
}

class _TopRatedResState extends State<TopRatedRes> {
  bool isFavorite = false;
  bool ismenuTap = false;
  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });

    final message =
        isFavorite ? 'Added to favorites' : 'Removed from favorites';

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: Duration(seconds: 1),
      backgroundColor: Colors.red.shade400,
      behavior: SnackBarBehavior.floating,
    ));
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

    int timeInSeconds = (distanceInMeters / 3).round();

    if (_isMounted) {
      setState(() {
        if (distanceInMeters > 1000) {
          distance = '| ${(distanceInMeters / 1000).toStringAsFixed(2)} km';
        } else {
          distance = '| 1.5 km';
        }

        if (timeInSeconds > 1000) {
          duration = '| ${(timeInSeconds / 60).toStringAsFixed(0)} mins';
        } else {
          duration = '| 10 mins';
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
                      child: Icon(
                        isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border_sharp,
                        // Icons.favorite_border_sharp,
                        size: 22,
                        color: isFavorite ? Colors.red : Colors.black,
                      ),
                    ),
                  ),
                ),
              )
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
                "⭐ ${widget.restaurantData['rating']} $distance $duration",
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

class ExploreRes extends StatefulWidget {
  final Map<String, dynamic> restaurantData;

  ExploreRes({super.key, required this.restaurantData});

  @override
  State<ExploreRes> createState() => _ExploreResState();
}

class _ExploreResState extends State<ExploreRes> {
  int randomValue = 0;
  void generateRandomNumber() {
    final random = Random();
    int randomNumber;

    do {
      randomNumber = (random.nextInt(8) + 3) * 10;
    } while (randomNumber <= 20 || randomNumber > 90);

    setState(() {
      randomValue = randomNumber;
    });
  }

  bool isFavorite = false;
  bool ismenuTap = false;
  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });

    final message =
        isFavorite ? 'Added to favorites' : 'Removed from favorites';

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: Duration(seconds: 1),
      backgroundColor: Colors.red.shade400,
      behavior: SnackBarBehavior.floating,
    ));
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
    _isMounted = true; // Widget is mounted
    generateRandomNumber();

    _calculateDistanceAndTime();
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

    int timeInSeconds = (distanceInMeters / 3).round();

    if (_isMounted) {
      setState(() {
        if (distanceInMeters > 1000) {
          distance = ' ${(distanceInMeters / 1000).toStringAsFixed(2)} km';
        } else if (distanceInMeters > 10000) {
          distance = "15 Km";
        } else {
          distance = '1.5 km';
        }

        if (timeInSeconds > 1000) {
          duration = '| ${(timeInSeconds / 60).toStringAsFixed(0)} mins';
        } else {
          duration = '| 10 mins';
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
          width: width,
          height: width * 0.45,
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
                right: 10,
                top: 10,
                child: InkWell(
                  onTap: () {
                    toggleFavorite();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Icon(
                        isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border_sharp,
                        // Icons.favorite_border_sharp,
                        size: 22,
                        color: isFavorite ? Colors.red : Colors.black,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        Container(
          width: width,
          height: width * 0.2,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.restaurantData['name'],
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.045,
                        color: Colors.black,
                        fontFamily: "Quicksand",
                        letterSpacing: 1,
                        fontWeight: FontWeight.w900),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "⭐ ${widget.restaurantData['rating']}",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.035,
                          color: Colors.black,
                          fontFamily: "Quicksand",
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${widget.restaurantData['subtitle']}",
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.035,
                        color: Colors.grey.shade600,
                        fontFamily: "Quicksand",
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "$distance  $duration",
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.035,
                        color: Colors.grey.shade600,
                        fontFamily: "Quicksand",
                        fontWeight: FontWeight.w600),
                  )
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}

// class CategoryWidget extends StatelessWidget {
//   final List<String> images;
//   final List<String> names;

//   const CategoryWidget({
//     Key? key,
//     required this.images,
//     required this.names,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Row(
//         children: List.generate(images.length, (index) {
//           return Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 10.0),
//             child: CategoryItem(
//               image: images[index],
//               name: names[index],
//               onTap: () {
//                 showCustomSnackBar(context, 'This feature is not available');
//               },
//             ),
//           );
//         }),
//       ),
//     );
//   }

//   void showCustomSnackBar(BuildContext context, String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message)),
//     );
//   }
// }

// class CategoryItem extends StatelessWidget {
//   final String image;
//   final String name;
//   final VoidCallback onTap;

//   const CategoryItem({
//     Key? key,
//     required this.image,
//     required this.name,
//     required this.onTap,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Image.asset(
//             image,
//             width: MediaQuery.of(context).size.width * 0.25,
//             height: MediaQuery.of(context).size.width * 0.25,
//           ),
//           SizedBox(height: 5),
//           Text(
//             name,
//             style: TextStyle(
//               fontSize: MediaQuery.of(context).size.width * 0.04,
//               color: Colors.black,
//               fontFamily: "Quicksand-Bold",
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class CategoryWidget extends StatelessWidget {
  final List<String> images;
  final List<String> names;

  const CategoryWidget({
    Key? key,
    required this.images,
    required this.names,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(images.length, (index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: CategoryItem(
              image: images[index],
              name: names[index],
              onTap: () {
                final category = names[index];
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        RestaurantListScreen(category: category),
                  ),
                );
              },
            ),
          );
        }),
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final String image;
  final String name;
  final VoidCallback onTap;

  const CategoryItem({
    Key? key,
    required this.image,
    required this.name,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            image,
            width: MediaQuery.of(context).size.width * 0.20,
            height: MediaQuery.of(context).size.width * 0.20,
          ),
          SizedBox(height: 5),
          Text(
            name,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.04,
              color: Colors.black,
              fontFamily: "Quicksand",
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class RestaurantListScreen extends StatelessWidget {
  final String category;

  const RestaurantListScreen({Key? key, required this.category})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurants - $category'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getRestaurants(category),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Shimmer_loading();
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final restaurants = snapshot.data!;
            return ListView.builder(
              itemCount: restaurants.length,
              itemBuilder: (context, index) {
                final restaurant = restaurants[index];
                return ListTile(
                  title: Text(restaurant['name']),
                  subtitle: Text(restaurant['subtitle']),
                  // Add more details as needed
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> getRestaurants(String category) async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Restaurants')
        .where('categories', isEqualTo: category)
        .get();
    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
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
