const bcrypt = require("bcryptjs");
const { validationResult } = require("express-validator");
const jwt = require("jsonwebtoken");
const sendVerificationCode = require('../Auth/mailer');
const { getUserByID } = require("../SQL/SQL-user-controller");
const { bookImage, searchBook_controller, likeBook, deletelike, favorit_books, GetBookByID, likeStatus , MBTIbooks, GetSuggestionsBook} = require("../SQL/SQL-book-controller");
const { Readable } = require('stream');

exports.searchBook = async (req, res) => {
    const searchterm = req.params.searchterm;
    if (!searchterm || searchterm.trim() === '') {
        return res.status(400).send('enter searchterm');
    }
    const pagenum = 1;
    const count = 5;
    const baseUrl = "http://185.173.104.228:9547/api/v1/images/file/";
    try {
        const bookData = await searchBook_controller(searchterm, pagenum, count);
        if(bookData == 0){
            return res.status(204).send("book not found");
        }
        if (bookData !== -1) {
        const updatedBookData = bookData.map(book => {
            return {
                ...book,
                imageurl: book.imageguid ? baseUrl + book.imageguid : ""
            };
        });
        //console.log(updatedBookData);
        res.status(200).json({
            updatedBookData
        });
       
        } else {
        res.status(500).json({ message: "server error" });
        }
    } 
    catch (error) {
        console.error('Error fetching top-rated books:', error);
        res.status(500).json({ message: 'Internal Server Error' });
    }
};

exports.popularBooks = async (req , res)=>{
    try{
        const {pagenum=1} = req.body;
        const count =10;
        const books = await searchBook_controller("",pagenum,count);
        if(!books){
            return res.status(204).send(); // No Content
        }
        const popularBooks= books.map(book=>({
            author: book.fullauthorname,
            avgrate: book.avgrate,
            bookid: book.bookid,
            title : book.title,
            RatingCount : book.ratingcount
            
        }));
        res.status(200).json(popularBooks);
    }catch(error){
        console.error('Error fetching top-rated books:', error);
        res.status(500).json({ message: 'Internal Server Error' });
    }
}

exports.getBookImage = async (req , res) =>{
    const bookid = req.params.bookid;
    try {
        const { stream, contentType } = await bookImage(bookid);
        res.setHeader('Content-Type', contentType);
        stream.pipe(res);
        console.log(`Image sent successfully bookid : ${bookid}`); // Stream the image to the response
    } catch (error) {
        console.log(error.message);
        res.status(500).json( {message : "server error - (error in fetching image)" });
    } 
}

exports.searchBook_with_image = async (req, res) => {
    const { pagenum, searchterm } = req.body;
    const count = 10;
    try {
        const bookData = await searchBook_controller(searchterm, pagenum, count);
        if (bookData === -1) {
            return res.status(500).json({ message: "server error" });
        }
        const booksWithImages = await Promise.all(
            bookData.map(async (book) => {
                try {
                    const imageData = await bookImage(book.bookid);
                    // Convert stream to base64
                    const buffer = await streamToBuffer(imageData.stream);
                    const base64Image = `data:${imageData.contentType};base64,${buffer.toString('base64')}`;
                    return {
                        ...book,
                        image: base64Image,
                    };
                } catch (error) {
                    console.error(`Error loading image for book ${book.bookid}:`, error.message);
                    return {
                        ...book,
                        image: null,
                    };
                }
            })
        );
        res.status(200).json({
            bookData: booksWithImages
        });
    } catch (error) {
        console.error("Error in searchBook:", error);
        res.status(500).json({ message: "server error" });
    }
};

exports.like_book = async(req, res) =>{
    const userID = req.user.id;
    const {bookid}= req.body;
    try {
        const response = await likeBook(bookid , userID);
        if(response === 1)
        {
            return res.status(200).send("liked");
        }
        else{
            return res.status(500).json({ message: "server error" });
        }
    } catch (error) {
        console.error("Error in liking book:", error);
        res.status(500).json({ message: "server error" });
    }
}

exports.dislike_book = async(req , res) => {
    const userID = req.user.id;
    const {bookid} = req.body;
    try {

        const response = await deletelike(bookid , userID);
        if(response === 1){
            return res.status(200).send("disliked");
        }
        else{
            return res.status(500).json({ message: "server error" });
        }

        
    } catch (error) {
        console.error("Error in disliking book:", error);
        res.status(500).json({ message: "server error" });
    }
}

exports.favoritBooks = async (req , res) => {
    const userID = req.user.id;
    
    try {
        const response = await favorit_books(userID);
        if(response === 0){
            return res.status(204).send("no content");
        }
        else if(response === -1){
            return res.status(500).json({ message: "server error" });
        }
        else{
            return res.status(200).send(response.data);
        }
    } catch (error) {
        console.error("Error in disliking book:", error);
        res.status(500).json({ message: "server error" });
    }
}

exports.likeStatusController = async (req , res) => {
    const userid = req.user.id;
    const {bookid } = req.query; 

    if (!bookid || !userid) {
        return res.status(400).json({ error: 'enter bookid and userid' });
    }

    try {
        let likeStatus_res = await likeStatus(bookid , userid);
        if(likeStatus_res != -1){
            res.status(200).json({
                message : `the status is : ${likeStatus_res.isLiked}`,
                status : likeStatus_res.isLiked
            })
        }else{
            res.status(500).json({ error: 'server error' });
        }
        
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'server error' });
    }
}

exports.getBookDetail = async (req, res) => {
    const bookid = req.query.bookid;

    if (!bookid) {
        return res.status(400).json({ error: 'enter bookid param' });
    }

    try {
        let books = await GetBookByID(bookid);
        if (!books || books.length===0){
            return res.status(404).json({ message: "Book not found" });
        }
        const book = books[0];
        res.json({
            message: "Book Detail:",
            book:{
                BookID: book.BookID,
                Title: book.Title,
                AuthorName: book.AuthorName,
                RatingCount: book.RatingCount,
                PublisherName: book.PublisherName,
                GenreName1: book.GenreName1,
                GenreName2: book.GenreName2,
                GenreName3: book.GenreName3,
                GenreExtra: book.GenreExtra,
                Description: book.Description,
                PublishedYear: book.PublishedYear,
                LanguageName: book.LanguageName,
                PageCount: book.PageCount,
                ISBN: book.ISBN },
        });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'server error' });
    }
};

exports.getSuggestionBook_controller = async(req , res)=>{
    const userid = req.user.id;
    const {pagenum=1} = req.query;
    try {
        const books = await GetSuggestionsBook(userid,pagenum,10);
        if(books===-1){
            res.status(500).json({ error: 'server error' });
        }
        if (!books || books.length===0 || books ===0){
            return res.status(404).json({ message: "Book not found" });
        }
        else{
            res.status(200).json(books);
        }
    } catch (error) {
        res.status(500).json({ error: 'server error' });
    }
}

// Utility to convert stream to buffer
const streamToBuffer = async (stream) => {
    return new Promise((resolve, reject) => {
        const chunks = [];
        stream.on('data', chunk => chunks.push(chunk));
        stream.on('end', () => resolve(Buffer.concat(chunks)));
        stream.on('error', reject);
    });
};

exports.MBTI_Books = async (req, res) => {
    const userid = req.user.id;
    const {searchterm,pagenum=1,count=10 } = req.query;
    //if (!searchterm) {searchterm = null;}
    //if (!pagenum) {pagenum = 1;}
    //if (!count) {count = 20;}

    try {
        let MBTIbooks_res = await MBTIbooks( searchterm, pagenum, count, userid);
        if(MBTIbooks_res != -1){
            res.status(200).json({
                message: "MBTI Books fetched successfully",
                books: MBTIbooks_res
            })
        }else{
            res.status(500).json({ error: 'server error' });
        }
        
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'server error' });
    }
}