--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: unpmex; Type: SCHEMA; Schema: -; Owner: unpmex
--

CREATE SCHEMA unpmex;


ALTER SCHEMA unpmex OWNER TO unpmex;

--
-- Name: insert_messages2(); Type: FUNCTION; Schema: unpmex; Owner: unpmex
--

CREATE FUNCTION unpmex.insert_messages2() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
        insert into messages2 values (new.*);
        RETURN NEW;
    END;
$$;


ALTER FUNCTION unpmex.insert_messages2() OWNER TO unpmex;

--
-- Name: update_messages2(); Type: FUNCTION; Schema: unpmex; Owner: unpmex
--

CREATE FUNCTION unpmex.update_messages2() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
        delete from messages2 where id = NEW.id;
        INSERT INTO messages2 values(NEW.*);
        RETURN NEW;
    END;
$$;


ALTER FUNCTION unpmex.update_messages2() OWNER TO unpmex;

SET default_tablespace = '';

--
-- Name: messages; Type: TABLE; Schema: unpmex; Owner: unpmex
--

CREATE TABLE unpmex.messages (
    id character varying(36) NOT NULL,
    bulk_id character(36),
    user_id character varying(255) NOT NULL,
    email_to character varying(255),
    email_subject character varying(255),
    email_body text,
    email_template_id character varying(255),
    sms_phone character varying(50),
    sms_content text,
    push_token text,
    push_title character varying(255),
    push_body text,
    push_call_to_action character varying(255),
    mex_title character varying(255),
    mex_body text,
    mex_call_to_action character varying(255),
    io text,
    client_token text,
    sender character varying(255),
    tag_csv character varying(255),
    correlation_id character varying(36),
    read_at timestamp with time zone,
    "timestamp" timestamp with time zone DEFAULT now(),
    memo text,
    tag text[],
    tenant character varying(16) NOT NULL
);


ALTER TABLE unpmex.messages OWNER TO unpmex;

--
-- Name: messages2; Type: TABLE; Schema: unpmex; Owner: unpmex
--

CREATE TABLE unpmex.messages2 (
    id character varying(36) NOT NULL,
    bulk_id character(36),
    user_id character varying(255) NOT NULL,
    email_to character varying(255),
    email_subject character varying(255),
    email_body text,
    email_template_id character varying(255),
    sms_phone character varying(50),
    sms_content text,
    push_token text,
    push_title character varying(255),
    push_body text,
    push_call_to_action character varying(255),
    mex_title character varying(255),
    mex_body text,
    mex_call_to_action character varying(255),
    io text,
    client_token text,
    sender character varying(255),
    tag_csv character varying(255),
    correlation_id character varying(36),
    read_at timestamp with time zone,
    "timestamp" timestamp with time zone DEFAULT now(),
    memo text,
    tag text[],
    tenant character varying(16) NOT NULL
);


ALTER TABLE unpmex.messages2 OWNER TO unpmex;

--
-- Name: messages idx_244709_primary; Type: CONSTRAINT; Schema: unpmex; Owner: unpmex
--

ALTER TABLE ONLY unpmex.messages
    ADD CONSTRAINT idx_244709_primary PRIMARY KEY (id);


--
-- Name: messages2 idx_244716_primary; Type: CONSTRAINT; Schema: unpmex; Owner: unpmex
--

ALTER TABLE ONLY unpmex.messages2
    ADD CONSTRAINT idx_244716_primary PRIMARY KEY (id);


--
-- Name: idx_244709_timestamp; Type: INDEX; Schema: unpmex; Owner: unpmex
--

CREATE INDEX idx_244709_timestamp ON unpmex.messages USING btree ("timestamp");


--
-- Name: idx_244709_user_id_idx; Type: INDEX; Schema: unpmex; Owner: unpmex
--

CREATE INDEX idx_244709_user_id_idx ON unpmex.messages USING btree (user_id);


--
-- Name: messages2_tag_array_idx_gin; Type: INDEX; Schema: unpmex; Owner: unpmex
--

CREATE INDEX messages2_tag_array_idx_gin ON unpmex.messages2 USING gin (tag);


--
-- Name: messages_sender_id_idx; Type: INDEX; Schema: unpmex; Owner: unpmex
--

CREATE INDEX messages_sender_id_idx ON unpmex.messages USING btree (sender, id);


--
-- Name: messages_sender_idx; Type: INDEX; Schema: unpmex; Owner: unpmex
--

CREATE INDEX messages_sender_idx ON unpmex.messages USING btree (sender);


--
-- Name: messages_tag_array_idx_btree; Type: INDEX; Schema: unpmex; Owner: unpmex
--

CREATE INDEX messages_tag_array_idx_btree ON unpmex.messages USING btree (tag);


--
-- Name: messages_timestamp_sender_idx; Type: INDEX; Schema: unpmex; Owner: unpmex
--

CREATE INDEX messages_timestamp_sender_idx ON unpmex.messages USING btree ("timestamp", sender);


--
-- Name: messages_user_id_id_idx; Type: INDEX; Schema: unpmex; Owner: unpmex
--

CREATE INDEX messages_user_id_id_idx ON unpmex.messages USING btree (user_id, id);


--
-- Name: messages bck_insert_messages; Type: TRIGGER; Schema: unpmex; Owner: unpmex
--

CREATE TRIGGER bck_insert_messages AFTER INSERT ON unpmex.messages FOR EACH ROW EXECUTE PROCEDURE unpmex.insert_messages2();


--
-- Name: messages bck_update_messages; Type: TRIGGER; Schema: unpmex; Owner: unpmex
--

CREATE TRIGGER bck_update_messages AFTER UPDATE ON unpmex.messages FOR EACH ROW EXECUTE PROCEDURE unpmex.update_messages2();

