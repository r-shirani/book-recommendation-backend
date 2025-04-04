const express = require("express");
const authMiddleware = require("../middlewares/authMiddleware");
const { newComment } = require("../controllers/commentController");
const { validateComment } = require("../validators/commentValidator");

const router = express.Router();

router.post("/comment",authMiddleware ,validateComment , newComment );

module.exports = router;
