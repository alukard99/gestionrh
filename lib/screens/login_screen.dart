import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gestionrh/screens/home_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserCredential> signInWithGoogle() async {
    // Cierra la sesión actual antes de iniciar una nueva
    await _auth.signOut();
    await _googleSignIn.signOut();

    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    if (googleUser == null) {
      throw Exception('Google Sign In failed.');
    }

    final GoogleSignInAuthentication googleAuth =
    await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await _auth.signInWithCredential(credential);
  }

  Future<UserCredential> createUserWithGoogle() async {
    // Cierra la sesión actual antes de iniciar una nueva
    await _auth.signOut();
    await _googleSignIn.signOut();

    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    // Lanzar una excepción si Google SignIn falla
    if (googleUser == null) {
      throw Exception("Google Sign In failed.");
    }

    final GoogleSignInAuthentication? googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    final UserCredential userCredential = await _auth.signInWithCredential(credential);

    // Comprobar si el usuario ya existe en la colección "userAccounts"
    final userAccountsCollection = _firestore.collection('userAccounts');
    final userDoc = userAccountsCollection.doc(userCredential.user?.uid);
    final doc = await userDoc.get();

    if (doc.exists) {
      throw Exception('Usuario ya existente, inicia sesión');
    }

    // Si el usuario no existe, crear un nuevo documento en la colección "userAccounts"
    userDoc.set({
      'userId': userCredential.user?.uid,
      'name': userCredential.user?.displayName,
    });

    return userCredential;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                try {
                  await signInWithGoogle();
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(e.toString()),
                  ));
                }
              },
              child: Text(AppLocalizations.of(context)!.googleSignIn),
            ),
            SizedBox(height: 20),  // Espaciado
            ElevatedButton(
              onPressed: () async {
                try {
                  await createUserWithGoogle();
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(e.toString()),
                  ));
                }
              },
              child: Text('Crear cuenta con Google'),  // Puedes reemplazar este texto con una versión localizada
            ),
          ],
        ),
      ),
    );
  }
}