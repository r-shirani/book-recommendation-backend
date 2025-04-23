const express = require("express");
const authMiddleware = require("../middlewares/authMiddleware");
const { newComment, getAllCommentBook, getRefComments } = require("../controllers/commentController");
const { validateComment } = require("../validators/commentValidator");

const router = express.Router();

router.post("/comment",authMiddleware ,validateComment , newComment );
router.get("/comment/book",getAllCommentBook);
router.get("/comment/ref",getRefComments);

module.exports = router;
