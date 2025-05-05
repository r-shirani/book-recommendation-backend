require("dotenv").config();
const express = require("express");
const cors = require("cors");
const cookieParser = require("cookie-parser");
//const connectDB = require("./configs/db");
const authRoutes = require("./routes/authRoutes");
const commentRoutes = require("./routes/commentRoutes")
const bookRoutes = require("./routes/bookRoutes")
const updatePtofilePicRoutes = require("./routes/updatePtofilePicRoutes");
const rateRoutes = require("./routes/rateRoutes")
const collectionRoutes = require("./routes/collectionRoutes");
const bodyParser = require('body-parser');


const app = express();

//connectDB();

app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cors());
app.use(cookieParser());

app.use("/api/auth", authRoutes);
app.use("/api",commentRoutes);
app.use("/api/book",bookRoutes);
app.use("/api/profile/pic",updatePtofilePicRoutes);
app.use("/api",rateRoutes);
app.use("/api/collection",collectionRoutes);

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Server running on port http://localhost:${PORT}`));
