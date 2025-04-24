const express = require("express");
const authMiddleware = require("../middlewares/authMiddleware");
const { newComment, getAllCommentBook, getRefComments, likeComment, dislikeComment } = require("../controllers/commentController");
const { validateComment } = require("../validators/commentValidator");

const router = express.Router();





module.exports = router;