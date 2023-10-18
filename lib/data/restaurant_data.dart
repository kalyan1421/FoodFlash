// restaurant_data.dart
class FoodItem {
  final String name;
  final double price;
  final String imageUrl;

  FoodItem({required this.name, required this.price, required this.imageUrl});
}

class RestaurantData {
  final String restaurantName;
  final List<FoodItem> foodItems;

  RestaurantData({required this.restaurantName, required this.foodItems});
}

// Sample restaurant data
final List<RestaurantData> restaurantsData = [
  RestaurantData(
    restaurantName: "Restaurant 1",
    foodItems: [
      FoodItem(
          name: "Item 1",
          price: 10.0,
          imageUrl:
              "https://images.pexels.com/photos/1988624/pexels-photo-1988624.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
      FoodItem(
          name: "Item 2",
          price: 12.0,
          imageUrl:
              "https://images.pexels.com/photos/1988624/pexels-photo-1988624.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
      // Add more food items for Restaurant 1
    ],
  ),
  RestaurantData(
    restaurantName: "Restaurant 2",
    foodItems: [
      FoodItem(
          name: "Item A",
          price: 15.0,
          imageUrl:
              "https://images.pexels.com/photos/1988624/pexels-photo-1988624.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
      FoodItem(
          name: "Item B",
          price: 8.0,
          imageUrl:
              "https://images.pexels.com/photos/1988624/pexels-photo-1988624.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
      // Add more food items for Restaurant 2
    ],
  ),
  // Add more restaurants
];
