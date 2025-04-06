const bcrypt = require("bcryptjs");

const book = axios.create({
    baseURL: "http://185.255.90.36:9547/api/v1/book", 
    headers: {
      "Content-Type": "application/json",
    },
  });


const searchBook_controller = async (searchterm_input , pageNum_input ,count_input)=>{
    try {
        const response = await book.get("/search",{
            params:
            {
                searchterm: searchterm_input,
                pageNum: pageNum_input,
                count: count_input
            }
        })
        return response.data;


    } catch (error) {
        console.log("Error:", error);
        console.log("SQL server error - (search-book)");
        return -1
    }
}



module.exports={
    searchBook_controller
}