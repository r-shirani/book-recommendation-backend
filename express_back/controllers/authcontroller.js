const User = require("../models/User");
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

    const hashedPassword = await bcrypt.hash(password, 10);

    user = new User({ name, email, password: hashedPassword });
    await user.save();

    res.status(201).json({ message:"registered successfully" });
  } catch (error) {
    console.log(error);
    console.log(req.body);
    res.status(500).json({ message: "server error"});
  }
};

const verificationCodes = {};
exports.login = async (req, res) => {
  const { username, password, email } = req.body;

  const user = User.findOne({email});

  if (!user) {
    return res.status(401).send('نام کاربری یا رمز عبور اشتباه است');
  }

  // generate the 6 digit verification code
  const verificationCode = Math.floor(100000 + Math.random() * 900000);
  verificationCodes[email] = verificationCode;

  // send the verification code
  await sendVerificationCode(email, verificationCode)
    .then(() => res.send('کد تأیید به ایمیل شما ارسال شد'))
    .catch((err) => res.status(500).send('خطا در ارسال ایمیل'));

  console.log(`کد تأیید برای ${email}: ${verificationCode}`); // print on console
};

exports.verifyCode = (req, res) => {
  const { email, code } = req.body;

  if (verificationCodes[email] && verificationCodes[email] == code) {
    delete verificationCodes[email]; // delete after use
    res.send('ورود موفقیت‌آمیز بود');
  } else {
    res.status(400).send('کد تأیید اشتباه است');
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
