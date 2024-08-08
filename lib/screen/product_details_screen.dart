import 'package:flutter/material.dart';
import '../model/product_model.dart';

class ProductDetailsPage extends StatelessWidget {
  final Product product;

  ProductDetailsPage({required this.product});

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
    final screenHeight = mediaQuery.size.height;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_ios),
            ),
            Spacer(),
            Text(
              "Short dress",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Icon(Icons.share),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: screenHeight * 0.5, // Adjust height based on screen height
                child: PageView.builder(
                  controller: PageController(viewportFraction: 0.8),
                  itemCount: product.images.length,
                  itemBuilder: (context, index) {
                    return Transform.scale(
                      scale: index == 1 ? 1 : 0.9,
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Image.network(
                              product.images[index],
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 10,
                            child: IconButton(
                              icon: Icon(
                                Icons.favorite_border,
                                color: Colors.grey,
                               // size: 30,
                              ),
                              onPressed: () {
                                // Handle favorite button press
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          product.brand,
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        Text(
                          'Price: \$${product.price}',
                          style: TextStyle(fontSize: 15, color: Colors.red),
                        ),
                      ],
                    ),
                    Text(
                      product.title,
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    buildRatingStars(product.rating),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(fontSize: 14, color: Colors.black),
                        children: [
                          TextSpan(
                            text: 'Description: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: product.description,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),
              Center(
                child: SizedBox(
                  width: screenWidth * 0.75,
                  child: ElevatedButton(
                    onPressed: () {
                      // Add to cart action
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      'Add to Cart',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
