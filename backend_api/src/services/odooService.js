// src/services/odooService.js

const mockProducts = [
    // --- MÁRMORES ---
    {
        id: 1,
        name: "Mármore Carrara Premium",
        category: "Mármore", // Campo Novo
        price: 5500,
        qty: 120,
        description: "Mármore italiano branco com veios cinzas distintos.",
        image: "https://i.pinimg.com/736x/4c/ad/ca/4cadca1e8a0c78cb1ef29247c75893c3.jpg"
    },
    {
        id: 5,
        name: "Mármore Nero Marquina",
        category: "Mármore",
        price: 6800,
        qty: 45,
        description: "Mármore preto profundo com veios brancos contrastantes.",
        image: "https://i.pinimg.com/1200x/ee/05/cf/ee05cf222eaf436788470575d05ceb30.jpg"
    },

    // --- GRANITOS ---
    {
        id: 2,
        name: "Granito Preto Absoluto",
        category: "Granito",
        price: 3200,
        qty: 50,
        description: "Pedra de alta resistência e cor profunda.",
        image: "https://i.pinimg.com/736x/70/e9/3e/70e93e65335f48e7ebdecb8870252f60.jpg"
    },
    {
        id: 6,
        name: "Granito Cinza Andorinha",
        category: "Granito",
        price: 2100,
        qty: 200,
        description: "Granito clássico, resistente e com ótimo custo-benefício.",
        image: "https://i.pinimg.com/736x/b7/1f/c5/b71fc52078a009c80fb02ec848ab9988.jpg"
    },

    // --- QUARTZO ---
    {
        id: 4,
        name: "Quartzo Calacatta Gold",
        category: "Quartzo",
        price: 8000,
        qty: 15,
        description: "Superfície manufaturada com veios dourados luxuosos.",
        image: "https://i.pinimg.com/736x/c0/12/5b/c0125b46812ae248c1506885eaf92ca0.jpg"
    },
    {
        id: 7,
        name: "Quartzo Cinza Estelar",
        category: "Quartzo",
        price: 7500,
        qty: 80,
        description: "Quartzo cinza moderno com pequenos pontos de brilho.",
        image: "https://i.pinimg.com/736x/7a/d9/87/7ad987b5eeb0e216fa08c13dafb72edb.jpg"
    },

    // --- ÔNIX E TRAVERTINO ---
    {
        id: 3,
        name: "Travertino Romano",
        category: "Mármore", // Classificamos como Mármore para simplificar ou crie categoria Travertino
        price: 6100,
        qty: 30,
        description: "Clássico, rústico e elegante.",
        image: "https://i.pinimg.com/1200x/fb/7f/68/fb7f68a626523565ebb29f8b68a39d2d.jpg"
    },
    {
        id: 8,
        name: "Ônix Mel Translúcido",
        category: "Ônix",
        price: 12000,
        qty: 10,
        description: "Pedra exótica que permite a passagem de luz. Luxo puro.",
        image: "https://i.pinimg.com/736x/90/9a/ca/909aca0dbcead5849f9ab85004181857.jpg"
    }
];

class OdooService {
    async getProducts() {
        return new Promise((resolve) => {
            setTimeout(() => {
                console.log("🛠️ OdooService: Enviando 8 produtos com categorias...");
                resolve(mockProducts);
            }, 500);
        });
    }
}

module.exports = new OdooService();