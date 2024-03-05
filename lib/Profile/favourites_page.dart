import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ionicons/ionicons.dart';
import 'package:uber_eats/Utils/utils.dart';
import 'package:uber_eats/dash_screen.dart';
import 'package:uber_eats/data/restaurant_data.dart';

class Favourites_page extends StatefulWidget {
  const Favourites_page({super.key});

  @override
  State<Favourites_page> createState() => _Favourites_pageState();
}

class _Favourites_pageState extends State<Favourites_page> {
  String distance = 'd';
  String duration = 'cadc';

  @override
  void initState() {
    super.initState();
  }

  Stream<QuerySnapshot> getFavoriteRestaurantsStream() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userId = user.uid;
      final favoriteRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('favorites');

      return favoriteRef.snapshots();
    }
    // If user is not logged in, return an empty stream
    return Stream.empty();
  }

  Future<void> _calculateDistanceAndTimeForRestaurant(
      DocumentSnapshot restaurantData) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final currentPosition = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);

        final startLatitude = currentPosition.latitude;
        final startLongitude = currentPosition.longitude;

        final destinationLatitude = double.parse(restaurantData["latitude"]);
        final destinationLongitude = double.parse(restaurantData["longitude"]);
        final distanceInMeters = await Geolocator.distanceBetween(startLatitude,
            startLongitude, destinationLatitude, destinationLongitude);

        final timeInSeconds = (distanceInMeters / 3).round();

        setState(() {
          if (distanceInMeters > 1000) {
            distance = '| ${(distanceInMeters / 1000).toStringAsFixed(2)} km';
          } else {
            distance = '| 1.5 km';
          }
          print(distance);

          if (timeInSeconds > 1000) {
            duration = '| ${(timeInSeconds / 60).toStringAsFixed(0)} mins';
          } else {
            duration = '| 10 mins';
          }
        });
      }
    } catch (e) {
      print('Error calculating distance and time: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              size: 35,
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Dash_board(
                    selectindex: 4,
                  ),
                ),
              );
            },
          ),
        ),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, bottom: 10),
                child: Text(
                  "Favourites",
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.05,
                      color: Colors.black,
                      fontFamily: "League-Regular",
                      fontWeight: FontWeight.w800),
                ),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: getFavoriteRestaurantsStream(),
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
                          } else {
                            print('Restaurant ID is missing in restaurantData');
                          }
                        },
                        child: TopRatedRes(
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
        ));
  }
}

class TopRatedRes extends StatefulWidget {
  final Map<String, dynamic> restaurantData;

  const TopRatedRes({super.key, required this.restaurantData});

  @override
  State<TopRatedRes> createState() => _TopRatedResState();
}

class _TopRatedResState extends State<TopRatedRes> {
  @override
  void initState() {
    super.initState();
    getRestaurantDetails(widget.restaurantData['restaurantId']);
  }

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

  Future<Map<String, dynamic>> getRestaurantDetails(String restaurantId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('Restaurants')
          .doc(restaurantId)
          .get();

      if (snapshot.exists) {
        return snapshot.data() ?? {}; // Return restaurant data if it exists
      } else {
        return {}; // Return empty map if restaurant doesn't exist
      }
    } catch (e) {
      print('Error getting restaurant details: $e');
      return {}; // Return empty map in case of error
    }
  }

  @override
  Widget build(BuildContext) {
    final width = MediaQuery.of(context).size.width;
    final restaurantId = widget.restaurantData['restaurantId'];

    return FutureBuilder<Map<String, dynamic>>(
      future: getRestaurantDetails(restaurantId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ListTile(
            title: Text('Loading...'),
          );
        } else if (snapshot.hasError) {
          return ListTile(
            title: Text('Error loading restaurant details'),
          );
        } else {
          final restaurantDetails = snapshot.data;
          if (restaurantDetails != null && restaurantDetails.isNotEmpty) {
            final restaurantName = restaurantDetails['name'];
            // Add more fields as per your restaurant document structure
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 100,
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: NetworkImage(
                              restaurantDetails['imageUrl'],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 15),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            restaurantName ?? 'Restaurant Name not found',
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.055,
                                color: Colors.black,
                                fontFamily: "League-Regular",
                                fontWeight: FontWeight.w900),
                          ),
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                size: 20,
                              ),
                              Text(
                                "${restaurantDetails['address']}",
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.035,
                                    color: Colors.grey.shade500,
                                    fontFamily: "League-Regular",
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Text(
                            "⭐ ${restaurantDetails['rating']}",
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.035,
                                color: Colors.black,
                                fontFamily: "MonaSans",
                                fontWeight: FontWeight.w900),
                          ),
                        ],
                      ),
                      Expanded(child: SizedBox()),
                      InkWell(
                        onTap: () {
                          toggleFavorite();
                        },
                        child: Icon(
                          Ionicons.heart_dislike,
                          size: 25,
                        ),
                      )
                    ]),
              ),
            );
          } else {
            return ListTile(
              title: Text('Restaurant not found'),
            );
          }
        }
      },
    );
  }
}
