import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:newgy/screen/product_details_screen.dart';


import 'dart:convert';

import '../model/product_model.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse('https://dummyjson.com/products'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print(data); // Print the entire response map

        // Adjust the following line according to the structure of the response
        final List<dynamic> productList = data['products']; // Assuming the products are inside 'products' key

        setState(() {
          products = productList.map((item) => Product.fromJson(item)).toList();
        });
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  Widget buildRatingStars(double rating) {
    final int fullStars = rating.toInt();
    final bool hasHalfStar = rating - fullStars >= 0.5;

    return Row(
      children: [
        for (var i = 0; i < fullStars; i++)
          Icon(Icons.star, color: Colors.deepOrange, size: 23,), // Full star
        if (hasHalfStar)
          Icon(Icons.star_half, color: Colors.deepOrange, size: 23,), // Half star
        for (var i = fullStars + (hasHalfStar ? 1 : 0); i < 5; i++)
          Icon(Icons.star_border, color: Colors.deepOrange, size: 23,), // Empty star
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Products', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(
                'Super summer sale',
                style: TextStyle(fontSize: 13),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: products.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailsPage(product: product),
                      ),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Container(
                      height: screenWidth * 0.37, // Adjust height based on screen width
                      child: Row(
                        children: [
                          Flexible(
                            flex: 3,
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: Image.network(
                                      product.images.isNotEmpty ? product.images[0] : '', // Use the first image URL or a placeholder
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 30,
                                  top: 20,
                                  child: Container(
                                    height: 30,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${product.discountPercentage}%', // Add percentage symbol
                                        style: TextStyle(color: Colors.white, fontSize: 10),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                            flex: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 50),
                                    child: buildRatingStars(product.rating),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 50),
                                    child: Text(product.title, style: TextStyle(fontWeight: FontWeight.bold),),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 140),
                                    child: Text(
                                      "\$${product.price.toStringAsFixed(2)}",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Bag',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
        currentIndex: 1, // Set the current index to highlight the selected item
        selectedItemColor: Colors.red[800],
        unselectedItemColor: Colors.grey,

        onTap: (index) {
          // Handle navigation tap
          print('Selected index: $index');
        },
      ),
    );
  }
}
