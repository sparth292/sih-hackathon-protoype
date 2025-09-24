import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GanpatiTriviaScreen extends StatelessWidget {
  const GanpatiTriviaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> triviaItems = [
      {
        'title': 'The Elephant-Headed God',
        'description': 'Lord Ganesha is easily recognized by his elephant head, which symbolizes wisdom, understanding, and a discriminating intellect that one should possess to attain perfection in life.',
        'icon': '🐘',
      },
      {
        'title': 'The Modak Lover',
        'description': 'Modak, a sweet dumpling, is considered to be Lord Ganesha\'s favorite food. It\'s traditionally offered to him during pujas and festivals.',
        'icon': '🍡',
      },
      {
        'title': 'The Remover of Obstacles',
        'description': 'Ganesha is known as Vighnaharta, the remover of obstacles. He is worshipped at the beginning of any new venture for success.',
        'icon': '🛤️',
      },
      {
        'title': 'The Scribe of Mahabharata',
        'description': 'Lord Ganesha is said to have written the epic Mahabharata as it was dictated to him by sage Vyasa.',
        'icon': '📜',
      },
      {
        'title': 'The Broken Tusk',
        'description': 'Ganesha\'s broken tusk symbolizes sacrifice and the idea of giving up something precious for a higher cause.',
        'icon': '🦷',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ganpati Trivia',
          style: GoogleFonts.playfairDisplay(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFD2691E),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF333333)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: triviaItems.length,
        itemBuilder: (context, index) {
          return _buildTriviaCard(
            context,
            title: triviaItems[index]['title']!,
            description: triviaItems[index]['description']!,
            emoji: triviaItems[index]['icon']!,
            index: index,
          );
        },
      ),
    );
  }

  Widget _buildTriviaCard(BuildContext context, {required String title, required String description, required String emoji, required int index}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: _getColorForIndex(index).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  emoji,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      color: const Color(0xFF666666),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getColorForIndex(int index) {
    final colors = [
      const Color(0xFFFF9B00), // Orange
      const Color(0xFF4CAF50), // Green
      const Color(0xFF2196F3), // Blue
      const Color(0xFF9C27B0), // Purple
      const Color(0xFFE91E63), // Pink
    ];
    return colors[index % colors.length];
  }
}
