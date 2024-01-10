// ignore_for_file: camel_case_types, file_names, use_key_in_widget_constructors

// import 'package:flutter/material.dart';

// class groceries extends StatefulWidget {
//   const groceries({super.key});

//   @override
//   State<groceries> createState() => _groceriesState();
// }

// ignore_for_file: avoid_print

// class _groceriesState extends State<groceries> {
//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: Column(
//         children: [
//           Center(
//             child: Text("Groceries"),
//           ),
//         ],
//       ),
//     );
//   }
// }
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

class groceries_add extends StatelessWidget {
  // Initialize Firestore
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final Uuid uuid = const Uuid();

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
    List<GroceryItem> MasalasAndDryFruits = [
      GroceryItem(
          id: generateUniqueId(),
          title: 'Pe Almond',
          image: 'mango_image_url.jpg',
          price: 350.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Groundnut',
          image: 'banana_image_url.jpg',
          price: 120.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Cashew Whole',
          image: 'apple_image_url.jpg',
          price: 180.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Roasted Cashew',
          image: 'orange_image_url.jpg',
          price: 340.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Kalmi Dates',
          image: 'grapes_image_url.jpg',
          price: 280.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Blask Raisins',
          image: 'tomato_image_url.jpg',
          price: 220.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Chia Seeds',
          image: 'potato_image_url.jpg',
          price: 140.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Jeera Whole',
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

    List<GroceryItem> TeaAndCoffe = [
      GroceryItem(
          id: generateUniqueId(),
          title: 'Flavourful Tea',
          image: 'mustard_oil_image_url.jpg',
          price: 250.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Bourn Vita',
          image: 'sunflower_oil_image_url.jpg',
          price: 300.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Red Lable ',
          image: 'ghee_image_url.jpg',
          price: 500.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Assam Tea',
          image: 'coconut_oil_image_url.jpg',
          price: 45.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Natural care Tea Oil',
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

    List<GroceryItem> CleaningEssentails = [
      GroceryItem(
          id: generateUniqueId(),
          title: 'Washing Powder',
          image: 'chicken_curry_cut_image_url.jpg',
          price: 120.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Ariel Detergent Powder',
          image: 'mutton_image_url.jpg',
          price: 200.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Surf Excel Detergent Powder',
          image: 'rohu_fish_image_url.jpg',
          price: 150.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Surf Excel Liquid Detergent',
          image: 'pomfret_image_url.jpg',
          price: 180.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Lizol Surface cleaner',
          image: 'prawns_image_url.jpg',
          price: 250.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Lizol Disinfectant Cleaner',
          image: 'chicken_sausages_image_url.jpg',
          price: 180.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Lizol Disinfectant Jasmine Cleaner',
          image: 'eggs_image_url.jpg',
          price: 300.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Vim Dishwash Liquid Gel',
          image: 'turkey_image_url.jpg',
          price: 300.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Sponge Wipe - Large ',
          image: 'salmon_image_url.jpg',
          price: 250.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Scrub Magic 2 in 1 ',
          image: 'crab_image_u in rl.jpg',
          price: 200.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Microfiber Duster',
          image: 'lamb_chops_image_url.jpg',
          price: 280.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Gala Twin Bucket spin  Mop',
          image: 'hilsa_fish_image_url.jpg',
          price: 180.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Bathroom Squeegee Wiper',
          image: 'catfish_image_url.jpg',
          price: 120.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Floor Squeegee Wiper',
          image: 'quail_image_url.jpg',
          price: 150.0),
    ];

    List<GroceryItem> BathBodyHai = [
      GroceryItem(
          id: generateUniqueId(),
          title: '6 Oil Nourish Shampoo',
          image: 'naan_image_url.jpg',
          price: 399.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'TRESemme Keratin Shampoo',
          image: 'roti_image_url.jpg',
          price: 400.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Dove Daily Shine Shampoo',
          image: 'samosa_image_url.jpg',
          price: 440.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Head & Shoulders Cool Menthol Shampoo',
          image: 'pakora_image_url.jpg',
          price: 350.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Cinthol Bath Soap',
          image: 'biscuits_image_url.jpg',
          price: 170.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Godrej No.1 Lime & Aloe Vera',
          image: 'bread_image_url.jpg',
          price: 166.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Poha (Flattened Rice)',
          image: 'poha_image_url.jpg',
          price: 150.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Dettol Intende Cool Soap',
          image: 'idli_dosa_batter_image_url.jpg',
          price: 300.0),
      GroceryItem(
          id: generateUniqueId(),
          title: "Neutrogena Deep Clean Foaming Cleaner",
          image: 'mathri_image_url.jpg',
          price: 320.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Garnier Facewash',
          image: 'kachori_image_url.jpg',
          price: 220.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Clean & Clear Foaming Facewash',
          image: 'khakhra_image_url.jpg',
          price: 200.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Cetaphil Oily Skin cleanser',
          image: 'sev_image_url.jpg',
          price: 500.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Nivea Face Wash',
          image: 'dhokla_mix_image_url.jpg',
          price: 250.0),
      GroceryItem(
          id: generateUniqueId(),
          title: 'Olay Total 7 in 1 Foaming Cleanser',
          image: 'aloo_bonda_image_url.jpg',
          price: 180.0),
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
            ElevatedButton(onPressed: (){
              Navigator.push(context, 
              MaterialPageRoute(builder: (context)=>const CategoryScreen()));
            }, child: const Text("Groceries")),
            ElevatedButton(
              onPressed: () {
                // Save data for each category
                saveDataToFirestore(BathBodyHai, 'BathBodyHai');
                saveDataToFirestore(CleaningEssentails, 'CleaningEssentails');
                // saveDataToFirestore(meatAndFish, 'meatAndFish');
                // saveDataToFirestore(bakeryAndSnacks, 'bakeryAndSnacks');
                // saveDataToFirestore(beverages, 'beverages');
              },
              child: const Text('Save Data to Firebase'),
            ),
          ],
        ),
      ),
    );
  }
}
