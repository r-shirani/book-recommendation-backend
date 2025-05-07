const bcrypt = require("bcryptjs");
const { validationResult } = require("express-validator");
const jwt = require("jsonwebtoken");
const sendVerificationCode = require('../Auth/mailer');
const { getUserByID } = require("../SQL/SQL-user-controller");
const { Readable } = require('stream');
const { get_all_user_collections, post_user_collection } = require("../SQL/SQL-collection-controller");


exports.getUser_Collections = async (req , res)=>{
    try {
        const userID = req.user.id; 
        const response = await get_all_user_collections(userID);
        if(response===-1){
            res.status(500).json({ message: "server error(SQL)" });
        }
        else {

            res.status(200).send(response);
        }
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: "server error" });
    }
}


exports.getAnotherUser_Collections = async (req , res)=>{
    try {
        const {userid} =req.body;
        const response = await get_all_user_collections(userid);
        if(response===-1){
            res.status(500).json({ message: "server error(SQL)" });
        }
        else {
            
            res.status(200).send(response);
        }
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: "server error" });
    }
}



exports.postUser_Collection = async (req , res)=>{
    try {
        const userID = req.user.id; 
        const {ispublic , title } = req.body;
        if(title===null || ispublic ===null){
            res.status(400).json({ message: "title and is public is empty" });
        }
        const response = await post_user_collection(ispublic, title, userID);
        if(response===-1){
            res.status(500).json({ message: "server error(SQL)" });
        }
        else if(response===1) {
            res.status(201).send("collection added sucessfully");
        }
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: "server error" });
    }
}















