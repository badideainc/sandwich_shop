import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

class Cart {
  List<Sandwich> sandwiches = [];
  final PricingRepository _pricingRepository = PricingRepository();

  // Total price computed via the price repository
  double get total => sandwiches.fold(
      0.0,
      (total, sandwich) =>
          total +
          _pricingRepository.calculatePrice(
              quantity: 1, isFootlong: sandwich.isFootlong));

  int get count => sandwiches.length;

  void add(Sandwich sandwich, {int quantity = 1}) {
    if (quantity <= 0) return;
    for (var i = 0; i < quantity; i++) {
      sandwiches.add(Sandwich(
        type: sandwich.type,
        isFootlong: sandwich.isFootlong,
        breadType: sandwich.breadType,
      ));
    }
  }

  bool remove(Sandwich sandwich) => sandwiches.remove(sandwich);

  void clear() => sandwiches.clear();
}
