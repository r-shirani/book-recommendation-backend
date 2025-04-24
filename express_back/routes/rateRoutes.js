const express = require("express");
const authMiddleware = require("../middlewares/authMiddleware");
const { newComment, getAllCommentBook, getRefComments, likeComment, dislikeComment } = require("../controllers/commentController");
const { validateComment } = require("../validators/commentValidator");
const { postRateController } = require("../controllers/rateController");

const router = express.Router();


router.post("/rate",authMiddleware ,postRateController);


module.exports = router;