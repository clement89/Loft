import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loftfin/providers/firebase_auth.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockFirebaseUser extends Mock implements User {}

class MockPhoneAuthCredential extends Mock implements PhoneAuthCredential {}

class MockAuthResult extends Mock implements UserCredential {}

void main() {
  MockFirebaseAuth _auth = MockFirebaseAuth();
  BehaviorSubject<MockFirebaseUser> _user = BehaviorSubject<MockFirebaseUser>();
  MockPhoneAuthCredential _phoneAuthCredential = MockPhoneAuthCredential();
  MockAuthResult _authResult = MockAuthResult();
  FirebaseAuthHandler _authHandler = FirebaseAuthHandler(auth: _auth);
  when(_auth.authStateChanges()).thenAnswer((realInvocation) {
    return _user;
  });
  group('firebase auth test', () {
    when(
      _auth.verifyPhoneNumber(
        phoneNumber: '123',
        verificationCompleted: (PhoneAuthCredential authCredential) async {},
        verificationFailed: (FirebaseAuthException exception) {},
        codeSent: (String verificationId, int? forceResendingToken) {},
        codeAutoRetrievalTimeout: (String timeout) {},
      ),
    );

    when(_auth.signInWithCredential(_phoneAuthCredential))
        .thenAnswer((realInvocation) async {
      _user.add(MockFirebaseUser());
      return _authResult;
    });

    test('signIn with phone number', () async {});
  });
}
