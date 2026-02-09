import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'api_service.dart';
import 'splash_screen.dart';
import 'product_detail.dart';
import 'cart_screen.dart';
import 'cart_service.dart'; // <--- IMPORTANTE: Importar o serviço do carrinho

void main() {
  runApp(const PemaroApp());
}

class PemaroApp extends StatelessWidget {
  const PemaroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Showroom Pemaro',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFD4AF37),
          primary: const Color(0xFFD4AF37),
          background: const Color(0xFFF9F9F9),
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.latoTextTheme(),
        scaffoldBackgroundColor: const Color(0xFFF9F9F9),
      ),
      home: const SplashScreen(),
    );
  }
}

class ShowroomScreen extends StatefulWidget {
  const ShowroomScreen({super.key});

  @override
  State<ShowroomScreen> createState() => _ShowroomScreenState();
}

class _ShowroomScreenState extends State<ShowroomScreen> {
  final ApiService api = ApiService();
  final CartService cart = CartService(); // <--- Instância do Carrinho para contar itens
  
  List<dynamic> allProducts = []; 
  List<dynamic> filteredProducts = []; 
  bool isLoading = true;
  String? errorMessage;
  int _selectedIndex = 0;
  String _selectedCategory = "Todos"; 
  
  final List<String> _categories = ["Todos", "Mármore", "Granito", "Quartzo", "Ônix"];

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  // Função chamada sempre que voltamos para esta tela (para atualizar o contador)
  void _refreshCart() {
    setState(() {});
  }

  void loadProducts() async {
    try {
      final data = await api.fetchProducts();
      setState(() {
        allProducts = data;
        filteredProducts = data; 
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  void _filterProducts(String category) {
    setState(() {
      _selectedCategory = category;
      if (category == "Todos") {
        filteredProducts = allProducts;
      } else {
        filteredProducts = allProducts.where((product) {
          return product['category'] == category;
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: Column(
          children: [
            // 1. CABEÇALHO
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.explore, color: Color(0xFFD4AF37), size: 28),
                      const SizedBox(width: 8),
                      Text(
                        "A GALERIA",
                        style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.black, letterSpacing: 0.5),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.notifications_outlined, color: Colors.grey[800], size: 26),
                      const SizedBox(width: 15),
                      const CircleAvatar(
                        radius: 18,
                        backgroundColor: Color(0xFFF0E5CF),
                        child: Icon(Icons.person_outline, color: Color(0xFFD4AF37), size: 20),
                      )
                    ],
                  ),
                ],
              ),
            ),

            // CONTEÚDO
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator(color: Color(0xFFD4AF37)))
                  : errorMessage != null
                      ? Center(child: Text("Erro: $errorMessage"))
                      : SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 2. BUSCA
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(30),
                                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
                                      ),
                                      child: TextField(
                                        decoration: InputDecoration(
                                          hintText: "Pesquisar pedras...",
                                          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                                          prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                                          border: InputBorder.none,
                                          contentPadding: const EdgeInsets.symmetric(vertical: 15),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
                                    ),
                                    child: const Icon(Icons.tune, color: Color(0xFFD4AF37)),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 25),

                              // 3. CATEGORIAS
                              SizedBox(
                                height: 40,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _categories.length,
                                  itemBuilder: (context, index) {
                                    final category = _categories[index];
                                    final isSelected = category == _selectedCategory;
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: GestureDetector(
                                        onTap: () => _filterProducts(category),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                                          decoration: BoxDecoration(
                                            color: isSelected ? const Color(0xFFD4AF37) : Colors.white,
                                            borderRadius: BorderRadius.circular(25),
                                            boxShadow: isSelected 
                                              ? [BoxShadow(color: const Color(0xFFD4AF37).withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 4))]
                                              : [],
                                          ),
                                          child: Text(
                                            category,
                                            style: TextStyle(
                                              color: isSelected ? Colors.white : Colors.grey[600],
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),

                              const SizedBox(height: 30),

                              // 4. RESULTADOS
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Destaques (${filteredProducts.length})", 
                                    style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.black87),
                                  ),
                                  Row(
                                    children: const [
                                      Text("Ver tudo", style: TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold, fontSize: 12)),
                                      SizedBox(width: 4),
                                      Icon(Icons.arrow_forward, size: 12, color: Color(0xFFD4AF37))
                                    ],
                                  )
                                ],
                              ),

                              const SizedBox(height: 20),

                              // 5. GRID
                              filteredProducts.isEmpty 
                                ? const Center(child: Padding(padding: EdgeInsets.all(20), child: Text("Nenhuma pedra nesta categoria.")))
                                : GridView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 0.65,
                                      crossAxisSpacing: 15,
                                      mainAxisSpacing: 15,
                                    ),
                                    itemCount: filteredProducts.length,
                                    itemBuilder: (context, index) {
                                      final product = filteredProducts[index];
                                      final isLowStock = product['qty'] < 50;

                                      return GestureDetector(
                                        onTap: () async {
                                          // NAVEGAÇÃO ESPERANDO RETORNO (Await)
                                          // Isso garante que quando voltar, atualiza o contador
                                          await Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => ProductDetailScreen(product: product)),
                                          );
                                          _refreshCart(); // Atualiza o contador ao voltar
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(20),
                                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 5))],
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Stack(
                                                  children: [
                                                    Hero(
                                                      tag: "img_${product['id']}",
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          borderRadius: const BorderRadius.all(Radius.circular(20)),
                                                          image: DecorationImage(
                                                            image: NetworkImage(product['image'] ?? ""),
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      top: 10, right: 10,
                                                      child: Container(
                                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                        decoration: BoxDecoration(
                                                          color: isLowStock ? Colors.orangeAccent : const Color(0xFF00C853),
                                                          borderRadius: BorderRadius.circular(10),
                                                        ),
                                                        child: Text(
                                                          isLowStock ? "POUCO STOCK" : "EM STOCK",
                                                          style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.w900),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(12.0),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      product['name'].toString().toUpperCase(),
                                                      style: GoogleFonts.lato(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.black),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      "MZN ${product['price']} / m²",
                                                      style: TextStyle(color: Colors.grey[600], fontSize: 11),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) async {
          if (index == 2) {
            // NAVEGAÇÃO ESPERANDO RETORNO
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CartScreen()),
            );
            _refreshCart(); // Atualiza contador ao voltar do carrinho
          } else {
            setState(() => _selectedIndex = index);
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFFD4AF37),
        unselectedItemColor: Colors.grey[400],
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
        elevation: 15,
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "INÍCIO"),
          const BottomNavigationBarItem(icon: Icon(Icons.explore_outlined), label: "EXPLORAR"),
          
          // --- ITEM DO CARRINHO COM BADGE ---
          BottomNavigationBarItem(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.shopping_bag_outlined),
                if (cart.count > 0) // Só mostra se tiver itens
                  Positioned(
                    right: -5,
                    top: -5,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.redAccent, // Cor de destaque do badge
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '${cart.count}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            label: "CARRINHO",
          ),
          
          const BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: "FAVORITOS"),
          const BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "PERFIL"),
        ],
      ),
    );
  }
}