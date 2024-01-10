// ignore_for_file: file_names, camel_case_types, avoid_print, prefer_const_constructors, avoid_types_as_parameter_names, non_constant_identifier_names

import 'package:uber_eats/Screens/RestaurantDetailsPage.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:uber_eats/Tracking/order_traking.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uber_eats/Screens/ordes_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uber_eats/Utils/utils.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:uber_eats/groceries/groceries_search_screen.dart';

class RestaurantList extends StatefulWidget {
  const RestaurantList({super.key});

  @override
  State<RestaurantList> createState() => _RestaurantListState();
}

class _RestaurantListState extends State<RestaurantList> {
  @override
  Widget build(BuildContext context) {
    CollectionReference restaurants =
        FirebaseFirestore.instance.collection('Restaurants');
    return Scaffold(
      // backgroundColor: Colors.grey.shade200,
      body: StreamBuilder<QuerySnapshot>(
        stream: restaurants.orderBy('time', descending: false).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: const CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Text('No restaurants found');
          }
          return Stack(
            children: [
              CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        const SizedBox(height: 30),
                        //INTRO - Location - Profile image-----
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Intro_Widget(),
                        ),
                        //SEARCH BAR-----------------------
                        const SearchBar(),
                        //LOGO----------------------
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 180,
                          child: Stack(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 500,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage("assets/utiles/Logo.png"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 120,
                                bottom: 25,
                                child: Center(
                                  child: AnimatedTextKit(
                                    animatedTexts: [
                                      ColorizeAnimatedText(
                                        textAlign: TextAlign.center,
                                        'On time guarantee',
                                        textStyle: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                        colors: colorizeColors,
                                      ),
                                      ColorizeAnimatedText(
                                        textAlign: TextAlign.right,
                                        '    Order Now 🍔',
                                        textStyle: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                        colors: colorizeColors,
                                      ),
                                      ColorizeAnimatedText(
                                        '    Join Now 👑',
                                        textStyle: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                        colors: colorizeColors,
                                      ),
                                    ],
                                    isRepeatingAnimation: true,
                                    repeatForever: true,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 10),
                        //EXPLORE WIDGET------------
                        const explore_Widget(),
                        const SizedBox(height: 15),
                        //WHATS ON YOUR MIND?------------------
                        const MindItems_Widget(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width / 5,
                              height: 1,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'ALL RESTAURANTS',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 5,
                              height: 1,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        //Fliter-----------------
                        const Fliter_Widget(),
                        const SizedBox(height: 10),
                        Center(
                          child: Text(
                            " ${snapshot.data!.docs.length} restaurants delivering to you",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: Text(
                            "FEATURED",
                            style: TextStyle(
                                fontSize: 14,
                                letterSpacing: 0.5,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, Index) {
                        final restaurantData = snapshot.data!.docs[Index].data()
                            as Map<String, dynamic>;
                        return GestureDetector(
                          onTap: () {
                            if (restaurantData.containsKey('restaurantId')) {
                              final String restaurantId = restaurantData[
                                  'restaurantId']; // Extract the restaurantId
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RestaurantDetailsPage(
                                      restaurantId: restaurantId),
                                ),
                              );
                            } else {
                              print(
                                  'Restaurant ID is missing in restaurantData');
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 10),
                            child: RestaurantCard(
                              restaurantData: snapshot.data!.docs[Index].data()
                                  as Map<String, dynamic>,
                            ),
                          ),
                        );
                      },
                      childCount: snapshot.data!.docs.length,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: const SizedBox(height: 52),
                  )
                ],
              ),
              Positioned(
                bottom: 0,
                left: 0,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5), // Shadow color
                          spreadRadius: 2, // Spread radius
                          blurRadius: 2, // Blur radius
                          offset:
                              const Offset(0, 2), // Offset in the Y direction
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.transparent,
                    ),
                    width: MediaQuery.of(context).size.width * 0.95,
                    height: 50,
                    alignment: Alignment.center,
                    child: Center(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Order_tracking(),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 2,
                                    offset: const Offset(2, 0),
                                  ),
                                ],
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    bottomLeft: Radius.circular(15)),
                                color: Colors.pink.shade100,
                              ),
                              alignment: Alignment.center,
                              height: 50,
                              width:
                                  (MediaQuery.of(context).size.width * 0.95) /
                                      2,
                              // color: Colors.white,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/utiles/Navigation_icon.png",
                                      scale: 3,
                                      // color: Colors.blue,
                                    ),
                                    Text("Track order"),
                                  ]),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Orders_page(),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey
                                        .withOpacity(0.5), // Shadow color
                                    spreadRadius: 2, // Spread radius
                                    blurRadius: 2, // Blur radius
                                    offset: const Offset(2, 0),
                                  ),
                                ],
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(15),
                                    bottomRight: Radius.circular(15)),
                                color: Colors.blue.shade100,
                              ),
                              height: 50,
                              width:
                                  (MediaQuery.of(context).size.width * 0.95) /
                                      2,
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/utiles/Fod_icon.png",
                                    scale: 3,
                                  ),
                                  const SizedBox(width: 5),
                                  Text("Order Details"),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          );
        },
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

  @override
  void initState() {
    super.initState();
    generateRandomNumber();
  }

  @override
  Widget build(BuildContext) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 1,
                offset: const Offset(2, 0),
              ),
            ],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width / 2,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          child: Stack(
            alignment: AlignmentDirectional.topStart,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  image: DecorationImage(
                    image: NetworkImage(
                      widget.restaurantData['imageUrl'],
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        toggleFavorite();
                      },
                      icon: Icon(
                        isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border_sharp,
                        // Icons.favorite_border_sharp,
                        size: 35,
                        color: isFavorite ? Colors.red : Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        menuRestaurant();
                      },
                      icon: const Icon(
                        Icons.more_vert_outlined,
                        size: 35,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 20,
                top: 50,
                child: ismenuTap
                    ? Container(
                        decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(width: 1, color: Colors.grey)),
                        width: 200,
                        height: 120,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const SizedBox(
                                  width: 5,
                                ),
                                InkWell(
                                  onTap: () {
                                    print("Show Similar");
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Image.asset(
                                        "assets/utiles/simlar_icon.png",
                                        scale: 4.5,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      const Text(
                                        "Show similar restaurants",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 14),
                                      ),
                                      const Expanded(child: SizedBox())
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                InkWell(
                                  onTap: () {
                                    print("Hide this restaurant");
                                  },
                                  child: const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Icon(
                                        Icons.visibility_off,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "Hide this restaurant",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 14),
                                      ),
                                      Expanded(child: SizedBox())
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                InkWell(
                                  onTap: () {
                                    print("Share");
                                  },
                                  child: const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: 3,
                                      ),
                                      Icon(
                                        Icons.share_rounded,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "Share",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 14),
                                      ),
                                      Expanded(child: SizedBox())
                                    ],
                                  ),
                                ),
                              ]),
                        ),
                      )
                    : Container(
                        color: Colors.transparent,
                        width: 200,
                        height: 50,
                      ),
              )
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3), // Shadow color
                spreadRadius: 1, // Spread radius
                blurRadius: 1, // Blur radius
                offset: const Offset(0, 3), // Offset in the Y direction
              ),
            ],
          ),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width / 3.5,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.restaurantData['name'],
                      style: GoogleFonts.patuaOne(
                          fontWeight: FontWeight.w400,
                          fontSize: 22,
                          color: Colors.black87,
                          letterSpacing: 2),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.green),
                      width: 55,
                      height: 26,
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.restaurantData['rating'],
                              style: const TextStyle(color: Colors.black),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.star,
                              color: Colors.white,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    const Icon(
                      Icons.timer,
                      color: Colors.green,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      "10 - ${widget.restaurantData['time']} min 3 Km",
                      style: const TextStyle(color: Colors.black),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Divider(
                  thickness: 2,
                  height: 2,
                  color: Colors.grey[400],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Image.asset(
                      "assets/utiles/discont.png",
                      color: Colors.indigo.shade300,
                      // scale: 20,
                      width: 20,
                      height: 20,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      "$randomValue% OFF up to ₹${randomValue + 50} ",
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.indigo.shade300,
                          fontWeight: FontWeight.w700),
                    )
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

class explore_Widget extends StatelessWidget {
  const explore_Widget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 3,
              height: 1,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "EXPLORE",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    letterSpacing: 1),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 3,
              height: 1,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            InkWell(
              onTap: () {
                showCustomSnackBar(context, 'Now this Feature is not Avaiable');
              },
              child: Container(
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3), // Shadow color
                        spreadRadius: 1, // Spread radius
                        blurRadius: 1, // Blur radius
                        offset: const Offset(0, 2), // Offset in the Y direction
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                width: (MediaQuery.of(context).size.width) / 3.3,
                height: 140,
                child: Column(
                  children: [
                    Image.asset(
                      "assets/utiles/offers_1.png",
                      scale: 1,
                      color: Colors.indigo,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Center(
                      child: Text(
                        "Offers",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    const Center(
                      child: Text(
                        "Up to 60% OFF",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.black),
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            InkWell(
              onTap: () {
                // show_AlertDialog(context);
                showCustomSnackBar(context, 'Now this Feature is not Avaiable');
              },
              child: Container(
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3), // Shadow color
                        spreadRadius: 1, // Spread radius
                        blurRadius: 1, // Blur radius
                        offset: const Offset(0, 2), // Offset in the Y direction
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                width: (MediaQuery.of(context).size.width) / 3.3,
                height: 140,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    Image.asset(
                      "assets/utiles/Healthy.png",
                      scale: 2,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Center(
                      child: Text(
                        "Healthy",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    const Center(
                      child: Text(
                        "Curated Dishes",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.black),
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            InkWell(
              onTap: () {
                showCustomSnackBar(context, 'Now this Feature is not Avaiable');
              },
              child: Container(
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3), // Shadow color
                        spreadRadius: 1, // Spread radius
                        blurRadius: 1, // Blur radius
                        offset: const Offset(0, 2), // Offset in the Y direction
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                width: (MediaQuery.of(context).size.width) / 3.3,
                height: 140,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    Image.asset(
                      "assets/utiles/Fast-delivery.png",
                      scale: 1,
                      // color: Colors.indigo,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Center(
                      child: Text(
                        "Fast Delivery",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    const Center(
                      child: Text(
                        "Just 15-20 mins ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.black),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}

class MindItems_Widget extends StatelessWidget {
  const MindItems_Widget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 8,
              height: 1,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "WHAT'S ON YOUR MIND?",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    letterSpacing: 1),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 8,
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
              const SizedBox(
                width: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width / 3,
                height: MediaQuery.of(context).size.height * 0.35,
                color: Colors.transparent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    InkWell(
                      onTap: () {
                        showCustomSnackBar(
                            context, 'Now this Feature is not Avaiable');
                      },
                      child: Image.asset(
                        "assets/food_images/Biryani.png",
                        scale: 4,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Biryani",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 18),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () {
                        showCustomSnackBar(
                            context, 'Now this Feature is not Avaiable');
                      },
                      child: Image.asset(
                        "assets/food_images/Fired_Rice.png",
                        scale: 7,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Fired Rice",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 18),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 3,

                height: MediaQuery.of(context).size.height * 0.35,
                // color: Colors.amber,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        showCustomSnackBar(
                            context, 'Now this Feature is not Avaiable');
                      },
                      child: Image.asset(
                        "assets/food_images/Dosa.png",
                        scale: 5,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Dosa",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 18),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () {
                        showCustomSnackBar(
                            context, 'Now this Feature is not Avaiable');
                      },
                      child: Image.asset(
                        "assets/food_images/Idli.png",
                        scale: 7,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Idil",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 18),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 3,

                height: MediaQuery.of(context).size.height * 0.35,
                // color: Colors.amber,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        showCustomSnackBar(
                            context, 'Now this Feature is not Avaiable');
                      },
                      child: Image.asset(
                        "assets/food_images/Chicken.png",
                        scale: 8,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Chicken",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 18),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    InkWell(
                      onTap: () {
                        showCustomSnackBar(
                            context, 'Now this Feature is not Avaiable');
                      },
                      child: Image.asset(
                        "assets/food_images/Panner.png",
                        scale: 7,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Panner",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 18),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 3,
                height: MediaQuery.of(context).size.height * 0.35,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        showCustomSnackBar(
                            context, 'Now this Feature is not Avaiable');
                      },
                      child: Image.asset(
                        "assets/food_images/Thali.png",
                        scale: 7,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Thali",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 18),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        showCustomSnackBar(
                            context, 'Now this Feature is not Avaiable');
                      },
                      child: Image.asset(
                        "assets/food_images/Pizza.png",
                        scale: 10,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      "Pizza",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 18),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 3,
                height: MediaQuery.of(context).size.height * 0.35,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        showCustomSnackBar(
                            context, 'Now this Feature is not Avaiable');
                      },
                      child: Image.asset(
                        "assets/food_images/Noodles.png",
                        scale: 6,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Noodles",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 18),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    InkWell(
                      onTap: () {
                        showCustomSnackBar(
                            context, 'Now this Feature is not Avaiable');
                      },
                      child: Image.asset(
                        "assets/food_images/Ice-cream.png",
                        scale: 8,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      "Ice Cream",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 18),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class Intro_Widget extends StatefulWidget {
  const Intro_Widget({super.key});

  @override
  State<Intro_Widget> createState() => _Intro_WidgetState();
}

class _Intro_WidgetState extends State<Intro_Widget> {
  String locationInfo = 'Loading...';

  @override
  void initState() {
    super.initState();
    _getLocationInfo();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _getLocationInfo() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (!mounted) return;
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        String address =
            '${placemark.subLocality}, ${placemark.locality}, ${placemark.administrativeArea}';
        setState(() {
          locationInfo = address;
        });
      } else {
        setState(() {
          locationInfo = 'Address not found';
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        locationInfo = 'Error fetching location data ';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(
              Icons.location_on_rounded,
              color: Colors.red,
              size: 40,
            ),
            const SizedBox(
              width: 5,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Text("Home",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                    Icon(Icons.keyboard_arrow_down_sharp)
                  ],
                ),
                Text(locationInfo)
                // location()
              ],
            )
          ],
        ),
        InkWell(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            width: 50,
            // height: 130,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black, width: 1),
              image: const DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("assets/utiles/profile_ani.png"),
              ),
            ),
          ),
        ),
      ],
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
              builder: (context) => groceries_search_screen(),
            ));
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 2,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  width: 5,
                ),
                const Icon(Icons.search_sharp, color: Colors.indigo, size: 30),
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
                    color: Colors.indigo,
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

class Fliter_Widget extends StatelessWidget {
  const Fliter_Widget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          const SizedBox(
            width: 10,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300, width: 2),
              color: Colors.white,
            ),
            width: 100,
            height: 40,
            child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.sort_sharp),
                  SizedBox(
                    width: 3,
                  ),
                  Text(
                    "Sort",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  Icon(Icons.arrow_drop_down_sharp)
                ]),
          ),
          const SizedBox(
            width: 10,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300, width: 2),
              color: Colors.white,
            ),
            width: 80,
            height: 40,
            child: const Center(
              child: Text(
                "Nearest",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300, width: 2),
              color: Colors.white,
            ),
            width: 100,
            height: 40,
            child: const Center(
              child: Text(
                "Great Offers",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300, width: 2),
              color: Colors.white,
            ),
            width: 100,
            height: 40,
            child: const Center(
              child: Text(
                "Rating 4.0+",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300, width: 2),
              color: Colors.white,
            ),
            width: 150,
            height: 40,
            child: const Center(
              child: Text(
                "Previously Ordered",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300, width: 2),
              color: Colors.white,
            ),
            width: 80,
            height: 40,
            child: const Center(
              child: Text(
                "Pure Veg",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          )
        ],
      ),
    );
  }
}
