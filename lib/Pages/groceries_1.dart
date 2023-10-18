import 'package:flutter/material.dart';
import 'package:uber_eats/Features_Layouts/groceries_items_screen.dart';
import 'package:uber_eats/Features_Layouts/groceries_search_screen.dart';
// import 'package:uber_app/Screens/groceries_search_screen.dart';
import 'package:uber_eats/dash_screen.dart';

class GroceryItem {
  final String id;
  final String title;
  final String image;
  final double price;

  GroceryItem({
    required this.id,
    required this.title,
    required this.image,
    required this.price,
  });
}

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final Map<String, String> categoryData = {
    'fruitsAndVegetables': 'Fresh Fruits and Vegetables',
    'cookingAndOils': 'Edible Oils and Ghee',
    'meatAndFish': 'Meat and Seafood',
    'bakeryAndSnacks': 'Biscuits and Munchies',
    'beverages': 'Cool Drinks and Juices',
  };
  List<String> filteredCategories = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MyHomePage()));
                },
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
              ),
              backgroundColor: Colors.indigo,
              elevation: 5,
              collapsedHeight: 160,
              shadowColor: Colors.grey,
              expandedHeight: 160,
              floating: true,
              pinned: true,
              flexibleSpace: Column(
                children: [
                  const Expanded(child: SizedBox()),
                  const Text(
                    "Explore By Categories",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold),
                  ),
                  const Expanded(child: SizedBox()),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const groceries_search_screen(),
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
                                // boxShadow: [
                                //   BoxShadow(
                                //     color: Colors.white
                                //         .withOpacity(0.5), // Shadow color
                                //     spreadRadius: 2, // Spread radius
                                //     blurRadius: 5, // Blur radius
                                //     offset: const Offset(
                                //         0, 2), // Offset in the Y direction
                                //   ),
                                // ],
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15)),
                            child:
                                // TextField(
                                // onChanged: onSearchTextChanged,
                                // decoration: InputDecoration(
                                // hintText: 'Search Categories',
                                // prefixIcon: const Icon(Icons.search),
                                // border: OutlineInputBorder(
                                // borderRadius: BorderRadius.circular(15.0),
                                // ),
                                // ),
                                // ),
                                const Row(
                              children: [
                                SizedBox(width: 5),
                                Icon(
                                  Icons.search,
                                  color: Colors.indigo,
                                  size: 30,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  "Search by categories",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.indigo),
                                )
                              ],
                            )),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20)
                ],
              ),
            ),
          ];
        },
        body: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
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
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          groceries_items_screen(category: categoryKey),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              categoryName,
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo.shade900),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.width * 0.3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.indigo.shade200,
              image: DecorationImage(
                image: AssetImage(categoryImage),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
