const express = require("express");
const authMiddleware = require("../middlewares/authMiddleware");
const { searchBook, getBookImage , popularBooks, searchBook_with_image, like_book, dislike_book, favoritBooks } = require("../controllers/bookController");

const router = express.Router();

router.get("/search", searchBook_with_image );
router.get("/searchurl/:searchterm",searchBook)
router.get("/image/:bookid",getBookImage);
router.get("/popularBooks",popularBooks);
router.post("/like" ,authMiddleware , like_book );
router.delete("/dislike" ,authMiddleware , dislike_book );
router.get("/favorit" , authMiddleware , favoritBooks);
router.get('/detail', bookController.getBookDetail);

module.exports = router;
