import 'package:flutter/material.dart';

class FavoritesService extends ChangeNotifier {
  // Singleton para usar em todo o app
  static final FavoritesService _instance = FavoritesService._internal();
  factory FavoritesService() => _instance;
  FavoritesService._internal();

  final List<Map<String, dynamic>> _favorites = [];

  List<Map<String, dynamic>> get items => _favorites;

  // Verifica se uma pedra já é favorita
  bool isFavorite(dynamic product) {
    return _favorites.any((item) => item['id'] == product['id']);
  }

  // Alterna entre favorito e não favorito
  void toggleFavorite(Map<String, dynamic> product) {
    final index = _favorites.indexWhere((item) => item['id'] == product['id']);
    if (index >= 0) {
      _favorites.removeAt(index);
    } else {
      _favorites.add(product);
    }
    notifyListeners(); // Notifica a UI para atualizar o ícone
  }
}
