// src/controllers/productController.js
const odooService = require('../services/odooService');

exports.getAllProducts = async (req, res) => {
    try {
        const products = await odooService.getProducts();
        res.status(200).json(products);
    } catch (error) {
        res.status(500).json({ message: "Erro ao buscar produtos", error: error.message });
    }
};