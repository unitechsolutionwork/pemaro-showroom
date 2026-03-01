import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import 'cart_service.dart';
import 'favorites_service.dart';

// Agora é um StatefulWidget para permitir a mudança visual do ícone de coração
class ProductDetailScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final FavoritesService favoritesService = FavoritesService();

  @override
  Widget build(BuildContext context) {
    final double imageHeight = MediaQuery.of(context).size.height * 0.55;
    // Atalho para facilitar a leitura do código
    final product = widget.product;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. IMAGEM HERO
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: imageHeight,
            child: Hero(
              tag: "img_${product['id']}",
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(product['image']),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.3),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.4],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 2. CONTEÚDO (Sheet Flutuante)
          SingleChildScrollView(
            padding: EdgeInsets.only(top: imageHeight - 50),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 20,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 12),
                      height: 5,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product['name'],
                                    style: GoogleFonts.lato(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w900,
                                      height: 1.1,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "MZN ${product['price']}",
                                          style: GoogleFonts.lato(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w900,
                                            color: const Color(0xFFD4AF37),
                                          ),
                                        ),
                                        TextSpan(
                                          text: " / m²",
                                          style: GoogleFonts.lato(
                                            fontSize: 14,
                                            color: Colors.grey[500],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                color: const Color(0xFFD4AF37),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFFD4AF37,
                                    ).withOpacity(0.4),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.zoom_in,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 25),
                        Text(
                          product['description'] ??
                              "Uma obra-prima natural selecionada manualmente das melhores pedreiras.",
                          style: GoogleFonts.lato(
                            fontSize: 16,
                            color: Colors.grey[600],
                            height: 1.6,
                          ),
                        ),

                        const SizedBox(height: 30),
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                          childAspectRatio: 2.2,
                          children: const [
                            _SpecBox(
                              title: "ORIGEM",
                              value: "Carrara, Itália",
                              icon: Icons.location_on,
                            ),
                            _SpecBox(
                              title: "ESPESSURA",
                              value: "20mm - 30mm",
                              icon: Icons.straighten,
                            ),
                            _SpecBox(
                              title: "ACABAMENTO",
                              value: "Polido / Fosco",
                              icon: Icons.shutter_speed,
                            ),
                            _SpecBox(
                              title: "DUREZA",
                              value: "3-4 Escala Mohs",
                              icon: Icons.diamond,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3. BARRA SUPERIOR (Ação de Favorito aqui)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _GlassButton(
                      icon: Icons.arrow_back_ios_new,
                      onTap: () => Navigator.pop(context),
                    ),
                    Row(
                      children: [
                        // --- AQUI ESTÁ A AÇÃO DE FAVORITOS ---
                        ListenableBuilder(
                          listenable: favoritesService,
                          builder: (context, child) {
                            final isFav = favoritesService.isFavorite(product);
                            return _GlassButton(
                              icon: isFav
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              iconColor: isFav ? Colors.red : Colors.white,
                              onTap: () {
                                favoritesService.toggleFavorite(product);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      isFav
                                          ? "Removido dos favoritos"
                                          : "Adicionado aos favoritos",
                                    ),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        const SizedBox(width: 10),
                        _GlassButton(icon: Icons.share, onTap: () {}),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 4. BARRA DE AÇÃO INFERIOR
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.white,
                    Colors.white.withOpacity(0.9),
                    Colors.transparent,
                  ],
                  stops: const [0.5, 0.8, 1.0],
                ),
              ),
              child: ElevatedButton(
                onPressed: () {
                  CartService().addToCart(product);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.black,
                      content: Row(
                        children: [
                          Icon(Icons.check_circle, color: Color(0xFFD4AF37)),
                          SizedBox(width: 10),
                          Text("Adicionado à cotação!"),
                        ],
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "ADICIONAR À COTAÇÃO",
                      style: GoogleFonts.lato(
                        color: const Color(0xFFD4AF37),
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(
                      Icons.arrow_forward,
                      color: Color(0xFFD4AF37),
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget auxiliar atualizado para suportar cores dinâmicas no ícone
class _GlassButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color iconColor;

  const _GlassButton({
    required this.icon,
    required this.onTap,
    this.iconColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
        ),
      ),
    );
  }
}

class _SpecBox extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  const _SpecBox({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F7F6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: GoogleFonts.lato(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.grey[400],
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Icon(icon, color: const Color(0xFFD4AF37), size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  value,
                  style: GoogleFonts.lato(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
