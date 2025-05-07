const bcrypt = require("bcryptjs");
const { validationResult } = require("express-validator");
const jwt = require("jsonwebtoken");
const sendVerificationCode = require('../Auth/mailer');

const { registerUSer_controller, getUserData, DeleteUser, EmailVerificationPut, updatePassword_controller, updateProfile_controller, updateVerifycode_controller } = require("../SQL/SQL-user-controller");
const { loginUser_controller } = require("../SQL/SQL-user-controller");
const { getUserByID } = require("../SQL/SQL-user-controller");

exports.register = async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }
    const { name, email, password } = req.body;
    // generate the 6 digit verification code
    const verificationCode = Math.floor(100000 + Math.random() * 900000);
    //hashing password
    const hashedPassword = await bcrypt.hash(password, 10);
    //creating random googleID
    const googleId = Math.floor(100000 + Math.random() * 900000);
    
    let user = await registerUSer_controller(email,name,hashedPassword,verificationCode);
    console.log(`USER LOGGED IN REGISTER : ${user}`);
    if(!user){
      // if(user.isEmailVerified === false)
      // {
      //   DeleteUser(email);
      //   return res.status(400).json({ message: "please register again" });
      // }
      return res.status(400).json({ message: "this user has already registered!" });
    }
    console.log(`new user data: ${email}  ${verificationCode} `);
    // send the verification code
    await sendVerificationCode(email, verificationCode)
    .then(() => res.send('Verification code sent to email.'))
    .catch((err) => res.status(500).send('error in sending the verification email!'));
  } catch (error) {
    console.log(error);
    console.log(req.body);
    res.status(500).json({ message: "server error"});
  }
};

exports.login = async (req, res) => {
  try
  {
    const {username , password , email } = req.body;
    let user = await loginUser_controller(email,password);
    console.log(user);
    if(user==-1)//not found
      return res.status(400).send('User not found');
    if(user==-2)//not verified
      return res.status(400).json({ message: "Please verify your email first!" });
    if(user>=0)//logged in
    {
      const token = jwt.sign({ id: user }, process.env.JWT_SECRET, { expiresIn: "48h" });
      res.status(201).json({ 
        message: "Logged in successfully", 
        token, 
        user: { id: user, name: username, email: email } 
      });
    }
    if(user==-3)//wrong pass
      return res.status(400).json({ message: "wrong password" });
  }
  catch (error) {
    res.status(500).json({ message: "server error" })
    console.log(error);
  };

};

exports.verifyCode = async (req, res) => {
  try{
    const { email, code} = req.body;
    let user = await getUserData(email);

    if (user.verificationCode == parseInt(code)) {
      console.log(user.userId);
      EmailVerificationPut(user.userId,true);
      res.json({ message: "User verified successfully. You can now log in." });
    } else {
      DeleteUser(email);
      res.status(400).send('wrong verification code');
    }

  }catch(error){
    res.status(500).json({ message: "Server error" });
  }
};


exports.sendEmailPassCode = async (req , res) => {
  try {
    const { email } = req.body;
    let user = await getUserData(email);
    const verificationCode = Math.floor(100000 + Math.random() * 900000);
    console.log(`userID : ${user.userId} pass verify code : ${verificationCode}`);
    let response = await updateVerifycode_controller(user.userId ,verificationCode);
    if(response === 1)
    {
      await sendVerificationCode.sendVerificationCode_password(email, verificationCode)
      .then(() => res.send('Verification code sent to email.'))
      .catch((err) => res.status(500).send('error in sending the verification email!'));
    }
    else
    {
      console.log("server error(SQL)_sendemail _ passcode");
      res.status(500).json({ message: "Server error" });
    }


  } catch (error) {
    console.log("server error(SQL)_sendemail _ passcode");
    res.status(500).json({ message: "Server error" });
  }
}


exports.forgetPassword_code = async (req , res) =>{
  try {
    const {email , code} = req.body;
    if(!code){
      res.status(400).json({ message: "code field is empty" });
    }
    let user = await getUserData(email);
    if (user.verificationCode == parseInt(code)) {
      console.log(`this ${user.userId} changing password (verififed code)`);
      res.status(200).json({ message: "User verified successfully" });
    }
    else{
      res.status(400).json({ message: "try again wrong code" });
    }
  } catch (error) {
    console.log(`server error(SQL)_forgetPassword _ passcode    error : ${error}`);
    res.status(500).json({ message: "Server error" });
  }
}


exports.settingNewPassword = async (req , res) => {
  const {email , newpass} = req.body;
  let user = await getUserData(email);
  const hashedPassword = await bcrypt.hash(newpass, 10);
  const response = await updatePassword_controller(user.userId ,hashedPassword);
  if(response===-1){
    res.status(500).json({ message: "SQL server error" })
  }
  else if(response === 1){
    res.status(200).json({ message: "User password updated successfully" })
  }
  else if(response === 0){
    res.status(400).json({ message: "User not found" })
  }

}

exports.getProfile = async (req, res) => {
  try {
    const userID = req.user.id; //"Data retrieved from middleware"
    let users = await getUserByID(userID);
    if (!users) {
      return res.status(404).json({ message: "User not found" });
    }
    const user = users[0];
    res.json({
      message: "User profile",
      user: {
        id: user.userId,
        first_name: user.firstName,
        last_name: user.lastName,
        user_name: user.userName,
        bio: user.bio,
        gender:user.gender,
        birthday: user.dateOfBrith,
        phone_number: user.phoneNumber,
        email: user.email },
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Server error" });
  }
};

exports.newPassword = async(req , res)=>{
  try {
    const {newPassword , oldPassword} = req.body;
    const userid = req.user.id;
    console.log(`updated password user id : ${userid}`);
    let users = await getUserByID(userid);
    const user = users[0];
    let isMatch = await bcrypt.compare(oldPassword, user.passwordHash);
    if(isMatch)
    {
      const hashedPassword = await bcrypt.hash(newPassword, 10);
      const response = await updatePassword_controller(userid ,hashedPassword);
      console.log(response);
      if(response===-1){
        res.status(500).json({ message: "SQL server error" })
      }
      else if(response === 1){
        let userAfters = await getUserByID(userid);
        const userAfter = userAfters[0];
        console.log('Old Hash:', user.passwordHash);
        console.log('New Hash:', userAfter.passwordHash);
        res.status(200).json({ message: "User password updated successfully" })
      }
      else if(response === 0){
        res.status(200).json({ message: "User not found" })
      }
    } else {
      res.status(404).json({ message: "wrong password"})
    }
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "server error" });
  }
};

exports.updateProfile = async (req, res) => {
  try {
    const userID = req.user.id; // "Data retrieved from middleware"
    const { new_firstName, new_lastName, new_userName, new_bio, new_gender, new_birthday, new_phoneNumber} = req.body; // new information
    if(new_gender != "F" && new_gender != "M"){
      return res.status(400).json({message: "gender must be M or F"});
    }
    let response = await updateProfile_controller(userID,new_firstName, new_lastName, new_userName, new_bio, new_gender, new_birthday, new_phoneNumber);

    if (response === 1) {
      res.status(200).json({ message: "Profile updated successfully!" });
    } else {
      res.status(500).json({ message: "Something went wrong, try again later!" });
    }
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Server error" });
  }
};

exports.googleLogin = async (req , res)=>{
  try {
    const { token } = req.body;
    const googleUser = await axios.get(`https://www.googleapis.com/oauth2/v1/userinfo?access_token=${token}`, {
      headers: { Authorization: `Bearer ${token}` },
    });
    const { id, name, email, picture } = googleUser.data;
    let user = await User.findOne({ googleId: id });
    if (!user) {
      user = new User({
        googleId: id,
        name,
        email,
        avatar: picture,
      });
      await user.save();
    }
    const authToken = jwt.sign({ id: user._id }, process.env.JWT_SECRET, { expiresIn: "1h" });
    res.json({ token: authToken, user });
  } catch (error) {
    console.error(error);
    res.status(400).json({ message: "Google authentication failed" });
  }
};
