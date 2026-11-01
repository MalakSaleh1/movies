import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movies/core/theme/app_colors/app_colors.dart';
import 'package:movies/modules/layout/view/main_layout.dart';
import 'package:movies/modules/onboarding/start_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 600),(){
      bool isLogin=FirebaseAuth.instance.currentUser!=null;
      if(isLogin){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MainLayout()));
      }
      else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>StartScreen()));
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: Image.asset("assets/logo/movies_logo.png",)),
            Image.asset("assets/logo/route.png",width: 180,height: 78,),
            Image.asset("assets/logo/Supervised by Mohamed Nabil.png",width: 244,height: 38,),

          ],
        ),
      ),
    ) ;
  }
}
