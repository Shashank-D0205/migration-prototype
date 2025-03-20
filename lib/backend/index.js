require("dotenv").config();
const express = require("express");
const cors = require("cors");
const bodyParser = require("body-parser");

const spotifyRoutes = require("./routes/spotifyRoutes");
const youtubeRoutes = require("./routes/youtubeRoutes");

const app = express();
app.use(cors());
app.use(bodyParser.json());

app.use("/api/spotify", spotifyRoutes);
app.use("/api/youtube", youtubeRoutes);

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
