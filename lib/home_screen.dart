import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bill_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime? lastBackPressTime;

  // Track quantities for each item
  final Map<String, int> quantities = {};
  // Track selection status for each item
  final Map<String, bool> selectedItems = {};

  // ================= MEALS =================

  final List<Map<String, dynamic>> meals = [
    {
      "name": "Cheese Burger",
      "price": 180,
      "image":
          "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=300&q=80",
    },
    {
      "name": "Margherita Pizza",
      "price": 220,
      "image":
          "https://images.unsplash.com/photo-1574071318508-1cdbab80d002?auto=format&fit=crop&w=300&q=80",
    },
    {
      "name": "Veg Sandwich",
      "price": 140,
      "image":
          "https://images.unsplash.com/photo-1528735602780-2552fd46c7af?auto=format&fit=crop&w=300&q=80",
    },
    {
      "name": "French Fries",
      "price": 100,
      "image":
          "https://images.unsplash.com/photo-1573080496219-bb080dd4f877?auto=format&fit=crop&w=300&q=80",
    },
    {
      "name": "Cold Coffee",
      "price": 150,
      "image":
          "https://cdn.loveandlemons.com/wp-content/uploads/2025/05/iced-coffee.jpg",
    },
    {
      "name": "Masala Maggi",
      "price": 120,
      "image":
          "https://images.unsplash.com/photo-1569718212165-3a8278d5f624?auto=format&fit=crop&w=300&q=80",
    },
    {
      "name": "Veg Cheese Roll",
      "price": 160,
      "image":
          "https://images.unsplash.com/photo-1626700051175-6818013e1d4f?auto=format&fit=crop&w=300&q=80",
    },
    {
      "name": "Paneer Wrap",
      "price": 190,
      "image":
          "https://images.unsplash.com/photo-1626700051175-6818013e1d4f?auto=format&fit=crop&w=300&q=80",
    },
    {
      "name": "Chocolate Cake",
      "price": 170,
      "image":
          "https://images.unsplash.com/photo-1578985545062-69928b1d9587?auto=format&fit=crop&w=300&q=80",
    },
    {
      "name": "Garlic Bread",
      "price": 130,
      "image":
          "https://tse4.mm.bing.net/th/id/OIP.3eilmX3983CsAQ44gy5nhQHaHa?r=0&pid=Api&h=220&P=0",
    },
  ];

  // ================= COMBOS =================

  final List<Map<String, dynamic>> combos = [
    {
      "name": "Burger + Fries",
      "price": 250,
      "image":
          "https://images.unsplash.com/photo-1572802419224-296b0aeee0d9?auto=format&fit=crop&w=300&q=80",
    },
    {
      "name": "Pizza + Cold Drink",
      "price": 300,
      "image":
          "https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?auto=format&fit=crop&w=300&q=80",
    },
    {
      "name": "Sandwich + Coffee",
      "price": 260,
      "image":
          "https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?auto=format&fit=crop&w=300&q=80",
    },
    {
      "name": "Burger + Cold Coffee",
      "price": 300,
      "image":
          "https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=300&q=80",
    },
    {
      "name": "Pizza + Garlic Bread",
      "price": 330,
      "image":
          "https://images.unsplash.com/photo-1574071318508-1cdbab80d002?auto=format&fit=crop&w=300&q=80",
    },
    {
      "name": "Maggi + Cold Coffee",
      "price": 240,
      "image":
          "https://images.unsplash.com/photo-1569718212165-3a8278d5f624?auto=format&fit=crop&w=300&q=80",
    },
    {
      "name": "Paneer Wrap + Fries",
      "price": 270,
      "image":
          "https://images.unsplash.com/photo-1626700051175-6818013e1d4f?auto=format&fit=crop&w=300&q=80",
    },
    {
      "name": "Cake + Cold Coffee",
      "price": 290,
      "image":
          "https://images.unsplash.com/photo-1578985545062-69928b1d9587?auto=format&fit=crop&w=300&q=80",
    },
    {
      "name": "Burger + Pizza",
      "price": 380,
      "image":
          "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=300&q=80",
    },
    {
      "name": "Family Snack Combo",
      "price": 450,
      "image":
          "https://images.unsplash.com/photo-1547592180-85f173990554?auto=format&fit=crop&w=300&q=80",
    },
  ];

  // ================= TOTAL PRICE =================

  int get totalPrice {
    int total = 0;
    for (var item in [...meals, ...combos]) {
      String name = item["name"];
      bool isSelected = selectedItems[name] ?? false;
      if (isSelected) {
        int qty = quantities[name] ?? 1;
        total += (item["price"] as int) * qty;
      }
    }
    return total;
  }

  // ================= LOGOUT =================

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("isLoggedIn");
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
      (route) => false,
    );
  }

  // ================= DOUBLE BACK EXIT =================

  Future<void> handleBackButton() async {
    final now = DateTime.now();
    if (lastBackPressTime == null ||
        now.difference(lastBackPressTime!) > const Duration(seconds: 2)) {
      lastBackPressTime = now;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Press back again to exit"),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    await SystemNavigator.pop();
  }

  // ================= PRODUCT CARD =================

  Widget productCard(Map<String, dynamic> item) {
    String name = item["name"];
    int price = item["price"];
    String image = item["image"];
    int qty = quantities[name] ?? 1;
    bool isSelected = selectedItems[name] ?? false;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            // CHECKBOX
            Checkbox(
              value: isSelected,
              activeColor: Colors.brown,
              onChanged: (value) {
                setState(() {
                  selectedItems[name] = value ?? false;
                  if (value == true && (quantities[name] ?? 0) == 0) {
                    quantities[name] = 1;
                  }
                });
              },
            ),

            // IMAGE
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                image,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 70,
                    height: 70,
                    color: Colors.brown.shade100,
                    child: const Icon(Icons.fastfood, color: Colors.brown),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),

            // NAME + PRICE
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "₹$price",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                  ),
                ],
              ),
            ),

            // QUANTITY CONTROLS (Only show if selected)
            if (isSelected)
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if (qty > 1) {
                        setState(() {
                          quantities[name] = qty - 1;
                        });
                      }
                    },
                    icon: const Icon(Icons.remove_circle_outline, size: 20),
                    color: Colors.brown,
                  ),
                  Text(
                    "$qty",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        quantities[name] = qty + 1;
                      });
                    },
                    icon: const Icon(Icons.add_circle_outline, size: 20),
                    color: Colors.brown,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  // ================= BUILD =================

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        handleBackButton();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F5F0),
        appBar: AppBar(
          backgroundColor: Colors.brown,
          foregroundColor: Colors.white,
          title: const Text(
            "My Cafe",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              onPressed: logout,
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome to My Cafe ☕",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Select items and set quantity",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ),

              // MEALS
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  "🍔 Meals",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ...meals.map((item) => productCard(item)),

              const SizedBox(height: 20),

              // COMBOS
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  "🔥 Combos",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ...combos.map((item) => productCard(item)),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Total Amount",
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    Text(
                      "₹$totalPrice",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (totalPrice == 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please select at least one item")),
                    );
                  } else {
                    List<Map<String, dynamic>> finalItems = [];
                    for (var item in [...meals, ...combos]) {
                      String name = item["name"];
                      if (selectedItems[name] == true) {
                        finalItems.add({
                          "name": name,
                          "price": item["price"],
                          "quantity": quantities[name] ?? 1,
                        });
                      }
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BillScreen(
                          selectedItems: finalItems,
                          totalAmount: totalPrice,
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  "ORDER",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
