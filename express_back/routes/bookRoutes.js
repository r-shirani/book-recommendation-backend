const express = require("express");
const authMiddleware = require("../middlewares/authMiddleware");
const { searchBook, getBookImage , popularBooks } = require("../controllers/bookController");

const router = express.Router();

router.get("/search", searchBook );
router.get("/image/:bookid",getBookImage);
router.get("/popularBooks",popularBooks);

module.exports = router;
