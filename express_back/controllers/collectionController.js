const bcrypt = require("bcryptjs");
const { validationResult } = require("express-validator");
const jwt = require("jsonwebtoken");
const sendVerificationCode = require('../Auth/mailer');
const { getUserByID } = require("../SQL/SQL-user-controller");
const { Readable } = require('stream');
const { get_all_user_collections, post_user_collection, get_collection_details, deleteCollection, deleteCollectionDetails } = require("../SQL/SQL-collection-controller");
const FormData = require('form-data');
const axios = require('axios');

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
        const userid = req.params.userid;
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
            res.status(400).json({ message: "title or is public is empty" });
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


exports.details_collection = async (req , res) =>{
    try {
        const {collectionid} = req.query; 
        if(!collectionid){
            return res.status(400).json({ error: 'enter collectionid' });
        }
        const details = await get_collection_details(collectionid);
        if (!details || details.length===0){
            return res.status(404).json({ message: "collection not found" });
        }
        if(details != -1){
            return res.status(200).send(details);
        }
        else{
            console.error(error);
            return res.status(500).json({ message: "server error" });
        }
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: "server error" });
    }
}


exports.proxyGetCollectionImage = async (req, res) => {
    const collectionid = req.params.collectionid;
  
    if (!collectionid) {
      return res.status(400).json({ message: 'collectionid is required' });
    }
  
    try {
      const { stream, contentType } = await getCollectionImage(collectionid);
      res.setHeader('Content-Type', contentType);
      stream.pipe(res);
      console.log(`Collection image sent successfully. collectionid: ${collectionid}`);
    } catch (error) {
      console.error(error.message);
      res.status(500).json({ message: 'Server error - (error in fetching collection image)' });
    }
};




exports.proxyUploadCollectionImage = async (req, res) => {
    try {
        const collectionid = req.params.collectionid;
  
      if (!req.file || !collectionid) {
        return res.status(400).json({ message: 'file or collectionid missing' });
      }
  
      const fd = new FormData();
      fd.append('file', req.file.buffer, {
        filename: req.file.originalname,
        contentType: req.file.mimetype
      });
      fd.append('collectionid', collectionid);
  
      const destURL = 'http://185.173.104.228:9547/api/v1/collections/image';
      const uploadResp = await axios.post(destURL, fd, {
        headers: fd.getHeaders(),
        maxContentLength: Infinity,
        maxBodyLength: Infinity,
        timeout: 15000
      });
  
      res.status(201).json(uploadResp.data);
    } catch (err) {
      console.error(err);
  
      if (err.response) {
        return res
          .status(err.response.status === 400 ? 400 : 502)
          .json(err.response.data);
      }
  
      res.status(500).json({ message: 'proxy collection upload failed' });
    }
};
  




exports.proxyUploadCollection = async (req, res) => {
  try {
    const { file } = req;
    const data = req.body.data;

    if (!file || !data) {
      return res.status(400).json({ message: 'file or data missing' });
    }

    const fd = new FormData();
    fd.append('file', file.buffer, {
      filename: file.originalname,
      contentType: file.mimetype
    });

    fd.append('data', data); // JSON string - ensure frontend sends it as string

    const destURL = 'http://185.173.104.228:9547/api/v1/collections';

    const response = await axios.post(destURL, fd, {
      headers: fd.getHeaders(),
      maxContentLength: Infinity,
      maxBodyLength: Infinity,
      timeout: 15000
    });

    res.status(201).json(response.data);

  } catch (err) {
    console.error(err);

    if (err.response) {
      return res
        .status(err.response.status || 502)
        .json(err.response.data);
    }

    res.status(500).json({ message: 'proxy upload failed' });
  }
};


exports.deleteCollection_controller = async (req, res) => {
  try {
    
    const collectionid = req.query.collectionid;
    if(!collectionid){
      return res.status(400).json({ error: 'enter collectionid' });
    }
    const response = await deleteCollection(collectionid);
    if(response == 1){
      res.status(200).send("collection deleted");
    }
    else{
      res.status(500).json({ message: 'SQL server error' });
    }

  
  } 
  catch (error) {
    console.error(error);

    if (error.response) {
      return res
        .status(err.response.status || 500)
        .json(err.response.data);
    }

    res.status(500).json({ message: 'SQL server error' });
  }
}
  
exports.deleteCollectionDetails_controller = async (req, res) => {
  try {
    
    const collectionid = req.query.collectionid;
    const bookid = req.query.bookid;
    if(!collectionid || !bookid){
      return res.status(400).json({ error: 'enter collectionid or bookid' });
    }
    const response = await deleteCollectionDetails(collectionid , bookid);
    if(response == 1){
      res.status(200).json({ message: "collection Details deleted",
      bookid : bookid
    });
    }
    else{
      res.status(500).json({ message: 'SQL server error' });
    }

  
  } 
  catch (error) {
    console.error(error);

    if (error.response) {
      return res
        .status(err.response.status || 500)
        .json(err.response.data);
    }

    res.status(500).json({ message: 'SQL server error' });
  }
}











