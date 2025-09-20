import 'package:flutter/material.dart';
import 'package:smart_india_hackathon/user_screen/pandal_detail_screen.dart';

class PandalListScreen extends StatelessWidget {
  const PandalListScreen({super.key});

  // Dummy data for pandals
  final List<Map<String, dynamic>> pandals = const [
    {
      'id': '1',
      'name': 'Lalbaugcha Raja',
      'location': 'Lalbaug, Mumbai',
      'distance': '2.5 km',
      'rating': 4.8,
      'imageUrl': 'assets/images/pandal1.jpg',
      'description': 'One of the most famous Ganesh pandals in Mumbai, known for its grand celebrations and beautiful decorations.',
      'timings': '6:00 AM - 10:00 PM',
      'specialAttraction': 'Grand Aarti at 7 PM',
    },
    {
      'id': '2',
      'name': 'Ganesh Galli',
      'location': 'Dadar, Mumbai',
      'distance': '3.1 km',
      'rating': 4.7,
      'imageUrl': 'assets/images/pandal2.jpg',
      'description': 'Famous for its innovative themes and eco-friendly decorations.',
      'timings': '5:30 AM - 10:30 PM',
      'specialAttraction': 'Cultural programs in the evening',
    },
    {
      'id': '3',
      'name': 'Andheri Cha Raja',
      'location': 'Andheri, Mumbai',
      'distance': '5.2 km',
      'rating': 4.5,
      'imageUrl': 'assets/images/pandal3.jpg',
      'description': 'Known for its traditional celebrations and community participation.',
      'timings': '6:00 AM - 11:00 PM',
      'specialAttraction': 'Grand procession on last day',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ganesh Mandals'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFFFF6B35),
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: pandals.length,
        itemBuilder: (context, index) {
          final pandal = pandals[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PandalDetailScreen(pandal: pandal),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Pandal Image
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.asset(
                      pandal['imageUrl'],
                      height: 150,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 150,
                        color: const Color(0xFFFFF3E0),
                        child: const Icon(Icons.temple_hindu, size: 50, color: Color(0xFFFF6B35)),
                      ),
                    ),
                  ),
                  // Pandal Details
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                pandal['name'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF333333),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF3E0),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.star, size: 16, color: Color(0xFFFF6B35)),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${pandal['rating']}',
                                    style: const TextStyle(
                                      color: Color(0xFFFF6B35),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 16, color: Color(0xFFFF6B35)),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                pandal['location'],
                                style: const TextStyle(color: Colors.grey),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.directions_walk, size: 16, color: Color(0xFFFF6B35)),
                            const SizedBox(width: 4),
                            Text(
                              '${pandal['distance']} away',
                              style: const TextStyle(color: Colors.grey),
                            ),
                            const Spacer(),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PandalDetailScreen(pandal: pandal),
                                  ),
                                );
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: const Color(0xFFFF6B35),
                                padding: EdgeInsets.zero,
                              ),
                              child: const Text('View Details >'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
