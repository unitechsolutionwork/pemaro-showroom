import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ExploreScreen extends StatelessWidget {
  // Adicionamos esta função que recebe o nome da categoria
  final Function(String) onCategorySelected;

  const ExploreScreen({super.key, required this.onCategorySelected});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'name': 'Mármore', 'icon': Icons.layers},
      {'name': 'Granito', 'icon': Icons.grid_view},
      {'name': 'Quartzo', 'icon': Icons.texture},
      {'name': 'Ônix', 'icon': Icons.brightness_high},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBF9),
      appBar: AppBar(
        title: Text(
          "EXPLORAR",
          style: GoogleFonts.lato(
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.0,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final catName = categories[index]['name'].toString();
          return GestureDetector(
            onTap: () => onCategorySelected(catName), // DISPARA A AÇÃO
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey[200]!),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    categories[index]['icon'] as IconData,
                    size: 45,
                    color: const Color(0xFFD4AF37),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    catName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
