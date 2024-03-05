import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uber_eats/Pages/Food_page.dart';

class RestaurantSearchScreen extends StatefulWidget {
  @override
  _RestaurantSearchScreenState createState() => _RestaurantSearchScreenState();
}

class _RestaurantSearchScreenState extends State<RestaurantSearchScreen> {
  TextEditingController _searchController = TextEditingController();
  List<DocumentSnapshot> searchResults = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(height: 45),
          ),
          // SliverAppBar(
          //   title: Text('Restaurant Search'),
          //   floating: true,
          //   expandedHeight: 50,
          //   flexibleSpace: Padding(
          //     padding: EdgeInsets.symmetric(horizontal: 10.0),
          //     child:
          //   ),
          // ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        size: 30,
                      )),
                  SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          searchRestaurants(value);
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: Icon(Icons.clear),
                                  onPressed: () {
                                    setState(() {
                                      _searchController.clear();
                                      searchResults.clear();
                                    });
                                  },
                                )
                              : null,
                          hintText: 'Search restaurants...',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 12.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    "Top Categories",
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.05,
                        color: Colors.black,
                        fontFamily: "Quicksand",
                        fontWeight: FontWeight.w800),
                  ),
                  CategoryWidget(
                    images: [
                      "assets/food_images/Burger.png",
                      "assets/food_images/Shawarma_.png",
                      "assets/food_images/mexican.png",
                      "assets/food_images/Ice-cream.png",
                      "assets/food_images/pasta.png",
                    ],
                    names: [
                      "Burger",
                      "Shawarma",
                      "Mexican",
                      "Ice Cream",
                      "Pasta",
                    ],
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      _searchController.text.isNotEmpty ? "Results:" : '',
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.035,
                          color: Colors.black,
                          fontFamily: "Quicksand",
                          fontWeight: FontWeight.w600),
                    ),
                  )
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(10),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  var restaurant = searchResults[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(restaurant['imageUrl']),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              restaurant['name'],
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.050,
                                  color: Colors.black,
                                  fontFamily: "Monasan",
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              restaurant['address'],
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.040,
                                  color: Colors.grey.shade400,
                                  fontFamily: "Monasan",
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                  // ListTile(
                  //   leading: Image.network(restaurant['imageUrl']),
                  //   title: Text(restaurant['name']),
                  //   subtitle: Text(restaurant['address']),
                  // );
                },
                childCount: searchResults.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void searchRestaurants(String searchText) async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('Restaurants').get();

    setState(() {
      searchResults = querySnapshot.docs.where((doc) {
        // Filter the documents based on the search text
        String name = doc['name'].toString().toLowerCase();

        // You can include other fields for searching as needed
        // Adjust the conditions based on your requirements

        return name.contains(searchText.toLowerCase());
        // location.contains(searchText.toLowerCase()) ||
        // price.contains(searchText.toLowerCase());
      }).toList();
    });
  }
}
