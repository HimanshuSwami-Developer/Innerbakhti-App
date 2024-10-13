const mongoose = require('mongoose');

const fileSchema = new mongoose.Schema({
  
  image: String,
  audio: String,
  title:String,
  author:String,
  slogun:String,
  description: String,
  createdAt: { type: Date, default: Date.now }
});

const File = mongoose.model('File', fileSchema);

module.exports = File;
