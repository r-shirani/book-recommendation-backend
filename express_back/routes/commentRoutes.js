const express = require("express");
const authMiddleware = require("../middlewares/authMiddleware");
const { newComment, getAllCommentBook, getRefComments, likeComment, dislikeComment } = require("../controllers/commentController");
const { validateComment } = require("../validators/commentValidator");

const router = express.Router();

router.post("/comment",authMiddleware ,validateComment , newComment );
router.get("/comment/book/:bookid",getAllCommentBook);
router.get("/comment/ref/:commentid",getRefComments);
router.put("/comment/like",likeComment);
router.put("/comment/dislike",dislikeComment);

module.exports = router;
