
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
const LoginScreen({super.key});

@override
State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
final usernameController = TextEditingController();
final passwordController = TextEditingController();

Future<void> login() async {
String username = usernameController.text;
String password = passwordController.text;

if (username == "mycaffey@gmail.com" && password == "1234") {
final prefs = await SharedPreferences.getInstance();

await prefs.setBool('isLoggedIn', true);

if (!mounted) return;

Navigator.pushReplacement(
context,
MaterialPageRoute(
builder: (context) => const HomeScreen(),
),
);
} else {
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content: Text("Invalid username or password"),
),
);
}
}

@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: const Color(0xFFF5EDE3),

body: Center(
child: SingleChildScrollView(
padding: const EdgeInsets.all(25),

child: Column(
children: [
const Icon(
Icons.local_cafe,
size: 90,
color: Colors.brown,
),

const SizedBox(height: 15),

const Text(
"My Cafe",
style: TextStyle(
fontSize: 32,
fontWeight: FontWeight.bold,
color: Colors.brown,
),
),

const SizedBox(height: 40),

TextField(
controller: usernameController,
decoration: InputDecoration(
labelText: "Username",
prefixIcon: const Icon(Icons.email),

border: OutlineInputBorder(
borderRadius: BorderRadius.circular(12),
),
),
),

const SizedBox(height: 20),

TextField(
controller: passwordController,
obscureText: true,

decoration: InputDecoration(
labelText: "Password",
prefixIcon: const Icon(Icons.lock),

border: OutlineInputBorder(
borderRadius: BorderRadius.circular(12),
),
),
),

const SizedBox(height: 30),

SizedBox(
width: double.infinity,
height: 55,

child: ElevatedButton(
onPressed: login,

style: ElevatedButton.styleFrom(
backgroundColor: Colors.brown,
foregroundColor: Colors.white,

shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(12),
),
),

child: const Text(
"LOGIN",

style: TextStyle(
fontSize: 18,
fontWeight: FontWeight.bold,
),
),
),
),
],
),
),
),
);
}
}
