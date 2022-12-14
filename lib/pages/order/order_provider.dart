import 'package:flutter/material.dart';

import '../../models/order_model.dart';
import '../../models/orders_model.dart';
import '../../models/product_model.dart';


class OrderProvider extends ChangeNotifier {
  OrdersModel orders = OrdersModel(id: "01", orders: [], createTime: "", total: 0.0);
  int orderNumber = 0;

  void addToCart(Product product, {int quantity = 1}) {
    double total = product.discount == null ? (quantity *  product.price).toDouble() : (quantity *  (product.price - product.price * product.discount!)).toDouble();
    Order order = Order(product: product, quantity: quantity, total: total);
    if(orders.orders.isNotEmpty) {
      orders.orders.add(order);
      orders.updateTime = DateTime.now().toString();
      orders.total += order.total;
    } else {
      orders = OrdersModel(id: "01", orders: [order], createTime: DateTime.now().toString(), total: order.total);
    }

    orderNumber = orders.orders.length;
    notifyListeners();
  }

  void removeToCart(Product product, {int quantity = 1}) {
    double total = product.discount == null ? (quantity *  product.price).toDouble() : (quantity *  (product.price - product.price * product.discount!)).toDouble();
    Order order = Order(product: product, quantity: quantity, total: total);
    orders.orders.remove(order);
    orders.updateTime = DateTime.now().toString();
    orders.total -= order.total;

    orderNumber = orders.orders.length;
    notifyListeners();
  }

  bool checkProduct(Product product) {
    if(orders.orders.isEmpty) return false;

    var list = orders.orders.where((order) => order.product.id == product.id).toList();

    return list.isNotEmpty;
  }

  Order getOrder(Product product) {
    if(orders.orders.isEmpty) return Order(product: product, total: 0.0, quantity: 0);
    Order order = orders.orders.firstWhere((order) => order.product.id == product.id);
    return order;
  }

  void plus(Order order) {
    order.quantity++;
    order.total += order.product.discount == null ? order.product.price : (order.product.price - order.product.price * order.product.discount!);
    orders.total += order.product.discount == null ? order.product.price : (order.product.price - order.product.price * order.product.discount!);
    int index = orders.orders.indexOf(order);
    if(index != -1) {
      orders.orders[index] = order;
    } else {
      orders.orders.add(order);
      orderNumber = orders.orders.length;
    }
    notifyListeners();
  }

  void minus(Order order) {
    if(order.quantity == 1) {
      removeToCart(order.product);
      orderNumber = orders.orders.length;
      notifyListeners();
    } else if(order.quantity > 1) {
      order.quantity--;
      order.total -= order.product.discount == null ? order.product.price : (order.product.price - order.product.price * order.product.discount!);
      orders.total -= order.product.discount == null ? order.product.price : (order.product.price - order.product.price * order.product.discount!);
      int index = orders.orders.indexOf(order);
      orders.orders[index] = order;
      notifyListeners();
    }
  }
}