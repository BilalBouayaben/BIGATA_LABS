-- Script PIG simplifié pour analyse des films
-- Utiliser TextLoader pour charger les données JSON ligne par ligne

movies_raw = LOAD '/input/movies.json' USING TextLoader() AS (line:chararray);
artists_raw = LOAD '/input/artists.json' USING TextLoader() AS (line:chararray);

-- Filtrer les lignes vides et les accolades  
movies_clean = FILTER movies_raw BY line MATCHES '.*"_id".*';
artists_clean = FILTER artists_raw BY line MATCHES '.*"_id".*';

-- Enregistrer pour vérification
STORE movies_clean INTO '/shared_volume/pigout/films_brut';
STORE artists_clean INTO '/shared_volume/pigout/artistes_brut';

-- Compter le nombre de films et d'artistes
movies_group = GROUP movies_clean ALL;
movies_count = FOREACH movies_group GENERATE COUNT(movies_clean) AS total_films;
STORE movies_count INTO '/shared_volume/pigout/total_films';

artists_group = GROUP artists_clean ALL;
artists_count = FOREACH artists_group GENERATE COUNT(artists_clean) AS total_artists;
STORE artists_count INTO '/shared_volume/pigout/total_artists';
