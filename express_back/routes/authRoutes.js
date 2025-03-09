const express = require("express");
const { register, login, getProfile } = require("../controllers/authcontroller");
const authMiddleware = require("../middlewares/authMiddleware");

const router = express.Router();

router.post("/register", register);
router.post("/login", login);
router.get("/profile", authMiddleware, getProfile);  // protected with token ()

module.exports = router;
