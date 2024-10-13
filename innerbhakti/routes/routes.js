const express = require('express');
const router = express.Router();
const multer = require('multer');
const Controller = require('../controllers/upload');

// Multer configuration for handling file uploads
const upload = multer({
  storage: multer.memoryStorage()  // Memory storage for temporary buffer
});

// Define the route to handle uploads
router.post('/upload', upload.fields([{ name: 'image' }, { name: 'audio' }]), Controller.uploadFiles);
router.get('/files',  Controller.getFiles);

module.exports = router