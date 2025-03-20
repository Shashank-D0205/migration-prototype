const express = require("express");
const { searchYouTube } = require("../controllers/youtubeController");
const router = express.Router();

router.get("/search/:query", searchYouTube);

module.exports = router;
