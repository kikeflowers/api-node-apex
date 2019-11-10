CREATE TABLE public.usuarios2
(
    usuario text COLLATE pg_catalog."default",
    nombre text COLLATE pg_catalog."default",
    email text COLLATE pg_catalog."default",
    direccion text COLLATE pg_catalog."default",
    id serial,
    CONSTRAINT usuarios_pkey2 PRIMARY KEY (id)
);


