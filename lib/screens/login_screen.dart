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
    await _googleSignIn.signOut(); // Asegura que la sesión previa (si existe) se cierre
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    final UserCredential userCredential = await _auth.signInWithCredential(credential);

    final QuerySnapshot result = await _firestore
        .collection('empleados')
        .where('userId', isEqualTo: userCredential.user?.uid)
        .get();

    final List<DocumentSnapshot> documents = result.docs;
    if (documents.length == 0) {
      // Si el usuario no está en la colección 'empleados', cerramos la sesión
      await _auth.signOut();
      throw Exception(AppLocalizations.of(context)!.userNotInColection);
    }

    return userCredential;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            try {
              await signInWithGoogle();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
            } catch (e) {
              // Mostrar el error en pantalla
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(e.toString()),
              ));
            }
          },
          child: Text(AppLocalizations.of(context)!.googleSignIn),
        ),
      ),
    );
  }
}