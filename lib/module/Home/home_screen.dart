import 'package:flutter/material.dart';
import 'package:flutter_projects_week_6/module/Plant/product_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 13),
            child: Column(
              children: [
                SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      'Find your\n favorite plants',
                      style: GoogleFonts.cabin(
                        textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: screenWidth * 0.08,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      height: screenWidth * 0.13,
                      width: screenWidth * 0.13,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(Icons.search, size: 30),
                    ),
                  ],
                ),
                Image.asset("Assets/banner.png"),
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  height: 41,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildTabButton('All', isActive: true),

                        _buildTabButton('Indoor'),

                        _buildTabButton('Outdoor'),

                        _buildTabButton('Popular'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                SizedBox(
                  width: 370,
                  height: 400,
                  child: ListView.builder(
                    itemCount: 3,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () => Navigator.of(
                        context,
                      ).push(MaterialPageRoute(builder: (context) => ProductScreen())),
                      child: product(name: "Monstera", price: "200", img: "Assets/plant.png"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget product({required String name, required String price, required String img}) {
  return Container(
    width: 200,
    margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
    child: Column(
      children: [
        Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        name,
                        style: GoogleFonts.cabin(
                          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Text(
                        '\$$price',
                        style: GoogleFonts.cabin(
                          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                Image.asset(img),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: 50,
                      width: 130,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: const [
                          BoxShadow(blurRadius: 0.5, color: Colors.grey, spreadRadius: 0.5),
                        ],
                      ),
                      child: const Text(
                        'Add to Cart',
                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                      ),
                    ),
                    Container(
                      height: 40,
                      width: 40,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(blurRadius: 0.5, color: Colors.grey, spreadRadius: 0.5),
                        ],
                      ),
                      child: const Icon(Icons.favorite_border_rounded, color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildTabButton(String label, {bool isActive = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: Container(
      width: 83.34,
      height: 35.84,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: isActive ? Color(0xFF2E2D2D) : Color(0xFFAEAEAE)),
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Color(0xFF2E2D2D) : Color(0xFFAEAEAE),
            fontSize: 18,
            fontFamily: 'Cabin',
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    ),
  );
}
