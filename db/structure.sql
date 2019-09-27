SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: blueprints; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.blueprints (
    id bigint NOT NULL,
    material_produced_id integer NOT NULL,
    material_required_id integer NOT NULL,
    number_required integer NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: blueprints_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.blueprints_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: blueprints_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.blueprints_id_seq OWNED BY public.blueprints.id;


--
-- Name: byproducts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.byproducts (
    id bigint NOT NULL,
    material_id bigint NOT NULL,
    byproduct_id integer NOT NULL,
    number_produced integer NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: byproducts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.byproducts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: byproducts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.byproducts_id_seq OWNED BY public.byproducts.id;


--
-- Name: materials; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.materials (
    id bigint NOT NULL,
    material_name character varying NOT NULL,
    material_type character varying NOT NULL,
    material_subtype character varying,
    inventory_spaces integer,
    growbed_spaces integer,
    wearable_slot character varying,
    storage_spaces_provided integer,
    crafted_at character varying,
    number_produced integer,
    material_description text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: materials_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.materials_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: materials_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.materials_id_seq OWNED BY public.materials.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: blueprints id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.blueprints ALTER COLUMN id SET DEFAULT nextval('public.blueprints_id_seq'::regclass);


--
-- Name: byproducts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.byproducts ALTER COLUMN id SET DEFAULT nextval('public.byproducts_id_seq'::regclass);


--
-- Name: materials id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.materials ALTER COLUMN id SET DEFAULT nextval('public.materials_id_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: blueprints blueprints_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.blueprints
    ADD CONSTRAINT blueprints_pkey PRIMARY KEY (id);


--
-- Name: byproducts byproducts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.byproducts
    ADD CONSTRAINT byproducts_pkey PRIMARY KEY (id);


--
-- Name: materials materials_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.materials
    ADD CONSTRAINT materials_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: index_byproducts_on_material_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_byproducts_on_material_id ON public.byproducts USING btree (material_id);


--
-- Name: index_materials_on_material_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_materials_on_material_name ON public.materials USING btree (material_name);


--
-- Name: uix_blueprints; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uix_blueprints ON public.blueprints USING btree (material_produced_id, material_required_id);


--
-- Name: uix_byproducts; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uix_byproducts ON public.byproducts USING btree (material_id, byproduct_id);


--
-- Name: byproducts fk_rails_5d5dddaf13; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.byproducts
    ADD CONSTRAINT fk_rails_5d5dddaf13 FOREIGN KEY (byproduct_id) REFERENCES public.materials(id);


--
-- Name: blueprints fk_rails_7420149fe4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.blueprints
    ADD CONSTRAINT fk_rails_7420149fe4 FOREIGN KEY (material_produced_id) REFERENCES public.materials(id);


--
-- Name: byproducts fk_rails_ba6e5041d3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.byproducts
    ADD CONSTRAINT fk_rails_ba6e5041d3 FOREIGN KEY (material_id) REFERENCES public.materials(id);


--
-- Name: blueprints fk_rails_bcc1fbe8d5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.blueprints
    ADD CONSTRAINT fk_rails_bcc1fbe8d5 FOREIGN KEY (material_required_id) REFERENCES public.materials(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20190927144237'),
('20190927152926'),
('20190927161854');


