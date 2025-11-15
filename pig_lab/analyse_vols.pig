-- ========================================
-- ANALYSE DES VOLS - Apache PIG
-- ========================================

-- Charger les données
-- Format test.csv: Year,Month,DayofMonth,DayOfWeek,DepTime,CRSDepTime,ArrTime,CRSArrTime,UniqueCarrier,FlightNum,TailNum,
--                  ActualElapsedTime,CRSElapsedTime,AirTime,ArrDelay,DepDelay,Origin,Dest,Distance,TaxiIn,TaxiOut,Cancelled,
--                  CancellationCode,Diverted,CarrierDelay,WeatherDelay,NASDelay,SecurityDelay,LateAircraftDelay

flights = LOAD '/input/flights/test.csv' USING PigStorage(',') AS (
    Year:int, Month:int, DayofMonth:int, DayOfWeek:int,
    DepTime:int, CRSDepTime:int, ArrTime:int, CRSArrTime:int,
    UniqueCarrier:chararray, FlightNum:int, TailNum:chararray,
    ActualElapsedTime:int, CRSElapsedTime:int, AirTime:int,
    ArrDelay:int, DepDelay:int, Origin:chararray, Dest:chararray,
    Distance:int, TaxiIn:int, TaxiOut:int, Cancelled:int,
    CancellationCode:chararray, Diverted:int,
    CarrierDelay:int, WeatherDelay:int, NASDelay:int,
    SecurityDelay:int, LateAircraftDelay:int
);

airports = LOAD '/input/flights/airports.csv' USING PigStorage(',') AS (
    iata:chararray, airport:chararray, city:chararray, 
    state:chararray, country:chararray, lat:double, long:double
);

carriers = LOAD '/input/flights/carriers.csv' USING PigStorage(',') AS (
    Code:chararray, Description:chararray
);

-- Filtrer l'en-tête
flights_clean = FILTER flights BY Year IS NOT NULL AND Year > 1900;
airports_clean = FILTER airports BY iata != 'iata';
carriers_clean = FILTER carriers BY Code != 'Code';

-- ========================================
-- 1. TOP 20 AEROPORTS PAR VOLUME TOTAL DE VOLS
-- ========================================

-- Compter vols au départ
departures = GROUP flights_clean BY Origin;
dep_count = FOREACH departures GENERATE group AS airport, COUNT(flights_clean) AS nb_departures;

-- Compter vols à l'arrivée
arrivals = GROUP flights_clean BY Dest;
arr_count = FOREACH arrivals GENERATE group AS airport, COUNT(flights_clean) AS nb_arrivals;

-- Jointure et somme
joined_flights = JOIN dep_count BY airport FULL OUTER, arr_count BY airport;
total_flights = FOREACH joined_flights GENERATE 
    (dep_count::airport IS NOT NULL ? dep_count::airport : arr_count::airport) AS airport,
    (dep_count::nb_departures IS NOT NULL ? dep_count::nb_departures : 0L) + 
    (arr_count::nb_arrivals IS NOT NULL ? arr_count::nb_arrivals : 0L) AS total_volume;

-- Trier et prendre top 20
top20_ordered = ORDER total_flights BY total_volume DESC;
top20_airports = LIMIT top20_ordered 20;
STORE top20_airports INTO '/shared_volume/pigout/flights/top20_airports';

-- ========================================
-- 2. POPULARITE DES TRANSPORTEURS
-- ========================================

carrier_group = GROUP flights_clean BY UniqueCarrier;
carrier_stats = FOREACH carrier_group GENERATE 
    group AS carrier_code,
    COUNT(flights_clean) AS nb_vols,
    AVG(flights_clean.Distance) AS distance_moyenne;

-- Jointure avec noms des transporteurs
carrier_popularity = JOIN carrier_stats BY carrier_code LEFT OUTER, carriers_clean BY Code;
carrier_final = FOREACH carrier_popularity GENERATE 
    carrier_stats::carrier_code AS code,
    carriers_clean::Description AS nom,
    carrier_stats::nb_vols AS nombre_vols,
    carrier_stats::distance_moyenne AS distance_moy;

carrier_sorted = ORDER carrier_final BY nombre_vols DESC;
STORE carrier_sorted INTO '/shared_volume/pigout/flights/carrier_popularity';

-- ========================================
-- 3. PROPORTION DE VOLS RETARDES
-- ========================================

-- Définir retard > 15 minutes
delayed_flights = FILTER flights_clean BY ArrDelay IS NOT NULL AND ArrDelay > 15;
ontime_flights = FILTER flights_clean BY ArrDelay IS NOT NULL AND ArrDelay <= 15;

-- Compter par heure de départ
flights_with_hour = FOREACH flights_clean GENERATE 
    (CRSDepTime / 100) AS dep_hour,
    (ArrDelay IS NOT NULL AND ArrDelay > 15 ? 1 : 0) AS is_delayed;

hourly_group = GROUP flights_with_hour BY dep_hour;
hourly_delays = FOREACH hourly_group GENERATE 
    group AS heure,
    COUNT(flights_with_hour) AS total_vols,
    SUM(flights_with_hour.is_delayed) AS vols_retardes,
    (double)SUM(flights_with_hour.is_delayed) / (double)COUNT(flights_with_hour) * 100 AS pct_retard;

hourly_sorted = ORDER hourly_delays BY heure;
STORE hourly_sorted INTO '/shared_volume/pigout/flights/hourly_delays';

-- Par jour de semaine
flights_with_day = FOREACH flights_clean GENERATE 
    DayOfWeek,
    (ArrDelay IS NOT NULL AND ArrDelay > 15 ? 1 : 0) AS is_delayed;

daily_group = GROUP flights_with_day BY DayOfWeek;
daily_delays = FOREACH daily_group {
    delayed = FILTER flights_with_day BY is_delayed == 1;
    GENERATE group AS jour_semaine,
             COUNT(flights_with_day) AS total_vols,
             COUNT(delayed) AS vols_retardes;
}
STORE daily_delays INTO '/shared_volume/pigout/flights/daily_delays';

-- Par mois
monthly_group = GROUP flights_clean BY Month;
monthly_delays = FOREACH monthly_group {
    delayed = FILTER flights_clean BY ArrDelay IS NOT NULL AND ArrDelay > 15;
    GENERATE group AS mois,
             COUNT(flights_clean) AS total_vols,
             COUNT(delayed) AS vols_retardes,
             (double)COUNT(delayed) / (double)COUNT(flights_clean) * 100 AS pct_retard;
}
monthly_sorted = ORDER monthly_delays BY mois;
STORE monthly_sorted INTO '/shared_volume/pigout/flights/monthly_delays';

-- ========================================
-- 4. RETARDS PAR TRANSPORTEUR
-- ========================================

carrier_delays_group = GROUP flights_clean BY UniqueCarrier;
carrier_delays = FOREACH carrier_delays_group {
    delayed = FILTER flights_clean BY ArrDelay IS NOT NULL AND ArrDelay > 15;
    GENERATE group AS carrier,
             COUNT(flights_clean) AS total_vols,
             COUNT(delayed) AS vols_retardes,
             (double)COUNT(delayed) / (double)COUNT(flights_clean) * 100 AS pct_retard;
}
carrier_delays_sorted = ORDER carrier_delays BY pct_retard DESC;
STORE carrier_delays_sorted INTO '/shared_volume/pigout/flights/carrier_delays';

-- ========================================
-- 5. ITINERAIRES LES PLUS FREQUENTS
-- ========================================

routes = FOREACH flights_clean GENERATE Origin, Dest;
routes_group = GROUP routes BY (Origin, Dest);
routes_count = FOREACH routes_group GENERATE 
    FLATTEN(group) AS (origin, destination),
    COUNT(routes) AS nb_vols;

top_routes = ORDER routes_count BY nb_vols DESC;
top20_routes = LIMIT top_routes 20;
STORE top20_routes INTO '/shared_volume/pigout/flights/top_routes';
