const express = require('express');
const { initializeApp, cert } = require('firebase-admin/app');
const mongoose = require('mongoose');
require('dotenv').config();

// Firebase Initialization
const serviceAccount = require('./resolute-e8cac-firebase-adminsdk-2po81-ef86825ca8.json');
initializeApp({
  credential: cert(serviceAccount),
  storageBucket: `${process.env.FIREBASE_PROJECT_ID}.appspot.com`
});

// MongoDB connection
mongoose.connect(process.env.MONGODB_URI, {
  useNewUrlParser: true,
  useUnifiedTopology: true
}).then(() => console.log('MongoDB connected'))
  .catch((err) => console.error('MongoDB connection error:', err));

// Initialize Express app
const app = express();
app.use(express.json());

// Routes
const uploadRoutes = require('./routes/routes');
app.use('/api', uploadRoutes);

// Start the server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
