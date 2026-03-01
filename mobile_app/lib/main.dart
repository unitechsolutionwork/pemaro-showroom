import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'api_service.dart';
import 'splash_screen.dart';
import 'product_detail.dart';
import 'cart_screen.dart';
import 'cart_service.dart';
import 'explore_screen.dart';
import 'favorites_screen.dart';
import 'profile_screen.dart';
import 'favorites_service.dart';

void main() {
  runApp(const StoneTradingApp());
}

class StoneTradingApp extends StatelessWidget {
  const StoneTradingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Stone Trading',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFD4AF37),
          primary: const Color(0xFFD4AF37),
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.latoTextTheme(),
        scaffoldBackgroundColor: const Color(0xFFF9F9F9),
      ),
      home: const SplashScreen(),
    );
  }
}

// --- CONTROLO DA NAVEGAÇÃO E BADGES ---
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  final CartService cart = CartService();
  final FavoritesService favorites = FavoritesService();

  final GlobalKey<_ShowroomScreenState> _showroomKey =
      GlobalKey<_ShowroomScreenState>();
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      ShowroomScreen(key: _showroomKey),
      ExploreScreen(
        onCategorySelected: (category) {
          _showroomKey.currentState?._filterByCategory(category);
          setState(() => _selectedIndex = 0);
        },
      ),
      const CartScreen(),
      const FavoritesScreen(),
      const ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFFD4AF37),
        unselectedItemColor: Colors.grey[400],
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
        elevation: 15,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: "INÍCIO",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            label: "EXPLORAR",
          ),
          BottomNavigationBarItem(
            icon: ListenableBuilder(
              listenable: cart,
              builder: (context, child) =>
                  _buildBadgeIcon(Icons.shopping_bag_outlined, cart.count),
            ),
            label: "CARRINHO",
          ),
          BottomNavigationBarItem(
            icon: ListenableBuilder(
              listenable: favorites,
              builder: (context, child) => _buildBadgeIcon(
                Icons.favorite_border,
                favorites.items.length,
              ),
            ),
            label: "FAVORITOS",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "PERFIL",
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeIcon(IconData icon, int count) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(icon),
        if (count > 0)
          Positioned(
            right: -5,
            top: -5,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.redAccent,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              child: Text(
                '$count',
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
    );
  }
}

// --- GALERIA COM PESQUISA EM TEMPO REAL ---
class ShowroomScreen extends StatefulWidget {
  const ShowroomScreen({super.key});
  @override
  State<ShowroomScreen> createState() => _ShowroomScreenState();
}

class _ShowroomScreenState extends State<ShowroomScreen> {
  final ApiService api = ApiService();
  final TextEditingController _searchController = TextEditingController();

  List<dynamic> allProducts = [];
  List<dynamic> filteredProducts = [];
  bool isLoading = true;
  String? errorMessage;
  String _selectedCategory = "Todos";

  final List<String> _categories = [
    "Todos",
    "Mármore",
    "Granito",
    "Quartzo",
    "Ônix",
  ];

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  void loadProducts() async {
    try {
      final data = await api.fetchProducts();
      if (mounted) {
        setState(() {
          allProducts = data;
          filteredProducts = data;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted)
        setState(() {
          isLoading = false;
          errorMessage = e.toString();
        });
    }
  }

  // Lógica de filtro combinada (Texto + Categoria)
  void _applyFilters() {
    setState(() {
      filteredProducts = allProducts.where((product) {
        final matchesCategory =
            _selectedCategory == "Todos" ||
            product['category'] == _selectedCategory;
        final matchesSearch = product['name'].toString().toLowerCase().contains(
          _searchController.text.toLowerCase(),
        );
        return matchesCategory && matchesSearch;
      }).toList();
    });
  }

  void _filterByCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFD4AF37),
                      ),
                    )
                  : errorMessage != null
                  ? Center(child: Text("Erro: $errorMessage"))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSearchBar(),
                          const SizedBox(height: 25),
                          _buildCategoryList(),
                          const SizedBox(height: 30),
                          _buildGridHeader(),
                          const SizedBox(height: 20),
                          _buildProductGrid(),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.diamond, color: Color(0xFFD4AF37), size: 28),
              const SizedBox(width: 8),
              Text(
                "STONE TRADING",
                style: GoogleFonts.lato(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const CircleAvatar(
            radius: 18,
            backgroundColor: Color(0xFFF0E5CF),
            child: Icon(
              Icons.person_outline,
              color: Color(0xFFD4AF37),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => _applyFilters(),
              decoration: InputDecoration(
                hintText: "Pesquisar pedras...",
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          _applyFilters();
                        },
                      )
                    : null,
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
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: const Icon(Icons.tune, color: Color(0xFFD4AF37)),
        ),
      ],
    );
  }

  Widget _buildCategoryList() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final cat = _categories[index];
          final isSelected = cat == _selectedCategory;
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () => _filterByCategory(cat),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFD4AF37) : Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: const Color(0xFFD4AF37).withOpacity(0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [],
                ),
                child: Text(
                  cat,
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
    );
  }

  Widget _buildGridHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Destaques (${filteredProducts.length})",
          style: GoogleFonts.lato(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: Colors.black87,
          ),
        ),
        const Row(
          children: [
            Text(
              "Ver tudo",
              style: TextStyle(
                color: Color(0xFFD4AF37),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            SizedBox(width: 4),
            Icon(Icons.arrow_forward, size: 12, color: Color(0xFFD4AF37)),
          ],
        ),
      ],
    );
  }

  Widget _buildProductGrid() {
    if (filteredProducts.isEmpty)
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text("Nenhuma pedra corresponde à sua busca."),
        ),
      );
    return GridView.builder(
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
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailScreen(product: product),
              ),
            );
            setState(() {});
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
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
                            borderRadius: const BorderRadius.all(
                              Radius.circular(20),
                            ),
                            image: DecorationImage(
                              image: NetworkImage(product['image'] ?? ""),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: isLowStock
                                ? Colors.orangeAccent
                                : const Color(0xFF00C853),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            isLowStock ? "POUCO STOCK" : "EM STOCK",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.w900,
                            ),
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
                        style: GoogleFonts.lato(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                        ),
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
    );
  }
}
