import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'main.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Fundo de Mármore (Sua imagem nova)
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage("https://i.pinimg.com/736x/31/ae/56/31ae567a4fed2c0a32c714930953eb11.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          // 2. Filtro Escuro (Gradiente para leitura)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.3), // Mais suave em cima
                  Colors.black.withOpacity(0.8), // Mais escuro em baixo
                ],
              ),
            ),
          ),

          // 3. Conteúdo
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 3), // Empurra o logo um pouco para baixo
                
                // Ícone Decorativo (Compasso/Arquitetura)
                const Icon(
                  Icons.architecture, 
                  color: Colors.white70, 
                  size: 40
                ),
                
                const SizedBox(height: 10),

                // LOGO PEMARO
                Text(
                  "PEMARO",
                  style: GoogleFonts.lato(
                    fontSize: 48,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 8.0,
                    shadows: [
                      const Shadow(color: Colors.black45, blurRadius: 20, offset: Offset(0, 5))
                    ],
                  ),
                ),
                
                // Divisor Dourado (Linhas ao lado do texto)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  child: Row(
                    children: [
                      Expanded(child: Container(height: 1, color: const Color(0xFFD4AF37))),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "PEDRAS ARQUITETÓNICAS",
                          style: GoogleFonts.lato(
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFFD4AF37), // Dourado
                            letterSpacing: 3.0,
                          ),
                        ),
                      ),
                      Expanded(child: Container(height: 1, color: const Color(0xFFD4AF37))),
                    ],
                  ),
                ),

                const Spacer(flex: 3),

                // Frase de Excelência (Acima do botão)
                Text(
                  "EXCELÊNCIA EM MÁRMORE & GRANITO",
                  style: GoogleFonts.lato(
                    fontSize: 10,
                    color: Colors.white70,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.bold
                  ),
                ),
                
                const SizedBox(height: 20),

                // Botão de Entrar (ARREDONDADO IGUAL AO STITCH)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const ShowroomScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD4AF37), // Dourado
                      foregroundColor: Colors.black, // Texto Preto
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      elevation: 10,
                      shadowColor: const Color(0xFFD4AF37).withOpacity(0.4),
                      // AQUI ESTÁ A MUDANÇA: Arredondado (30) em vez de Quadrado (0)
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), 
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "ENTRAR NA GALERIA", 
                          style: TextStyle(
                            fontWeight: FontWeight.w900, 
                            letterSpacing: 1.2,
                            fontSize: 14
                          )
                        ),
                        SizedBox(width: 10),
                        Icon(Icons.arrow_forward_ios, size: 14), // Seta mais elegante
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // RODAPÉ (Informações extras do design)
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.public, color: Colors.white54, size: 12),
                          SizedBox(width: 5),
                          Text("EDIÇÃO INTERNACIONAL", style: TextStyle(color: Colors.white54, fontSize: 10)),
                        ],
                      ),
                      Container(width: 1, height: 15, color: Colors.white24), // Separador vertical
                      Row(
                        children: const [
                          Icon(Icons.verified_user_outlined, color: Colors.white54, size: 12),
                          SizedBox(width: 5),
                          Text("AUTENTICIDADE GARANTIDA", style: TextStyle(color: Colors.white54, fontSize: 10)),
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