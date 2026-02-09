import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'main.dart'; // Para voltar ao início
import 'cart_service.dart'; // Para limpar o carrinho

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Limpar o carrinho ao chegar aqui (Simulação de pedido feito)
    // Na vida real, você limparia só depois da confirmação do servidor
    // CartService().clear(); // (Se tiveres um método clear, senão ignora por agora)

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Círculo animado (Simples)
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFFD4AF37).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Color(0xFFD4AF37), size: 50),
              ),
              const SizedBox(height: 30),
              Text(
                "Pedido Recebido!",
                style: GoogleFonts.lato(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                "A sua cotação foi enviada com sucesso. A nossa equipa entrará em contacto em breve.",
                style: GoogleFonts.lato(fontSize: 14, color: Colors.grey[600], height: 1.5),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),
              
              // Botão Voltar
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    // Volta para a tela inicial e remove tudo da pilha de navegação
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const PemaroApp()), // Reinicia o app
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: const Color(0xFFD4AF37),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("VOLTAR À GALERIA", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}