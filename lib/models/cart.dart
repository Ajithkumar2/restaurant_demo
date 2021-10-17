import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_demo/models/products_data.dart';

class Cart extends ChangeNotifier {
  HashMap<CategoryDish, int> cartItems = HashMap();
  List<CategoryDish> itemList = [];
  double price = 0.0;
  void add(CategoryDish categoryDish, int count) {
    itemList.add(categoryDish);
    price += categoryDish.dishPrice;
    cartItems[categoryDish] = count;
    notifyListeners();
  }

  int get count {
    return itemList.length;
  }

  int? dishCount(CategoryDish categoryDish) {
    return cartItems[categoryDish];
  }

  HashMap<CategoryDish, int> get allCartItems {
    return cartItems;
  }

  void removeCart(CategoryDish categoryDish) {
    itemList.remove(categoryDish);
    price = price - categoryDish.dishPrice;
    if (cartItems[categoryDish]! > 1) {
      int? coin = cartItems[categoryDish];
      cartItems[categoryDish] = coin! - 1;
    } else {
      cartItems.remove(categoryDish);
    }
    notifyListeners();
  }

  void decrementItem(CategoryDish categoryDish) {
    price = price - categoryDish.dishPrice;
    itemList.remove(categoryDish);
    notifyListeners();
  }

  void incrementItem(CategoryDish categoryDish) {
    price = price + categoryDish.dishPrice;
    itemList.add(categoryDish);
    notifyListeners();
  }

  void clearCart() {
    itemList.clear();
    cartItems.clear();
    price = 0;
  }

  double get totalPrice {
    return price;
  }
}
