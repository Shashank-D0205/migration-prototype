const { google } = require("googleapis");
require("dotenv").config();

const youtube = google.youtube({
  version: "v3",
  auth: process.env.YOUTUBE_API_KEY,
});

exports.searchYouTube = async (req, res) => {
  const { query } = req.params;

  try {
    const response = await youtube.search.list({
      part: "snippet",
      q: query,
      maxResults: 1,
    });

    const videoId = response.data.items[0]?.id?.videoId;
    if (!videoId) {
      return res.status(404).json({ error: "No matching video found" });
    }

    res.json({ videoId });
  } catch (error) {
    console.error("Error searching YouTube:", error);
    res.status(500).json({ error: "YouTube search failed" });
  }
};
