import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uber_eats/Utils/utils.dart';
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
              collapsedHeight: 180,
              expandedHeight: 190,
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
                height: 210,
                child: Column(
                  children: [
                    // const Expanded(child: SizedBox()),
                    const SizedBox(height: 25),
                    location_insta(),
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const groceries_search_screen(),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1.5, color: Colors.grey),
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Row(
                                children: [
                                  SizedBox(width: 10),
                                  Text(
                                    "Search by categories",
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.indigo),
                                  ),
                                  Expanded(child: SizedBox()),
                                  Icon(
                                    Icons.search,
                                    color: Colors.indigo.shade300,
                                    size: 30,
                                  ),
                                  SizedBox(width: 10),
                                ],
                              )),
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
                        // color: Colors.amber,
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
