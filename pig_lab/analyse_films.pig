-- Ouvrir le grunt shell de Pig
-- Charger les fichiers JSON avec JsonLoader sans schéma explicite

-- Charger les films
movies = LOAD '/input/movies.json' USING JsonLoader();

-- Charger les artistes  
artists = LOAD '/input/artists.json' USING JsonLoader();

-- 1. Collection mUSA_annee: Films américains groupés par année
USA_movies = FILTER movies BY $6 == 'USA';
mUSA_annee = GROUP USA_movies BY $3;
STORE mUSA_annee INTO '/shared_volume/pigout/mUSA_annee';

-- 2. Collection mUSA_director: Films américains groupés par réalisateur
mUSA_director = GROUP USA_movies BY $7;
STORE mUSA_director INTO '/shared_volume/pigout/mUSA_director';

-- 3. Collection mUSA_acteurs: Triplets (idFilm, idActeur, role) pour films américains
-- Filtrer les artistes qui ont un rôle (acteurs)
acteurs = FILTER artists BY $4 IS NOT NULL;
actors_flat = FOREACH acteurs GENERATE $0, $1, $2, $4;
STORE actors_flat INTO '/shared_volume/pigout/mUSA_acteurs';

-- 4. Collection moviesActors: Associer identifiant du film à description complète de l'acteur
movies_info = FOREACH movies GENERATE $0, $1, $3, $4;
STORE movies_info INTO '/shared_volume/pigout/moviesActors';

-- 5. Collection fullMovies: Description complète du film à la description de tous les acteurs
fullMovies = FOREACH movies GENERATE $0, $1, $3, $4, $7, $8;
STORE fullMovies INTO '/shared_volume/pigout/fullMovies';

-- 6. Collection ActeursRealisateurs: Pour chaque artiste, liste des films où il/elle a joué et films dirigés
directors = FOREACH movies GENERATE $7, $0, 'director';
STORE directors INTO '/shared_volume/pigout/ActeursRealisateurs';
