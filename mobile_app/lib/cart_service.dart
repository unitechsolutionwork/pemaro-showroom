// lib/cart_service.dart

class CartService {
  // Padrão Singleton (Para existir apenas UM carrinho no app inteiro)
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  // A lista de produtos no carrinho
  final List<Map<String, dynamic>> _items = [];

  // 1. Obter itens
  List<Map<String, dynamic>> get items => _items;

  // 2. Adicionar Produto
  void addToCart(Map<String, dynamic> product) {
    // Verifica se o produto já existe no carrinho
    final index = _items.indexWhere((item) => item['id'] == product['id']);

    if (index >= 0) {
      // Se já existe, só aumenta a quantidade
      _items[index]['qty'] += 1;
    } else {
      // Se não existe, adiciona novo com quantidade 1
      _items.add({
        'id': product['id'],
        'name': product['name'],
        'category': product['category'] ?? 'Pedra Natural',
        'image': product['image'],
        'price': product['price'],
        'qty': 1, // Começa com 1m²
      });
    }
  }

  // 3. Remover/Diminuir Produto
  void removeFromCart(int productId) {
    final index = _items.indexWhere((item) => item['id'] == productId);
    
    if (index >= 0) {
      if (_items[index]['qty'] > 1) {
        _items[index]['qty'] -= 1;
      } else {
        _items.removeAt(index); // Remove da lista se for 0
      }
    }
  }

  // 4. Aumentar quantidade manualmente
  void incrementQty(int productId) {
    final index = _items.indexWhere((item) => item['id'] == productId);
    if (index >= 0) {
      _items[index]['qty'] += 1;
    }
  }

  // 5. Calcular Total
  double get total {
    return _items.fold(0, (sum, item) => sum + (item['price'] * item['qty']));
  }

  // 6. Contar itens totais
  int get count {
    return _items.length;
  }
}