import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'cart_service.dart';
import 'checkout_screen.dart';
import 'quotation_form_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Instância do Carrinho
  final CartService cart = CartService();

  @override
  Widget build(BuildContext context) {
    // 1. ADICIONAMOS O LISTENABLE BUILDER AQUI
    // Isto obriga a tela inteira a atualizar sempre que o CartService mudar!
    return ListenableBuilder(
      listenable: cart,
      builder: (context, child) {
        // Pega os itens reais ATUALIZADOS
        final cartItems = cart.items;

        return Scaffold(
          backgroundColor: const Color(0xFFFBFBF9),
          appBar: AppBar(
            backgroundColor: const Color(0xFFFBFBF9).withOpacity(0.9),
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black87,
                size: 20,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              "Carrinho & Cotação",
              style: GoogleFonts.lato(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: Colors.black87,
              ),
            ),
          ),
          body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // CABEÇALHO DA LISTA
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Pedras Selecionadas",
                              style: GoogleFonts.lato(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: Colors.black87,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFD4AF37).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "${cartItems.length} Itens",
                                style: GoogleFonts.lato(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFFD4AF37),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),

                        // LISTA DE ITENS REFORÇADA
                        cartItems.isEmpty
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(40.0),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.shopping_cart_outlined,
                                        size: 60,
                                        color: Colors.grey[300],
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        "Seu carrinho está vazio",
                                        style: TextStyle(
                                          color: Colors.grey[400],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: cartItems.length,
                                itemBuilder: (context, index) {
                                  final item = cartItems[index];

                                  final String name =
                                      item['name'] ??
                                      item['display_name'] ??
                                      'Pedra Selecionada';
                                  final String category =
                                      item['category'] ?? 'Pedra';
                                  final String qty =
                                      item['qty']?.toString() ?? '1';

                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 15),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: Colors.grey[200]!,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.02),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 70,
                                          height: 70,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            color: Colors.grey[100],
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            child:
                                                (item['image'] != null &&
                                                    item['image']
                                                        .toString()
                                                        .isNotEmpty)
                                                ? Image.network(
                                                    item['image'],
                                                    fit: BoxFit.cover,
                                                    errorBuilder:
                                                        (
                                                          context,
                                                          error,
                                                          stackTrace,
                                                        ) => const Icon(
                                                          Icons.broken_image,
                                                          color: Colors.grey,
                                                        ),
                                                  )
                                                : const Icon(
                                                    Icons.diamond_outlined,
                                                    color: Color(0xFFD4AF37),
                                                    size: 30,
                                                  ),
                                          ),
                                        ),
                                        const SizedBox(width: 15),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                name,
                                                style: GoogleFonts.lato(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                  color: Colors.black87,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                category,
                                                style: GoogleFonts.lato(
                                                  fontSize: 12,
                                                  color: const Color(
                                                    0xFF918255,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            _QtyButton(
                                              icon: Icons.remove,
                                              onTap: () {
                                                cart.decrementQty(
                                                  item['id'] ?? index,
                                                ); // Atualizado para usar lógica real
                                              },
                                            ),
                                            SizedBox(
                                              width: 40,
                                              child: Column(
                                                children: [
                                                  Text(
                                                    qty,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  Text(
                                                    "m²",
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.grey[400],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            _QtyButton(
                                              icon: Icons.add,
                                              onTap: () {
                                                cart.incrementQty(
                                                  item['id'] ?? index,
                                                ); // Atualizado para usar lógica real
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),

                        const SizedBox(height: 25),

                        // DETALHES DO PROJETO
                        Text(
                          "Detalhes do Projeto",
                          style: GoogleFonts.lato(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 15),
                        const _CustomTextField(
                          label: "NOME COMPLETO",
                          hint: "Ex: Edson Jose",
                        ),
                        const SizedBox(height: 12),
                        const _CustomTextField(
                          label: "TELEFONE",
                          hint: "+258 84 000 0000",
                          inputType: TextInputType.phone,
                        ),
                        const SizedBox(height: 12),
                        const _CustomTextField(
                          label: "ENDEREÇO DA OBRA",
                          hint: "Endereço completo para entrega",
                          maxLines: 3,
                        ),

                        const SizedBox(height: 30),

                        // RESUMO DE VALORES
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.grey[200]!,
                              style: BorderStyle.solid,
                            ),
                          ),
                          child: Column(
                            children: [
                              _SummaryRow(
                                label: "Subtotal Estimado",
                                value: "MZN ${cart.total.toStringAsFixed(0)}",
                              ),
                              const SizedBox(height: 10),
                              const _SummaryRow(
                                label: "Frete Estimado",
                                value: "A definir",
                                isItalic: true,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 15),
                                child: Divider(),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Total Estimado",
                                    style: GoogleFonts.lato(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "MZN ${cart.total.toStringAsFixed(0)}",
                                        style: GoogleFonts.lato(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w900,
                                          color: const Color(0xFFD4AF37),
                                        ),
                                      ),
                                      Text(
                                        "PREÇO PODE VARIAR POR LOTE",
                                        style: GoogleFonts.lato(
                                          fontSize: 9,
                                          color: Colors.grey[400],
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 160),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomSheet: Container(
            color: const Color(0xFFFBFBF9).withOpacity(0.95),
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      if (cartItems.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("O carrinho está vazio."),
                          ),
                        );
                        return;
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CheckoutScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD4AF37),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      shadowColor: const Color(0xFFD4AF37).withOpacity(0.4),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.shopping_bag_outlined, size: 22),
                        const SizedBox(width: 10),
                        Text(
                          "FINALIZAR COMPRA",
                          style: GoogleFonts.lato(
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      if (cartItems.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "O carrinho está vazio. Adicione pedras primeiro!",
                            ),
                          ),
                        );
                        return;
                      }

                      List<Map<String, dynamic>> itensParaCotacao = cartItems
                          .map((item) {
                            double price = (item['price'] ?? 0.0).toDouble();
                            int qty = (item['qty'] ?? 1).toInt();
                            String name =
                                item['name'] ?? item['display_name'] ?? 'Pedra';

                            return {
                              'nome': name,
                              'quantidade': qty,
                              'preco_unitario': price,
                              'sub_Total': price * qty,
                            };
                          })
                          .toList();

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuotationFormScreen(
                            cartItems: itensParaCotacao,
                            subtotal: cart.total,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.picture_as_pdf_outlined, size: 22),
                        const SizedBox(width: 10),
                        Text(
                          "BAIXAR COTAÇÃO (PDF)",
                          style: GoogleFonts.lato(
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
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

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _QtyButton({required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16, color: Colors.black87),
      ),
    );
  }
}

class _CustomTextField extends StatelessWidget {
  final String label;
  final String hint;
  final int maxLines;
  final TextInputType inputType;
  const _CustomTextField({
    required this.label,
    required this.hint,
    this.maxLines = 1,
    this.inputType = TextInputType.text,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Text(
            label,
            style: GoogleFonts.lato(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.grey[500],
              letterSpacing: 1.0,
            ),
          ),
        ),
        TextField(
          keyboardType: inputType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFD4AF37)),
            ),
          ),
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isItalic;
  const _SummaryRow({
    required this.label,
    required this.value,
    this.isItalic = false,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: isItalic ? Colors.grey : Colors.black87,
            fontWeight: FontWeight.w600,
            fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
          ),
        ),
      ],
    );
  }
}
