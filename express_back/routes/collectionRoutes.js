const express = require("express");
const authMiddleware = require("../middlewares/authMiddleware");
const { getUser_Collections, postUser_Collection, getAnotherUser_Collections, details_collection, proxyGetCollectionImage, proxyUploadCollectionImage, proxyUploadCollection } = require("../controllers/collectionController");
const multer = require('multer');
const upload = multer();
const router = express.Router();

router.get("/user", authMiddleware , getUser_Collections );
router.get("/anotherUser/:userid" , getAnotherUser_Collections );
router.post("/user", authMiddleware , postUser_Collection );
router.get("/details",details_collection);
router.get("/pic/:collectionid" , proxyGetCollectionImage);
router.post('/pic/:collectionid', upload.single('file'), proxyUploadCollectionImage);
router.post('/upload-collection', upload.single('file'), proxyUploadCollection);
module.exports = router;
