const { check } = require("express-validator");

exports.validateRegister = [
  check("name", "Name is required").not().isEmpty(),
  check("email", "Please enter a valid email").isEmail(),
  check("password", "Password must be at least 8 characters").isLength({ min: 8 }),
];

exports.validateLogin = [
  check("email", "Please enter a valid email").isEmail(),
  check("password", "Password is required").not().isEmpty(),
];