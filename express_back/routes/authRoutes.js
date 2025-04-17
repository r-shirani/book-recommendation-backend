const express = require("express");
const { register, login, getProfile ,verifyCode, googleLogin, newPassword,updateProfile} = require("../controllers/authcontroller");
const authMiddleware = require("../middlewares/authMiddleware");
const { validateRegister, validateLogin } = require("../validators/authValidator");
const { getUserGenres, updateUserGenres, getAllGenres } = require("../controllers/genresController");


const router = express.Router();

router.post("/register",validateRegister ,register);
router.post("/login",validateLogin ,login);
router.get("/profile", authMiddleware, getProfile);  // protected with token 
router.put("/newPassword",authMiddleware, newPassword);  
router.post('/verify-code', verifyCode);
router.post("/google-login",googleLogin);
router.put("/updateProfile",authMiddleware,updateProfile);   
router.get("/genres",authMiddleware,getUserGenres);  
router.put("/genres",authMiddleware,updateUserGenres);  
router.get("/allgenres",getAllGenres);


module.exports = router;
