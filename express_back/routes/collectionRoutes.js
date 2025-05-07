const express = require("express");
const authMiddleware = require("../middlewares/authMiddleware");
const { getUser_Collections, postUser_Collection, getAnotherUser_Collections } = require("../controllers/collectionController");

const router = express.Router();

router.get("/user", authMiddleware , getUser_Collections );
router.get("/anotherUser/:userid" , getAnotherUser_Collections );
router.post("/user", authMiddleware , postUser_Collection );

module.exports = router;
