import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'dart:io' show Platform;
import '../models/user_profile.dart';
import 'user_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserService _userService = UserService();
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
    serverClientId: '1007589703352-ifqmuossng5l6posq36nvudpqpebns31.apps.googleusercontent.com',
  );

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign up with email and password
  Future<User?> signUpWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      // Create user with email and password
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user != null) {
        // Update display name if provided
        if (displayName != null && displayName.isNotEmpty) {
          await user.updateDisplayName(displayName);
          await user.reload();
        }

        // Create user profile in Firestore
        final now = DateTime.now();
        final userProfile = UserProfile(
          uid: user.uid,
          email: email,
          displayName: displayName,
          createdAt: now,
          updatedAt: now,
        );
        await _userService.createUserProfile(userProfile);
      }

      return user;
    } catch (e) {
      print('Error signing up: $e');
      rethrow;
    }
  }

  // Sign in with email and password
  Future<User?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('Error signing in: $e');
      rethrow;
    }
  }

  // Sign in with Google
  Future<User?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User canceled the sign-in
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      final user = userCredential.user;

      // Create user profile if it doesn't exist
      if (user != null) {
        final existingProfile = await _userService.getUserProfile(user.uid);
        if (existingProfile == null) {
          final now = DateTime.now();
          final userProfile = UserProfile(
            uid: user.uid,
            email: user.email ?? '',
            displayName: user.displayName,
            photoURL: user.photoURL,
            createdAt: now,
            updatedAt: now,
          );
          await _userService.createUserProfile(userProfile);
        }
      }

      return user;
    } catch (e) {
      print('Error signing in with Google: $e');
      rethrow;
    }
  }

  // Sign in with Apple
  Future<User?> signInWithApple() async {
    try {
      // Check if Apple Sign In is available (iOS 13+, macOS 10.15+)
      if (!Platform.isIOS && !Platform.isMacOS) {
        throw Exception('Apple Sign In is only available on iOS and macOS');
      }

      // Request credential for the currently signed in Apple account
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // Create an OAuthCredential from the credential returned by Apple
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      // Sign in to Firebase with the Apple credential
      final UserCredential userCredential =
          await _auth.signInWithCredential(oauthCredential);

      final user = userCredential.user;

      // Update display name if available from Apple
      String? displayName;
      if (user != null &&
          appleCredential.givenName != null &&
          appleCredential.familyName != null) {
        displayName =
            '${appleCredential.givenName} ${appleCredential.familyName}';
        await user.updateDisplayName(displayName);
      }

      // Create user profile if it doesn't exist
      if (user != null) {
        final existingProfile = await _userService.getUserProfile(user.uid);
        if (existingProfile == null) {
          final now = DateTime.now();
          final userProfile = UserProfile(
            uid: user.uid,
            email: user.email ?? '',
            displayName: displayName ?? user.displayName,
            photoURL: user.photoURL,
            createdAt: now,
            updatedAt: now,
          );
          await _userService.createUserProfile(userProfile);
        }
      }

      return user;
    } catch (e) {
      print('Error signing in with Apple: $e');
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (e) {
      print('Error signing out: $e');
      rethrow;
    }
  }

  // Check if user is signed in
  bool isSignedIn() {
    return _auth.currentUser != null;
  }

  // Get user display name
  String? getUserDisplayName() {
    return _auth.currentUser?.displayName;
  }

  // Get user email
  String? getUserEmail() {
    return _auth.currentUser?.email;
  }

  // Get user photo URL
  String? getUserPhotoUrl() {
    return _auth.currentUser?.photoURL;
  }
}
