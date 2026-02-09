// src/routes/productRoutes.js
const express = require('express');
const router = express.Router();
const productController = require('../controllers/productController');

// Quando alguém acessar '/', chama o controller
router.get('/', productController.getAllProducts);

module.exports = router;