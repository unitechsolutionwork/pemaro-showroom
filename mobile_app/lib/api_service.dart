// mobile_app/lib/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // ⚠️ CONFIGURAÇÃO DE IP (MUITO IMPORTANTE):
  // Se estiver no Emulador Android: use 'http://10.0.2.2:3000/api'
  // Se estiver no iOS ou Web: use 'http://localhost:3000/api'
  // Se estiver no Celular Real (USB): use o IP do seu PC (ex: 'http://192.168.1.5:3000/api')
  
  static const String baseUrl = 'http://localhost:3000/api'; 

  // 1. BUSCAR PRODUTOS
  Future<List<dynamic>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/products'));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Falha ao carregar produtos: ${response.statusCode}');
      }
    } catch (e) {
      print("Erro de conexão: $e");
      throw Exception('Erro ao conectar com o servidor. Verifique o IP.');
    }
  }

  // 2. INICIAR PAGAMENTO REAL (M-Pesa / E-Mola)
  Future<bool> initiatePayment({
    required String method, // 'mpesa' ou 'emola'
    required String phoneNumber,
    required double amount,
  }) async {
    // A. Formatar o número para 258...
    String formattedPhone = phoneNumber.trim();
    if (formattedPhone.startsWith('+')) {
      formattedPhone = formattedPhone.substring(1); 
    }
    if (!formattedPhone.startsWith('258')) {
      formattedPhone = '258$formattedPhone';
    }

    print("🚀 Enviando para o Backend: $method | $formattedPhone | $amount");

    // B. CHAMADA REAL AO SEU BACKEND
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/payment/initiate'), // Chama a rota do node.js
        body: jsonEncode({
          "phone": formattedPhone,
          "amount": amount,
          "method": method
        }),
        headers: {"Content-Type": "application/json"}
      );
      
      print("📩 Resposta do Servidor: ${response.body}");

      if (response.statusCode == 200) {
        // Sucesso! O Backend confirmou que mandou para o M-Pesa
        return true; 
      } else {
        // O Backend retornou erro (ex: falha na API do M-Pesa)
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? "Erro no processamento");
      }
    } catch (e) {
      print("❌ Erro Técnico: $e");
      throw Exception("Falha de conexão. O Backend está rodando?");
    }
  }
}