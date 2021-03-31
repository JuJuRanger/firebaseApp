import 'package:firebaseApp/res/color.dart';
import 'package:firebaseApp/route/routes.dart';
import 'package:firebaseApp/screen/home_screen.dart';
import 'package:firebaseApp/screen/login_screen.dart';
import 'package:firebaseApp/service/firebase/firebase_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  // กำหนดให้รองรับการอ่าน api ผ่าน https
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // กำหนดให้แสดงผลเฉพาะแนวตั้งเท่านั้น
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // สั่งให้ app แสดงผลเต็มหน้าจอ
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: colorPrimaryDark,
    systemNavigationBarColor: colorPrimaryDark,
  ));
  runApp(StreamProvider(
    create: (context) => FirebaseAuthService.firebaseListener,
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      // title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: GoogleFonts.kanitTextTheme(),
        primaryColorDark: colorPrimaryDark,
        accentColor: colorPrimaryDark,
        primaryColor: colorPrimary,
      ),
      onGenerateRoute: Routes.generateRoute,
      // home: MyApp(),
    ),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider.of<User>(context) == null ? LoginScreen() : HomeScreen();
  }
}
