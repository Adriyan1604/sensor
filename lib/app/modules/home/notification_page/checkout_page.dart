// lib/checkout_page.dart
import 'package:flutter/material.dart';

class CheckoutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Checkout"),
      ),
      body: Center(
        child: Text("Proceed with your checkout!"),
      ),
    );
  }
}