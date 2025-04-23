const bcrypt = require("bcryptjs");
const { validationResult } = require("express-validator");
const jwt = require("jsonwebtoken");
const sendVerificationCode = require('../Auth/mailer');
const { getUserByID } = require("../SQL/SQL-user-controller");
const { postComment_controller, getAllComment_book, get_ref_comments } = require("../SQL/SQL-comment-controller");

exports.newComment = async (req , res)=>{
    try {
        const userID = req.user.id; //"Data retrieved from middleware"
        const {bookid , text , Commentrefid} = req.body;
        const response = await postComment_controller(userID , bookid , text ,Commentrefid);
        if(response===-1){
            res.status(500).json({ message: "server error(SQL)" });
        }
        else if(response===1){
            res.status(201).json({ message: "Comment added successfully" });
        }
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: "server error" });
    }
}



exports.getAllCommentBook = async (req,res)=>{
    try {
        const {bookid } = req.body;
        const response = await getAllComment_book(bookid);
        if(response != -1){
            res.status(200).send(response);
        }
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: "server error" });
    }
}


exports.getRefComments = async (req , res)=>{
    try {
        const {commentid } = req.body;
        const response = await get_ref_comments(commentid);
        if(response===-1){
            res.status(500).json({ message: "server error(SQL)" });
        }
        else{

            res.status(200).send(response.list);
        }
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: "server error" });
    }
}


