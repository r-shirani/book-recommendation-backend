const bcrypt = require("bcryptjs");
const axios = require('axios');
const api = axios.create({
    baseURL: "https://185.173.104.228:9547/api/v1", 
    headers: {
      "Content-Type": "application/json",
    },
});


const post_rate = async (userid_input , bookid_input , rate_input) => {

  try {
    const response = await api.post("/rate",{
      userid : userid_input,
      bookid : bookid_input,
      rate : rate_input
    })

    if(response.status === 200)
    {
      return 1;
    }
    else{
      return -1;
    }


  } catch (error) {

    console.log("SQL server error - (rate-book)");
    return -1
  }

}







module.exports ={
  post_rate
}