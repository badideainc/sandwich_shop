import 'package:flutter/material.dart';
import 'package:sandwich_shop/models/cart.dart';

class CartScreen extends StatefulWidget {
  final Cart cart;

  const CartScreen({super.key, required this.cart});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.cart.count,
              itemBuilder: (context, index) {
                final sandwich = widget.cart.sandwiches[index];
                return ListTile(
                  title: Text(sandwich.name),
                  subtitle: Text('${sandwich.size} ${sandwich.breadType.name} Bread'),
                );
              },
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Total: £${widget.cart.total.toStringAsFixed(2)}',// Placeholder for total price
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
