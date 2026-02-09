const express = require('express');
const cors = require('cors');
const odooService = require('./services/odooService'); // Seu serviço de produtos
const mpesaService = require('./services/mpesaService'); // <--- IMPORTANTE: Importar o serviço do M-Pesa

const app = express();

app.use(cors());
app.use(express.json());

// --- ROTA DE TESTE (Para ver se o servidor está vivo) ---
app.get('/', (req, res) => {
    res.send('Servidor Pemaro Backend está rodando! 🚀');
});

// --- ROTA DE PRODUTOS ---
app.get('/api/products', async (req, res) => {
    try {
        const products = await odooService.getProducts();
        res.json(products);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// --- NOVA ROTA DE PAGAMENTO (A que estava faltando!) ---
app.post('/api/payment/initiate', async (req, res) => {
    const { method, phone, amount } = req.body;

    console.log(`📡 Recebido pedido de pagamento: ${method} | ${phone} | ${amount} MT`);

    if (method === 'mpesa') {
        try {
            // Chama o nosso serviço que fala com a e2payments
            const result = await mpesaService.initiateC2B(phone, amount);

            console.log("✅ Sucesso API:", result);

            // Retorna sucesso para o Flutter
            res.status(200).json({
                success: true,
                message: "Pedido enviado com sucesso",
                details: result
            });

        } catch (error) {
            console.error("❌ Falha no Pagamento:", error.message);
            res.status(500).json({
                success: false,
                message: "Falha ao processar pagamento",
                error: error.message
            });
        }
    } else {
        // Simulação para E-Mola (se não tiver API ainda)
        console.log("⚠️ Método não implementado ainda:", method);
        setTimeout(() => {
            res.status(200).json({ success: true, message: "E-Mola Simulado (Sucesso)" });
        }, 2000);
    }
});

const PORT = process.env.PORT || 3000;

// Esta verificação garante que o app.listen só roda no seu computador (local)
// No Vercel, ele ignora isso e usa o "module.exports"
if (require.main === module) {
    app.listen(PORT, () => {
        console.log(`🔥 Servidor Backend rodando na porta ${PORT}`);
    });
}

// OBRIGATÓRIO PARA O VERCEL: Exportar o app
module.exports = app;