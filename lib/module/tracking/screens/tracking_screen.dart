import 'package:flutter/material.dart';
import 'package:flutter_projects_week_6/utils/Extension/responsive_ui_extension.dart';
import 'package:flutter_projects_week_6/utils/theme/app_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(37.7749, -122.4194),
    zoom: 14,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => context.go('/home'),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          const GoogleMap(
            initialCameraPosition: _initialCameraPosition,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: context.heightPercentage(35),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                boxShadow: [BoxShadow(blurRadius: 20, color: Colors.black12)],
              ),
              child: Padding(
                padding: EdgeInsets.all(context.widthPercentage(6)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    SizedBox(height: context.heightPercentage(2)),
                    Text(
                      "Order #2502",
                      style: GoogleFonts.cabin(
                        fontSize: context.responsiveTextSize(14),
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      "On the way",
                      style: GoogleFonts.cabin(
                        fontSize: context.responsiveTextSize(24),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: context.heightPercentage(2)),
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 24,
                          backgroundImage: NetworkImage("https://ui-avatars.com/api/?name=Driver"),
                        ),
                        SizedBox(width: context.widthPercentage(4)),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "James Anderson",
                              style: GoogleFonts.cabin(
                                fontWeight: FontWeight.bold,
                                fontSize: context.responsiveTextSize(16),
                              ),
                            ),
                            Text(
                              "Delivery Partner",
                              style: GoogleFonts.cabin(
                                color: Colors.grey,
                                fontSize: context.responsiveTextSize(14),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xff50AD98),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.phone, color: Colors.white, size: 20),
                        ),
                      ],
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      height: context.hightForButton(56),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                        ),
                        child: Text(
                          "Contact Support",
                          style: GoogleFonts.cabin(
                            fontSize: context.responsiveTextSize(16),
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
