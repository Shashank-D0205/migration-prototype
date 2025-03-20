const express = require("express");
const { getPlaylistTracks } = require("../controllers/spotifyController");
const router = express.Router();

router.get("/:playlistId", getPlaylistTracks);

module.exports = router;
