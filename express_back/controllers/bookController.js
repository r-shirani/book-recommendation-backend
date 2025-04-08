const bcrypt = require("bcryptjs");
const { validationResult } = require("express-validator");
const jwt = require("jsonwebtoken");
const sendVerificationCode = require('../Auth/mailer');
const { getUserByID } = require("../SQL/SQL-user-controller");
const { bookImage, searchBook_controller } = require("../SQL/SQL-book-controller");

exports.searchBook = async (req , res)=>{
    const {pagenum , searchterm} = req.body;
    const count =10;
    const bookData = await searchBook_controller(searchterm,pagenum,count);
    if(bookData != -1){
        res.status(200).json({
            bookData
        })
        console.log(bookData);
    }
    else{
        res.status(500).json({ message: "server error" });
    }
}

exports.popularBooks = async (req , res)=>{
    try{
        const {pagenum=1} = req.body;
        const count =10;
        const books = await searchBook_controller("",pagenum,count);
        if(!books){
            return res.status(204).send(); // No Content
        }
        const popularBooks= books.map(book=>({
            author: `${book.firstname} ${book.lastname}`,
            avgrate: book.avgrate,
            bookid: book.bookid,
            title : book.title
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