CREATE TABLE public.stoptimes
(
  trip_id character varying(50),
  arrival_time character varying(50),
  departure_time character varying(50),
  stop_id character varying(20),
  stop_sequence character varying(50),
  stop_headsign character varying(100),
  pickup_type integer,
  dropoff_type integer
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.stoptimes
  OWNER TO postgres;


 COPY stoptimes FROM 'C:/LeiLin/USX28452/Downloads/COPTER/metro-los-angeles_20160110_0950/stop_times.txt' ( FORMAT CSV, HEADER true, DELIMITER(',') );
 ALTER TABLE stoptimes ADD column id bigserial;


CREATE TABLE public.stops
(
   stop_id character varying(20),
   stop_code character varying(20),
   stop_name character varying(100),
   stop_desc character varying(20),
   stop_lat float,
   stop_lon float,
   stop_url character varying(50),
   location_type character varying(50),
   parent_station character varying(50),
   tpis_name character varying(20)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.stops
  OWNER TO postgres;


 COPY stops FROM 'C:/LeiLin/USX28452/Downloads/COPTER/metro-los-angeles_20160110_0950/stops.txt' ( FORMAT CSV, HEADER true, DELIMITER(',') );
 ALTER TABLE stops ADD column id bigserial;


CREATE TABLE public.routes
(
   route_id character varying(50),
   route_short_name character varying(50),
   route_long_name character varying(50),
   route_desc character varying(50),
   route_type character varying(50),
   route_color character varying(20),
   route_text_color character varying(10),
   route_url character varying(50)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.routes
  OWNER TO postgres;

 COPY routes FROM 'C:/LeiLin/USX28452/Downloads/COPTER/metro-los-angeles_20160110_0950/routes.txt' ( FORMAT CSV, HEADER true, DELIMITER(',') );
 ALTER TABLE routes ADD column id bigserial;

CREATE TABLE public.trips
(
   route_id character varying(50),
   service_id character varying(50),
   trip_id character varying(50),
   trip_headsign character varying(20),
   direction_id integer,
   block_id integer,
   shape_id character varying(50)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.trips
  OWNER TO postgres;

 COPY trips FROM 'C:/LeiLin/USX28452/Downloads/COPTER/metro-los-angeles_20160110_0950/trips.txt' ( FORMAT CSV, HEADER true, DELIMITER(',') );
 ALTER TABLE trips ADD column id bigserial;

 COPY(
 SELECT trips.route_id, trips.direction_id, stoptimes.*, stops.stop_name, stops.stop_lat, stops.stop_lon 
 FROM trips
 INNER JOIN stoptimes ON stoptimes.trip_id = trips.trip_id
 INNER JOIN stops ON stops.stop_id = stoptimes.stop_id
 WHERE route_id = '801' OR route_id = '802' OR route_id = '803' OR route_id = '804' OR route_id = '805' OR route_id = '806' 
 ) TO 'C:/LeiLin/USX28452/Downloads/COPTER/metro-los-angeles_20160110_0950/queryRes.csv' (FORMAT CSV, HEADER true);



 COPY(
 SELECT DISTINCT stops.stop_name, stops.stop_lat, stops.stop_lon 
 FROM trips
 INNER JOIN stoptimes ON stoptimes.trip_id = trips.trip_id
 INNER JOIN stops ON stops.stop_id = stoptimes.stop_id
 WHERE route_id = '801' OR route_id = '802' OR route_id = '803' OR route_id = '804' OR route_id = '805' OR route_id = '806' 
 ) TO 'C:/LeiLin/USX28452/Downloads/COPTER/stationInfo.csv' (FORMAT CSV, HEADER true);