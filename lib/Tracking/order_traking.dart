// ignore_for_file: camel_case_types, prefer_const_constructors, unnecessary_cast, avoid_print, prefer_final_fields, unused_field, prefer_const_literals_to_create_immutables, deprecated_member_use

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uber_eats/Provider/user_provider.dart';
import 'package:uber_eats/model/user.dart' as model;
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uber_eats/Utils/utils.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import "package:intl/intl.dart";
import 'dart:async';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:location/location.dart' as location;

class Order_tracking extends StatefulWidget {
  const Order_tracking({super.key});

  @override
  State<Order_tracking> createState() => _OrderTrackingState();
}

class _OrderTrackingState extends State<Order_tracking> {
  late Timer _animationTimer = Timer(Duration.zero, () {});
  String locationInfo = 'Loading...';
  List<Map<String, dynamic>> orderItems = [];
  double totalAmount = 0.0;
  String orderTimestamp = "";
  String nearbyLocationInfo = '';
  GoogleMapController? _controller;
  final Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  Set<Marker> _iconMarkers = {};

  late LatLng _deliveryLocation;
  late LatLng _userLocation;
  late BitmapDescriptor _bikeIcon;
  MapType _currentMapType = MapType.normal;

  Completer<GoogleMapController> _mapController = Completer();
  double _animationFraction = 0.0;
  String selectedAmount = '';
  bool _isDeliveryCompleted = false;
  bool _isTrafficEnabled = false;

  late Polyline _polyline;
  location.Location _location = location.Location();

  late LatLng bikePosition;
  final Duration _animationDuration = const Duration(milliseconds: 1000);

  void _toggleMapType() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  void _toggleTraffic() {
    setState(() {
      _isTrafficEnabled = !_isTrafficEnabled;
    });
  }

  @override
  void dispose() {
    _animationTimer.cancel();
    super.dispose();
  }

  Set<Polyline> _polyLines = {};
  GoogleMapController? mapController;
  LatLng? source;
  LatLng destination = const LatLng(17.4380, 78.3986);

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    bikePosition = destination;
    _animationTimer = Timer.periodic(_animationDuration, (timer) {
      moveBike();
    });
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        _isDeliveryCompleted = true;
      });
    });
    fetchOrderDetails();
  }

  void moveBike() {
    if (source != null && bikePosition != null) {
      setState(() {
        double deltaLat = (source!.latitude - destination.latitude) / 10;
        double deltaLng = (source!.longitude - destination.longitude) / 10;

        bikePosition = LatLng(
          bikePosition.latitude - deltaLat,
          bikePosition.longitude - deltaLng,
        );

        if (_calculateDistance(bikePosition, source!) < 0.0001) {
          _animationTimer.cancel();
        }
      });
    }
  }

  double _calculateDistance(LatLng start, LatLng end) {
    return Geolocator.distanceBetween(
      start.latitude,
      start.longitude,
      end.latitude,
      end.longitude,
    );
  }

  Future<Position> _determinePosition() async {
    return await Geolocator.getCurrentPosition();
  }

  void _updateMapPosition() async {
    _polyLines.clear();
    await _getRoutePolyline(source!, destination);
    if (mounted) {
      setState(() {
        bikePosition = destination;
      });
    }
  }

  Future<void> _getRoutePolyline(LatLng start, LatLng finish) async {
    final polylinePoints = PolylinePoints();
    final List<LatLng> polylineCoordinates = [];

    final startPoint = PointLatLng(start.latitude, start.longitude);
    final finishPoint = PointLatLng(finish.latitude, finish.longitude);

    try {
      final result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey: "AIzaSyBHgv6qWJ_ADWU9jTNcKa5vMpThbfAlgns",
        request: PolylineRequest(
          origin: startPoint,
          destination: finishPoint,
          mode: TravelMode.driving,
        ),
      );

      if (result.points.isNotEmpty) {
        for (var point in result.points) {
          polylineCoordinates.add(
            LatLng(point.latitude, point.longitude),
          );
        }
      } else {
        print('No route found between $start and $finish');
        return;
      }
    } catch (e) {
      print('Error fetching route: $e');
      return;
    }

    final Polyline polyline = Polyline(
      polylineId: const PolylineId('polyline'),
      consumeTapEvents: true,
      points: polylineCoordinates,
      color: Colors.blue,
      width: 4,
    );

    if (mounted) {
      setState(() {
        _polyLines.add(polyline);
      });
    }
  }

  void _getCurrentLocation() async {
    try {
      Position currentPosition = await _determinePosition();
      setState(() {
        source = LatLng(currentPosition.latitude, currentPosition.longitude);
      });
      _updateMapPosition();
    } catch (e) {
      print('Error getting current location: $e');
    }
  }

  Future<void> fetchOrderDetails() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);

    try {
      final userId = userProvider.getUser?.uid;

      if (userId != null) {
        final orderSnapshot = await firestore
            .collection('users')
            .doc(userId)
            .collection('orders')
            .orderBy('timestamp', descending: true)
            .limit(1)
            .get();

        if (orderSnapshot.docs.isNotEmpty) {
          final orderDocument = orderSnapshot.docs.first;
          final orderData = orderDocument.data() as Map<String, dynamic>;
          final items = orderData['items'] as List<dynamic>;
          final totalAmount = orderData['totalAmount'] as double;
          final timestamp = orderData['timestamp'] as Timestamp;
          final dateTime = timestamp.toDate();
          final formattedDateTime = DateFormat.MMMd().add_jm().format(dateTime);
          setState(() {
            orderItems = List<Map<String, dynamic>>.from(items);
            this.totalAmount = totalAmount;
            orderTimestamp = formattedDateTime;
          });
        }
      }
    } catch (e) {
      print('Error fetching order details: $e');
    }
  }

  void _makePhoneCall(String phoneNumber) async {
    try {
      await launch(phoneNumber);
    } on PlatformException catch (e) {
      print("Failed to make phone call: ${e.message}");
    }
  }

  @override
  Widget build(BuildContext context) {
    model.User? user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      body: orderItems.isEmpty
          ? Center(child: Text("No Order placed"))
          : NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    leading: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        size: 30,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    actions: [
                      IconButton(
                        icon: const Icon(
                          Icons.share,
                          size: 26,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                    backgroundColor: Colors.indigo.shade400,
                    elevation: 5,
                    collapsedHeight: 180,
                    shadowColor: Colors.grey.shade200,
                    expandedHeight: 180,
                    floating: true,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      // centerTitle: true,
                      titlePadding: EdgeInsets.only(
                          right: 5,
                          left: MediaQuery.of(context).size.width * 0.03),
                      title: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 80),
                          Text(
                              _isDeliveryCompleted
                                  ? "Order delivered. Enjoy your meal!"
                                  : "     Order on the way .Get ready!",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.aBeeZee(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 24)),
                          SizedBox(height: 5),
                          Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.white54.withOpacity(.2),
                                borderRadius: BorderRadius.circular(10)),
                            width: MediaQuery.of(context).size.width * 0.42,
                            height: 35,
                            child: Text(
                              _isDeliveryCompleted
                                  ? "Delivered on time"
                                  : "Arriving in 14 mins",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ];
              },
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(children: [
                      SizedBox(
                        height: 450,
                        width: MediaQuery.of(context).size.width,
                        child: source == null
                            ? const Center(child: CircularProgressIndicator())
                            : GoogleMap(
                                polylines: _polyLines,
                                onMapCreated: (c) {
                                  mapController = c;
                                },
                                myLocationEnabled: true,
                                initialCameraPosition: CameraPosition(
                                  target: source!,
                                  zoom: 15.0,
                                ),
                                mapType: MapType.normal,
                              ),
                      ),
                      Positioned(
                        bottom: 100,
                        right: 10,
                        child: Column(
                          children: [
                            Tooltip(
                              message: "For satilate view",
                              child: IconButton(
                                  onPressed: _toggleMapType,
                                  icon: Icon(
                                    Icons.map_outlined,
                                    color: Colors.white,
                                    size: 40,
                                  )),
                            ),
                            IconButton(
                                onPressed: _toggleTraffic,
                                icon: Icon(
                                  Icons.traffic,
                                  color: Colors.white,
                                  size: 40,
                                )),
                          ],
                        ),
                      )
                    ]),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.35,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey
                                    .withOpacity(0.5), // Shadow color
                                spreadRadius: 2, // Spread radius
                                blurRadius: 2, // Blur radius
                                offset: const Offset(
                                    0, 2), // Offset in the Y direction
                              ),
                            ],
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Container(
                                    width: 45,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey.shade300,
                                    ),
                                    child: Image.asset(
                                      "assets/utiles/Delivery_person.png",
                                      scale: 1,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Kalyam kumar",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                      Text(
                                        "Your delivery partner",
                                        style: TextStyle(
                                            color: Colors.black45,
                                            fontSize: 16),
                                      ),
                                    ],
                                  ),
                                  Expanded(child: SizedBox()),
                                  Container(
                                    width: 40,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.shade400
                                                .withOpacity(
                                                    0.8), // Shadow color
                                            spreadRadius: 1, // Spread radius
                                            blurRadius: 1, // Blur radius
                                            offset: const Offset(0,
                                                1.5), // Offset in the Y direction
                                          ),
                                        ],
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            width: 1, color: Colors.grey)),
                                    child: Center(
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.message,
                                          size: 25,
                                          color: Colors.indigo,
                                        ),
                                        onPressed: () {},
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Container(
                                    width: 40,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.shade500
                                                .withOpacity(
                                                    0.8), // Shadow color
                                            spreadRadius: 1, // Spread radius
                                            blurRadius: 1, // Blur radius
                                            offset: const Offset(0,
                                                1.5), // Offset in the Y direction
                                          ),
                                        ],
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            width: 1, color: Colors.grey)),
                                    child: Center(
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.call,
                                          size: 25,
                                          color: Colors.indigo,
                                        ),
                                        onPressed: () {
                                          _makePhoneCall("tel:+9063290012");
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            Divider(
                              thickness: 1,
                              height: 2,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 5),
                                  Text(
                                    "Thank kalyan by leaving a tip ",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Text(
                                    "100% of the tip will go to your delivery partner.",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  SizedBox(height: 15),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      buildTipContainer('😁 ₹15'),
                                      SizedBox(width: 10),
                                      buildTipContainer('🤩 ₹20'),
                                      SizedBox(width: 10),
                                      buildTipContainer('😍 ₹30'),
                                      SizedBox(width: 10),
                                      buildTipContainer('👏 other'),
                                      SizedBox(width: 10),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 15),
                            Divider(
                              thickness: 1,
                              height: 2,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10, top: 10),
                              child: Row(
                                children: [
                                  Image.asset(
                                    "assets/utiles/Warning_shield.png",
                                    scale: 4,
                                    color: Colors.red,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    "Report a fraud",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  Expanded(child: SizedBox()),
                                  IconButton(
                                      onPressed: () {},
                                      icon: Icon(Icons.arrow_forward_ios_sharp))
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        // height: 250,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey
                                    .withOpacity(0.5), // Shadow color
                                spreadRadius: 2, // Spread radius
                                blurRadius: 2, // Blur radius
                                offset: const Offset(
                                    0, 2), // Offset in the Y direction
                              ),
                            ],
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          children: [
                            SizedBox(height: 10),
                            Text(
                              "Order details ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: orderItems.length,
                              itemBuilder: (context, index) {
                                final item = orderItems[index];
                                return OrderItemCard(
                                  itemName: item['item name'],
                                  price: item['price'],
                                  quantity: item['quantity'],
                                );
                              },
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(child: SizedBox()),
                                Text(
                                    "Total Amount: ₹${totalAmount.toStringAsFixed(1)},",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            SizedBox(height: 10),
                            Divider(height: 2, thickness: 2),
                            SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Image.asset(
                                    "assets/utiles/cooking_instructions.png",
                                    scale: 2,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Add cooking instructions",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        "Currently unavailable. Please call the \nrestaurant  directly",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w300),
                                        overflow: TextOverflow
                                            .ellipsis, // or TextOverflow.clip
                                        maxLines: 2,
                                      )
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.25,
                        decoration: BoxDecoration(
                            color: const Color.fromRGBO(255, 255, 255, 1),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey
                                    .withOpacity(0.5), // Shadow color
                                spreadRadius: 2, // Spread radius
                                blurRadius: 2, // Blur radius
                                offset: const Offset(
                                    0, 2), // Offset in the Y direction
                              ),
                            ],
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Container(
                                    width: 50,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            width: 2,
                                            color: Colors.grey.shade400)),
                                    child: Icon(
                                      Icons.person_2_sharp,
                                      size: 40,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${user!.username} , 9063290XXX",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        "Add alternate contact ",
                                        style: TextStyle(
                                            color: Colors.indigo, fontSize: 14),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(height: 10),
                              Divider(thickness: 2, height: 2),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Container(
                                    width: 50,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            width: 2, color: Colors.grey)),
                                    child: Icon(
                                      Icons.home_outlined,
                                      size: 40,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Delivery address",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        "",
                                        // locationInfo,
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 14),
                                      ),
                                      SizedBox(height: 5),
                                      InkWell(
                                        onTap: () {},
                                        child: Text(
                                          "Change address",
                                          style: TextStyle(
                                              color: Colors.indigo,
                                              fontSize: 14),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 100,
                    )
                  ],
                ),
              ),
            ),
    );
  }

  Widget buildTipContainer(String amount) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedAmount = amount;
        });

        print('Selected Amount: $amount');
      },
      child: Container(
        width: 70,
        height: 35,
        decoration: BoxDecoration(
            color: selectedAmount == amount ? Colors.white : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 1)),
        child: Stack(children: [
          selectedAmount == amount
              ? Positioned(
                  top: 3,
                  left: 10,
                  child: Text(
                    amount,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                )
              : Center(
                  child: Text(
                    amount,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
          selectedAmount == amount
              ? Positioned(
                  bottom: 0,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.indigo.shade300,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10))),
                    width: 80,
                    child: Text(
                      "Thanks",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ))
              : Positioned(child: Text(""))
        ]),
      ),
    );
  }
}

class OrderItemCard extends StatelessWidget {
  final String itemName;
  final double price;
  final int quantity;

  const OrderItemCard({
    super.key,
    required this.itemName,
    required this.price,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        // height: 100,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$quantity x $itemName",
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
                // Text(
                //   'Quantity: $quantity',
                //   style: TextStyle(fontSize: 18, color: Colors.black),
                // ),
              ],
            ),
            Text(
              '₹$price',
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}

class WidgetGoogleMap extends StatefulWidget {
  const WidgetGoogleMap({Key? key}) : super(key: key);

  @override
  _WidgetGoogleMapState createState() => _WidgetGoogleMapState();
}

class _WidgetGoogleMapState extends State<WidgetGoogleMap> {
  Set<Polyline> _polyLines = {};
  GoogleMapController? mapController;
  LatLng? source;
  LatLng destination =
      const LatLng(17.4380, 78.3986); 

  @override      
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: source == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              polylines: _polyLines,
              onMapCreated: (c) {
                mapController = c;
              },
              myLocationEnabled: true,
              initialCameraPosition: CameraPosition(
                target: source!,
                zoom: 12.0,
              ),
              mapType: MapType.normal,
            ),
    );
  }

  void _getCurrentLocation() async {
    try {
      Position currentPosition = await _determinePosition();
      setState(() {
        source = LatLng(currentPosition.latitude, currentPosition.longitude);
      });
      _updateMapPosition();
    } catch (e) {
      print('Error getting current location: $e');
    }
  }

  Future<Position> _determinePosition() async {
    return await Geolocator.getCurrentPosition();
  }

  void _updateMapPosition() async {
    _polyLines.clear();
    await _getRoutePolyline(source!, destination);
    setState(() {});
  }

  Future<void> _getRoutePolyline(LatLng start, LatLng finish) async {
    final polylinePoints = PolylinePoints();
    final List<LatLng> polylineCoordinates = [];

    final startPoint = PointLatLng(start.latitude, start.longitude);
    final finishPoint = PointLatLng(finish.latitude, finish.longitude);

    try {
      final result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey: APIKEY,
        request: PolylineRequest(
          origin: startPoint,
          destination: finishPoint,
          mode: TravelMode.driving,
        ),
      );

      if (result.points.isNotEmpty) {
        for (var point in result.points) {
          polylineCoordinates.add(
            LatLng(point.latitude, point.longitude),
          );
        }
      } else {
        print('No route found between $start and $finish');
        return;
      }
    } catch (e) {
      print('Error fetching route: $e');
      return;
    }

    final Polyline polyline = Polyline(
      polylineId: const PolylineId('polyline'),
      consumeTapEvents: true,
      points: polylineCoordinates,
      color: Colors.blue,
      width: 4,
    );

    setState(() {
      _polyLines.add(polyline);
    });
  }
}

String APIKEY = "AIzaSyBHgv6qWJ_ADWU9jTNcKa5vMpThbfAlgns";
