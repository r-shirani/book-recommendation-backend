const bcrypt = require("bcryptjs");
const axios = require('axios');
const book = axios.create({
    baseURL: "http://185.173.104.228:9547/api/v1/book", 
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
        if(response.status == 204){
            return 0;
        }
        return response.data;
    } catch (error) {
        console.log("Error:", error);
        console.log("SQL server error - (search-book)");
        return -1
    }
}

const bookImage = async (bookid)=>{
    const baseurl = "http://185.173.104.228:9547/api/v1/images";
    const image_info = await axios.get(baseurl+`/book/${bookid}`);
    const{list} = image_info.data;
    const imageguid =list[0].imageguid;
    const image_file_url = baseurl + `/file/${imageguid}`;

    try {
        const response = await axios.get(image_file_url, { responseType: 'stream' });
        return {
          stream: response.data,
          contentType: response.headers['content-type'],
        };
    } 
    catch (error) {
        throw new Error('Failed to fetch image');
    }
}

const likeBook =async (bookid_input , userid_input)=>{
    const baseurl = "http://185.173.104.228:9547/api/v1/like";
    try {
        const response = await axios.post(baseurl ,{
            bookid : bookid_input,
            userid : userid_input
         })

        if(response.status === 200){
            return 1;
        }
        else{
            return -1;
        }
    } catch (error) {
        console.log("SQL server error - (like-book)");
        return -1
    }
    
}

const likeStatus = async (bookid_input , userid_input) =>{
    const baseurl = "http://185.173.104.228:9547/api/v1/like/status";
    try {
        const response = await axios.get(baseurl , {
            params:
            {
                bookid : bookid_input,
                userid : userid_input
            }
        })
        if(response.status == 200){
            return response.data
        }
        else{
            console.log("SQL server error - (get Like Status by bookid)");
            return -1
        }
    } catch (error) {
        console.log("SQL server error - (get Like Status by bookid)");
        return -1
    }
}

const MBTIbooks = async (seachterm_input, pageNum_input, count_input,userid_input) => {
    const baseurl = "http://185.173.104.228:9547/api/v1/book/search";
    try {
        const response = await axios.get(baseurl , {
            params:
            {
                searchterm : seachterm_input,
                userid : userid_input,
                pageNum : pageNum_input,
                count : count_input
            }
        })
        if(response.status == 200){
            return response.data
        }
        else{
            console.log("SQL server error - (get MBTI Books)");
            return -1
        }
    } catch (error) {
        console.log("SQL server error - (get MBTI books)");
        return -1
    }
}

const deletelike = async (bookid_input , userid_input) => {

    const baseurl = "http://185.173.104.228:9547/api/v1/like";
    try {
        
        const response = await axios.delete(baseurl ,{
            params: {
                userid: userid_input,
                bookid : bookid_input
            }
        })
        if(response.status === 200){
            return 1;
        }
        else{
            return -1;

        }



    } catch (error) {
        console.log("SQL server error - (dislike-book)");
        return -1
    }
}

const favorit_books = async (userid_input) => {
    const baseurl = "http://185.173.104.228:9547/api/v1/book/favorit";
    try {
        const response = await axios.get(baseurl ,{
            params: {
                userid: userid_input,
            }
        })
        if(response.status === 200){
            return response;
        }
        else if(response.status === 204)
        {
            return 0;
        }
        else{
            return -1;
        }
        
    } catch (error) {
        console.log("SQL server error - (favorit-book)");
        return -1
    }
}

const GetBookByID = async(bookid_input)=> {
    try {
        const baseurl = "http://185.173.104.228:9547/api/v1/book/detail";
        const response = await book.get(baseurl, {
            params:
            {
                bookid : bookid_input,
            }
        })
        return response.data;
    } catch (error) {
        console.log("Error:", error);
        console.log("SQL server error - (get book by id)");
        return -1
    }
}

const GetSuggestionsBook = async(userid_input , pageNum_input , count_input) =>{
    try {
        
    
        const baseurl = "http://185.173.104.228:9547/api/v1/book/suggestion";
        const response = await book.get(baseurl, {
            params:
            {
                userid : userid_input,
                pagenum : pageNum_input,
                count : count_input
            }
        })
        if(response.status==204){
            return 0;
        }
        else{
            return response.data;
        }
    }
    catch (error) {
        console.log("Error:", error);
        console.log("SQL server error - (get GetSuggestionsBook by userid)");
        return -1
    }
    
}

module.exports={
    searchBook_controller,
    bookImage,
    likeBook,
    deletelike,
    favorit_books,
    GetBookByID,
    likeStatus,
    MBTIbooks,
    GetSuggestionsBook
}