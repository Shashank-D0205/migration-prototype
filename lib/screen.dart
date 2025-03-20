import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PlaylistMigrationScreen extends StatefulWidget {
  @override
  _PlaylistMigrationScreenState createState() => _PlaylistMigrationScreenState();
}

class _PlaylistMigrationScreenState extends State<PlaylistMigrationScreen> {
  TextEditingController _urlController = TextEditingController();
  List songs = [];
  bool isLoading = false;

  Future<void> fetchSpotifyPlaylist() async {
    String playlistUrl = _urlController.text.trim();

    if (!playlistUrl.contains("spotify.com/playlist/")) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid Spotify playlist URL", style: TextStyle(color: Colors.redAccent))),
      );
      return;
    }

    setState(() => isLoading = true);

    String playlistId = playlistUrl.split("playlist/")[1].split("?")[0]; // Extract ID
    String apiUrl = "https://api.spotify.com/v1/playlists/$playlistId/tracks";

    String token = "YOUR_SPOTIFY_API_TOKEN"; // Temporary, backend should handle this
    final response = await http.get(Uri.parse(apiUrl), headers: {
      "Authorization": "Bearer $token",
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        songs = data["items"];
        isLoading = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch playlist", style: TextStyle(color: Colors.redAccent))),
      );
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Spotify to YouTube", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _urlController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Paste Spotify Playlist URL",
                labelStyle: TextStyle(color: Colors.white70),
                prefixIcon: Icon(Icons.link, color: Colors.white70),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: fetchSpotifyPlaylist,
              icon: Icon(Icons.download, color: Colors.black),
              label: Text("Fetch Playlist"),
            ),
            SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator(color: Color(0xFF1DB954))
                : Expanded(
              child: ListView.builder(
                itemCount: songs.length,
                itemBuilder: (context, index) {
                  var track = songs[index]["track"];
                  return Card(
                    color: Colors.grey[850],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      leading: Icon(Icons.music_note, color: Colors.greenAccent),
                      title: Text(track["name"], style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      subtitle: Text(track["artists"][0]["name"], style: TextStyle(color: Colors.white70)),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
