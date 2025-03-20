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
    } catch (error) {
      console.error("Error fetching data:", error);
    }
  };
  
const RegisterUser = async (emailInput,nameInput,passwordInput,verificatoncodeInput) => {
    try {
        const response = await api.post("/signupNormalUser", null, { 
            params: {
                email: emailInput,
                name: nameInput,
                password: passwordInput,
                verificationCode: verificatoncodeInput
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



const registerUSer_controller = async(emailInput,nameInput,passwordInput,verificatoncodeInput)=>{
  let response = await RegisterUser(emailInput,nameInput,passwordInput,verificatoncodeInput);
  
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
    if (!isVerified){
      console.log("not verified");
      return -2;
    }
    if (isVerified && pass==passwordInput){
      console.log("logged in");
      return ID;
    }
    if (isVerified && pass!=passwordInput){
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

module.exports={
  registerUSer_controller,
  loginUser_controller,
  getUserData,
  verifyCode_controller,
  DeleteUser
};

























