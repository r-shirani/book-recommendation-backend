const express = require("express");
const authMiddleware = require("../middlewares/authMiddleware");
const { getUser_Collections, postUser_Collection, getAnotherUser_Collections, details_collection, proxyGetCollectionImage, proxyUploadCollectionImage, proxyUploadCollection, deleteCollection_controller, deleteCollectionDetails_controller, getAllCollections } = require("../controllers/collectionController");
const multer = require('multer');
const upload = multer();
const router = express.Router();

router.get("/user", authMiddleware , getUser_Collections );
router.get("/all",getAllCollections);
router.get("/anotherUser/:userid" , getAnotherUser_Collections );
router.post("/user", authMiddleware , postUser_Collection );
router.get("/details",details_collection);
router.get("/pic/:collectionid" , proxyGetCollectionImage);
router.post('/pic/:collectionid', upload.single('file'), proxyUploadCollectionImage);
router.post('/upload-collection', upload.single('file'), proxyUploadCollection);
router.delete("/delete-collection",deleteCollection_controller);
router.delete("/delete-collection-details",deleteCollectionDetails_controller);
module.exports = router;
