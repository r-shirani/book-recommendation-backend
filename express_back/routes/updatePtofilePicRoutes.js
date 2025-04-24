// routes/uploadRoutes.js
const router  = require('express').Router();
const upload  = require('../middlewares/memoryMulter');
const { proxyUpload } = require('../controllers/updateProfilePicController');
const authMiddleware = require("../middlewares/authMiddleware");

router.post('/upload',authMiddleware, upload.single('file'), proxyUpload);

module.exports = router;
