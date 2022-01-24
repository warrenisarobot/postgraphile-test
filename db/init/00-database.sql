\connect forum_example;

CREATE EXTENSION "uuid-ossp";

/*Create user table in public schema*/
CREATE TABLE public.user (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    username TEXT,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE public.user IS
'Forum users.';

/*Create post table in public schema*/
CREATE TABLE public.post (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    title TEXT,
    body TEXT,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    author_id uuid NOT NULL REFERENCES public.user(id)
);

COMMENT ON TABLE public.post IS
'Forum posts written by a user.';



CREATE OR REPLACE FUNCTION public.sync_user_role()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    VOLATILE NOT LEAKPROOF
AS $BODY$
   	 BEGIN
     	EXECUTE format('CREATE ROLE %I', NEW.id);
		RETURN NULL;
	 END;
$BODY$;

ALTER FUNCTION public.sync_user_role()
    OWNER TO postgres;

GRANT EXECUTE ON FUNCTION public.sync_user_role() TO postgres;

GRANT EXECUTE ON FUNCTION public.sync_user_role() TO PUBLIC;


CREATE TRIGGER _000_add_user_as_role
    AFTER INSERT
    ON public."user"
    FOR EACH ROW
    EXECUTE FUNCTION public.sync_user_role();
