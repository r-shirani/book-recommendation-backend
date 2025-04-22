const bcrypt = require("bcryptjs");
const axios = require('axios');
const api = axios.create({
    baseURL: "http://185.255.90.36:9547/api/v1", 
    headers: {
      "Content-Type": "application/json",
    },
});

const postComment_controller = async (userid_input,bookid_input,text_input)=>{
    try {
        const response = await api.post("/comment" , {
            userid: userid_input,
            bookid: bookid_input,
            text: text_input
        })
        if (!response || response.length===0){
            console.log("server Error(SQL-login)");
            return -1;
        }
        const pure = response.data;
        if(response.status===201)
        {
            console.log(`comment added userid:${userid_input}   bookid:${bookid_input} `);
            return 1
        }
        else if(response.status===500)
        {
            console.log(`message from sql server :${pure.message} `);
            return 0
        }
        else
        {
            console.log("SQL server error");
            return -1
        }

    } catch (error) {       
        console.log("Error:", error);
        console.log("SQL server error - (post-comment)");
        return -1
    }
}



const getAllComment_book = async(bookid_input)=>{
    try {
      
      const response = await api.get("/comment/book",{
        params: {bookid : bookid_input}
      });
      if (!response || response.length===0){
        console.log("server Error(SQL-login)");
        return -1;
      }   
      return response.data.list;
  
  
    } catch (error) {
      console.log("Error:", error);
      return -1;
    }
  }



module.exports={
    postComment_controller,
    getAllComment_book
};
