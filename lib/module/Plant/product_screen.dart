import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.08,
            vertical: screenHeight * 0.02,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: screenHeight * 0.35,
                width: screenWidth * 0.9,
                child: Image.asset("Assets/plant.png", fit: BoxFit.fitHeight),
              ),
              SizedBox(height: screenHeight * 0.03),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Monstera",
                    style: GoogleFonts.cabin(
                      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.teal),
                      Text(
                        '5',
                        style: GoogleFonts.cabin(
                          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        '/10',
                        style: GoogleFonts.cabin(
                          textStyle: TextStyle(
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.04),

              const Text(
                'Description',
                style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: screenHeight * 0.015),

              Text(
                "Monstera is a genus of 40 to 60 tropical and warm temperate flowering annuals and perennials from the family Asteraceae, tribe Eupatorieae. Most species are native to Central America...Read More",
                style: GoogleFonts.cabin(
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.035),

              Text(
                'Size',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Medium',
                    style: GoogleFonts.cabin(
                      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    'Orchid',
                    style: GoogleFonts.cabin(
                      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    '12.6',
                    style: GoogleFonts.cabin(
                      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    '82%',
                    style: GoogleFonts.cabin(
                      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Spacer(),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Price',
                        style: GoogleFonts.cabin(
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      Text(
                        '\$ 200',
                        style: GoogleFonts.cabin(
                          textStyle: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      height: screenHeight * 0.08,
                      width: screenWidth * 0.5,
                      decoration: BoxDecoration(
                        color: const Color(0xff50AD98),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Add to Cart',
                        style: GoogleFonts.cabin(
                          textStyle: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
