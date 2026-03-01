import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pdf_service.dart';

class DigitalQuotationScreen extends StatelessWidget {
  final String nome;
  final String endereco;
  final String nuit;
  final List<Map<String, dynamic>> items;
  final double subtotal;

  const DigitalQuotationScreen({
    super.key,
    required this.nome,
    required this.endereco,
    required this.nuit,
    required this.items,
    required this.subtotal,
  });

  @override
  Widget build(BuildContext context) {
    // Cálculos da Cotação
    double iva = subtotal * 0.16;
    double total = subtotal + iva;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "RESUMO DA COTAÇÃO",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho com dados do cliente
            Text(
              "Cliente: $nome",
              style: GoogleFonts.lato(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              "NUIT: $nuit | Endereço: $endereco",
              style: GoogleFonts.lato(fontSize: 14, color: Colors.grey[800]),
            ),
            const Divider(height: 30, thickness: 1.5),

            // Lista de Itens
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      item['nome'].toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "Qtd: ${item['quantidade']} x ${item['preco_unitario']} MT",
                    ),
                    trailing: Text(
                      "${item['sub_Total']} MT",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),
            ),

            const Divider(thickness: 1.5),

            // Totais
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Subtotal"),
                Text("${subtotal.toStringAsFixed(2)} MT"),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("IVA (16%)"),
                Text("${iva.toStringAsFixed(2)} MT"),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "TOTAL",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                ),
                Text(
                  "${total.toStringAsFixed(2)} MT",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Botão para Gerar e Baixar o PDF
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.download),
                label: const Text(
                  "DESCARREGAR COTAÇÃO (PDF)",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // Cor Stone Trading
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async {
                  // Feedback visual para o utilizador
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("A preparar o seu PDF..."),
                      duration: Duration(seconds: 2),
                    ),
                  );

                  // Chama a função para baixar
                  await gerarEDescarregarPDF(
                    nome,
                    endereco,
                    nuit,
                    items,
                    subtotal,
                    iva,
                    total,
                  );

                  // Verifica se o widget ainda está montado para evitar erros de contexto
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Download iniciado com sucesso!"),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
