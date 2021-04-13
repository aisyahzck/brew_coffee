import 'package:brew_coffee/models/user.dart';
import 'package:brew_coffee/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService{

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user object based on UserCredential
  TheUser _userFromFirebaseUser(User user) {
    return user != null ? TheUser(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<TheUser> get user {
    return _auth.authStateChanges()
      .map(_userFromFirebaseUser);
  }


  // sign in anonymously
    Future signInAnon() async {
      try {
        UserCredential result = await _auth.signInAnonymously();
        User user = result.user;
        return _userFromFirebaseUser(user);
      } catch (e) {
        print(e.toString());
        return null;
      }
    }

    // sign in with email & password
    Future signInWithEmailAndPassword(String email, String pw) async {
      try{
       UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: pw);
       User user = result.user;
       return user;
     }catch(e){
        print(e.toString());
        return null;
     }
    }


    // register with email & password
    Future registerWithEmailAndPassword(String email, String pw) async {
      try{
        UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: pw);
        User  user = result.user;
        // create a new document for the user with the uid
        await DatabaseService(uid: user.uid).updateUserData('0', 'New Crew Member', 100);
        return _userFromFirebaseUser(user);
      }catch(e){
        print(e.toString());
        return null;
      }
    }


    //sign out
    Future signOut() async {
      try {
        return await _auth.signOut();
      } catch(e){
          print(e.toString());
          return null;
      }
    }
}