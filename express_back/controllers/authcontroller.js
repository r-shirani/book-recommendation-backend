const User = require("../models/user");
const bcrypt = require("bcryptjs");
const { validationResult } = require("express-validator");
const jwt = require("jsonwebtoken");
const sendVerificationCode = require('../Auth/mailer');

exports.register = async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }
    const { name, email, password } = req.body;
    let user = await User.findOne({ email });

    if (user) return res.status(400).json({ message: "this user has already registered!" });

    // generate the 6 digit verification code
    const verificationCode = Math.floor(100000 + Math.random() * 900000);
    
    const hashedPassword = await bcrypt.hash(password, 10);
    const googleId = Math.floor(100000 + Math.random() * 900000);
    user = new User({ name, email, password: hashedPassword, isVerified: false, verificationCode , googleId});
    await user.save();

    // send the verification code
    await sendVerificationCode(email, verificationCode)
    .then(() => res.send('Verification code sent to email.'))
    .catch((err) => res.status(500).send('error in sending the verification email!'));

  } catch (error) {
    console.log(error);
    console.log(req.body);
    res.status(500).json({ message: "server error"});
  }
};

exports.login = async (req, res) => {
  try
  {
    const { username, password, email } = req.body;
    const user =await User.findOne({email});
    if (!user) {return res.status(400).send('User not found');}
    if (!user.isVerified) return res.status(400).json({ message: "Please verify your email first!" });
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) return res.status(400).json({ message: "wrong password" });
    else
    {
      const token = jwt.sign({ id: user._id }, process.env.JWT_SECRET, { expiresIn: "1h" });
      res.status(201).json({ 
        message: "Logged in successfully", 
        token, 
        user: { id: user._id, name: user.name, email: user.email } 
      });
    }
  }
  catch (error) {res.status(500).json({ message: "server error" })};

};

exports.verifyCode = async (req, res) => {
  try{
    const { email, code} = req.body;
    let user = await User.findOne({ email });
    if (!user) return res.status(400).json({ message: "User not found" });

    if (user.verificationCode == parseInt(code)) {
      user.isVerified = true;
      await user.save();
      res.json({ message: "User verified successfully. You can now log in." });
    } else {
      await User.deleteOne({ email });
      res.status(400).send('wrong verification code');
    }

  }catch(error){
    res.status(500).json({ message: "Server error" });
  }
};

exports.getProfile = async (req, res) => {
  try {
    res.json({ 
      message: "user profile", 
      user: { id: req.user.id, name: req.user.name, email: req.user.email } 
    });
  } catch (error) {
    res.status(500).json({ message:"server error" });
  }
};


exports.googleLogin = async (req , res)=>{
  try {
    const { token } = req.body;

    const googleUser = await axios.get(`https://www.googleapis.com/oauth2/v1/userinfo?access_token=${token}`, {
      headers: { Authorization: `Bearer ${token}` },
    });

    const { id, name, email, picture } = googleUser.data;

    let user = await User.findOne({ googleId: id });

    if (!user) {
      user = new User({
        googleId: id,
        name,
        email,
        avatar: picture,
      });
      await user.save();
    }

    const authToken = jwt.sign({ id: user._id }, process.env.JWT_SECRET, { expiresIn: "1h" });

    res.json({ token: authToken, user });
  } catch (error) {
    console.error(error);
    res.status(400).json({ message: "Google authentication failed" });
  }
};