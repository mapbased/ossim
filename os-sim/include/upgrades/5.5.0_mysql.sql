USE alienvault;

REPLACE INTO config (conf, value) VALUES ('latest_asset_change', utc_timestamp());
REPLACE INTO config (conf, value) VALUES ('last_update', '2017-11-21');
REPLACE INTO config (conf, value) VALUES ('ossim_schema_version', '5.5.0');

-- PLEASE ADD NOTHING HERE

COMMIT;
-- NOTHING BELOW THIS LINE / NADA DEBAJO DE ESTA LINEA
