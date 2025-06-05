const bcrypt = require("bcryptjs");
const { validationResult } = require("express-validator");
const jwt = require("jsonwebtoken");
const sendVerificationCode = require('../Auth/mailer');
const { getUserByID } = require("../SQL/SQL-user-controller");
const { Readable } = require('stream');
const { get_all_user_collections, post_user_collection, get_collection_details, deleteCollection, deleteCollectionDetails, getCollectionImage, get_all_collections_SQL, saveCollection_SQL, deleteCollection_SQL, getCollections_user_SQL, addCollectionDetail } = require("../SQL/SQL-collection-controller");
const FormData = require('form-data');
const axios = require('axios');
const { Collection } = require("mongoose");

exports.getAllCollections = async(req , res)=>{
  try {
    const {pagenum=1 , count=10} = req.query;
    

    const collections = await get_all_collections_SQL(pagenum , count);
    if(!collections){
      return res.status(204).send();
    }
    const pure_collections = collections.filter(item => item.IsOwner === 1 && item.IsPublic===true).map(item =>({
        title: item.Title,
        username: item.UserName,
        fullname: item.FullName,
        discription : item.Discription,
        collectionid : item.CollectionID,       
    }));
    return res.status(200).send(pure_collections);

  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "server error" });
  }
}

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
  } 
  catch (error) {
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
            return res.status(404).json({ message: "no details in this collection" });
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
      const response = await getCollectionImage(collectionid);
      console.log(`response from sql server = ${response}`);
      if(response == 0)
      {
        return res.status(404).json({ message: 'image not found' });
      }
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

    if (!data) {
      return res.status(400).json({ message: 'file or data missing' });
    }
    const fd = new FormData();
   
    if (file) {
      fd.append('file', file.buffer, {
        filename: file.originalname,
        contentType: file.mimetype
      });
    } 
    else {
      fd.append('file', Buffer.from(''), {
        filename: '',
        contentType: 'application/octet-stream'
      });
    }
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

exports.addCollectionDetails_controller = async (req, res) => {
  try {
    
    const collectionid = req.body.collectionid;
    const bookid = req.body.bookid;
    if(!collectionid || !bookid){
      return res.status(400).json({ error: 'enter collectionid or bookid' });
    }
    const response = await addCollectionDetail(collectionid , bookid);
    if(response == 1){
      res.status(201).json({ message: "collection Details updated",
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

exports.saveCollection_controller = async (req, res) => {
  try {
    const userID = req.user.id; 
    const { accessibilitygroup } = req.body;

    
    const response = await saveCollection_SQL(accessibilitygroup, userID);

    if (response === 1) {
      return res.status(200).json({ message: `collection saved for user : ${userID}` });
    } else if (response === 0) {
      return res.status(400).json({ message: `Failed to save collection: Invalid UserID or AccessibilityGroupID for user ${userID}` });
    } else if (response === -1) {
      return res.status(500).json({ message: `Server error while saving collection for user ${userID}` });
    }
  } catch (error) {
    
    console.error("Unexpected error in saveCollection_controller:", error);
    return res.status(500).json({ message: "server error" });
  }
};


exports.deleteCollectionSaved_controller = async (req, res) => {
  try {
    const userID = req.user.id; 
    const { accessibilitygroup } = req.body;

   
    const response = await deleteCollection_SQL(accessibilitygroup, userID);

    if (response === 1) {
      return res.status(200).json({ message: `Collection deleted for user: ${userID}` });
    } else if (response === 0) {
      return res.status(404).json({ message: `No collection found to delete for user: ${userID} with accessibilitygroup: ${accessibilitygroup}` });
    } else if (response === -1) {
      return res.status(500).json({ message: `Server error while deleting collection for user: ${userID}` });
    }
  } catch (error) {
   
    console.error("Unexpected error in deleteCollection_controller:", error);
    return res.status(500).json({ message: " server error" });
  }
};

exports.getCollectionsUser_controller = async (req, res) => {
  try {
    const userID = req.user.id; 
    const { count = 20, pagenum = 1 } = req.query; 

    
    const collections = await getCollections_user_SQL(count, pagenum, userID);

   
    const filteredCollections = collections.filter(collection => collection.IsOwner === 0);

   
    return res.status(200).json({
      message: `Collections retrieved for user: ${userID}`,
      data: filteredCollections,
      total: filteredCollections.length
    });
  } catch (error) {

    console.error("Error in getCollections_controller:", error);
    return res.status(500).json({ message: "Server error " });
  }
};








