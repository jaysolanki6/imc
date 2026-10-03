
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_screen.dart';
import 'home_screen.dart';

void main() async {
WidgetsFlutterBinding.ensureInitialized();

final prefs = await SharedPreferences.getInstance();
final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

runApp(
MyCafeApp(
isLoggedIn: isLoggedIn,
),
);
}

class MyCafeApp extends StatelessWidget {
final bool isLoggedIn;

const MyCafeApp({
super.key,
required this.isLoggedIn,
});

@override
Widget build(BuildContext context) {
return MaterialApp(
debugShowCheckedModeBanner: false,
title: 'My Cafe2',

home: isLoggedIn
? const HomeScreen()
    : const LoginScreen(),
);
}
}
