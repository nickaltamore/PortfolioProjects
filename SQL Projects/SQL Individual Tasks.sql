-- Select Database
USE Music1

-- Retreive all albums released between 1982 and 1998
SELECT Albumname AS [Album Name], ReleaseDate AS [Release Date]
FROM Albums
WHERE ReleaseDate BETWEEN '1982-01-01' AND '1988-01-01';

--How many albums were released in the summer months?
SELECT COUNT (Albumname) AS [Number of Albums]
FROM Albums
WHERE MONTH(ReleaseDate) BETWEEN '5' AND '9';

--Generate a report with a new column from Albums with Years_Released with the number of years the Album has been out.
SELECT Albumname AS [Album Name], ReleaseDate AS [Years Released], DATEDIFF(year, ReleaseDate, '2023') AS [Years Released]
FROM Albums;

-- How many Artists begin with the letter ‘b’ or end with the ‘s’
SELECT COUNT(ArtistName) AS [Number of Artist names starting with b or ending in s]
FROM artists
WHERE artistname LIKE 'b%' OR artistname LIKE '%s';

--Update the album ‘Killers’ with ‘The Killers’
UPDATE albums
SET AlbumName='The Killers'
WHERE AlbumID=9;

SELECT * FROM albums

-- Derive a list of artists with albums that came out in the winter
SELECT artists.artistname AS [Artist Name], albums.albumname AS [Album Name], MONTH(albums.releasedate) AS [Month of Release]
FROM artists RIGHT JOIN albums
ON artists.artistID = albums.artistID
WHERE MONTH(albums.releasedate) = '12' OR MONTH(albums.releasedate) BETWEEN '1' and '2';

-- Retrieve information about artists, their albums, and the genres of those albums. Additionally, include only active artists and albums released between 1982 and 1988. 
SELECT artists.artistname AS [Artist Name], albums.albumname AS [Album Name], genres.genre AS [Genre], albums.releasedate AS [Album Release Date], artists.ActiveFrom AS [Active From]
FROM artists RIGHT JOIN albums
ON artists.artistID = albums.artistID
JOIN Genres 
ON genres.genreID = albums.genreID
WHERE albums.releasedate BETWEEN '1982' AND '1988';

--Derive a list of albums that are Jazz or Rock
SELECT albums.albumname AS [Album Name], genres.genre AS [Genre]
FROM genres JOIN albums
ON genres.genreID = albums.genreID
WHERE genre = 'Jazz' OR genre = 'Rock';

-- Derive a list of artists that have released pop albums. Requires 2 Joins,
SELECT artists.artistname AS [Artist Name], albums.Albumname AS [Album Name], genres.genre AS [Genre]
FROM artists JOIN albums
ON artists.artistID = albums.artistID
JOIN Genres 
ON genres.genreID = albums.genreID
WHERE genres.genre = 'pop';

