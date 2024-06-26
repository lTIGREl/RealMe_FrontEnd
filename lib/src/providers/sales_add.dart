import 'package:flutter/cupertino.dart';

class SelectedItemSale with ChangeNotifier {
  String _product = 'Diario';
  String _mode = 'Efectivo';
  int _quantity = 1;
  String _costumer = '';
  DateTime _date = DateTime.now();
  //DateFormat('yyyy-MM-dd', 'es_MX').format(DateTime.now());

  DateTime get date => _date;

  set date(DateTime date) {
    _date = date;
    notifyListeners();
  }

  String get mode => _mode;

  set mode(String modality) {
    _mode = modality;
    notifyListeners();
  }

  String get costumer => _costumer;
  set costumer(String costumer) {
    _costumer = costumer;
    notifyListeners();
  }

  int get quantity => _quantity;

  set quantity(int cantidad) {
    if (cantidad <= 0) {
      cantidad = 1;
    }
    _quantity = cantidad;
    notifyListeners();
  }

  String get product => _product;

  set product(String producto) {
    _product = producto;
    notifyListeners();
  }
}
