const bcrypt = require("bcryptjs");
const axios = require('axios');
const api = axios.create({
    baseURL: "http://185.255.90.36:9547/api/v1", 
    headers: {
      "Content-Type": "application/json",
    },
});


