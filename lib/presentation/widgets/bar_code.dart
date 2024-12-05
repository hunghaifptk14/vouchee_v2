// import 'dart:io';

// import 'package:barcode/barcode.dart';

// buildBarcode(
//   Barcode bc,
//   String data, {
//   String? filename,
//   double? width,
//   double? height,
//   double? fontHeight,
// }) {
//   /// Create the Barcode
//   final svg = bc.toSvg(
//     data,
//     width: width ?? 200,
//     height: height ?? 80,
//     fontHeight: fontHeight,
//   );

//   // Save the image
//   filename ??= bc.name.replaceAll(RegExp(r'\s'), '-').toLowerCase();
//   File('$filename.svg').writeAsStringSync(svg);
// }
