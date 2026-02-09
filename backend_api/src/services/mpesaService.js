// backend_api/src/services/mpesaService.js
const axios = require('axios');

// --- CONFIGURAÇÕES DA API E2PAYMENTS ---
const API_URL = "https://e2payments.explicador.co.mz/v1/c2b/mpesa-payment/390841";
const CLIENT_ID = "9d1a0e7b-9785-4087-8857-c461fefeb1dc";
const ACCESS_TOKEN = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiI5ZDFhMGU3Yi05Nzg1LTQwODctODg1Ny1jNDYxZmVmZWIxZGMiLCJqdGkiOiJkMWNjYTI2NGU3MWZmYWEyZDA4ZjZhZTYxNjg3Y2NlZGE0MTRmNjA0MTQzZmViNTJmMGFhZjBjNmUxOWMzNjM2Zjc3NzA3ODE2NjM2MGJkMiIsImlhdCI6MTc3MDY1Mzc1Mi4zNzM2MTcsIm5iZiI6MTc3MDY1Mzc1Mi4zNzM2MiwiZXhwIjoxODAyMTg5NzUyLjM2OTc2MSwic3ViIjoiIiwic2NvcGVzIjpbXX0.pVOdfPrEhYlFjZ6gQOILYOa3P31qnNozVRhkczCsDLC_MUSmVnKuRbrKAMguevCqUKU9CNnlZkf3gWIcvOjAi04uN0FQoHidj4v-kHfizOm0IvxBqXf1Y5HiB3OyJWlGSFfmsrp4Gtqsed5Qwc24X95gyNYQ16xXM74O6hCitzsxahHeLIH_K9eCdNnbHf520Ck3Ox46FX6NQXmN8H7X7pIBTO4UwZtd0DHsYjgLx_17v2vhC5i1rxHBPSplF4YyD81VgUOmZ__SgA2zqQzksj2Z8yxw6EpTWP2rfUVZreF6IS3v6P_lPV8b8xLnfiAcxxTNKVjSG7cnR7ofaKrwOR3xrvAzZ6HMEk8WB4vB6bgkLsRC46LRFszA31QjKwwD9i6SeUWTYSIx3uCeFE5YkpgQ75hvSut1rd90cNK9Q4O0R_pGCoy-Yxf4bQvySLNOgxuIde8JYYtT9nLz27cUltzVmL51lxjQzhfO7ZA96SGwNyziPCV-qTMeWjbCTBvgMI4wEvLPnPkMIvDfbRXKTbEggbXeBkAWWAE-jZQaIRUBPodFGY_WN41bBt10Kz4nim0i-W5izRaUOGG0cE0mmkXy8lg4S6Gulcl8vYhSz-eLj57A6qqInCM4dtUJA1-Tl96uMkxSSBuDVR5OCIB-W4660Q5qD8PY3QqSUrog3tA";

class MpesaService {

    async initiateC2B(phoneNumber, amount) {

        // 1. Limpeza do número
        let phone = phoneNumber.replace(/\D/g, ''); // Remove não dígitos

        // Remove 258 se tiver
        if (phone.startsWith('258') && phone.length === 12) {
            phone = phone.substring(3);
        }

        // 2. CORREÇÃO CRÍTICA DA REFERÊNCIA
        // Em vez de "REF-" + Date.now(), vamos usar apenas 5 números aleatórios.
        // A API vai transformar "12345" em "e2P12345NTMT", que é curto o suficiente.
        const referencia = Math.floor(10000 + Math.random() * 90000).toString();

        const payload = {
            "client_id": CLIENT_ID,
            "amount": amount.toString(),
            "phone": phone,
            "reference": referencia // Agora é curtinha!
        };

        console.log("📤 Enviando para E2Payments:", payload);

        try {
            const response = await axios.post(
                API_URL,
                payload,
                {
                    headers: {
                        'Authorization': `Bearer ${ACCESS_TOKEN}`,
                        'Content-Type': 'application/json',
                        'Accept': 'application/json'
                    }
                }
            );

            return response.data;

        } catch (error) {
            console.error("❌ Erro na E2Payments:");
            if (error.response) {
                console.error("Dados:", JSON.stringify(error.response.data, null, 2));
                throw new Error(JSON.stringify(error.response.data));
            } else {
                console.error("Mensagem:", error.message);
                throw new Error("Falha na conexão com o servidor de pagamento.");
            }
        }
    }
}

module.exports = new MpesaService();