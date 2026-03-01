import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'main.dart';
import 'image_helper.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Fundo de Mármore
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  proxyImage(
                    "https://i.pinimg.com/736x/31/ae/56/31ae567a4fed2c0a32c714930953eb11.jpg",
                  ),
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 2. Filtro Escuro
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.8),
                ],
              ),
            ),
          ),

          // 3. Conteúdo
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 3),
                const Icon(Icons.architecture, color: Colors.white70, size: 40),
                const SizedBox(height: 10),
                Text(
                  "Stone Trading",
                  style: GoogleFonts.lato(
                    fontSize: 48,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 8.0,
                    shadows: const [
                      Shadow(
                        color: Colors.black45,
                        blurRadius: 20,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 1,
                          color: const Color(0xFFD4AF37),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "PEDRAS ARQUITETÓNICAS",
                          style: GoogleFonts.lato(
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFFD4AF37),
                            letterSpacing: 3.0,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 1,
                          color: const Color(0xFFD4AF37),
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(flex: 3),

                Text(
                  "EXCELÊNCIA EM MÁRMORE & GRANITO",
                  style: GoogleFonts.lato(
                    fontSize: 10,
                    color: Colors.white70,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          // ✅ CORRIGIDO: Navega para MainNavigation (que tem a NavBar)
                          builder: (context) => const MainNavigation(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD4AF37),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      elevation: 10,
                      shadowColor: const Color(0xFFD4AF37).withOpacity(0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "ENTRAR NA GALERIA",
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(width: 10),
                        Icon(Icons.arrow_forward_ios, size: 14),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.public, color: Colors.white54, size: 12),
                          SizedBox(width: 5),
                          Text(
                            "EDIÇÃO INTERNACIONAL",
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      Container(width: 1, height: 15, color: Colors.white24),
                      const Row(
                        children: [
                          Icon(
                            Icons.verified_user_outlined,
                            color: Colors.white54,
                            size: 12,
                          ),
                          SizedBox(width: 5),
                          Text(
                            "AUTENTICIDADE GARANTIDA",
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
