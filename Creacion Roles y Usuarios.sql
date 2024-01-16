CREATE ROLE rolsuper WITH LOGIN;
CREATE ROLE rolro WITH LOGIN;
CREATE USER superuser WITH PASSWORD 'superusuarioCCM';
GRANT rolsuper TO superuser;
CREATE USER rouser WITH PASSWORD '12345';
GRANT rolro TO rouser;
--Otorgar permisos a los Roles
DO $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN SELECT tablename FROM pg_tables WHERE schemaname = 'public'
    LOOP
        EXECUTE 'GRANT SELECT, INSERT, UPDATE, DELETE ON ' || quote_ident(r.tablename) || ' TO rolsuper';
    END LOOP;
END
$$;

DO $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN SELECT sequence_name FROM information_schema.sequences WHERE sequence_schema = 'public'
    LOOP
        EXECUTE 'GRANT USAGE, SELECT ON SEQUENCE public.' || quote_ident(r.sequence_name) || ' TO rolsuper';
    END LOOP;
END
$$;

DO $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN SELECT tablename FROM pg_tables WHERE schemaname = 'public'
    LOOP
        EXECUTE 'GRANT SELECT ON ' || quote_ident(r.tablename) || ' TO rolro';
    END LOOP;
END
$$;