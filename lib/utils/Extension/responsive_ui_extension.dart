import 'package:flutter/material.dart';

extension PixelExtensions on BuildContext {
  // Get the pixel ratio
  double get pixelRatio =>
      MediaQuery.maybeOf(this)?.devicePixelRatio ?? View.of(this).devicePixelRatio;

  // Convert dp (device pixels) to logical pixels
  double toLogicalPixels(double dp) => dp / pixelRatio;

  // Get height in logical pixels
  double heightInPx(double px) => toLogicalPixels(px);

  // Get width in logical pixels
  double widthInPx(double px) => toLogicalPixels(px);
}

extension ResponsiveExtensions on BuildContext {
  // Define breakpoints
  static const double tabletWidthBreakpoint = 600.0;
  static const double largeMobileWidthBreakpoint = 392.0;
  static const double smallMobileWidthBreakpoint = 375.0;

  // Define reference heights
  static const double tabletHeightReference = 1366.0;
  static const double largeMobileHeightReference = 932.0;
  static const double smallMobileHeightReference = 667.0;

  // Get the screen height
  double get screenHeight {
    final mediaQuery = MediaQuery.maybeOf(this);
    if (mediaQuery != null) {
      return mediaQuery.size.height;
    }
    final view = View.maybeOf(this);
    if (view != null) {
      return view.physicalSize.height / view.devicePixelRatio;
    }
    // Fallback to a default height if both are null
    return 667.0;
  }

  // Get the screen width
  double get screenWidth {
    final mediaQuery = MediaQuery.maybeOf(this);
    if (mediaQuery != null) {
      return mediaQuery.size.width;
    }
    final view = View.maybeOf(this);
    if (view != null) {
      return view.physicalSize.width / view.devicePixelRatio;
    }
    // Fallback to a default width if both are null
    return 375.0;
  }

  // Get the screen's aspect ratio
  double get aspectRatio => screenWidth / screenHeight;

  // Determine if the device is a tablet
  bool get isTablet => screenWidth >= tabletWidthBreakpoint;

  // Determine if the device is a large mobile
  bool get isLargeMobile =>
      screenWidth >= largeMobileWidthBreakpoint && screenWidth < tabletWidthBreakpoint;

  // Determine if the device is a small mobile
  bool get isSmallMobile => screenWidth < largeMobileWidthBreakpoint;

  // Get height as a percentage of screen height
  double heightPercentage(double percentage, {double? height}) =>
      height ?? screenHeight * (percentage / 100);

  // Get width as a percentage of screen width
  double widthPercentage(double percentage, {double? width}) =>
      width ?? screenWidth * (percentage / 100);

  // Get height relative to a reference screen height
  double heightRelative(double height, {required double referenceHeight}) =>
      screenHeight * (height / referenceHeight);

  // Get width relative to a reference screen width
  double widthRelative(double width, {required double referenceWidth}) =>
      screenWidth * (width / referenceWidth);

  // Get height for different device types
  double heightForDevice(double height) {
    if (isTablet) {
      // Adjust for tablets
      return heightRelative(height, referenceHeight: tabletHeightReference);
    } else if (isLargeMobile) {
      // Adjust for large mobiles
      return heightRelative(height, referenceHeight: largeMobileHeightReference);
    } else {
      // Adjust for small mobiles
      return heightRelative(height, referenceHeight: smallMobileHeightReference);
    }
  }

  // Get width for different device types
  double widthForDevice(double width) {
    if (isTablet) {
      // Adjust for tablets
      return widthRelative(width, referenceWidth: tabletWidthBreakpoint);
    } else if (isLargeMobile) {
      // Adjust for large mobiles
      return widthRelative(width, referenceWidth: largeMobileWidthBreakpoint);
    } else {
      // Adjust for small mobiles
      return widthRelative(width, referenceWidth: smallMobileWidthBreakpoint);
    }
  }

  double buttonHight(double height, {required double referenceHight}) =>
      screenHeight * (height / referenceHight);
  double hightForButton(double hight) {
    if (isTablet) {
      // Adjust for tablets
      return buttonHight(hight, referenceHight: 1000);
    } else if (isLargeMobile) {
      // Adjust for large mobiles
      return buttonHight(hight, referenceHight: 850);
    } else {
      // Adjust for small mobiles
      return buttonHight(hight, referenceHight: 800);
    }
  }
}

extension ResponsiveText on BuildContext {
  // Get the screen width
  double get screenWidth {
    final mediaQuery = MediaQuery.maybeOf(this);
    if (mediaQuery != null) {
      return mediaQuery.size.width;
    }
    final view = View.maybeOf(this);
    if (view != null) {
      return view.physicalSize.width / view.devicePixelRatio;
    }
    // Fallback to a default width if both are null
    return 375.0;
  }

  // Get the screen height
  double get screenHeight {
    final mediaQuery = MediaQuery.maybeOf(this);
    if (mediaQuery != null) {
      return mediaQuery.size.height;
    }
    final view = View.maybeOf(this);
    if (view != null) {
      return view.physicalSize.height / view.devicePixelRatio;
    }
    // Fallback to a default height if both are null
    return 667.0;
  }

  // Adjust text size based on screen width with different scaling for tablets
  double responsiveTextSize(double size, {double referenceWidth = 375.0}) {
    double scale = screenWidth / referenceWidth;

    // Adjust the scale for tablets
    if (screenWidth >= 744.0) {
      // Example tablet breakpoint
      scale *= 0.7; // Decrease size by 20% for tablets
    }

    return size * scale;
  }
}
