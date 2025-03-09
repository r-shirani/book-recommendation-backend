const jwt = require("jsonwebtoken");

module.exports = (req, res, next) => {
  const token = req.header("Authorization");
  if (!token) return res.status(401).json({ message: "please login again not allowed" });
  maintoken = token.split(" ")[1];
  try {
    const decoded = jwt.verify(maintoken, process.env.JWT_SECRET);
    req.user = decoded;
    next();
  } catch (err) {
    if (err.name === "TokenExpiredError") {
      return res.status(401).json({ message: "token expired please login again" });
    }
    res.status(401).json({ message: "invalid token" });
  }
};
