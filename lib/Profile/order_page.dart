// ignore_for_file: camel_case_types, unused_element
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

class Food_Orders_page extends StatefulWidget {
  const Food_Orders_page({Key? key}) : super(key: key);

  @override
  State<Food_Orders_page> createState() => _Food_Orders_pageState();
}

class _Food_Orders_pageState extends State<Food_Orders_page> {
  List<double> ratings = [];

  String _getOrderTime(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    String formattedTime =
        DateFormat('dd MMM yyyy \'at\' hh:mm a').format(dateTime);
    return formattedTime;
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(_user!.uid)
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

          return Column(
            children: [
              SizedBox(height: 10),
              SizedBox(
                height: MediaQuery.of(context).size.height - 197,
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final orderDocument = snapshot.data!.docs[index];
                    final orderData =
                        orderDocument.data() as Map<String, dynamic>;
                    final orderItems = orderData['items'] as List<dynamic>;
                    ratings =
                        List<double>.filled(snapshot.data!.docs.length, 0.0);
                        
                        
                    return Container(
                      child: Column(
                        children: [
                          SizedBox(height: 5),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                          "${orderItems[0]['image']}"),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${orderItems[0]['restaurantname']}",
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.022,
                                            color: Colors.black,
                                            fontFamily: "Quicksand",
                                            fontWeight: FontWeight.w900),
                                      ),
                                      Text(
                                        "${orderItems[0]['restaurantloaction']}",
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.015,
                                            color: Colors.grey.shade500,
                                            fontFamily: "Quicksand",
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        DateFormat('dd/MM/yyyy, hh:mm a')
                                            .format(orderDocument['timestamp']
                                                .toDate()),
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.015,
                                            color: Colors.grey.shade400,
                                            fontFamily: "Quicksand",
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(child: SizedBox()),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: Text(
                                    "✔️Delivered",
                                    style: TextStyle(
                                        color: Colors.green.shade300,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "₹ ${orderDocument['totalAmount'].toString()} ",
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.height *
                                                0.016,
                                        color: Colors.grey.shade900,
                                        fontFamily: "Quicksand",
                                        fontWeight: FontWeight.w800),
                                  ),
                                  Text(
                                    '| ${orderItems.length.toString()} items',
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.height *
                                                0.016,
                                        color: Colors.grey.shade900,
                                        fontFamily: "Quicksand",
                                        fontWeight: FontWeight.w800),
                                  ),
                                  Expanded(child: SizedBox()),
                                  InkWell(
                                    onTap: () {},
                                    child: Text(
                                      'View Details',
                                      style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.015,
                                          color: Colors.grey.shade800,
                                          fontFamily: "Quicksand",
                                          fontWeight: FontWeight.w900),
                                    ),
                                  ),
                                ]),
                          ),
                          SizedBox(height: 5),
                          Divider(
                            thickness: 1.5,
                            color: Colors.grey.shade300,
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );

          // },
          // );
        },
      ),
    );
  }
}

class My_Order extends StatefulWidget {
  const My_Order({super.key});

  @override
  State<My_Order> createState() => _My_OrderState();
}

class _My_OrderState extends State<My_Order> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          Icons.arrow_back,
          size: 35,
        ),
      )),
      backgroundColor: Colors.white24,
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "My Orders",
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.035,
                      color: Colors.black,
                      fontFamily: "League-Regular",
                      fontWeight: FontWeight.w800),
                ),
              ),
              TabBar(
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Image.asset(
                        //   "assets/Food_icon.png",
                        //   scale: 3,
                        // ),
                        SizedBox(width: 8),
                        Text(
                          'Food',
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Image.asset(
                        //   "assets/Groceries_icon.png",
                        //   scale: 4,
                        // ),
                        SizedBox(width: 8),
                        Text(
                          'Groceries',
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    Food_Orders_page(),
                    Food_Orders_page(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
