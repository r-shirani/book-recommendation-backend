const bcrypt = require("bcryptjs");
const axios = require('axios');

const newApi = axios.create({
    baseURL: "https://185.173.104.228:9547/api/v1", 
    headers: {
      "Content-Type": "application/json"
    }, 
  });


  const getAllGenres_controller = async () => {
    try {
        const response = await newApi.get("/genres/getAllGenres");
        const rawList = response.data.list;

        // فیلتر کردن لیست برای حذف آیتم‌های null و بدون title یا genreid
        const filteredList = rawList
            .filter(item => item && item.genreid !== null && item.title !== null)
            .map(item => ({
                genreid: item.genreid,
                title: item.title
            }));

        console.log(filteredList);
        return filteredList;

    } catch (error) {
        console.log("Error:", error);
        return -1;
    }
}

module.exports ={
    getAllGenres_controller
}