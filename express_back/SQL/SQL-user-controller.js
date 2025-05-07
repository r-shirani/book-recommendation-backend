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
        console.log("Response from (sql) server:", response.data);
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
};

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
};

const getUserData = async (email)=>{
  try {
    console.log(email);
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
};

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
};

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
};

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

const updateProfile_controller = async (userID,new_firstName, new_lastName, new_userName, new_bio, new_gender, new_birthday, new_phoneNumber) => {
  try {
    const response = await newApi.put("/user", { 
      userid : userID,
      firstname : new_firstName,
      lastname : new_lastName,
      username : new_userName,
      bio : new_bio,
      gender : new_gender,
      dateofbirth : new_birthday,
      phonenumber : new_phoneNumber
    });

    if (!response || response.length === 0) {
      console.log("server Error(SQL-updateUserProfile)");
      return -1;
    }

    const pure = response.data;
    if (pure === "User_Updated") {
      console.log("User profile updated successfully");
      return 1;
    } else {
      console.log("Something went wrong");
      return 0;
    }
  } catch (error) {
    console.error("Error updating user profile:", error);
  }
};

// new apis in sql server
const newApi = axios.create({
  baseURL: "http://185.255.90.36:9547/api/v1", 
  headers: {
    "Content-Type": "application/json"
  }, 
});

const updatePassword_controller = async(userIdInput ,newPasswordInput) =>{
  try {
      console.log(`new password input : ${newPasswordInput} `);
      const response = await newApi.put("/userSecurity", {
          userid : userIdInput,
          passwordhash : newPasswordInput,
      });

      if (!response || response.length===0){
          console.log("server Error(SQL-login)");
          return -1;
      }
      
      const pure = response.data;
      if(pure === "User_Security_Updated"){
        console.log("User_Security_Updated");
          return 1;
      } else {
          console.log("somethiing went wrong");
          return 0;
      }    
  } catch (error) {
      console.log("Error:", error);
  }
};

const updateVerifycode_controller = async(userIdInput , verificationCodeValue) =>{
  try {
    const newVerifiedcode = String(verificationCodeValue);
    const response = await newApi.put("/userSecurity", {
      userid : userIdInput,
      verificationcode : newVerifiedcode,
    });

    if (!response || response.length===0){
      console.log("server Error(SQL-login)");
      return -1;
    }
    const pure = response.data;
      if(pure === "User_Security_Updated"){
        console.log("User_Security_Updated");
          return 1;
      } else {
          console.log("somethiing went wrong");
          return 0;
      }    


  } catch (error) {
    
    console.log("Error:", error);
    return -1;
  }
}








const get_user_genres_controller = async(useridInput) => {
  try {
      const response = await newApi.get("/user/genres", {
          params: { userid: useridInput },
        });
    
      
      const genreIds = response.data.list
      .filter(item => item !== null) 
      .map(item => item.genreid);    
      return genreIds;


  } catch (error) {
    console.log("Error:", error);
    return [];
  }
}




const get_user_genres_name_controller = async (genreids) => {
  try {
    const requests = genreids.map(id => 
      newApi.get("/genres", {
        params: { genreid: id }
      })
    );

    const responses = await Promise.all(requests);

    const titles = responses.map(res => res.data.title);

    return titles;

  } catch (error) {
    console.log("Error:", error);
    return [];
  }
};





const update_genres = async (useridInput, genresID) => {
  try {
   
    const response = await newApi.put("/user/genres", {
      userid: useridInput,
      genres: genresID
    });

    console.log("response from sql server (updating genres):", response.data + "   "+useridInput);

    if (response.data === "Updated") {
      return 1;
    } else {
      return 0;
    }

  } catch (error) {
    console.log("Error:", error);
    return -1;
  }
};



module.exports={
  registerUSer_controller,
  loginUser_controller,
  getUserData,
  verifyCode_controller,
  DeleteUser,
  EmailVerificationPut,
  getUserByID,
  updatePassword_controller,
  updateProfile_controller,
  get_user_genres_controller,
  get_user_genres_name_controller,
  update_genres,
  updateVerifycode_controller
};
