const { getStorage } = require('firebase-admin/storage');
const File = require('../models/program');
const bucket = getStorage().bucket();

// Helper function to upload a file to Firebase Storage and return its public URL
const uploadFileToFirebase = (file, fileName) => {
  return new Promise((resolve, reject) => {
    const fileUpload = bucket.file(fileName);
    const blobStream = fileUpload.createWriteStream({
      metadata: {
        contentType: file.mimetype
      }
    });

    blobStream.on('error', (error) => reject(error));
    blobStream.on('finish', async () => {
      await fileUpload.makePublic();
      const publicUrl = `https://storage.googleapis.com/${bucket.name}/${fileName}`;
      resolve(publicUrl);
    });

    blobStream.end(file.buffer);
  });
};

// Controller function to handle file uploads
exports.uploadFiles = async (req, res) => {
  try {
    const { description,title ,author,slogun} = req.body;
    const image = req.files['image'] ? req.files['image'][0] : null;
    const audio = req.files['audio'] ? req.files['audio'][0] : null;

    if (!image || !audio) {
      return res.status(400).send('Both image and audio files are required.');
    }

    // Create unique filenames for both files
    const imageFileName = Date.now() + '-image-' + image.originalname;
    const audioFileName = Date.now() + '-audio-' + audio.originalname;

    // Upload both files to Firebase Storage
    const imageUrl = await uploadFileToFirebase(image, imageFileName);
    const audioUrl = await uploadFileToFirebase(audio, audioFileName);

    // Store file metadata in MongoDB
    const fileData = new File({
      image:imageUrl,
      audio: audioUrl,
      description: description || 'No description provided',
      title: title || 'No title',
      author: author || 'No author',
      slogun: slogun || 'No slogun',
    });

    await fileData.save();

    res.status(201).json({
      message: 'Files uploaded successfully and stored in MongoDB',
      data: fileData
    });

  } catch (error) {
    console.error('Error during upload:', error);
    res.status(500).json({ error: 'Something went wrong during the upload process.' });
  }
};

// fetch
exports.getFiles =  async (req, res) => {
  try {
    
    const files = await File.find();
    res.status(200).json(files);
  } catch (error) {
    res.status(500).json({ error: 'Failed to fetch files' });
  }
};