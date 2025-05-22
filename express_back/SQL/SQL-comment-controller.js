const bcrypt = require("bcryptjs");
const axios = require('axios');
const api = axios.create({
    baseURL: "https://185.173.104.228:9547/api/v1", 
    headers: {
      "Content-Type": "application/json",
    },
});

const postComment_controller = async (userid_input,bookid_input,text_input,commentrefid_input)=>{
    try {
        const response = await api.post("/comment" , {
            userid: userid_input,
            bookid: bookid_input,
            commentrefid: commentrefid_input,
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



  const get_ref_comments = async(commentid_input) =>{
    try {
      const response = await api.get("/comment/replies",{
        params: {commentid : commentid_input}
      })
      if(response.status === 200){
        return response.data;
      }
      else{
        return -1;
      }
      
  
    } catch (error) {
      console.log("Error:", error);
      return -1;
    }
  }



const like_comment = async(commentid_input) =>{
    try {
        const response = await api.put("/comment/like",{},{
            params: {commentid : commentid_input}
        })
        if(response.status === 200){
            return 1 ;
        }
        else{
            return -1 ;
        }


    } catch (error) {
        console.log("Error:", error);
        return -1 ;
    }
}


const dislike_comment = async(commentid_input) =>{
    try {
        const response = await api.put("/comment/dislike",{},{
            params: {commentid : commentid_input}
        })
        if(response.status === 200){
            return 1 ;
        }
        else{
            return -1 ;
        }


    } catch (error) {
        console.log("Error:", error);
        return -1 ;
    }
}

module.exports={
    postComment_controller,
    getAllComment_book,
    get_ref_comments,
    like_comment,
    dislike_comment
};
