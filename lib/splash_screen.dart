
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  final bool isLoggedIn;

  const SplashScreen({
    super.key,
    required this.isLoggedIn,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _checking = false;
  bool _dialogOpen = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        checkInternet();
      }
    });
  }

  Future<void> checkInternet() async {
    if (_checking || !mounted) return;

    _checking = true;
    bool connected = false;

    try {
      connected =
      await InternetConnection().hasInternetAccess;
    } catch (_) {
      connected = false;
    }

    _checking = false;

    if (!mounted) return;

    if (connected) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        ),
      );
    } else {
      showNoInternetAlert();
    }
  }

  Future<void> showNoInternetAlert() async {
    if (!mounted || _dialogOpen) return;

    _dialogOpen = true;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          icon: const Icon(
            Icons.wifi_off,
            color: Colors.red,
            size: 45,
          ),
          title: const Text('No Internet Connection'),
          content: const Text(
            'Please connect to the internet and try again.',
          ),
          actions: [
            TextButton(
              onPressed: () async {
                bool connected = false;

                try {
                  connected = await InternetConnection()
                      .hasInternetAccess;
                } catch (_) {
                  connected = false;
                }

                if (!dialogContext.mounted) return;

                if (connected) {
                  Navigator.pop(dialogContext);
                  _dialogOpen = false;
                  checkInternet();
                } else {
                  ScaffoldMessenger.of(dialogContext)
                      .showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Internet is still unavailable!',
                      ),
                    ),
                  );
                }
              },
              child: const Text('Retry'),
            ),
          ],
        );
      },
    );

    _dialogOpen = false;
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF7F0E8),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.local_cafe,
              size: 90,
              color: Colors.brown,
            ),
            SizedBox(height: 20),
            Text(
              'My Cafe',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
            SizedBox(height: 25),
            CircularProgressIndicator(
              color: Colors.brown,
            ),
          ],
        ),
      ),
    );
  }
}
