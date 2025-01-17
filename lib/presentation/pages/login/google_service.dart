import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:vouchee/networking/api_request.dart';

class GoogleSignInService {
  static String token = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ApiServices postToken = ApiServices();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final ApiServices apiServices = ApiServices();
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print('no user');
        return null; // If the user cancels the login
      }

      // Obtain the Google Auth credentials
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase using the Google credentials
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      String? idToken = await userCredential.user?.getIdToken();
      log(idToken!);
      await _postToken(idToken);
      return userCredential.user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> _postToken(String accessToken) async {
    await apiServices.postToken(accessToken);
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}
