const bcrypt = require("bcryptjs");
const axios = require('axios');
const api = axios.create({
    baseURL: "http://185.173.104.228:9547/api/v1", 
    headers: {
      "Content-Type": "application/json",
    },
});

const get_all_collections_SQL = async(pagenum_input, count_input)=>{
  try {
    const response = await api.get("/collections",{
      params : {
        count : count_input ,
        pagenum : pagenum_input
      }
    });
    if(response.status == 200){
      return response.data;
    }
    else{
      return -1;
    }
  } catch (error) {
    console.log("server Error(SQL-get-all-collection)");
    return -1;
  }
}

const getCollections_user_SQL = async (count_input, pagenum_input, userid_input) => {
  try {
    const response = await api.get(
      "/collections",
      {
        params: {
          count: count_input,
          pagenum: pagenum_input,
          userid: userid_input
        }
      }
    );

    if (response.status === 200) {
      return response.data; 
    }
  } catch (error) {
    console.log("server Error(SQL-getting-collections)");
    throw error; 
  }
};

const get_all_user_collections = async(userid_input)=>{
  try {
    
    const response = await api.get("/collections",{
      params: {userid : userid_input}
    });
    if (!response || response.length===0){
      console.log("server Error(SQL-get-collection)");
      return -1;
    }   
    return response.data;

  } catch (error) {
    console.log("server Error(SQL-get-user-collection)");
    return -1;
  }
}


const post_user_collection = async(ispublic_input , title_input ,userid_input)=>{
  try {
    const response =await api.post("/collections",{
      ispublic : ispublic_input ,
      title : title_input ,
      userid : userid_input
    })
    if (!response || response.length===0){
      console.log("server Error(SQL-post-collection)");
      return -1;
    }   

    if(response.status === 201){
      return 1;
    }



  } catch (error) {
    console.log("server Error(SQL-post-collection)");
    return -1;
  }
}


const get_collection_details = async(collectionid_input) =>{
  try {
    const response = await api.get("/collections/detail",{
      params: {collectionid : collectionid_input}
    });
    if (!response || response.length===0){
      console.log("server Error(SQL-get-collection-details)");      
      return -1;
    }   
    if(response.status == 200){
      return response.data;
    }
  } catch (error) {
    console.log("server Error(SQL-get-collection-details)");
    return -1;
  }
}

const getCollectionImage = async (collectionid) => {
  const imageUrl = `http://185.173.104.228:9547/api/v1/collections/image?collectionid=${collectionid}`;

  try {
    const response = await axios.get(imageUrl, { responseType: 'stream' });
    if(response.status==404){
      return 0;
    }
    return {
      stream: response.data,
      contentType: response.headers['content-type'],
    };
    
  } catch (error) {
    console.log(error.message + "  SQL server for collection image");
    return 0;
  }
};

const deleteCollection = async(collectionid_input) => {
  try {
    const response = await api.delete("/collections",{
      params: {collectionid : collectionid_input}
    });
    if(response.status == 200){
      return 1;
    }
    else{
      return -1
    }
  } catch (error) {
    console.log("server Error(SQL-deleting-collection)");
    return -1;
  }


};

const deleteCollectionDetails = async(collectionid_input , bookid_input) => {
  try {
    const response = await api.delete("/collections/detail",{
      params: {
        collectionid : collectionid_input,
        bookid : bookid_input

        }
    });
    if(response.status == 200){
      return 1;
    }
    else{
      return -1
    }
  } catch (error) {
    console.log("server Error(SQL-deleting-Details-collection)");
    return -1;
  }
};

const addCollectionDetail = async(collectionid_input , bookid_input) => {
  try {
    const bookid = [parseInt(bookid_input, 10)];
    const response = await api.post("/collections/detail",{        
      collectionid : collectionid_input,
      bookid : bookid       
    });
    
    if(response.status == 201){
      return 1;
    }
    else{
      return -1
    }
  } catch (error) {
    console.log(error.response.data);
    console.log("server Error(SQL-deleting-Details-collection)");
    return -1;
  }
};


const saveCollection_SQL = async (accessibilitygroup_input, userid_input) => {
  try {
    const response = await api.put(
      "/collections/access",
      {
        userid: [userid_input]
      },
      {
        params: {
          accessibilitygroup: accessibilitygroup_input
        }
      }
    );
    if (response.status == 200) {
      return 1;
    }
  } catch (error) {

    if (error.response && error.response.data && error.response.data.message) {
      const errorMessage = error.response.data.message;
      if (errorMessage.includes("UserID") || errorMessage.includes("AccessibilityGroupID")) {
        return 0;
      }
    }
 
    console.log("server Error(SQL-saving-collection)");
    return -1;
  }
};

const deleteCollection_SQL = async (accessibilitygroup_input, userid_input) => {
  try {
    const response = await api.delete(
      "/collections/access",
      {
        params: {
          accessibilitygroup: accessibilitygroup_input
        },
        data: {
          userid: [userid_input]
        }
      }
    );

    if (response.status === 200) {
      return 1;
    }
  } catch (error) {
    if (error.response && error.response.status === 404) {
      
      if (error.response.data && error.response.data.message && error.response.data.message.includes("Got 0 rows when exactly 1 was expected")) {
        return 0; 
      }
    }

    console.log("server Error(SQL-deleting-collection)");
    return -1;
  }
};

module.exports={
  get_all_user_collections,
  post_user_collection,
  get_collection_details,
  getCollectionImage,
  deleteCollection,
  deleteCollectionDetails,
  get_all_collections_SQL,
  saveCollection_SQL,
  deleteCollection_SQL,
  getCollections_user_SQL,
  addCollectionDetail
};
