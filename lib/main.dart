import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_e_shop/providers/user_provider.dart';
import 'package:firebase_e_shop/screens/Authentication/authentication.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_e_shop/responsive/mobile_screen_layout.dart';
import 'package:firebase_e_shop/responsive/responsive_layout.dart';
import 'package:firebase_e_shop/responsive/web_screen_layout.dart';
import 'package:firebase_e_shop/utils/colors.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // initialise app based on platform- web or mobile
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyDexHNihTcuAIxPPWHQNCBWdz1KBszyPAw",
          authDomain: "flutter-sns-udemy.firebaseapp.com",
          projectId: "flutter-sns-udemy",
          storageBucket: "flutter-sns-udemy.appspot.com",
          messagingSenderId: "167564632543",
          appId: "1:167564632543:web:f94602ed61b8e65325246a",
          measurementId: "G-3QHPXLC0VY"),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'E Shop',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              print("1");
              // Checking if the snapshot has any data or not (スナップショットがデータを持っている場合)
              if (snapshot.hasData) {
                print("2");
                // if snapshot has data which means user is logged in then we check the width of screen and accordingly display the screen layout
                return const ResponsiveLayout(
                  mobileScreenLayout: MobileScreenLayout(),
                  webScreenLayout: WebScreenLayout(),
                );
              } else if (snapshot.hasError) {
                print("3");
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }
            print("4");
            // means connection to future hasnt been made yet
            if (snapshot.connectionState == ConnectionState.waiting) {
              print("5");
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            print("6");
            return const AuthenticScreen();
          },
        ),
      ),
    );
  }
}
