import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';

class _FirebaseUser extends Fake implements User {
  _FirebaseUser(this.uid);
  @override
  final String uid;
}

class FakeFirebaseAuth extends Fake implements FirebaseAuth {
  final changes = StreamController<User?>.broadcast(sync: true);
  @override
  User? currentUser;
  void signInAs(String? uid) {
    currentUser = uid == null ? null : _FirebaseUser(uid);
    changes.add(currentUser);
  }

  @override
  Stream<User?> authStateChanges() => changes.stream;
}
