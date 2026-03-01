import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'digital_quotation_screen.dart';

class QuotationFormScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems; // Itens que vêm do carrinho
  final double subtotal;

  const QuotationFormScreen({
    super.key,
    required this.cartItems,
    required this.subtotal,
  });

  @override
  State<QuotationFormScreen> createState() => _QuotationFormScreenState();
}

class _QuotationFormScreenState extends State<QuotationFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _enderecoController = TextEditingController();
  final _nuitController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "DADOS DA COTAÇÃO",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Preencha os seus dados para emitirmos o documento oficial:",
                style: GoogleFonts.lato(fontSize: 16),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome Completo ou Empresa',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _enderecoController,
                decoration: const InputDecoration(
                  labelText: 'Endereço (Ex: Maputo, Matola)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _nuitController,
                decoration: const InputDecoration(
                  labelText: 'NUIT',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DigitalQuotationScreen(
                            nome: _nomeController.text,
                            endereco: _enderecoController.text.isEmpty
                                ? 'Moçambique'
                                : _enderecoController.text,
                            nuit: _nuitController.text.isEmpty
                                ? '999999999'
                                : _nuitController.text,
                            items: widget.cartItems,
                            subtotal: widget.subtotal,
                          ),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    "GERAR COTAÇÃO",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
