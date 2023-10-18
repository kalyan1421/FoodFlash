// data_model.dart

class ItemData {
  final String title;
  final String imageUrl;
  final String text;
  final double rating;
  final String time;

  ItemData({
    required this.title,
    required this.imageUrl,
    required this.text,
    required this.rating,
    required this.time,
  });
}

List<ItemData> sampleData = [
  ItemData(
    title: "1989 Pizza ",
    imageUrl:
        "https://images.pexels.com/photos/1099680/pexels-photo-1099680.jpeg?auto=compress&cs=tinysrgb&w=600",
    text: '20 mins',
    rating: 4.5,
    time: 'Free Delivery ',
  ),
  ItemData(
    title: "Pista House",
    imageUrl:
        "https://images.pexels.com/photos/958545/pexels-photo-958545.jpeg?auto=compress&cs=tinysrgb&w=600",
    text: '55 mins',
    rating: 3.8,
    time: 'Free Delivery ',
  ),
  ItemData(
    title: "Hotel Ragavendra",
    imageUrl:
        'https://images.pexels.com/photos/3186654/pexels-photo-3186654.jpeg?auto=compress&cs=tinysrgb&w=600',
    text: '45 mins',
    rating: 4.2,
    time: 'Free Delivery ',
  ),
];
