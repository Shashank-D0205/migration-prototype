const express = require("express");
const { searchYouTube } = require("../controllers/youtubeController");
const router = express.Router();

router.get("/search", async (req, res) => {
  const query = req.query.q;
  if (!query) {
    return res.status(400).json({ error: "Missing query parameter" });
  }
  searchYouTube(query, res);
});

module.exports = router;
