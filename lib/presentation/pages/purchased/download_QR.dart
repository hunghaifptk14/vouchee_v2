// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:vouchee/presentation/pages/login/login.dart';

class QRDownloadPage extends StatefulWidget {
  const QRDownloadPage({super.key});

  @override
  _QRDownloadPageState createState() => _QRDownloadPageState();
}

class _QRDownloadPageState extends State<QRDownloadPage> {
  final GlobalKey _repaintKey = GlobalKey();

  // Method to capture the widget as an image

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Download QR Code'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RepaintBoundary(
              key: _repaintKey, // Assign the key to the boundary
              child: Container(
                height: 250,
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Center(
                  child: QrImageView(
                    data: 'https://example.com', // Example QR Code Data
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            IconButton(
              onPressed: () async {
                await GoogleSignIn().signOut();
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => LoginPage()));
              },
              icon: Icon(Icons.logout),
            ),
            Text('Đăng xuất')
          ],
        ),
      ),
    );
  }
}

class ImageGallerySaver {}
