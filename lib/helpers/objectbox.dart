import 'package:arryt/models/customer.dart';
import 'package:arryt/models/order.dart';
import 'package:arryt/models/order_status.dart';
import 'package:arryt/models/terminals.dart';
import 'package:arryt/objectbox.g.dart';
import 'package:objectbox/objectbox.dart';

import '../models/waiting_order.dart';

class ObjectBox {
  // ObjectBox
  late final Store _store;
  late final Box<OrderModel> _currentOrdersBox;
  late final Box<Customer> _customersBox;
  late final Box<WaitingOrderModel> _waitingOrdersBox;
  late final Box<OrderStatus> _orderStatusesBox;
  late final Box<Terminals> _terminalsBox;

  ObjectBox._init(this._store) {
    _currentOrdersBox = Box<OrderModel>(_store);
    _waitingOrdersBox = Box<WaitingOrderModel>(_store);
    _customersBox = Box<Customer>(_store);
    _orderStatusesBox = Box<OrderStatus>(_store);
    _terminalsBox = Box<Terminals>(_store);
  }

  ObjectBox._internal();

  // Init
  static Future<ObjectBox> init() async {
    // Get the directory where the database file will be stored
    final store = await openStore();
    return ObjectBox._init(store);
  }

  Future<void> clearCurrentOrders() {
    _currentOrdersBox.removeAll();
    return Future.value();
  }

  Future<void> clearWaitingOrders() {
    _waitingOrdersBox.removeAll();
    return Future.value();
  }

  void addCurrentOrders(List<OrderModel> orders) {
    _currentOrdersBox.putMany(orders);
  }

  void addWaitingOrders(List<WaitingOrderModel> orders) {
    _waitingOrdersBox.putMany(orders);
  }

  Stream<List<OrderModel>> getCurrentOrders() {
    final builder = _currentOrdersBox.query()..order(OrderModel_.created_at);
    return builder.watch(triggerImmediately: true).map((query) {
      return query.find();
    });
  }

  Stream<List<WaitingOrderModel>> getWaitingOrders() {
    final builder = _waitingOrdersBox.query()
      ..order(WaitingOrderModel_.created_at);
    return builder.watch(triggerImmediately: true).map((query) {
      return query.find();
    });
  }

  Future<void> deleteCurrentOrder(String identity) {
    final query =
        _currentOrdersBox.query(OrderModel_.identity.equals(identity)).build();
    query.remove();
    return Future.value();
  }

  Future<void> deleteWaitingOrder(String identity) {
    final query = _waitingOrdersBox
        .query(WaitingOrderModel_.identity.equals(identity))
        .build();
    query.remove();
    return Future.value();
  }

  Future<void> updateCurrentOrder(String identity, OrderModel order) {
    final query =
        _currentOrdersBox.query(OrderModel_.identity.equals(identity)).build();
    query.remove();

    if (order.orderStatus.target != null &&
        (!order.orderStatus.target!.cancel &&
            !order.orderStatus.target!.finish)) {
      _currentOrdersBox.put(order);
    }

    return Future.value();
  }
}
