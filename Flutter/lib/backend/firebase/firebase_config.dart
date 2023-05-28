import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyAGlAFZNqHq1yPx7Rc0jJMmHoGJxDwTAEg",
            authDomain: "recycleright2.firebaseapp.com",
            projectId: "recycleright2",
            storageBucket: "recycleright2.appspot.com",
            messagingSenderId: "49337145189",
            appId: "1:49337145189:web:3c842f9a9a926d0737b38c"));
  } else {
    await Firebase.initializeApp();
  }
}
