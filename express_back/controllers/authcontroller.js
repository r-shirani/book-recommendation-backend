const User = require("../models/User");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");

exports.register = async (req, res) => {
  try {
    const { name, email, password } = req.body;
    let user = await User.findOne({ email });

    if (user) return res.status(400).json({ message: "کاربر قبلاً ثبت شده است" });

    const hashedPassword = await bcrypt.hash(password, 10);

    user = new User({ name, email, password: hashedPassword });
    await user.save();

    res.status(201).json({ message: "ثبت‌نام با موفقیت انجام شد" });
  } catch (error) {
    console.log(error);
    console.log(req.body);
    res.status(500).json({ message: "خطای سرور" });
  }
};






exports.login = async (req, res) => {
  try {
    const { email, password } = req.body;
    const user = await User.findOne({ email });

    if (!user) return res.status(400).json({ message: "کاربر یافت نشد" });

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) return res.status(400).json({ message: "رمز عبور نادرست است" });

    const token = jwt.sign({ id: user._id }, process.env.JWT_SECRET, { expiresIn: "1h" });

    res.json({ token, user: { id: user._id, name: user.name, email: user.email } });
  } catch (error) {
    res.status(500).json({ message: "خطای سرور" });
  }
};




exports.getProfile = async (req, res) => {
  try {
    res.json({ 
      message: "پروفایل کاربر", 
      user: { id: req.user.id, name: req.user.name, email: req.user.email } 
    });
  } catch (error) {
    res.status(500).json({ message: "خطای سرور" });
  }
};
