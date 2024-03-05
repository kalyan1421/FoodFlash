import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:uber_eats/Add_address/add_address.dart';
import 'package:uber_eats/groceries/groceries_items_screen.dart';
import 'package:uber_eats/groceries/groceries_search_screen.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final Map<String, String> categoryData = {
    'fruitsAndVegetables': 'Fresh Fruits & Vegetables',
    'cookingAndOils': 'Edible Oils and Ghee',
    'meatAndFish': 'Meat and Seafood',
    'bakeryAndSnacks': 'Biscuits and Munchies',
    'beverages': 'Cool Drinks and Juices',
    'MasalasAndDryFruits': " Masalas And Dry Fruits",
    'TeaAndCoffe': "Tea, Coffee and More",
    'CleaningEssentails': "Cleaning Essentails",
    'BathBodyHai': "Bath, Body and Hair"
  };

  List<String> filteredCategories = [];

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

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 5;
    final double itemWidth = size.width / 3;
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              collapsedHeight: 200,
              expandedHeight: 220,
              floating: true,
              pinned: true,
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.indigo.shade400,
                      Colors.indigo.shade300,
                      Colors.indigo.shade200,
                      Colors.indigo.shade200.withOpacity(0.5),
                      Colors.white30,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                height: 220,
                child: Column(
                  children: [
                    // const Expanded(child: SizedBox()),
                    const SizedBox(height: 45),
                    // location_insta(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
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
                                      color: Colors.white,
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
                    ),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => groceries_search_screen(),
                            ));
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.95,
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
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
                                          builder: (context) =>
                                              groceries_search_screen(),
                                        ));
                                  },
                                  child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Search",
                                          style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        AnimatedTextKit(
                                          animatedTexts: [
                                            RotateAnimatedText(
                                              ' Fruits',
                                              duration:
                                                  const Duration(seconds: 1),
                                              textStyle: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            RotateAnimatedText(
                                              ' Dry Fruits',
                                              duration:
                                                  const Duration(seconds: 1),
                                              textStyle: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            RotateAnimatedText(
                                              ' Tea',
                                              duration:
                                                  const Duration(seconds: 1),
                                              textStyle: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600),
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
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        SizedBox(width: 10),
                        Text(
                          "Instamart",
                          style: GoogleFonts.paytoneOne(
                              fontSize: 28,
                              letterSpacing: 1,
                              color: Colors.indigo,
                              fontWeight: FontWeight.bold),
                        ),
                        Expanded(child: SizedBox()),
                        Column(
                          children: [
                            Text(
                              "Delivering in ",
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Image.asset(
                                  "assets/utiles/power_delivery.png",
                                  scale: 25,
                                  color: Colors.indigo,
                                ),
                                Text(
                                  "10 Mins",
                                  style: GoogleFonts.alata(
                                      fontSize: 16,
                                      letterSpacing: 0.5,
                                      color: Colors.indigo,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(width: 10),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.95,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        // color: Colors.amber,
                        image: DecorationImage(
                            image: AssetImage(
                              "assets/Groceries_bannner_images/1.jpg",
                            ),
                            fit: BoxFit.fill),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.95,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        // color: Colors.amber,
                        image: DecorationImage(
                            image: AssetImage(
                              "assets/Groceries_bannner_images/2.jpg",
                            ),
                            fit: BoxFit.fill),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.95,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                            image: AssetImage(
                              "assets/Groceries_bannner_images/1.jpg",
                            ),
                            fit: BoxFit.fill),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "Shop by category",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: .1),
              ),
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: itemWidth / itemHeight,
                  crossAxisCount: 3,
                  crossAxisSpacing: 0,
                  mainAxisSpacing: 0,
                ),
                itemCount: categoryData.length,
                itemBuilder: (context, index) {
                  final categoryKey = categoryData.keys.elementAt(index);
                  final categoryName = categoryData[categoryKey]!;
                  final categoryImage =
                      'assets/images_groceries/$categoryKey.png'; // Adjust the path

                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => groceries_items_screen(
                              category: categoryKey,
                              categoryImage: categoryImage,
                              categoryName: categoryName,
                            ),
                          ),
                        );
                      },
                      child: CategoryCard(
                        categoryName: categoryName,
                        categoryImage: categoryImage,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onSearchTextChanged(String text) {
    filteredCategories = categoryData.keys
        .where((category) =>
            categoryData[category]!.toLowerCase().contains(text.toLowerCase()))
        .toList();
    setState(() {});
  }
}

class CategoryCard extends StatelessWidget {
  final String categoryName;
  final String categoryImage;

  const CategoryCard({
    Key? key,
    required this.categoryName,
    required this.categoryImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.indigo.shade200,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 5, top: 10),
            child: Text(
              categoryName,
              style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo.shade800),
            ),
          ),
          SizedBox(height: 5),
          Container(
            alignment: Alignment.bottomCenter,
            // height: 80,

            height: MediaQuery.of(context).size.width * 0.18,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.indigo.shade200,
              image: DecorationImage(
                image: AssetImage(categoryImage),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
