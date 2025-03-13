
const mongoose = require("mongoose");

const UserSchema = new mongoose.Schema({
    googleId: { type: String, unique: true },
    email: { type: String, required: true, unique: true },
    name: { type: String },
    avatar: { type: String },
    password: { type: String, required: true },
    isVerified: { type: Boolean, default: false },
    verificationCode: { type: String },
    
}, { timestamps: true });

module.exports = mongoose.model("User", UserSchema);
