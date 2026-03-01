import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'dart:typed_data';
import 'package:printing/printing.dart';

// Contador global para o número da cotação
int _cotacaoCounter = 1;

Future<void> gerarEDescarregarPDF(
  String nomeCliente,
  String endereco,
  String nuit,
  List<Map<String, dynamic>> itens,
  double subtotal,
  double iva,
  double total,
) async {
  final pdf = pw.Document();
  final dateFormat = DateFormat('dd/MM/yyyy');
  final currencyFormat = NumberFormat.currency(locale: 'pt_MZ', symbol: 'MZN ');
  final now = DateTime.now();

  try {
    // Geração do número da cotação
    String cotacaoNumero =
        'ST${_cotacaoCounter.toString().padLeft(4, '0')}/2026';
    _cotacaoCounter++;

    // Estilos de Texto
    final titleStyle = pw.TextStyle(
      fontSize: 14,
      fontWeight: pw.FontWeight.bold,
    );
    final headerStyle = pw.TextStyle(
      fontSize: 10,
      fontWeight: pw.FontWeight.bold,
    );
    final normalStyle = const pw.TextStyle(fontSize: 9);
    final darkGrey = PdfColor.fromHex('#333333');

    // Construção da Página do PDF
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Cabeçalho da Empresa (Stone Trading)
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'STONE TRADING',
                        style: pw.TextStyle(
                          fontSize: 22,
                          fontWeight: pw.FontWeight.bold,
                          color: darkGrey,
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        'Especialistas em Rochas Ornamentais',
                        style: normalStyle,
                      ),
                      pw.Text('Maputo, Moçambique', style: normalStyle),
                      pw.Text(
                        'Email: info@stonetrading.co.mz',
                        style: normalStyle,
                      ),
                      pw.Text('NUIT: 400000000', style: normalStyle),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('Cotação N° $cotacaoNumero', style: titleStyle),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        'Data: ${dateFormat.format(now)}',
                        style: normalStyle,
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 25),

              // Bloco de Dados do Cliente
              pw.Container(
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey400, width: 1),
                  borderRadius: const pw.BorderRadius.all(
                    pw.Radius.circular(4),
                  ),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Cliente: $nomeCliente', style: headerStyle),
                    pw.SizedBox(height: 4),
                    pw.Text('Endereço: $endereco', style: normalStyle),
                    pw.SizedBox(height: 4),
                    pw.Text('NUIT: $nuit', style: normalStyle),
                  ],
                ),
              ),
              pw.SizedBox(height: 25),

              // Tabela de Produtos
              pw.TableHelper.fromTextArray(
                headers: ['Item', 'Qtd', 'Preço Unit.', 'Subtotal'],
                headerStyle: headerStyle.copyWith(color: PdfColors.white),
                headerDecoration: pw.BoxDecoration(color: darkGrey),
                cellStyle: normalStyle,
                cellAlignments: {
                  0: pw.Alignment.centerLeft,
                  1: pw.Alignment.center,
                  2: pw.Alignment.centerRight,
                  3: pw.Alignment.centerRight,
                },
                data: itens
                    .map(
                      (item) => [
                        item['nome'].toString(),
                        item['quantidade'].toString(),
                        currencyFormat.format(item['preco_unitario'] ?? 0.0),
                        currencyFormat.format(item['sub_Total'] ?? 0.0),
                      ],
                    )
                    .toList(),
              ),
              pw.SizedBox(height: 20),

              // Resumo Financeiro (Totais)
              pw.Container(
                alignment: pw.Alignment.centerRight,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text(
                      'Subtotal: ${currencyFormat.format(subtotal)}',
                      style: normalStyle,
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      'IVA (16%): ${currencyFormat.format(iva)}',
                      style: normalStyle,
                    ),
                    pw.SizedBox(height: 6),
                    pw.Text(
                      'TOTAL: ${currencyFormat.format(total)}',
                      style: titleStyle,
                    ),
                  ],
                ),
              ),

              // Rodapé com Informações Bancárias
              pw.Spacer(),
              pw.Divider(color: PdfColors.grey400),
              pw.SizedBox(height: 5),
              pw.Text(
                'Referências Bancárias (Stone Trading):',
                style: headerStyle,
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                'Millennium Bim - Conta: 123456789 | NIB: 000100000000000000000',
                style: normalStyle,
              ),
              pw.SizedBox(height: 2),
              pw.Text('Validade da Cotação: 15 dias', style: normalStyle),
              pw.SizedBox(height: 10),
              pw.Center(
                child: pw.Text(
                  'Documento processado por computador.',
                  style: pw.TextStyle(fontSize: 7, color: PdfColors.grey600),
                ),
              ),
            ],
          );
        },
      ),
    );

    // Salva o PDF na memória e força o download
    final Uint8List pdfBytes = await pdf.save();

    // O pacote printing lida com o download automático no browser
    await Printing.sharePdf(
      bytes: pdfBytes,
      filename:
          'Cotacao_StoneTrading_${cotacaoNumero.replaceAll('/', '_')}.pdf',
    );
  } catch (e) {
    print('Erro ao gerar PDF: $e');
  }
}
