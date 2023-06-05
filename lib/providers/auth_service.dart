import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService { //Se encarga de autenticar al usuario desde la login_screen
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Getter público para _auth
  FirebaseAuth get auth => _auth;
  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    if (googleUser == null) {
      throw Exception('Google login error');
    }

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await _auth.signInWithCredential(credential);
  }

  // signOut
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  // getCurrentUser
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // checkUserRole
  Future<String> checkUserRole(String userId) async {
    DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();

    if (userDoc.exists) {
      return userDoc['role'];
    } else {
      throw Exception('Rol verification error');
    }
  }
}