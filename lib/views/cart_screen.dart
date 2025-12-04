import 'package:flutter/material.dart';
import 'package:sandwich_shop/views/app_styles.dart';
import 'package:sandwich_shop/views/header.dart';
import 'package:sandwich_shop/views/order_screen.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';
import 'package:sandwich_shop/views/checkout_screen.dart';

class CartScreen extends StatefulWidget {
  final Cart cart;

  const CartScreen({super.key, required this.cart});

  @override
  State<CartScreen> createState() {
    return _CartScreenState();
  }
}

class _CartScreenState extends State<CartScreen> {
  void _goBack() {
    Navigator.pop(context);
  }

  Future<void> _navigateToCheckout() async {
    if (widget.cart.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your cart is empty'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckoutScreen(cart: widget.cart),
      ),
    );

    if (result != null && mounted) {
      setState(() {
        widget.cart.clear();
      });

      final String orderId = result['orderId'] as String;
      final String estimatedTime = result['estimatedTime'] as String;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Order $orderId confirmed! Estimated time: $estimatedTime'),
          duration: const Duration(seconds: 4),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    }
  }

  String _getSizeText(bool isFootlong) {
    if (isFootlong) {
      return 'Footlong';
    } else {
      return 'Six-inch';
    }
  }

  double _getItemPrice(Sandwich sandwich, int quantity) {
    final PricingRepository pricingRepository = PricingRepository();
    return pricingRepository.calculatePrice(
      quantity: quantity,
      isFootlong: sandwich.isFootlong,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isWide = MediaQuery.of(context).size.width >= 600;
    final Map<String, String> routeLabels = {
      '/': 'Home',
      '/about': 'About',
      '/login': 'Account',
    };

    final Widget content = Center(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            if (widget.cart.isEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    Icon(Icons.shopping_cart_outlined,
                        size: 72, color: Colors.grey[600]),
                    const SizedBox(height: 12),
                    const Text(
                      'Your cart is empty',
                      style: heading2,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Add sandwiches from the order screen before checking out.',
                      style: normalText,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    StyledButton(
                      onPressed: _goBack,
                      icon: Icons.arrow_back,
                      label: 'Back to Order',
                      backgroundColor: Colors.grey,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ] else ...[
              for (MapEntry<Sandwich, int> entry in widget.cart.items.entries)
                Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(entry.key.name, style: heading2),
                              Text(
                                '${_getSizeText(entry.key.isFootlong)} on ${entry.key.breadType.name} bread',
                                style: normalText,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Qty: ${entry.value} - £${_getItemPrice(entry.key, entry.value).toStringAsFixed(2)}',
                                style: normalText,
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  widget.cart.remove(entry.key);
                                });
                              },
                              icon: const Icon(Icons.remove_circle_outline),
                            ),
                            Text('${entry.value}', style: heading2),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  widget.cart.add(entry.key);
                                });
                              },
                              icon: const Icon(Icons.add_circle_outline),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  widget.cart.setQuantity(entry.key, 0);
                                });
                              },
                              icon: const Icon(Icons.delete_outline),
                              tooltip: 'Remove item',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 12),
              Text(
                'Total: £${widget.cart.totalPrice.toStringAsFixed(2)}',
                style: heading2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Builder(
                builder: (BuildContext context) {
                  final bool cartHasItems = widget.cart.items.isNotEmpty;
                  if (cartHasItems) {
                    return StyledButton(
                      onPressed: _navigateToCheckout,
                      icon: Icons.payment,
                      label: 'Checkout',
                      backgroundColor: Colors.orange,
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
              const SizedBox(height: 20),
              StyledButton(
                onPressed: _goBack,
                icon: Icons.arrow_back,
                label: 'Back to Order',
                backgroundColor: Colors.grey,
              ),
              const SizedBox(height: 20),
            ],
          ],
        ),
      ),
    );

    return Scaffold(
      appBar: Header.buildAppBar(context, title: 'Cart View'),
      drawer:
          isWide ? null : Header.buildDrawer(context, routeLabels: routeLabels),
      body: isWide
          ? Row(
              children: [
                Header.buildSideNav(context, routeLabels: routeLabels),
                Expanded(child: content),
              ],
            )
          : content,
    );
  }
}
