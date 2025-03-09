const express = require("express");
const { register, login, getProfile } = require("../controllers/authcontroller");
const authMiddleware = require("../middlewares/authMiddleware");
const { validateRegister, validateLogin } = require("../validators/authValidator");

const router = express.Router();

router.post("/register",validateRegister ,register);
router.post("/login",validateLogin ,login);
router.get("/profile", authMiddleware, getProfile);  // protected with token ()

module.exports = router;
