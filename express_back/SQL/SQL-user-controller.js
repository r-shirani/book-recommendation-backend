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


const RegisterUser = async (emailInput,nameInput,passwordInput) => {
    try {
        const response = await api.post("/signupNormalUser", null, { 
            params: {
                email: emailInput,
                name: nameInput,
                password: passwordInput
            },
        });
        return response.data;
        console.log("Response from server:", response.data);
    } catch (error) {
        console.error("Error:", error);
    }
};


 const registerUSer_controller = async(emailInput,nameInput,passwordInput)=>{
  let response = await RegisterUser(emailInput,nameInput,passwordInput);
  let Pure_response = response[0];
  console.log(Pure_response.message);
  if (!response || response.length === 0) {
      console.log("server Error(SQL-signupNormalUser)");
      return ;
  }
  
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
  let response = await LoginUser(emailInput);
  let isVerified = response[16];
  let pass =response[21];
  let ID =response[0];
  console.log(isVerified.message);
  console.log(pass.message);
  if (!response || response.length===0){
    console.log("server Error(SQL-login)");
    return -1;
  }
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

module.exports={
  registerUSer_controller,
  loginUser_controller
};

























