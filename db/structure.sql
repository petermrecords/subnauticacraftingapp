SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
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


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: blueprints; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE blueprints (
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

CREATE SEQUENCE blueprints_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: blueprints_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE blueprints_id_seq OWNED BY blueprints.id;


--
-- Name: byproducts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE byproducts (
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

CREATE SEQUENCE byproducts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: byproducts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE byproducts_id_seq OWNED BY byproducts.id;


--
-- Name: materials; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE materials (
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

CREATE SEQUENCE materials_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: materials_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE materials_id_seq OWNED BY materials.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE users (
    id bigint NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: blueprints id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY blueprints ALTER COLUMN id SET DEFAULT nextval('blueprints_id_seq'::regclass);


--
-- Name: byproducts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY byproducts ALTER COLUMN id SET DEFAULT nextval('byproducts_id_seq'::regclass);


--
-- Name: materials id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY materials ALTER COLUMN id SET DEFAULT nextval('materials_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: blueprints blueprints_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY blueprints
    ADD CONSTRAINT blueprints_pkey PRIMARY KEY (id);


--
-- Name: byproducts byproducts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY byproducts
    ADD CONSTRAINT byproducts_pkey PRIMARY KEY (id);


--
-- Name: materials materials_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY materials
    ADD CONSTRAINT materials_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_byproducts_on_material_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_byproducts_on_material_id ON byproducts USING btree (material_id);


--
-- Name: index_materials_on_material_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_materials_on_material_name ON materials USING btree (material_name);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: uix_blueprints; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uix_blueprints ON blueprints USING btree (material_produced_id, material_required_id);


--
-- Name: uix_byproducts; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uix_byproducts ON byproducts USING btree (material_id, byproduct_id);


--
-- Name: byproducts fk_rails_5d5dddaf13; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY byproducts
    ADD CONSTRAINT fk_rails_5d5dddaf13 FOREIGN KEY (byproduct_id) REFERENCES materials(id);


--
-- Name: blueprints fk_rails_7420149fe4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY blueprints
    ADD CONSTRAINT fk_rails_7420149fe4 FOREIGN KEY (material_produced_id) REFERENCES materials(id);


--
-- Name: byproducts fk_rails_ba6e5041d3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY byproducts
    ADD CONSTRAINT fk_rails_ba6e5041d3 FOREIGN KEY (material_id) REFERENCES materials(id);


--
-- Name: blueprints fk_rails_bcc1fbe8d5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY blueprints
    ADD CONSTRAINT fk_rails_bcc1fbe8d5 FOREIGN KEY (material_required_id) REFERENCES materials(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20190927144237'),
('20190927152926'),
('20190927161854'),
('20190928161942');


