import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'core/di/app_dependencies.dart';



import 'app.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GoogleSignIn.instance.initialize(
    serverClientId:
        "539197071852-miqpd5h6klr25bfvtboc2t67pr374j45.apps.googleusercontent.com",
  );

  final providers = await AppDependencies.providers();

  runApp(
    MultiProvider(
      providers: providers,
      child: const MyApp(),
    ),
  );
}
