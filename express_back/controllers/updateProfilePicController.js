
const axios = require('axios');
const FormData = require('form-data');

exports.proxyUpload = async (req, res) => {
  try {
    const userID = req.user.id
    if (!req.file || !userID) {
      return res.status(400).json({ message: 'file or userid missing' });
    }

   
    const fd = new FormData();
    fd.append('file',        req.file.buffer, {     
      filename: req.file.originalname,
      contentType: req.file.mimetype
    });
    fd.append('userid',      userID);


    const destURL = 'https://185.173.104.228:9547/api/v1/user/profile';
    const uploadResp = await axios.post(destURL, fd, {
      headers: fd.getHeaders(),      
      maxContentLength: Infinity,
      maxBodyLength:   Infinity,
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

    res.status(500).json({ message: 'proxy upload failed' });
  }
};





