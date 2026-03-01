import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'favorites_service.dart';
import 'product_detail.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  // Instância do serviço global de favoritos
  final FavoritesService favoritesService = FavoritesService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBF9),
      appBar: AppBar(
        title: Text(
          "MEUS FAVORITOS",
          style: GoogleFonts.lato(
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      // O ListenableBuilder é a "mágica" que faz a lista atualizar sozinha
      body: ListenableBuilder(
        listenable: favoritesService,
        builder: (context, child) {
          final items = favoritesService.items;

          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 80,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "Sua lista de desejos está vazia.",
                    style: GoogleFonts.lato(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final product = items[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 15),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(10),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      product['image'],
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    product['name'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("MZN ${product['price']} / m²"),
                  trailing: IconButton(
                    icon: const Icon(Icons.favorite, color: Colors.red),
                    onPressed: () {
                      // Remove dos favoritos e a UI atualiza automaticamente
                      favoritesService.toggleFavorite(product);
                    },
                  ),
                  onTap: () {
                    // Navega para ver os detalhes da pedra favorita
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductDetailScreen(product: product),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
