const bcrypt = require("bcryptjs");
const { validationResult } = require("express-validator");
const jwt = require("jsonwebtoken");
const sendVerificationCode = require('../Auth/mailer');
const { getUserByID } = require("../SQL/SQL-user-controller");
const { post_rate } = require("../SQL/SQL-rate-controller");


exports.postRateController = async (req ,res) => {
    const userID = req.user.id;
    const {bookid , rate} =req.body;
    if(!bookid || !rate){
        res.status(400).json({ message: 'bookid or rate missing' });
    }
    try {
        const response = await post_rate(userID , bookid , rate);
        if(response === 1){
            res.status(200).send("Rating updated successfully");
        }
        else{
            res.status(500).json({ message: 'Internal Server Error' });
    
        }
    } catch (error) {
        console.error('Error in rating books');
        res.status(500).json({ message: 'Internal Server Error' });
    }
}