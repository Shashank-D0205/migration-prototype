const axios = require("axios");
require("dotenv").config();

const getSpotifyAccessToken = async () => {
  const authOptions = {
    method: "post",
    url: "https://accounts.spotify.com/api/token",
    headers: {
      "Content-Type": "application/x-www-form-urlencoded",
    },
    data: `grant_type=client_credentials&client_id=${process.env.SPOTIFY_CLIENT_ID}&client_secret=${process.env.SPOTIFY_CLIENT_SECRET}`,
  };

  try {
    const response = await axios(authOptions);
    return response.data.access_token;
  } catch (error) {
    console.error("Error fetching Spotify token:", error.response.data);
  }
};

exports.getPlaylistTracks = async (req, res) => {
  const { playlistId } = req.params;

  try {
    const token = await getSpotifyAccessToken();
    const response = await axios.get(
      `https://api.spotify.com/v1/playlists/${playlistId}/tracks`,
      {
        headers: { Authorization: `Bearer ${token}` },
      }
    );

    const tracks = response.data.items.map((item) => ({
      name: item.track.name,
      artist: item.track.artists[0].name,
    }));

    res.json({ tracks });
  } catch (error) {
    console.error("Error fetching playlist:", error.response.data);
    res.status(500).json({ error: "Failed to fetch playlist" });
  }
};
