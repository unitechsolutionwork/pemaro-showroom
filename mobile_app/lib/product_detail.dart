import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui'; // Necessário para o efeito de vidro (Blur)
import 'cart_service.dart'; // <--- 1. IMPORTANTE: Importar o serviço do carrinho

class ProductDetailScreen extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    // Altura da imagem (55% da tela, como no HTML)
    final double imageHeight = MediaQuery.of(context).size.height * 0.55;

    return Scaffold(
      backgroundColor: Colors.white, // Fundo branco quando rola para baixo
      body: Stack(
        children: [
          // 1. IMAGEM HERO (Fundo)
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
                  // Gradiente leve para o texto branco do topo aparecer
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black.withOpacity(0.3), Colors.transparent],
                      stops: const [0.0, 0.4],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 2. CONTEÚDO (Sheet Flutuante)
          SingleChildScrollView(
            padding: EdgeInsets.only(top: imageHeight - 50), // Começa um pouco antes da imagem acabar
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, -5)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Pequena barra de "pega" (Handle bar)
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
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 100), // Padding inferior grande p/ botão fixo
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Título e Preço
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
                                      color: Colors.black87
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
                                            color: const Color(0xFFD4AF37)
                                          ),
                                        ),
                                        TextSpan(
                                          text: " / m²",
                                          style: GoogleFonts.lato(
                                            fontSize: 14, 
                                            color: Colors.grey[500]
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Botão de Zoom (Simulado visualmente)
                            Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                color: const Color(0xFFD4AF37),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFD4AF37).withOpacity(0.4),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: const Icon(Icons.zoom_in, color: Colors.white, size: 28),
                            ),
                          ],
                        ),

                        const SizedBox(height: 25),

                        // Descrição
                        Text(
                          product['description'] ?? "Uma obra-prima natural selecionada manualmente das melhores pedreiras. Veios ousados com tons sutis, oferecendo elegância inigualável para interiores de luxo.",
                          style: GoogleFonts.lato(fontSize: 16, color: Colors.grey[600], height: 1.6),
                        ),

                        const SizedBox(height: 30),

                        // Grid de Especificações
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                          childAspectRatio: 2.2,
                          children: const [
                            _SpecBox(title: "ORIGEM", value: "Carrara, Itália", icon: Icons.location_on),
                            _SpecBox(title: "ESPESSURA", value: "20mm - 30mm", icon: Icons.straighten),
                            _SpecBox(title: "ACABAMENTO", value: "Polido / Fosco", icon: Icons.shutter_speed),
                            _SpecBox(title: "DUREZA", value: "3-4 Escala Mohs", icon: Icons.diamond),
                          ],
                        ),

                        const SizedBox(height: 30),

                        // Galeria Horizontal
                        Text(
                          "CORTES ALTERNATIVOS",
                          style: GoogleFonts.lato(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[400], letterSpacing: 1.5),
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          height: 80,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 4,
                            itemBuilder: (context, index) {
                              return Container(
                                width: 80,
                                margin: const EdgeInsets.only(right: 15),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  image: DecorationImage(
                                    image: NetworkImage(product['image']),
                                    fit: BoxFit.cover,
                                    alignment: Alignment(index * 0.3, 0),
                                  ),
                                  border: Border.all(color: Colors.grey[200]!),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3. BARRA SUPERIOR (Glassmorphism)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _GlassButton(
                      icon: Icons.arrow_back_ios_new,
                      onTap: () => Navigator.pop(context),
                    ),
                    Row(
                      children: [
                        _GlassButton(icon: Icons.favorite_border, onTap: () {}),
                        const SizedBox(width: 10),
                        _GlassButton(icon: Icons.share, onTap: () {}),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 4. BARRA DE AÇÃO INFERIOR (Sticky)
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
                  colors: [Colors.white, Colors.white.withOpacity(0.9), Colors.transparent],
                  stops: const [0.5, 0.8, 1.0],
                ),
              ),
              child: ElevatedButton(
                onPressed: () {
                  // --- 2. LÓGICA DO CARRINHO AQUI ---
                  CartService().addToCart(product);

                  // Feedback visual (SnackBar Bonita)
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.black,
                      content: Row(
                        children: const [
                          Icon(Icons.check_circle, color: Color(0xFFD4AF37)),
                          SizedBox(width: 10),
                          Text("Pedra adicionada à cotação!", style: TextStyle(color: Colors.white)),
                        ],
                      ),
                      duration: const Duration(seconds: 2),
                    )
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 10,
                  shadowColor: Colors.black45,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "ADICIONAR À COTAÇÃO",
                      style: GoogleFonts.lato(color: const Color(0xFFD4AF37), fontWeight: FontWeight.w900, letterSpacing: 1.5),
                    ),
                    const SizedBox(width: 10),
                    const Icon(Icons.arrow_forward, color: Color(0xFFD4AF37), size: 20),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

// Widget auxiliar para os botões de vidro (Blur)
class _GlassButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _GlassButton({required this.icon, required this.onTap});

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
            child: Icon(icon, color: Colors.white, size: 20),
          ),
        ),
      ),
    );
  }
}

// Widget auxiliar para a Grid de Especificações
class _SpecBox extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _SpecBox({required this.title, required this.value, required this.icon});

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
            style: GoogleFonts.lato(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey[400], letterSpacing: 1.0),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Icon(icon, color: const Color(0xFFD4AF37), size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  value,
                  style: GoogleFonts.lato(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87),
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