import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loftfin/models/loft_user.dart';
import 'package:loftfin/services/log_service.dart';
import 'package:loftfin/utils/app_settings.dart';

enum AuthStatus {
  notDetermined,
  notAuthenticated,
  verified,
  verificationFailed,
}

class FirebaseAuthHandler with ChangeNotifier {
  final FirebaseAuth auth;
  String? verificationId;

  FirebaseAuthHandler({required this.auth});

  AuthStatus authStatus = AuthStatus.notDetermined;
  String verificationError = '';

  bool isUserLoggedIn() {
    if (auth.currentUser == null) {
      listenAuthStateChanges();
      return false;
    } else {
      authStatus = AuthStatus.verified;
      return true;
    }
  }

  void listenAuthStateChanges() {
    dPrint('observing auth state changes...');
    auth.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');

        authStatus = AuthStatus.notAuthenticated;
        notifyListeners();
      } else {
        print('User is signed in!');
        if (authStatus != AuthStatus.verified) {
          authStatus = AuthStatus.verified;
          notifyListeners();
        }
      }
    });
  }

  Future<String?> getFirebaseToken() async {
    User? user = auth.currentUser;
    String token = await user!.getIdToken();
    return token;
  }

  String getUserId() {
    return auth.currentUser!.uid;
  }

  Future<void> signInUsingGoogle() async {
    UserCredential userCredential = await _signInWithGoogle();
    if (userCredential.user == null) {
      authStatus = AuthStatus.verificationFailed;
    } else {
      authStatus = AuthStatus.verified;
      print('User signed in - ${userCredential.user!.email}');
      print('User signed in - ${userCredential.user!.displayName}');

      AppSettings.instance.currentUser = LoftUser(
        userId: userCredential.user!.uid,
        firstName: userCredential.user!.displayName ?? '',
        lastName: '',
        email: userCredential.user!.email!,
        zipcode: '',
      );
    }
    notifyListeners();
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<UserCredential> _signInWithGoogle() async {
    if (kIsWeb) {
      GoogleAuthProvider googleProvider = GoogleAuthProvider();

      // googleProvider
      //     .addScope('https://www.googleapis.com/auth/contacts.readonly');
      googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithPopup(googleProvider);

      // Or use signInWithRedirect
      // return await FirebaseAuth.instance.signInWithRedirect(googleProvider);
    } else {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    }
  }

  Future<dynamic> logout() async {
    listenAuthStateChanges();
    try {
      try {
        if (!kIsWeb) {
          await _googleSignIn.signOut();
        }
        await auth.signOut().then(
          (value) {
            dPrint('google disconnect');
            //FirebaseAuth.instance.signOut();
            _googleSignIn.signOut();

            _googleSignIn.disconnect();
            authStatus = AuthStatus.notAuthenticated;
            notifyListeners();
          },
        );

        // disconnect google
        //await _signOut();
      } on FirebaseAuthException catch (e) {
        dPrint('Firebase auth exception - $e');
        authStatus = AuthStatus.notAuthenticated;
        notifyListeners();
      }
    } on SocketException {
      dPrint('No internet connection');
    }
  }

  Future<void> _signOut() async {
    await _googleSignIn.disconnect();
    await FirebaseAuth.instance.signOut();
    //await _firebaseAuth.signOut();
    //_googleSignIn.signOut();
    authStatus = AuthStatus.notAuthenticated;
    notifyListeners();
  }
}
