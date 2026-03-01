import 'package:flutter/material.dart';

// Adicionámos o 'with ChangeNotifier' para que o Flutter possa "ouvir" esta classe
class CartService with ChangeNotifier {
  // Configuração Singleton para manter o mesmo carrinho em todo o app
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  final List<Map<String, dynamic>> _items = [];

  List<Map<String, dynamic>> get items => _items;

  // Retorna a quantidade total de itens diferentes no carrinho
  int get count => _items.length;

  // Calcula o valor total somando os subtotais de cada pedra
  double get total =>
      _items.fold(0, (sum, item) => sum + (item['sub_Total'] ?? 0));

  void addToCart(Map<String, dynamic> product) {
    // Verifica se a pedra já existe no carrinho
    final index = _items.indexWhere((item) => item['id'] == product['id']);

    if (index >= 0) {
      // Se já existe, apenas aumenta a quantidade (m²)
      _items[index]['qty']++;
      _items[index]['sub_Total'] =
          _items[index]['qty'] * (_items[index]['price'] ?? 0);
    } else {
      // Se é nova, adiciona à lista com quantidade inicial 1
      _items.add({...product, 'qty': 1, 'sub_Total': product['price']});
    }

    // ESTA LINHA É ESSENCIAL: Avisa a MainNavigation para atualizar o badge vermelho
    notifyListeners();
  }

  void removeFromCart(int id) {
    _items.removeWhere((item) => item['id'] == id);
    // Avisa que o item foi removido para atualizar o contador
    notifyListeners();
  }

  void incrementQty(int id) {
    final index = _items.indexWhere((item) => item['id'] == id);
    if (index >= 0) {
      _items[index]['qty']++;
      _items[index]['sub_Total'] =
          _items[index]['qty'] * (_items[index]['price'] ?? 0);
      notifyListeners();
    }
  }

  void decrementQty(int id) {
    final index = _items.indexWhere((item) => item['id'] == id);
    if (index >= 0) {
      if (_items[index]['qty'] > 1) {
        _items[index]['qty']--;
        _items[index]['sub_Total'] =
            _items[index]['qty'] * (_items[index]['price'] ?? 0);
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
