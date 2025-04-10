const express = require("express");
const authMiddleware = require("../middlewares/authMiddleware");
const { searchBook, getBookImage , popularBooks, searchBook_with_image } = require("../controllers/bookController");

const router = express.Router();

router.get("/search", searchBook_with_image );
router.get("/image/:bookid",getBookImage);
router.get("/popularBooks",popularBooks);

module.exports = router;
