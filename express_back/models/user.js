const mongoose = require('mongoose');
const userSchema = new mongoose.Schema({
  userId: String,
  username: String,
  chatPartners: [String],
});
module.exports = mongoose.model('User', userSchema);