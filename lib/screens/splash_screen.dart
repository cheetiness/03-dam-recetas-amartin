/* import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>{
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 4), (){
      Navigator.pushReplacement
      (context,
      MaterialPageRoute(builder: (context)=> const HomeScreen()));
    });
  } 
}

@override
Widget build(BuildContext context){
  return Scaffold(
      backgroundColor: Colors.white,
      body:Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant_menu, color: const Color.fromARGB(255, 243, 241, 240), size: 90,),
            SizedBox(height: 16),
            Text('Recetas App',
            style: TextStyle(color: const Color.fromARGB(255, 195, 194, 194), fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Sabores del Mayab',
            style: TextStyle(color: const Color.fromARGB(255, 194, 193, 193), fontSize: 13, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            CircularProgressIndicator(color: const Color.fromARGB(255, 193, 193, 192)
          )
        ],
      )
    )
  );
} */

import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: () => const HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant_menu, color: Colors.white, size: 90,),
            SizedBox(height: 16,),
            Text(
              'Recetas App',
              style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold,),
            ),
            SizedBox(height: 8),
            Text(
              'Sabores del Mayab',
              style: TextStyle(color: Colors.white70, fontSize: 13,),
            ),
            SizedBox(height: 16),
            CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}