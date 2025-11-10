import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

class Cart {
  List<Sandwich> sandwiches = [];
  final PricingRepository _pricingRepository = PricingRepository();

  // Total price computed via the price repository
  double get total => _pricingRepository.calculatePrice(
        quantity: count,
        isFootlong: sandwiches.isNotEmpty ? sandwiches[0].isFootlong : false,
      );

  int get count => sandwiches.length;

  void add(Sandwich sandwich) => sandwiches.add(sandwich);

  bool remove(Sandwich sandwich) => sandwiches.remove(sandwich);

  void clear() => sandwiches.clear();
}
