const bcrypt = require("bcryptjs");
const { validationResult } = require("express-validator");
const jwt = require("jsonwebtoken");
const sendVerificationCode = require('../Auth/mailer');
const { get_user_genres_controller, get_user_genres_name_controller, update_genres } = require("../SQL/SQL-user-controller");
const { loginUser_controller } = require("../SQL/SQL-user-controller");
const { getUserByID } = require("../SQL/SQL-user-controller");
const { getAllGenres, getAllGenres_controller } = require("../SQL/SQL-genre-controller");




exports.getUserGenres = async(req ,res)=>{
    try {
        const userID = req.user.id;
        const received_genresID = await get_user_genres_controller(userID);
        const genresTitle = await get_user_genres_name_controller(received_genresID);
        res.json(genresTitle);

    } catch (error) {
        console.error(error);
        res.status(500).json({ message: "Server error" });
    }
}


exports.updateUserGenres = async(req ,res)=>{
    try {
        
        const userID = req.user.id;
        const {genres} = req.body;

        if (typeof genres === "string") {
            try {
              genres = JSON.parse(genres); 
            } catch (e) {
              console.error("Invalid JSON string in genres");
              return res.status(400).json({ message: "Invalid genres format" });
            }
        }

        const response = await update_genres(userID, genres);
        if(response === 1)
        {
            res.send("user genres updated");
        }
        else if(response === 0 || response === -1 )
        {
            res.status(500).json({ message: "Server error" });
        }

    } catch (error) {
        console.error(error);
        res.status(500).json({ message: "Server error" });
    }
}



exports.getAllGenres = async(req , res)=>{
    try {
        const response = await getAllGenres_controller();
        res.json(response);

    } catch (error) {
        console.error(error);
        res.status(500).json({ message: "Server error" });
    }
    
}