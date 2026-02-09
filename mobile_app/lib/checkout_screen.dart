import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'cart_service.dart';
import 'api_service.dart'; // A ponte para o Backend
import 'success_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final CartService cart = CartService();
  final ApiService api = ApiService(); // Instância da API
  
  String _selectedMethod = "mpesa"; // Padrão: M-Pesa
  final TextEditingController _phoneController = TextEditingController();
  bool _isProcessing = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBF9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Pagamento Seguro",
          style: GoogleFonts.lato(color: Colors.black, fontWeight: FontWeight.w900),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. TOTAL GRANDE
            Center(
              child: Column(
                children: [
                  Text("Total a Pagar", style: TextStyle(color: Colors.grey[500], fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                  const SizedBox(height: 5),
                  Text(
                    "MZN ${cart.total.toStringAsFixed(0)}",
                    style: GoogleFonts.lato(fontSize: 32, fontWeight: FontWeight.w900, color: const Color(0xFFD4AF37)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // 2. SELEÇÃO DE MÉTODO
            Text("Escolha o Método", style: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 15),
            
            // Cartão M-Pesa
            _PaymentMethodCard(
              id: "mpesa",
              name: "M-Pesa",
              description: "Vodacom Moçambique",
              color: Colors.redAccent,
              icon: Icons.phonelink_ring,
              isSelected: _selectedMethod == "mpesa",
              onTap: () => setState(() => _selectedMethod = "mpesa"),
            ),
            const SizedBox(height: 10),
            
            // Cartão E-Mola
            _PaymentMethodCard(
              id: "emola",
              name: "E-Mola",
              description: "Movitel Moçambique",
              color: Colors.orangeAccent,
              icon: Icons.flash_on,
              isSelected: _selectedMethod == "emola",
              onTap: () => setState(() => _selectedMethod = "emola"),
            ),
            const SizedBox(height: 10),

            // Cartão POS (Outros)
            _PaymentMethodCard(
              id: "pos",
              name: "Cartão / POS",
              description: "Pagamento na Entrega",
              color: Colors.grey,
              icon: Icons.credit_card,
              isSelected: _selectedMethod == "pos",
              onTap: () => setState(() => _selectedMethod = "pos"),
            ),

            const SizedBox(height: 40),

            // 3. ÁREA DE INPUT (Só aparece se for Mobile Money)
            if (_selectedMethod == "mpesa" || _selectedMethod == "emola") ...[
              Text(
                "Número de Telefone (${_selectedMethod == 'mpesa' ? 'Vodacom' : 'Movitel'})",
                style: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.5)),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                ),
                child: Row(
                  children: [
                    // Bandeira MZ (Simulada) e código
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(6)),
                      child: Row(
                        children: const [
                          Text("🇲🇿", style: TextStyle(fontSize: 20)),
                          SizedBox(width: 5),
                          Text("+258", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 15),
                    // Input
                    Expanded(
                      child: TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                        decoration: InputDecoration(
                          hintText: _selectedMethod == "mpesa" ? "84/85..." : "86/87...",
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey[300]),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.info_outline, size: 14, color: Colors.grey[500]),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      "Você receberá um PIN no seu telemóvel para confirmar.",
                      style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                    ),
                  ),
                ],
              )
            ],
          ],
        ),
      ),
      
      // 4. BOTÃO DE PAGAR
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20, offset: const Offset(0, -5))]),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: _isProcessing ? null : _processPayment, // Bloqueia se estiver processando
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD4AF37),
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 5,
            ),
            child: _isProcessing 
              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : Text(
                  "PAGAR MZN ${cart.total.toStringAsFixed(0)}",
                  style: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1.0),
                ),
          ),
        ),
      ),
    );
  }

  // --- LÓGICA DE PAGAMENTO ---
  void _processPayment() async {
    // 1. Validação do Input
    String phone = _phoneController.text.trim();
    
    // Se for M-Pesa ou E-Mola, precisa de 9 dígitos (ex: 841234567)
    if ((_selectedMethod == "mpesa" || _selectedMethod == "emola")) {
      if (phone.isEmpty || phone.length < 9) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text("Erro: Insira um número válido (9 dígitos)."),
        ));
        return;
      }
    }

    // 2. Iniciar Processamento (Loading)
    setState(() => _isProcessing = true);

    try {
      // 3. CHAMADA AO SERVIÇO (Backend)
      // Esta função está no arquivo api_service.dart que configuramos antes
      await api.initiatePayment(
        method: _selectedMethod,
        phoneNumber: phone,
        amount: cart.total,
      );

      // 4. Sucesso!
      if (mounted) {
        setState(() => _isProcessing = false);
        
        // Vamos para a tela de sucesso
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SuccessScreen()),
        );
      }

    } catch (e) {
      // 5. Erro (Ex: Falha de conexão ou Backend offline)
      if (mounted) {
        setState(() => _isProcessing = false);
        
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red[800],
          content: Row(
            children: [
              const Icon(Icons.error, color: Colors.white),
              const SizedBox(width: 10),
              // Mostra a mensagem de erro limpa
              Expanded(child: Text(e.toString().replaceAll("Exception: ", ""))),
            ],
          ),
          duration: const Duration(seconds: 4),
        ));
      }
    }
  }
}

// --- WIDGET AUXILIAR: CARTÃO DE PAGAMENTO ---
class _PaymentMethodCard extends StatelessWidget {
  final String id;
  final String name;
  final String description;
  final Color color;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentMethodCard({
    required this.id, required this.name, required this.description, required this.color, required this.icon, required this.isSelected, required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFFD4AF37) : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(color: const Color(0xFFD4AF37).withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4))
            else
              BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5, offset: const Offset(0, 2))
          ],
        ),
        child: Row(
          children: [
            // Ícone do Método
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 15),
            // Textos
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text(description, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                ],
              ),
            ),
            // Bolinha de Seleção (Radio Customizado)
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: isSelected ? const Color(0xFFD4AF37) : Colors.grey[300]!, width: 2),
                color: isSelected ? const Color(0xFFD4AF37) : Colors.transparent,
              ),
              child: isSelected ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
            )
          ],
        ),
      ),
    );
  }
}