const axios = require('axios');
const api = axios.create({
    baseURL: "http://185.255.90.36:9547/api/v1/user", 
    headers: {
      "Content-Type": "application/json",
    },
  });



const LoginUser = async (username,email) => {
    try {
      const response = await api.get("/login",{
        params:{userName: username , email: email}
        
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
        
        console.log("Response from server:", response.data);
    } catch (error) {
        console.error("Error:", error);
    }
};


const registerUSer_controller = async(emailInput,nameInput,passwordInput)=>{
  let response = await RegisterUser(emailInput,nameInput,passwordInput);
  if (!response || response.length === 0) {
      console.log("server Error(SQL-signupNormalUser)");
      return;
  }
  let Pure_response = response[0];
  if(Pure_response.message === 'exists')
  {
      console.log("user exists");
      return;
  }
  else{
      console.log("The user has been added to the SQL database");
  }

}






























