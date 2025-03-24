const bcrypt = require("bcryptjs");
const axios = require('axios');
const api = axios.create({
    baseURL: "http://185.255.90.36:9547/api/v1/user", 
    headers: {
      "Content-Type": "application/json",
    },
  });

const LoginUser = async (email) => {
  try {
    const response = await api.get("/login",{
      params:{email: email} 
    });
    return response.data;
  } catch (error) {console.error("Error fetching data:", error);}
};
  
const RegisterUser = async (emailInput,nameInput,passwordInput,verificationcodeInput) => {
    try {
        const response = await api.post("/signupNormalUser", null, { 
            params: {
                email: emailInput,
                name: nameInput,
                password: passwordInput,
                verificationCode: verificationcodeInput
            },
        });
        console.log("Response from server:", response.data);
        return response.data;       
    } catch (error) {
        console.error("Error:", error);
    }
};

const DeleteUser = async (emailInput) => {
  try {
    const response = await api.delete("/remove " ,{
      params: {
          email: emailInput
      }
    })
    console.log("Response from server:", response.data);
    Pure = response.data[0];
    console.log(pure.status);
  } catch (error) {
    console.error("Error:", error);
  }
}

const EmailVerificationPut = async (userIdInput , EmailverificationInput) =>{
  try {
      const response = await api.put("/EmailVerification",{} , {
          params: {
              userID: userIdInput,
              isEmailVerify: EmailverificationInput
          }
      });
      const pure = response.data;
      console.log(pure.Message); 
      return pure.Status ;
    } catch (error) {
      console.log("Error:", error);
  }
}

const getUserData = async (email)=>{
  try {
    let responses = await LoginUser(email);
    let response = responses[0];
    console.log(response.email+ " " + response.verificationCode + " " +"getUserDataMethod log");
    if(!response){
      return -1;
    }
    return response
  } catch (error) {
    console.error("Error fetching data:", error);
  }
}

const registerUSer_controller = async(emailInput,nameInput,passwordInput,verificationcodeInput)=>{
  let response = await RegisterUser(emailInput,nameInput,passwordInput,verificationcodeInput);
  
  if (!response || response.length === 0) {
      console.log("server Error(SQL-signupNormalUser)");
      return ;
  }
  let Pure_response = response[0];
  console.log(Pure_response.message);
  if(Pure_response.message === 'exists')
  {
      console.log("user exists");
      return 0;
  }
  else{
      console.log("The user has been added to the SQL database");
      return 1;
  }
}

const loginUser_controller = async(emailInput , passwordInput)=>{
  let responses = await LoginUser(emailInput);
  
  if (!responses || responses.length===0){
    console.log("server Error(SQL-login)");
    return -1;
  }
  else{
    let response = responses[0];
    let isVerified = response.isEmailVerified;
    let pass =response.passwordHash;
    let ID =response.userId;

    let isMatch = await bcrypt.compare(passwordInput, pass);
    console.log("password input: "+passwordInput);
    console.log("password from SQL: "+pass);
    console.log("isMatch: "+isMatch);

    if (!isVerified){
      console.log("not verified");
      return -2;
    }
    if (isVerified && isMatch){
      console.log("logged in");
      return ID;
    }
    if (isVerified && !isMatch){
      console.log("wrong password");
      return -3;
    }
  }
}

const verifyCode_controller = async(emailInput)=>{
  let response = await LoginUser(emailInput);
  if (!responses || responses.length===0){
    console.log("server Error(SQL-login)");
    return ;
  }
  let Pure_response = response[0];
  return Pure_response.verificationCode;
}

const getUserByID = async (userID) => {
  try {
    const response = await api.get("/getUser", {
      params: { userID: userID }
    });
    return response.data;
  }catch (error) {
      console.error("Error fetching user data:", error);
      return null;
  }
};

module.exports={
  registerUSer_controller,
  loginUser_controller,
  getUserData,
  verifyCode_controller,
  DeleteUser,
  EmailVerificationPut,
  getUserByID
};