import 'package:flutter_sixvalley_ecommerce/features/cart/domain/models/cart_model.dart';

class CartHelper {
  double calculateVatTax(List<CartModel>? cartList,) {
    double taxAmount = 0;
    if (cartList != null) {
      for (CartModel cart in cartList) {
        if (cart.isChecked ?? false) {
          taxAmount += cart.appliedTax ?? 0;
          taxAmount += cart.shippingCostTax ?? 0;
        }
      }
    }
    return taxAmount;
  }

  bool hasPhysical(List<List<CartModel>> cartProductList) {
    for (CartModel cart in cartProductList[0]) {
      if (cart.productType == 'physical' && cart.isChecked!) {
        return true;
      }
    }
    return false;
  }
}
