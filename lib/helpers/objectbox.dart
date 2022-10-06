import 'package:newtook/models/customer.dart';
import 'package:newtook/models/order.dart';
import 'package:newtook/models/order_status.dart';
import 'package:newtook/models/terminals.dart';
import 'package:newtook/objectbox.g.dart';
import 'package:objectbox/objectbox.dart';

class ObjectBox {
  // ObjectBox
  late final Store _store;
  late final Box<OrderModel> _currentOrdersBox;
  late final Box<Customer> _customersBox;
  late final Box<OrderStatus> _orderStatusesBox;
  late final Box<Terminals> _terminalsBox;

  ObjectBox._init(this._store) {
    _currentOrdersBox = Box<OrderModel>(_store);
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

  void addCurrentOrders(List<OrderModel> orders) {
    _currentOrdersBox.putMany(orders);
  }

  Stream<List<OrderModel>> getCurrentOrders() {
    final builder = _currentOrdersBox.query()..order(OrderModel_.pre_distance);
    return builder.watch(triggerImmediately: true).map((query) {
      return query.find();
    });
  }
}
