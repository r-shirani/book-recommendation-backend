const express = require("express");
const authMiddleware = require("../middlewares/authMiddleware");
const { newComment, getAllCommentBook } = require("../controllers/commentController");
const { validateComment } = require("../validators/commentValidator");

const router = express.Router();

router.post("/comment",authMiddleware ,validateComment , newComment );
router.get("/comment/book",getAllCommentBook);


module.exports = router;
