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






























  
//   const getData = async () => {
//     let data = await LoginData('Ahmad-2', 'ahmademrani@gmail.com');


//     if (!data || data.length === 0) {
//         console.error("null data");
//         return;
//     }

//     let user = data[0];
    
//     Object.keys(user).forEach(key => {
//         console.log(`${key}: ${user[key]}`);
//     });

// };


