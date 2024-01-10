// ignore_for_file: camel_case_types, avoid_print

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uber_eats/Pages/Groceries_page.dart';
import 'package:uuid/uuid.dart';

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

class groceries extends StatelessWidget {
  // Initialize Firestore
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final Uuid uuid = const Uuid();

  groceries({super.key});

  // Function to generate a unique ID for each item
  String generateUniqueId() {
    return uuid.v4();
  }

  // Function to save data to Firestore
  Future<void> saveDataToFirestore(
      List<GroceryItem> items, String category) async {
    try {
      // Convert GroceryItem objects to Map
      List<Map<String, dynamic>> itemList = items
          .map((item) => {
                'id': item.id,
                'title': item.title,
                'image': item.image,
                'price': item.price,
              })
          .toList();

      // Save data to Firestore without creating a sub-collection
      await firestore.collection('groceries').doc(category).set({
        'items': itemList,
      });

      print('Data saved successfully for $category!');
    } catch (e) {
      print('Error saving data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Define items for each category
    List<GroceryItem> fruitsAndVegetables = [
      GroceryItem(
          id: generateUniqueId(),
          title: 'Mango',
          image: 'mango_image_url.jpg',
          price: 50.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Banana',
          image: 'banana_image_url.jpg',
          price: 20.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Apple',
          image: 'apple_image_url.jpg',
          price: 30.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Orange',
          image: 'orange_image_url.jpg',
          price: 25.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Grapes',
          image: 'grapes_image_url.jpg',
          price: 40.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Tomato',
          image: 'tomato_image_url.jpg',
          price: 15.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Potato',
          image: 'potato_image_url.jpg',
          price: 10.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Onion',
          image: 'onion_image_url.jpg',
          price: 18.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Spinach (Palak)',
          image: 'spinach_image_url.jpg',
          price: 12.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Bhindi (Okra)',
          image: 'bhindi_image_url.jpg',
          price: 22.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Brinjal (Eggplant)',
          image: 'brinjal_image_url.jpg',
          price: 25.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Cauliflower',
          image: 'cauliflower_image_url.jpg',
          price: 30.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Carrot',
          image: 'carrot_image_url.jpg',
          price: 18.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Cucumber',
          image: 'cucumber_image_url.jpg',
          price: 15.0),
    ];

    List<GroceryItem> cookingAndOils = [
      GroceryItem(
          id: generateUniqueId(),
          title: 'Mustard Oil',
          image: 'mustard_oil_image_url.jpg',
          price: 40.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Sunflower Oil',
          image: 'sunflower_oil_image_url.jpg',
          price: 30.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Ghee',
          image: 'ghee_image_url.jpg',
          price: 60.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Coconut Oil',
          image: 'coconut_oil_image_url.jpg',
          price: 45.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Olive Oil',
          image: 'olive_oil_image_url.jpg',
          price: 55.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Cumin Seeds (Jeera)',
          image: 'cumin_seeds_image_url.jpg',
          price: 12.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Turmeric Powder (Haldi)',
          image: 'turmeric_powder_image_url.jpg',
          price: 8.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Coriander Powder (Dhania)',
          image: 'coriander_powder_image_url.jpg',
          price: 10.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Red Chili Powder',
          image: 'red_chili_powder_image_url.jpg',
          price: 15.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Mustard Seeds (Sarson)',
          image: 'mustard_seeds_image_url.jpg',
          price: 14.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Fenugreek Seeds (Methi)',
          image: 'fenugreek_seeds_image_url.jpg',
          price: 18.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Asafoetida (Hing)',
          image: 'asafoetida_image_url.jpg',
          price: 20.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Curry Leaves',
          image: 'curry_leaves_image_url.jpg',
          price: 8.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Cardamom (Elaichi)',
          image: 'cardamom_image_url.jpg',
          price: 30.0),
    ];

    List<GroceryItem> meatAndFish = [
      GroceryItem(
          id: generateUniqueId(),
          title: 'Chicken Curry Cut',
          image: 'chicken_curry_cut_image_url.jpg',
          price: 120.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Mutton',
          image: 'mutton_image_url.jpg',
          price: 200.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Rohu Fish',
          image: 'rohu_fish_image_url.jpg',
          price: 150.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Pomfret',
          image: 'pomfret_image_url.jpg',
          price: 180.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Prawns',
          image: 'prawns_image_url.jpg',
          price: 250.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Chicken Sausages',
          image: 'chicken_sausages_image_url.jpg',
          price: 180.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Eggs',
          image: 'eggs_image_url.jpg',
          price: 6.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Turkey (for festive seasons)',
          image: 'turkey_image_url.jpg',
          price: 300.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Salmon',
          image: 'salmon_image_url.jpg',
          price: 250.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Crab',
          image: 'crab_image_url.jpg',
          price: 200.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Lamb Chops',
          image: 'lamb_chops_image_url.jpg',
          price: 280.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Hilsa Fish',
          image: 'hilsa_fish_image_url.jpg',
          price: 180.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Catfish (Singhara)',
          image: 'catfish_image_url.jpg',
          price: 120.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Quail',
          image: 'quail_image_url.jpg',
          price: 150.0),
    ];

    List<GroceryItem> bakeryAndSnacks = [
      GroceryItem(
          id: generateUniqueId(),
          title: 'Naan',
          image: 'naan_image_url.jpg',
          price: 25.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Roti',
          image: 'roti_image_url.jpg',
          price: 15.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Samosa',
          image: 'samosa_image_url.jpg',
          price: 10.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Pakora',
          image: 'pakora_image_url.jpg',
          price: 12.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Biscuits (various types)',
          image: 'biscuits_image_url.jpg',
          price: 20.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Bread (White and Brown)',
          image: 'bread_image_url.jpg',
          price: 25.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Poha (Flattened Rice)',
          image: 'poha_image_url.jpg',
          price: 18.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Idli/Dosa Batter',
          image: 'idli_dosa_batter_image_url.jpg',
          price: 30.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Mathri',
          image: 'mathri_image_url.jpg',
          price: 15.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Kachori',
          image: 'kachori_image_url.jpg',
          price: 12.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Khakhra',
          image: 'khakhra_image_url.jpg',
          price: 20.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Sev',
          image: 'sev_image_url.jpg',
          price: 10.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Dhokla Mix',
          image: 'dhokla_mix_image_url.jpg',
          price: 25.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Aloo Bonda',
          image: 'aloo_bonda_image_url.jpg',
          price: 18.0),
    ];

    List<GroceryItem> beverages = [
      GroceryItem(
          id: generateUniqueId(),
          title: 'Masala Chai',
          image: 'masala_chai_image_url.jpg',
          price: 15.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Green Tea',
          image: 'green_tea_image_url.jpg',
          price: 25.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Coffee Powder',
          image: 'coffee_powder_image_url.jpg',
          price: 30.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Mango Lassi',
          image: 'mango_lassi_image_url.jpg',
          price: 40.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Buttermilk',
          image: 'buttermilk_image_url.jpg',
          price: 12.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Coconut Water',
          image: 'coconut_water_image_url.jpg',
          price: 20.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Thandai (for festivals)',
          image: 'thandai_image_url.jpg',
          price: 50.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Jaljeera',
          image: 'jaljeera_image_url.jpg',
          price: 18.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Aam Panna',
          image: 'aam_panna_image_url.jpg',
          price: 25.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Sugarcane Juice',
          image: 'sugarcane_juice_image_url.jpg',
          price: 15.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Badam Milk',
          image: 'badam_milk_image_url.jpg',
          price: 30.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Rose Sherbet',
          image: 'rose_sherbet_image_url.jpg',
          price: 20.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Nimbu Pani (Lemonade)',
          image: 'nimbu_pani_image_url.jpg',
          price: 15.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Rooh Afza',
          image: 'rooh_afza_image_url.jpg',
          price: 35.0),
    ];

    // Save data for each category
    // saveDataToFirestore(fruitsAndVegetables, 'fruitsAndVegetables');
    // saveDataToFirestore(cookingAndOils, 'cookingAndOils');
    // saveDataToFirestore(meatAndFish, 'meatAndFish');
    // saveDataToFirestore(bakeryAndSnacks, 'bakeryAndSnacks');
    // saveDataToFirestore(beverages, 'beverages');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Firebase Demo'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CategoryScreen()));
                },
                child: const Text("Groceries")),
            ElevatedButton(
              onPressed: () {
                // Save data for each category
                saveDataToFirestore(fruitsAndVegetables, 'fruitsAndVegetables');
                saveDataToFirestore(cookingAndOils, 'cookingAndOils');
                saveDataToFirestore(meatAndFish, 'meatAndFish');
                saveDataToFirestore(bakeryAndSnacks, 'bakeryAndSnacks');
                saveDataToFirestore(beverages, 'beverages');
              },
              child: const Text('Save Data to Firebase'),
            ),
          ],
        ),
      ),
    );
  }
}
