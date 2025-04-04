const bcrypt = require("bcryptjs");
const { validationResult } = require("express-validator");
const jwt = require("jsonwebtoken");
const sendVerificationCode = require('../Auth/mailer');
const { getUserByID } = require("../SQL/SQL-user-controller");
const { postComment_controller } = require("../SQL/SQL-comment-controller");


exports.newComment = async (req , res)=>{
    try {
        const userID = req.user.id; //"Data retrieved from middleware"
        const {bookid , text} = req.body;

        const response = await postComment_controller(userID , bookid , text);
        if(response===-1){
            res.status(500).json({ message: "server error(SQL)" });
        }
        else if(response===1)
        {
            res.status(201).json({ message: "Comment added successfully" });
        }

    } catch (error) {
        console.error(error);
        res.status(500).json({ message: "server error" });
    }
}