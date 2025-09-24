import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../home/home_screen.dart';
import '../festivals/festivals_screen.dart';
import '../communities/communities_screen.dart';

// Add these to your pubspec.yaml if not already present:
// cached_network_image: ^3.3.0
// url_launcher: ^6.2.2

// Model for product items
class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final double rating;
  final String imageUrl;
  final String category;
  final Map<String, dynamic> artist;
  final Map<String, dynamic> details;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.rating,
    required this.imageUrl,
    required this.category,
    required this.artist,
    required this.details,
  });
}

// Dummy data
final List<Product> dummyProducts = [
  // Eco-friendly Murtis
  Product(
    id: 'm1',
    title: 'Eco Ganesha',
    description: 'Handcrafted eco-friendly Ganesha idol made from natural clay and organic colors',
    price: 2499.0,
    rating: 4.8,
    imageUrl: 'assets/images/ecoMurti1.jpg',
    category: 'murti',
    artist: {
      'name': 'Rajesh Patil',
      'experience': '15 years',
      'location': 'Kolkata, West Bengal',
      'phone': '+91 98765 43210',
      'email': 'rajesh.murtikar@example.com',
      'rating': 4.7,
      'productsMade': 1200,
    },
    details: {
      'height': '12 inches',
      'width': '8 inches',
      'weight': '2.5 kg',
      'materials': 'Natural clay, organic colors, jute base',
      'deliveryTime': '5-7 days',
      'ecoFriendly': true,
    },
  ),
  Product(
    id: 'm2',
    title: 'Clay Ganpati Idol',
    description: 'Elegant Ganpati idol made from natural clay with vegetable dyes',
    price: 3499.0,
    rating: 4.9,
    imageUrl: 'assets/images/ecoMurti2.jpg',
    category: 'murti',
    artist: {
      'name': 'Sunita Devi',
      'experience': '22 years',
      'location': 'Kumartuli, Kolkata',
      'phone': '+91 98765 12345',
      'email': 'sunitadevi.art@example.com',
      'rating': 4.9,
      'productsMade': 2500,
    },
    details: {
      'height': '18 inches',
      'width': '14 inches',
      'weight': '4.2 kg',
      'materials': 'Natural clay, vegetable dyes, jute',
      'deliveryTime': '7-10 days',
      'ecoFriendly': true,
    },
  ),
  // Banjo Groups
  Product(
    id: 'b1',
    title: 'Rhythm Beats',
    description: 'Professional Banjo group with 10+ years of experience in festivals',
    price: 15000.0,
    rating: 4.7,
    imageUrl: 'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
    category: 'banjo',
    artist: {
      'name': 'Rhythm Beats Group',
      'experience': '12 years',
      'location': 'Mumbai, Maharashtra',
      'phone': '+91 98765 67890',
      'email': 'rhythm.beats@example.com',
      'rating': 4.7,
      'eventsPerformed': 350,
    },
    details: {
      'groupSize': '8 members',
      'performanceDuration': '2-4 hours',
      'genres': 'Traditional, Bollywood, Fusion',
      'equipmentProvided': 'Yes',
      'travel': 'Pan India',
    },
  ),
  // Dhol-Tasha Groups
  Product(
    id: 'd1',
    title: 'Maharashtra Dhol Tasha Pathak',
    description: 'Energetic Dhol-Tasha group specializing in Ganesh Chaturthi processions',
    price: 20000.0,
    rating: 4.9,
    imageUrl: 'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
    category: 'dhol',
    artist: {
      'name': 'Shiv Dhol Tasha Pathak',
      'experience': '15 years',
      'location': 'Pune, Maharashtra',
      'phone': '+91 98765 98765',
      'email': 'shivdhol@example.com',
      'rating': 4.9,
      'eventsPerformed': 500,
    },
    details: {
      'groupSize': '15-20 members',
      'performanceDuration': '3-5 hours',
      'specialization': 'Ganesh Chaturthi, Navratri, Weddings',
      'equipmentProvided': 'Yes (Dhol, Tasha, Lezim)',
      'travel': 'Maharashtra & Goa',
    },
  ),
];

class StoreScreen extends StatefulWidget {
  const StoreScreen({Key? key}) : super(key: key);

  @override
  _StoreScreenState createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  String _selectedCategory = 'murti';
  final TextEditingController _searchController = TextEditingController();

  List<Product> get filteredProducts {
    return dummyProducts.where((product) => product.category == _selectedCategory).toList();
  }

  void _showProductDetails(Product product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ProductDetailsSheet(product: product),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7F5),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'EcoMurti',
          style: GoogleFonts.playfairDisplay(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFD2691E),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for murtis, banjo groups...',
                prefixIcon: const Icon(Icons.search, color: Color(0xFFFF9B00)),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          
          // Category Chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildCategoryChip('Murtis', 'murti'),
                  const SizedBox(width: 8),
                  _buildCategoryChip('Banjo Groups', 'banjo'),
                  const SizedBox(width: 8),
                  _buildCategoryChip('Dhol-Tasha', 'dhol'),
                ],
              ),
            ),
          ),
          
          // Product Grid
          Expanded(
            child: filteredProducts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 60,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No products found',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      return _buildProductCard(filteredProducts[index]);
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildCategoryChip(String label, String category) {
    final isSelected = _selectedCategory == category;
    return FilterChip(
      label: Text(
        label,
        style: GoogleFonts.poppins(
          color: isSelected ? Colors.white : const Color(0xFF666666),
          fontWeight: FontWeight.w500,
        ),
      ),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedCategory = category;
        });
      },
      backgroundColor: Colors.white,
      selectedColor: const Color(0xFFFF9B00),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: 2,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFFFF9B00),
        unselectedItemColor: const Color(0xFF666666),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 24),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on, size: 24),
            label: 'Pandals',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store, size: 24),
            label: 'Store',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline, size: 24),
            label: 'Communities',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const FestivalsScreen(),
              ),
            );
          } else if (index == 3) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const CommunitiesScreen(),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return GestureDetector(
      onTap: () => _showProductDetails(product),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: buildProductImage(
                product.imageUrl,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
            
            // Product Details
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF333333),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '₹${product.price.toStringAsFixed(0)}',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFFF9B00),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${product.rating} (${(product.rating * 20).toInt()})',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: const Color(0xFF666666),
                        ),
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
  }

}

class ProductDetailsSheet extends StatelessWidget {
  final Product product;

  const ProductDetailsSheet({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: buildProductImage(
                product.imageUrl,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Product Title and Price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    product.title,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF333333),
                    ),
                  ),
                ),
                Text(
                  '₹${product.price.toStringAsFixed(0)}',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFFF9B00),
                  ),
                ),
              ],
            ),
            
            // Rating
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 20),
                const SizedBox(width: 4),
                Text(
                  '${product.rating} (${(product.rating * 20).toInt()})',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: const Color(0xFF666666),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Description
            Text(
              'Description',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product.description,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: const Color(0xFF666666),
                height: 1.5,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Product Details
            Text(
              'Product Details',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 8),
            ...product.details.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '• ${entry.key}: ',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF333333),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '${entry.value}',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: const Color(0xFF666666),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            
            const SizedBox(height: 16),
            
            // Artist Details
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8E1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFFE082)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About the ${product.category == 'murti' ? 'Artist' : 'Group'}\n${product.artist['name']}',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow('Experience', '${product.artist['experience']}'),
                  _buildInfoRow('Location', product.artist['location']),
                  _buildInfoRow('Contact', product.artist['phone']),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            final phone = product.artist['phone'];
                            launchUrl(Uri.parse('tel:$phone'));
                          },
                          icon: const Icon(Icons.phone, size: 18),
                          label: const Text('Call'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white, 
                            backgroundColor: const Color(0xFFFF9B00),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            final email = product.artist['email'];
                            launchUrl(Uri.parse('mailto:$email'));
                          },
                          icon: const Icon(Icons.email, size: 18),
                          label: const Text('Email'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFFFF9B00),
                            side: const BorderSide(color: Color(0xFFFF9B00)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Contact Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final phone = product.artist['phone'];
                  launchUrl(Uri.parse('tel:$phone'));
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, 
                  backgroundColor: const Color(0xFFFF9B00),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: Text(
                  'Contact ${product.artist['name']} Now',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
  
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF333333),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: const Color(0xFF666666),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Shared image builder that supports both asset paths and network URLs.
Widget buildProductImage(
  String path, {
  double? height,
  double? width,
  BoxFit fit = BoxFit.cover,
}) {
  if (path.startsWith('assets/')) {
    return Image.asset(
      path,
      height: height,
      width: width ?? double.infinity,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          'assets/images/ecoMurti1.jpg',
          height: height,
          width: width ?? double.infinity,
          fit: fit,
        );
      },
    );
  }

  return CachedNetworkImage(
    imageUrl: path,
    height: height,
    width: width ?? double.infinity,
    fit: fit,
    placeholder: (context, url) => Container(
      height: height,
      color: Colors.grey[200],
      child: const Center(child: CircularProgressIndicator()),
    ),
    errorWidget: (context, url, error) => Image.asset(
      'assets/images/chintamani.jpg',
      height: height,
      width: width ?? double.infinity,
      fit: fit,
    ),
  );
}
