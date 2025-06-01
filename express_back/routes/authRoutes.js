const express = require("express");
const { register, login, getProfile ,verifyCode, googleLogin, newPassword,updateProfile, sendEmailPassCode, forgetPassword_code, settingNewPassword, getUserProfileImage, getUserProfileImage_token, updateMBTI,GetMBTI, getProfile_AnotherUser} = require("../controllers/authcontroller");
const authMiddleware = require("../middlewares/authMiddleware");
const { validateRegister, validateLogin } = require("../validators/authValidator");
const { getUserGenres, updateUserGenres, getAllGenres } = require("../controllers/genresController");

const router = express.Router();

router.post("/register",validateRegister ,register);
router.post("/login",validateLogin ,login);
router.get("/profile", authMiddleware, getProfile);  // protected with token 
router.get("/profile-another-user" , getProfile_AnotherUser);
router.put("/newPassword",authMiddleware, newPassword);  
router.post('/verify-code', verifyCode);
router.post("/google-login",googleLogin);
router.put("/updateProfile",authMiddleware,updateProfile);   
router.get("/genres",authMiddleware,getUserGenres);  
router.put("/genres",authMiddleware,updateUserGenres);  
router.get("/allgenres",getAllGenres);
router.post("/send-verify-code-pass" , sendEmailPassCode);
router.post("/verify-code-pass" , forgetPassword_code);
router.put("/settingNewPassword" , settingNewPassword);
router.get("/profilePic/:userid" ,getUserProfileImage);
router.get("/profilePicToken" ,authMiddleware ,getUserProfileImage_token);
router.put("/MBTI-update",authMiddleware,updateMBTI); // Update MBTI type for the user
router.get("/MBTI",authMiddleware,GetMBTI); // Get MBTI type for the user

module.exports = router;
