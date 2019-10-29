--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.11
-- Dumped by pg_dump version 9.6.11

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
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: getnextid(character varying); Type: FUNCTION; Schema: public; Owner: funasauser
--

CREATE FUNCTION public.getnextid(character varying) RETURNS integer
    LANGUAGE sql
    AS $_$SELECT CAST (nextval($1 || '_seq') AS INTEGER) AS RESULT;$_$;


ALTER FUNCTION public.getnextid(character varying) OWNER TO funasauser;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: bitstream; Type: TABLE; Schema: public; Owner: funasauser
--

CREATE TABLE public.bitstream (
    bitstream_id integer,
    bitstream_format_id integer,
    checksum character varying(64),
    checksum_algorithm character varying(32),
    internal_id character varying(256),
    deleted boolean,
    store_number integer,
    sequence_id integer,
    size_bytes bigint,
    uuid uuid DEFAULT public.gen_random_uuid() NOT NULL
);


ALTER TABLE public.bitstream OWNER TO funasauser;

--
-- Name: bitstreamformatregistry; Type: TABLE; Schema: public; Owner: funasauser
--

CREATE TABLE public.bitstreamformatregistry (
    bitstream_format_id integer NOT NULL,
    mimetype character varying(256),
    short_description character varying(128),
    description text,
    support_level integer,
    internal boolean
);


ALTER TABLE public.bitstreamformatregistry OWNER TO funasauser;

--
-- Name: bitstreamformatregistry_seq; Type: SEQUENCE; Schema: public; Owner: funasauser
--

CREATE SEQUENCE public.bitstreamformatregistry_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.bitstreamformatregistry_seq OWNER TO funasauser;

--
-- Name: bundle; Type: TABLE; Schema: public; Owner: funasauser
--

CREATE TABLE public.bundle (
    bundle_id integer,
    uuid uuid DEFAULT public.gen_random_uuid() NOT NULL,
    primary_bitstream_id uuid
);


ALTER TABLE public.bundle OWNER TO funasauser;

--
-- Name: bundle2bitstream; Type: TABLE; Schema: public; Owner: funasauser
--

CREATE TABLE public.bundle2bitstream (
    bitstream_order_legacy integer,
    bundle_id uuid NOT NULL,
    bitstream_id uuid NOT NULL,
    bitstream_order integer NOT NULL
);


ALTER TABLE public.bundle2bitstream OWNER TO funasauser;

--
-- Name: checksum_history; Type: TABLE; Schema: public; Owner: funasauser
--

CREATE TABLE public.checksum_history (
    check_id bigint NOT NULL,
    process_start_date timestamp without time zone,
    process_end_date timestamp without time zone,
    checksum_expected character varying,
    checksum_calculated character varying,
    result character varying,
    bitstream_id uuid
);


ALTER TABLE public.checksum_history OWNER TO funasauser;

--
-- Name: checksum_history_check_id_seq; Type: SEQUENCE; Schema: public; Owner: funasauser
--

CREATE SEQUENCE public.checksum_history_check_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.checksum_history_check_id_seq OWNER TO funasauser;

--
-- Name: checksum_history_check_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: funasauser
--

ALTER SEQUENCE public.checksum_history_check_id_seq OWNED BY public.checksum_history.check_id;


--
-- Name: checksum_results; Type: TABLE; Schema: public; Owner: funasauser
--

CREATE TABLE public.checksum_results (
    result_code character varying NOT NULL,
    result_description character varying
);


ALTER TABLE public.checksum_results OWNER TO funasauser;

--
-- Name: collection; Type: TABLE; Schema: public; Owner: funasauser
--

CREATE TABLE public.collection (
    collection_id integer,
    uuid uuid DEFAULT public.gen_random_uuid() NOT NULL,
    workflow_step_1 uuid,
    workflow_step_2 uuid,
    workflow_step_3 uuid,
    submitter uuid,
    template_item_id uuid,
    logo_bitstream_id uuid,
    admin uuid
);


ALTER TABLE public.collection OWNER TO funasauser;

--
-- Name: collection2item; Type: TABLE; Schema: public; Owner: funasauser
--

CREATE TABLE public.collection2item (
    collection_id uuid NOT NULL,
    item_id uuid NOT NULL
);


ALTER TABLE public.collection2item OWNER TO funasauser;

--
-- Name: community; Type: TABLE; Schema: public; Owner: funasauser
--

CREATE TABLE public.community (
    community_id integer,
    uuid uuid DEFAULT public.gen_random_uuid() NOT NULL,
    admin uuid,
    logo_bitstream_id uuid
);


ALTER TABLE public.community OWNER TO funasauser;

--
-- Name: community2collection; Type: TABLE; Schema: public; Owner: funasauser
--

CREATE TABLE public.community2collection (
    collection_id uuid NOT NULL,
    community_id uuid NOT NULL
);


ALTER TABLE public.community2collection OWNER TO funasauser;

--
-- Name: community2community; Type: TABLE; Schema: public; Owner: funasauser
--

CREATE TABLE public.community2community (
    parent_comm_id uuid NOT NULL,
    child_comm_id uuid NOT NULL
);


ALTER TABLE public.community2community OWNER TO funasauser;

--
-- Name: doi; Type: TABLE; Schema: public; Owner: funasauser
--

CREATE TABLE public.doi (
    doi_id integer NOT NULL,
    doi character varying(256),
    resource_type_id integer,
    resource_id integer,
    status integer,
    dspace_object uuid
);


ALTER TABLE public.doi OWNER TO funasauser;

--
-- Name: doi_seq; Type: SEQUENCE; Schema: public; Owner: funasauser
--

CREATE SEQUENCE public.doi_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.doi_seq OWNER TO funasauser;

--
-- Name: dspaceobject; Type: TABLE; Schema: public; Owner: funasauser
--

CREATE TABLE public.dspaceobject (
    uuid uuid NOT NULL
);


ALTER TABLE public.dspaceobject OWNER TO funasauser;

--
-- Name: eperson; Type: TABLE; Schema: public; Owner: funasauser
--

CREATE TABLE public.eperson (
    eperson_id integer,
    email character varying(64),
    password character varying(128),
    can_log_in boolean,
    require_certificate boolean,
    self_registered boolean,
    last_active timestamp without time zone,
    sub_frequency integer,
    netid character varying(64),
    salt character varying(32),
    digest_algorithm character varying(16),
    uuid uuid DEFAULT public.gen_random_uuid() NOT NULL
);


ALTER TABLE public.eperson OWNER TO funasauser;

--
-- Name: epersongroup; Type: TABLE; Schema: public; Owner: funasauser
--

CREATE TABLE public.epersongroup (
    eperson_group_id integer,
    uuid uuid DEFAULT public.gen_random_uuid() NOT NULL,
    permanent boolean DEFAULT false,
    name character varying(250)
);


ALTER TABLE public.epersongroup OWNER TO funasauser;

--
-- Name: epersongroup2eperson; Type: TABLE; Schema: public; Owner: funasauser
--

CREATE TABLE public.epersongroup2eperson (
    eperson_group_id uuid NOT NULL,
    eperson_id uuid NOT NULL
);


ALTER TABLE public.epersongroup2eperson OWNER TO funasauser;

--
-- Name: epersongroup2workspaceitem; Type: TABLE; Schema: public; Owner: funasauser
--

CREATE TABLE public.epersongroup2workspaceitem (
    workspace_item_id integer NOT NULL,
    eperson_group_id uuid NOT NULL
);


ALTER TABLE public.epersongroup2workspaceitem OWNER TO funasauser;

--
-- Name: fileextension; Type: TABLE; Schema: public; Owner: funasauser
--

CREATE TABLE public.fileextension (
    file_extension_id integer NOT NULL,
    bitstream_format_id integer,
    extension character varying(16)
);


ALTER TABLE public.fileextension OWNER TO funasauser;

--
-- Name: fileextension_seq; Type: SEQUENCE; Schema: public; Owner: funasauser
--

CREATE SEQUENCE public.fileextension_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.fileextension_seq OWNER TO funasauser;

--
-- Name: group2group; Type: TABLE; Schema: public; Owner: funasauser
--

CREATE TABLE public.group2group (
    parent_id uuid NOT NULL,
    child_id uuid NOT NULL
);


ALTER TABLE public.group2group OWNER TO funasauser;

--
-- Name: group2groupcache; Type: TABLE; Schema: public; Owner: funasauser
--

CREATE TABLE public.group2groupcache (
    parent_id uuid NOT NULL,
    child_id uuid NOT NULL
);


ALTER TABLE public.group2groupcache OWNER TO funasauser;

--
-- Name: handle; Type: TABLE; Schema: public; Owner: funasauser
--

CREATE TABLE public.handle (
    handle_id integer NOT NULL,
    handle character varying(256),
    resource_type_id integer,
    resource_legacy_id integer,
    resource_id uuid
);


ALTER TABLE public.handle OWNER TO funasauser;

--
-- Name: handle_id_seq; Type: SEQUENCE; Schema: public; Owner: funasauser
--

CREATE SEQUENCE public.handle_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.handle_id_seq OWNER TO funasauser;

--
-- Name: handle_seq; Type: SEQUENCE; Schema: public; Owner: funasauser
--

CREATE SEQUENCE public.handle_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.handle_seq OWNER TO funasauser;

--
-- Name: harvested_collection; Type: TABLE; Schema: public; Owner: funasauser
--

CREATE TABLE public.harvested_collection (
    harvest_type integer,
    oai_source character varying,
    oai_set_id character varying,
    harvest_message character varying,
    metadata_config_id character varying,
    harvest_status integer,
    harvest_start_time timestamp with time zone,
    last_harvested timestamp with time zone,
    id integer NOT NULL,
    collection_id uuid
);


ALTER TABLE public.harvested_collection OWNER TO funasauser;

--
-- Name: harvested_collection_seq; Type: SEQUENCE; Schema: public; Owner: funasauser
--

CREATE SEQUENCE public.harvested_collection_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.harvested_collection_seq OWNER TO funasauser;

--
-- Name: harvested_item; Type: TABLE; Schema: public; Owner: funasauser
--

CREATE TABLE public.harvested_item (
    last_harvested timestamp with time zone,
    oai_id character varying,
    id integer NOT NULL,
    item_id uuid
);


ALTER TABLE public.harvested_item OWNER TO funasauser;

--
-- Name: harvested_item_seq; Type: SEQUENCE; Schema: public; Owner: funasauser
--

CREATE SEQUENCE public.harvested_item_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.harvested_item_seq OWNER TO funasauser;

--
-- Name: history_seq; Type: SEQUENCE; Schema: public; Owner: funasauser
--

CREATE SEQUENCE public.history_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.history_seq OWNER TO funasauser;

--
-- Name: item; Type: TABLE; Schema: public; Owner: funasauser
--

CREATE TABLE public.item (
    item_id integer,
    in_archive boolean,
    withdrawn boolean,
    last_modified timestamp with time zone,
    discoverable boolean,
    uuid uuid DEFAULT public.gen_random_uuid() NOT NULL,
    submitter_id uuid,
    owning_collection uuid
);


ALTER TABLE public.item OWNER TO funasauser;

--
-- Name: item2bundle; Type: TABLE; Schema: public; Owner: funasauser
--

CREATE TABLE public.item2bundle (
    bundle_id uuid NOT NULL,
    item_id uuid NOT NULL
);


ALTER TABLE public.item2bundle OWNER TO funasauser;

--
-- Name: metadatafieldregistry_seq; Type: SEQUENCE; Schema: public; Owner: funasauser
--

CREATE SEQUENCE public.metadatafieldregistry_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.metadatafieldregistry_seq OWNER TO funasauser;

--
-- Name: metadatafieldregistry; Type: TABLE; Schema: public; Owner: funasauser
--

CREATE TABLE public.metadatafieldregistry (
    metadata_field_id integer DEFAULT nextval('public.metadatafieldregistry_seq'::regclass) NOT NULL,
    metadata_schema_id integer NOT NULL,
    element character varying(64),
    qualifier character varying(64),
    scope_note text
);


ALTER TABLE public.metadatafieldregistry OWNER TO funasauser;

--
-- Name: metadataschemaregistry_seq; Type: SEQUENCE; Schema: public; Owner: funasauser
--

CREATE SEQUENCE public.metadataschemaregistry_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.metadataschemaregistry_seq OWNER TO funasauser;

--
-- Name: metadataschemaregistry; Type: TABLE; Schema: public; Owner: funasauser
--

CREATE TABLE public.metadataschemaregistry (
    metadata_schema_id integer DEFAULT nextval('public.metadataschemaregistry_seq'::regclass) NOT NULL,
    namespace character varying(256),
    short_id character varying(32)
);


ALTER TABLE public.metadataschemaregistry OWNER TO funasauser;

--
-- Name: metadatavalue_seq; Type: SEQUENCE; Schema: public; Owner: funasauser
--

CREATE SEQUENCE public.metadatavalue_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.metadatavalue_seq OWNER TO funasauser;

--
-- Name: metadatavalue; Type: TABLE; Schema: public; Owner: funasauser
--

CREATE TABLE public.metadatavalue (
    metadata_value_id integer DEFAULT nextval('public.metadatavalue_seq'::regclass) NOT NULL,
    metadata_field_id integer,
    text_value text,
    text_lang character varying(24),
    place integer,
    authority character varying(100),
    confidence integer DEFAULT '-1'::integer,
    dspace_object_id uuid
);


ALTER TABLE public.metadatavalue OWNER TO funasauser;

--
-- Name: most_recent_checksum; Type: TABLE; Schema: public; Owner: funasauser
--

CREATE TABLE public.most_recent_checksum (
    to_be_processed boolean NOT NULL,
    expected_checksum character varying NOT NULL,
    current_checksum character varying NOT NULL,
    last_process_start_date timestamp without time zone NOT NULL,
    last_process_end_date timestamp without time zone NOT NULL,
    checksum_algorithm character varying NOT NULL,
    matched_prev_checksum boolean NOT NULL,
    result character varying,
    bitstream_id uuid
);


ALTER TABLE public.most_recent_checksum OWNER TO funasauser;

--
-- Name: registrationdata; Type: TABLE; Schema: public; Owner: funasauser
--

CREATE TABLE public.registrationdata (
    registrationdata_id integer NOT NULL,
    email character varying(64),
    token character varying(48),
    expires timestamp without time zone
);


ALTER TABLE public.registrationdata OWNER TO funasauser;

--
-- Name: registrationdata_seq; Type: SEQUENCE; Schema: public; Owner: funasauser
--

CREATE SEQUENCE public.registrationdata_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.registrationdata_seq OWNER TO funasauser;

--
-- Name: requestitem; Type: TABLE; Schema: public; Owner: funasauser
--

CREATE TABLE public.requestitem (
    requestitem_id integer NOT NULL,
    token character varying(48),
    allfiles boolean,
    request_email character varying(64),
    request_name character varying(64),
    request_date timestamp without time zone,
    accept_request boolean,
    decision_date timestamp without time zone,
    expires timestamp without time zone,
    request_message text,
    item_id uuid,
    bitstream_id uuid
);


ALTER TABLE public.requestitem OWNER TO funasauser;

--
-- Name: requestitem_seq; Type: SEQUENCE; Schema: public; Owner: funasauser
--

CREATE SEQUENCE public.requestitem_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.requestitem_seq OWNER TO funasauser;

--
-- Name: resourcepolicy; Type: TABLE; Schema: public; Owner: funasauser
--

CREATE TABLE public.resourcepolicy (
    policy_id integer NOT NULL,
    resource_type_id integer,
    resource_id integer,
    action_id integer,
    start_date date,
    end_date date,
    rpname character varying(30),
    rptype character varying(30),
    rpdescription text,
    eperson_id uuid,
    epersongroup_id uuid,
    dspace_object uuid
);


ALTER TABLE public.resourcepolicy OWNER TO funasauser;

--
-- Name: resourcepolicy_seq; Type: SEQUENCE; Schema: public; Owner: funasauser
--

CREATE SEQUENCE public.resourcepolicy_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.resourcepolicy_seq OWNER TO funasauser;

--
-- Name: schema_version; Type: TABLE; Schema: public; Owner: funasauser
--

CREATE TABLE public.schema_version (
    installed_rank integer NOT NULL,
    version character varying(50),
    description character varying(200) NOT NULL,
    type character varying(20) NOT NULL,
    script character varying(1000) NOT NULL,
    checksum integer,
    installed_by character varying(100) NOT NULL,
    installed_on timestamp without time zone DEFAULT now() NOT NULL,
    execution_time integer NOT NULL,
    success boolean NOT NULL
);


ALTER TABLE public.schema_version OWNER TO funasauser;

--
-- Name: site; Type: TABLE; Schema: public; Owner: funasauser
--

CREATE TABLE public.site (
    uuid uuid NOT NULL
);


ALTER TABLE public.site OWNER TO funasauser;

--
-- Name: subscription; Type: TABLE; Schema: public; Owner: funasauser
--

CREATE TABLE public.subscription (
    subscription_id integer NOT NULL,
    eperson_id uuid,
    collection_id uuid
);


ALTER TABLE public.subscription OWNER TO funasauser;

--
-- Name: subscription_seq; Type: SEQUENCE; Schema: public; Owner: funasauser
--

CREATE SEQUENCE public.subscription_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.subscription_seq OWNER TO funasauser;

--
-- Name: tasklistitem; Type: TABLE; Schema: public; Owner: funasauser
--

CREATE TABLE public.tasklistitem (
    tasklist_id integer NOT NULL,
    workflow_id integer,
    eperson_id uuid
);


ALTER TABLE public.tasklistitem OWNER TO funasauser;

--
-- Name: tasklistitem_seq; Type: SEQUENCE; Schema: public; Owner: funasauser
--

CREATE SEQUENCE public.tasklistitem_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tasklistitem_seq OWNER TO funasauser;

--
-- Name: versionhistory; Type: TABLE; Schema: public; Owner: funasauser
--

CREATE TABLE public.versionhistory (
    versionhistory_id integer NOT NULL
);


ALTER TABLE public.versionhistory OWNER TO funasauser;

--
-- Name: versionhistory_seq; Type: SEQUENCE; Schema: public; Owner: funasauser
--

CREATE SEQUENCE public.versionhistory_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.versionhistory_seq OWNER TO funasauser;

--
-- Name: versionitem; Type: TABLE; Schema: public; Owner: funasauser
--

CREATE TABLE public.versionitem (
    versionitem_id integer NOT NULL,
    version_number integer,
    version_date timestamp without time zone,
    version_summary character varying(255),
    versionhistory_id integer,
    eperson_id uuid,
    item_id uuid
);


ALTER TABLE public.versionitem OWNER TO funasauser;

--
-- Name: versionitem_seq; Type: SEQUENCE; Schema: public; Owner: funasauser
--

CREATE SEQUENCE public.versionitem_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.versionitem_seq OWNER TO funasauser;

--
-- Name: webapp; Type: TABLE; Schema: public; Owner: funasauser
--

CREATE TABLE public.webapp (
    webapp_id integer NOT NULL,
    appname character varying(32),
    url character varying,
    started timestamp without time zone,
    isui integer
);


ALTER TABLE public.webapp OWNER TO funasauser;

--
-- Name: webapp_seq; Type: SEQUENCE; Schema: public; Owner: funasauser
--

CREATE SEQUENCE public.webapp_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.webapp_seq OWNER TO funasauser;

--
-- Name: workflowitem; Type: TABLE; Schema: public; Owner: funasauser
--

CREATE TABLE public.workflowitem (
    workflow_id integer NOT NULL,
    state integer,
    multiple_titles boolean,
    published_before boolean,
    multiple_files boolean,
    item_id uuid,
    collection_id uuid,
    owner uuid
);


ALTER TABLE public.workflowitem OWNER TO funasauser;

--
-- Name: workflowitem_seq; Type: SEQUENCE; Schema: public; Owner: funasauser
--

CREATE SEQUENCE public.workflowitem_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.workflowitem_seq OWNER TO funasauser;

--
-- Name: workspaceitem; Type: TABLE; Schema: public; Owner: funasauser
--

CREATE TABLE public.workspaceitem (
    workspace_item_id integer NOT NULL,
    multiple_titles boolean,
    published_before boolean,
    multiple_files boolean,
    stage_reached integer,
    page_reached integer,
    item_id uuid,
    collection_id uuid
);


ALTER TABLE public.workspaceitem OWNER TO funasauser;

--
-- Name: workspaceitem_seq; Type: SEQUENCE; Schema: public; Owner: funasauser
--

CREATE SEQUENCE public.workspaceitem_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.workspaceitem_seq OWNER TO funasauser;

--
-- Name: checksum_history check_id; Type: DEFAULT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.checksum_history ALTER COLUMN check_id SET DEFAULT nextval('public.checksum_history_check_id_seq'::regclass);


--
-- Data for Name: bitstream; Type: TABLE DATA; Schema: public; Owner: funasauser
--

COPY public.bitstream (bitstream_id, bitstream_format_id, checksum, checksum_algorithm, internal_id, deleted, store_number, sequence_id, size_bytes, uuid) FROM stdin;
\N	4	e1032c18f29644821c1ca184abe7f627	MD5	72885084615825553981429249809201442715	f	0	1	1062348	a36abd3c-a60d-454e-b3f6-c661d35d035b
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	87365557438761435928618001395211791456	f	0	2	1748	916f5c8f-f012-4adb-8a55-1352136a4e85
\N	6	a41262bc5f502b3c93959a7bdc62c35c	MD5	92665005729641812815598915403232829483	t	0	10	19687	bdd0442a-c010-4085-91e6-08ae289263d6
\N	6	a41262bc5f502b3c93959a7bdc62c35c	MD5	67939088126467067675551588263741191626	f	0	22	19687	5bb00ffc-b25e-487d-a336-aa5b07b778ec
\N	6	8f19bcefd1613115c3c496d2cb21ea04	MD5	146942028980956841825531604883430879093	t	0	3	98350	7b26105a-af1e-4b1f-a66a-f8267a25b94b
\N	16	43781add9fec5c6cf82e554bd1254cad	MD5	113425428200642426638800874819455333334	t	0	12	148051	fc2aee31-cfb0-41b6-9b61-84b092376ea9
\N	4	988c5ed45e6bf01f93d439b367eca981	MD5	99979145084808464091307094686624663801	f	0	1	1329667	0d9ed226-7e90-48b9-807d-f0b893dd48b0
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	160878048882087862787032077876183820044	f	0	2	1748	599069e2-0776-4d86-8654-9c6352b3b7c7
\N	16	8a4a5b6255163c5fd05c76b3e00496cf	MD5	5223422200060661326459818085475785439	t	0	14	6113	a35fbc18-7ef2-4f1d-9673-e6cc6330b8a9
\N	4	69fe6fc72ec299bb38047f8305ec6581	MD5	39227825688398274177751286036961760436	f	0	1	9879310	2b2be099-c0d6-40a0-9daf-83fb0c6a8328
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	20265751046458420036113368327735331130	f	0	2	1748	d5ba2f5e-4e86-40fd-b152-3ae25ff15c7d
\N	16	8f1deb7493e2d3c6312d529945525671	MD5	81055528281629377548756662266517539992	f	0	24	18644	aedad30e-a19a-468a-9f45-22219de85513
\N	6	8f19bcefd1613115c3c496d2cb21ea04	MD5	80776991874313258395738997978010011656	t	0	7	98350	b7ff174d-067a-4e2c-8e44-3a5482ba8034
\N	6	a41262bc5f502b3c93959a7bdc62c35c	MD5	42352703162349107214360566331336215796	t	0	3	19687	34482a2e-2400-4e9f-85a2-c7e9a654af28
\N	16	8a4a5b6255163c5fd05c76b3e00496cf	MD5	155889890053966095510191679591676889676	t	0	23	6113	7615c83e-de9f-4751-80d3-b8a8ffbc41cd
\N	16	8a4a5b6255163c5fd05c76b3e00496cf	MD5	155868052970023027909418994720007585570	t	0	4	6113	15560463-2b70-4a26-9df1-e0de90c0df9e
\N	16	75a49302c9ed7415f475cf113486c57e	MD5	42092401059223081832232570781040972185	t	0	8	6681	43fc62cf-973e-46f8-bc35-ca46c9cf1952
\N	6	8f19bcefd1613115c3c496d2cb21ea04	MD5	133562404358222884932844244393212268569	f	0	15	98350	551fa807-a0c5-4594-8861-b4b6f6f6d82e
\N	6	a41262bc5f502b3c93959a7bdc62c35c	MD5	111250460634997872536273399793344007053	t	0	13	19687	f0370f2f-d71c-4799-9e2a-aa5c4f0efe12
\N	16	6accd25907b14cbfcf4ddc75858e36a4	MD5	85199100932939231977700749826863588799	t	0	15	148051	d532b057-4536-4ca6-ac4b-537d52c2c8bc
\N	6	8f19bcefd1613115c3c496d2cb21ea04	MD5	6569562480391788373354765323905441643	t	0	9	98350	3d0b7cc1-77a0-4562-a8ef-469c0f0bb11c
\N	6	a41262bc5f502b3c93959a7bdc62c35c	MD5	56448656319582546420164317361364265084	t	0	7	19687	2f994c23-2fe4-4031-9b44-fd2d8b3036a8
\N	16	75a49302c9ed7415f475cf113486c57e	MD5	157273890312738228771610323553263296032	t	0	10	6681	d7fdf9dd-5702-4353-b54f-8700d7d39cb2
\N	6	a41262bc5f502b3c93959a7bdc62c35c	MD5	149365490312100647757372073269974741668	t	0	5	19687	91adcac7-c635-47a7-9816-5a36a00e79be
\N	4	f764acc95d7fc9bb27499cc0e052f97f	MD5	99179868284381481240937049570353795500	f	0	1	81058	a5bae5f3-528a-48f5-9a62-1d9f45445a95
\N	16	8a4a5b6255163c5fd05c76b3e00496cf	MD5	117281468194961539270633419482902298934	t	0	6	6113	dc46a916-640f-4d78-bf42-a019a5176256
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	5768365481236924272258848719781542203	f	0	2	1748	a15549c9-dd49-4ae1-a01b-5506f097c6ca
\N	16	8a4a5b6255163c5fd05c76b3e00496cf	MD5	109618507513513043420055105594755691729	t	0	8	6113	3d028ecc-c3ff-4a05-acda-2afbfe231cb5
\N	16	75a49302c9ed7415f475cf113486c57e	MD5	111017905543361089014317296100575043346	t	0	4	6681	0161965c-a80c-46ab-b33a-d596c6eb912a
\N	1	dec00bc4b11660d0259ed2b4d57e8f0e	MD5	107066774884221228165217035338184802930	f	0	-1	417511	b1f9e084-1af0-4671-a7a6-29f55d92e4e5
\N	6	a84c5fc55290947a84da96b4e9843eb1	MD5	81871599504788112654457394483527022328	t	0	3	312760	9ec2493d-5731-4e86-a02e-a9e9cf3b2e12
\N	16	e4deba1d3e645a3f2e4e19cd52ed9b5d	MD5	43671636270314993290374820359549791631	t	0	4	5015	24f41a56-b4f0-43f7-858d-5fcb0621541b
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	2306149823668245207873960335959169522	f	0	2	1748	9df5ca2c-3147-401a-9d3c-1638a6f02ad0
\N	16	e4deba1d3e645a3f2e4e19cd52ed9b5d	MD5	65162102384497044784746728717500511789	t	0	6	5015	ae7ac122-7e41-4d56-8699-1a0c44e62241
\N	6	0e378be0c3ee0efdf05e1cf9872a8223	MD5	164960783774992734784765582795898861489	t	0	2	11	56ac04cc-163d-4316-a0e3-a09dab85594d
\N	16	d782eb655fd979e5e677a49ceb955fbb	MD5	110161839991949003165620832037040750354	t	0	9	148051	91ff9e31-a61d-42bb-9fdd-405a17220205
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	123194458764450981842453897951119520827	f	0	1	1748	fa9b00c5-369d-4db7-bec8-45627225438d
\N	16	8a4a5b6255163c5fd05c76b3e00496cf	MD5	101546097123307219547900401107082446507	t	0	11	6113	2e5c87b0-0c5d-47fb-af1a-bffe4a2305be
\N	6	8f19bcefd1613115c3c496d2cb21ea04	MD5	124114484833502184525751778325472457514	t	0	5	98350	33dc18c8-e0d8-488d-89fd-1dc632373638
\N	6	8a40b4d31a53dd39dfa5b541022e09ce	MD5	140234795211804172355718729014512376097	f	0	1	24	1b6078c0-fb54-4ff6-b526-890bb95184a1
\N	16	75a49302c9ed7415f475cf113486c57e	MD5	160509429187081263723076912011346718875	t	0	6	6681	ef695971-00b7-4c43-8a47-1f3c31272310
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	87161854535676694958479176702060584732	f	0	2	1748	d889cbef-ad65-49c8-a2e7-835a8262d9bc
\N	6	a84c5fc55290947a84da96b4e9843eb1	MD5	115444314432035975085223172275169990119	t	0	5	312760	41ca3781-3d14-4290-857b-74de1273742a
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	38433085175324151647255466673500894240	f	0	1	1748	ddbfcf61-6825-46a0-afe5-f307b4bdefe9
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	21186389019551876004020149051674228894	f	0	1	1748	4afdf8ac-bf2a-4d7d-9020-24aaa7344ce7
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	42333580763036011549230440897762227218	f	0	1	1748	e67500f7-2f48-4894-816e-bd8d52c46382
\N	16	4cc8552c3c7a762be0f5771e92a0efd2	MD5	84851820594607767337296606806646508304	f	0	1	1865922	df71148b-a7aa-4c7f-9496-b0eaee0aae6f
\N	6	8a40b4d31a53dd39dfa5b541022e09ce	MD5	124515932674649345931192646386290737503	t	0	1	24	910a3078-9fba-457e-a3d2-5a8a42a4a59b
\N	16	7d1ca3a36fd6fb0ccc8def6309ed97cc	MD5	66344940305703136758027798885475672350	t	0	7	148037	9ca1f9d3-7329-431a-8925-de7be40f98f1
\N	6	a41262bc5f502b3c93959a7bdc62c35c	MD5	133769414350630934951001983395364985425	t	0	20	19687	5c8e9a8c-d250-4519-86ee-90b00716aced
\N	6	a84c5fc55290947a84da96b4e9843eb1	MD5	18140279636325349925937618293732877011	t	0	8	312760	d222311e-6af9-453e-a7e8-a51be09ab3af
\N	16	e4deba1d3e645a3f2e4e19cd52ed9b5d	MD5	41486286583200469592750158415668148423	t	0	9	5015	1e206441-d46b-41a3-bde6-b16ab75b9e22
\N	16	8f1deb7493e2d3c6312d529945525671	MD5	60869825831147763156502973599018725148	t	0	21	18644	0f75ba2c-cff7-496b-a5f8-b02ab18a4081
\N	6	8f19bcefd1613115c3c496d2cb21ea04	MD5	146730157847996561880909707622419859796	t	0	13	98350	c0ff9ebd-65e4-4f18-a28d-30fab3441ec9
\N	16	405edf392ddc7c6c858e25158b3c32b8	MD5	107587714914794095491388556775340193102	t	0	14	14794	060ff518-0b92-4a23-8b14-a53e5d45d5b1
\N	16	7203d995e8a63584d7ba0623f6ac994c	MD5	151995579535173400088749132898528135559	t	0	10	148037	094768e3-b838-4ce5-811d-114d2fa070cb
\N	6	8f19bcefd1613115c3c496d2cb21ea04	MD5	147610156995945358165361190173951811003	t	0	11	98350	bd8f5557-4558-4906-96cf-2b0bf72fe8f5
\N	16	e4deba1d3e645a3f2e4e19cd52ed9b5d	MD5	148054898941970485257478709756888108307	t	0	12	5015	3e3f1469-9f2d-4ad6-88f1-e11fcb9bbd73
\N	16	405edf392ddc7c6c858e25158b3c32b8	MD5	68216440038985707584402672753818397243	f	0	17	14794	5690cd4e-8606-4c7e-ab6d-078223839687
\N	16	75a49302c9ed7415f475cf113486c57e	MD5	159714833559118397179068159481185966632	t	0	16	6681	8eebc70a-4b00-4482-b947-0c5e7294aae0
\N	4	691a771e7db0948af6a196954a367b22	MD5	98350145567007275643201543610013078493	f	0	1	6347638	73328566-b3cc-4516-a70f-3d7fe821151b
\N	6	a84c5fc55290947a84da96b4e9843eb1	MD5	77528838792930903980250409258529089571	f	0	20	312760	8b34f2e0-5993-4256-9619-3c691d85be98
\N	6	8f19bcefd1613115c3c496d2cb21ea04	MD5	23834008123883069466086536286371720829	t	0	12	98350	e44af120-0129-47e5-993b-09b5d17149e3
\N	6	a84c5fc55290947a84da96b4e9843eb1	MD5	7104727224996026104395717740462310128	t	0	18	312760	103b738b-104b-4e0c-9331-6b0cae944943
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	131728935175654345862374391726789485692	f	0	1	1748	50e510a9-0bdb-4a55-b55f-dc37ea43633a
\N	16	d81127947cef3eccb788902b975d13f1	MD5	59852849146952517600639395560641051171	t	0	19	17597	d3b78492-0db6-415b-a406-b3fcb4d9a3ac
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	99231642232714182966416493257747408205	f	0	2	1748	cf9c4758-a326-4605-b96c-86f858c213c6
\N	6	a84c5fc55290947a84da96b4e9843eb1	MD5	138713582056769049829485295762990024588	t	0	11	312760	2b6bf1e3-bc59-4c23-ba1b-b99c4f8b6076
\N	16	d81127947cef3eccb788902b975d13f1	MD5	54547369422172282557563348042386006961	f	0	22	17597	c571a8dc-0d71-42e2-9b92-2b2ef5675ade
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	42079442399750004703593094943185345870	f	0	1	1748	90378b0b-c426-4551-a9f9-800896dbf44e
\N	16	08a5507751862820cb38fe40dcf13196	MD5	54239852047071983383192990231619337877	t	0	13	148037	c79ad9e7-f621-4ec5-a0d9-c2bcffb8e307
\N	16	e4deba1d3e645a3f2e4e19cd52ed9b5d	MD5	168878856406823727548937291387075326011	t	0	21	5015	99df2191-1118-4f68-9ebe-0c08df306d89
\N	4	512ffc5ac6b2178df4bd83b49555cdf3	MD5	162183706146888238406410488972857836105	f	0	1	16357552	1c879e87-ef55-4420-9fff-a0d9ef52a1c2
\N	6	a41262bc5f502b3c93959a7bdc62c35c	MD5	144529471945368071295563215500434363214	t	0	16	19687	7f497245-2823-4263-9d37-96793901a7cd
\N	1	0ccd9da314d3b6eed9955d24b2397e23	MD5	100486173138273947258200411724790035097	f	0	-1	312885	d6834eae-2c8a-4ff3-85b8-022bdee1d3dd
\N	16	7b0e023f415f3d272a3ac6839a93aa7a	MD5	107729069598374200549506487462744890710	t	0	17	148051	6aac1840-ba1a-4fbf-98c7-3639d6baf971
\N	1	6e3f4d6729d4551bb71e129264d4390c	MD5	102209024315673771355974005417228613720	f	0	-1	276056	a3226bcc-9f1c-4216-9d44-8f1dcb06288b
\N	1	926b9453b9ae4dbceeedaf8b6b375dac	MD5	34244540571394666322057479118664058562	f	0	-1	93418	c85acf18-4bc6-49d8-aeb1-9ac4b2666956
\N	6	a84c5fc55290947a84da96b4e9843eb1	MD5	38263483165057822042478880614479385105	t	0	14	312760	43f467c7-150e-4fca-ae72-d736dd3be02e
\N	1	e04adfb254ec4daa0a9ecdd051cadff6	MD5	141080605302912401660157945975909070893	f	0	-1	304834	75885d51-2fb0-4968-a3de-fe0c53eceb6b
\N	16	d759834c63c8c1b8a398828a79533cc0	MD5	66561568532891061728123079078652325825	t	0	15	148037	fd0b8087-877f-4855-ad71-9c24986821dd
\N	1	a1d61f654ed5b79131007e0839cfc413	MD5	32833523149072418497061097550464619715	f	0	-1	278553	fa813a90-86ff-4f16-8639-424d9db60bf7
\N	1	2eb12cf9dbce1d873405ec8f5559a81a	MD5	38674261682085866195246962095221680489	f	0	-1	207007	67d54727-eeb4-4daa-8c41-40fd40134cad
\N	6	a41262bc5f502b3c93959a7bdc62c35c	MD5	39294735101107226941511117396159778028	t	0	18	19687	b769f832-39bf-4295-bafb-418932987f3d
\N	1	ef6cefd91d4c342983cfe60c06c33b61	MD5	91215326551775358099306956747097925089	f	0	-1	179153	6bb85bb3-b2a7-4cfc-8fe5-eda2707287b4
\N	16	7cdea85cd12fe68f19d04efa33211582	MD5	88785847976209781822937544084092114290	t	0	19	148049	44939725-96d2-4935-8030-00bb43cad6fc
\N	1	88582105bfbc56c3b1df33abb3161179	MD5	144977777286976953452126256699910222111	f	0	-1	69756	5727043c-4c89-4e29-a594-6b8fe56ad3f7
\N	6	61c0dc269fa0068407c60996358bdbf1	MD5	7441745092968188144573072188156992297	t	0	1	7	a4765167-b5ef-478c-a067-cd5dbcd6aceb
\N	6	a84c5fc55290947a84da96b4e9843eb1	MD5	100080543051075318221881724847549088455	t	0	16	312760	773d1a57-3eec-45c7-9d19-0c011d2e4b1f
\N	4	6a04b40b877e7bf32fcb914329e9e01b	MD5	81814423750313090873090853431488772719	f	0	1	213493	e5e4b3e2-45fe-4ff9-8766-bee1f235ad36
\N	16	f163021220c3919dad2c13399aba91fb	MD5	71714425788902804200308696372017724362	t	0	17	148035	13a8e654-e35a-47f7-bce3-c709c5f56beb
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	107209550051596556368192842525385813265	f	0	2	1748	8a5f262f-0da7-41bc-82ad-8f7eb1609617
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	54872202099328982081127556195017794940	f	0	2	1748	bc954f78-c223-4b19-ad6c-059227740671
\N	4	96940ef65a4ec2fd3b92de8c13d79e88	MD5	93281836622895279908187714828014857218	f	0	3	34686	2966e974-c340-4197-94de-d6815d41bf0d
\N	6	5c9c273831526a35586249f0bcc8ae5b	MD5	70302765781399614867411693104468945480	f	0	3	7	0ee257a7-150e-4396-9c23-4d155ead67d5
\N	16	1e2ce8edeb99a9b399d81f23e96e2ad9	MD5	58252878799665931547653053299856749240	f	0	4	1975	069756ac-ffb4-41f5-b33c-d90e382e79b4
\N	6	63a619ad06ec5a1e25d65ba477e4228c	MD5	93820292841285309413238130471568986429	f	0	4	4215	f3688f7e-ed1a-43e0-ad17-6f3638d64723
\N	16	a73b783b3b093f5ab5c02a9aa26d3f22	MD5	73335004493396600923005055135933270039	f	0	5	5637	29eef076-48c8-40af-b18c-7bcac3baa316
\N	6	4ea59b5690cc0a10667ee9b335537ae9	MD5	42552168107806241047156790936931323343	f	0	3	25	8c007dd9-ff34-4051-a72a-3e9cce0c5c8f
\N	6	29ab2cf5ee27a38bd268d01394c9b0a6	MD5	60516512378184473706484416379025543940	f	0	3	103672	b0828ac7-d229-4f84-ae1b-77d8a212c0ff
\N	6	cf4a8571ca84b4cdb604f08bc334e489	MD5	69871586613749580629052914485266971518	f	0	3	9739	1d3c4bdf-7b01-4175-9d09-1698499c29c5
\N	16	a17c4913b38209b4728b759925b5b62a	MD5	15805799006135326036150115638829924316	f	0	4	8615	9dd6b47b-f9b5-47e0-8ad0-0012c5c9ef2f
\N	16	a2d1384db7a082b3f846006891908f22	MD5	22618563922522366817406522158496748115	f	0	4	5575	d129fd45-13f2-414f-a2a3-cb8c153c2c08
\N	16	94798a00382a735c3b8d85e4be5b9d63	MD5	20609421054533813546512366934718469470	f	0	3	27804	2962c64d-2d70-40c7-99d0-c09489937317
\N	1	2e03d3fd5df4279fefd14b7ec3f7d707	MD5	33477352172206062192450063908098628109	t	0	-1	9762	98287454-b304-41d2-882c-9bf97d30f141
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	71905739183527356574964487648950246322	f	0	1	1748	20138169-8e01-4926-aeae-04135b3706eb
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	65997733401420510273145518826027525761	f	0	1	1748	e61f61ed-6bf9-4e74-91be-f0bdf50bc671
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	114264993528338246230947898135099414655	f	0	1	1748	c9cd3978-6216-4983-b67e-5d697ec20b81
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	34463030749871240531871032291235342228	f	0	1	1748	5bcae71d-2a79-4652-a04c-c9bf08923201
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	33418296108518178026378312245144760731	f	0	1	1748	ec87a684-65b5-4c2e-9ec0-df33773c4e5b
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	94993377464866509067550188240159786947	f	0	1	1748	c2fe3a86-8006-4f44-ad3a-9689e269a3c3
\.


--
-- Data for Name: bitstreamformatregistry; Type: TABLE DATA; Schema: public; Owner: funasauser
--

COPY public.bitstreamformatregistry (bitstream_format_id, mimetype, short_description, description, support_level, internal) FROM stdin;
1	application/octet-stream	Unknown	Unknown data format	0	f
2	text/plain; charset=utf-8	License	Item-specific license agreed upon to submission	1	t
3	text/html; charset=utf-8	CC License	Item-specific Creative Commons license agreed upon to submission	1	t
4	application/pdf	Adobe PDF	Adobe Portable Document Format	1	f
5	text/xml	XML	Extensible Markup Language	1	f
6	text/plain	Text	Plain Text	1	f
7	text/html	HTML	Hypertext Markup Language	1	f
8	text/css	CSS	Cascading Style Sheets	1	f
9	application/msword	Microsoft Word	Microsoft Word	1	f
10	application/vnd.openxmlformats-officedocument.wordprocessingml.document	Microsoft Word XML	Microsoft Word XML	1	f
11	application/vnd.ms-powerpoint	Microsoft Powerpoint	Microsoft Powerpoint	1	f
12	application/vnd.openxmlformats-officedocument.presentationml.presentation	Microsoft Powerpoint XML	Microsoft Powerpoint XML	1	f
13	application/vnd.ms-excel	Microsoft Excel	Microsoft Excel	1	f
14	application/vnd.openxmlformats-officedocument.spreadsheetml.sheet	Microsoft Excel XML	Microsoft Excel XML	1	f
15	application/marc	MARC	Machine-Readable Cataloging records	1	f
16	image/jpeg	JPEG	Joint Photographic Experts Group/JPEG File Interchange Format (JFIF)	1	f
17	image/gif	GIF	Graphics Interchange Format	1	f
18	image/png	image/png	Portable Network Graphics	1	f
19	image/tiff	TIFF	Tag Image File Format	1	f
20	audio/x-aiff	AIFF	Audio Interchange File Format	1	f
21	audio/basic	audio/basic	Basic Audio	1	f
22	audio/x-wav	WAV	Broadcase Wave Format	1	f
23	video/mpeg	MPEG	Moving Picture Experts Group	1	f
24	text/richtext	RTF	Rich Text Format	1	f
25	application/vnd.visio	Microsoft Visio	Microsoft Visio	1	f
26	application/x-filemaker	FMP3	Filemaker Pro	1	f
27	image/x-ms-bmp	BMP	Microsoft Windows bitmap	1	f
28	application/x-photoshop	Photoshop	Photoshop	1	f
29	application/postscript	Postscript	Postscript Files	1	f
30	video/quicktime	Video Quicktime	Video Quicktime	1	f
31	audio/x-mpeg	MPEG Audio	MPEG Audio	1	f
32	application/vnd.ms-project	Microsoft Project	Microsoft Project	1	f
33	application/mathematica	Mathematica	Mathematica Notebook	1	f
34	application/x-latex	LateX	LaTeX document	1	f
35	application/x-tex	TeX	Tex/LateX document	1	f
36	application/x-dvi	TeX dvi	TeX dvi format	1	f
37	application/sgml	SGML	SGML application (RFC 1874)	1	f
38	application/wordperfect5.1	WordPerfect	WordPerfect 5.1 document	1	f
39	audio/x-pn-realaudio	RealAudio	RealAudio file	1	f
40	image/x-photo-cd	Photo CD	Kodak Photo CD image	1	f
41	application/vnd.oasis.opendocument.text	OpenDocument Text	OpenDocument Text	1	f
42	application/vnd.oasis.opendocument.text-template	OpenDocument Text Template	OpenDocument Text Template	1	f
43	application/vnd.oasis.opendocument.text-web	OpenDocument HTML Template	OpenDocument HTML Template	1	f
44	application/vnd.oasis.opendocument.text-master	OpenDocument Master Document	OpenDocument Master Document	1	f
45	application/vnd.oasis.opendocument.graphics	OpenDocument Drawing	OpenDocument Drawing	1	f
46	application/vnd.oasis.opendocument.graphics-template	OpenDocument Drawing Template	OpenDocument Drawing Template	1	f
47	application/vnd.oasis.opendocument.presentation	OpenDocument Presentation	OpenDocument Presentation	1	f
48	application/vnd.oasis.opendocument.presentation-template	OpenDocument Presentation Template	OpenDocument Presentation Template	1	f
49	application/vnd.oasis.opendocument.spreadsheet	OpenDocument Spreadsheet	OpenDocument Spreadsheet	1	f
50	application/vnd.oasis.opendocument.spreadsheet-template	OpenDocument Spreadsheet Template	OpenDocument Spreadsheet Template	1	f
51	application/vnd.oasis.opendocument.chart	OpenDocument Chart	OpenDocument Chart	1	f
52	application/vnd.oasis.opendocument.formula	OpenDocument Formula	OpenDocument Formula	1	f
53	application/vnd.oasis.opendocument.database	OpenDocument Database	OpenDocument Database	1	f
54	application/vnd.oasis.opendocument.image	OpenDocument Image	OpenDocument Image	1	f
55	application/vnd.openofficeorg.extension	OpenOffice.org extension	OpenOffice.org extension (since OOo 2.1)	1	f
56	application/vnd.sun.xml.writer	Writer 6.0 documents	Writer 6.0 documents	1	f
57	application/vnd.sun.xml.writer.template	Writer 6.0 templates	Writer 6.0 templates	1	f
58	application/vnd.sun.xml.calc	Calc 6.0 spreadsheets	Calc 6.0 spreadsheets	1	f
59	application/vnd.sun.xml.calc.template	Calc 6.0 templates	Calc 6.0 templates	1	f
60	application/vnd.sun.xml.draw	Draw 6.0 documents	Draw 6.0 documents	1	f
61	application/vnd.sun.xml.draw.template	Draw 6.0 templates	Draw 6.0 templates	1	f
62	application/vnd.sun.xml.impress	Impress 6.0 presentations	Impress 6.0 presentations	1	f
63	application/vnd.sun.xml.impress.template	Impress 6.0 templates	Impress 6.0 templates	1	f
64	application/vnd.sun.xml.writer.global	Writer 6.0 global documents	Writer 6.0 global documents	1	f
65	application/vnd.sun.xml.math	Math 6.0 documents	Math 6.0 documents	1	f
66	application/vnd.stardivision.writer	StarWriter 5.x documents	StarWriter 5.x documents	1	f
67	application/vnd.stardivision.writer-global	StarWriter 5.x global documents	StarWriter 5.x global documents	1	f
68	application/vnd.stardivision.calc	StarCalc 5.x spreadsheets	StarCalc 5.x spreadsheets	1	f
69	application/vnd.stardivision.draw	StarDraw 5.x documents	StarDraw 5.x documents	1	f
70	application/vnd.stardivision.impress	StarImpress 5.x presentations	StarImpress 5.x presentations	1	f
71	application/vnd.stardivision.impress-packed	StarImpress Packed 5.x files	StarImpress Packed 5.x files	1	f
72	application/vnd.stardivision.math	StarMath 5.x documents	StarMath 5.x documents	1	f
73	application/vnd.stardivision.chart	StarChart 5.x documents	StarChart 5.x documents	1	f
74	application/vnd.stardivision.mail	StarMail 5.x mail files	StarMail 5.x mail files	1	f
75	application/rdf+xml; charset=utf-8	RDF XML	RDF serialized in XML	1	f
76	application/epub+zip	EPUB	Electronic publishing	1	f
\.


--
-- Name: bitstreamformatregistry_seq; Type: SEQUENCE SET; Schema: public; Owner: funasauser
--

SELECT pg_catalog.setval('public.bitstreamformatregistry_seq', 76, true);


--
-- Data for Name: bundle; Type: TABLE DATA; Schema: public; Owner: funasauser
--

COPY public.bundle (bundle_id, uuid, primary_bitstream_id) FROM stdin;
\N	12f6e52a-9df2-4bc6-8a4a-f88cebb87203	\N
\N	da51fa58-1abe-4f80-bbc7-9e72e48e1fcf	\N
\N	e629b0d9-bf91-439a-9f16-632d621535b2	\N
\N	972d8284-ac47-4d48-82fe-103a24fbe65b	\N
\N	5c1126f4-8376-42d3-b83e-3f4f070a6710	\N
\N	276a4446-ee69-4bc0-8f29-690dbf3fbaa2	\N
\N	a260f402-ab1b-48d5-8f31-e54b8246e97e	\N
\N	2dd047b5-e43b-4ba9-8d1d-b6badc87a459	\N
\N	7bba6efb-709f-4b4a-b666-654168314b1c	\N
\N	539670a8-3427-4d5c-96ac-02b95f900003	\N
\N	9709fcb3-1e1e-4825-89cf-6774de18420b	\N
\N	a63a3b39-a5c2-478d-b57b-c250553fa2e0	\N
\N	93182026-e06b-4654-950f-39cc4aa0180f	\N
\N	1f55e71a-6121-4374-baf3-3f6e8881131a	\N
\N	b46e66b6-fef8-4551-844b-f48b51f18887	\N
\N	6c09d5c6-7db2-4d59-a23c-a0cff7ea31da	\N
\N	c6f291c2-9995-454e-a838-cb645ec2de77	\N
\N	75c62285-d1bb-4897-a31f-230c5115c6c5	\N
\N	6a68fb46-a034-4129-b96e-b8d5209945cb	\N
\N	50ffad89-623b-41e4-986a-c3a2feaade8c	\N
\N	35120e12-4729-4a25-a25b-572399403a63	\N
\N	ad33886e-87fb-4206-a2de-6feb2995e006	\N
\N	4658a0b2-50e4-444a-b4ac-e4d6d7aa559c	\N
\N	dbcfe7c2-b2ab-4cef-a7e2-1574b7387410	\N
\N	9496fe87-9539-44d1-8ca3-4d62c300194d	\N
\N	f927872e-3dba-4482-af19-719b731d7fea	\N
\N	b6a93f95-1b06-48ac-8422-c0ff627bc780	\N
\N	d2fd6cdc-efbe-47ba-bb06-06971d06d11b	\N
\N	2715b220-a689-4384-89a8-78efb69abf3b	\N
\N	d5ab3c0f-e4fb-4d5d-80bb-f66751da4850	\N
\N	0b1f1831-2e41-4c59-af71-5f537a9a1a22	\N
\N	de0009cf-13b5-4649-86fe-90fc9eec3b30	\N
\N	b9bc2a0e-639a-4587-9f6d-42fec43ffd82	\N
\N	0a7a2874-2f9d-477f-9044-465aae71afcd	\N
\N	1c7b63c0-8006-4d71-a70b-1a59ce3ba62f	\N
\N	fe7ea1de-7497-4d64-93b5-a6b56d21eee8	\N
\N	5bfb5579-17ed-4113-b850-5d52fe90f1f7	\N
\N	a761698f-3924-4e7d-9219-37f93670fdf0	\N
\N	22be2e2a-2cf2-4956-a75f-bb4ff2c756b9	\N
\N	ab12cb79-aac2-414b-9946-6a754548e110	\N
\N	bf28708a-d254-4e0b-9189-a5704d83d883	\N
\N	d755ed7e-018c-4209-ae5c-a485a3172ccb	\N
\N	c05c05d3-d9ac-4896-8ed1-46ac985ae51c	\N
\N	edc044e1-bae6-4e22-b2a6-5ac50f8576c6	\N
\N	7e111fd6-e95d-46fa-8e6a-fc112f2c3468	\N
\N	e3f4ba1b-0b3f-477f-9785-2c45c1cc53e4	\N
\N	cea631f7-6753-416e-a6f1-83b25760bf3a	\N
\.


--
-- Data for Name: bundle2bitstream; Type: TABLE DATA; Schema: public; Owner: funasauser
--

COPY public.bundle2bitstream (bitstream_order_legacy, bundle_id, bitstream_id, bitstream_order) FROM stdin;
\N	12f6e52a-9df2-4bc6-8a4a-f88cebb87203	a36abd3c-a60d-454e-b3f6-c661d35d035b	0
\N	da51fa58-1abe-4f80-bbc7-9e72e48e1fcf	916f5c8f-f012-4adb-8a55-1352136a4e85	0
\N	5c1126f4-8376-42d3-b83e-3f4f070a6710	0d9ed226-7e90-48b9-807d-f0b893dd48b0	0
\N	276a4446-ee69-4bc0-8f29-690dbf3fbaa2	599069e2-0776-4d86-8654-9c6352b3b7c7	0
\N	a260f402-ab1b-48d5-8f31-e54b8246e97e	2b2be099-c0d6-40a0-9daf-83fb0c6a8328	0
\N	2dd047b5-e43b-4ba9-8d1d-b6badc87a459	d5ba2f5e-4e86-40fd-b152-3ae25ff15c7d	0
\N	e629b0d9-bf91-439a-9f16-632d621535b2	5bb00ffc-b25e-487d-a336-aa5b07b778ec	0
\N	972d8284-ac47-4d48-82fe-103a24fbe65b	aedad30e-a19a-468a-9f45-22219de85513	0
\N	7bba6efb-709f-4b4a-b666-654168314b1c	551fa807-a0c5-4594-8861-b4b6f6f6d82e	0
\N	539670a8-3427-4d5c-96ac-02b95f900003	5690cd4e-8606-4c7e-ab6d-078223839687	0
\N	9709fcb3-1e1e-4825-89cf-6774de18420b	8b34f2e0-5993-4256-9619-3c691d85be98	0
\N	a63a3b39-a5c2-478d-b57b-c250553fa2e0	c571a8dc-0d71-42e2-9b92-2b2ef5675ade	0
\N	93182026-e06b-4654-950f-39cc4aa0180f	a5bae5f3-528a-48f5-9a62-1d9f45445a95	0
\N	1f55e71a-6121-4374-baf3-3f6e8881131a	a15549c9-dd49-4ae1-a01b-5506f097c6ca	0
\N	b46e66b6-fef8-4551-844b-f48b51f18887	9df5ca2c-3147-401a-9d3c-1638a6f02ad0	0
\N	6c09d5c6-7db2-4d59-a23c-a0cff7ea31da	fa9b00c5-369d-4db7-bec8-45627225438d	0
\N	c6f291c2-9995-454e-a838-cb645ec2de77	50e510a9-0bdb-4a55-b55f-dc37ea43633a	0
\N	75c62285-d1bb-4897-a31f-230c5115c6c5	1b6078c0-fb54-4ff6-b526-890bb95184a1	0
\N	6a68fb46-a034-4129-b96e-b8d5209945cb	d889cbef-ad65-49c8-a2e7-835a8262d9bc	0
\N	50ffad89-623b-41e4-986a-c3a2feaade8c	ddbfcf61-6825-46a0-afe5-f307b4bdefe9	0
\N	35120e12-4729-4a25-a25b-572399403a63	4afdf8ac-bf2a-4d7d-9020-24aaa7344ce7	0
\N	ad33886e-87fb-4206-a2de-6feb2995e006	e67500f7-2f48-4894-816e-bd8d52c46382	0
\N	4658a0b2-50e4-444a-b4ac-e4d6d7aa559c	e5e4b3e2-45fe-4ff9-8766-bee1f235ad36	0
\N	dbcfe7c2-b2ab-4cef-a7e2-1574b7387410	8a5f262f-0da7-41bc-82ad-8f7eb1609617	0
\N	9496fe87-9539-44d1-8ca3-4d62c300194d	df71148b-a7aa-4c7f-9496-b0eaee0aae6f	0
\N	f927872e-3dba-4482-af19-719b731d7fea	bc954f78-c223-4b19-ad6c-059227740671	0
\N	b6a93f95-1b06-48ac-8422-c0ff627bc780	2966e974-c340-4197-94de-d6815d41bf0d	0
\N	d2fd6cdc-efbe-47ba-bb06-06971d06d11b	0ee257a7-150e-4396-9c23-4d155ead67d5	0
\N	2715b220-a689-4384-89a8-78efb69abf3b	069756ac-ffb4-41f5-b33c-d90e382e79b4	0
\N	d5ab3c0f-e4fb-4d5d-80bb-f66751da4850	f3688f7e-ed1a-43e0-ad17-6f3638d64723	0
\N	0b1f1831-2e41-4c59-af71-5f537a9a1a22	29eef076-48c8-40af-b18c-7bcac3baa316	0
\N	de0009cf-13b5-4649-86fe-90fc9eec3b30	8c007dd9-ff34-4051-a72a-3e9cce0c5c8f	0
\N	b9bc2a0e-639a-4587-9f6d-42fec43ffd82	1d3c4bdf-7b01-4175-9d09-1698499c29c5	0
\N	0a7a2874-2f9d-477f-9044-465aae71afcd	9dd6b47b-f9b5-47e0-8ad0-0012c5c9ef2f	0
\N	1c7b63c0-8006-4d71-a70b-1a59ce3ba62f	2962c64d-2d70-40c7-99d0-c09489937317	0
\N	fe7ea1de-7497-4d64-93b5-a6b56d21eee8	73328566-b3cc-4516-a70f-3d7fe821151b	0
\N	5bfb5579-17ed-4113-b850-5d52fe90f1f7	cf9c4758-a326-4605-b96c-86f858c213c6	0
\N	a761698f-3924-4e7d-9219-37f93670fdf0	b0828ac7-d229-4f84-ae1b-77d8a212c0ff	0
\N	22be2e2a-2cf2-4956-a75f-bb4ff2c756b9	d129fd45-13f2-414f-a2a3-cb8c153c2c08	0
\N	ab12cb79-aac2-414b-9946-6a754548e110	90378b0b-c426-4551-a9f9-800896dbf44e	0
\N	bf28708a-d254-4e0b-9189-a5704d83d883	1c879e87-ef55-4420-9fff-a0d9ef52a1c2	0
\N	d755ed7e-018c-4209-ae5c-a485a3172ccb	20138169-8e01-4926-aeae-04135b3706eb	0
\N	c05c05d3-d9ac-4896-8ed1-46ac985ae51c	e61f61ed-6bf9-4e74-91be-f0bdf50bc671	0
\N	edc044e1-bae6-4e22-b2a6-5ac50f8576c6	c9cd3978-6216-4983-b67e-5d697ec20b81	0
\N	7e111fd6-e95d-46fa-8e6a-fc112f2c3468	5bcae71d-2a79-4652-a04c-c9bf08923201	0
\N	e3f4ba1b-0b3f-477f-9785-2c45c1cc53e4	ec87a684-65b5-4c2e-9ec0-df33773c4e5b	0
\N	cea631f7-6753-416e-a6f1-83b25760bf3a	c2fe3a86-8006-4f44-ad3a-9689e269a3c3	0
\.


--
-- Data for Name: checksum_history; Type: TABLE DATA; Schema: public; Owner: funasauser
--

COPY public.checksum_history (check_id, process_start_date, process_end_date, checksum_expected, checksum_calculated, result, bitstream_id) FROM stdin;
\.


--
-- Name: checksum_history_check_id_seq; Type: SEQUENCE SET; Schema: public; Owner: funasauser
--

SELECT pg_catalog.setval('public.checksum_history_check_id_seq', 1, false);


--
-- Data for Name: checksum_results; Type: TABLE DATA; Schema: public; Owner: funasauser
--

COPY public.checksum_results (result_code, result_description) FROM stdin;
INVALID_HISTORY	Install of the cheksum checking code do not consider this history as valid
BITSTREAM_NOT_FOUND	The bitstream could not be found
CHECKSUM_MATCH	Current checksum matched previous checksum
CHECKSUM_NO_MATCH	Current checksum does not match previous checksum
CHECKSUM_PREV_NOT_FOUND	Previous checksum was not found: no comparison possible
BITSTREAM_INFO_NOT_FOUND	Bitstream info not found
CHECKSUM_ALGORITHM_INVALID	Invalid checksum algorithm
BITSTREAM_NOT_PROCESSED	Bitstream marked to_be_processed=false
BITSTREAM_MARKED_DELETED	Bitstream marked deleted in bitstream table
\.


--
-- Data for Name: collection; Type: TABLE DATA; Schema: public; Owner: funasauser
--

COPY public.collection (collection_id, uuid, workflow_step_1, workflow_step_2, workflow_step_3, submitter, template_item_id, logo_bitstream_id, admin) FROM stdin;
\N	afd22d8d-4201-4482-888c-c06b85307651	\N	\N	\N	\N	\N	\N	\N
\N	4b0ebee1-3f02-43c5-bdac-923b17a459bb	\N	\N	\N	\N	\N	\N	\N
\N	240b86fb-057a-4098-b4a9-16362bd4d88e	\N	\N	\N	\N	\N	\N	\N
\N	f02c8749-274c-4492-ba7b-cc33c3b8db61	\N	\N	\N	\N	\N	\N	\N
\N	28df2a70-de20-4c58-a5c8-e3c24e688cee	\N	\N	\N	\N	\N	\N	\N
\N	19737605-9de5-494c-b19e-7118aa37b963	\N	\N	\N	\N	\N	\N	\N
\N	f5a61cfd-721a-4eba-bf4f-4fa931159f12	\N	\N	\N	\N	\N	\N	\N
\N	bf82b5db-01cb-402c-81a9-8249ff7395a6	\N	\N	\N	\N	\N	\N	\N
\N	2aa863cf-c22a-4dae-8aed-2f08b702420a	\N	\N	\N	\N	\N	\N	\N
\N	d72bd580-c8d7-46af-ad71-ee7a50bbd582	\N	\N	\N	\N	\N	\N	\N
\N	0607dd1b-5468-48ef-8905-8d07d253d1f7	\N	\N	\N	\N	\N	\N	\N
\N	d52095c9-d548-4f66-9dad-d84f4928ded7	\N	\N	\N	\N	\N	\N	\N
\N	f805ab68-cf57-431a-affc-8ce7f9778fe7	\N	\N	\N	\N	\N	\N	\N
\N	5f662caf-e96c-432e-8137-a17afe17283b	\N	\N	\N	\N	\N	\N	\N
\N	fc9b46f8-dd31-4298-9f47-73af77f1c56d	\N	\N	\N	\N	\N	\N	\N
\N	c32fae4a-fdfa-4498-a50a-bc9285fbb3a0	\N	\N	\N	\N	\N	\N	\N
\N	8f327435-da4d-4bbe-99f2-df602eddf8fb	\N	\N	\N	\N	\N	\N	\N
\N	b73c9ead-ff11-4e99-bcd0-86186ccd10aa	\N	\N	\N	\N	\N	\N	\N
\N	fd415204-97cc-4568-938b-467f663aab73	\N	\N	\N	\N	\N	\N	\N
\N	19cefe3e-817f-4584-8647-e1e0345ca422	\N	\N	\N	\N	\N	\N	\N
\N	3bf97251-0d2c-497a-b1c0-2fb8f089d5d9	\N	\N	\N	\N	\N	\N	\N
\N	24a1c3ff-d7a4-4e39-92ca-bbbd1ef02a13	\N	\N	\N	\N	\N	\N	\N
\N	60f00aaf-c385-4dcb-b9a4-ed59d23e3feb	\N	\N	\N	\N	\N	\N	\N
\N	2a26db78-5987-40be-b908-a20da0086e8b	\N	\N	\N	\N	\N	\N	\N
\N	4e7863f5-b198-47e4-8eb1-688af9155b78	\N	\N	\N	\N	\N	\N	\N
\N	b85655ce-7a32-438b-9211-a8b12ec6dcfd	\N	\N	\N	\N	\N	\N	\N
\N	33d85721-7ff3-4926-ae80-084bb178dd97	\N	\N	\N	\N	\N	\N	\N
\N	9a582dff-81aa-4021-9f30-f75871aeb9eb	\N	\N	\N	\N	\N	\N	\N
\N	681bb445-6fc8-49c1-9915-1d418f2ac4d1	\N	\N	\N	\N	\N	\N	\N
\N	96f9e582-cb6e-441e-a361-97f5e69b8ff2	\N	\N	\N	\N	\N	\N	\N
\N	88d41f3a-a149-4dc5-81a2-84380835533a	\N	\N	\N	\N	\N	\N	\N
\N	41b5c503-8ca0-435f-8103-3e692593b755	\N	\N	\N	\N	\N	\N	\N
\N	728d1b2f-f32f-4ba9-80ff-922deca5458b	\N	\N	\N	\N	\N	\N	\N
\N	a2561e5d-7cbf-464d-b6e6-6178bddd9bae	\N	\N	\N	\N	\N	\N	\N
\N	25c745b0-5b75-44bd-91fb-f468f52c377b	\N	\N	\N	\N	\N	\N	\N
\N	357da42e-ffb4-43f7-bb59-3b66f6d09b1f	\N	\N	\N	\N	\N	\N	\N
\N	8a52ac60-0cb5-4d6f-8b4c-a9cd65b62d0a	\N	\N	\N	\N	\N	\N	\N
\N	d851294f-191c-46a0-abf4-d338042d5971	\N	\N	\N	\N	\N	\N	\N
\N	fbe5350a-c8ba-4a39-98e2-bd742a6be202	\N	\N	\N	\N	\N	\N	\N
\N	3afa7efe-2891-4c47-b396-c83d56ff9d90	\N	\N	\N	\N	\N	\N	\N
\N	f2c7e15a-2db1-4099-9d26-78ba2c16b8da	\N	\N	\N	\N	\N	\N	\N
\N	cd75101b-abb6-46ef-ac88-3af552f33478	\N	\N	\N	\N	\N	\N	\N
\N	b55202c0-1e3b-4eba-909d-54f7fad48b9c	\N	\N	\N	\N	\N	\N	\N
\N	411dd125-33df-451a-87c9-7dca418b665e	\N	\N	\N	\N	\N	\N	\N
\N	7db66edb-3f9f-4c24-8fa2-0a4b11efb0b8	\N	\N	\N	\N	\N	\N	\N
\N	b2020a23-0063-4efe-b770-9c9a5a099b42	\N	\N	\N	\N	\N	\N	\N
\N	6a8d7523-aace-4c61-9a7f-9133ae72d7b0	\N	\N	\N	\N	\N	\N	\N
\N	3449a99e-7799-4ba0-bd51-63ae8ee23093	\N	\N	\N	\N	\N	\N	\N
\N	1e0e772a-32a3-4fef-99c9-2aeab683bae2	\N	\N	\N	\N	\N	\N	\N
\N	909a8161-d474-4b0e-afdc-5a5ae63c3a6c	\N	\N	\N	\N	\N	\N	\N
\N	f6ed7993-8237-4ef0-9cc4-0573e90e75d2	\N	\N	\N	\N	\N	\N	\N
\N	66151470-c472-418e-a958-e93c235b10e4	\N	\N	\N	\N	\N	\N	\N
\N	d46da801-96a5-42ca-90a0-0ed42a484f3b	\N	\N	\N	\N	\N	\N	\N
\N	f3152358-78b0-495c-8086-12b8a7a6e7c4	\N	\N	\N	\N	\N	\N	\N
\N	87416815-8bb9-42a5-98eb-5aefce3bfbcf	\N	\N	\N	\N	\N	\N	\N
\N	24b8f080-dac2-454c-aba3-16201b523039	\N	\N	\N	\N	\N	\N	\N
\N	e666ae2f-259c-4fff-8884-df1c6401bbf9	\N	\N	\N	\N	\N	\N	\N
\N	289a3f50-e20c-442b-b1af-a6dc0e973bd5	\N	\N	\N	\N	\N	\N	\N
\N	efa858af-f6b2-44c4-abf0-e469f1353d10	\N	\N	\N	\N	\N	\N	\N
\N	1ba431f3-259a-4751-9ae9-22d5a110ae53	\N	\N	\N	\N	\N	\N	\N
\N	3011dd24-c2db-46ef-b5d1-895e38d9b930	\N	\N	\N	\N	\N	\N	\N
\N	110adbb2-e44d-4c83-80e6-d404b4741ed4	\N	\N	\N	\N	\N	\N	\N
\N	9683b122-799f-4d4e-92b8-8f57283e964f	\N	\N	\N	\N	\N	\N	\N
\N	995b6a10-b9dc-4f43-bd81-b6249cd8b191	\N	\N	\N	\N	\N	\N	\N
\N	617031b7-af6b-4fa3-9644-dc5ade438caf	\N	\N	\N	\N	\N	\N	\N
\N	5b1045d7-6c9e-4446-ae09-6831ea31e1cc	\N	\N	\N	\N	\N	\N	\N
\N	0a4d3518-c6fa-4a84-bec3-453eafd845b7	\N	\N	\N	\N	\N	\N	\N
\N	c513be3f-2789-46b7-bc33-0feea0e7e628	\N	\N	\N	\N	\N	\N	\N
\N	5539833b-6142-452e-bea3-fc373b058c14	\N	\N	\N	\N	\N	\N	\N
\N	ef2b53fa-b6fb-4962-a523-53ff8c1e65fa	\N	\N	\N	\N	\N	\N	\N
\N	701fb3d8-8ea8-43b9-ad0a-27e0a053f41f	\N	\N	\N	\N	\N	\N	\N
\N	82ad2994-8a8a-4734-8924-089e49902749	\N	\N	\N	\N	\N	\N	\N
\N	3004c43c-f694-4d5d-bc56-d89e562d8810	\N	\N	\N	\N	\N	\N	\N
\N	2255af62-ea0f-441e-8cef-c95a842d0c8f	\N	\N	\N	\N	\N	\N	\N
\N	5f35338b-62e5-48be-9737-7ec419eb9fc9	\N	\N	\N	\N	\N	\N	\N
\N	beaabaf0-bfc2-411f-9a6d-e6135d699097	\N	\N	\N	\N	\N	\N	\N
\N	ee0feefe-84c4-4d99-b69c-06445074d7ff	\N	\N	\N	\N	\N	\N	\N
\N	1f9d14c8-64db-41c2-9867-9641e5d112b1	\N	\N	\N	\N	\N	\N	\N
\N	4ee1cee2-a251-4b2d-9205-e12ad4a8499a	\N	\N	\N	\N	\N	\N	\N
\N	8380299d-ae45-4b0b-bab1-3f2769dfdca8	\N	\N	\N	\N	\N	\N	\N
\N	f4897015-28c0-46b4-9b1c-0312bbe14f19	\N	\N	\N	\N	\N	\N	\N
\N	cf051540-fc52-47a6-9247-7cca3089b0d2	\N	\N	\N	\N	\N	\N	\N
\N	0f8aee5b-53cc-46b2-af21-4b7fea33f4a8	\N	\N	\N	\N	\N	\N	\N
\N	2db4aa27-37b4-454e-86d1-24dd3185a968	\N	\N	\N	\N	\N	\N	\N
\N	6fbf8d40-a83f-4977-bf0f-2fbdc397a975	\N	\N	\N	\N	\N	\N	\N
\N	7e531fe1-bf4a-4d2e-a697-b8ccaf587377	\N	\N	\N	\N	\N	\N	\N
\N	e6dd595d-9bc9-4ec0-a594-1e9c8d541133	\N	\N	\N	\N	\N	\N	\N
\N	f8f0c20b-e38b-47ee-8788-2c675649e67c	\N	\N	\N	\N	\N	\N	\N
\N	4e77e1c7-3c74-4ced-ba10-bad97ecd405d	\N	\N	\N	\N	\N	\N	\N
\N	3bbcfa02-d7d2-4733-9f3d-45ad29a8117a	\N	\N	\N	\N	\N	\N	\N
\N	cd65d599-6ac3-470c-9eb6-75f9aed99357	\N	\N	\N	\N	\N	\N	\N
\N	9f225cd4-4db1-4fb2-b976-ea4e9ae18656	\N	\N	\N	\N	\N	\N	\N
\N	f2af2366-3fec-449c-9571-fe170605a28e	\N	\N	\N	\N	\N	\N	\N
\N	ea7f0fea-6dd7-4907-beef-d60d62f7a0d9	\N	\N	\N	\N	\N	\N	\N
\N	79f9afe4-97a6-42a4-a906-f80f360ad656	\N	\N	\N	\N	\N	\N	\N
\N	828c145d-a069-48d4-857b-9ee667d38c68	\N	\N	\N	\N	\N	\N	\N
\N	ac22c96b-12db-4e4a-82c9-63e1c5af3de3	\N	\N	\N	\N	\N	\N	\N
\N	f68dd0f4-475b-4b2d-9cd1-8236b29ff7b4	\N	\N	\N	\N	\N	\N	\N
\N	8742eb33-87b7-4f31-8ed8-be8788d16368	\N	\N	\N	\N	\N	\N	\N
\N	048560cc-de2b-4693-969c-61d493365d18	\N	\N	\N	\N	\N	\N	\N
\N	bb4c6911-03b5-480e-819e-6a760460e9a1	\N	\N	\N	\N	\N	\N	\N
\N	893f8288-3bfe-4656-9c84-4fbb6f695849	\N	\N	\N	\N	\N	\N	\N
\N	2f7c5598-12bd-41ee-a1f4-625b8d93f2ef	\N	\N	\N	\N	\N	\N	\N
\N	90601c90-b68b-4ea2-8b12-e13ccc6eb0e5	\N	\N	\N	\N	\N	\N	\N
\N	673a6a9d-1cdd-4613-ac3b-1814c8831656	\N	\N	\N	\N	\N	\N	\N
\N	f9de8b0b-92ab-4726-9a25-387f0a8d2720	\N	\N	\N	\N	\N	\N	\N
\N	9611172c-b2e0-4bfa-8f3c-57d9f82bb480	\N	\N	\N	\N	\N	\N	\N
\N	22b91317-4740-4caa-bb89-5a45c9c311f3	\N	\N	\N	\N	\N	\N	\N
\N	645f03ae-c3bd-4ff3-94c3-31acc342036c	\N	\N	\N	\N	\N	\N	\N
\N	4f1937a8-4952-4ad7-8517-a3b777ef3ed7	\N	\N	\N	\N	\N	\N	\N
\N	9c1f759e-1c23-443e-b601-dd4b5a867d98	\N	\N	\N	\N	\N	\N	\N
\N	eb746f42-f39e-484c-8ad7-51b355b7f227	\N	\N	\N	\N	\N	\N	\N
\N	a6ba185b-3885-4be2-9bb5-dc61de428543	\N	\N	\N	\N	\N	\N	\N
\N	c5d79dda-0dfe-4acb-ba9b-b9850715b7f5	\N	\N	\N	\N	\N	\N	\N
\N	a44d06ae-fd12-4b30-b17e-24944c917470	\N	\N	\N	\N	\N	\N	\N
\N	f38cddca-d777-4d6b-b104-867d27969d2a	\N	\N	\N	\N	\N	\N	\N
\N	48de73ab-3a92-4c08-a1ae-4c7cf43e8341	\N	\N	\N	\N	\N	\N	\N
\N	a89ae057-da72-458a-8b54-c2c01c59633e	\N	\N	\N	\N	\N	\N	\N
\N	b824b5fd-76a7-4fd8-87a3-6d2942b62eb0	\N	\N	\N	\N	\N	\N	\N
\N	40a29a62-25aa-491f-8791-ec96017b4e12	\N	\N	\N	\N	\N	\N	\N
\N	79922945-f438-4446-bc33-6565320adebf	\N	\N	\N	\N	\N	\N	\N
\N	63035ee2-cc1c-4302-9d66-ebf6901744a4	\N	\N	\N	\N	\N	\N	\N
\N	c1a15047-56a4-43bf-aaf6-fd0e6477f98f	\N	\N	\N	\N	\N	\N	\N
\N	70366e28-2101-47c1-abc4-3711331158f2	\N	\N	\N	\N	\N	\N	\N
\N	4a253056-b197-44af-b8e6-13f826ad9a22	\N	\N	\N	\N	\N	\N	\N
\N	d3b46df8-f992-4cc2-824c-1efbbd369775	\N	\N	\N	\N	\N	\N	\N
\N	5eff5609-7edc-4d4f-98d3-a7a561862a93	\N	\N	\N	\N	\N	\N	\N
\N	fdae48ca-2993-46f9-b543-c623e2f23a28	\N	\N	\N	\N	\N	\N	\N
\N	8d1bb197-7f21-44c8-8b4f-1aa584dcc189	\N	\N	\N	\N	\N	\N	\N
\N	6a4f724e-ee9e-41c4-9418-275558f5b865	\N	\N	\N	\N	\N	\N	\N
\N	84d45869-0e52-4f3c-8468-7419f86c5727	\N	\N	\N	\N	\N	\N	\N
\N	9a4df270-972f-4ab6-9fb0-5f96e79db5da	\N	\N	\N	\N	\N	\N	\N
\N	0daedcc9-d2b3-4833-bfe4-a0eeaee838b2	\N	\N	\N	\N	\N	\N	\N
\N	44560ab4-adc2-443e-a599-1a440bfc5c48	\N	\N	\N	\N	\N	\N	\N
\N	640da60a-12ee-48e4-90d5-9d3609e18051	\N	\N	\N	\N	\N	\N	\N
\N	8db9f9d0-d195-407a-923d-a0de4a20bfed	\N	\N	\N	\N	\N	\N	\N
\N	85683df6-16a7-4ded-b5fd-74f04e3b8080	\N	\N	\N	\N	\N	\N	\N
\N	bdb6f30c-459c-48a3-ac6f-1a861a004953	\N	\N	\N	\N	\N	\N	\N
\N	ca5e06ab-e7d9-4963-8747-67003deb6b31	\N	\N	\N	\N	\N	\N	\N
\N	7e9ba303-9d53-4c40-90b9-4f68d86270f2	\N	\N	\N	\N	\N	\N	\N
\N	3f84afbc-9185-4a3f-b3c9-569c3e9da89b	\N	\N	\N	\N	\N	\N	\N
\N	0aa9ece4-f742-4c0a-8040-cdf4d8faf5b9	\N	\N	\N	\N	\N	\N	\N
\N	f597ed21-6f76-41b8-8c1d-57f763859fad	\N	\N	\N	\N	\N	\N	\N
\N	9c532e18-a50a-4815-bbcc-a2e5d9c2b65f	\N	\N	\N	\N	\N	\N	\N
\N	105d0e1a-d561-459b-8322-0e985510883b	\N	\N	\N	\N	\N	\N	\N
\N	130b1879-7c73-446f-95cb-dfa274fd8361	\N	\N	\N	\N	\N	\N	\N
\N	0de8081c-86c1-4318-96a2-61ff4a5eafd8	\N	\N	\N	\N	\N	\N	\N
\N	a12c7960-d301-433f-b967-55d86845070b	\N	\N	\N	\N	\N	\N	\N
\N	3bbe59c8-460c-4879-bad9-50a6607ac8f0	\N	\N	\N	\N	\N	\N	\N
\N	6486917f-01cd-4e4d-b606-af71d92a14fa	\N	\N	\N	\N	\N	\N	\N
\N	9f65562a-b18b-429c-892e-5740150f30ce	\N	\N	\N	\N	\N	\N	\N
\N	0e56849a-8a47-4e6a-a208-7af588a91310	\N	\N	\N	\N	\N	\N	\N
\N	11c01b5a-3ef7-4298-a9da-18739a99fa62	\N	\N	\N	\N	\N	\N	\N
\N	9bc40373-4a2a-46ff-847c-714cb460e549	\N	\N	\N	\N	\N	\N	\N
\N	0ebec10d-4478-49ab-93f9-154d33b27b48	\N	\N	\N	\N	\N	\N	\N
\N	bccab95d-41a0-417f-8c60-c4930d2ee64b	\N	\N	\N	\N	\N	\N	\N
\N	de089951-60b0-4a0f-96f0-808a6dbdee71	\N	\N	\N	\N	\N	\N	\N
\N	9945f686-7847-4d78-9b8c-154e2a2bb296	\N	\N	\N	\N	\N	\N	\N
\N	2b0ca2ad-7e28-4a9c-b0a3-63b4f4b5f427	\N	\N	\N	\N	\N	\N	\N
\N	c63831fc-1419-470b-8f44-bdf13b06618c	\N	\N	\N	\N	\N	\N	\N
\N	e0cb29a5-a7e7-4183-a647-59027c0c8c2e	\N	\N	\N	\N	\N	\N	\N
\N	21f3514c-8861-4b5f-ac3f-d4b88441adcc	\N	\N	\N	\N	\N	\N	\N
\N	95824968-09b5-45c3-a5ff-f6c8fad3cba5	\N	\N	\N	\N	\N	\N	\N
\N	76a4baa0-c312-47de-abd8-38d342f5648a	\N	\N	\N	\N	\N	\N	\N
\N	433ec679-855f-4e2e-8302-b485271cd68f	\N	\N	\N	\N	\N	\N	\N
\N	86ccc8a7-5a8e-468d-b03c-4ce0436bc4dd	\N	\N	\N	\N	\N	\N	\N
\N	7cf1f5ae-d764-4d10-904d-1d8052283126	\N	\N	\N	\N	\N	\N	\N
\N	1a948c76-f0c1-42ea-8a98-090bb3c0e952	\N	\N	\N	\N	\N	\N	\N
\N	30edbd28-6241-4876-ae87-818171fb29ea	\N	\N	\N	\N	\N	\N	\N
\N	0bfb3ac9-90de-4934-b39b-178edde5c7ef	\N	\N	\N	\N	\N	\N	\N
\N	5b79fd4a-7656-4ddd-8860-b292b48350e6	\N	\N	\N	\N	\N	\N	\N
\N	6ce04d42-1a73-46e1-b145-4f43f004cd70	\N	\N	\N	\N	\N	\N	\N
\N	73c5e039-5fd5-45ca-8b42-e46dfc33d06c	\N	\N	\N	\N	\N	\N	\N
\N	5d2a1df2-7371-435c-b241-b3c9539b6049	\N	\N	\N	\N	\N	\N	\N
\N	c60c6dbc-67c4-42e9-adaf-acc0c82822ac	\N	\N	\N	\N	\N	\N	\N
\N	0ce316b3-41f3-4a74-8bfc-e0ee3cfe4000	\N	\N	\N	\N	\N	\N	\N
\N	36ea01fe-9920-424a-a9bb-b5de23ec2c7d	\N	\N	\N	\N	\N	\N	\N
\N	1652f904-9088-4fa5-bd63-9ff1e6efcf97	\N	\N	\N	\N	\N	\N	\N
\N	bf95d0b0-a562-4c96-9252-5b2ed9bcfb64	\N	\N	\N	\N	\N	\N	\N
\N	7001f4bb-55d0-4a1f-bde5-e514920a429b	\N	\N	\N	\N	\N	\N	\N
\N	9edbbc8c-bc1b-42ba-8914-1d9e9db2347f	\N	\N	\N	\N	\N	\N	\N
\N	85429d43-9926-4439-8704-20e18bb5679b	\N	\N	\N	\N	\N	\N	\N
\N	dc0136e1-f792-4aac-a8ea-16e09675995c	\N	\N	\N	\N	\N	\N	\N
\N	ef8e7e2c-eeeb-439d-b7f9-ade465fc4f68	\N	\N	\N	\N	\N	\N	\N
\N	79300c61-6d47-405d-9a9a-d1e8f0204305	\N	\N	\N	\N	\N	\N	\N
\N	9e61e347-ce40-43c5-a332-f5683442b1fa	\N	\N	\N	\N	\N	\N	\N
\N	d3672c54-1ef2-471a-ba24-239a3990fc75	\N	\N	\N	\N	\N	\N	\N
\N	ef53ffdb-0f3a-492e-874c-fcd8fba11d06	\N	\N	\N	\N	\N	\N	\N
\N	01712afa-c526-4f73-94ae-02734ce15c96	\N	\N	\N	\N	\N	\N	\N
\N	9b63b2f1-f8e9-42f3-8d4f-a49a3f16e914	\N	\N	\N	\N	\N	\N	\N
\N	c23dcaad-e9fa-4c6b-8d86-4fd2f3c125e9	\N	\N	\N	\N	\N	\N	\N
\N	5e78e0bf-da34-4c8b-ab86-2a6b9f8d63a8	\N	\N	\N	\N	\N	\N	\N
\N	127e289a-cced-4934-91ee-0bd505946855	\N	\N	\N	\N	\N	\N	\N
\N	a4c357bb-03ad-445b-b073-d6c5a8a9ce33	\N	\N	\N	\N	\N	\N	\N
\N	96931619-4af6-4562-9d21-45a09a3a369f	\N	\N	\N	\N	\N	\N	\N
\N	35210960-6f4c-4dde-9ee3-063f923c3dc3	\N	\N	\N	\N	\N	\N	\N
\N	631514ab-cb74-4a79-a03d-ea3e718ee702	\N	\N	\N	\N	\N	\N	\N
\N	a5f66249-7b4d-4084-a7b2-76a4ce0f2483	\N	\N	\N	\N	\N	\N	\N
\N	9ac23e05-d27e-4732-83a1-dc07ce94c3e5	\N	\N	\N	\N	\N	\N	\N
\N	47b9440a-6769-4287-b4e7-a9a79fbf4fdc	\N	\N	\N	\N	\N	\N	\N
\N	c545077e-d983-473a-b621-d0213869b06d	\N	\N	\N	\N	\N	\N	\N
\N	40951858-8246-4cb1-b095-0d20303ca115	\N	\N	\N	\N	\N	\N	\N
\N	7eaed4ff-162a-430f-8a35-1acdd53bc884	\N	\N	\N	\N	\N	\N	\N
\N	8b6e660f-2253-4b81-9b42-a065a6964f56	\N	\N	\N	\N	\N	\N	\N
\N	51fde179-1543-41de-9206-eaa3c75f9b59	\N	\N	\N	\N	\N	\N	\N
\N	05915171-100e-4d10-89e4-c872711de1aa	\N	\N	\N	\N	\N	\N	\N
\N	c66b4475-75d3-4d34-b33a-87077ac6bdab	\N	\N	\N	\N	\N	\N	\N
\N	22e0168a-c2a8-4e0b-85ec-a8d88eafa46e	\N	\N	\N	\N	\N	\N	\N
\N	10b5d9e1-b62d-4c93-ba9c-d5a258b6f2c3	\N	\N	\N	\N	\N	\N	\N
\N	f98570e1-e406-4857-9e8d-90c97ea8b7eb	\N	\N	\N	\N	\N	\N	\N
\N	e6c49376-930b-4689-9111-51386ff65eb8	\N	\N	\N	\N	\N	\N	\N
\N	6e7329c4-fbf0-4c06-aed1-f57996b0dc02	\N	\N	\N	\N	\N	\N	\N
\N	ecb7bd93-4a76-4895-af27-8033ffb4b9ee	\N	\N	\N	\N	\N	\N	\N
\N	86b7a281-7358-4bd0-be35-d7b13d3a54d7	\N	\N	\N	\N	\N	\N	\N
\N	c0727846-37aa-424a-a8b6-776f29a6b11c	\N	\N	\N	\N	\N	\N	\N
\N	69b38b68-43bc-4d73-9de6-7252271f950c	\N	\N	\N	\N	\N	\N	\N
\N	b20c5473-4f4b-4af4-b0ac-f25f63c15091	\N	\N	\N	\N	\N	\N	\N
\N	80e08532-d009-40b6-b60b-01ad848f29e7	\N	\N	\N	\N	\N	\N	\N
\N	dd80f6f0-c10b-4172-a531-716f9dd1c230	\N	\N	\N	\N	\N	\N	\N
\N	98b7684c-bcff-4679-89a6-c6f0d23f0540	\N	\N	\N	\N	\N	\N	\N
\N	e70c5835-3e0c-4681-b682-089b156bdd3c	\N	\N	\N	\N	\N	\N	\N
\N	55dcf71d-31cb-43c0-b001-288d404c3890	\N	\N	\N	\N	\N	\N	\N
\N	58713621-70cd-4c5e-9341-28b32ba41fb9	\N	\N	\N	\N	\N	\N	\N
\N	1807e1c8-fe69-44f0-99f5-5543862721dd	\N	\N	\N	\N	\N	\N	\N
\N	3021c2ed-dea4-4b82-a0e4-147c790655fd	\N	\N	\N	\N	\N	\N	\N
\N	778fbe77-519d-43cf-8e5f-b7524f22be6d	\N	\N	\N	\N	\N	\N	\N
\N	a3760f39-a4f7-494b-98ef-ca6264671474	\N	\N	\N	\N	\N	\N	\N
\N	739c1d61-b1fb-4f93-8a6f-a20d3910c4a0	\N	\N	\N	\N	\N	\N	\N
\N	c82c39e8-1b65-4647-90af-d2e6fc0e80a4	\N	\N	\N	\N	\N	\N	\N
\N	628a887f-5405-49b5-a113-8da165007f80	\N	\N	\N	\N	\N	\N	\N
\N	62ecff54-d3ad-4590-9773-f7a975437ddf	\N	\N	\N	\N	\N	\N	\N
\N	63af20f3-0299-4b5b-8c39-e1343f9f944b	\N	\N	\N	\N	\N	\N	\N
\N	cedd3c7e-baf0-471f-9044-b43cca83af23	\N	\N	\N	\N	\N	\N	\N
\N	07045af3-ed80-4990-a660-6282fe0fe4fb	\N	\N	\N	\N	\N	\N	\N
\N	f5f06691-69b5-4979-aee5-1c940a3a17b3	\N	\N	\N	\N	\N	\N	\N
\N	33f44877-bc89-4386-aca3-ef3a4946d305	\N	\N	\N	\N	\N	\N	\N
\N	bdf997dd-df12-480a-ae52-8950beded503	\N	\N	\N	\N	\N	\N	\N
\N	2319137c-c5cc-4ea5-9de7-50713a7f88c4	\N	\N	\N	\N	\N	\N	\N
\N	d42ed59c-0c22-4b9b-bebf-118132eeb353	\N	\N	\N	\N	\N	\N	\N
\N	3da18c61-9632-4a05-9962-27590f23772d	\N	\N	\N	\N	\N	\N	\N
\N	8a758888-6213-4881-9b2b-690336684fa7	\N	\N	\N	\N	\N	\N	\N
\N	3f987ebb-99ce-497d-81e3-5dc76547cc98	\N	\N	\N	\N	\N	\N	\N
\N	0f76ce1d-7218-4ff1-848a-af873e4033b3	\N	\N	\N	\N	\N	\N	\N
\N	924a0f97-19fa-46d9-8720-b3203cbb4ad3	\N	\N	\N	\N	\N	\N	\N
\N	0f289146-ce3b-42a6-b59e-3f159bb3e6f7	\N	\N	\N	\N	\N	\N	\N
\N	b58ca63f-f2e7-411e-a5da-fe0857ba17d7	\N	\N	\N	\N	\N	\N	\N
\N	a0562a18-237a-401a-9e61-99b48c4122dd	\N	\N	\N	\N	\N	\N	\N
\N	d6af0d41-100d-4f6d-9bca-da31efbef9b9	\N	\N	\N	\N	\N	\N	\N
\N	9d445c33-454e-49dc-a493-0f5015eead12	\N	\N	\N	\N	\N	\N	\N
\N	2b332fc6-9146-4623-863f-255d6566214f	\N	\N	\N	\N	\N	\N	\N
\N	7df394a5-4dff-468b-b97e-0559c07fa1b9	\N	\N	\N	\N	\N	\N	\N
\N	a0304a67-0fff-496c-9419-d6696ba39cc1	\N	\N	\N	\N	\N	\N	\N
\N	870c2ff3-ea24-4139-b31b-c643aa094c67	\N	\N	\N	\N	\N	\N	\N
\N	f6806a22-5e75-442a-8474-1f1bf3b49bb0	\N	\N	\N	\N	\N	\N	\N
\N	43c5b7d9-a1c7-4361-a0cf-0aa73a9333a7	\N	\N	\N	\N	\N	\N	\N
\N	55fdca5e-d193-44a3-ada5-2ab4d65395d6	\N	\N	\N	\N	\N	\N	\N
\N	0357e12e-1e20-4de1-89f8-17dfdd55fd31	\N	\N	\N	\N	\N	\N	\N
\N	c4ae769f-b5a3-48a9-885a-c99c99c19e37	\N	\N	\N	\N	\N	\N	\N
\N	3158d744-02ae-45d3-a4c1-3b8a5c22de3e	\N	\N	\N	\N	\N	\N	\N
\N	3dac7ef7-c456-42a2-8fc4-519e13b07ee0	\N	\N	\N	\N	\N	\N	\N
\N	040fde0b-489a-4cc8-bfba-6f69ba7f4f11	\N	\N	\N	\N	\N	\N	\N
\N	e657559e-c7af-4fa3-8d0a-aba39f0ba879	\N	\N	\N	\N	\N	\N	\N
\N	bf015865-7bd0-4282-bc70-61735421f9f1	\N	\N	\N	\N	\N	\N	\N
\N	3e935853-f1c6-47a7-9e22-2a457109ee60	\N	\N	\N	\N	\N	\N	\N
\N	70511c74-d0ea-42c8-8bbf-f8446f544022	\N	\N	\N	\N	\N	\N	\N
\N	7f76cd2d-725a-479d-999f-6581b07371ac	\N	\N	\N	\N	\N	\N	\N
\N	90c56da0-ae13-4f05-aa67-be54c7bad83a	\N	\N	\N	\N	\N	\N	\N
\N	d43aa0c1-4c5f-4c36-bf52-1df23a753b59	\N	\N	\N	\N	\N	\N	\N
\N	65dac126-89fc-463c-ba18-63d827a920c5	\N	\N	\N	\N	\N	\N	\N
\N	e8aa370e-19da-4d55-bb48-c53fff30c7b2	\N	\N	\N	\N	\N	\N	\N
\N	907454e2-0671-4ddf-9725-3509a9c3a454	\N	\N	\N	\N	\N	\N	\N
\N	1633cc84-63f4-4adf-986b-7da47de84bad	\N	\N	\N	\N	\N	\N	\N
\N	a1e46639-3086-442e-a8ea-efcc9193e674	\N	\N	\N	\N	\N	\N	\N
\N	6ef94e51-16d7-4cec-9359-a94d499e8337	\N	\N	\N	9e6cee53-8569-420a-9e75-d704e5f3517c	3d527afd-cb44-4f63-ae6a-cd9ccee96f11	\N	\N
\N	c087e9be-29f7-437f-b0da-bddb0b2ab183	\N	\N	\N	609ddd28-e6f3-41a2-a670-e0c2776bcca7	efd3ec50-5afd-4a3f-ade0-387c995fa513	\N	\N
\.


--
-- Data for Name: collection2item; Type: TABLE DATA; Schema: public; Owner: funasauser
--

COPY public.collection2item (collection_id, item_id) FROM stdin;
d851294f-191c-46a0-abf4-d338042d5971	1f0c95ab-3775-4094-b293-183d3b5074b2
0607dd1b-5468-48ef-8905-8d07d253d1f7	b37744b2-292c-4937-a401-9243b80980b3
3bf97251-0d2c-497a-b1c0-2fb8f089d5d9	25cb38d4-142c-4282-a4cc-b7be4e8f363b
7db66edb-3f9f-4c24-8fa2-0a4b11efb0b8	28f1a24a-b6ea-4b76-bba7-6779f81b14fe
c087e9be-29f7-437f-b0da-bddb0b2ab183	b1c7cc22-a459-4f55-99cc-98fc7e9829cd
c087e9be-29f7-437f-b0da-bddb0b2ab183	510ef6ac-d964-4857-81e9-85a00e00dc51
f2c7e15a-2db1-4099-9d26-78ba2c16b8da	09d7f4dc-8fce-43c0-b778-0df584c2739f
6ef94e51-16d7-4cec-9359-a94d499e8337	d450501d-bb9e-4ec6-9691-e27f33bba466
6ef94e51-16d7-4cec-9359-a94d499e8337	b7cc4d08-a40f-4400-bca5-3039f8c965b3
6ef94e51-16d7-4cec-9359-a94d499e8337	24fb983c-62fc-41d7-9a45-45bf55a5359c
cd75101b-abb6-46ef-ac88-3af552f33478	ed4b6780-5f7d-429f-beab-eb44e6170bc9
c087e9be-29f7-437f-b0da-bddb0b2ab183	b683a946-16af-4acd-a050-17decd4bd085
f2c7e15a-2db1-4099-9d26-78ba2c16b8da	1446271c-d93d-42dc-a7ba-a6ca384b4448
b55202c0-1e3b-4eba-909d-54f7fad48b9c	3bc2d4e3-6c4f-4e12-98c7-89b38012246f
b55202c0-1e3b-4eba-909d-54f7fad48b9c	416198eb-e102-4842-9bcc-a60fdcb450d7
c087e9be-29f7-437f-b0da-bddb0b2ab183	f332b151-98c1-4e28-b87e-bed0d9bf17e8
f2c7e15a-2db1-4099-9d26-78ba2c16b8da	e85ea3c1-9d09-4c0e-aaa8-33aca608cbb5
cd75101b-abb6-46ef-ac88-3af552f33478	1386b2cc-40f2-4213-a6d2-8d3ab04ba6bc
b55202c0-1e3b-4eba-909d-54f7fad48b9c	87bf956f-41be-46d9-a741-f304c8165e94
6ef94e51-16d7-4cec-9359-a94d499e8337	d2f5671b-6c52-4952-ba85-c3a87bf72a97
c087e9be-29f7-437f-b0da-bddb0b2ab183	380e731b-2df3-4f9e-84d0-16ffb0010e66
\.


--
-- Data for Name: community; Type: TABLE DATA; Schema: public; Owner: funasauser
--

COPY public.community (community_id, uuid, admin, logo_bitstream_id) FROM stdin;
\N	0c873029-343e-4740-bd26-c976c9b2c6c2	\N	\N
\N	1f757c54-5850-4cbe-ae02-284cfaccc1e7	\N	\N
\N	e8be30cd-3daa-4118-8548-8731d7495020	\N	\N
\N	b09f6eb0-f79f-489a-a7e8-bb87486bc1b2	\N	\N
\N	e13aa597-d0ce-44df-a774-e65c5b8ce61c	\N	\N
\N	62cb0c79-b578-470b-9e81-6a712fea7281	\N	\N
\N	050033bb-42bb-4d2e-be49-3bb13979f6b3	\N	\N
\N	bf24224f-e566-4c37-a5f1-27a1867114e6	\N	\N
\N	ca5ff7d4-3470-4ef2-90ca-dc563214be58	\N	\N
\N	7a290d59-1bed-4a4f-a6a1-02e191774a8f	\N	\N
\N	6c5dd78a-94ba-4ba9-ba37-401a80442dd5	\N	\N
\N	435bcf56-d368-4f2f-8e7f-4bafd3367063	\N	\N
\N	f0cb7fe8-e5c5-4d33-9530-b38f96535074	\N	\N
\N	342ea849-01c8-41cd-b812-44638b5c22ef	\N	\N
\N	e88afa75-f030-4a94-8c91-72257614e295	\N	\N
\N	7709d357-75c7-4039-bfcf-f2297e7493e9	\N	\N
\N	e43ea389-e3e6-410b-bbc3-75bce3a6474f	\N	\N
\N	08285b26-0b55-48c0-aae2-bd4c60dece4b	\N	\N
\N	043d9a3f-684c-4fc2-a642-4df251ff0ce6	\N	\N
\N	54def7e9-b01c-4405-831b-f55d391bc8db	\N	\N
\N	0122bff8-45c5-4403-9af8-4d92e63bf462	\N	\N
\N	c338e24b-54ce-439e-80fb-6aea64047d8c	\N	\N
\N	58411222-09a0-4a4c-a0aa-a16fed8c8057	\N	\N
\N	131515f5-0c56-4276-94dd-054d41a4f959	\N	\N
\N	265b2c85-db13-4fe1-ab54-4134f76d252b	\N	\N
\N	777e1210-3ec0-459a-aca6-29b715063e73	\N	\N
\N	6599bbd5-7809-439a-85d2-dd0c607838cc	\N	\N
\N	4de09263-c707-4a67-b45a-f9de6a6edac0	\N	\N
\N	7590066c-de6e-4a65-9565-25e1bd3b87f6	\N	\N
\N	01bf637b-7e76-4610-88b6-b85270d50e0c	\N	\N
\N	927e147b-5d98-4bc8-be35-941cdaf90018	\N	\N
\N	1f1e123d-71ba-45d8-a436-9866334f6679	\N	\N
\N	4a04d20c-9629-456f-a426-cc82d587d3cb	\N	\N
\N	fa19502e-672d-4ce0-b465-111ab855321a	\N	\N
\N	68c53a2c-0fd6-42a1-9c67-3387ebe11972	\N	\N
\N	5a2d5225-d585-4549-8758-a2c186dcb42a	\N	\N
\N	e062cd7e-5965-432f-89e4-7d30ea154e87	\N	\N
\N	f46e680e-8e04-426a-b055-c66c18163caa	\N	\N
\N	12f102df-9e17-4bbd-8a46-6879014fd76b	\N	\N
\N	6ad2c279-e29e-402c-a09b-cadf0a19207f	\N	\N
\N	2c944a82-e4a1-4d58-b31e-3c96236eb34d	\N	\N
\N	ae79c603-8cb2-40f8-9d07-c69363f0039a	\N	\N
\N	0a540eac-23c0-4dca-9943-d006688c005b	\N	\N
\N	1b9b305d-dc05-42d2-b4b1-47e95b8cc167	\N	\N
\N	f43b5db9-d9fe-4f67-b1df-48dd4cf237af	\N	\N
\N	f090f032-d9d9-4ec2-9490-16e3db96212b	\N	\N
\N	ef9c52da-c800-4fb6-8ecb-6851e26a2794	\N	\N
\N	1b279197-328f-4ff1-a8a3-60e842b4d099	\N	\N
\N	8d8d2fbb-cae3-4073-a46d-d4e01d204cad	\N	\N
\N	a14ae54e-0797-4324-8b82-9846be3aa9fd	\N	\N
\N	f1e4428f-78dc-4c65-93b0-a5fd4a291f23	\N	\N
\N	7482f96f-4d1c-42ef-935b-afa2a5bc1045	\N	\N
\N	86b6a785-abca-429f-991c-d473d49502ee	\N	\N
\N	3d6690d8-eadd-46a6-8fea-73dbcdd3ec66	\N	\N
\N	7e294bf6-2eec-49aa-9d8f-a6d4a2cc498b	\N	\N
\N	508fd417-903e-485c-8a79-1d47fecf89ec	\N	\N
\N	70a9c7ec-c890-4cb2-9978-47493f08fa8f	\N	\N
\N	9d0dccbc-1024-4802-993c-933cb6cdc260	\N	\N
\N	786d3d1a-1946-4dd0-817b-dab8b0dfa161	\N	\N
\N	12188074-fdf3-41c4-96c8-fdd2d1cee710	\N	\N
\N	bc548182-4db3-4087-a94d-d059f9f386e4	\N	\N
\N	803bc41a-3cf3-4f5a-b888-26b61a5ba929	\N	\N
\N	214d281b-6762-46e2-a6a1-98d270cbf4bb	\N	\N
\N	9f71cf2b-168c-4efe-844e-afe0e670ccbf	\N	\N
\N	305fba50-26ce-48e4-af27-4ea801b1ef30	\N	\N
\N	823a9569-d81b-4871-9b0d-1a8f04de234a	\N	\N
\N	ea38e67d-c827-487c-b429-13be16d4a6c5	\N	b1f9e084-1af0-4671-a7a6-29f55d92e4e5
\N	683bfc83-3cc1-4f22-83d3-c9ee4ea2c82b	\N	d6834eae-2c8a-4ff3-85b8-022bdee1d3dd
\N	6805171d-b16f-46e4-b7a1-2d91aafb9037	\N	a3226bcc-9f1c-4216-9d44-8f1dcb06288b
\N	f7af0744-1ec4-437f-88db-205b9666f652	\N	c85acf18-4bc6-49d8-aeb1-9ac4b2666956
\N	a6dbaa98-ed1f-40f8-bdf9-8822d64a800d	\N	75885d51-2fb0-4968-a3de-fe0c53eceb6b
\N	04ae4009-f11b-486e-929a-2512280f4227	\N	fa813a90-86ff-4f16-8639-424d9db60bf7
\N	6b2e2ac5-98ee-4257-a54a-f24c7cb8fb01	\N	67d54727-eeb4-4daa-8c41-40fd40134cad
\N	5e8bca7b-a019-4138-9939-7951646ad23c	\N	6bb85bb3-b2a7-4cfc-8fe5-eda2707287b4
\N	9b4b9979-0172-4961-9d58-10f57df85092	\N	5727043c-4c89-4e29-a594-6b8fe56ad3f7
\.


--
-- Data for Name: community2collection; Type: TABLE DATA; Schema: public; Owner: funasauser
--

COPY public.community2collection (collection_id, community_id) FROM stdin;
afd22d8d-4201-4482-888c-c06b85307651	1f757c54-5850-4cbe-ae02-284cfaccc1e7
4b0ebee1-3f02-43c5-bdac-923b17a459bb	1f757c54-5850-4cbe-ae02-284cfaccc1e7
240b86fb-057a-4098-b4a9-16362bd4d88e	1f757c54-5850-4cbe-ae02-284cfaccc1e7
f02c8749-274c-4492-ba7b-cc33c3b8db61	1f757c54-5850-4cbe-ae02-284cfaccc1e7
28df2a70-de20-4c58-a5c8-e3c24e688cee	1f757c54-5850-4cbe-ae02-284cfaccc1e7
19737605-9de5-494c-b19e-7118aa37b963	e8be30cd-3daa-4118-8548-8731d7495020
f5a61cfd-721a-4eba-bf4f-4fa931159f12	e8be30cd-3daa-4118-8548-8731d7495020
bf82b5db-01cb-402c-81a9-8249ff7395a6	e8be30cd-3daa-4118-8548-8731d7495020
2aa863cf-c22a-4dae-8aed-2f08b702420a	e8be30cd-3daa-4118-8548-8731d7495020
d72bd580-c8d7-46af-ad71-ee7a50bbd582	e8be30cd-3daa-4118-8548-8731d7495020
0607dd1b-5468-48ef-8905-8d07d253d1f7	b09f6eb0-f79f-489a-a7e8-bb87486bc1b2
d52095c9-d548-4f66-9dad-d84f4928ded7	b09f6eb0-f79f-489a-a7e8-bb87486bc1b2
f805ab68-cf57-431a-affc-8ce7f9778fe7	b09f6eb0-f79f-489a-a7e8-bb87486bc1b2
5f662caf-e96c-432e-8137-a17afe17283b	b09f6eb0-f79f-489a-a7e8-bb87486bc1b2
fc9b46f8-dd31-4298-9f47-73af77f1c56d	b09f6eb0-f79f-489a-a7e8-bb87486bc1b2
c32fae4a-fdfa-4498-a50a-bc9285fbb3a0	62cb0c79-b578-470b-9e81-6a712fea7281
8f327435-da4d-4bbe-99f2-df602eddf8fb	62cb0c79-b578-470b-9e81-6a712fea7281
b73c9ead-ff11-4e99-bcd0-86186ccd10aa	62cb0c79-b578-470b-9e81-6a712fea7281
fd415204-97cc-4568-938b-467f663aab73	62cb0c79-b578-470b-9e81-6a712fea7281
19cefe3e-817f-4584-8647-e1e0345ca422	62cb0c79-b578-470b-9e81-6a712fea7281
3bf97251-0d2c-497a-b1c0-2fb8f089d5d9	bf24224f-e566-4c37-a5f1-27a1867114e6
24a1c3ff-d7a4-4e39-92ca-bbbd1ef02a13	bf24224f-e566-4c37-a5f1-27a1867114e6
60f00aaf-c385-4dcb-b9a4-ed59d23e3feb	bf24224f-e566-4c37-a5f1-27a1867114e6
2a26db78-5987-40be-b908-a20da0086e8b	bf24224f-e566-4c37-a5f1-27a1867114e6
4e7863f5-b198-47e4-8eb1-688af9155b78	bf24224f-e566-4c37-a5f1-27a1867114e6
b85655ce-7a32-438b-9211-a8b12ec6dcfd	ca5ff7d4-3470-4ef2-90ca-dc563214be58
33d85721-7ff3-4926-ae80-084bb178dd97	ca5ff7d4-3470-4ef2-90ca-dc563214be58
9a582dff-81aa-4021-9f30-f75871aeb9eb	ca5ff7d4-3470-4ef2-90ca-dc563214be58
681bb445-6fc8-49c1-9915-1d418f2ac4d1	ca5ff7d4-3470-4ef2-90ca-dc563214be58
96f9e582-cb6e-441e-a361-97f5e69b8ff2	ca5ff7d4-3470-4ef2-90ca-dc563214be58
88d41f3a-a149-4dc5-81a2-84380835533a	7a290d59-1bed-4a4f-a6a1-02e191774a8f
41b5c503-8ca0-435f-8103-3e692593b755	7a290d59-1bed-4a4f-a6a1-02e191774a8f
728d1b2f-f32f-4ba9-80ff-922deca5458b	7a290d59-1bed-4a4f-a6a1-02e191774a8f
a2561e5d-7cbf-464d-b6e6-6178bddd9bae	7a290d59-1bed-4a4f-a6a1-02e191774a8f
25c745b0-5b75-44bd-91fb-f468f52c377b	7a290d59-1bed-4a4f-a6a1-02e191774a8f
357da42e-ffb4-43f7-bb59-3b66f6d09b1f	6c5dd78a-94ba-4ba9-ba37-401a80442dd5
8a52ac60-0cb5-4d6f-8b4c-a9cd65b62d0a	6c5dd78a-94ba-4ba9-ba37-401a80442dd5
d851294f-191c-46a0-abf4-d338042d5971	6c5dd78a-94ba-4ba9-ba37-401a80442dd5
fbe5350a-c8ba-4a39-98e2-bd742a6be202	6c5dd78a-94ba-4ba9-ba37-401a80442dd5
3afa7efe-2891-4c47-b396-c83d56ff9d90	6c5dd78a-94ba-4ba9-ba37-401a80442dd5
c087e9be-29f7-437f-b0da-bddb0b2ab183	f0cb7fe8-e5c5-4d33-9530-b38f96535074
f2c7e15a-2db1-4099-9d26-78ba2c16b8da	f0cb7fe8-e5c5-4d33-9530-b38f96535074
cd75101b-abb6-46ef-ac88-3af552f33478	f0cb7fe8-e5c5-4d33-9530-b38f96535074
b55202c0-1e3b-4eba-909d-54f7fad48b9c	f0cb7fe8-e5c5-4d33-9530-b38f96535074
6ef94e51-16d7-4cec-9359-a94d499e8337	f0cb7fe8-e5c5-4d33-9530-b38f96535074
411dd125-33df-451a-87c9-7dca418b665e	342ea849-01c8-41cd-b812-44638b5c22ef
7db66edb-3f9f-4c24-8fa2-0a4b11efb0b8	342ea849-01c8-41cd-b812-44638b5c22ef
b2020a23-0063-4efe-b770-9c9a5a099b42	342ea849-01c8-41cd-b812-44638b5c22ef
6a8d7523-aace-4c61-9a7f-9133ae72d7b0	342ea849-01c8-41cd-b812-44638b5c22ef
3449a99e-7799-4ba0-bd51-63ae8ee23093	342ea849-01c8-41cd-b812-44638b5c22ef
1e0e772a-32a3-4fef-99c9-2aeab683bae2	e88afa75-f030-4a94-8c91-72257614e295
909a8161-d474-4b0e-afdc-5a5ae63c3a6c	e88afa75-f030-4a94-8c91-72257614e295
f6ed7993-8237-4ef0-9cc4-0573e90e75d2	e88afa75-f030-4a94-8c91-72257614e295
66151470-c472-418e-a958-e93c235b10e4	e88afa75-f030-4a94-8c91-72257614e295
d46da801-96a5-42ca-90a0-0ed42a484f3b	e88afa75-f030-4a94-8c91-72257614e295
f3152358-78b0-495c-8086-12b8a7a6e7c4	e43ea389-e3e6-410b-bbc3-75bce3a6474f
87416815-8bb9-42a5-98eb-5aefce3bfbcf	e43ea389-e3e6-410b-bbc3-75bce3a6474f
24b8f080-dac2-454c-aba3-16201b523039	e43ea389-e3e6-410b-bbc3-75bce3a6474f
e666ae2f-259c-4fff-8884-df1c6401bbf9	e43ea389-e3e6-410b-bbc3-75bce3a6474f
289a3f50-e20c-442b-b1af-a6dc0e973bd5	e43ea389-e3e6-410b-bbc3-75bce3a6474f
efa858af-f6b2-44c4-abf0-e469f1353d10	08285b26-0b55-48c0-aae2-bd4c60dece4b
1ba431f3-259a-4751-9ae9-22d5a110ae53	08285b26-0b55-48c0-aae2-bd4c60dece4b
3011dd24-c2db-46ef-b5d1-895e38d9b930	08285b26-0b55-48c0-aae2-bd4c60dece4b
110adbb2-e44d-4c83-80e6-d404b4741ed4	08285b26-0b55-48c0-aae2-bd4c60dece4b
9683b122-799f-4d4e-92b8-8f57283e964f	08285b26-0b55-48c0-aae2-bd4c60dece4b
995b6a10-b9dc-4f43-bd81-b6249cd8b191	043d9a3f-684c-4fc2-a642-4df251ff0ce6
617031b7-af6b-4fa3-9644-dc5ade438caf	043d9a3f-684c-4fc2-a642-4df251ff0ce6
5b1045d7-6c9e-4446-ae09-6831ea31e1cc	043d9a3f-684c-4fc2-a642-4df251ff0ce6
0a4d3518-c6fa-4a84-bec3-453eafd845b7	043d9a3f-684c-4fc2-a642-4df251ff0ce6
c513be3f-2789-46b7-bc33-0feea0e7e628	043d9a3f-684c-4fc2-a642-4df251ff0ce6
5539833b-6142-452e-bea3-fc373b058c14	54def7e9-b01c-4405-831b-f55d391bc8db
ef2b53fa-b6fb-4962-a523-53ff8c1e65fa	54def7e9-b01c-4405-831b-f55d391bc8db
701fb3d8-8ea8-43b9-ad0a-27e0a053f41f	54def7e9-b01c-4405-831b-f55d391bc8db
82ad2994-8a8a-4734-8924-089e49902749	54def7e9-b01c-4405-831b-f55d391bc8db
3004c43c-f694-4d5d-bc56-d89e562d8810	54def7e9-b01c-4405-831b-f55d391bc8db
2255af62-ea0f-441e-8cef-c95a842d0c8f	0122bff8-45c5-4403-9af8-4d92e63bf462
5f35338b-62e5-48be-9737-7ec419eb9fc9	0122bff8-45c5-4403-9af8-4d92e63bf462
beaabaf0-bfc2-411f-9a6d-e6135d699097	0122bff8-45c5-4403-9af8-4d92e63bf462
ee0feefe-84c4-4d99-b69c-06445074d7ff	0122bff8-45c5-4403-9af8-4d92e63bf462
1f9d14c8-64db-41c2-9867-9641e5d112b1	0122bff8-45c5-4403-9af8-4d92e63bf462
4ee1cee2-a251-4b2d-9205-e12ad4a8499a	58411222-09a0-4a4c-a0aa-a16fed8c8057
8380299d-ae45-4b0b-bab1-3f2769dfdca8	58411222-09a0-4a4c-a0aa-a16fed8c8057
f4897015-28c0-46b4-9b1c-0312bbe14f19	58411222-09a0-4a4c-a0aa-a16fed8c8057
cf051540-fc52-47a6-9247-7cca3089b0d2	58411222-09a0-4a4c-a0aa-a16fed8c8057
0f8aee5b-53cc-46b2-af21-4b7fea33f4a8	58411222-09a0-4a4c-a0aa-a16fed8c8057
2db4aa27-37b4-454e-86d1-24dd3185a968	131515f5-0c56-4276-94dd-054d41a4f959
6fbf8d40-a83f-4977-bf0f-2fbdc397a975	131515f5-0c56-4276-94dd-054d41a4f959
7e531fe1-bf4a-4d2e-a697-b8ccaf587377	131515f5-0c56-4276-94dd-054d41a4f959
e6dd595d-9bc9-4ec0-a594-1e9c8d541133	131515f5-0c56-4276-94dd-054d41a4f959
f8f0c20b-e38b-47ee-8788-2c675649e67c	131515f5-0c56-4276-94dd-054d41a4f959
4e77e1c7-3c74-4ced-ba10-bad97ecd405d	265b2c85-db13-4fe1-ab54-4134f76d252b
3bbcfa02-d7d2-4733-9f3d-45ad29a8117a	265b2c85-db13-4fe1-ab54-4134f76d252b
cd65d599-6ac3-470c-9eb6-75f9aed99357	265b2c85-db13-4fe1-ab54-4134f76d252b
9f225cd4-4db1-4fb2-b976-ea4e9ae18656	265b2c85-db13-4fe1-ab54-4134f76d252b
f2af2366-3fec-449c-9571-fe170605a28e	265b2c85-db13-4fe1-ab54-4134f76d252b
ea7f0fea-6dd7-4907-beef-d60d62f7a0d9	777e1210-3ec0-459a-aca6-29b715063e73
79f9afe4-97a6-42a4-a906-f80f360ad656	777e1210-3ec0-459a-aca6-29b715063e73
828c145d-a069-48d4-857b-9ee667d38c68	777e1210-3ec0-459a-aca6-29b715063e73
ac22c96b-12db-4e4a-82c9-63e1c5af3de3	777e1210-3ec0-459a-aca6-29b715063e73
f68dd0f4-475b-4b2d-9cd1-8236b29ff7b4	777e1210-3ec0-459a-aca6-29b715063e73
8742eb33-87b7-4f31-8ed8-be8788d16368	6599bbd5-7809-439a-85d2-dd0c607838cc
048560cc-de2b-4693-969c-61d493365d18	6599bbd5-7809-439a-85d2-dd0c607838cc
bb4c6911-03b5-480e-819e-6a760460e9a1	6599bbd5-7809-439a-85d2-dd0c607838cc
893f8288-3bfe-4656-9c84-4fbb6f695849	6599bbd5-7809-439a-85d2-dd0c607838cc
2f7c5598-12bd-41ee-a1f4-625b8d93f2ef	6599bbd5-7809-439a-85d2-dd0c607838cc
90601c90-b68b-4ea2-8b12-e13ccc6eb0e5	7590066c-de6e-4a65-9565-25e1bd3b87f6
673a6a9d-1cdd-4613-ac3b-1814c8831656	7590066c-de6e-4a65-9565-25e1bd3b87f6
f9de8b0b-92ab-4726-9a25-387f0a8d2720	7590066c-de6e-4a65-9565-25e1bd3b87f6
9611172c-b2e0-4bfa-8f3c-57d9f82bb480	7590066c-de6e-4a65-9565-25e1bd3b87f6
22b91317-4740-4caa-bb89-5a45c9c311f3	7590066c-de6e-4a65-9565-25e1bd3b87f6
645f03ae-c3bd-4ff3-94c3-31acc342036c	01bf637b-7e76-4610-88b6-b85270d50e0c
4f1937a8-4952-4ad7-8517-a3b777ef3ed7	01bf637b-7e76-4610-88b6-b85270d50e0c
9c1f759e-1c23-443e-b601-dd4b5a867d98	01bf637b-7e76-4610-88b6-b85270d50e0c
eb746f42-f39e-484c-8ad7-51b355b7f227	01bf637b-7e76-4610-88b6-b85270d50e0c
a6ba185b-3885-4be2-9bb5-dc61de428543	01bf637b-7e76-4610-88b6-b85270d50e0c
c5d79dda-0dfe-4acb-ba9b-b9850715b7f5	927e147b-5d98-4bc8-be35-941cdaf90018
a44d06ae-fd12-4b30-b17e-24944c917470	927e147b-5d98-4bc8-be35-941cdaf90018
f38cddca-d777-4d6b-b104-867d27969d2a	927e147b-5d98-4bc8-be35-941cdaf90018
48de73ab-3a92-4c08-a1ae-4c7cf43e8341	927e147b-5d98-4bc8-be35-941cdaf90018
a89ae057-da72-458a-8b54-c2c01c59633e	927e147b-5d98-4bc8-be35-941cdaf90018
b824b5fd-76a7-4fd8-87a3-6d2942b62eb0	4a04d20c-9629-456f-a426-cc82d587d3cb
40a29a62-25aa-491f-8791-ec96017b4e12	4a04d20c-9629-456f-a426-cc82d587d3cb
79922945-f438-4446-bc33-6565320adebf	4a04d20c-9629-456f-a426-cc82d587d3cb
63035ee2-cc1c-4302-9d66-ebf6901744a4	4a04d20c-9629-456f-a426-cc82d587d3cb
c1a15047-56a4-43bf-aaf6-fd0e6477f98f	4a04d20c-9629-456f-a426-cc82d587d3cb
70366e28-2101-47c1-abc4-3711331158f2	fa19502e-672d-4ce0-b465-111ab855321a
4a253056-b197-44af-b8e6-13f826ad9a22	fa19502e-672d-4ce0-b465-111ab855321a
d3b46df8-f992-4cc2-824c-1efbbd369775	fa19502e-672d-4ce0-b465-111ab855321a
5eff5609-7edc-4d4f-98d3-a7a561862a93	fa19502e-672d-4ce0-b465-111ab855321a
fdae48ca-2993-46f9-b543-c623e2f23a28	fa19502e-672d-4ce0-b465-111ab855321a
8d1bb197-7f21-44c8-8b4f-1aa584dcc189	5a2d5225-d585-4549-8758-a2c186dcb42a
6a4f724e-ee9e-41c4-9418-275558f5b865	5a2d5225-d585-4549-8758-a2c186dcb42a
84d45869-0e52-4f3c-8468-7419f86c5727	5a2d5225-d585-4549-8758-a2c186dcb42a
9a4df270-972f-4ab6-9fb0-5f96e79db5da	5a2d5225-d585-4549-8758-a2c186dcb42a
0daedcc9-d2b3-4833-bfe4-a0eeaee838b2	5a2d5225-d585-4549-8758-a2c186dcb42a
44560ab4-adc2-443e-a599-1a440bfc5c48	e062cd7e-5965-432f-89e4-7d30ea154e87
640da60a-12ee-48e4-90d5-9d3609e18051	e062cd7e-5965-432f-89e4-7d30ea154e87
8db9f9d0-d195-407a-923d-a0de4a20bfed	e062cd7e-5965-432f-89e4-7d30ea154e87
85683df6-16a7-4ded-b5fd-74f04e3b8080	e062cd7e-5965-432f-89e4-7d30ea154e87
bdb6f30c-459c-48a3-ac6f-1a861a004953	e062cd7e-5965-432f-89e4-7d30ea154e87
ca5e06ab-e7d9-4963-8747-67003deb6b31	12f102df-9e17-4bbd-8a46-6879014fd76b
7e9ba303-9d53-4c40-90b9-4f68d86270f2	12f102df-9e17-4bbd-8a46-6879014fd76b
3f84afbc-9185-4a3f-b3c9-569c3e9da89b	12f102df-9e17-4bbd-8a46-6879014fd76b
0aa9ece4-f742-4c0a-8040-cdf4d8faf5b9	12f102df-9e17-4bbd-8a46-6879014fd76b
f597ed21-6f76-41b8-8c1d-57f763859fad	12f102df-9e17-4bbd-8a46-6879014fd76b
9c532e18-a50a-4815-bbcc-a2e5d9c2b65f	6ad2c279-e29e-402c-a09b-cadf0a19207f
105d0e1a-d561-459b-8322-0e985510883b	6ad2c279-e29e-402c-a09b-cadf0a19207f
130b1879-7c73-446f-95cb-dfa274fd8361	6ad2c279-e29e-402c-a09b-cadf0a19207f
0de8081c-86c1-4318-96a2-61ff4a5eafd8	6ad2c279-e29e-402c-a09b-cadf0a19207f
a12c7960-d301-433f-b967-55d86845070b	6ad2c279-e29e-402c-a09b-cadf0a19207f
3bbe59c8-460c-4879-bad9-50a6607ac8f0	2c944a82-e4a1-4d58-b31e-3c96236eb34d
6486917f-01cd-4e4d-b606-af71d92a14fa	2c944a82-e4a1-4d58-b31e-3c96236eb34d
9f65562a-b18b-429c-892e-5740150f30ce	2c944a82-e4a1-4d58-b31e-3c96236eb34d
0e56849a-8a47-4e6a-a208-7af588a91310	2c944a82-e4a1-4d58-b31e-3c96236eb34d
11c01b5a-3ef7-4298-a9da-18739a99fa62	2c944a82-e4a1-4d58-b31e-3c96236eb34d
9bc40373-4a2a-46ff-847c-714cb460e549	ae79c603-8cb2-40f8-9d07-c69363f0039a
0ebec10d-4478-49ab-93f9-154d33b27b48	ae79c603-8cb2-40f8-9d07-c69363f0039a
bccab95d-41a0-417f-8c60-c4930d2ee64b	ae79c603-8cb2-40f8-9d07-c69363f0039a
de089951-60b0-4a0f-96f0-808a6dbdee71	ae79c603-8cb2-40f8-9d07-c69363f0039a
9945f686-7847-4d78-9b8c-154e2a2bb296	ae79c603-8cb2-40f8-9d07-c69363f0039a
2b0ca2ad-7e28-4a9c-b0a3-63b4f4b5f427	1b9b305d-dc05-42d2-b4b1-47e95b8cc167
c63831fc-1419-470b-8f44-bdf13b06618c	1b9b305d-dc05-42d2-b4b1-47e95b8cc167
e0cb29a5-a7e7-4183-a647-59027c0c8c2e	1b9b305d-dc05-42d2-b4b1-47e95b8cc167
21f3514c-8861-4b5f-ac3f-d4b88441adcc	1b9b305d-dc05-42d2-b4b1-47e95b8cc167
95824968-09b5-45c3-a5ff-f6c8fad3cba5	1b9b305d-dc05-42d2-b4b1-47e95b8cc167
76a4baa0-c312-47de-abd8-38d342f5648a	f43b5db9-d9fe-4f67-b1df-48dd4cf237af
433ec679-855f-4e2e-8302-b485271cd68f	f43b5db9-d9fe-4f67-b1df-48dd4cf237af
86ccc8a7-5a8e-468d-b03c-4ce0436bc4dd	f43b5db9-d9fe-4f67-b1df-48dd4cf237af
7cf1f5ae-d764-4d10-904d-1d8052283126	f43b5db9-d9fe-4f67-b1df-48dd4cf237af
1a948c76-f0c1-42ea-8a98-090bb3c0e952	f43b5db9-d9fe-4f67-b1df-48dd4cf237af
30edbd28-6241-4876-ae87-818171fb29ea	f090f032-d9d9-4ec2-9490-16e3db96212b
0bfb3ac9-90de-4934-b39b-178edde5c7ef	f090f032-d9d9-4ec2-9490-16e3db96212b
5b79fd4a-7656-4ddd-8860-b292b48350e6	f090f032-d9d9-4ec2-9490-16e3db96212b
6ce04d42-1a73-46e1-b145-4f43f004cd70	f090f032-d9d9-4ec2-9490-16e3db96212b
73c5e039-5fd5-45ca-8b42-e46dfc33d06c	f090f032-d9d9-4ec2-9490-16e3db96212b
5d2a1df2-7371-435c-b241-b3c9539b6049	ef9c52da-c800-4fb6-8ecb-6851e26a2794
c60c6dbc-67c4-42e9-adaf-acc0c82822ac	ef9c52da-c800-4fb6-8ecb-6851e26a2794
0ce316b3-41f3-4a74-8bfc-e0ee3cfe4000	ef9c52da-c800-4fb6-8ecb-6851e26a2794
36ea01fe-9920-424a-a9bb-b5de23ec2c7d	ef9c52da-c800-4fb6-8ecb-6851e26a2794
1652f904-9088-4fa5-bd63-9ff1e6efcf97	ef9c52da-c800-4fb6-8ecb-6851e26a2794
bf95d0b0-a562-4c96-9252-5b2ed9bcfb64	1b279197-328f-4ff1-a8a3-60e842b4d099
7001f4bb-55d0-4a1f-bde5-e514920a429b	1b279197-328f-4ff1-a8a3-60e842b4d099
9edbbc8c-bc1b-42ba-8914-1d9e9db2347f	1b279197-328f-4ff1-a8a3-60e842b4d099
85429d43-9926-4439-8704-20e18bb5679b	1b279197-328f-4ff1-a8a3-60e842b4d099
dc0136e1-f792-4aac-a8ea-16e09675995c	1b279197-328f-4ff1-a8a3-60e842b4d099
ef8e7e2c-eeeb-439d-b7f9-ade465fc4f68	8d8d2fbb-cae3-4073-a46d-d4e01d204cad
79300c61-6d47-405d-9a9a-d1e8f0204305	8d8d2fbb-cae3-4073-a46d-d4e01d204cad
9e61e347-ce40-43c5-a332-f5683442b1fa	8d8d2fbb-cae3-4073-a46d-d4e01d204cad
d3672c54-1ef2-471a-ba24-239a3990fc75	8d8d2fbb-cae3-4073-a46d-d4e01d204cad
ef53ffdb-0f3a-492e-874c-fcd8fba11d06	8d8d2fbb-cae3-4073-a46d-d4e01d204cad
01712afa-c526-4f73-94ae-02734ce15c96	a14ae54e-0797-4324-8b82-9846be3aa9fd
9b63b2f1-f8e9-42f3-8d4f-a49a3f16e914	a14ae54e-0797-4324-8b82-9846be3aa9fd
c23dcaad-e9fa-4c6b-8d86-4fd2f3c125e9	a14ae54e-0797-4324-8b82-9846be3aa9fd
5e78e0bf-da34-4c8b-ab86-2a6b9f8d63a8	a14ae54e-0797-4324-8b82-9846be3aa9fd
127e289a-cced-4934-91ee-0bd505946855	a14ae54e-0797-4324-8b82-9846be3aa9fd
a4c357bb-03ad-445b-b073-d6c5a8a9ce33	f1e4428f-78dc-4c65-93b0-a5fd4a291f23
96931619-4af6-4562-9d21-45a09a3a369f	f1e4428f-78dc-4c65-93b0-a5fd4a291f23
35210960-6f4c-4dde-9ee3-063f923c3dc3	f1e4428f-78dc-4c65-93b0-a5fd4a291f23
631514ab-cb74-4a79-a03d-ea3e718ee702	f1e4428f-78dc-4c65-93b0-a5fd4a291f23
a5f66249-7b4d-4084-a7b2-76a4ce0f2483	f1e4428f-78dc-4c65-93b0-a5fd4a291f23
9ac23e05-d27e-4732-83a1-dc07ce94c3e5	86b6a785-abca-429f-991c-d473d49502ee
47b9440a-6769-4287-b4e7-a9a79fbf4fdc	86b6a785-abca-429f-991c-d473d49502ee
c545077e-d983-473a-b621-d0213869b06d	86b6a785-abca-429f-991c-d473d49502ee
40951858-8246-4cb1-b095-0d20303ca115	86b6a785-abca-429f-991c-d473d49502ee
7eaed4ff-162a-430f-8a35-1acdd53bc884	86b6a785-abca-429f-991c-d473d49502ee
8b6e660f-2253-4b81-9b42-a065a6964f56	3d6690d8-eadd-46a6-8fea-73dbcdd3ec66
51fde179-1543-41de-9206-eaa3c75f9b59	3d6690d8-eadd-46a6-8fea-73dbcdd3ec66
05915171-100e-4d10-89e4-c872711de1aa	3d6690d8-eadd-46a6-8fea-73dbcdd3ec66
c66b4475-75d3-4d34-b33a-87077ac6bdab	3d6690d8-eadd-46a6-8fea-73dbcdd3ec66
22e0168a-c2a8-4e0b-85ec-a8d88eafa46e	3d6690d8-eadd-46a6-8fea-73dbcdd3ec66
10b5d9e1-b62d-4c93-ba9c-d5a258b6f2c3	7e294bf6-2eec-49aa-9d8f-a6d4a2cc498b
f98570e1-e406-4857-9e8d-90c97ea8b7eb	7e294bf6-2eec-49aa-9d8f-a6d4a2cc498b
e6c49376-930b-4689-9111-51386ff65eb8	7e294bf6-2eec-49aa-9d8f-a6d4a2cc498b
6e7329c4-fbf0-4c06-aed1-f57996b0dc02	7e294bf6-2eec-49aa-9d8f-a6d4a2cc498b
ecb7bd93-4a76-4895-af27-8033ffb4b9ee	7e294bf6-2eec-49aa-9d8f-a6d4a2cc498b
86b7a281-7358-4bd0-be35-d7b13d3a54d7	508fd417-903e-485c-8a79-1d47fecf89ec
c0727846-37aa-424a-a8b6-776f29a6b11c	508fd417-903e-485c-8a79-1d47fecf89ec
69b38b68-43bc-4d73-9de6-7252271f950c	508fd417-903e-485c-8a79-1d47fecf89ec
b20c5473-4f4b-4af4-b0ac-f25f63c15091	508fd417-903e-485c-8a79-1d47fecf89ec
80e08532-d009-40b6-b60b-01ad848f29e7	508fd417-903e-485c-8a79-1d47fecf89ec
dd80f6f0-c10b-4172-a531-716f9dd1c230	70a9c7ec-c890-4cb2-9978-47493f08fa8f
98b7684c-bcff-4679-89a6-c6f0d23f0540	70a9c7ec-c890-4cb2-9978-47493f08fa8f
e70c5835-3e0c-4681-b682-089b156bdd3c	70a9c7ec-c890-4cb2-9978-47493f08fa8f
55dcf71d-31cb-43c0-b001-288d404c3890	70a9c7ec-c890-4cb2-9978-47493f08fa8f
58713621-70cd-4c5e-9341-28b32ba41fb9	70a9c7ec-c890-4cb2-9978-47493f08fa8f
1807e1c8-fe69-44f0-99f5-5543862721dd	9d0dccbc-1024-4802-993c-933cb6cdc260
3021c2ed-dea4-4b82-a0e4-147c790655fd	9d0dccbc-1024-4802-993c-933cb6cdc260
778fbe77-519d-43cf-8e5f-b7524f22be6d	9d0dccbc-1024-4802-993c-933cb6cdc260
a3760f39-a4f7-494b-98ef-ca6264671474	9d0dccbc-1024-4802-993c-933cb6cdc260
739c1d61-b1fb-4f93-8a6f-a20d3910c4a0	9d0dccbc-1024-4802-993c-933cb6cdc260
c82c39e8-1b65-4647-90af-d2e6fc0e80a4	786d3d1a-1946-4dd0-817b-dab8b0dfa161
628a887f-5405-49b5-a113-8da165007f80	786d3d1a-1946-4dd0-817b-dab8b0dfa161
62ecff54-d3ad-4590-9773-f7a975437ddf	786d3d1a-1946-4dd0-817b-dab8b0dfa161
63af20f3-0299-4b5b-8c39-e1343f9f944b	786d3d1a-1946-4dd0-817b-dab8b0dfa161
cedd3c7e-baf0-471f-9044-b43cca83af23	786d3d1a-1946-4dd0-817b-dab8b0dfa161
07045af3-ed80-4990-a660-6282fe0fe4fb	bc548182-4db3-4087-a94d-d059f9f386e4
f5f06691-69b5-4979-aee5-1c940a3a17b3	bc548182-4db3-4087-a94d-d059f9f386e4
33f44877-bc89-4386-aca3-ef3a4946d305	bc548182-4db3-4087-a94d-d059f9f386e4
bdf997dd-df12-480a-ae52-8950beded503	bc548182-4db3-4087-a94d-d059f9f386e4
2319137c-c5cc-4ea5-9de7-50713a7f88c4	bc548182-4db3-4087-a94d-d059f9f386e4
d42ed59c-0c22-4b9b-bebf-118132eeb353	803bc41a-3cf3-4f5a-b888-26b61a5ba929
3da18c61-9632-4a05-9962-27590f23772d	803bc41a-3cf3-4f5a-b888-26b61a5ba929
8a758888-6213-4881-9b2b-690336684fa7	803bc41a-3cf3-4f5a-b888-26b61a5ba929
3f987ebb-99ce-497d-81e3-5dc76547cc98	803bc41a-3cf3-4f5a-b888-26b61a5ba929
0f76ce1d-7218-4ff1-848a-af873e4033b3	803bc41a-3cf3-4f5a-b888-26b61a5ba929
924a0f97-19fa-46d9-8720-b3203cbb4ad3	9f71cf2b-168c-4efe-844e-afe0e670ccbf
0f289146-ce3b-42a6-b59e-3f159bb3e6f7	9f71cf2b-168c-4efe-844e-afe0e670ccbf
b58ca63f-f2e7-411e-a5da-fe0857ba17d7	9f71cf2b-168c-4efe-844e-afe0e670ccbf
a0562a18-237a-401a-9e61-99b48c4122dd	9f71cf2b-168c-4efe-844e-afe0e670ccbf
d6af0d41-100d-4f6d-9bca-da31efbef9b9	9f71cf2b-168c-4efe-844e-afe0e670ccbf
9d445c33-454e-49dc-a493-0f5015eead12	6b2e2ac5-98ee-4257-a54a-f24c7cb8fb01
2b332fc6-9146-4623-863f-255d6566214f	6b2e2ac5-98ee-4257-a54a-f24c7cb8fb01
7df394a5-4dff-468b-b97e-0559c07fa1b9	6b2e2ac5-98ee-4257-a54a-f24c7cb8fb01
a0304a67-0fff-496c-9419-d6696ba39cc1	6b2e2ac5-98ee-4257-a54a-f24c7cb8fb01
870c2ff3-ea24-4139-b31b-c643aa094c67	6b2e2ac5-98ee-4257-a54a-f24c7cb8fb01
f6806a22-5e75-442a-8474-1f1bf3b49bb0	5e8bca7b-a019-4138-9939-7951646ad23c
43c5b7d9-a1c7-4361-a0cf-0aa73a9333a7	5e8bca7b-a019-4138-9939-7951646ad23c
55fdca5e-d193-44a3-ada5-2ab4d65395d6	5e8bca7b-a019-4138-9939-7951646ad23c
0357e12e-1e20-4de1-89f8-17dfdd55fd31	5e8bca7b-a019-4138-9939-7951646ad23c
c4ae769f-b5a3-48a9-885a-c99c99c19e37	5e8bca7b-a019-4138-9939-7951646ad23c
3158d744-02ae-45d3-a4c1-3b8a5c22de3e	9b4b9979-0172-4961-9d58-10f57df85092
3dac7ef7-c456-42a2-8fc4-519e13b07ee0	9b4b9979-0172-4961-9d58-10f57df85092
040fde0b-489a-4cc8-bfba-6f69ba7f4f11	9b4b9979-0172-4961-9d58-10f57df85092
e657559e-c7af-4fa3-8d0a-aba39f0ba879	9b4b9979-0172-4961-9d58-10f57df85092
bf015865-7bd0-4282-bc70-61735421f9f1	9b4b9979-0172-4961-9d58-10f57df85092
3e935853-f1c6-47a7-9e22-2a457109ee60	305fba50-26ce-48e4-af27-4ea801b1ef30
70511c74-d0ea-42c8-8bbf-f8446f544022	305fba50-26ce-48e4-af27-4ea801b1ef30
7f76cd2d-725a-479d-999f-6581b07371ac	305fba50-26ce-48e4-af27-4ea801b1ef30
90c56da0-ae13-4f05-aa67-be54c7bad83a	305fba50-26ce-48e4-af27-4ea801b1ef30
d43aa0c1-4c5f-4c36-bf52-1df23a753b59	305fba50-26ce-48e4-af27-4ea801b1ef30
65dac126-89fc-463c-ba18-63d827a920c5	823a9569-d81b-4871-9b0d-1a8f04de234a
e8aa370e-19da-4d55-bb48-c53fff30c7b2	823a9569-d81b-4871-9b0d-1a8f04de234a
907454e2-0671-4ddf-9725-3509a9c3a454	823a9569-d81b-4871-9b0d-1a8f04de234a
1633cc84-63f4-4adf-986b-7da47de84bad	823a9569-d81b-4871-9b0d-1a8f04de234a
a1e46639-3086-442e-a8ea-efcc9193e674	823a9569-d81b-4871-9b0d-1a8f04de234a
\.


--
-- Data for Name: community2community; Type: TABLE DATA; Schema: public; Owner: funasauser
--

COPY public.community2community (parent_comm_id, child_comm_id) FROM stdin;
ea38e67d-c827-487c-b429-13be16d4a6c5	0c873029-343e-4740-bd26-c976c9b2c6c2
0c873029-343e-4740-bd26-c976c9b2c6c2	1f757c54-5850-4cbe-ae02-284cfaccc1e7
0c873029-343e-4740-bd26-c976c9b2c6c2	e8be30cd-3daa-4118-8548-8731d7495020
0c873029-343e-4740-bd26-c976c9b2c6c2	b09f6eb0-f79f-489a-a7e8-bb87486bc1b2
ea38e67d-c827-487c-b429-13be16d4a6c5	e13aa597-d0ce-44df-a774-e65c5b8ce61c
e13aa597-d0ce-44df-a774-e65c5b8ce61c	62cb0c79-b578-470b-9e81-6a712fea7281
ea38e67d-c827-487c-b429-13be16d4a6c5	050033bb-42bb-4d2e-be49-3bb13979f6b3
050033bb-42bb-4d2e-be49-3bb13979f6b3	bf24224f-e566-4c37-a5f1-27a1867114e6
050033bb-42bb-4d2e-be49-3bb13979f6b3	ca5ff7d4-3470-4ef2-90ca-dc563214be58
050033bb-42bb-4d2e-be49-3bb13979f6b3	7a290d59-1bed-4a4f-a6a1-02e191774a8f
050033bb-42bb-4d2e-be49-3bb13979f6b3	6c5dd78a-94ba-4ba9-ba37-401a80442dd5
683bfc83-3cc1-4f22-83d3-c9ee4ea2c82b	435bcf56-d368-4f2f-8e7f-4bafd3367063
435bcf56-d368-4f2f-8e7f-4bafd3367063	f0cb7fe8-e5c5-4d33-9530-b38f96535074
435bcf56-d368-4f2f-8e7f-4bafd3367063	342ea849-01c8-41cd-b812-44638b5c22ef
683bfc83-3cc1-4f22-83d3-c9ee4ea2c82b	e88afa75-f030-4a94-8c91-72257614e295
683bfc83-3cc1-4f22-83d3-c9ee4ea2c82b	7709d357-75c7-4039-bfcf-f2297e7493e9
7709d357-75c7-4039-bfcf-f2297e7493e9	e43ea389-e3e6-410b-bbc3-75bce3a6474f
7709d357-75c7-4039-bfcf-f2297e7493e9	08285b26-0b55-48c0-aae2-bd4c60dece4b
6805171d-b16f-46e4-b7a1-2d91aafb9037	043d9a3f-684c-4fc2-a642-4df251ff0ce6
6805171d-b16f-46e4-b7a1-2d91aafb9037	54def7e9-b01c-4405-831b-f55d391bc8db
6805171d-b16f-46e4-b7a1-2d91aafb9037	0122bff8-45c5-4403-9af8-4d92e63bf462
6805171d-b16f-46e4-b7a1-2d91aafb9037	c338e24b-54ce-439e-80fb-6aea64047d8c
c338e24b-54ce-439e-80fb-6aea64047d8c	58411222-09a0-4a4c-a0aa-a16fed8c8057
c338e24b-54ce-439e-80fb-6aea64047d8c	131515f5-0c56-4276-94dd-054d41a4f959
c338e24b-54ce-439e-80fb-6aea64047d8c	265b2c85-db13-4fe1-ab54-4134f76d252b
6805171d-b16f-46e4-b7a1-2d91aafb9037	777e1210-3ec0-459a-aca6-29b715063e73
6805171d-b16f-46e4-b7a1-2d91aafb9037	6599bbd5-7809-439a-85d2-dd0c607838cc
f7af0744-1ec4-437f-88db-205b9666f652	4de09263-c707-4a67-b45a-f9de6a6edac0
4de09263-c707-4a67-b45a-f9de6a6edac0	7590066c-de6e-4a65-9565-25e1bd3b87f6
4de09263-c707-4a67-b45a-f9de6a6edac0	01bf637b-7e76-4610-88b6-b85270d50e0c
4de09263-c707-4a67-b45a-f9de6a6edac0	927e147b-5d98-4bc8-be35-941cdaf90018
f7af0744-1ec4-437f-88db-205b9666f652	1f1e123d-71ba-45d8-a436-9866334f6679
1f1e123d-71ba-45d8-a436-9866334f6679	4a04d20c-9629-456f-a426-cc82d587d3cb
1f1e123d-71ba-45d8-a436-9866334f6679	fa19502e-672d-4ce0-b465-111ab855321a
f7af0744-1ec4-437f-88db-205b9666f652	68c53a2c-0fd6-42a1-9c67-3387ebe11972
68c53a2c-0fd6-42a1-9c67-3387ebe11972	5a2d5225-d585-4549-8758-a2c186dcb42a
68c53a2c-0fd6-42a1-9c67-3387ebe11972	e062cd7e-5965-432f-89e4-7d30ea154e87
f7af0744-1ec4-437f-88db-205b9666f652	f46e680e-8e04-426a-b055-c66c18163caa
f46e680e-8e04-426a-b055-c66c18163caa	12f102df-9e17-4bbd-8a46-6879014fd76b
f7af0744-1ec4-437f-88db-205b9666f652	6ad2c279-e29e-402c-a09b-cadf0a19207f
a6dbaa98-ed1f-40f8-bdf9-8822d64a800d	2c944a82-e4a1-4d58-b31e-3c96236eb34d
a6dbaa98-ed1f-40f8-bdf9-8822d64a800d	ae79c603-8cb2-40f8-9d07-c69363f0039a
a6dbaa98-ed1f-40f8-bdf9-8822d64a800d	0a540eac-23c0-4dca-9943-d006688c005b
0a540eac-23c0-4dca-9943-d006688c005b	1b9b305d-dc05-42d2-b4b1-47e95b8cc167
0a540eac-23c0-4dca-9943-d006688c005b	f43b5db9-d9fe-4f67-b1df-48dd4cf237af
0a540eac-23c0-4dca-9943-d006688c005b	f090f032-d9d9-4ec2-9490-16e3db96212b
0a540eac-23c0-4dca-9943-d006688c005b	ef9c52da-c800-4fb6-8ecb-6851e26a2794
a6dbaa98-ed1f-40f8-bdf9-8822d64a800d	1b279197-328f-4ff1-a8a3-60e842b4d099
a6dbaa98-ed1f-40f8-bdf9-8822d64a800d	8d8d2fbb-cae3-4073-a46d-d4e01d204cad
a6dbaa98-ed1f-40f8-bdf9-8822d64a800d	a14ae54e-0797-4324-8b82-9846be3aa9fd
a6dbaa98-ed1f-40f8-bdf9-8822d64a800d	f1e4428f-78dc-4c65-93b0-a5fd4a291f23
04ae4009-f11b-486e-929a-2512280f4227	7482f96f-4d1c-42ef-935b-afa2a5bc1045
7482f96f-4d1c-42ef-935b-afa2a5bc1045	86b6a785-abca-429f-991c-d473d49502ee
7482f96f-4d1c-42ef-935b-afa2a5bc1045	3d6690d8-eadd-46a6-8fea-73dbcdd3ec66
7482f96f-4d1c-42ef-935b-afa2a5bc1045	7e294bf6-2eec-49aa-9d8f-a6d4a2cc498b
7482f96f-4d1c-42ef-935b-afa2a5bc1045	508fd417-903e-485c-8a79-1d47fecf89ec
7482f96f-4d1c-42ef-935b-afa2a5bc1045	70a9c7ec-c890-4cb2-9978-47493f08fa8f
7482f96f-4d1c-42ef-935b-afa2a5bc1045	9d0dccbc-1024-4802-993c-933cb6cdc260
7482f96f-4d1c-42ef-935b-afa2a5bc1045	786d3d1a-1946-4dd0-817b-dab8b0dfa161
04ae4009-f11b-486e-929a-2512280f4227	12188074-fdf3-41c4-96c8-fdd2d1cee710
12188074-fdf3-41c4-96c8-fdd2d1cee710	bc548182-4db3-4087-a94d-d059f9f386e4
12188074-fdf3-41c4-96c8-fdd2d1cee710	803bc41a-3cf3-4f5a-b888-26b61a5ba929
04ae4009-f11b-486e-929a-2512280f4227	214d281b-6762-46e2-a6a1-98d270cbf4bb
214d281b-6762-46e2-a6a1-98d270cbf4bb	9f71cf2b-168c-4efe-844e-afe0e670ccbf
04ae4009-f11b-486e-929a-2512280f4227	305fba50-26ce-48e4-af27-4ea801b1ef30
04ae4009-f11b-486e-929a-2512280f4227	823a9569-d81b-4871-9b0d-1a8f04de234a
\.


--
-- Data for Name: doi; Type: TABLE DATA; Schema: public; Owner: funasauser
--

COPY public.doi (doi_id, doi, resource_type_id, resource_id, status, dspace_object) FROM stdin;
\.


--
-- Name: doi_seq; Type: SEQUENCE SET; Schema: public; Owner: funasauser
--

SELECT pg_catalog.setval('public.doi_seq', 1, false);


--
-- Data for Name: dspaceobject; Type: TABLE DATA; Schema: public; Owner: funasauser
--

COPY public.dspaceobject (uuid) FROM stdin;
582e3083-b833-4022-a81e-04220f4eca76
2749c445-d9b3-4641-bbd5-c292cbc31c3e
44f60f35-fb87-4dd7-98cc-eb861476c8b0
cd410caa-8ed0-4822-8722-8eab234a8b4c
ea38e67d-c827-487c-b429-13be16d4a6c5
0c873029-343e-4740-bd26-c976c9b2c6c2
1f757c54-5850-4cbe-ae02-284cfaccc1e7
afd22d8d-4201-4482-888c-c06b85307651
4b0ebee1-3f02-43c5-bdac-923b17a459bb
240b86fb-057a-4098-b4a9-16362bd4d88e
f02c8749-274c-4492-ba7b-cc33c3b8db61
28df2a70-de20-4c58-a5c8-e3c24e688cee
e8be30cd-3daa-4118-8548-8731d7495020
19737605-9de5-494c-b19e-7118aa37b963
f5a61cfd-721a-4eba-bf4f-4fa931159f12
bf82b5db-01cb-402c-81a9-8249ff7395a6
2aa863cf-c22a-4dae-8aed-2f08b702420a
d72bd580-c8d7-46af-ad71-ee7a50bbd582
b09f6eb0-f79f-489a-a7e8-bb87486bc1b2
0607dd1b-5468-48ef-8905-8d07d253d1f7
d52095c9-d548-4f66-9dad-d84f4928ded7
f805ab68-cf57-431a-affc-8ce7f9778fe7
5f662caf-e96c-432e-8137-a17afe17283b
fc9b46f8-dd31-4298-9f47-73af77f1c56d
e13aa597-d0ce-44df-a774-e65c5b8ce61c
62cb0c79-b578-470b-9e81-6a712fea7281
c32fae4a-fdfa-4498-a50a-bc9285fbb3a0
8f327435-da4d-4bbe-99f2-df602eddf8fb
b73c9ead-ff11-4e99-bcd0-86186ccd10aa
fd415204-97cc-4568-938b-467f663aab73
19cefe3e-817f-4584-8647-e1e0345ca422
050033bb-42bb-4d2e-be49-3bb13979f6b3
bf24224f-e566-4c37-a5f1-27a1867114e6
3bf97251-0d2c-497a-b1c0-2fb8f089d5d9
24a1c3ff-d7a4-4e39-92ca-bbbd1ef02a13
60f00aaf-c385-4dcb-b9a4-ed59d23e3feb
2a26db78-5987-40be-b908-a20da0086e8b
4e7863f5-b198-47e4-8eb1-688af9155b78
ca5ff7d4-3470-4ef2-90ca-dc563214be58
b85655ce-7a32-438b-9211-a8b12ec6dcfd
33d85721-7ff3-4926-ae80-084bb178dd97
9a582dff-81aa-4021-9f30-f75871aeb9eb
681bb445-6fc8-49c1-9915-1d418f2ac4d1
96f9e582-cb6e-441e-a361-97f5e69b8ff2
7a290d59-1bed-4a4f-a6a1-02e191774a8f
88d41f3a-a149-4dc5-81a2-84380835533a
41b5c503-8ca0-435f-8103-3e692593b755
728d1b2f-f32f-4ba9-80ff-922deca5458b
a2561e5d-7cbf-464d-b6e6-6178bddd9bae
25c745b0-5b75-44bd-91fb-f468f52c377b
6c5dd78a-94ba-4ba9-ba37-401a80442dd5
357da42e-ffb4-43f7-bb59-3b66f6d09b1f
8a52ac60-0cb5-4d6f-8b4c-a9cd65b62d0a
d851294f-191c-46a0-abf4-d338042d5971
fbe5350a-c8ba-4a39-98e2-bd742a6be202
3afa7efe-2891-4c47-b396-c83d56ff9d90
683bfc83-3cc1-4f22-83d3-c9ee4ea2c82b
435bcf56-d368-4f2f-8e7f-4bafd3367063
f0cb7fe8-e5c5-4d33-9530-b38f96535074
c087e9be-29f7-437f-b0da-bddb0b2ab183
f2c7e15a-2db1-4099-9d26-78ba2c16b8da
cd75101b-abb6-46ef-ac88-3af552f33478
b55202c0-1e3b-4eba-909d-54f7fad48b9c
6ef94e51-16d7-4cec-9359-a94d499e8337
342ea849-01c8-41cd-b812-44638b5c22ef
411dd125-33df-451a-87c9-7dca418b665e
7db66edb-3f9f-4c24-8fa2-0a4b11efb0b8
b2020a23-0063-4efe-b770-9c9a5a099b42
6a8d7523-aace-4c61-9a7f-9133ae72d7b0
3449a99e-7799-4ba0-bd51-63ae8ee23093
e88afa75-f030-4a94-8c91-72257614e295
1e0e772a-32a3-4fef-99c9-2aeab683bae2
909a8161-d474-4b0e-afdc-5a5ae63c3a6c
f6ed7993-8237-4ef0-9cc4-0573e90e75d2
66151470-c472-418e-a958-e93c235b10e4
d46da801-96a5-42ca-90a0-0ed42a484f3b
7709d357-75c7-4039-bfcf-f2297e7493e9
e43ea389-e3e6-410b-bbc3-75bce3a6474f
f3152358-78b0-495c-8086-12b8a7a6e7c4
87416815-8bb9-42a5-98eb-5aefce3bfbcf
24b8f080-dac2-454c-aba3-16201b523039
e666ae2f-259c-4fff-8884-df1c6401bbf9
289a3f50-e20c-442b-b1af-a6dc0e973bd5
08285b26-0b55-48c0-aae2-bd4c60dece4b
efa858af-f6b2-44c4-abf0-e469f1353d10
1ba431f3-259a-4751-9ae9-22d5a110ae53
3011dd24-c2db-46ef-b5d1-895e38d9b930
110adbb2-e44d-4c83-80e6-d404b4741ed4
9683b122-799f-4d4e-92b8-8f57283e964f
6805171d-b16f-46e4-b7a1-2d91aafb9037
043d9a3f-684c-4fc2-a642-4df251ff0ce6
995b6a10-b9dc-4f43-bd81-b6249cd8b191
617031b7-af6b-4fa3-9644-dc5ade438caf
5b1045d7-6c9e-4446-ae09-6831ea31e1cc
0a4d3518-c6fa-4a84-bec3-453eafd845b7
c513be3f-2789-46b7-bc33-0feea0e7e628
54def7e9-b01c-4405-831b-f55d391bc8db
5539833b-6142-452e-bea3-fc373b058c14
ef2b53fa-b6fb-4962-a523-53ff8c1e65fa
701fb3d8-8ea8-43b9-ad0a-27e0a053f41f
82ad2994-8a8a-4734-8924-089e49902749
3004c43c-f694-4d5d-bc56-d89e562d8810
0122bff8-45c5-4403-9af8-4d92e63bf462
2255af62-ea0f-441e-8cef-c95a842d0c8f
5f35338b-62e5-48be-9737-7ec419eb9fc9
beaabaf0-bfc2-411f-9a6d-e6135d699097
ee0feefe-84c4-4d99-b69c-06445074d7ff
1f9d14c8-64db-41c2-9867-9641e5d112b1
c338e24b-54ce-439e-80fb-6aea64047d8c
58411222-09a0-4a4c-a0aa-a16fed8c8057
4ee1cee2-a251-4b2d-9205-e12ad4a8499a
8380299d-ae45-4b0b-bab1-3f2769dfdca8
f4897015-28c0-46b4-9b1c-0312bbe14f19
cf051540-fc52-47a6-9247-7cca3089b0d2
0f8aee5b-53cc-46b2-af21-4b7fea33f4a8
131515f5-0c56-4276-94dd-054d41a4f959
2db4aa27-37b4-454e-86d1-24dd3185a968
6fbf8d40-a83f-4977-bf0f-2fbdc397a975
7e531fe1-bf4a-4d2e-a697-b8ccaf587377
e6dd595d-9bc9-4ec0-a594-1e9c8d541133
f8f0c20b-e38b-47ee-8788-2c675649e67c
265b2c85-db13-4fe1-ab54-4134f76d252b
4e77e1c7-3c74-4ced-ba10-bad97ecd405d
3bbcfa02-d7d2-4733-9f3d-45ad29a8117a
cd65d599-6ac3-470c-9eb6-75f9aed99357
9f225cd4-4db1-4fb2-b976-ea4e9ae18656
f2af2366-3fec-449c-9571-fe170605a28e
777e1210-3ec0-459a-aca6-29b715063e73
ea7f0fea-6dd7-4907-beef-d60d62f7a0d9
79f9afe4-97a6-42a4-a906-f80f360ad656
828c145d-a069-48d4-857b-9ee667d38c68
ac22c96b-12db-4e4a-82c9-63e1c5af3de3
f68dd0f4-475b-4b2d-9cd1-8236b29ff7b4
6599bbd5-7809-439a-85d2-dd0c607838cc
8742eb33-87b7-4f31-8ed8-be8788d16368
048560cc-de2b-4693-969c-61d493365d18
bb4c6911-03b5-480e-819e-6a760460e9a1
893f8288-3bfe-4656-9c84-4fbb6f695849
2f7c5598-12bd-41ee-a1f4-625b8d93f2ef
f7af0744-1ec4-437f-88db-205b9666f652
4de09263-c707-4a67-b45a-f9de6a6edac0
7590066c-de6e-4a65-9565-25e1bd3b87f6
90601c90-b68b-4ea2-8b12-e13ccc6eb0e5
673a6a9d-1cdd-4613-ac3b-1814c8831656
f9de8b0b-92ab-4726-9a25-387f0a8d2720
9611172c-b2e0-4bfa-8f3c-57d9f82bb480
22b91317-4740-4caa-bb89-5a45c9c311f3
01bf637b-7e76-4610-88b6-b85270d50e0c
645f03ae-c3bd-4ff3-94c3-31acc342036c
4f1937a8-4952-4ad7-8517-a3b777ef3ed7
9c1f759e-1c23-443e-b601-dd4b5a867d98
eb746f42-f39e-484c-8ad7-51b355b7f227
a6ba185b-3885-4be2-9bb5-dc61de428543
927e147b-5d98-4bc8-be35-941cdaf90018
c5d79dda-0dfe-4acb-ba9b-b9850715b7f5
a44d06ae-fd12-4b30-b17e-24944c917470
f38cddca-d777-4d6b-b104-867d27969d2a
48de73ab-3a92-4c08-a1ae-4c7cf43e8341
a89ae057-da72-458a-8b54-c2c01c59633e
1f1e123d-71ba-45d8-a436-9866334f6679
4a04d20c-9629-456f-a426-cc82d587d3cb
b824b5fd-76a7-4fd8-87a3-6d2942b62eb0
40a29a62-25aa-491f-8791-ec96017b4e12
79922945-f438-4446-bc33-6565320adebf
63035ee2-cc1c-4302-9d66-ebf6901744a4
c1a15047-56a4-43bf-aaf6-fd0e6477f98f
fa19502e-672d-4ce0-b465-111ab855321a
70366e28-2101-47c1-abc4-3711331158f2
4a253056-b197-44af-b8e6-13f826ad9a22
d3b46df8-f992-4cc2-824c-1efbbd369775
5eff5609-7edc-4d4f-98d3-a7a561862a93
fdae48ca-2993-46f9-b543-c623e2f23a28
68c53a2c-0fd6-42a1-9c67-3387ebe11972
5a2d5225-d585-4549-8758-a2c186dcb42a
8d1bb197-7f21-44c8-8b4f-1aa584dcc189
6a4f724e-ee9e-41c4-9418-275558f5b865
84d45869-0e52-4f3c-8468-7419f86c5727
9a4df270-972f-4ab6-9fb0-5f96e79db5da
0daedcc9-d2b3-4833-bfe4-a0eeaee838b2
e062cd7e-5965-432f-89e4-7d30ea154e87
44560ab4-adc2-443e-a599-1a440bfc5c48
640da60a-12ee-48e4-90d5-9d3609e18051
8db9f9d0-d195-407a-923d-a0de4a20bfed
85683df6-16a7-4ded-b5fd-74f04e3b8080
bdb6f30c-459c-48a3-ac6f-1a861a004953
f46e680e-8e04-426a-b055-c66c18163caa
12f102df-9e17-4bbd-8a46-6879014fd76b
ca5e06ab-e7d9-4963-8747-67003deb6b31
7e9ba303-9d53-4c40-90b9-4f68d86270f2
3f84afbc-9185-4a3f-b3c9-569c3e9da89b
0aa9ece4-f742-4c0a-8040-cdf4d8faf5b9
f597ed21-6f76-41b8-8c1d-57f763859fad
6ad2c279-e29e-402c-a09b-cadf0a19207f
9c532e18-a50a-4815-bbcc-a2e5d9c2b65f
105d0e1a-d561-459b-8322-0e985510883b
130b1879-7c73-446f-95cb-dfa274fd8361
0de8081c-86c1-4318-96a2-61ff4a5eafd8
a12c7960-d301-433f-b967-55d86845070b
a6dbaa98-ed1f-40f8-bdf9-8822d64a800d
2c944a82-e4a1-4d58-b31e-3c96236eb34d
3bbe59c8-460c-4879-bad9-50a6607ac8f0
6486917f-01cd-4e4d-b606-af71d92a14fa
9f65562a-b18b-429c-892e-5740150f30ce
0e56849a-8a47-4e6a-a208-7af588a91310
11c01b5a-3ef7-4298-a9da-18739a99fa62
ae79c603-8cb2-40f8-9d07-c69363f0039a
9bc40373-4a2a-46ff-847c-714cb460e549
0ebec10d-4478-49ab-93f9-154d33b27b48
bccab95d-41a0-417f-8c60-c4930d2ee64b
de089951-60b0-4a0f-96f0-808a6dbdee71
9945f686-7847-4d78-9b8c-154e2a2bb296
0a540eac-23c0-4dca-9943-d006688c005b
1b9b305d-dc05-42d2-b4b1-47e95b8cc167
2b0ca2ad-7e28-4a9c-b0a3-63b4f4b5f427
c63831fc-1419-470b-8f44-bdf13b06618c
e0cb29a5-a7e7-4183-a647-59027c0c8c2e
21f3514c-8861-4b5f-ac3f-d4b88441adcc
95824968-09b5-45c3-a5ff-f6c8fad3cba5
f43b5db9-d9fe-4f67-b1df-48dd4cf237af
76a4baa0-c312-47de-abd8-38d342f5648a
433ec679-855f-4e2e-8302-b485271cd68f
86ccc8a7-5a8e-468d-b03c-4ce0436bc4dd
7cf1f5ae-d764-4d10-904d-1d8052283126
1a948c76-f0c1-42ea-8a98-090bb3c0e952
f090f032-d9d9-4ec2-9490-16e3db96212b
30edbd28-6241-4876-ae87-818171fb29ea
0bfb3ac9-90de-4934-b39b-178edde5c7ef
5b79fd4a-7656-4ddd-8860-b292b48350e6
6ce04d42-1a73-46e1-b145-4f43f004cd70
73c5e039-5fd5-45ca-8b42-e46dfc33d06c
ef9c52da-c800-4fb6-8ecb-6851e26a2794
5d2a1df2-7371-435c-b241-b3c9539b6049
c60c6dbc-67c4-42e9-adaf-acc0c82822ac
0ce316b3-41f3-4a74-8bfc-e0ee3cfe4000
36ea01fe-9920-424a-a9bb-b5de23ec2c7d
1652f904-9088-4fa5-bd63-9ff1e6efcf97
1b279197-328f-4ff1-a8a3-60e842b4d099
bf95d0b0-a562-4c96-9252-5b2ed9bcfb64
7001f4bb-55d0-4a1f-bde5-e514920a429b
9edbbc8c-bc1b-42ba-8914-1d9e9db2347f
85429d43-9926-4439-8704-20e18bb5679b
dc0136e1-f792-4aac-a8ea-16e09675995c
8d8d2fbb-cae3-4073-a46d-d4e01d204cad
ef8e7e2c-eeeb-439d-b7f9-ade465fc4f68
79300c61-6d47-405d-9a9a-d1e8f0204305
9e61e347-ce40-43c5-a332-f5683442b1fa
d3672c54-1ef2-471a-ba24-239a3990fc75
ef53ffdb-0f3a-492e-874c-fcd8fba11d06
a14ae54e-0797-4324-8b82-9846be3aa9fd
01712afa-c526-4f73-94ae-02734ce15c96
9b63b2f1-f8e9-42f3-8d4f-a49a3f16e914
c23dcaad-e9fa-4c6b-8d86-4fd2f3c125e9
5e78e0bf-da34-4c8b-ab86-2a6b9f8d63a8
127e289a-cced-4934-91ee-0bd505946855
f1e4428f-78dc-4c65-93b0-a5fd4a291f23
a4c357bb-03ad-445b-b073-d6c5a8a9ce33
96931619-4af6-4562-9d21-45a09a3a369f
35210960-6f4c-4dde-9ee3-063f923c3dc3
631514ab-cb74-4a79-a03d-ea3e718ee702
a5f66249-7b4d-4084-a7b2-76a4ce0f2483
04ae4009-f11b-486e-929a-2512280f4227
7482f96f-4d1c-42ef-935b-afa2a5bc1045
86b6a785-abca-429f-991c-d473d49502ee
9ac23e05-d27e-4732-83a1-dc07ce94c3e5
47b9440a-6769-4287-b4e7-a9a79fbf4fdc
c545077e-d983-473a-b621-d0213869b06d
40951858-8246-4cb1-b095-0d20303ca115
7eaed4ff-162a-430f-8a35-1acdd53bc884
3d6690d8-eadd-46a6-8fea-73dbcdd3ec66
8b6e660f-2253-4b81-9b42-a065a6964f56
51fde179-1543-41de-9206-eaa3c75f9b59
05915171-100e-4d10-89e4-c872711de1aa
c66b4475-75d3-4d34-b33a-87077ac6bdab
22e0168a-c2a8-4e0b-85ec-a8d88eafa46e
7e294bf6-2eec-49aa-9d8f-a6d4a2cc498b
10b5d9e1-b62d-4c93-ba9c-d5a258b6f2c3
f98570e1-e406-4857-9e8d-90c97ea8b7eb
e6c49376-930b-4689-9111-51386ff65eb8
6e7329c4-fbf0-4c06-aed1-f57996b0dc02
ecb7bd93-4a76-4895-af27-8033ffb4b9ee
508fd417-903e-485c-8a79-1d47fecf89ec
86b7a281-7358-4bd0-be35-d7b13d3a54d7
c0727846-37aa-424a-a8b6-776f29a6b11c
69b38b68-43bc-4d73-9de6-7252271f950c
b20c5473-4f4b-4af4-b0ac-f25f63c15091
80e08532-d009-40b6-b60b-01ad848f29e7
70a9c7ec-c890-4cb2-9978-47493f08fa8f
dd80f6f0-c10b-4172-a531-716f9dd1c230
98b7684c-bcff-4679-89a6-c6f0d23f0540
e70c5835-3e0c-4681-b682-089b156bdd3c
55dcf71d-31cb-43c0-b001-288d404c3890
58713621-70cd-4c5e-9341-28b32ba41fb9
9d0dccbc-1024-4802-993c-933cb6cdc260
1807e1c8-fe69-44f0-99f5-5543862721dd
3021c2ed-dea4-4b82-a0e4-147c790655fd
778fbe77-519d-43cf-8e5f-b7524f22be6d
a3760f39-a4f7-494b-98ef-ca6264671474
739c1d61-b1fb-4f93-8a6f-a20d3910c4a0
786d3d1a-1946-4dd0-817b-dab8b0dfa161
c82c39e8-1b65-4647-90af-d2e6fc0e80a4
628a887f-5405-49b5-a113-8da165007f80
62ecff54-d3ad-4590-9773-f7a975437ddf
63af20f3-0299-4b5b-8c39-e1343f9f944b
cedd3c7e-baf0-471f-9044-b43cca83af23
12188074-fdf3-41c4-96c8-fdd2d1cee710
bc548182-4db3-4087-a94d-d059f9f386e4
07045af3-ed80-4990-a660-6282fe0fe4fb
f5f06691-69b5-4979-aee5-1c940a3a17b3
33f44877-bc89-4386-aca3-ef3a4946d305
bdf997dd-df12-480a-ae52-8950beded503
2319137c-c5cc-4ea5-9de7-50713a7f88c4
803bc41a-3cf3-4f5a-b888-26b61a5ba929
d42ed59c-0c22-4b9b-bebf-118132eeb353
3da18c61-9632-4a05-9962-27590f23772d
8a758888-6213-4881-9b2b-690336684fa7
3f987ebb-99ce-497d-81e3-5dc76547cc98
0f76ce1d-7218-4ff1-848a-af873e4033b3
214d281b-6762-46e2-a6a1-98d270cbf4bb
9f71cf2b-168c-4efe-844e-afe0e670ccbf
924a0f97-19fa-46d9-8720-b3203cbb4ad3
0f289146-ce3b-42a6-b59e-3f159bb3e6f7
b58ca63f-f2e7-411e-a5da-fe0857ba17d7
a0562a18-237a-401a-9e61-99b48c4122dd
d6af0d41-100d-4f6d-9bca-da31efbef9b9
305fba50-26ce-48e4-af27-4ea801b1ef30
9e6cee53-8569-420a-9e75-d704e5f3517c
609ddd28-e6f3-41a2-a670-e0c2776bcca7
33a11e84-68c9-4e4c-8aba-53990a33f7ca
fe7ea1de-7497-4d64-93b5-a6b56d21eee8
73328566-b3cc-4516-a70f-3d7fe821151b
5bfb5579-17ed-4113-b850-5d52fe90f1f7
823a9569-d81b-4871-9b0d-1a8f04de234a
cf9c4758-a326-4605-b96c-86f858c213c6
a761698f-3924-4e7d-9219-37f93670fdf0
b0828ac7-d229-4f84-ae1b-77d8a212c0ff
22be2e2a-2cf2-4956-a75f-bb4ff2c756b9
d129fd45-13f2-414f-a2a3-cb8c153c2c08
54274d99-b0a7-41f5-bfbb-321d3e01d787
6b2e2ac5-98ee-4257-a54a-f24c7cb8fb01
9d445c33-454e-49dc-a493-0f5015eead12
2b332fc6-9146-4623-863f-255d6566214f
7df394a5-4dff-468b-b97e-0559c07fa1b9
a0304a67-0fff-496c-9419-d6696ba39cc1
870c2ff3-ea24-4139-b31b-c643aa094c67
5e8bca7b-a019-4138-9939-7951646ad23c
f6806a22-5e75-442a-8474-1f1bf3b49bb0
43c5b7d9-a1c7-4361-a0cf-0aa73a9333a7
55fdca5e-d193-44a3-ada5-2ab4d65395d6
0357e12e-1e20-4de1-89f8-17dfdd55fd31
c4ae769f-b5a3-48a9-885a-c99c99c19e37
9b4b9979-0172-4961-9d58-10f57df85092
3158d744-02ae-45d3-a4c1-3b8a5c22de3e
3dac7ef7-c456-42a2-8fc4-519e13b07ee0
040fde0b-489a-4cc8-bfba-6f69ba7f4f11
e657559e-c7af-4fa3-8d0a-aba39f0ba879
bf015865-7bd0-4282-bc70-61735421f9f1
1f0c95ab-3775-4094-b293-183d3b5074b2
12f6e52a-9df2-4bc6-8a4a-f88cebb87203
a36abd3c-a60d-454e-b3f6-c661d35d035b
da51fa58-1abe-4f80-bbc7-9e72e48e1fcf
916f5c8f-f012-4adb-8a55-1352136a4e85
e629b0d9-bf91-439a-9f16-632d621535b2
34482a2e-2400-4e9f-85a2-c7e9a654af28
972d8284-ac47-4d48-82fe-103a24fbe65b
15560463-2b70-4a26-9df1-e0de90c0df9e
b37744b2-292c-4937-a401-9243b80980b3
5c1126f4-8376-42d3-b83e-3f4f070a6710
0d9ed226-7e90-48b9-807d-f0b893dd48b0
276a4446-ee69-4bc0-8f29-690dbf3fbaa2
599069e2-0776-4d86-8654-9c6352b3b7c7
25cb38d4-142c-4282-a4cc-b7be4e8f363b
a260f402-ab1b-48d5-8f31-e54b8246e97e
2b2be099-c0d6-40a0-9daf-83fb0c6a8328
2dd047b5-e43b-4ba9-8d1d-b6badc87a459
d5ba2f5e-4e86-40fd-b152-3ae25ff15c7d
91adcac7-c635-47a7-9816-5a36a00e79be
dc46a916-640f-4d78-bf42-a019a5176256
7bba6efb-709f-4b4a-b666-654168314b1c
7b26105a-af1e-4b1f-a66a-f8267a25b94b
539670a8-3427-4d5c-96ac-02b95f900003
0161965c-a80c-46ab-b33a-d596c6eb912a
9709fcb3-1e1e-4825-89cf-6774de18420b
9ec2493d-5731-4e86-a02e-a9e9cf3b2e12
a63a3b39-a5c2-478d-b57b-c250553fa2e0
24f41a56-b4f0-43f7-858d-5fcb0621541b
2f994c23-2fe4-4031-9b44-fd2d8b3036a8
3d028ecc-c3ff-4a05-acda-2afbfe231cb5
91ff9e31-a61d-42bb-9fdd-405a17220205
33dc18c8-e0d8-488d-89fd-1dc632373638
ef695971-00b7-4c43-8a47-1f3c31272310
41ca3781-3d14-4290-857b-74de1273742a
ae7ac122-7e41-4d56-8699-1a0c44e62241
9ca1f9d3-7329-431a-8925-de7be40f98f1
bdd0442a-c010-4085-91e6-08ae289263d6
2e5c87b0-0c5d-47fb-af1a-bffe4a2305be
fc2aee31-cfb0-41b6-9b61-84b092376ea9
b7ff174d-067a-4e2c-8e44-3a5482ba8034
43fc62cf-973e-46f8-bc35-ca46c9cf1952
d222311e-6af9-453e-a7e8-a51be09ab3af
1e206441-d46b-41a3-bde6-b16ab75b9e22
094768e3-b838-4ce5-811d-114d2fa070cb
f0370f2f-d71c-4799-9e2a-aa5c4f0efe12
a35fbc18-7ef2-4f1d-9673-e6cc6330b8a9
d532b057-4536-4ca6-ac4b-537d52c2c8bc
3d0b7cc1-77a0-4562-a8ef-469c0f0bb11c
d7fdf9dd-5702-4353-b54f-8700d7d39cb2
2b6bf1e3-bc59-4c23-ba1b-b99c4f8b6076
3e3f1469-9f2d-4ad6-88f1-e11fcb9bbd73
c79ad9e7-f621-4ec5-a0d9-c2bcffb8e307
7f497245-2823-4263-9d37-96793901a7cd
6aac1840-ba1a-4fbf-98c7-3639d6baf971
bd8f5557-4558-4906-96cf-2b0bf72fe8f5
43f467c7-150e-4fca-ae72-d736dd3be02e
fd0b8087-877f-4855-ad71-9c24986821dd
b769f832-39bf-4295-bafb-418932987f3d
44939725-96d2-4935-8030-00bb43cad6fc
e44af120-0129-47e5-993b-09b5d17149e3
773d1a57-3eec-45c7-9d19-0c011d2e4b1f
13a8e654-e35a-47f7-bce3-c709c5f56beb
5c8e9a8c-d250-4519-86ee-90b00716aced
0f75ba2c-cff7-496b-a5f8-b02ab18a4081
c0ff9ebd-65e4-4f18-a28d-30fab3441ec9
060ff518-0b92-4a23-8b14-a53e5d45d5b1
103b738b-104b-4e0c-9331-6b0cae944943
d3b78492-0db6-415b-a406-b3fcb4d9a3ac
5bb00ffc-b25e-487d-a336-aa5b07b778ec
7615c83e-de9f-4751-80d3-b8a8ffbc41cd
aedad30e-a19a-468a-9f45-22219de85513
551fa807-a0c5-4594-8861-b4b6f6f6d82e
8eebc70a-4b00-4482-b947-0c5e7294aae0
5690cd4e-8606-4c7e-ab6d-078223839687
8b34f2e0-5993-4256-9619-3c691d85be98
99df2191-1118-4f68-9ebe-0c08df306d89
c571a8dc-0d71-42e2-9b92-2b2ef5675ade
861af420-dd5d-497c-83d4-f06ebcfc9528
8080f669-d4f0-4f53-a855-35d5dc39c564
7ec15392-187a-4bff-be44-4a77a0735d92
463c2ddb-cbf5-4d22-b65a-88c79d578ac7
5ee61fad-2de8-4f98-834b-c327dfed413c
a4d10708-6a03-4a32-9b2f-245adb6b6240
28194931-611a-42cc-89c7-b133dc63c893
765a25ac-1a70-4bae-96b7-e593fe0caa6e
3bc2d4e3-6c4f-4e12-98c7-89b38012246f
d2550a87-9f59-4d60-aca3-bd9b955bfa4d
7612424e-b29d-4a55-b8de-61f3ac6bfb59
28f1a24a-b6ea-4b76-bba7-6779f81b14fe
416198eb-e102-4842-9bcc-a60fdcb450d7
93182026-e06b-4654-950f-39cc4aa0180f
a5bae5f3-528a-48f5-9a62-1d9f45445a95
1f55e71a-6121-4374-baf3-3f6e8881131a
a15549c9-dd49-4ae1-a01b-5506f097c6ca
ab12cb79-aac2-414b-9946-6a754548e110
90378b0b-c426-4551-a9f9-800896dbf44e
05387bb7-4eb6-49e7-9061-6b7c2c6bb446
a4765167-b5ef-478c-a067-cd5dbcd6aceb
56ac04cc-163d-4316-a0e3-a09dab85594d
efd3ec50-5afd-4a3f-ade0-387c995fa513
98287454-b304-41d2-882c-9bf97d30f141
98667b07-a1fd-4b74-ba08-933c0d63c1d0
b1f9e084-1af0-4671-a7a6-29f55d92e4e5
d6834eae-2c8a-4ff3-85b8-022bdee1d3dd
a3226bcc-9f1c-4216-9d44-8f1dcb06288b
c85acf18-4bc6-49d8-aeb1-9ac4b2666956
75885d51-2fb0-4968-a3de-fe0c53eceb6b
fa813a90-86ff-4f16-8639-424d9db60bf7
67d54727-eeb4-4daa-8c41-40fd40134cad
6bb85bb3-b2a7-4cfc-8fe5-eda2707287b4
5727043c-4c89-4e29-a594-6b8fe56ad3f7
bf28708a-d254-4e0b-9189-a5704d83d883
c54373cb-b02d-4935-add5-f3c17ae29223
1c879e87-ef55-4420-9fff-a0d9ef52a1c2
c80bc66c-a22e-43ae-8149-4fb687e2aad1
1948e980-ac90-4c67-9d57-375b10c0978a
fd7979d1-2f9d-43c1-921b-16286ad57b19
351126ff-3ed8-4ee6-bb98-54a08e436331
4efe5ddd-8bc9-43b6-a95d-bfedee710730
9213adb3-98f4-4d42-b36f-a044402c752a
2b63d710-d77a-46ed-a02d-8f12284d093d
b1c7cc22-a459-4f55-99cc-98fc7e9829cd
910a3078-9fba-457e-a3d2-5a8a42a4a59b
b46e66b6-fef8-4551-844b-f48b51f18887
9df5ca2c-3147-401a-9d3c-1638a6f02ad0
510ef6ac-d964-4857-81e9-85a00e00dc51
6c09d5c6-7db2-4d59-a23c-a0cff7ea31da
fa9b00c5-369d-4db7-bec8-45627225438d
09d7f4dc-8fce-43c0-b778-0df584c2739f
c6f291c2-9995-454e-a838-cb645ec2de77
50e510a9-0bdb-4a55-b55f-dc37ea43633a
3e935853-f1c6-47a7-9e22-2a457109ee60
70511c74-d0ea-42c8-8bbf-f8446f544022
7f76cd2d-725a-479d-999f-6581b07371ac
90c56da0-ae13-4f05-aa67-be54c7bad83a
d43aa0c1-4c5f-4c36-bf52-1df23a753b59
65dac126-89fc-463c-ba18-63d827a920c5
e8aa370e-19da-4d55-bb48-c53fff30c7b2
907454e2-0671-4ddf-9725-3509a9c3a454
1633cc84-63f4-4adf-986b-7da47de84bad
a1e46639-3086-442e-a8ea-efcc9193e674
d450501d-bb9e-4ec6-9691-e27f33bba466
75c62285-d1bb-4897-a31f-230c5115c6c5
1b6078c0-fb54-4ff6-b526-890bb95184a1
6a68fb46-a034-4129-b96e-b8d5209945cb
d889cbef-ad65-49c8-a2e7-835a8262d9bc
b7cc4d08-a40f-4400-bca5-3039f8c965b3
50ffad89-623b-41e4-986a-c3a2feaade8c
ddbfcf61-6825-46a0-afe5-f307b4bdefe9
3d527afd-cb44-4f63-ae6a-cd9ccee96f11
24fb983c-62fc-41d7-9a45-45bf55a5359c
35120e12-4729-4a25-a25b-572399403a63
4afdf8ac-bf2a-4d7d-9020-24aaa7344ce7
ed4b6780-5f7d-429f-beab-eb44e6170bc9
ad33886e-87fb-4206-a2de-6feb2995e006
e67500f7-2f48-4894-816e-bd8d52c46382
b683a946-16af-4acd-a050-17decd4bd085
4658a0b2-50e4-444a-b4ac-e4d6d7aa559c
e5e4b3e2-45fe-4ff9-8766-bee1f235ad36
dbcfe7c2-b2ab-4cef-a7e2-1574b7387410
8a5f262f-0da7-41bc-82ad-8f7eb1609617
1446271c-d93d-42dc-a7ba-a6ca384b4448
9496fe87-9539-44d1-8ca3-4d62c300194d
df71148b-a7aa-4c7f-9496-b0eaee0aae6f
f927872e-3dba-4482-af19-719b731d7fea
bc954f78-c223-4b19-ad6c-059227740671
b6a93f95-1b06-48ac-8422-c0ff627bc780
2966e974-c340-4197-94de-d6815d41bf0d
d2fd6cdc-efbe-47ba-bb06-06971d06d11b
0ee257a7-150e-4396-9c23-4d155ead67d5
2715b220-a689-4384-89a8-78efb69abf3b
069756ac-ffb4-41f5-b33c-d90e382e79b4
d5ab3c0f-e4fb-4d5d-80bb-f66751da4850
f3688f7e-ed1a-43e0-ad17-6f3638d64723
0b1f1831-2e41-4c59-af71-5f537a9a1a22
29eef076-48c8-40af-b18c-7bcac3baa316
de0009cf-13b5-4649-86fe-90fc9eec3b30
8c007dd9-ff34-4051-a72a-3e9cce0c5c8f
b9bc2a0e-639a-4587-9f6d-42fec43ffd82
1d3c4bdf-7b01-4175-9d09-1698499c29c5
0a7a2874-2f9d-477f-9044-465aae71afcd
9dd6b47b-f9b5-47e0-8ad0-0012c5c9ef2f
1c7b63c0-8006-4d71-a70b-1a59ce3ba62f
2962c64d-2d70-40c7-99d0-c09489937317
0d867733-f5ce-4f36-af20-f3f1359c3240
20d44fc9-5933-4c33-8e9b-22fa73c0e866
51f5e325-d8b5-41f3-b208-8271808ecf72
d1483857-e58d-4d41-9d56-e70a642ca5f8
5465b2d4-cc89-4a55-bf57-b27704f9d683
6466da00-ee69-4ea7-a7b4-3bbdbbf104ae
f332b151-98c1-4e28-b87e-bed0d9bf17e8
d755ed7e-018c-4209-ae5c-a485a3172ccb
20138169-8e01-4926-aeae-04135b3706eb
e85ea3c1-9d09-4c0e-aaa8-33aca608cbb5
c05c05d3-d9ac-4896-8ed1-46ac985ae51c
e61f61ed-6bf9-4e74-91be-f0bdf50bc671
1386b2cc-40f2-4213-a6d2-8d3ab04ba6bc
edc044e1-bae6-4e22-b2a6-5ac50f8576c6
c9cd3978-6216-4983-b67e-5d697ec20b81
87bf956f-41be-46d9-a741-f304c8165e94
7e111fd6-e95d-46fa-8e6a-fc112f2c3468
5bcae71d-2a79-4652-a04c-c9bf08923201
d2f5671b-6c52-4952-ba85-c3a87bf72a97
e3f4ba1b-0b3f-477f-9785-2c45c1cc53e4
ec87a684-65b5-4c2e-9ec0-df33773c4e5b
a96c12d6-537a-46d9-9b12-5e6e3841afea
a933e90f-022f-487e-bb25-c1e3f9de5e6c
fa0c8a49-a6bf-4d87-805d-5233c36c82ea
4bfa33a5-6844-4768-a282-9dac09cd5770
a0c1ee92-b2b4-4f58-adae-4a8101e93aa7
6435afc7-5bfc-43d1-a557-286efaaf8ed4
e15414f8-b998-4844-a3e6-fd616616a97d
a9e375db-ed27-49a4-ab37-1f71e3344c07
d97e2d78-7a2c-413d-9749-2c004d3f95a9
7a3e90a0-98d3-431e-9432-1ede8f95757f
65aff6e2-e01f-4ea7-b76a-854578347fce
7f9c8b1b-3a70-4b8b-8900-c6d095e1db00
f1228c2e-1e8e-4e61-b4ce-a569f98cc534
b4c46f03-496f-42a2-98f7-6739e324de11
fec6cee0-40ae-40ab-8b42-b2adf77d55a4
61cec1fe-92dd-4e5f-8cb0-cd838ac093f0
d7ff7622-8d60-4892-9132-d44c6321e8a6
7009fa9d-a02c-4910-a62f-5c3f2b8f28a2
3371e717-1768-4f52-8eee-3ff331e3d90e
f2d20e8d-cc45-4737-a1f8-6dc97d45f981
253193d7-2a6f-4636-9ebc-08c8cc1723ac
202142cf-284f-499e-95a9-5ebb2522750a
beb1e339-b679-44de-be95-b17bb1255c7a
0fbb9e34-4b32-409d-a301-6a4a5e5a9ee4
e21ca461-7f92-4cc7-8b99-9779c76e351a
534ec073-e464-4149-bf28-5cf8ad4baa5d
428163a7-e57d-4b39-a5b8-9fd69dc65567
34cefcb9-0d95-4de6-938f-9217bcc9399b
380e731b-2df3-4f9e-84d0-16ffb0010e66
cea631f7-6753-416e-a6f1-83b25760bf3a
c2fe3a86-8006-4f44-ad3a-9689e269a3c3
01abe899-e6b3-49d1-87b3-08a163471785
d03bfdfd-3c94-4b1d-8abd-b78d465c5daa
01ac3eb0-7858-420b-9131-19cf28abf13e
2c23936e-e138-4502-8ec3-e8c71bb851b1
0a2460c5-e7b6-4e59-8342-35dd4514da7c
e1ae23f4-c9da-4c10-b7e2-8a3dc83982d2
\.


--
-- Data for Name: eperson; Type: TABLE DATA; Schema: public; Owner: funasauser
--

COPY public.eperson (eperson_id, email, password, can_log_in, require_certificate, self_registered, last_active, sub_frequency, netid, salt, digest_algorithm, uuid) FROM stdin;
\N	britofa@paho.org	6d31c8e1e6ae13c43168fc1d2c7ff7d67b17de7c74ee44a66e8f464d2f5d550f95c7b2d7e2bac47f657cb050fe28c150f8b8975340c5839365ff1c278f48baed	t	f	f	2019-10-29 13:11:40.036	\N	\N	9abf3280b85e220adb683b3e32b82c0f	SHA-512	28194931-611a-42cc-89c7-b133dc63c893
\N	marcosasalmeida73@gmail.com	d0e9cb4b59f7d4ec687bde24c3870a4b2fd8873d9a5795510450ac76a2163671c8d5ffa60ac450c30970a931cc09e2828650908663a30c7f1ac13bf5fc525ecb	t	f	f	2019-10-29 14:06:40.814	\N	\N	47adf4678d4890e85f898cfa147f2d7f	SHA-512	e1ae23f4-c9da-4c10-b7e2-8a3dc83982d2
\N	emarmonti@siu.edu.ar	\N	t	f	f	\N	\N	\N	\N	\N	8080f669-d4f0-4f53-a855-35d5dc39c564
\N	emarmonti@hotmail.com	\N	t	f	f	\N	\N	\N	\N	\N	7ec15392-187a-4bff-be44-4a77a0735d92
\N	murasaki@paho.org	faaab13f8b5514358c7ec82e0997601eb2a910069b2a2174d03197c4766aadb39bbefe96c39c7733391dfc77079cde6d0f7f027a025d867fa3888bbda1115a6f	t	f	f	2019-04-23 16:04:17.246	\N	\N	75e27b1ef63782f6581ab60f137db5e2	SHA-512	a4d10708-6a03-4a32-9b2f-245adb6b6240
\N	morimarc@paho.org	166103aaaf1395aafdacd5be1ee13b91bfd4d6444ff4a1d968f3bb38728e78f773b8fdde3ce9a38d2f23c2a237f6d0438c8f91f05fb2098c9e40a8fec366b7bb	t	f	f	2019-02-22 16:45:49.472	\N	\N	cf41d53a61d8347d7574ea041ec1f226	SHA-512	765a25ac-1a70-4bae-96b7-e593fe0caa6e
\N	test@bvsalud.org	0a15c805455429b0253cb0c8aab7feb0727a88af6ddad8b5ac0568c774de6729d80b1f7398da0877c022cf447df0bc43087d32cd920571a94a5c0abc08498c16	t	f	f	2019-02-19 07:56:34.776	\N	\N	8e417e262cf2df6b318ac737e3c42665	SHA-512	463c2ddb-cbf5-4d22-b65a-88c79d578ac7
\N	falbrito@hotmail.com	\N	t	f	f	\N	\N	\N	\N	\N	0d867733-f5ce-4f36-af20-f3f1359c3240
\N	isabella@agenciawebnauta.com	d6c77321617e190593d752262720774b24c58f2d35c7d8057470a2d45a32189d75f2dd521e282871555a358743a4c8f3324ffe61511daa05ceb84b16fbb8c0a7	t	f	f	2019-10-08 16:08:55.851	\N	\N	39270c1335fdd4845c761dcc34134834	SHA-512	51f5e325-d8b5-41f3-b208-8271808ecf72
\N	suellen.silva@funasa.gov.br	2bceb5bfdbe38b5dc836b8ff779bb852eeff7210783826255d614dc16dc4514a85afec7ac4348819ba990b8e34352c713c47932ba8d55bad7261062197a14f07	t	f	f	2019-10-29 11:32:12.524	\N	\N	2635a2c8c1f1f446327b7501968d649a	SHA-512	5ee61fad-2de8-4f98-834b-c327dfed413c
\N	emarmonti@gmail.com	3e30e8840b4010d0a5dce8c7f536d1545f11771259ad59ba8869b913059aac3b98041e7764f2b56b3ff56957eba4cda4b90ddc0f2e06713c814a9a32c0c13356	t	f	f	2019-10-29 12:37:18.618	\N	\N	2c343351abcdb3636c83d722d7fd51bb	SHA-512	cd410caa-8ed0-4822-8722-8eab234a8b4c
\.


--
-- Data for Name: epersongroup; Type: TABLE DATA; Schema: public; Owner: funasauser
--

COPY public.epersongroup (eperson_group_id, uuid, permanent, name) FROM stdin;
\N	582e3083-b833-4022-a81e-04220f4eca76	t	Anonymous
\N	2749c445-d9b3-4641-bbd5-c292cbc31c3e	t	Administrator
\N	20d44fc9-5933-4c33-8e9b-22fa73c0e866	f	Catalogadores
\N	9e6cee53-8569-420a-9e75-d704e5f3517c	f	COLLECTION_6ef94e51-16d7-4cec-9359-a94d499e8337_SUBMIT
\N	609ddd28-e6f3-41a2-a670-e0c2776bcca7	f	COLLECTION_c087e9be-29f7-437f-b0da-bddb0b2ab183_SUBMIT
\.


--
-- Data for Name: epersongroup2eperson; Type: TABLE DATA; Schema: public; Owner: funasauser
--

COPY public.epersongroup2eperson (eperson_group_id, eperson_id) FROM stdin;
20d44fc9-5933-4c33-8e9b-22fa73c0e866	51f5e325-d8b5-41f3-b208-8271808ecf72
2749c445-d9b3-4641-bbd5-c292cbc31c3e	463c2ddb-cbf5-4d22-b65a-88c79d578ac7
2749c445-d9b3-4641-bbd5-c292cbc31c3e	cd410caa-8ed0-4822-8722-8eab234a8b4c
2749c445-d9b3-4641-bbd5-c292cbc31c3e	5ee61fad-2de8-4f98-834b-c327dfed413c
2749c445-d9b3-4641-bbd5-c292cbc31c3e	765a25ac-1a70-4bae-96b7-e593fe0caa6e
2749c445-d9b3-4641-bbd5-c292cbc31c3e	a4d10708-6a03-4a32-9b2f-245adb6b6240
2749c445-d9b3-4641-bbd5-c292cbc31c3e	28194931-611a-42cc-89c7-b133dc63c893
2749c445-d9b3-4641-bbd5-c292cbc31c3e	e1ae23f4-c9da-4c10-b7e2-8a3dc83982d2
\.


--
-- Data for Name: epersongroup2workspaceitem; Type: TABLE DATA; Schema: public; Owner: funasauser
--

COPY public.epersongroup2workspaceitem (workspace_item_id, eperson_group_id) FROM stdin;
\.


--
-- Data for Name: fileextension; Type: TABLE DATA; Schema: public; Owner: funasauser
--

COPY public.fileextension (file_extension_id, bitstream_format_id, extension) FROM stdin;
1	4	pdf
2	5	xml
3	6	txt
4	6	asc
5	7	htm
6	7	html
7	8	css
8	9	doc
9	10	docx
10	11	ppt
11	12	pptx
12	13	xls
13	14	xlsx
14	16	jpeg
15	16	jpg
16	17	gif
17	18	png
18	19	tiff
19	19	tif
20	20	aiff
21	20	aif
22	20	aifc
23	21	au
24	21	snd
25	22	wav
26	23	mpeg
27	23	mpg
28	23	mpe
29	24	rtf
30	25	vsd
31	26	fm
32	27	bmp
33	28	psd
34	28	pdd
35	29	ps
36	29	eps
37	29	ai
38	30	mov
39	30	qt
40	31	mpa
41	31	abs
42	31	mpega
43	32	mpp
44	32	mpx
45	32	mpd
46	33	ma
47	34	latex
48	35	tex
49	36	dvi
50	37	sgm
51	37	sgml
52	38	wpd
53	39	ra
54	39	ram
55	40	pcd
56	41	odt
57	42	ott
58	43	oth
59	44	odm
60	45	odg
61	46	otg
62	47	odp
63	48	otp
64	49	ods
65	50	ots
66	51	odc
67	52	odf
68	53	odb
69	54	odi
70	55	oxt
71	56	sxw
72	57	stw
73	58	sxc
74	59	stc
75	60	sxd
76	61	std
77	62	sxi
78	63	sti
79	64	sxg
80	65	sxm
81	66	sdw
82	67	sgl
83	68	sdc
84	69	sda
85	70	sdd
86	71	sdp
87	72	smf
88	73	sds
89	74	sdm
90	75	rdf
91	76	epub
\.


--
-- Name: fileextension_seq; Type: SEQUENCE SET; Schema: public; Owner: funasauser
--

SELECT pg_catalog.setval('public.fileextension_seq', 91, true);


--
-- Data for Name: group2group; Type: TABLE DATA; Schema: public; Owner: funasauser
--

COPY public.group2group (parent_id, child_id) FROM stdin;
9e6cee53-8569-420a-9e75-d704e5f3517c	20d44fc9-5933-4c33-8e9b-22fa73c0e866
\.


--
-- Data for Name: group2groupcache; Type: TABLE DATA; Schema: public; Owner: funasauser
--

COPY public.group2groupcache (parent_id, child_id) FROM stdin;
9e6cee53-8569-420a-9e75-d704e5f3517c	20d44fc9-5933-4c33-8e9b-22fa73c0e866
\.


--
-- Data for Name: handle; Type: TABLE DATA; Schema: public; Owner: funasauser
--

COPY public.handle (handle_id, handle, resource_type_id, resource_legacy_id, resource_id) FROM stdin;
2	123456789/1	4	\N	\N
1	123456789/0	5	\N	44f60f35-fb87-4dd7-98cc-eb861476c8b0
355	123456789/354	2	\N	1f0c95ab-3775-4094-b293-183d3b5074b2
3	123456789/2	4	\N	ea38e67d-c827-487c-b429-13be16d4a6c5
4	123456789/3	4	\N	0c873029-343e-4740-bd26-c976c9b2c6c2
359	123456789/358	2	\N	b1c7cc22-a459-4f55-99cc-98fc7e9829cd
5	123456789/4	4	\N	1f757c54-5850-4cbe-ae02-284cfaccc1e7
6	123456789/5	3	\N	afd22d8d-4201-4482-888c-c06b85307651
360	123456789/359	2	\N	510ef6ac-d964-4857-81e9-85a00e00dc51
7	123456789/6	3	\N	4b0ebee1-3f02-43c5-bdac-923b17a459bb
8	123456789/7	3	\N	240b86fb-057a-4098-b4a9-16362bd4d88e
377	123456789/376	2	\N	1446271c-d93d-42dc-a7ba-a6ca384b4448
9	123456789/8	3	\N	f02c8749-274c-4492-ba7b-cc33c3b8db61
10	123456789/9	3	\N	28df2a70-de20-4c58-a5c8-e3c24e688cee
385	123456789/384	2	\N	380e731b-2df3-4f9e-84d0-16ffb0010e66
11	123456789/10	4	\N	e8be30cd-3daa-4118-8548-8731d7495020
12	123456789/11	3	\N	19737605-9de5-494c-b19e-7118aa37b963
13	123456789/12	3	\N	f5a61cfd-721a-4eba-bf4f-4fa931159f12
14	123456789/13	3	\N	bf82b5db-01cb-402c-81a9-8249ff7395a6
15	123456789/14	3	\N	2aa863cf-c22a-4dae-8aed-2f08b702420a
16	123456789/15	3	\N	d72bd580-c8d7-46af-ad71-ee7a50bbd582
17	123456789/16	4	\N	b09f6eb0-f79f-489a-a7e8-bb87486bc1b2
18	123456789/17	3	\N	0607dd1b-5468-48ef-8905-8d07d253d1f7
19	123456789/18	3	\N	d52095c9-d548-4f66-9dad-d84f4928ded7
20	123456789/19	3	\N	f805ab68-cf57-431a-affc-8ce7f9778fe7
21	123456789/20	3	\N	5f662caf-e96c-432e-8137-a17afe17283b
22	123456789/21	3	\N	fc9b46f8-dd31-4298-9f47-73af77f1c56d
23	123456789/22	4	\N	e13aa597-d0ce-44df-a774-e65c5b8ce61c
24	123456789/23	4	\N	62cb0c79-b578-470b-9e81-6a712fea7281
25	123456789/24	3	\N	c32fae4a-fdfa-4498-a50a-bc9285fbb3a0
26	123456789/25	3	\N	8f327435-da4d-4bbe-99f2-df602eddf8fb
27	123456789/26	3	\N	b73c9ead-ff11-4e99-bcd0-86186ccd10aa
28	123456789/27	3	\N	fd415204-97cc-4568-938b-467f663aab73
29	123456789/28	3	\N	19cefe3e-817f-4584-8647-e1e0345ca422
30	123456789/29	4	\N	050033bb-42bb-4d2e-be49-3bb13979f6b3
31	123456789/30	4	\N	bf24224f-e566-4c37-a5f1-27a1867114e6
32	123456789/31	3	\N	3bf97251-0d2c-497a-b1c0-2fb8f089d5d9
33	123456789/32	3	\N	24a1c3ff-d7a4-4e39-92ca-bbbd1ef02a13
34	123456789/33	3	\N	60f00aaf-c385-4dcb-b9a4-ed59d23e3feb
35	123456789/34	3	\N	2a26db78-5987-40be-b908-a20da0086e8b
36	123456789/35	3	\N	4e7863f5-b198-47e4-8eb1-688af9155b78
37	123456789/36	4	\N	ca5ff7d4-3470-4ef2-90ca-dc563214be58
38	123456789/37	3	\N	b85655ce-7a32-438b-9211-a8b12ec6dcfd
39	123456789/38	3	\N	33d85721-7ff3-4926-ae80-084bb178dd97
40	123456789/39	3	\N	9a582dff-81aa-4021-9f30-f75871aeb9eb
41	123456789/40	3	\N	681bb445-6fc8-49c1-9915-1d418f2ac4d1
42	123456789/41	3	\N	96f9e582-cb6e-441e-a361-97f5e69b8ff2
43	123456789/42	4	\N	7a290d59-1bed-4a4f-a6a1-02e191774a8f
44	123456789/43	3	\N	88d41f3a-a149-4dc5-81a2-84380835533a
45	123456789/44	3	\N	41b5c503-8ca0-435f-8103-3e692593b755
46	123456789/45	3	\N	728d1b2f-f32f-4ba9-80ff-922deca5458b
47	123456789/46	3	\N	a2561e5d-7cbf-464d-b6e6-6178bddd9bae
48	123456789/47	3	\N	25c745b0-5b75-44bd-91fb-f468f52c377b
49	123456789/48	4	\N	6c5dd78a-94ba-4ba9-ba37-401a80442dd5
50	123456789/49	3	\N	357da42e-ffb4-43f7-bb59-3b66f6d09b1f
51	123456789/50	3	\N	8a52ac60-0cb5-4d6f-8b4c-a9cd65b62d0a
52	123456789/51	3	\N	d851294f-191c-46a0-abf4-d338042d5971
53	123456789/52	3	\N	fbe5350a-c8ba-4a39-98e2-bd742a6be202
54	123456789/53	3	\N	3afa7efe-2891-4c47-b396-c83d56ff9d90
55	123456789/54	4	\N	683bfc83-3cc1-4f22-83d3-c9ee4ea2c82b
56	123456789/55	4	\N	435bcf56-d368-4f2f-8e7f-4bafd3367063
57	123456789/56	4	\N	f0cb7fe8-e5c5-4d33-9530-b38f96535074
58	123456789/57	3	\N	c087e9be-29f7-437f-b0da-bddb0b2ab183
59	123456789/58	3	\N	f2c7e15a-2db1-4099-9d26-78ba2c16b8da
60	123456789/59	3	\N	cd75101b-abb6-46ef-ac88-3af552f33478
61	123456789/60	3	\N	b55202c0-1e3b-4eba-909d-54f7fad48b9c
62	123456789/61	3	\N	6ef94e51-16d7-4cec-9359-a94d499e8337
63	123456789/62	4	\N	342ea849-01c8-41cd-b812-44638b5c22ef
64	123456789/63	3	\N	411dd125-33df-451a-87c9-7dca418b665e
65	123456789/64	3	\N	7db66edb-3f9f-4c24-8fa2-0a4b11efb0b8
66	123456789/65	3	\N	b2020a23-0063-4efe-b770-9c9a5a099b42
67	123456789/66	3	\N	6a8d7523-aace-4c61-9a7f-9133ae72d7b0
68	123456789/67	3	\N	3449a99e-7799-4ba0-bd51-63ae8ee23093
69	123456789/68	4	\N	e88afa75-f030-4a94-8c91-72257614e295
70	123456789/69	3	\N	1e0e772a-32a3-4fef-99c9-2aeab683bae2
71	123456789/70	3	\N	909a8161-d474-4b0e-afdc-5a5ae63c3a6c
72	123456789/71	3	\N	f6ed7993-8237-4ef0-9cc4-0573e90e75d2
73	123456789/72	3	\N	66151470-c472-418e-a958-e93c235b10e4
74	123456789/73	3	\N	d46da801-96a5-42ca-90a0-0ed42a484f3b
75	123456789/74	4	\N	7709d357-75c7-4039-bfcf-f2297e7493e9
76	123456789/75	4	\N	e43ea389-e3e6-410b-bbc3-75bce3a6474f
77	123456789/76	3	\N	f3152358-78b0-495c-8086-12b8a7a6e7c4
78	123456789/77	3	\N	87416815-8bb9-42a5-98eb-5aefce3bfbcf
79	123456789/78	3	\N	24b8f080-dac2-454c-aba3-16201b523039
80	123456789/79	3	\N	e666ae2f-259c-4fff-8884-df1c6401bbf9
356	123456789/355	2	\N	b37744b2-292c-4937-a401-9243b80980b3
81	123456789/80	3	\N	289a3f50-e20c-442b-b1af-a6dc0e973bd5
82	123456789/81	4	\N	08285b26-0b55-48c0-aae2-bd4c60dece4b
361	123456789/360	2	\N	09d7f4dc-8fce-43c0-b778-0df584c2739f
83	123456789/82	3	\N	efa858af-f6b2-44c4-abf0-e469f1353d10
84	123456789/83	3	\N	1ba431f3-259a-4751-9ae9-22d5a110ae53
378	123456789/377	2	\N	3bc2d4e3-6c4f-4e12-98c7-89b38012246f
85	123456789/84	3	\N	3011dd24-c2db-46ef-b5d1-895e38d9b930
86	123456789/85	3	\N	110adbb2-e44d-4c83-80e6-d404b4741ed4
87	123456789/86	3	\N	9683b122-799f-4d4e-92b8-8f57283e964f
88	123456789/87	4	\N	6805171d-b16f-46e4-b7a1-2d91aafb9037
89	123456789/88	4	\N	043d9a3f-684c-4fc2-a642-4df251ff0ce6
90	123456789/89	3	\N	995b6a10-b9dc-4f43-bd81-b6249cd8b191
91	123456789/90	3	\N	617031b7-af6b-4fa3-9644-dc5ade438caf
92	123456789/91	3	\N	5b1045d7-6c9e-4446-ae09-6831ea31e1cc
93	123456789/92	3	\N	0a4d3518-c6fa-4a84-bec3-453eafd845b7
94	123456789/93	3	\N	c513be3f-2789-46b7-bc33-0feea0e7e628
95	123456789/94	4	\N	54def7e9-b01c-4405-831b-f55d391bc8db
96	123456789/95	3	\N	5539833b-6142-452e-bea3-fc373b058c14
97	123456789/96	3	\N	ef2b53fa-b6fb-4962-a523-53ff8c1e65fa
98	123456789/97	3	\N	701fb3d8-8ea8-43b9-ad0a-27e0a053f41f
99	123456789/98	3	\N	82ad2994-8a8a-4734-8924-089e49902749
100	123456789/99	3	\N	3004c43c-f694-4d5d-bc56-d89e562d8810
101	123456789/100	4	\N	0122bff8-45c5-4403-9af8-4d92e63bf462
102	123456789/101	3	\N	2255af62-ea0f-441e-8cef-c95a842d0c8f
103	123456789/102	3	\N	5f35338b-62e5-48be-9737-7ec419eb9fc9
104	123456789/103	3	\N	beaabaf0-bfc2-411f-9a6d-e6135d699097
105	123456789/104	3	\N	ee0feefe-84c4-4d99-b69c-06445074d7ff
106	123456789/105	3	\N	1f9d14c8-64db-41c2-9867-9641e5d112b1
107	123456789/106	4	\N	c338e24b-54ce-439e-80fb-6aea64047d8c
108	123456789/107	4	\N	58411222-09a0-4a4c-a0aa-a16fed8c8057
109	123456789/108	3	\N	4ee1cee2-a251-4b2d-9205-e12ad4a8499a
110	123456789/109	3	\N	8380299d-ae45-4b0b-bab1-3f2769dfdca8
111	123456789/110	3	\N	f4897015-28c0-46b4-9b1c-0312bbe14f19
112	123456789/111	3	\N	cf051540-fc52-47a6-9247-7cca3089b0d2
113	123456789/112	3	\N	0f8aee5b-53cc-46b2-af21-4b7fea33f4a8
114	123456789/113	4	\N	131515f5-0c56-4276-94dd-054d41a4f959
115	123456789/114	3	\N	2db4aa27-37b4-454e-86d1-24dd3185a968
116	123456789/115	3	\N	6fbf8d40-a83f-4977-bf0f-2fbdc397a975
117	123456789/116	3	\N	7e531fe1-bf4a-4d2e-a697-b8ccaf587377
118	123456789/117	3	\N	e6dd595d-9bc9-4ec0-a594-1e9c8d541133
119	123456789/118	3	\N	f8f0c20b-e38b-47ee-8788-2c675649e67c
120	123456789/119	4	\N	265b2c85-db13-4fe1-ab54-4134f76d252b
121	123456789/120	3	\N	4e77e1c7-3c74-4ced-ba10-bad97ecd405d
122	123456789/121	3	\N	3bbcfa02-d7d2-4733-9f3d-45ad29a8117a
123	123456789/122	3	\N	cd65d599-6ac3-470c-9eb6-75f9aed99357
124	123456789/123	3	\N	9f225cd4-4db1-4fb2-b976-ea4e9ae18656
125	123456789/124	3	\N	f2af2366-3fec-449c-9571-fe170605a28e
126	123456789/125	4	\N	777e1210-3ec0-459a-aca6-29b715063e73
127	123456789/126	3	\N	ea7f0fea-6dd7-4907-beef-d60d62f7a0d9
128	123456789/127	3	\N	79f9afe4-97a6-42a4-a906-f80f360ad656
129	123456789/128	3	\N	828c145d-a069-48d4-857b-9ee667d38c68
130	123456789/129	3	\N	ac22c96b-12db-4e4a-82c9-63e1c5af3de3
131	123456789/130	3	\N	f68dd0f4-475b-4b2d-9cd1-8236b29ff7b4
132	123456789/131	4	\N	6599bbd5-7809-439a-85d2-dd0c607838cc
133	123456789/132	3	\N	8742eb33-87b7-4f31-8ed8-be8788d16368
134	123456789/133	3	\N	048560cc-de2b-4693-969c-61d493365d18
135	123456789/134	3	\N	bb4c6911-03b5-480e-819e-6a760460e9a1
136	123456789/135	3	\N	893f8288-3bfe-4656-9c84-4fbb6f695849
137	123456789/136	3	\N	2f7c5598-12bd-41ee-a1f4-625b8d93f2ef
138	123456789/137	4	\N	f7af0744-1ec4-437f-88db-205b9666f652
139	123456789/138	4	\N	4de09263-c707-4a67-b45a-f9de6a6edac0
140	123456789/139	4	\N	7590066c-de6e-4a65-9565-25e1bd3b87f6
141	123456789/140	3	\N	90601c90-b68b-4ea2-8b12-e13ccc6eb0e5
142	123456789/141	3	\N	673a6a9d-1cdd-4613-ac3b-1814c8831656
143	123456789/142	3	\N	f9de8b0b-92ab-4726-9a25-387f0a8d2720
144	123456789/143	3	\N	9611172c-b2e0-4bfa-8f3c-57d9f82bb480
145	123456789/144	3	\N	22b91317-4740-4caa-bb89-5a45c9c311f3
146	123456789/145	4	\N	01bf637b-7e76-4610-88b6-b85270d50e0c
147	123456789/146	3	\N	645f03ae-c3bd-4ff3-94c3-31acc342036c
148	123456789/147	3	\N	4f1937a8-4952-4ad7-8517-a3b777ef3ed7
149	123456789/148	3	\N	9c1f759e-1c23-443e-b601-dd4b5a867d98
150	123456789/149	3	\N	eb746f42-f39e-484c-8ad7-51b355b7f227
151	123456789/150	3	\N	a6ba185b-3885-4be2-9bb5-dc61de428543
152	123456789/151	4	\N	927e147b-5d98-4bc8-be35-941cdaf90018
153	123456789/152	3	\N	c5d79dda-0dfe-4acb-ba9b-b9850715b7f5
154	123456789/153	3	\N	a44d06ae-fd12-4b30-b17e-24944c917470
155	123456789/154	3	\N	f38cddca-d777-4d6b-b104-867d27969d2a
156	123456789/155	3	\N	48de73ab-3a92-4c08-a1ae-4c7cf43e8341
157	123456789/156	3	\N	a89ae057-da72-458a-8b54-c2c01c59633e
158	123456789/157	4	\N	1f1e123d-71ba-45d8-a436-9866334f6679
159	123456789/158	4	\N	4a04d20c-9629-456f-a426-cc82d587d3cb
357	123456789/356	2	\N	25cb38d4-142c-4282-a4cc-b7be4e8f363b
160	123456789/159	3	\N	b824b5fd-76a7-4fd8-87a3-6d2942b62eb0
161	123456789/160	3	\N	40a29a62-25aa-491f-8791-ec96017b4e12
362	123456789/361	3	\N	3e935853-f1c6-47a7-9e22-2a457109ee60
162	123456789/161	3	\N	79922945-f438-4446-bc33-6565320adebf
163	123456789/162	3	\N	63035ee2-cc1c-4302-9d66-ebf6901744a4
363	123456789/362	3	\N	70511c74-d0ea-42c8-8bbf-f8446f544022
164	123456789/163	3	\N	c1a15047-56a4-43bf-aaf6-fd0e6477f98f
165	123456789/164	4	\N	fa19502e-672d-4ce0-b465-111ab855321a
364	123456789/363	3	\N	7f76cd2d-725a-479d-999f-6581b07371ac
166	123456789/165	3	\N	70366e28-2101-47c1-abc4-3711331158f2
167	123456789/166	3	\N	4a253056-b197-44af-b8e6-13f826ad9a22
365	123456789/364	3	\N	90c56da0-ae13-4f05-aa67-be54c7bad83a
168	123456789/167	3	\N	d3b46df8-f992-4cc2-824c-1efbbd369775
169	123456789/168	3	\N	5eff5609-7edc-4d4f-98d3-a7a561862a93
366	123456789/365	3	\N	d43aa0c1-4c5f-4c36-bf52-1df23a753b59
170	123456789/169	3	\N	fdae48ca-2993-46f9-b543-c623e2f23a28
171	123456789/170	4	\N	68c53a2c-0fd6-42a1-9c67-3387ebe11972
367	123456789/366	3	\N	65dac126-89fc-463c-ba18-63d827a920c5
172	123456789/171	4	\N	5a2d5225-d585-4549-8758-a2c186dcb42a
173	123456789/172	3	\N	8d1bb197-7f21-44c8-8b4f-1aa584dcc189
368	123456789/367	3	\N	e8aa370e-19da-4d55-bb48-c53fff30c7b2
174	123456789/173	3	\N	6a4f724e-ee9e-41c4-9418-275558f5b865
175	123456789/174	3	\N	84d45869-0e52-4f3c-8468-7419f86c5727
369	123456789/368	3	\N	907454e2-0671-4ddf-9725-3509a9c3a454
176	123456789/175	3	\N	9a4df270-972f-4ab6-9fb0-5f96e79db5da
177	123456789/176	3	\N	0daedcc9-d2b3-4833-bfe4-a0eeaee838b2
370	123456789/369	3	\N	1633cc84-63f4-4adf-986b-7da47de84bad
178	123456789/177	4	\N	e062cd7e-5965-432f-89e4-7d30ea154e87
179	123456789/178	3	\N	44560ab4-adc2-443e-a599-1a440bfc5c48
371	123456789/370	3	\N	a1e46639-3086-442e-a8ea-efcc9193e674
180	123456789/179	3	\N	640da60a-12ee-48e4-90d5-9d3609e18051
181	123456789/180	3	\N	8db9f9d0-d195-407a-923d-a0de4a20bfed
379	123456789/378	2	\N	416198eb-e102-4842-9bcc-a60fdcb450d7
182	123456789/181	3	\N	85683df6-16a7-4ded-b5fd-74f04e3b8080
183	123456789/182	3	\N	bdb6f30c-459c-48a3-ac6f-1a861a004953
184	123456789/183	4	\N	f46e680e-8e04-426a-b055-c66c18163caa
185	123456789/184	4	\N	12f102df-9e17-4bbd-8a46-6879014fd76b
186	123456789/185	3	\N	ca5e06ab-e7d9-4963-8747-67003deb6b31
187	123456789/186	3	\N	7e9ba303-9d53-4c40-90b9-4f68d86270f2
188	123456789/187	3	\N	3f84afbc-9185-4a3f-b3c9-569c3e9da89b
189	123456789/188	3	\N	0aa9ece4-f742-4c0a-8040-cdf4d8faf5b9
190	123456789/189	3	\N	f597ed21-6f76-41b8-8c1d-57f763859fad
191	123456789/190	4	\N	6ad2c279-e29e-402c-a09b-cadf0a19207f
192	123456789/191	3	\N	9c532e18-a50a-4815-bbcc-a2e5d9c2b65f
193	123456789/192	3	\N	105d0e1a-d561-459b-8322-0e985510883b
194	123456789/193	3	\N	130b1879-7c73-446f-95cb-dfa274fd8361
195	123456789/194	3	\N	0de8081c-86c1-4318-96a2-61ff4a5eafd8
196	123456789/195	3	\N	a12c7960-d301-433f-b967-55d86845070b
197	123456789/196	4	\N	a6dbaa98-ed1f-40f8-bdf9-8822d64a800d
198	123456789/197	4	\N	2c944a82-e4a1-4d58-b31e-3c96236eb34d
199	123456789/198	3	\N	3bbe59c8-460c-4879-bad9-50a6607ac8f0
200	123456789/199	3	\N	6486917f-01cd-4e4d-b606-af71d92a14fa
201	123456789/200	3	\N	9f65562a-b18b-429c-892e-5740150f30ce
202	123456789/201	3	\N	0e56849a-8a47-4e6a-a208-7af588a91310
203	123456789/202	3	\N	11c01b5a-3ef7-4298-a9da-18739a99fa62
204	123456789/203	4	\N	ae79c603-8cb2-40f8-9d07-c69363f0039a
205	123456789/204	3	\N	9bc40373-4a2a-46ff-847c-714cb460e549
206	123456789/205	3	\N	0ebec10d-4478-49ab-93f9-154d33b27b48
207	123456789/206	3	\N	bccab95d-41a0-417f-8c60-c4930d2ee64b
208	123456789/207	3	\N	de089951-60b0-4a0f-96f0-808a6dbdee71
209	123456789/208	3	\N	9945f686-7847-4d78-9b8c-154e2a2bb296
210	123456789/209	4	\N	0a540eac-23c0-4dca-9943-d006688c005b
211	123456789/210	4	\N	1b9b305d-dc05-42d2-b4b1-47e95b8cc167
212	123456789/211	3	\N	2b0ca2ad-7e28-4a9c-b0a3-63b4f4b5f427
213	123456789/212	3	\N	c63831fc-1419-470b-8f44-bdf13b06618c
214	123456789/213	3	\N	e0cb29a5-a7e7-4183-a647-59027c0c8c2e
215	123456789/214	3	\N	21f3514c-8861-4b5f-ac3f-d4b88441adcc
216	123456789/215	3	\N	95824968-09b5-45c3-a5ff-f6c8fad3cba5
217	123456789/216	4	\N	f43b5db9-d9fe-4f67-b1df-48dd4cf237af
218	123456789/217	3	\N	76a4baa0-c312-47de-abd8-38d342f5648a
219	123456789/218	3	\N	433ec679-855f-4e2e-8302-b485271cd68f
220	123456789/219	3	\N	86ccc8a7-5a8e-468d-b03c-4ce0436bc4dd
221	123456789/220	3	\N	7cf1f5ae-d764-4d10-904d-1d8052283126
222	123456789/221	3	\N	1a948c76-f0c1-42ea-8a98-090bb3c0e952
223	123456789/222	4	\N	f090f032-d9d9-4ec2-9490-16e3db96212b
224	123456789/223	3	\N	30edbd28-6241-4876-ae87-818171fb29ea
225	123456789/224	3	\N	0bfb3ac9-90de-4934-b39b-178edde5c7ef
226	123456789/225	3	\N	5b79fd4a-7656-4ddd-8860-b292b48350e6
227	123456789/226	3	\N	6ce04d42-1a73-46e1-b145-4f43f004cd70
228	123456789/227	3	\N	73c5e039-5fd5-45ca-8b42-e46dfc33d06c
229	123456789/228	4	\N	ef9c52da-c800-4fb6-8ecb-6851e26a2794
230	123456789/229	3	\N	5d2a1df2-7371-435c-b241-b3c9539b6049
231	123456789/230	3	\N	c60c6dbc-67c4-42e9-adaf-acc0c82822ac
232	123456789/231	3	\N	0ce316b3-41f3-4a74-8bfc-e0ee3cfe4000
233	123456789/232	3	\N	36ea01fe-9920-424a-a9bb-b5de23ec2c7d
234	123456789/233	3	\N	1652f904-9088-4fa5-bd63-9ff1e6efcf97
235	123456789/234	4	\N	1b279197-328f-4ff1-a8a3-60e842b4d099
236	123456789/235	3	\N	bf95d0b0-a562-4c96-9252-5b2ed9bcfb64
237	123456789/236	3	\N	7001f4bb-55d0-4a1f-bde5-e514920a429b
358	123456789/357	2	\N	28f1a24a-b6ea-4b76-bba7-6779f81b14fe
238	123456789/237	3	\N	9edbbc8c-bc1b-42ba-8914-1d9e9db2347f
239	123456789/238	3	\N	85429d43-9926-4439-8704-20e18bb5679b
372	123456789/371	2	\N	d450501d-bb9e-4ec6-9691-e27f33bba466
240	123456789/239	3	\N	dc0136e1-f792-4aac-a8ea-16e09675995c
241	123456789/240	4	\N	8d8d2fbb-cae3-4073-a46d-d4e01d204cad
373	123456789/372	2	\N	b7cc4d08-a40f-4400-bca5-3039f8c965b3
242	123456789/241	3	\N	ef8e7e2c-eeeb-439d-b7f9-ade465fc4f68
243	123456789/242	3	\N	79300c61-6d47-405d-9a9a-d1e8f0204305
374	123456789/373	2	\N	24fb983c-62fc-41d7-9a45-45bf55a5359c
244	123456789/243	3	\N	9e61e347-ce40-43c5-a332-f5683442b1fa
245	123456789/244	3	\N	d3672c54-1ef2-471a-ba24-239a3990fc75
375	123456789/374	2	\N	ed4b6780-5f7d-429f-beab-eb44e6170bc9
246	123456789/245	3	\N	ef53ffdb-0f3a-492e-874c-fcd8fba11d06
247	123456789/246	4	\N	a14ae54e-0797-4324-8b82-9846be3aa9fd
380	123456789/379	2	\N	f332b151-98c1-4e28-b87e-bed0d9bf17e8
248	123456789/247	3	\N	01712afa-c526-4f73-94ae-02734ce15c96
249	123456789/248	3	\N	9b63b2f1-f8e9-42f3-8d4f-a49a3f16e914
381	123456789/380	2	\N	e85ea3c1-9d09-4c0e-aaa8-33aca608cbb5
250	123456789/249	3	\N	c23dcaad-e9fa-4c6b-8d86-4fd2f3c125e9
251	123456789/250	3	\N	5e78e0bf-da34-4c8b-ab86-2a6b9f8d63a8
382	123456789/381	2	\N	1386b2cc-40f2-4213-a6d2-8d3ab04ba6bc
252	123456789/251	3	\N	127e289a-cced-4934-91ee-0bd505946855
253	123456789/252	4	\N	f1e4428f-78dc-4c65-93b0-a5fd4a291f23
254	123456789/253	3	\N	a4c357bb-03ad-445b-b073-d6c5a8a9ce33
255	123456789/254	3	\N	96931619-4af6-4562-9d21-45a09a3a369f
256	123456789/255	3	\N	35210960-6f4c-4dde-9ee3-063f923c3dc3
257	123456789/256	3	\N	631514ab-cb74-4a79-a03d-ea3e718ee702
258	123456789/257	3	\N	a5f66249-7b4d-4084-a7b2-76a4ce0f2483
259	123456789/258	4	\N	04ae4009-f11b-486e-929a-2512280f4227
260	123456789/259	4	\N	7482f96f-4d1c-42ef-935b-afa2a5bc1045
261	123456789/260	4	\N	86b6a785-abca-429f-991c-d473d49502ee
262	123456789/261	3	\N	9ac23e05-d27e-4732-83a1-dc07ce94c3e5
263	123456789/262	3	\N	47b9440a-6769-4287-b4e7-a9a79fbf4fdc
264	123456789/263	3	\N	c545077e-d983-473a-b621-d0213869b06d
265	123456789/264	3	\N	40951858-8246-4cb1-b095-0d20303ca115
266	123456789/265	3	\N	7eaed4ff-162a-430f-8a35-1acdd53bc884
267	123456789/266	4	\N	3d6690d8-eadd-46a6-8fea-73dbcdd3ec66
268	123456789/267	3	\N	8b6e660f-2253-4b81-9b42-a065a6964f56
269	123456789/268	3	\N	51fde179-1543-41de-9206-eaa3c75f9b59
270	123456789/269	3	\N	05915171-100e-4d10-89e4-c872711de1aa
271	123456789/270	3	\N	c66b4475-75d3-4d34-b33a-87077ac6bdab
272	123456789/271	3	\N	22e0168a-c2a8-4e0b-85ec-a8d88eafa46e
273	123456789/272	4	\N	7e294bf6-2eec-49aa-9d8f-a6d4a2cc498b
274	123456789/273	3	\N	10b5d9e1-b62d-4c93-ba9c-d5a258b6f2c3
275	123456789/274	3	\N	f98570e1-e406-4857-9e8d-90c97ea8b7eb
276	123456789/275	3	\N	e6c49376-930b-4689-9111-51386ff65eb8
277	123456789/276	3	\N	6e7329c4-fbf0-4c06-aed1-f57996b0dc02
278	123456789/277	3	\N	ecb7bd93-4a76-4895-af27-8033ffb4b9ee
279	123456789/278	4	\N	508fd417-903e-485c-8a79-1d47fecf89ec
280	123456789/279	3	\N	86b7a281-7358-4bd0-be35-d7b13d3a54d7
281	123456789/280	3	\N	c0727846-37aa-424a-a8b6-776f29a6b11c
282	123456789/281	3	\N	69b38b68-43bc-4d73-9de6-7252271f950c
283	123456789/282	3	\N	b20c5473-4f4b-4af4-b0ac-f25f63c15091
284	123456789/283	3	\N	80e08532-d009-40b6-b60b-01ad848f29e7
285	123456789/284	4	\N	70a9c7ec-c890-4cb2-9978-47493f08fa8f
286	123456789/285	3	\N	dd80f6f0-c10b-4172-a531-716f9dd1c230
287	123456789/286	3	\N	98b7684c-bcff-4679-89a6-c6f0d23f0540
288	123456789/287	3	\N	e70c5835-3e0c-4681-b682-089b156bdd3c
289	123456789/288	3	\N	55dcf71d-31cb-43c0-b001-288d404c3890
290	123456789/289	3	\N	58713621-70cd-4c5e-9341-28b32ba41fb9
291	123456789/290	4	\N	9d0dccbc-1024-4802-993c-933cb6cdc260
292	123456789/291	3	\N	1807e1c8-fe69-44f0-99f5-5543862721dd
293	123456789/292	3	\N	3021c2ed-dea4-4b82-a0e4-147c790655fd
294	123456789/293	3	\N	778fbe77-519d-43cf-8e5f-b7524f22be6d
295	123456789/294	3	\N	a3760f39-a4f7-494b-98ef-ca6264671474
296	123456789/295	3	\N	739c1d61-b1fb-4f93-8a6f-a20d3910c4a0
297	123456789/296	4	\N	786d3d1a-1946-4dd0-817b-dab8b0dfa161
298	123456789/297	3	\N	c82c39e8-1b65-4647-90af-d2e6fc0e80a4
299	123456789/298	3	\N	628a887f-5405-49b5-a113-8da165007f80
300	123456789/299	3	\N	62ecff54-d3ad-4590-9773-f7a975437ddf
301	123456789/300	3	\N	63af20f3-0299-4b5b-8c39-e1343f9f944b
302	123456789/301	3	\N	cedd3c7e-baf0-471f-9044-b43cca83af23
303	123456789/302	4	\N	12188074-fdf3-41c4-96c8-fdd2d1cee710
304	123456789/303	4	\N	bc548182-4db3-4087-a94d-d059f9f386e4
305	123456789/304	3	\N	07045af3-ed80-4990-a660-6282fe0fe4fb
306	123456789/305	3	\N	f5f06691-69b5-4979-aee5-1c940a3a17b3
307	123456789/306	3	\N	33f44877-bc89-4386-aca3-ef3a4946d305
308	123456789/307	3	\N	bdf997dd-df12-480a-ae52-8950beded503
309	123456789/308	3	\N	2319137c-c5cc-4ea5-9de7-50713a7f88c4
310	123456789/309	4	\N	803bc41a-3cf3-4f5a-b888-26b61a5ba929
311	123456789/310	3	\N	d42ed59c-0c22-4b9b-bebf-118132eeb353
312	123456789/311	3	\N	3da18c61-9632-4a05-9962-27590f23772d
313	123456789/312	3	\N	8a758888-6213-4881-9b2b-690336684fa7
314	123456789/313	3	\N	3f987ebb-99ce-497d-81e3-5dc76547cc98
325	123456789/324	3	\N	\N
315	123456789/314	3	\N	0f76ce1d-7218-4ff1-848a-af873e4033b3
326	123456789/325	3	\N	\N
316	123456789/315	4	\N	214d281b-6762-46e2-a6a1-98d270cbf4bb
327	123456789/326	3	\N	\N
317	123456789/316	4	\N	9f71cf2b-168c-4efe-844e-afe0e670ccbf
328	123456789/327	3	\N	\N
318	123456789/317	3	\N	924a0f97-19fa-46d9-8720-b3203cbb4ad3
329	123456789/328	3	\N	\N
319	123456789/318	3	\N	0f289146-ce3b-42a6-b59e-3f159bb3e6f7
324	123456789/323	4	\N	\N
320	123456789/319	3	\N	b58ca63f-f2e7-411e-a5da-fe0857ba17d7
332	123456789/331	3	\N	\N
321	123456789/320	3	\N	a0562a18-237a-401a-9e61-99b48c4122dd
333	123456789/332	3	\N	\N
322	123456789/321	3	\N	d6af0d41-100d-4f6d-9bca-da31efbef9b9
334	123456789/333	3	\N	\N
323	123456789/322	4	\N	305fba50-26ce-48e4-af27-4ea801b1ef30
335	123456789/334	3	\N	\N
336	123456789/335	3	\N	\N
331	123456789/330	4	\N	\N
376	123456789/375	2	\N	b683a946-16af-4acd-a050-17decd4bd085
383	123456789/382	2	\N	87bf956f-41be-46d9-a741-f304c8165e94
330	123456789/329	4	\N	823a9569-d81b-4871-9b0d-1a8f04de234a
384	123456789/383	2	\N	d2f5671b-6c52-4952-ba85-c3a87bf72a97
337	123456789/336	4	\N	6b2e2ac5-98ee-4257-a54a-f24c7cb8fb01
338	123456789/337	3	\N	9d445c33-454e-49dc-a493-0f5015eead12
339	123456789/338	3	\N	2b332fc6-9146-4623-863f-255d6566214f
340	123456789/339	3	\N	7df394a5-4dff-468b-b97e-0559c07fa1b9
341	123456789/340	3	\N	a0304a67-0fff-496c-9419-d6696ba39cc1
342	123456789/341	3	\N	870c2ff3-ea24-4139-b31b-c643aa094c67
343	123456789/342	4	\N	5e8bca7b-a019-4138-9939-7951646ad23c
344	123456789/343	3	\N	f6806a22-5e75-442a-8474-1f1bf3b49bb0
345	123456789/344	3	\N	43c5b7d9-a1c7-4361-a0cf-0aa73a9333a7
346	123456789/345	3	\N	55fdca5e-d193-44a3-ada5-2ab4d65395d6
347	123456789/346	3	\N	0357e12e-1e20-4de1-89f8-17dfdd55fd31
348	123456789/347	3	\N	c4ae769f-b5a3-48a9-885a-c99c99c19e37
349	123456789/348	4	\N	9b4b9979-0172-4961-9d58-10f57df85092
350	123456789/349	3	\N	3158d744-02ae-45d3-a4c1-3b8a5c22de3e
351	123456789/350	3	\N	3dac7ef7-c456-42a2-8fc4-519e13b07ee0
352	123456789/351	3	\N	040fde0b-489a-4cc8-bfba-6f69ba7f4f11
353	123456789/352	3	\N	e657559e-c7af-4fa3-8d0a-aba39f0ba879
354	123456789/353	3	\N	bf015865-7bd0-4282-bc70-61735421f9f1
\.


--
-- Name: handle_id_seq; Type: SEQUENCE SET; Schema: public; Owner: funasauser
--

SELECT pg_catalog.setval('public.handle_id_seq', 385, true);


--
-- Name: handle_seq; Type: SEQUENCE SET; Schema: public; Owner: funasauser
--

SELECT pg_catalog.setval('public.handle_seq', 384, true);


--
-- Data for Name: harvested_collection; Type: TABLE DATA; Schema: public; Owner: funasauser
--

COPY public.harvested_collection (harvest_type, oai_source, oai_set_id, harvest_message, metadata_config_id, harvest_status, harvest_start_time, last_harvested, id, collection_id) FROM stdin;
\.


--
-- Name: harvested_collection_seq; Type: SEQUENCE SET; Schema: public; Owner: funasauser
--

SELECT pg_catalog.setval('public.harvested_collection_seq', 1, false);


--
-- Data for Name: harvested_item; Type: TABLE DATA; Schema: public; Owner: funasauser
--

COPY public.harvested_item (last_harvested, oai_id, id, item_id) FROM stdin;
\.


--
-- Name: harvested_item_seq; Type: SEQUENCE SET; Schema: public; Owner: funasauser
--

SELECT pg_catalog.setval('public.harvested_item_seq', 1, false);


--
-- Name: history_seq; Type: SEQUENCE SET; Schema: public; Owner: funasauser
--

SELECT pg_catalog.setval('public.history_seq', 1, false);


--
-- Data for Name: item; Type: TABLE DATA; Schema: public; Owner: funasauser
--

COPY public.item (item_id, in_archive, withdrawn, last_modified, discoverable, uuid, submitter_id, owning_collection) FROM stdin;
\N	f	f	2019-04-23 16:11:53.951-03	t	c54373cb-b02d-4935-add5-f3c17ae29223	a4d10708-6a03-4a32-9b2f-245adb6b6240	\N
\N	t	f	2019-01-20 19:27:26.896-02	t	25cb38d4-142c-4282-a4cc-b7be4e8f363b	cd410caa-8ed0-4822-8722-8eab234a8b4c	3bf97251-0d2c-497a-b1c0-2fb8f089d5d9
\N	f	f	2019-09-23 13:49:48.162-03	t	a96c12d6-537a-46d9-9b12-5e6e3841afea	51f5e325-d8b5-41f3-b208-8271808ecf72	\N
\N	f	f	2019-09-23 11:13:01.311-03	t	5465b2d4-cc89-4a55-bf57-b27704f9d683	51f5e325-d8b5-41f3-b208-8271808ecf72	\N
\N	t	f	2019-05-10 10:20:06.071-03	t	b7cc4d08-a40f-4400-bca5-3039f8c965b3	28194931-611a-42cc-89c7-b133dc63c893	6ef94e51-16d7-4cec-9359-a94d499e8337
\N	t	f	2019-09-23 13:37:44.213-03	t	87bf956f-41be-46d9-a741-f304c8165e94	28194931-611a-42cc-89c7-b133dc63c893	b55202c0-1e3b-4eba-909d-54f7fad48b9c
\N	t	f	2019-05-26 11:50:56.008-03	t	28f1a24a-b6ea-4b76-bba7-6779f81b14fe	5ee61fad-2de8-4f98-834b-c327dfed413c	7db66edb-3f9f-4c24-8fa2-0a4b11efb0b8
\N	t	f	2019-05-15 09:18:41.262-03	t	510ef6ac-d964-4857-81e9-85a00e00dc51	28194931-611a-42cc-89c7-b133dc63c893	c087e9be-29f7-437f-b0da-bddb0b2ab183
\N	t	f	2019-05-26 11:50:57.465-03	t	b1c7cc22-a459-4f55-99cc-98fc7e9829cd	28194931-611a-42cc-89c7-b133dc63c893	c087e9be-29f7-437f-b0da-bddb0b2ab183
\N	t	f	2019-05-26 11:50:57.894-03	t	d450501d-bb9e-4ec6-9691-e27f33bba466	28194931-611a-42cc-89c7-b133dc63c893	6ef94e51-16d7-4cec-9359-a94d499e8337
\N	f	f	2019-08-05 15:46:45.851-03	t	efd3ec50-5afd-4a3f-ade0-387c995fa513	\N	\N
\N	t	f	2019-05-26 11:50:59.242-03	t	b683a946-16af-4acd-a050-17decd4bd085	5ee61fad-2de8-4f98-834b-c327dfed413c	c087e9be-29f7-437f-b0da-bddb0b2ab183
\N	t	f	2019-05-26 11:50:59.911-03	t	1446271c-d93d-42dc-a7ba-a6ca384b4448	5ee61fad-2de8-4f98-834b-c327dfed413c	f2c7e15a-2db1-4099-9d26-78ba2c16b8da
\N	t	f	2019-09-23 13:35:30.36-03	t	1386b2cc-40f2-4213-a6d2-8d3ab04ba6bc	28194931-611a-42cc-89c7-b133dc63c893	cd75101b-abb6-46ef-ac88-3af552f33478
\N	f	f	2019-09-02 15:15:10.015-03	t	fd7979d1-2f9d-43c1-921b-16286ad57b19	cd410caa-8ed0-4822-8722-8eab234a8b4c	\N
\N	f	f	2019-09-23 11:16:47.336-03	t	6466da00-ee69-4ea7-a7b4-3bbdbbf104ae	51f5e325-d8b5-41f3-b208-8271808ecf72	\N
\N	t	f	2019-05-15 09:40:22.609-03	t	24fb983c-62fc-41d7-9a45-45bf55a5359c	cd410caa-8ed0-4822-8722-8eab234a8b4c	6ef94e51-16d7-4cec-9359-a94d499e8337
\N	t	f	2019-09-23 13:33:08.809-03	t	e85ea3c1-9d09-4c0e-aaa8-33aca608cbb5	28194931-611a-42cc-89c7-b133dc63c893	f2c7e15a-2db1-4099-9d26-78ba2c16b8da
\N	f	f	2019-09-02 15:27:26.169-03	t	351126ff-3ed8-4ee6-bb98-54a08e436331	cd410caa-8ed0-4822-8722-8eab234a8b4c	\N
\N	f	f	2019-08-31 19:05:41.573-03	t	98667b07-a1fd-4b74-ba08-933c0d63c1d0	cd410caa-8ed0-4822-8722-8eab234a8b4c	\N
\N	f	f	2019-06-10 16:36:34.223-03	t	d2550a87-9f59-4d60-aca3-bd9b955bfa4d	51f5e325-d8b5-41f3-b208-8271808ecf72	\N
\N	t	f	2019-03-26 02:32:44.572-03	t	1f0c95ab-3775-4094-b293-183d3b5074b2	cd410caa-8ed0-4822-8722-8eab234a8b4c	d851294f-191c-46a0-abf4-d338042d5971
\N	t	f	2019-05-14 16:16:43.743-03	t	ed4b6780-5f7d-429f-beab-eb44e6170bc9	28194931-611a-42cc-89c7-b133dc63c893	cd75101b-abb6-46ef-ac88-3af552f33478
\N	f	f	2019-05-14 08:25:33.111-03	t	3d527afd-cb44-4f63-ae6a-cd9ccee96f11	\N	\N
\N	f	f	2019-06-10 17:18:30.336-03	t	7612424e-b29d-4a55-b8de-61f3ac6bfb59	51f5e325-d8b5-41f3-b208-8271808ecf72	\N
\N	f	f	2019-09-23 10:43:07.286-03	t	4efe5ddd-8bc9-43b6-a95d-bfedee710730	51f5e325-d8b5-41f3-b208-8271808ecf72	\N
\N	f	f	2019-06-06 15:52:13.511-03	t	861af420-dd5d-497c-83d4-f06ebcfc9528	51f5e325-d8b5-41f3-b208-8271808ecf72	\N
\N	t	f	2019-05-08 08:21:42.599-03	t	09d7f4dc-8fce-43c0-b778-0df584c2739f	28194931-611a-42cc-89c7-b133dc63c893	f2c7e15a-2db1-4099-9d26-78ba2c16b8da
\N	t	f	2019-01-20 19:27:16.356-02	t	b37744b2-292c-4937-a401-9243b80980b3	cd410caa-8ed0-4822-8722-8eab234a8b4c	0607dd1b-5468-48ef-8905-8d07d253d1f7
\N	f	f	2019-09-23 16:10:02.301-03	t	7f9c8b1b-3a70-4b8b-8900-c6d095e1db00	51f5e325-d8b5-41f3-b208-8271808ecf72	\N
\N	t	f	2019-06-11 00:00:43.177-03	t	3bc2d4e3-6c4f-4e12-98c7-89b38012246f	5ee61fad-2de8-4f98-834b-c327dfed413c	b55202c0-1e3b-4eba-909d-54f7fad48b9c
\N	f	f	2019-09-02 12:15:29.063-03	t	c80bc66c-a22e-43ae-8149-4fb687e2aad1	cd410caa-8ed0-4822-8722-8eab234a8b4c	\N
\N	f	f	2019-09-23 14:01:22.651-03	t	a0c1ee92-b2b4-4f58-adae-4a8101e93aa7	51f5e325-d8b5-41f3-b208-8271808ecf72	\N
\N	t	f	2019-06-12 08:47:02.339-03	t	416198eb-e102-4842-9bcc-a60fdcb450d7	28194931-611a-42cc-89c7-b133dc63c893	b55202c0-1e3b-4eba-909d-54f7fad48b9c
\N	f	f	2019-06-11 14:01:33.008-03	t	54274d99-b0a7-41f5-bfbb-321d3e01d787	51f5e325-d8b5-41f3-b208-8271808ecf72	\N
\N	f	f	2019-06-07 15:27:34.466-03	t	33a11e84-68c9-4e4c-8aba-53990a33f7ca	5ee61fad-2de8-4f98-834b-c327dfed413c	\N
\N	f	f	2019-09-23 10:43:43.235-03	t	9213adb3-98f4-4d42-b36f-a044402c752a	51f5e325-d8b5-41f3-b208-8271808ecf72	\N
\N	f	f	2019-06-14 15:24:14.453-03	t	05387bb7-4eb6-49e7-9061-6b7c2c6bb446	51f5e325-d8b5-41f3-b208-8271808ecf72	\N
\N	f	f	2019-09-23 13:50:24.741-03	t	a933e90f-022f-487e-bb25-c1e3f9de5e6c	51f5e325-d8b5-41f3-b208-8271808ecf72	\N
\N	t	f	2019-09-23 13:40:12.401-03	t	d2f5671b-6c52-4952-ba85-c3a87bf72a97	28194931-611a-42cc-89c7-b133dc63c893	6ef94e51-16d7-4cec-9359-a94d499e8337
\N	f	f	2019-09-23 11:05:54.56-03	t	2b63d710-d77a-46ed-a02d-8f12284d093d	51f5e325-d8b5-41f3-b208-8271808ecf72	\N
\N	f	f	2019-09-02 15:05:22.952-03	t	1948e980-ac90-4c67-9d57-375b10c0978a	cd410caa-8ed0-4822-8722-8eab234a8b4c	\N
\N	f	f	2019-09-23 11:12:39.846-03	t	d1483857-e58d-4d41-9d56-e70a642ca5f8	51f5e325-d8b5-41f3-b208-8271808ecf72	\N
\N	f	f	2019-09-23 15:55:06.264-03	t	d97e2d78-7a2c-413d-9749-2c004d3f95a9	51f5e325-d8b5-41f3-b208-8271808ecf72	\N
\N	f	f	2019-09-23 14:03:15.848-03	t	a9e375db-ed27-49a4-ab37-1f71e3344c07	51f5e325-d8b5-41f3-b208-8271808ecf72	\N
\N	f	f	2019-09-23 13:50:42.554-03	t	fa0c8a49-a6bf-4d87-805d-5233c36c82ea	51f5e325-d8b5-41f3-b208-8271808ecf72	\N
\N	f	f	2019-09-23 14:01:45.309-03	t	6435afc7-5bfc-43d1-a557-286efaaf8ed4	51f5e325-d8b5-41f3-b208-8271808ecf72	\N
\N	t	f	2019-09-23 13:29:35.206-03	t	f332b151-98c1-4e28-b87e-bed0d9bf17e8	28194931-611a-42cc-89c7-b133dc63c893	c087e9be-29f7-437f-b0da-bddb0b2ab183
\N	f	f	2019-09-24 08:55:51.391-03	t	d7ff7622-8d60-4892-9132-d44c6321e8a6	51f5e325-d8b5-41f3-b208-8271808ecf72	\N
\N	f	f	2019-09-23 14:00:52.467-03	t	4bfa33a5-6844-4768-a282-9dac09cd5770	51f5e325-d8b5-41f3-b208-8271808ecf72	\N
\N	f	f	2019-09-23 14:02:54.613-03	t	e15414f8-b998-4844-a3e6-fd616616a97d	51f5e325-d8b5-41f3-b208-8271808ecf72	\N
\N	f	f	2019-09-23 15:55:52.43-03	t	7a3e90a0-98d3-431e-9432-1ede8f95757f	51f5e325-d8b5-41f3-b208-8271808ecf72	\N
\N	f	f	2019-09-23 16:14:34.804-03	t	fec6cee0-40ae-40ab-8b42-b2adf77d55a4	51f5e325-d8b5-41f3-b208-8271808ecf72	\N
\N	f	f	2019-09-23 16:10:18.879-03	t	f1228c2e-1e8e-4e61-b4ce-a569f98cc534	51f5e325-d8b5-41f3-b208-8271808ecf72	\N
\N	f	f	2019-09-23 15:58:36.385-03	t	65aff6e2-e01f-4ea7-b76a-854578347fce	51f5e325-d8b5-41f3-b208-8271808ecf72	\N
\N	f	f	2019-09-24 09:47:06.111-03	t	202142cf-284f-499e-95a9-5ebb2522750a	51f5e325-d8b5-41f3-b208-8271808ecf72	\N
\N	f	f	2019-09-24 09:00:05.058-03	t	3371e717-1768-4f52-8eee-3ff331e3d90e	51f5e325-d8b5-41f3-b208-8271808ecf72	\N
\N	f	f	2019-09-24 08:52:41.225-03	t	61cec1fe-92dd-4e5f-8cb0-cd838ac093f0	51f5e325-d8b5-41f3-b208-8271808ecf72	\N
\N	f	f	2019-09-23 16:10:25.656-03	t	b4c46f03-496f-42a2-98f7-6739e324de11	51f5e325-d8b5-41f3-b208-8271808ecf72	\N
\N	f	f	2019-09-24 08:55:55.289-03	t	7009fa9d-a02c-4910-a62f-5c3f2b8f28a2	51f5e325-d8b5-41f3-b208-8271808ecf72	\N
\N	f	f	2019-09-24 09:46:35.695-03	t	253193d7-2a6f-4636-9ebc-08c8cc1723ac	51f5e325-d8b5-41f3-b208-8271808ecf72	\N
\N	f	f	2019-09-24 09:46:29.048-03	t	f2d20e8d-cc45-4737-a1f8-6dc97d45f981	51f5e325-d8b5-41f3-b208-8271808ecf72	\N
\N	f	f	2019-09-24 09:51:12.499-03	t	beb1e339-b679-44de-be95-b17bb1255c7a	51f5e325-d8b5-41f3-b208-8271808ecf72	\N
\N	f	f	2019-09-24 09:59:29.907-03	t	0fbb9e34-4b32-409d-a301-6a4a5e5a9ee4	51f5e325-d8b5-41f3-b208-8271808ecf72	\N
\N	f	f	2019-09-24 09:59:30.337-03	t	e21ca461-7f92-4cc7-8b99-9779c76e351a	51f5e325-d8b5-41f3-b208-8271808ecf72	\N
\N	f	f	2019-09-24 09:59:47.754-03	t	534ec073-e464-4149-bf28-5cf8ad4baa5d	51f5e325-d8b5-41f3-b208-8271808ecf72	\N
\N	f	f	2019-09-24 10:03:48.282-03	t	428163a7-e57d-4b39-a5b8-9fd69dc65567	51f5e325-d8b5-41f3-b208-8271808ecf72	\N
\N	f	f	2019-10-08 16:33:25.901-03	t	34cefcb9-0d95-4de6-938f-9217bcc9399b	51f5e325-d8b5-41f3-b208-8271808ecf72	\N
\N	t	f	2019-10-24 10:44:20.325-03	t	380e731b-2df3-4f9e-84d0-16ffb0010e66	28194931-611a-42cc-89c7-b133dc63c893	c087e9be-29f7-437f-b0da-bddb0b2ab183
\N	f	f	2019-10-29 09:57:21.285-03	t	01abe899-e6b3-49d1-87b3-08a163471785	28194931-611a-42cc-89c7-b133dc63c893	\N
\N	f	f	2019-10-29 10:50:34.446-03	t	d03bfdfd-3c94-4b1d-8abd-b78d465c5daa	5ee61fad-2de8-4f98-834b-c327dfed413c	\N
\N	f	f	2019-10-29 11:32:40.506-03	t	01ac3eb0-7858-420b-9131-19cf28abf13e	5ee61fad-2de8-4f98-834b-c327dfed413c	\N
\N	f	f	2019-10-29 11:34:43.863-03	t	2c23936e-e138-4502-8ec3-e8c71bb851b1	5ee61fad-2de8-4f98-834b-c327dfed413c	\N
\N	f	f	2019-10-29 11:42:19.496-03	t	0a2460c5-e7b6-4e59-8342-35dd4514da7c	5ee61fad-2de8-4f98-834b-c327dfed413c	\N
\.


--
-- Data for Name: item2bundle; Type: TABLE DATA; Schema: public; Owner: funasauser
--

COPY public.item2bundle (bundle_id, item_id) FROM stdin;
12f6e52a-9df2-4bc6-8a4a-f88cebb87203	1f0c95ab-3775-4094-b293-183d3b5074b2
da51fa58-1abe-4f80-bbc7-9e72e48e1fcf	1f0c95ab-3775-4094-b293-183d3b5074b2
e629b0d9-bf91-439a-9f16-632d621535b2	1f0c95ab-3775-4094-b293-183d3b5074b2
972d8284-ac47-4d48-82fe-103a24fbe65b	1f0c95ab-3775-4094-b293-183d3b5074b2
5c1126f4-8376-42d3-b83e-3f4f070a6710	b37744b2-292c-4937-a401-9243b80980b3
276a4446-ee69-4bc0-8f29-690dbf3fbaa2	b37744b2-292c-4937-a401-9243b80980b3
a260f402-ab1b-48d5-8f31-e54b8246e97e	25cb38d4-142c-4282-a4cc-b7be4e8f363b
2dd047b5-e43b-4ba9-8d1d-b6badc87a459	25cb38d4-142c-4282-a4cc-b7be4e8f363b
7bba6efb-709f-4b4a-b666-654168314b1c	b37744b2-292c-4937-a401-9243b80980b3
539670a8-3427-4d5c-96ac-02b95f900003	b37744b2-292c-4937-a401-9243b80980b3
9709fcb3-1e1e-4825-89cf-6774de18420b	25cb38d4-142c-4282-a4cc-b7be4e8f363b
a63a3b39-a5c2-478d-b57b-c250553fa2e0	25cb38d4-142c-4282-a4cc-b7be4e8f363b
93182026-e06b-4654-950f-39cc4aa0180f	28f1a24a-b6ea-4b76-bba7-6779f81b14fe
1f55e71a-6121-4374-baf3-3f6e8881131a	28f1a24a-b6ea-4b76-bba7-6779f81b14fe
b46e66b6-fef8-4551-844b-f48b51f18887	b1c7cc22-a459-4f55-99cc-98fc7e9829cd
6c09d5c6-7db2-4d59-a23c-a0cff7ea31da	510ef6ac-d964-4857-81e9-85a00e00dc51
c6f291c2-9995-454e-a838-cb645ec2de77	09d7f4dc-8fce-43c0-b778-0df584c2739f
75c62285-d1bb-4897-a31f-230c5115c6c5	d450501d-bb9e-4ec6-9691-e27f33bba466
6a68fb46-a034-4129-b96e-b8d5209945cb	d450501d-bb9e-4ec6-9691-e27f33bba466
50ffad89-623b-41e4-986a-c3a2feaade8c	b7cc4d08-a40f-4400-bca5-3039f8c965b3
35120e12-4729-4a25-a25b-572399403a63	24fb983c-62fc-41d7-9a45-45bf55a5359c
ad33886e-87fb-4206-a2de-6feb2995e006	ed4b6780-5f7d-429f-beab-eb44e6170bc9
4658a0b2-50e4-444a-b4ac-e4d6d7aa559c	b683a946-16af-4acd-a050-17decd4bd085
dbcfe7c2-b2ab-4cef-a7e2-1574b7387410	b683a946-16af-4acd-a050-17decd4bd085
9496fe87-9539-44d1-8ca3-4d62c300194d	1446271c-d93d-42dc-a7ba-a6ca384b4448
f927872e-3dba-4482-af19-719b731d7fea	1446271c-d93d-42dc-a7ba-a6ca384b4448
b6a93f95-1b06-48ac-8422-c0ff627bc780	b1c7cc22-a459-4f55-99cc-98fc7e9829cd
d2fd6cdc-efbe-47ba-bb06-06971d06d11b	28f1a24a-b6ea-4b76-bba7-6779f81b14fe
2715b220-a689-4384-89a8-78efb69abf3b	28f1a24a-b6ea-4b76-bba7-6779f81b14fe
d5ab3c0f-e4fb-4d5d-80bb-f66751da4850	b1c7cc22-a459-4f55-99cc-98fc7e9829cd
0b1f1831-2e41-4c59-af71-5f537a9a1a22	b1c7cc22-a459-4f55-99cc-98fc7e9829cd
de0009cf-13b5-4649-86fe-90fc9eec3b30	d450501d-bb9e-4ec6-9691-e27f33bba466
b9bc2a0e-639a-4587-9f6d-42fec43ffd82	b683a946-16af-4acd-a050-17decd4bd085
0a7a2874-2f9d-477f-9044-465aae71afcd	b683a946-16af-4acd-a050-17decd4bd085
1c7b63c0-8006-4d71-a70b-1a59ce3ba62f	1446271c-d93d-42dc-a7ba-a6ca384b4448
fe7ea1de-7497-4d64-93b5-a6b56d21eee8	3bc2d4e3-6c4f-4e12-98c7-89b38012246f
5bfb5579-17ed-4113-b850-5d52fe90f1f7	3bc2d4e3-6c4f-4e12-98c7-89b38012246f
a761698f-3924-4e7d-9219-37f93670fdf0	3bc2d4e3-6c4f-4e12-98c7-89b38012246f
22be2e2a-2cf2-4956-a75f-bb4ff2c756b9	3bc2d4e3-6c4f-4e12-98c7-89b38012246f
ab12cb79-aac2-414b-9946-6a754548e110	416198eb-e102-4842-9bcc-a60fdcb450d7
bf28708a-d254-4e0b-9189-a5704d83d883	98667b07-a1fd-4b74-ba08-933c0d63c1d0
d755ed7e-018c-4209-ae5c-a485a3172ccb	f332b151-98c1-4e28-b87e-bed0d9bf17e8
c05c05d3-d9ac-4896-8ed1-46ac985ae51c	e85ea3c1-9d09-4c0e-aaa8-33aca608cbb5
edc044e1-bae6-4e22-b2a6-5ac50f8576c6	1386b2cc-40f2-4213-a6d2-8d3ab04ba6bc
7e111fd6-e95d-46fa-8e6a-fc112f2c3468	87bf956f-41be-46d9-a741-f304c8165e94
e3f4ba1b-0b3f-477f-9785-2c45c1cc53e4	d2f5671b-6c52-4952-ba85-c3a87bf72a97
cea631f7-6753-416e-a6f1-83b25760bf3a	380e731b-2df3-4f9e-84d0-16ffb0010e66
\.


--
-- Data for Name: metadatafieldregistry; Type: TABLE DATA; Schema: public; Owner: funasauser
--

COPY public.metadatafieldregistry (metadata_field_id, metadata_schema_id, element, qualifier, scope_note) FROM stdin;
1	2	firstname	\N	\N
2	2	lastname	\N	\N
3	2	phone	\N	\N
4	2	language	\N	\N
5	1	provenance	\N	\N
6	1	rights	license	\N
7	1	contributor	\N	A person, organization, or service responsible for the content of the resource.  Catch-all for unspecified contributors.
8	1	contributor	advisor	Use primarily for thesis advisor.
9	1	contributor	author	\N
10	1	contributor	corporatename	\N
11	1	contributor	editor	\N
12	1	contributor	illustrator	\N
13	1	contributor	other	\N
14	1	coverage	spatial	Spatial characteristics of content.
15	1	coverage	temporal	Temporal characteristics of content.
16	1	creator	\N	Do not use; only for harvested metadata.
17	1	date	\N	Use qualified form if possible.
18	1	date	accessioned	Date DSpace takes possession of item.
19	1	date	available	Date or date range item became available to the public.
20	1	date	copyright	Date of copyright.
21	1	date	created	Date of creation or manufacture of intellectual content if different from date.issued.
22	1	date	issued	Date of publication or distribution.
23	1	date	submitted	Recommend for theses/dissertations.
24	1	identifier	\N	Catch-all for unambiguous identifiers not defined by\n    qualified form; use identifier.other for a known identifier common\n    to a local collection instead of unqualified form.
25	1	identifier	citation	Human-readable, standard bibliographic citation \n    of non-DSpace format of this item
26	1	identifier	govdoc	A government document number
27	1	identifier	isbn	International Standard Book Number
28	1	identifier	issn	International Standard Serial Number
29	1	identifier	sici	Serial Item and Contribution Identifier
30	1	identifier	doi	Digital Object Identifier
31	1	identifier	ismn	International Standard Music Number
32	1	identifier	other	A known identifier type common to a local collection.
33	1	identifier	uri	Uniform Resource Identifier
34	1	description	\N	Catch-all for any description not defined by qualifiers.
35	1	description	abstract	Abstract or summary.
36	1	description	provenance	The history of custody of the item since its creation, including any changes successive custodians made to it.
37	1	description	sponsorship	Information about sponsoring agencies, individuals, or\n    contractual arrangements for the item.
38	1	description	statementofresponsibility	To preserve statement of responsibility from MARC records.
39	1	description	tableofcontents	A table of contents for a given item.
40	1	description	uri	Uniform Resource Identifier pointing to description of\n    this item.
41	1	description	notes	General notes for the item
42	1	format	\N	Catch-all for any format information not defined by qualifiers.
43	1	format	extent	Size or duration.
44	1	format	medium	Physical medium.
45	1	format	mimetype	Registered MIME type identifiers.
46	1	language	\N	Catch-all for non-ISO forms of the language of the\n    item, accommodating harvested values.
47	1	language	iso	Current ISO standard for language of intellectual content, including country codes (e.g. "en_US").
48	1	publisher	\N	Entity responsible for publication, distribution, or imprint.
49	1	relation	\N	Catch-all for references to other related items.
50	1	relation	isformatof	References additional physical form.
51	1	relation	ispartof	References physically or logically containing item.
52	1	relation	ispartofseries	Series name and number within that series, if available.
53	1	relation	haspart	References physically or logically contained item.
54	1	relation	isversionof	References earlier version.
55	1	relation	hasversion	References later version.
56	1	relation	isbasedon	References source.
57	1	relation	isreferencedby	Pointed to by referenced resource.
58	1	relation	requires	Referenced resource is required to support function,\n    delivery, or coherence of item.
59	1	relation	replaces	References preceeding item.
60	1	relation	isreplacedby	References succeeding item.
61	1	relation	uri	References Uniform Resource Identifier for related item.
62	1	rights	\N	Terms governing use and reproduction.
63	1	rights	uri	References terms governing use and reproduction.
64	1	rights	holder	Holder of the copyright of the record.
65	1	source	\N	Do not use; only for harvested metadata.
66	1	source	uri	Do not use; only for harvested metadata.
67	1	source	centercode	PAHO K center
68	1	subject	\N	Uncontrolled index term.
69	1	subject	classification	Catch-all for value from local classification system;\n    global classification systems will receive specific qualifier
70	1	subject	ddc	Dewey Decimal Classification Number
71	1	subject	lcc	Library of Congress Classification Number
72	1	subject	lcsh	Library of Congress Subject Headings
73	1	subject	mesh	MEdical Subject Headings
74	1	subject	other	Local controlled vocabulary; global vocabularies will receive specific qualifier.
75	1	title	\N	Title statement/title proper.
76	1	title	alternative	Varying (or substitute) form of title proper appearing in item,\n    e.g. abbreviation or translation
77	1	title	release	Version
78	1	type	\N	Nature or genre of content.
79	3	abstract	\N	A summary of the resource.
80	3	accessRights	\N	Information about who can access the resource or an indication of its security status. May include information regarding access or restrictions based on privacy, security, or other policies.
81	3	accrualMethod	\N	The method by which items are added to a collection.
82	3	accrualPeriodicity	\N	The frequency with which items are added to a collection.
83	3	accrualPolicy	\N	The policy governing the addition of items to a collection.
84	3	alternative	\N	An alternative name for the resource.
85	3	audience	\N	A class of entity for whom the resource is intended or useful.
86	3	available	\N	Date (often a range) that the resource became or will become available.
87	3	bibliographicCitation	\N	Recommended practice is to include sufficient bibliographic detail to identify the resource as unambiguously as possible.
88	3	conformsTo	\N	An established standard to which the described resource conforms.
89	3	contributor	\N	An entity responsible for making contributions to the resource. Examples of a Contributor include a person, an organization, or a service.
90	3	coverage	\N	The spatial or temporal topic of the resource, the spatial applicability of the resource, or the jurisdiction under which the resource is relevant.
91	3	created	\N	Date of creation of the resource.
92	3	creator	\N	An entity primarily responsible for making the resource.
93	3	date	\N	A point or period of time associated with an event in the lifecycle of the resource.
94	3	dateAccepted	\N	Date of acceptance of the resource.
95	3	dateCopyrighted	\N	Date of copyright.
96	3	dateSubmitted	\N	Date of submission of the resource.
97	3	description	\N	An account of the resource.
98	3	educationLevel	\N	A class of entity, defined in terms of progression through an educational or training context, for which the described resource is intended.
99	3	extent	\N	The size or duration of the resource.
100	3	format	\N	The file format, physical medium, or dimensions of the resource.
101	3	hasFormat	\N	A related resource that is substantially the same as the pre-existing described resource, but in another format.
102	3	hasPart	\N	A related resource that is included either physically or logically in the described resource.
103	3	hasVersion	\N	A related resource that is a version, edition, or adaptation of the described resource.
104	3	identifier	\N	An unambiguous reference to the resource within a given context.
105	3	instructionalMethod	\N	A process, used to engender knowledge, attitudes and skills, that the described resource is designed to support.
106	3	isFormatOf	\N	A related resource that is substantially the same as the described resource, but in another format.
107	3	isPartOf	\N	A related resource in which the described resource is physically or logically included.
108	3	isReferencedBy	\N	A related resource that references, cites, or otherwise points to the described resource.
109	3	isReplacedBy	\N	A related resource that supplants, displaces, or supersedes the described resource.
110	3	isRequiredBy	\N	A related resource that requires the described resource to support its function, delivery, or coherence.
111	3	issued	\N	Date of formal issuance (e.g., publication) of the resource.
112	3	isVersionOf	\N	A related resource of which the described resource is a version, edition, or adaptation.
113	3	language	\N	A language of the resource.
114	3	license	\N	A legal document giving official permission to do something with the resource.
115	3	mediator	\N	An entity that mediates access to the resource and for whom the resource is intended or useful.
116	3	medium	\N	The material or physical carrier of the resource.
117	3	modified	\N	Date on which the resource was changed.
118	3	provenance	\N	A statement of any changes in ownership and custody of the resource since its creation that are significant for its authenticity, integrity, and interpretation.
119	3	publisher	\N	An entity responsible for making the resource available.
120	3	references	\N	A related resource that is referenced, cited, or otherwise pointed to by the described resource.
121	3	relation	\N	A related resource.
122	3	replaces	\N	A related resource that is supplanted, displaced, or superseded by the described resource.
123	3	requires	\N	A related resource that is required by the described resource to support its function, delivery, or coherence.
124	3	rights	\N	Information about rights held in and over the resource.
125	3	rightsHolder	\N	A person or organization owning or managing rights over the resource.
126	3	source	\N	A related resource from which the described resource is derived.
127	3	spatial	\N	Spatial characteristics of the resource.
128	3	subject	\N	The topic of the resource.
129	3	tableOfContents	\N	A list of subunits of the resource.
130	3	temporal	\N	Temporal characteristics of the resource.
131	3	title	\N	A name given to the resource.
132	3	type	\N	The nature or genre of the resource.
133	3	valid	\N	Date (often a range) of validity of a resource.
134	1	date	updated	The last time the item was updated via the SWORD interface
135	1	description	version	The Peer Reviewed status of an item
136	1	identifier	slug	a uri supplied via the sword slug header, as a suggested uri for the item
137	1	language	rfc3066	the rfc3066 form of the language for the item
138	5	isfeatured	\N	Aparece en seccion  featured items
139	5	publisher	city	Aparece en seccion  featured items
140	5	publisher	country	Aparece en seccion  featured items
141	5	relation	languageVersion	Aparece en seccion  featured items
143	5	subject	\N	
144	5	youtubeid	\N	
145	6	date	submitted	Legislation collection. Used for the date of submission of the document (not same as issued)
146	6	volume	\N	Volume of the entire publication where the item exists
147	6	section	\N	Section of the entire publication where the item exists
148	6	part	\N	Part of the entire publication where the item exists
149	6	pages	\N	Pages of the entire publication where the item exists
150	6	date	vigencia	Legislation collection. Used for defining the date until this document will be valid
151	6	legislation	scope	Legislation collection. Scope of the legislation (National, State, etc)
152	6	publisher	country	Legislation collection. Country that applies the legislation. Something similar to coverage
153	6	publisher	state	Legislation collection. State that applies the legislation. Something similar to coverage
154	6	publisher	city	Legislation collection. City that applies the legislation. Something similar to coverage
155	6	relation	altera	Legislation collection. Relation between documents
156	6	relation	cambiadopor	Legislation collection. Relation between documents
157	6	relation	complementa	Legislation collection. Relation between documents
158	6	relation	complementadopor	Legislation collection. Relation between documents
161	6	relation	incluidoen	Legislation collection. Relation between documents
162	6	relation	incluye	Legislation collection. Relation between documents
163	6	youtubeid	\N	Youtube identifier to play videos online
164	6	relation	revoga	Legislation collection. Relation between documents
165	6	relation	revogadopor	Legislation collection. Relation between documents
166	7	educational	interactivityLevel	Level of interactivity of the resource
167	7	educational	difficulty	Difficulty of the resource
168	7	general	aggregationLevel	Level of granularity of the resource
169	7	technical	requirement	Technical requirements required for the resource
170	7	educational	typicalLearningTime	Typical learning time for the resource
171	7	educational	learningResourceType	Type of learning resource
172	6	relation	excluye	Legislation collection. Relation between documents
173	6	relation	excluidopor	Legislation collection. Relation between documents
174	6	relation	epartede	Educational resources
175	6	relation	eversaode	Educational resources
176	6	relation	ebasepara	Educational resources
177	6	relation	requer	Educational resources
178	6	educational	granularity	Educational resources. Understands how to describe the granularity of the educational resource
179	7	educational	instructionalMethod	Understands how to qualify the educational resource
180	1	audience	\N	Educational resources
181	7	educational	context	The main objective of knowledge is the resource should be used
182	6	subject	\N	Subject for secondary controlled vocabulary
\.


--
-- Name: metadatafieldregistry_seq; Type: SEQUENCE SET; Schema: public; Owner: funasauser
--

SELECT pg_catalog.setval('public.metadatafieldregistry_seq', 182, true);


--
-- Data for Name: metadataschemaregistry; Type: TABLE DATA; Schema: public; Owner: funasauser
--

COPY public.metadataschemaregistry (metadata_schema_id, namespace, short_id) FROM stdin;
1	http://dublincore.org/documents/dcmi-terms/	dc
2	http://dspace.org/eperson	eperson
3	http://purl.org/dc/terms/	dcterms
4	http://dspace.org/namespace/local/	local
5	http://www.paho.org	paho
6	http://www.paho.org/bireme/schemas	bireme
7	https://standards.ieee.org/lom/schema	lom
\.


--
-- Name: metadataschemaregistry_seq; Type: SEQUENCE SET; Schema: public; Owner: funasauser
--

SELECT pg_catalog.setval('public.metadataschemaregistry_seq', 7, true);


--
-- Data for Name: metadatavalue; Type: TABLE DATA; Schema: public; Owner: funasauser
--

COPY public.metadatavalue (metadata_value_id, metadata_field_id, text_value, text_lang, place, authority, confidence, dspace_object_id) FROM stdin;
1	2	Marmonti	\N	0	\N	-1	cd410caa-8ed0-4822-8722-8eab234a8b4c
2	1	Emiliano	\N	0	\N	-1	cd410caa-8ed0-4822-8722-8eab234a8b4c
3	4	es	\N	0	\N	-1	cd410caa-8ed0-4822-8722-8eab234a8b4c
2839	75	LICENSE	\N	1	\N	-1	c05c05d3-d9ac-4896-8ed1-46ac985ae51c
2199	63	http://creativecommons.org/licenses/by-sa/3.0/igo/	*	0	\N	-1	ed4b6780-5f7d-429f-beab-eb44e6170bc9
2200	62	Attribution-ShareAlike 3.0 IGO	*	0	\N	-1	ed4b6780-5f7d-429f-beab-eb44e6170bc9
1460	75	teste_upload.txt	\N	0	\N	-1	910a3078-9fba-457e-a3d2-5a8a42a4a59b
1461	65	teste_upload.txt	\N	0	\N	-1	910a3078-9fba-457e-a3d2-5a8a42a4a59b
2201	75	LICENSE	\N	1	\N	-1	ad33886e-87fb-4206-a2de-6feb2995e006
11	35		\N	0	\N	-1	afd22d8d-4201-4482-888c-c06b85307651
12	75	Legislação	\N	0	\N	-1	afd22d8d-4201-4482-888c-c06b85307651
13	35		\N	0	\N	-1	4b0ebee1-3f02-43c5-bdac-923b17a459bb
14	75	Materiais Multimidia	\N	0	\N	-1	4b0ebee1-3f02-43c5-bdac-923b17a459bb
15	35		\N	0	\N	-1	240b86fb-057a-4098-b4a9-16362bd4d88e
16	75	Políticas, Planejamento, Gestão e Projetos	\N	0	\N	-1	240b86fb-057a-4098-b4a9-16362bd4d88e
17	35		\N	0	\N	-1	f02c8749-274c-4492-ba7b-cc33c3b8db61
18	75	Produção Científica	\N	0	\N	-1	f02c8749-274c-4492-ba7b-cc33c3b8db61
19	35		\N	0	\N	-1	28df2a70-de20-4c58-a5c8-e3c24e688cee
20	75	Produções Educacionais	\N	0	\N	-1	28df2a70-de20-4c58-a5c8-e3c24e688cee
2202	75	license.txt	\N	0	\N	-1	e67500f7-2f48-4894-816e-bd8d52c46382
2203	65	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	e67500f7-2f48-4894-816e-bd8d52c46382
23	35		\N	0	\N	-1	19737605-9de5-494c-b19e-7118aa37b963
24	75	Legislação	\N	0	\N	-1	19737605-9de5-494c-b19e-7118aa37b963
25	35		\N	0	\N	-1	f5a61cfd-721a-4eba-bf4f-4fa931159f12
26	75	Materiais Multimidia	\N	0	\N	-1	f5a61cfd-721a-4eba-bf4f-4fa931159f12
27	35		\N	0	\N	-1	bf82b5db-01cb-402c-81a9-8249ff7395a6
28	75	Políticas, Planejamento, Gestão e Projetos	\N	0	\N	-1	bf82b5db-01cb-402c-81a9-8249ff7395a6
29	35		\N	0	\N	-1	2aa863cf-c22a-4dae-8aed-2f08b702420a
30	75	Produção Científica	\N	0	\N	-1	2aa863cf-c22a-4dae-8aed-2f08b702420a
31	35		\N	0	\N	-1	d72bd580-c8d7-46af-ad71-ee7a50bbd582
32	75	Produções Educacionais	\N	0	\N	-1	d72bd580-c8d7-46af-ad71-ee7a50bbd582
2204	36	Submitted by Fábio Luís de Brito (britofa@paho.org) on 2019-05-14T19:16:43Z\nNo. of bitstreams: 0	en	0	\N	-1	ed4b6780-5f7d-429f-beab-eb44e6170bc9
35	35		\N	0	\N	-1	0607dd1b-5468-48ef-8905-8d07d253d1f7
36	75	Legislação	\N	0	\N	-1	0607dd1b-5468-48ef-8905-8d07d253d1f7
37	35		\N	0	\N	-1	d52095c9-d548-4f66-9dad-d84f4928ded7
38	75	Materiais Multimidia	\N	0	\N	-1	d52095c9-d548-4f66-9dad-d84f4928ded7
39	35		\N	0	\N	-1	f805ab68-cf57-431a-affc-8ce7f9778fe7
40	75	Políticas, Planejamento, Gestão e Projetos	\N	0	\N	-1	f805ab68-cf57-431a-affc-8ce7f9778fe7
41	35		\N	0	\N	-1	5f662caf-e96c-432e-8137-a17afe17283b
42	75	Produção Científica	\N	0	\N	-1	5f662caf-e96c-432e-8137-a17afe17283b
43	35		\N	0	\N	-1	fc9b46f8-dd31-4298-9f47-73af77f1c56d
44	75	Produções Educacionais	\N	0	\N	-1	fc9b46f8-dd31-4298-9f47-73af77f1c56d
1474	36	Made available in DSpace on 2019-05-07T17:33:01Z (GMT). No. of bitstreams: 1\nteste_upload.txt: 24 bytes, checksum: 8a40b4d31a53dd39dfa5b541022e09ce (MD5)\n  Previous issue date: 2019-06-01	en	1	\N	-1	b1c7cc22-a459-4f55-99cc-98fc7e9829cd
1463	34	Teste para upload	\N	0	\N	-1	910a3078-9fba-457e-a3d2-5a8a42a4a59b
2840	75	license.txt	\N	0	\N	-1	e61f61ed-6bf9-4e74-91be-f0bdf50bc671
2841	65	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	e61f61ed-6bf9-4e74-91be-f0bdf50bc671
49	35		\N	0	\N	-1	c32fae4a-fdfa-4498-a50a-bc9285fbb3a0
50	75	Legislação	\N	0	\N	-1	c32fae4a-fdfa-4498-a50a-bc9285fbb3a0
51	35		\N	0	\N	-1	8f327435-da4d-4bbe-99f2-df602eddf8fb
52	75	Materiais Multimidia	\N	0	\N	-1	8f327435-da4d-4bbe-99f2-df602eddf8fb
53	35		\N	0	\N	-1	b73c9ead-ff11-4e99-bcd0-86186ccd10aa
106	75	Produção Científica	\N	0	\N	-1	fbe5350a-c8ba-4a39-98e2-bd742a6be202
1464	63	http://creativecommons.org/publicdomain/zero/1.0/	*	0	\N	-1	b1c7cc22-a459-4f55-99cc-98fc7e9829cd
1465	62	CC0 1.0 Universal	*	0	\N	-1	b1c7cc22-a459-4f55-99cc-98fc7e9829cd
1466	75	LICENSE	\N	1	\N	-1	b46e66b6-fef8-4551-844b-f48b51f18887
1213	75	teste1.txt	\N	0	\N	-1	a4765167-b5ef-478c-a067-cd5dbcd6aceb
1214	65	teste1.txt	\N	0	\N	-1	a4765167-b5ef-478c-a067-cd5dbcd6aceb
1215	34	teste	\N	0	\N	-1	a4765167-b5ef-478c-a067-cd5dbcd6aceb
1467	75	license.txt	\N	0	\N	-1	9df5ca2c-3147-401a-9d3c-1638a6f02ad0
1468	65	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	9df5ca2c-3147-401a-9d3c-1638a6f02ad0
1469	36	Submitted by Fábio Luís de Brito (britofa@paho.org) on 2019-05-07T17:33:00Z\nNo. of bitstreams: 1\nteste_upload.txt: 24 bytes, checksum: 8a40b4d31a53dd39dfa5b541022e09ce (MD5)	en	0	\N	-1	b1c7cc22-a459-4f55-99cc-98fc7e9829cd
1470	33	http://rcfunasa.bvsalud.org//handle/123456789/358	\N	0	\N	-1	b1c7cc22-a459-4f55-99cc-98fc7e9829cd
1471	18	2019-05-07T17:33:01Z	\N	0	\N	-1	b1c7cc22-a459-4f55-99cc-98fc7e9829cd
1472	19	2019-05-07T17:33:01Z	\N	0	\N	-1	b1c7cc22-a459-4f55-99cc-98fc7e9829cd
1473	22	2019-06-01	\N	0	\N	-1	b1c7cc22-a459-4f55-99cc-98fc7e9829cd
2176	75	TESTE1 - Politicas	en_US	0	\N	-1	ed4b6780-5f7d-429f-beab-eb44e6170bc9
2177	76	TESTE1 - Politicas Titulo alternativo	en_US	0	\N	-1	ed4b6780-5f7d-429f-beab-eb44e6170bc9
2178	9	Carlos Gardel	en_US	0	\N	-1	ed4b6780-5f7d-429f-beab-eb44e6170bc9
2179	10	FUNASA	en_US	0	\N	-1	ed4b6780-5f7d-429f-beab-eb44e6170bc9
2191	52	Séries para Teste;1-6	\N	0	\N	-1	ed4b6780-5f7d-429f-beab-eb44e6170bc9
2192	64	FUNASA	en_US	0	\N	-1	ed4b6780-5f7d-429f-beab-eb44e6170bc9
2193	68	Vacinas contra Dengue	en_US	0	\N	-1	ed4b6780-5f7d-429f-beab-eb44e6170bc9
2194	68	Vacina BCG	en_US	1	\N	-1	ed4b6780-5f7d-429f-beab-eb44e6170bc9
2195	78	Apresentação	en_US	0	\N	-1	ed4b6780-5f7d-429f-beab-eb44e6170bc9
2196	78	Conjunto de dados / dados estatísticos	en_US	1	\N	-1	ed4b6780-5f7d-429f-beab-eb44e6170bc9
2197	78	Documento oficial	en_US	2	\N	-1	ed4b6780-5f7d-429f-beab-eb44e6170bc9
2198	78	Guia	en_US	3	\N	-1	ed4b6780-5f7d-429f-beab-eb44e6170bc9
54	75	Políticas, Planejamento, Gestão e Projetos	\N	0	\N	-1	b73c9ead-ff11-4e99-bcd0-86186ccd10aa
55	35		\N	0	\N	-1	fd415204-97cc-4568-938b-467f663aab73
56	75	Produção Científica	\N	0	\N	-1	fd415204-97cc-4568-938b-467f663aab73
57	35		\N	0	\N	-1	19cefe3e-817f-4584-8647-e1e0345ca422
58	75	Produções Educacionais	\N	0	\N	-1	19cefe3e-817f-4584-8647-e1e0345ca422
1698	75	Legislação	\N	0	\N	-1	3e935853-f1c6-47a7-9e22-2a457109ee60
1699	75	Materiais Multimidia	\N	0	\N	-1	70511c74-d0ea-42c8-8bbf-f8446f544022
2205	33	http://rcfunasa.bvsalud.org//handle/123456789/374	\N	0	\N	-1	ed4b6780-5f7d-429f-beab-eb44e6170bc9
63	35		\N	0	\N	-1	3bf97251-0d2c-497a-b1c0-2fb8f089d5d9
64	75	Legislação	\N	0	\N	-1	3bf97251-0d2c-497a-b1c0-2fb8f089d5d9
65	35		\N	0	\N	-1	24a1c3ff-d7a4-4e39-92ca-bbbd1ef02a13
66	75	Materiais Multimidia	\N	0	\N	-1	24a1c3ff-d7a4-4e39-92ca-bbbd1ef02a13
67	35		\N	0	\N	-1	60f00aaf-c385-4dcb-b9a4-ed59d23e3feb
68	75	Políticas, Planejamento, Gestão e Projetos	\N	0	\N	-1	60f00aaf-c385-4dcb-b9a4-ed59d23e3feb
69	35		\N	0	\N	-1	2a26db78-5987-40be-b908-a20da0086e8b
70	75	Produção Científica	\N	0	\N	-1	2a26db78-5987-40be-b908-a20da0086e8b
71	35		\N	0	\N	-1	4e7863f5-b198-47e4-8eb1-688af9155b78
72	75	Produções Educacionais	\N	0	\N	-1	4e7863f5-b198-47e4-8eb1-688af9155b78
2842	36	Submitted by Fábio Luís de Brito (britofa@paho.org) on 2019-09-23T16:33:08Z\nNo. of bitstreams: 0	en	0	\N	-1	e85ea3c1-9d09-4c0e-aaa8-33aca608cbb5
75	35		\N	0	\N	-1	b85655ce-7a32-438b-9211-a8b12ec6dcfd
76	75	Legislação	\N	0	\N	-1	b85655ce-7a32-438b-9211-a8b12ec6dcfd
77	35		\N	0	\N	-1	33d85721-7ff3-4926-ae80-084bb178dd97
78	75	Materiais Multimidia	\N	0	\N	-1	33d85721-7ff3-4926-ae80-084bb178dd97
79	35		\N	0	\N	-1	9a582dff-81aa-4021-9f30-f75871aeb9eb
80	75	Políticas, Planejamento, Gestão e Projetos	\N	0	\N	-1	9a582dff-81aa-4021-9f30-f75871aeb9eb
81	35		\N	0	\N	-1	681bb445-6fc8-49c1-9915-1d418f2ac4d1
82	75	Produção Científica	\N	0	\N	-1	681bb445-6fc8-49c1-9915-1d418f2ac4d1
83	35		\N	0	\N	-1	96f9e582-cb6e-441e-a361-97f5e69b8ff2
84	75	Produções Educacionais	\N	0	\N	-1	96f9e582-cb6e-441e-a361-97f5e69b8ff2
2209	36	Made available in DSpace on 2019-05-14T19:16:43Z (GMT). No. of bitstreams: 0\n  Previous issue date: 2019-01-01	en	1	\N	-1	ed4b6780-5f7d-429f-beab-eb44e6170bc9
2206	18	2019-05-14T19:16:43Z	\N	0	\N	-1	ed4b6780-5f7d-429f-beab-eb44e6170bc9
2207	19	2019-05-14T19:16:43Z	\N	0	\N	-1	ed4b6780-5f7d-429f-beab-eb44e6170bc9
2208	22	2019-01-01	\N	0	\N	-1	ed4b6780-5f7d-429f-beab-eb44e6170bc9
87	35		\N	0	\N	-1	88d41f3a-a149-4dc5-81a2-84380835533a
88	75	Legislação	\N	0	\N	-1	88d41f3a-a149-4dc5-81a2-84380835533a
89	35		\N	0	\N	-1	41b5c503-8ca0-435f-8103-3e692593b755
90	75	Materiais Multimidia	\N	0	\N	-1	41b5c503-8ca0-435f-8103-3e692593b755
91	35		\N	0	\N	-1	728d1b2f-f32f-4ba9-80ff-922deca5458b
92	75	Políticas, Planejamento, Gestão e Projetos	\N	0	\N	-1	728d1b2f-f32f-4ba9-80ff-922deca5458b
93	35		\N	0	\N	-1	a2561e5d-7cbf-464d-b6e6-6178bddd9bae
94	75	Produção Científica	\N	0	\N	-1	a2561e5d-7cbf-464d-b6e6-6178bddd9bae
95	35		\N	0	\N	-1	25c745b0-5b75-44bd-91fb-f468f52c377b
96	75	Produções Educacionais	\N	0	\N	-1	25c745b0-5b75-44bd-91fb-f468f52c377b
2843	33	http://rcfunasa.bvsalud.org//handle/123456789/380	\N	0	\N	-1	e85ea3c1-9d09-4c0e-aaa8-33aca608cbb5
99	35		\N	0	\N	-1	357da42e-ffb4-43f7-bb59-3b66f6d09b1f
100	75	Legislação	\N	0	\N	-1	357da42e-ffb4-43f7-bb59-3b66f6d09b1f
101	35		\N	0	\N	-1	8a52ac60-0cb5-4d6f-8b4c-a9cd65b62d0a
102	75	Materiais Multimidia	\N	0	\N	-1	8a52ac60-0cb5-4d6f-8b4c-a9cd65b62d0a
103	35		\N	0	\N	-1	d851294f-191c-46a0-abf4-d338042d5971
104	75	Políticas, Planejamento, Gestão e Projetos	\N	0	\N	-1	d851294f-191c-46a0-abf4-d338042d5971
105	35		\N	0	\N	-1	fbe5350a-c8ba-4a39-98e2-bd742a6be202
1700	75	Políticas, Planejamento, Gestão e Projetos	\N	0	\N	-1	7f76cd2d-725a-479d-999f-6581b07371ac
1701	75	Produção Científica	\N	0	\N	-1	90c56da0-ae13-4f05-aa67-be54c7bad83a
1702	75	Produções Educacionais	\N	0	\N	-1	d43aa0c1-4c5f-4c36-bf52-1df23a753b59
1233	75	teste2.txt	\N	0	\N	-1	56ac04cc-163d-4316-a0e3-a09dab85594d
1234	65	teste2.txt	\N	0	\N	-1	56ac04cc-163d-4316-a0e3-a09dab85594d
1703	75	Legislação	\N	0	\N	-1	65dac126-89fc-463c-ba18-63d827a920c5
1236	34	teste 2	\N	0	\N	-1	56ac04cc-163d-4316-a0e3-a09dab85594d
1704	75	Materiais Multimidia	\N	0	\N	-1	e8aa370e-19da-4d55-bb48-c53fff30c7b2
1705	75	Políticas, Planejamento, Gestão e Projetos	\N	0	\N	-1	907454e2-0671-4ddf-9725-3509a9c3a454
1706	75	Produção Científica	\N	0	\N	-1	1633cc84-63f4-4adf-986b-7da47de84bad
1707	75	Produções Educacionais	\N	0	\N	-1	a1e46639-3086-442e-a8ea-efcc9193e674
1457	68	Cabeça	en_US	0	\N	-1	b1c7cc22-a459-4f55-99cc-98fc7e9829cd
1458	68	Pescoço	en_US	1	\N	-1	b1c7cc22-a459-4f55-99cc-98fc7e9829cd
2520	62	Attribution-NonCommercial-NoDerivs 3.0 IGO	*	0	\N	-1	3bc2d4e3-6c4f-4e12-98c7-89b38012246f
2514	78	Publicação	en_US	0	\N	-1	3bc2d4e3-6c4f-4e12-98c7-89b38012246f
2515	75	ORIGINAL	\N	1	\N	-1	fe7ea1de-7497-4d64-93b5-a6b56d21eee8
2421	1	Fabio	\N	0	\N	-1	0d867733-f5ce-4f36-af20-f3f1359c3240
2422	2	Brito	\N	0	\N	-1	0d867733-f5ce-4f36-af20-f3f1359c3240
2423	3		\N	0	\N	-1	0d867733-f5ce-4f36-af20-f3f1359c3240
2521	75	LICENSE	\N	1	\N	-1	5bfb5579-17ed-4113-b850-5d52fe90f1f7
2516	75	san_ambiental.pdf	\N	0	\N	-1	73328566-b3cc-4516-a70f-3d7fe821151b
2517	65	san_ambiental.pdf	\N	0	\N	-1	73328566-b3cc-4516-a70f-3d7fe821151b
2518	34		\N	0	\N	-1	73328566-b3cc-4516-a70f-3d7fe821151b
2519	63	http://creativecommons.org/licenses/by-nc-nd/3.0/igo/	*	0	\N	-1	3bc2d4e3-6c4f-4e12-98c7-89b38012246f
2522	75	license.txt	\N	0	\N	-1	cf9c4758-a326-4605-b96c-86f858c213c6
2523	65	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	cf9c4758-a326-4605-b96c-86f858c213c6
2524	36	Submitted by Suellen Viriato Leite da Silva (suellen.silva@funasa.gov.br) on 2019-06-10T14:46:49Z\nNo. of bitstreams: 1\nsan_ambiental.pdf: 6347638 bytes, checksum: 691a771e7db0948af6a196954a367b22 (MD5)	en	0	\N	-1	3bc2d4e3-6c4f-4e12-98c7-89b38012246f
2525	33	http://rcfunasa.bvsalud.org//handle/123456789/377	\N	0	\N	-1	3bc2d4e3-6c4f-4e12-98c7-89b38012246f
107	35		\N	0	\N	-1	3afa7efe-2891-4c47-b396-c83d56ff9d90
108	75	Produções Educacionais	\N	0	\N	-1	3afa7efe-2891-4c47-b396-c83d56ff9d90
1955	75	TESTE - Sesión 01 de 10 - Análisis de contenido y principios de indización	en_US	0	\N	-1	b7cc4d08-a40f-4400-bca5-3039f8c965b3
1956	35	Sesiones virtuales con foco en la introducción al proceso de indización de documentos según Metodología LILACS.	en_US	0	\N	-1	b7cc4d08-a40f-4400-bca5-3039f8c965b3
1957	34	Esta capacitación es indicada a todo nuevo profesional de información que ingrese en la red pero también a los que ya actúan hace algunos años porque trae una visión detallada de las reglas y orientaciones que deben ser adoptadas en la práctica de indización en el area de salud, principalmente en LILACS y las fuentes de información de la BVS.\r\n\r\nLos videos consisten de las grabaciones de las sesiones virtuales que tuvieron la duración aproximada de 1 hora cada y fueran trasmitidas via Webex en 2017.	en_US	0	\N	-1	b7cc4d08-a40f-4400-bca5-3039f8c965b3
2847	36	Made available in DSpace on 2019-09-23T16:33:08Z (GMT). No. of bitstreams: 0\n  Previous issue date: 2019-09-23	en	1	\N	-1	e85ea3c1-9d09-4c0e-aaa8-33aca608cbb5
2844	18	2019-09-23T16:33:08Z	\N	0	\N	-1	e85ea3c1-9d09-4c0e-aaa8-33aca608cbb5
2382	75	1413-8123-csc-21-08-2326.pdf	\N	0	\N	-1	2966e974-c340-4197-94de-d6815d41bf0d
2845	19	2019-09-23T16:33:08Z	\N	0	\N	-1	e85ea3c1-9d09-4c0e-aaa8-33aca608cbb5
2846	22	2019-09-23	\N	0	\N	-1	e85ea3c1-9d09-4c0e-aaa8-33aca608cbb5
3021	78	Recurso Educativo		0	\N	-1	e15414f8-b998-4844-a3e6-fd616616a97d
117	35		\N	0	\N	-1	f2c7e15a-2db1-4099-9d26-78ba2c16b8da
118	75	Materiais Multimidia	\N	0	\N	-1	f2c7e15a-2db1-4099-9d26-78ba2c16b8da
119	35		\N	0	\N	-1	cd75101b-abb6-46ef-ac88-3af552f33478
120	75	Políticas, Planejamento, Gestão e Projetos	\N	0	\N	-1	cd75101b-abb6-46ef-ac88-3af552f33478
121	35		\N	0	\N	-1	b55202c0-1e3b-4eba-909d-54f7fad48b9c
122	75	Produção Científica	\N	0	\N	-1	b55202c0-1e3b-4eba-909d-54f7fad48b9c
123	35		\N	0	\N	-1	6ef94e51-16d7-4cec-9359-a94d499e8337
124	75	Produções Educacionais	\N	0	\N	-1	6ef94e51-16d7-4cec-9359-a94d499e8337
127	35		\N	0	\N	-1	411dd125-33df-451a-87c9-7dca418b665e
128	75	Legislação	\N	0	\N	-1	411dd125-33df-451a-87c9-7dca418b665e
129	35		\N	0	\N	-1	7db66edb-3f9f-4c24-8fa2-0a4b11efb0b8
130	75	Materiais Multimidia	\N	0	\N	-1	7db66edb-3f9f-4c24-8fa2-0a4b11efb0b8
131	35		\N	0	\N	-1	b2020a23-0063-4efe-b770-9c9a5a099b42
132	75	Políticas, Planejamento, Gestão e Projetos	\N	0	\N	-1	b2020a23-0063-4efe-b770-9c9a5a099b42
133	35		\N	0	\N	-1	6a8d7523-aace-4c61-9a7f-9133ae72d7b0
134	75	Produção Científica	\N	0	\N	-1	6a8d7523-aace-4c61-9a7f-9133ae72d7b0
135	35		\N	0	\N	-1	3449a99e-7799-4ba0-bd51-63ae8ee23093
136	75	Produções Educacionais	\N	0	\N	-1	3449a99e-7799-4ba0-bd51-63ae8ee23093
139	35		\N	0	\N	-1	1e0e772a-32a3-4fef-99c9-2aeab683bae2
140	75	Legislação	\N	0	\N	-1	1e0e772a-32a3-4fef-99c9-2aeab683bae2
141	35		\N	0	\N	-1	909a8161-d474-4b0e-afdc-5a5ae63c3a6c
142	75	Materiais Multimidia	\N	0	\N	-1	909a8161-d474-4b0e-afdc-5a5ae63c3a6c
143	35		\N	0	\N	-1	f6ed7993-8237-4ef0-9cc4-0573e90e75d2
144	75	Políticas, Planejamento, Gestão e Projetos	\N	0	\N	-1	f6ed7993-8237-4ef0-9cc4-0573e90e75d2
145	35		\N	0	\N	-1	66151470-c472-418e-a958-e93c235b10e4
146	75	Produção Científica	\N	0	\N	-1	66151470-c472-418e-a958-e93c235b10e4
147	35		\N	0	\N	-1	d46da801-96a5-42ca-90a0-0ed42a484f3b
148	75	Produções Educacionais	\N	0	\N	-1	d46da801-96a5-42ca-90a0-0ed42a484f3b
3022	78	Recurso Educativo		0	\N	-1	a9e375db-ed27-49a4-ab37-1f71e3344c07
153	35		\N	0	\N	-1	f3152358-78b0-495c-8086-12b8a7a6e7c4
154	75	Legislação	\N	0	\N	-1	f3152358-78b0-495c-8086-12b8a7a6e7c4
155	35		\N	0	\N	-1	87416815-8bb9-42a5-98eb-5aefce3bfbcf
156	75	Materiais Multimidia	\N	0	\N	-1	87416815-8bb9-42a5-98eb-5aefce3bfbcf
157	35		\N	0	\N	-1	24b8f080-dac2-454c-aba3-16201b523039
158	75	Políticas, Planejamento, Gestão e Projetos	\N	0	\N	-1	24b8f080-dac2-454c-aba3-16201b523039
2383	65	1413-8123-csc-21-08-2326.pdf	\N	0	\N	-1	2966e974-c340-4197-94de-d6815d41bf0d
2384	34		\N	0	\N	-1	2966e974-c340-4197-94de-d6815d41bf0d
1958	7	Funano	en_US	0	\N	-1	b7cc4d08-a40f-4400-bca5-3039f8c965b3
2381	75	ORIGINAL	\N	1	\N	-1	b6a93f95-1b06-48ac-8422-c0ff627bc780
1959	10	Bireme	en_US	0	\N	-1	b7cc4d08-a40f-4400-bca5-3039f8c965b3
1961	179	Recurso de aprendizagem	en_US	0	\N	-1	b7cc4d08-a40f-4400-bca5-3039f8c965b3
1962	47	pt	en_US	0	\N	-1	b7cc4d08-a40f-4400-bca5-3039f8c965b3
1963	47	en	en_US	1	\N	-1	b7cc4d08-a40f-4400-bca5-3039f8c965b3
1964	178	Módulo	en_US	0	\N	-1	b7cc4d08-a40f-4400-bca5-3039f8c965b3
1965	171	Ilustração	en_US	0	\N	-1	b7cc4d08-a40f-4400-bca5-3039f8c965b3
1966	166	Alto	en_US	0	\N	-1	b7cc4d08-a40f-4400-bca5-3039f8c965b3
1967	181	Treinamento em serviço	en_US	0	\N	-1	b7cc4d08-a40f-4400-bca5-3039f8c965b3
1968	167	Médio	en_US	0	\N	-1	b7cc4d08-a40f-4400-bca5-3039f8c965b3
1969	168	2	en_US	0	\N	-1	b7cc4d08-a40f-4400-bca5-3039f8c965b3
159	35		\N	0	\N	-1	e666ae2f-259c-4fff-8884-df1c6401bbf9
160	75	Produção Científica	\N	0	\N	-1	e666ae2f-259c-4fff-8884-df1c6401bbf9
161	35		\N	0	\N	-1	289a3f50-e20c-442b-b1af-a6dc0e973bd5
162	75	Produções Educacionais	\N	0	\N	-1	289a3f50-e20c-442b-b1af-a6dc0e973bd5
1722	75	01.Saneamento	\N	0	\N	-1	683bfc83-3cc1-4f22-83d3-c9ee4ea2c82b
1723	75	01.01.Universalização das Ações de Saneamento	\N	0	\N	-1	435bcf56-d368-4f2f-8e7f-4bafd3367063
165	35		\N	0	\N	-1	efa858af-f6b2-44c4-abf0-e469f1353d10
166	75	Legislação	\N	0	\N	-1	efa858af-f6b2-44c4-abf0-e469f1353d10
167	35		\N	0	\N	-1	1ba431f3-259a-4751-9ae9-22d5a110ae53
168	75	Materiais Multimidia	\N	0	\N	-1	1ba431f3-259a-4751-9ae9-22d5a110ae53
169	35		\N	0	\N	-1	3011dd24-c2db-46ef-b5d1-895e38d9b930
170	75	Políticas, Planejamento, Gestão e Projetos	\N	0	\N	-1	3011dd24-c2db-46ef-b5d1-895e38d9b930
171	35		\N	0	\N	-1	110adbb2-e44d-4c83-80e6-d404b4741ed4
172	75	Produção Científica	\N	0	\N	-1	110adbb2-e44d-4c83-80e6-d404b4741ed4
173	35		\N	0	\N	-1	9683b122-799f-4d4e-92b8-8f57283e964f
174	75	Produções Educacionais	\N	0	\N	-1	9683b122-799f-4d4e-92b8-8f57283e964f
1724	75	01.01.01.Saneamento Rural	\N	0	\N	-1	f0cb7fe8-e5c5-4d33-9530-b38f96535074
1725	75	01.01.02.Saneamento Urbano	\N	0	\N	-1	342ea849-01c8-41cd-b812-44638b5c22ef
177	35		\N	0	\N	-1	043d9a3f-684c-4fc2-a642-4df251ff0ce6
178	75	03.01.Edificações para Saúde (Laboratórios para CQA)	\N	0	\N	-1	043d9a3f-684c-4fc2-a642-4df251ff0ce6
179	35		\N	0	\N	-1	995b6a10-b9dc-4f43-bd81-b6249cd8b191
180	75	Legislação	\N	0	\N	-1	995b6a10-b9dc-4f43-bd81-b6249cd8b191
181	35		\N	0	\N	-1	617031b7-af6b-4fa3-9644-dc5ade438caf
182	75	Materiais Multimidia	\N	0	\N	-1	617031b7-af6b-4fa3-9644-dc5ade438caf
183	35		\N	0	\N	-1	5b1045d7-6c9e-4446-ae09-6831ea31e1cc
184	75	Políticas, Planejamento, Gestão e Projetos	\N	0	\N	-1	5b1045d7-6c9e-4446-ae09-6831ea31e1cc
185	35		\N	0	\N	-1	0a4d3518-c6fa-4a84-bec3-453eafd845b7
186	75	Produção Científica	\N	0	\N	-1	0a4d3518-c6fa-4a84-bec3-453eafd845b7
187	35		\N	0	\N	-1	c513be3f-2789-46b7-bc33-0feea0e7e628
188	75	Produções Educacionais	\N	0	\N	-1	c513be3f-2789-46b7-bc33-0feea0e7e628
189	35		\N	0	\N	-1	54def7e9-b01c-4405-831b-f55d391bc8db
190	75	03.02.Melhorias Sanitárias Domiciliares - MSD	\N	0	\N	-1	54def7e9-b01c-4405-831b-f55d391bc8db
191	35		\N	0	\N	-1	5539833b-6142-452e-bea3-fc373b058c14
192	75	Legislação	\N	0	\N	-1	5539833b-6142-452e-bea3-fc373b058c14
193	35		\N	0	\N	-1	ef2b53fa-b6fb-4962-a523-53ff8c1e65fa
194	75	Materiais Multimidia	\N	0	\N	-1	ef2b53fa-b6fb-4962-a523-53ff8c1e65fa
195	35		\N	0	\N	-1	701fb3d8-8ea8-43b9-ad0a-27e0a053f41f
196	75	Políticas, Planejamento, Gestão e Projetos	\N	0	\N	-1	701fb3d8-8ea8-43b9-ad0a-27e0a053f41f
197	35		\N	0	\N	-1	82ad2994-8a8a-4734-8924-089e49902749
198	75	Produção Científica	\N	0	\N	-1	82ad2994-8a8a-4734-8924-089e49902749
199	35		\N	0	\N	-1	3004c43c-f694-4d5d-bc56-d89e562d8810
200	75	Produções Educacionais	\N	0	\N	-1	3004c43c-f694-4d5d-bc56-d89e562d8810
201	35		\N	0	\N	-1	0122bff8-45c5-4403-9af8-4d92e63bf462
202	75	03.03.Melhorias Habitacionais para o Controle da Doença de Chagas - MHCDC	\N	0	\N	-1	0122bff8-45c5-4403-9af8-4d92e63bf462
203	35		\N	0	\N	-1	2255af62-ea0f-441e-8cef-c95a842d0c8f
204	75	Legislação	\N	0	\N	-1	2255af62-ea0f-441e-8cef-c95a842d0c8f
205	35		\N	0	\N	-1	5f35338b-62e5-48be-9737-7ec419eb9fc9
206	75	Materiais Multimidia	\N	0	\N	-1	5f35338b-62e5-48be-9737-7ec419eb9fc9
207	35		\N	0	\N	-1	beaabaf0-bfc2-411f-9a6d-e6135d699097
208	75	Políticas, Planejamento, Gestão e Projetos	\N	0	\N	-1	beaabaf0-bfc2-411f-9a6d-e6135d699097
209	35		\N	0	\N	-1	ee0feefe-84c4-4d99-b69c-06445074d7ff
210	75	Produção Científica	\N	0	\N	-1	ee0feefe-84c4-4d99-b69c-06445074d7ff
1726	75	01.02.Comunidades Tradicionais (Quilombolas, Ribeirinhos, Extrativistas e Assentamentos)	\N	0	\N	-1	e88afa75-f030-4a94-8c91-72257614e295
1727	75	01.03.Resíduos Sólidos	\N	0	\N	-1	7709d357-75c7-4039-bfcf-f2297e7493e9
1728	75	01.03.01.Apoio a Catadores	\N	0	\N	-1	e43ea389-e3e6-410b-bbc3-75bce3a6474f
1729	75	01.03.02.Coleta e Manejo de Resíduos Sólidos	\N	0	\N	-1	08285b26-0b55-48c0-aae2-bd4c60dece4b
1246	75	04.Cooperações Técnicas Nacionais e Internacionais	\N	0	\N	-1	f7af0744-1ec4-437f-88db-205b9666f652
1730	75	02.Saúde Ambiental	\N	0	\N	-1	ea38e67d-c827-487c-b429-13be16d4a6c5
1247	75	05.Gestão Administrativa e Estratégica	\N	0	\N	-1	a6dbaa98-ed1f-40f8-bdf9-8822d64a800d
1731	75	02.01.Educação em Saúde Ambiental	\N	0	\N	-1	e13aa597-d0ce-44df-a774-e65c5b8ce61c
1732	75	02.02.Ações e Projetos Estratégicos	\N	0	\N	-1	0c873029-343e-4740-bd26-c976c9b2c6c2
1733	75	02.03.Água para Consumo Humano	\N	0	\N	-1	050033bb-42bb-4d2e-be49-3bb13979f6b3
1734	75	02.01.01.Recurso metodológicos e Pedagógicos	\N	0	\N	-1	62cb0c79-b578-470b-9e81-6a712fea7281
1735	75	02.02.01.Territórios Saudáveis e Sustentáveis	\N	0	\N	-1	1f757c54-5850-4cbe-ae02-284cfaccc1e7
1736	75	02.02.03.Remediar	\N	0	\N	-1	b09f6eb0-f79f-489a-a7e8-bb87486bc1b2
1970	180	Gestor	en_US	0	\N	-1	b7cc4d08-a40f-4400-bca5-3039f8c965b3
1971	180	Pesquisador	en_US	1	\N	-1	b7cc4d08-a40f-4400-bca5-3039f8c965b3
1972	180	Outros	en_US	2	\N	-1	b7cc4d08-a40f-4400-bca5-3039f8c965b3
1973	62	Atribuição CC BY	en_US	0	\N	-1	b7cc4d08-a40f-4400-bca5-3039f8c965b3
1974	48	Bla bla	en_US	0	\N	-1	b7cc4d08-a40f-4400-bca5-3039f8c965b3
1975	68	Materiais de Ensino	en_US	0	\N	-1	b7cc4d08-a40f-4400-bca5-3039f8c965b3
1976	68	Instituições de Ensino Superior	en_US	1	\N	-1	b7cc4d08-a40f-4400-bca5-3039f8c965b3
1977	43	10 minutos	en_US	0	\N	-1	b7cc4d08-a40f-4400-bca5-3039f8c965b3
1978	169	Acesso à internet	en_US	0	\N	-1	b7cc4d08-a40f-4400-bca5-3039f8c965b3
1979	170	1 semana	en_US	0	\N	-1	b7cc4d08-a40f-4400-bca5-3039f8c965b3
1980	174	123456789/371	\N	0	\N	-1	b7cc4d08-a40f-4400-bca5-3039f8c965b3
1981	163	_F2_Fb23uPA	en_US	0	\N	-1	b7cc4d08-a40f-4400-bca5-3039f8c965b3
211	35		\N	0	\N	-1	1f9d14c8-64db-41c2-9867-9641e5d112b1
212	75	Produções Educacionais	\N	0	\N	-1	1f9d14c8-64db-41c2-9867-9641e5d112b1
213	35		\N	0	\N	-1	c338e24b-54ce-439e-80fb-6aea64047d8c
214	75	03.04.Apoio a Gestão dos Serviços Municipais de Saneamento	\N	0	\N	-1	c338e24b-54ce-439e-80fb-6aea64047d8c
215	35		\N	0	\N	-1	58411222-09a0-4a4c-a0aa-a16fed8c8057
216	75	03.04.01.Gestão Estruturada	\N	0	\N	-1	58411222-09a0-4a4c-a0aa-a16fed8c8057
217	35		\N	0	\N	-1	4ee1cee2-a251-4b2d-9205-e12ad4a8499a
218	75	Legislação	\N	0	\N	-1	4ee1cee2-a251-4b2d-9205-e12ad4a8499a
219	35		\N	0	\N	-1	8380299d-ae45-4b0b-bab1-3f2769dfdca8
220	75	Materiais Multimidia	\N	0	\N	-1	8380299d-ae45-4b0b-bab1-3f2769dfdca8
221	35		\N	0	\N	-1	f4897015-28c0-46b4-9b1c-0312bbe14f19
222	75	Políticas, Planejamento, Gestão e Projetos	\N	0	\N	-1	f4897015-28c0-46b4-9b1c-0312bbe14f19
223	35		\N	0	\N	-1	cf051540-fc52-47a6-9247-7cca3089b0d2
224	75	Produção Científica	\N	0	\N	-1	cf051540-fc52-47a6-9247-7cca3089b0d2
225	35		\N	0	\N	-1	0f8aee5b-53cc-46b2-af21-4b7fea33f4a8
226	75	Produções Educacionais	\N	0	\N	-1	0f8aee5b-53cc-46b2-af21-4b7fea33f4a8
227	35		\N	0	\N	-1	131515f5-0c56-4276-94dd-054d41a4f959
228	75	03.04.02.Gestão Não Estruturada	\N	0	\N	-1	131515f5-0c56-4276-94dd-054d41a4f959
229	35		\N	0	\N	-1	2db4aa27-37b4-454e-86d1-24dd3185a968
230	75	Legislação	\N	0	\N	-1	2db4aa27-37b4-454e-86d1-24dd3185a968
231	35		\N	0	\N	-1	6fbf8d40-a83f-4977-bf0f-2fbdc397a975
232	75	Materiais Multimidia	\N	0	\N	-1	6fbf8d40-a83f-4977-bf0f-2fbdc397a975
233	35		\N	0	\N	-1	7e531fe1-bf4a-4d2e-a697-b8ccaf587377
234	75	Políticas, Planejamento, Gestão e Projetos	\N	0	\N	-1	7e531fe1-bf4a-4d2e-a697-b8ccaf587377
235	35		\N	0	\N	-1	e6dd595d-9bc9-4ec0-a594-1e9c8d541133
236	75	Produção Científica	\N	0	\N	-1	e6dd595d-9bc9-4ec0-a594-1e9c8d541133
237	35		\N	0	\N	-1	f8f0c20b-e38b-47ee-8788-2c675649e67c
238	75	Produções Educacionais	\N	0	\N	-1	f8f0c20b-e38b-47ee-8788-2c675649e67c
239	35		\N	0	\N	-1	265b2c85-db13-4fe1-ab54-4134f76d252b
240	75	03.04.03.Gestão Consorciada	\N	0	\N	-1	265b2c85-db13-4fe1-ab54-4134f76d252b
241	35		\N	0	\N	-1	4e77e1c7-3c74-4ced-ba10-bad97ecd405d
242	75	Legislação	\N	0	\N	-1	4e77e1c7-3c74-4ced-ba10-bad97ecd405d
243	35		\N	0	\N	-1	3bbcfa02-d7d2-4733-9f3d-45ad29a8117a
244	75	Materiais Multimidia	\N	0	\N	-1	3bbcfa02-d7d2-4733-9f3d-45ad29a8117a
245	35		\N	0	\N	-1	cd65d599-6ac3-470c-9eb6-75f9aed99357
246	75	Políticas, Planejamento, Gestão e Projetos	\N	0	\N	-1	cd65d599-6ac3-470c-9eb6-75f9aed99357
247	35		\N	0	\N	-1	9f225cd4-4db1-4fb2-b976-ea4e9ae18656
248	75	Produção Científica	\N	0	\N	-1	9f225cd4-4db1-4fb2-b976-ea4e9ae18656
249	35		\N	0	\N	-1	f2af2366-3fec-449c-9571-fe170605a28e
250	75	Produções Educacionais	\N	0	\N	-1	f2af2366-3fec-449c-9571-fe170605a28e
251	35		\N	0	\N	-1	777e1210-3ec0-459a-aca6-29b715063e73
252	75	03.05.Drenagem e Manejo Ambiental (Áreas Endêmicas de Malária)	\N	0	\N	-1	777e1210-3ec0-459a-aca6-29b715063e73
253	35		\N	0	\N	-1	ea7f0fea-6dd7-4907-beef-d60d62f7a0d9
254	75	Legislação	\N	0	\N	-1	ea7f0fea-6dd7-4907-beef-d60d62f7a0d9
255	35		\N	0	\N	-1	79f9afe4-97a6-42a4-a906-f80f360ad656
256	75	Materiais Multimidia	\N	0	\N	-1	79f9afe4-97a6-42a4-a906-f80f360ad656
257	35		\N	0	\N	-1	828c145d-a069-48d4-857b-9ee667d38c68
258	75	Políticas, Planejamento, Gestão e Projetos	\N	0	\N	-1	828c145d-a069-48d4-857b-9ee667d38c68
259	35		\N	0	\N	-1	ac22c96b-12db-4e4a-82c9-63e1c5af3de3
260	75	Produção Científica	\N	0	\N	-1	ac22c96b-12db-4e4a-82c9-63e1c5af3de3
261	35		\N	0	\N	-1	f68dd0f4-475b-4b2d-9cd1-8236b29ff7b4
262	75	Produções Educacionais	\N	0	\N	-1	f68dd0f4-475b-4b2d-9cd1-8236b29ff7b4
1248	75	06.História Institucional (Antecedentes Históricos)	\N	0	\N	-1	04ae4009-f11b-486e-929a-2512280f4227
1250	75	08.Programa Nacional de Saneamento Rural (PNSR)	\N	0	\N	-1	5e8bca7b-a019-4138-9939-7951646ad23c
1252	144	YwxGSyYGXT0		0	\N	-1	1f0c95ab-3775-4094-b293-183d3b5074b2
1737	75	02.02.02.Apoio as situações de Vulnerabilidade e Risco a Saúde.	\N	0	\N	-1	e8be30cd-3daa-4118-8548-8731d7495020
1738	75	02.03.01 Qualidade da água	\N	0	\N	-1	bf24224f-e566-4c37-a5f1-27a1867114e6
1739	75	02.03.02.Segurança da água	\N	0	\N	-1	ca5ff7d4-3470-4ef2-90ca-dc563214be58
1740	75	02.03.03.Tratamento da água	\N	0	\N	-1	7a290d59-1bed-4a4f-a6a1-02e191774a8f
1741	75	02.03.04.Estruturas para Controle da qualidade da água	\N	0	\N	-1	6c5dd78a-94ba-4ba9-ba37-401a80442dd5
1982	75	LICENSE	\N	1	\N	-1	50ffad89-623b-41e4-986a-c3a2feaade8c
1743	75	03.Engenharia de Saúde Pública	\N	0	\N	-1	6805171d-b16f-46e4-b7a1-2d91aafb9037
1983	75	license.txt	\N	0	\N	-1	ddbfcf61-6825-46a0-afe5-f307b4bdefe9
2689	75	Legislação	\N	0	\N	-1	c087e9be-29f7-437f-b0da-bddb0b2ab183
263	35		\N	0	\N	-1	6599bbd5-7809-439a-85d2-dd0c607838cc
264	75	03.06.Hidrogeologia	\N	0	\N	-1	6599bbd5-7809-439a-85d2-dd0c607838cc
265	35		\N	0	\N	-1	8742eb33-87b7-4f31-8ed8-be8788d16368
266	75	Legislação	\N	0	\N	-1	8742eb33-87b7-4f31-8ed8-be8788d16368
267	35		\N	0	\N	-1	048560cc-de2b-4693-969c-61d493365d18
268	75	Materiais Multimidia	\N	0	\N	-1	048560cc-de2b-4693-969c-61d493365d18
269	35		\N	0	\N	-1	bb4c6911-03b5-480e-819e-6a760460e9a1
270	75	Políticas, Planejamento, Gestão e Projetos	\N	0	\N	-1	bb4c6911-03b5-480e-819e-6a760460e9a1
271	35		\N	0	\N	-1	893f8288-3bfe-4656-9c84-4fbb6f695849
272	75	Produção Científica	\N	0	\N	-1	893f8288-3bfe-4656-9c84-4fbb6f695849
273	35		\N	0	\N	-1	2f7c5598-12bd-41ee-a1f4-625b8d93f2ef
274	75	Produções Educacionais	\N	0	\N	-1	2f7c5598-12bd-41ee-a1f4-625b8d93f2ef
2352	75	Solução Alternativa de Tratamento de Água (Salta-z)	en_US	0	\N	-1	1446271c-d93d-42dc-a7ba-a6ca384b4448
2353	9	Alberto Venturieri	en_US	0	\N	-1	1446271c-d93d-42dc-a7ba-a6ca384b4448
277	35		\N	0	\N	-1	4de09263-c707-4a67-b45a-f9de6a6edac0
278	75	04.01.Cooperações multilaterais	\N	0	\N	-1	4de09263-c707-4a67-b45a-f9de6a6edac0
279	35		\N	0	\N	-1	7590066c-de6e-4a65-9565-25e1bd3b87f6
280	75	04.01.01.OPAS	\N	0	\N	-1	7590066c-de6e-4a65-9565-25e1bd3b87f6
281	35		\N	0	\N	-1	90601c90-b68b-4ea2-8b12-e13ccc6eb0e5
282	75	Legislação	\N	0	\N	-1	90601c90-b68b-4ea2-8b12-e13ccc6eb0e5
283	35		\N	0	\N	-1	673a6a9d-1cdd-4613-ac3b-1814c8831656
284	75	Materiais Multimidia	\N	0	\N	-1	673a6a9d-1cdd-4613-ac3b-1814c8831656
285	35		\N	0	\N	-1	f9de8b0b-92ab-4726-9a25-387f0a8d2720
286	75	Políticas, Planejamento, Gestão e Projetos	\N	0	\N	-1	f9de8b0b-92ab-4726-9a25-387f0a8d2720
287	35		\N	0	\N	-1	9611172c-b2e0-4bfa-8f3c-57d9f82bb480
288	75	Produção Científica	\N	0	\N	-1	9611172c-b2e0-4bfa-8f3c-57d9f82bb480
289	35		\N	0	\N	-1	22b91317-4740-4caa-bb89-5a45c9c311f3
290	75	Produções Educacionais	\N	0	\N	-1	22b91317-4740-4caa-bb89-5a45c9c311f3
291	35		\N	0	\N	-1	01bf637b-7e76-4610-88b6-b85270d50e0c
292	75	04.01.02.OEI	\N	0	\N	-1	01bf637b-7e76-4610-88b6-b85270d50e0c
293	35		\N	0	\N	-1	645f03ae-c3bd-4ff3-94c3-31acc342036c
294	75	Legislação	\N	0	\N	-1	645f03ae-c3bd-4ff3-94c3-31acc342036c
295	35		\N	0	\N	-1	4f1937a8-4952-4ad7-8517-a3b777ef3ed7
296	75	Materiais Multimidia	\N	0	\N	-1	4f1937a8-4952-4ad7-8517-a3b777ef3ed7
297	35		\N	0	\N	-1	9c1f759e-1c23-443e-b601-dd4b5a867d98
298	75	Políticas, Planejamento, Gestão e Projetos	\N	0	\N	-1	9c1f759e-1c23-443e-b601-dd4b5a867d98
299	35		\N	0	\N	-1	eb746f42-f39e-484c-8ad7-51b355b7f227
300	75	Produção Científica	\N	0	\N	-1	eb746f42-f39e-484c-8ad7-51b355b7f227
301	35		\N	0	\N	-1	a6ba185b-3885-4be2-9bb5-dc61de428543
302	75	Produções Educacionais	\N	0	\N	-1	a6ba185b-3885-4be2-9bb5-dc61de428543
303	35		\N	0	\N	-1	927e147b-5d98-4bc8-be35-941cdaf90018
304	75	04.01.03.IFEH	\N	0	\N	-1	927e147b-5d98-4bc8-be35-941cdaf90018
305	35		\N	0	\N	-1	c5d79dda-0dfe-4acb-ba9b-b9850715b7f5
306	75	Legislação	\N	0	\N	-1	c5d79dda-0dfe-4acb-ba9b-b9850715b7f5
307	35		\N	0	\N	-1	a44d06ae-fd12-4b30-b17e-24944c917470
308	75	Materiais Multimidia	\N	0	\N	-1	a44d06ae-fd12-4b30-b17e-24944c917470
309	35		\N	0	\N	-1	f38cddca-d777-4d6b-b104-867d27969d2a
310	75	Políticas, Planejamento, Gestão e Projetos	\N	0	\N	-1	f38cddca-d777-4d6b-b104-867d27969d2a
311	35		\N	0	\N	-1	48de73ab-3a92-4c08-a1ae-4c7cf43e8341
312	75	Produção Científica	\N	0	\N	-1	48de73ab-3a92-4c08-a1ae-4c7cf43e8341
313	35		\N	0	\N	-1	a89ae057-da72-458a-8b54-c2c01c59633e
314	75	Produções Educacionais	\N	0	\N	-1	a89ae057-da72-458a-8b54-c2c01c59633e
315	35		\N	0	\N	-1	1f1e123d-71ba-45d8-a436-9866334f6679
1575	75	LICENSE	\N	1	\N	-1	6c09d5c6-7db2-4d59-a23c-a0cff7ea31da
1984	65	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	ddbfcf61-6825-46a0-afe5-f307b4bdefe9
1576	75	license.txt	\N	0	\N	-1	fa9b00c5-369d-4db7-bec8-45627225438d
1577	65	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	fa9b00c5-369d-4db7-bec8-45627225438d
2354	10	Fundação Nacional de Saúde	en_US	0	\N	-1	1446271c-d93d-42dc-a7ba-a6ca384b4448
2355	35	Imagem da experiência inovadora, Solução Alternativa de Tratamento de Água (Salta-z), desenvolvida pela Superintendência Estadual da Funasa no Pará (Suest/PA). Tecnologia Salta-z implementada na Comunidade Ilha do Maracujá no estado do Pará	en_US	0	\N	-1	1446271c-d93d-42dc-a7ba-a6ca384b4448
1985	36	Submitted by Fábio Luís de Brito (britofa@paho.org) on 2019-05-10T13:20:05Z\nNo. of bitstreams: 0	en	0	\N	-1	b7cc4d08-a40f-4400-bca5-3039f8c965b3
1986	33	http://rcfunasa.bvsalud.org//handle/123456789/372	\N	0	\N	-1	b7cc4d08-a40f-4400-bca5-3039f8c965b3
2356	152	Brasil	en_US	0	\N	-1	1446271c-d93d-42dc-a7ba-a6ca384b4448
2357	153	Pará	en_US	0	\N	-1	1446271c-d93d-42dc-a7ba-a6ca384b4448
2358	154	Comunidade Ilha do Maracujá	en_US	0	\N	-1	1446271c-d93d-42dc-a7ba-a6ca384b4448
2359	78	Fotografia	en_US	0	\N	-1	1446271c-d93d-42dc-a7ba-a6ca384b4448
1990	36	Made available in DSpace on 2019-05-10T13:20:05Z (GMT). No. of bitstreams: 0\n  Previous issue date: 2017-01-01	en	1	\N	-1	b7cc4d08-a40f-4400-bca5-3039f8c965b3
1987	18	2019-05-10T13:20:05Z	\N	0	\N	-1	b7cc4d08-a40f-4400-bca5-3039f8c965b3
1988	19	2019-05-10T13:20:05Z	\N	0	\N	-1	b7cc4d08-a40f-4400-bca5-3039f8c965b3
1989	22	2017-01-01	\N	0	\N	-1	b7cc4d08-a40f-4400-bca5-3039f8c965b3
2361	51	http://www.funasa.gov.br/todas-as-noticias/-/asset_publisher/lpnzx3bJYv7G/content/salta-z-e-selecionado-para-concorrer-premio-municiencia/pop_up?inheritRedirect=false	en_US	0	\N	-1	1446271c-d93d-42dc-a7ba-a6ca384b4448
316	75	04.02.Cooperações bilaterais	\N	0	\N	-1	1f1e123d-71ba-45d8-a436-9866334f6679
317	35		\N	0	\N	-1	4a04d20c-9629-456f-a426-cc82d587d3cb
318	75	04.02.01.Suiça	\N	0	\N	-1	4a04d20c-9629-456f-a426-cc82d587d3cb
319	35		\N	0	\N	-1	b824b5fd-76a7-4fd8-87a3-6d2942b62eb0
320	75	Legislação	\N	0	\N	-1	b824b5fd-76a7-4fd8-87a3-6d2942b62eb0
321	35		\N	0	\N	-1	40a29a62-25aa-491f-8791-ec96017b4e12
322	75	Materiais Multimidia	\N	0	\N	-1	40a29a62-25aa-491f-8791-ec96017b4e12
323	35		\N	0	\N	-1	79922945-f438-4446-bc33-6565320adebf
324	75	Políticas, Planejamento, Gestão e Projetos	\N	0	\N	-1	79922945-f438-4446-bc33-6565320adebf
325	35		\N	0	\N	-1	63035ee2-cc1c-4302-9d66-ebf6901744a4
326	75	Produção Científica	\N	0	\N	-1	63035ee2-cc1c-4302-9d66-ebf6901744a4
327	35		\N	0	\N	-1	c1a15047-56a4-43bf-aaf6-fd0e6477f98f
328	75	Produções Educacionais	\N	0	\N	-1	c1a15047-56a4-43bf-aaf6-fd0e6477f98f
329	35		\N	0	\N	-1	fa19502e-672d-4ce0-b465-111ab855321a
330	75	04.02.02.Itália	\N	0	\N	-1	fa19502e-672d-4ce0-b465-111ab855321a
331	35		\N	0	\N	-1	70366e28-2101-47c1-abc4-3711331158f2
332	75	Legislação	\N	0	\N	-1	70366e28-2101-47c1-abc4-3711331158f2
333	35		\N	0	\N	-1	4a253056-b197-44af-b8e6-13f826ad9a22
334	75	Materiais Multimidia	\N	0	\N	-1	4a253056-b197-44af-b8e6-13f826ad9a22
335	35		\N	0	\N	-1	d3b46df8-f992-4cc2-824c-1efbbd369775
336	75	Políticas, Planejamento, Gestão e Projetos	\N	0	\N	-1	d3b46df8-f992-4cc2-824c-1efbbd369775
337	35		\N	0	\N	-1	5eff5609-7edc-4d4f-98d3-a7a561862a93
338	75	Produção Científica	\N	0	\N	-1	5eff5609-7edc-4d4f-98d3-a7a561862a93
339	35		\N	0	\N	-1	fdae48ca-2993-46f9-b543-c623e2f23a28
340	75	Produções Educacionais	\N	0	\N	-1	fdae48ca-2993-46f9-b543-c623e2f23a28
341	35		\N	0	\N	-1	68c53a2c-0fd6-42a1-9c67-3387ebe11972
342	75	04.03.Cooperações Sul-Sul	\N	0	\N	-1	68c53a2c-0fd6-42a1-9c67-3387ebe11972
343	35		\N	0	\N	-1	5a2d5225-d585-4549-8758-a2c186dcb42a
344	75	04.03.01.Palestina	\N	0	\N	-1	5a2d5225-d585-4549-8758-a2c186dcb42a
345	35		\N	0	\N	-1	8d1bb197-7f21-44c8-8b4f-1aa584dcc189
346	75	Legislação	\N	0	\N	-1	8d1bb197-7f21-44c8-8b4f-1aa584dcc189
347	35		\N	0	\N	-1	6a4f724e-ee9e-41c4-9418-275558f5b865
348	75	Materiais Multimidia	\N	0	\N	-1	6a4f724e-ee9e-41c4-9418-275558f5b865
349	35		\N	0	\N	-1	84d45869-0e52-4f3c-8468-7419f86c5727
350	75	Políticas, Planejamento, Gestão e Projetos	\N	0	\N	-1	84d45869-0e52-4f3c-8468-7419f86c5727
351	35		\N	0	\N	-1	9a4df270-972f-4ab6-9fb0-5f96e79db5da
352	75	Produção Científica	\N	0	\N	-1	9a4df270-972f-4ab6-9fb0-5f96e79db5da
353	35		\N	0	\N	-1	0daedcc9-d2b3-4833-bfe4-a0eeaee838b2
354	75	Produções Educacionais	\N	0	\N	-1	0daedcc9-d2b3-4833-bfe4-a0eeaee838b2
355	35		\N	0	\N	-1	e062cd7e-5965-432f-89e4-7d30ea154e87
356	75	04.03.02.Haiti	\N	0	\N	-1	e062cd7e-5965-432f-89e4-7d30ea154e87
357	35		\N	0	\N	-1	44560ab4-adc2-443e-a599-1a440bfc5c48
358	75	Legislação	\N	0	\N	-1	44560ab4-adc2-443e-a599-1a440bfc5c48
359	35		\N	0	\N	-1	640da60a-12ee-48e4-90d5-9d3609e18051
360	75	Materiais Multimidia	\N	0	\N	-1	640da60a-12ee-48e4-90d5-9d3609e18051
361	35		\N	0	\N	-1	8db9f9d0-d195-407a-923d-a0de4a20bfed
362	75	Políticas, Planejamento, Gestão e Projetos	\N	0	\N	-1	8db9f9d0-d195-407a-923d-a0de4a20bfed
363	35		\N	0	\N	-1	85683df6-16a7-4ded-b5fd-74f04e3b8080
364	75	Produção Científica	\N	0	\N	-1	85683df6-16a7-4ded-b5fd-74f04e3b8080
365	35		\N	0	\N	-1	bdb6f30c-459c-48a3-ac6f-1a861a004953
366	75	Produções Educacionais	\N	0	\N	-1	bdb6f30c-459c-48a3-ac6f-1a861a004953
367	35		\N	0	\N	-1	f46e680e-8e04-426a-b055-c66c18163caa
368	75	04.04.Cooperações trilaterais	\N	0	\N	-1	f46e680e-8e04-426a-b055-c66c18163caa
1991	78	Recurso Educativo		0	\N	-1	3d527afd-cb44-4f63-ae6a-cd9ccee96f11
1992	78	Recurso Educativo		0	\N	-1	24fb983c-62fc-41d7-9a45-45bf55a5359c
2373	75	license.txt	\N	0	\N	-1	bc954f78-c223-4b19-ad6c-059227740671
2367	75	saltaz.jpg	\N	0	\N	-1	df71148b-a7aa-4c7f-9496-b0eaee0aae6f
2368	65	saltaz.jpg	\N	0	\N	-1	df71148b-a7aa-4c7f-9496-b0eaee0aae6f
2369	34		\N	0	\N	-1	df71148b-a7aa-4c7f-9496-b0eaee0aae6f
2370	63	http://creativecommons.org/licenses/by-nc-nd/3.0/igo/	*	0	\N	-1	1446271c-d93d-42dc-a7ba-a6ca384b4448
2371	62	Attribution-NonCommercial-NoDerivs 3.0 IGO	*	0	\N	-1	1446271c-d93d-42dc-a7ba-a6ca384b4448
2372	75	LICENSE	\N	1	\N	-1	f927872e-3dba-4482-af19-719b731d7fea
2362	68	Saneamento Básico	en_US	0	\N	-1	1446271c-d93d-42dc-a7ba-a6ca384b4448
2363	68	Saneamento Rural	en_US	1	\N	-1	1446271c-d93d-42dc-a7ba-a6ca384b4448
2364	45	image/jpeg	en_US	0	\N	-1	1446271c-d93d-42dc-a7ba-a6ca384b4448
2365	43	1365 × 2048	en_US	0	\N	-1	1446271c-d93d-42dc-a7ba-a6ca384b4448
2366	75	ORIGINAL	\N	1	\N	-1	9496fe87-9539-44d1-8ca3-4d62c300194d
2374	65	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	bc954f78-c223-4b19-ad6c-059227740671
2375	36	Submitted by Suellen Viriato Leite da Silva (suellen.silva@funasa.gov.br) on 2019-05-15T13:23:04Z\nNo. of bitstreams: 1\nsaltaz.jpg: 1865922 bytes, checksum: 4cc8552c3c7a762be0f5771e92a0efd2 (MD5)	en	0	\N	-1	1446271c-d93d-42dc-a7ba-a6ca384b4448
2376	33	http://rcfunasa.bvsalud.org//handle/123456789/376	\N	0	\N	-1	1446271c-d93d-42dc-a7ba-a6ca384b4448
2011	75	DSpace CRIS, una pesadilla	en_US	0	\N	-1	24fb983c-62fc-41d7-9a45-45bf55a5359c
2012	35	Aprender acerca de DSpace CRIS	en_US	0	\N	-1	24fb983c-62fc-41d7-9a45-45bf55a5359c
2377	18	2019-05-15T13:23:05Z	\N	0	\N	-1	1446271c-d93d-42dc-a7ba-a6ca384b4448
2378	19	2019-05-15T13:23:05Z	\N	0	\N	-1	1446271c-d93d-42dc-a7ba-a6ca384b4448
369	35		\N	0	\N	-1	12f102df-9e17-4bbd-8a46-6879014fd76b
370	75	04.04.01.Etiópia	\N	0	\N	-1	12f102df-9e17-4bbd-8a46-6879014fd76b
371	35		\N	0	\N	-1	ca5e06ab-e7d9-4963-8747-67003deb6b31
372	75	Legislação	\N	0	\N	-1	ca5e06ab-e7d9-4963-8747-67003deb6b31
373	35		\N	0	\N	-1	7e9ba303-9d53-4c40-90b9-4f68d86270f2
374	75	Materiais Multimidia	\N	0	\N	-1	7e9ba303-9d53-4c40-90b9-4f68d86270f2
375	35		\N	0	\N	-1	3f84afbc-9185-4a3f-b3c9-569c3e9da89b
376	75	Políticas, Planejamento, Gestão e Projetos	\N	0	\N	-1	3f84afbc-9185-4a3f-b3c9-569c3e9da89b
377	35		\N	0	\N	-1	0aa9ece4-f742-4c0a-8040-cdf4d8faf5b9
378	75	Produção Científica	\N	0	\N	-1	0aa9ece4-f742-4c0a-8040-cdf4d8faf5b9
379	35		\N	0	\N	-1	f597ed21-6f76-41b8-8c1d-57f763859fad
380	75	Produções Educacionais	\N	0	\N	-1	f597ed21-6f76-41b8-8c1d-57f763859fad
381	35		\N	0	\N	-1	6ad2c279-e29e-402c-a09b-cadf0a19207f
382	75	04.05.Universidades e Institutos	\N	0	\N	-1	6ad2c279-e29e-402c-a09b-cadf0a19207f
383	35		\N	0	\N	-1	9c532e18-a50a-4815-bbcc-a2e5d9c2b65f
384	75	Legislação	\N	0	\N	-1	9c532e18-a50a-4815-bbcc-a2e5d9c2b65f
385	35		\N	0	\N	-1	105d0e1a-d561-459b-8322-0e985510883b
386	75	Materiais Multimidia	\N	0	\N	-1	105d0e1a-d561-459b-8322-0e985510883b
387	35		\N	0	\N	-1	130b1879-7c73-446f-95cb-dfa274fd8361
388	75	Políticas, Planejamento, Gestão e Projetos	\N	0	\N	-1	130b1879-7c73-446f-95cb-dfa274fd8361
389	35		\N	0	\N	-1	0de8081c-86c1-4318-96a2-61ff4a5eafd8
390	75	Produção Científica	\N	0	\N	-1	0de8081c-86c1-4318-96a2-61ff4a5eafd8
391	35		\N	0	\N	-1	a12c7960-d301-433f-b967-55d86845070b
392	75	Produções Educacionais	\N	0	\N	-1	a12c7960-d301-433f-b967-55d86845070b
2013	34	Un dos tres	en_US	0	\N	-1	24fb983c-62fc-41d7-9a45-45bf55a5359c
2014	7	Marmonti, Emiliano	en_US	0	\N	-1	24fb983c-62fc-41d7-9a45-45bf55a5359c
2015	10	Brito, Fabio	en_US	0	\N	-1	24fb983c-62fc-41d7-9a45-45bf55a5359c
395	35		\N	0	\N	-1	2c944a82-e4a1-4d58-b31e-3c96236eb34d
396	75	05.01.Gestão da logística	\N	0	\N	-1	2c944a82-e4a1-4d58-b31e-3c96236eb34d
397	35		\N	0	\N	-1	3bbe59c8-460c-4879-bad9-50a6607ac8f0
398	75	Legislação	\N	0	\N	-1	3bbe59c8-460c-4879-bad9-50a6607ac8f0
399	35		\N	0	\N	-1	6486917f-01cd-4e4d-b606-af71d92a14fa
400	75	Materiais Multimidia	\N	0	\N	-1	6486917f-01cd-4e4d-b606-af71d92a14fa
401	35		\N	0	\N	-1	9f65562a-b18b-429c-892e-5740150f30ce
402	75	Políticas, Planejamento, Gestão e Projetos	\N	0	\N	-1	9f65562a-b18b-429c-892e-5740150f30ce
403	35		\N	0	\N	-1	0e56849a-8a47-4e6a-a208-7af588a91310
404	75	Produção Científica	\N	0	\N	-1	0e56849a-8a47-4e6a-a208-7af588a91310
405	35		\N	0	\N	-1	11c01b5a-3ef7-4298-a9da-18739a99fa62
406	75	Produções Educacionais	\N	0	\N	-1	11c01b5a-3ef7-4298-a9da-18739a99fa62
407	35		\N	0	\N	-1	ae79c603-8cb2-40f8-9d07-c69363f0039a
408	75	05.02.Gestão de Pessoas	\N	0	\N	-1	ae79c603-8cb2-40f8-9d07-c69363f0039a
409	35		\N	0	\N	-1	9bc40373-4a2a-46ff-847c-714cb460e549
410	75	Legislação	\N	0	\N	-1	9bc40373-4a2a-46ff-847c-714cb460e549
411	35		\N	0	\N	-1	0ebec10d-4478-49ab-93f9-154d33b27b48
412	75	Materiais Multimidia	\N	0	\N	-1	0ebec10d-4478-49ab-93f9-154d33b27b48
413	35		\N	0	\N	-1	bccab95d-41a0-417f-8c60-c4930d2ee64b
414	75	Políticas, Planejamento, Gestão e Projetos	\N	0	\N	-1	bccab95d-41a0-417f-8c60-c4930d2ee64b
415	35		\N	0	\N	-1	de089951-60b0-4a0f-96f0-808a6dbdee71
416	75	Produção Científica	\N	0	\N	-1	de089951-60b0-4a0f-96f0-808a6dbdee71
417	35		\N	0	\N	-1	9945f686-7847-4d78-9b8c-154e2a2bb296
418	75	Produções Educacionais	\N	0	\N	-1	9945f686-7847-4d78-9b8c-154e2a2bb296
419	35		\N	0	\N	-1	0a540eac-23c0-4dca-9943-d006688c005b
420	75	05.03.Gestão da Informação e documentação	\N	0	\N	-1	0a540eac-23c0-4dca-9943-d006688c005b
1261	68	Fiebre Amarilla	en_US	0	\N	-1	c54373cb-b02d-4935-add5-f3c17ae29223
1262	140	Not specified	en_US	0	\N	-1	c54373cb-b02d-4935-add5-f3c17ae29223
1263	64	FUNASA	en_US	0	\N	-1	c54373cb-b02d-4935-add5-f3c17ae29223
2017	179	Curso	en_US	0	\N	-1	24fb983c-62fc-41d7-9a45-45bf55a5359c
2018	47	pt	en_US	0	\N	-1	24fb983c-62fc-41d7-9a45-45bf55a5359c
2019	47	es	en_US	1	\N	-1	24fb983c-62fc-41d7-9a45-45bf55a5359c
2020	178	Aula	en_US	0	\N	-1	24fb983c-62fc-41d7-9a45-45bf55a5359c
2021	171	Exames	en_US	0	\N	-1	24fb983c-62fc-41d7-9a45-45bf55a5359c
2022	166	Muito baixo	en_US	0	\N	-1	24fb983c-62fc-41d7-9a45-45bf55a5359c
2023	181	Treinamento em serviço	en_US	0	\N	-1	24fb983c-62fc-41d7-9a45-45bf55a5359c
2024	167	Fácil	en_US	0	\N	-1	24fb983c-62fc-41d7-9a45-45bf55a5359c
2025	168	0	en_US	0	\N	-1	24fb983c-62fc-41d7-9a45-45bf55a5359c
2026	180	Outros	en_US	0	\N	-1	24fb983c-62fc-41d7-9a45-45bf55a5359c
2027	62	Atribuição CC BY	en_US	0	\N	-1	24fb983c-62fc-41d7-9a45-45bf55a5359c
2028	68	Automatización de Bibliotecas	en_US	0	\N	-1	24fb983c-62fc-41d7-9a45-45bf55a5359c
2029	63	http://creativecommons.org/licenses/by-sa/3.0/igo/	*	0	\N	-1	24fb983c-62fc-41d7-9a45-45bf55a5359c
2030	62	Attribution-ShareAlike 3.0 IGO	*	1	\N	-1	24fb983c-62fc-41d7-9a45-45bf55a5359c
2031	75	LICENSE	\N	1	\N	-1	35120e12-4729-4a25-a25b-572399403a63
2032	75	license.txt	\N	0	\N	-1	4afdf8ac-bf2a-4d7d-9020-24aaa7344ce7
2033	65	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	4afdf8ac-bf2a-4d7d-9020-24aaa7344ce7
2034	36	Submitted by Emiliano Marmonti (emarmonti@gmail.com) on 2019-05-14T11:29:36Z\nNo. of bitstreams: 0	en	0	\N	-1	24fb983c-62fc-41d7-9a45-45bf55a5359c
2035	33	http://rcfunasa.bvsalud.org//handle/123456789/373	\N	0	\N	-1	24fb983c-62fc-41d7-9a45-45bf55a5359c
2871	75	TESTE-5 Politicas, Planejamento, Gestão e Projetos	en_US	0	\N	-1	1386b2cc-40f2-4213-a6d2-8d3ab04ba6bc
2872	76	teste 5 - titulo alternativo	en_US	0	\N	-1	1386b2cc-40f2-4213-a6d2-8d3ab04ba6bc
2873	9	João da Silva e Silva	en_US	0	\N	-1	1386b2cc-40f2-4213-a6d2-8d3ab04ba6bc
2874	10	Bireme	en_US	0	\N	-1	1386b2cc-40f2-4213-a6d2-8d3ab04ba6bc
2875	35	Phasellus vitae odio accumsan lacus viverra gravida sed rhoncus nulla. Donec dictum gravida scelerisque. Nullam ultrices venenatis venenatis.	en_US	0	\N	-1	1386b2cc-40f2-4213-a6d2-8d3ab04ba6bc
2877	47	pt	en_US	0	\N	-1	1386b2cc-40f2-4213-a6d2-8d3ab04ba6bc
421	35		\N	0	\N	-1	1b9b305d-dc05-42d2-b4b1-47e95b8cc167
422	75	05.03.01.Arquivo	\N	0	\N	-1	1b9b305d-dc05-42d2-b4b1-47e95b8cc167
423	35		\N	0	\N	-1	2b0ca2ad-7e28-4a9c-b0a3-63b4f4b5f427
424	75	Legislação	\N	0	\N	-1	2b0ca2ad-7e28-4a9c-b0a3-63b4f4b5f427
425	35		\N	0	\N	-1	c63831fc-1419-470b-8f44-bdf13b06618c
426	75	Materiais Multimidia	\N	0	\N	-1	c63831fc-1419-470b-8f44-bdf13b06618c
427	35		\N	0	\N	-1	e0cb29a5-a7e7-4183-a647-59027c0c8c2e
428	75	Políticas, Planejamento, Gestão e Projetos	\N	0	\N	-1	e0cb29a5-a7e7-4183-a647-59027c0c8c2e
429	35		\N	0	\N	-1	21f3514c-8861-4b5f-ac3f-d4b88441adcc
430	75	Produção Científica	\N	0	\N	-1	21f3514c-8861-4b5f-ac3f-d4b88441adcc
431	35		\N	0	\N	-1	95824968-09b5-45c3-a5ff-f6c8fad3cba5
432	75	Produções Educacionais	\N	0	\N	-1	95824968-09b5-45c3-a5ff-f6c8fad3cba5
433	35		\N	0	\N	-1	f43b5db9-d9fe-4f67-b1df-48dd4cf237af
434	75	05.03.02.Biblioteca	\N	0	\N	-1	f43b5db9-d9fe-4f67-b1df-48dd4cf237af
435	35		\N	0	\N	-1	76a4baa0-c312-47de-abd8-38d342f5648a
436	75	Legislação	\N	0	\N	-1	76a4baa0-c312-47de-abd8-38d342f5648a
437	35		\N	0	\N	-1	433ec679-855f-4e2e-8302-b485271cd68f
438	75	Materiais Multimidia	\N	0	\N	-1	433ec679-855f-4e2e-8302-b485271cd68f
439	35		\N	0	\N	-1	86ccc8a7-5a8e-468d-b03c-4ce0436bc4dd
440	75	Políticas, Planejamento, Gestão e Projetos	\N	0	\N	-1	86ccc8a7-5a8e-468d-b03c-4ce0436bc4dd
441	35		\N	0	\N	-1	7cf1f5ae-d764-4d10-904d-1d8052283126
442	75	Produção Científica	\N	0	\N	-1	7cf1f5ae-d764-4d10-904d-1d8052283126
443	35		\N	0	\N	-1	1a948c76-f0c1-42ea-8a98-090bb3c0e952
444	75	Produções Educacionais	\N	0	\N	-1	1a948c76-f0c1-42ea-8a98-090bb3c0e952
445	35		\N	0	\N	-1	f090f032-d9d9-4ec2-9490-16e3db96212b
446	75	05.03.03.Museu	\N	0	\N	-1	f090f032-d9d9-4ec2-9490-16e3db96212b
447	35		\N	0	\N	-1	30edbd28-6241-4876-ae87-818171fb29ea
448	75	Legislação	\N	0	\N	-1	30edbd28-6241-4876-ae87-818171fb29ea
449	35		\N	0	\N	-1	0bfb3ac9-90de-4934-b39b-178edde5c7ef
450	75	Materiais Multimidia	\N	0	\N	-1	0bfb3ac9-90de-4934-b39b-178edde5c7ef
451	35		\N	0	\N	-1	5b79fd4a-7656-4ddd-8860-b292b48350e6
452	75	Políticas, Planejamento, Gestão e Projetos	\N	0	\N	-1	5b79fd4a-7656-4ddd-8860-b292b48350e6
453	35		\N	0	\N	-1	6ce04d42-1a73-46e1-b145-4f43f004cd70
454	75	Produção Científica	\N	0	\N	-1	6ce04d42-1a73-46e1-b145-4f43f004cd70
455	35		\N	0	\N	-1	73c5e039-5fd5-45ca-8b42-e46dfc33d06c
456	75	Produções Educacionais	\N	0	\N	-1	73c5e039-5fd5-45ca-8b42-e46dfc33d06c
457	35		\N	0	\N	-1	ef9c52da-c800-4fb6-8ecb-6851e26a2794
458	75	05.03.04.Georeferenciamento	\N	0	\N	-1	ef9c52da-c800-4fb6-8ecb-6851e26a2794
459	35		\N	0	\N	-1	5d2a1df2-7371-435c-b241-b3c9539b6049
460	75	Legislação	\N	0	\N	-1	5d2a1df2-7371-435c-b241-b3c9539b6049
461	35		\N	0	\N	-1	c60c6dbc-67c4-42e9-adaf-acc0c82822ac
462	75	Materiais Multimidia	\N	0	\N	-1	c60c6dbc-67c4-42e9-adaf-acc0c82822ac
463	35		\N	0	\N	-1	0ce316b3-41f3-4a74-8bfc-e0ee3cfe4000
464	75	Políticas, Planejamento, Gestão e Projetos	\N	0	\N	-1	0ce316b3-41f3-4a74-8bfc-e0ee3cfe4000
465	35		\N	0	\N	-1	36ea01fe-9920-424a-a9bb-b5de23ec2c7d
466	75	Produção Científica	\N	0	\N	-1	36ea01fe-9920-424a-a9bb-b5de23ec2c7d
467	35		\N	0	\N	-1	1652f904-9088-4fa5-bd63-9ff1e6efcf97
468	75	Produções Educacionais	\N	0	\N	-1	1652f904-9088-4fa5-bd63-9ff1e6efcf97
469	35		\N	0	\N	-1	1b279197-328f-4ff1-a8a3-60e842b4d099
470	75	05.04.Tecnologias da informação e comunicação	\N	0	\N	-1	1b279197-328f-4ff1-a8a3-60e842b4d099
471	35		\N	0	\N	-1	bf95d0b0-a562-4c96-9252-5b2ed9bcfb64
472	75	Legislação	\N	0	\N	-1	bf95d0b0-a562-4c96-9252-5b2ed9bcfb64
473	35		\N	0	\N	-1	7001f4bb-55d0-4a1f-bde5-e514920a429b
1264	1	Fábio Luís	\N	0	\N	-1	28194931-611a-42cc-89c7-b133dc63c893
1265	2	de Brito	\N	0	\N	-1	28194931-611a-42cc-89c7-b133dc63c893
1266	3		\N	0	\N	-1	28194931-611a-42cc-89c7-b133dc63c893
1267	4	pt	\N	0	\N	-1	28194931-611a-42cc-89c7-b133dc63c893
2039	36	Made available in DSpace on 2019-05-14T11:29:37Z (GMT). No. of bitstreams: 0\n  Previous issue date: 2019	en	1	\N	-1	24fb983c-62fc-41d7-9a45-45bf55a5359c
2036	18	2019-05-14T11:29:37Z	\N	0	\N	-1	24fb983c-62fc-41d7-9a45-45bf55a5359c
2037	19	2019-05-14T11:29:37Z	\N	0	\N	-1	24fb983c-62fc-41d7-9a45-45bf55a5359c
2038	22	2019	\N	0	\N	-1	24fb983c-62fc-41d7-9a45-45bf55a5359c
2242	152	Brasil	en_US	0	\N	-1	b683a946-16af-4acd-a050-17decd4bd085
2243	78	Portaria	en_US	0	\N	-1	b683a946-16af-4acd-a050-17decd4bd085
2244	32	3069	en_US	0	\N	-1	b683a946-16af-4acd-a050-17decd4bd085
2245	75	Portaria 3.069 de 21 de maio de 2018	en_US	0	\N	-1	b683a946-16af-4acd-a050-17decd4bd085
2246	151	Nacional	en_US	0	\N	-1	b683a946-16af-4acd-a050-17decd4bd085
2247	65	Diário Oficial da União	en_US	0	\N	-1	b683a946-16af-4acd-a050-17decd4bd085
2248	147	1	en_US	0	\N	-1	b683a946-16af-4acd-a050-17decd4bd085
2249	148	97	en_US	0	\N	-1	b683a946-16af-4acd-a050-17decd4bd085
2250	149	88	en_US	0	\N	-1	b683a946-16af-4acd-a050-17decd4bd085
2251	145	2018-05-21	\N	0	\N	-1	b683a946-16af-4acd-a050-17decd4bd085
2878	152	Brasil	en_US	0	\N	-1	1386b2cc-40f2-4213-a6d2-8d3ab04ba6bc
2253	10	Fundação Nacional de Saúde	en_US	0	\N	-1	b683a946-16af-4acd-a050-17decd4bd085
2254	47	pt	en_US	0	\N	-1	b683a946-16af-4acd-a050-17decd4bd085
2255	35	Aprova e institui o Programa Sustentar com a finalidade de promover a sustentabilidade das ações e dos serviços de saneamento e saúde ambiental e de fornecer diretrizes para atuação, no âmbito da Funasa, em áreas rurais e comunidades tradicionais	en_US	0	\N	-1	b683a946-16af-4acd-a050-17decd4bd085
2256	68	Saneamento Básico	en_US	0	\N	-1	b683a946-16af-4acd-a050-17decd4bd085
2257	75	ORIGINAL	\N	1	\N	-1	4658a0b2-50e4-444a-b4ac-e4d6d7aa559c
2261	63	http://creativecommons.org/publicdomain/zero/1.0/	*	0	\N	-1	b683a946-16af-4acd-a050-17decd4bd085
2258	75	Portaria Programa Sustentar.pdf	\N	0	\N	-1	e5e4b3e2-45fe-4ff9-8766-bee1f235ad36
2259	65	Portaria Programa Sustentar.pdf	\N	0	\N	-1	e5e4b3e2-45fe-4ff9-8766-bee1f235ad36
2260	34		\N	0	\N	-1	e5e4b3e2-45fe-4ff9-8766-bee1f235ad36
2262	62	CC0 1.0 Universal	*	0	\N	-1	b683a946-16af-4acd-a050-17decd4bd085
2263	75	LICENSE	\N	1	\N	-1	dbcfe7c2-b2ab-4cef-a7e2-1574b7387410
2879	153	São Paulo	en_US	0	\N	-1	1386b2cc-40f2-4213-a6d2-8d3ab04ba6bc
2880	154	São Paulo	en_US	0	\N	-1	1386b2cc-40f2-4213-a6d2-8d3ab04ba6bc
2881	68	Área Programática (Saúde)	en_US	0	\N	-1	1386b2cc-40f2-4213-a6d2-8d3ab04ba6bc
474	75	Materiais Multimidia	\N	0	\N	-1	7001f4bb-55d0-4a1f-bde5-e514920a429b
475	35		\N	0	\N	-1	9edbbc8c-bc1b-42ba-8914-1d9e9db2347f
476	75	Políticas, Planejamento, Gestão e Projetos	\N	0	\N	-1	9edbbc8c-bc1b-42ba-8914-1d9e9db2347f
477	35		\N	0	\N	-1	85429d43-9926-4439-8704-20e18bb5679b
478	75	Produção Científica	\N	0	\N	-1	85429d43-9926-4439-8704-20e18bb5679b
479	35		\N	0	\N	-1	dc0136e1-f792-4aac-a8ea-16e09675995c
480	75	Produções Educacionais	\N	0	\N	-1	dc0136e1-f792-4aac-a8ea-16e09675995c
481	35		\N	0	\N	-1	8d8d2fbb-cae3-4073-a46d-d4e01d204cad
482	75	05.05.Gestão orçamentária e financeira	\N	0	\N	-1	8d8d2fbb-cae3-4073-a46d-d4e01d204cad
483	35		\N	0	\N	-1	ef8e7e2c-eeeb-439d-b7f9-ade465fc4f68
484	75	Legislação	\N	0	\N	-1	ef8e7e2c-eeeb-439d-b7f9-ade465fc4f68
485	35		\N	0	\N	-1	79300c61-6d47-405d-9a9a-d1e8f0204305
486	75	Materiais Multimidia	\N	0	\N	-1	79300c61-6d47-405d-9a9a-d1e8f0204305
487	35		\N	0	\N	-1	9e61e347-ce40-43c5-a332-f5683442b1fa
488	75	Políticas, Planejamento, Gestão e Projetos	\N	0	\N	-1	9e61e347-ce40-43c5-a332-f5683442b1fa
489	35		\N	0	\N	-1	d3672c54-1ef2-471a-ba24-239a3990fc75
490	75	Produção Científica	\N	0	\N	-1	d3672c54-1ef2-471a-ba24-239a3990fc75
491	35		\N	0	\N	-1	ef53ffdb-0f3a-492e-874c-fcd8fba11d06
492	75	Produções Educacionais	\N	0	\N	-1	ef53ffdb-0f3a-492e-874c-fcd8fba11d06
493	35		\N	0	\N	-1	a14ae54e-0797-4324-8b82-9846be3aa9fd
494	75	05.06.Planejamento Estratégico	\N	0	\N	-1	a14ae54e-0797-4324-8b82-9846be3aa9fd
495	35		\N	0	\N	-1	01712afa-c526-4f73-94ae-02734ce15c96
496	75	Legislação	\N	0	\N	-1	01712afa-c526-4f73-94ae-02734ce15c96
497	35		\N	0	\N	-1	9b63b2f1-f8e9-42f3-8d4f-a49a3f16e914
498	75	Materiais Multimidia	\N	0	\N	-1	9b63b2f1-f8e9-42f3-8d4f-a49a3f16e914
499	35		\N	0	\N	-1	c23dcaad-e9fa-4c6b-8d86-4fd2f3c125e9
500	75	Políticas, Planejamento, Gestão e Projetos	\N	0	\N	-1	c23dcaad-e9fa-4c6b-8d86-4fd2f3c125e9
501	35		\N	0	\N	-1	5e78e0bf-da34-4c8b-ab86-2a6b9f8d63a8
502	75	Produção Científica	\N	0	\N	-1	5e78e0bf-da34-4c8b-ab86-2a6b9f8d63a8
503	35		\N	0	\N	-1	127e289a-cced-4934-91ee-0bd505946855
504	75	Produções Educacionais	\N	0	\N	-1	127e289a-cced-4934-91ee-0bd505946855
505	35		\N	0	\N	-1	f1e4428f-78dc-4c65-93b0-a5fd4a291f23
506	75	05.07.Comunicação Institucional	\N	0	\N	-1	f1e4428f-78dc-4c65-93b0-a5fd4a291f23
507	35		\N	0	\N	-1	a4c357bb-03ad-445b-b073-d6c5a8a9ce33
508	75	Legislação	\N	0	\N	-1	a4c357bb-03ad-445b-b073-d6c5a8a9ce33
509	35		\N	0	\N	-1	96931619-4af6-4562-9d21-45a09a3a369f
510	75	Materiais Multimidia	\N	0	\N	-1	96931619-4af6-4562-9d21-45a09a3a369f
511	35		\N	0	\N	-1	35210960-6f4c-4dde-9ee3-063f923c3dc3
512	75	Políticas, Planejamento, Gestão e Projetos	\N	0	\N	-1	35210960-6f4c-4dde-9ee3-063f923c3dc3
513	35		\N	0	\N	-1	631514ab-cb74-4a79-a03d-ea3e718ee702
514	75	Produção Científica	\N	0	\N	-1	631514ab-cb74-4a79-a03d-ea3e718ee702
515	35		\N	0	\N	-1	a5f66249-7b4d-4084-a7b2-76a4ce0f2483
516	75	Produções Educacionais	\N	0	\N	-1	a5f66249-7b4d-4084-a7b2-76a4ce0f2483
519	35		\N	0	\N	-1	7482f96f-4d1c-42ef-935b-afa2a5bc1045
520	75	06.01.Sucam	\N	0	\N	-1	7482f96f-4d1c-42ef-935b-afa2a5bc1045
521	35		\N	0	\N	-1	86b6a785-abca-429f-991c-d473d49502ee
522	75	06.01.01.Controle e combate de Endemias	\N	0	\N	-1	86b6a785-abca-429f-991c-d473d49502ee
523	35		\N	0	\N	-1	9ac23e05-d27e-4732-83a1-dc07ce94c3e5
524	75	Legislação	\N	0	\N	-1	9ac23e05-d27e-4732-83a1-dc07ce94c3e5
525	35		\N	0	\N	-1	47b9440a-6769-4287-b4e7-a9a79fbf4fdc
1274	75	07.Solução Alternativa Coletiva de Tratamento de Água (Salta–Z)	\N	0	\N	-1	6b2e2ac5-98ee-4257-a54a-f24c7cb8fb01
2264	75	license.txt	\N	0	\N	-1	8a5f262f-0da7-41bc-82ad-8f7eb1609617
2265	65	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	8a5f262f-0da7-41bc-82ad-8f7eb1609617
2266	36	Submitted by Suellen Viriato Leite da Silva (suellen.silva@funasa.gov.br) on 2019-05-15T02:56:49Z\nNo. of bitstreams: 1\nPortaria Programa Sustentar.pdf: 213493 bytes, checksum: 6a04b40b877e7bf32fcb914329e9e01b (MD5)	en	0	\N	-1	b683a946-16af-4acd-a050-17decd4bd085
2040	10	Fundação Nacional de Saúde (FUNASA)	en_US	0	\N	-1	28f1a24a-b6ea-4b76-bba7-6779f81b14fe
2041	18	2019-03-11T10:13:30Z		0	\N	-1	28f1a24a-b6ea-4b76-bba7-6779f81b14fe
2042	19	2019-03-11T10:13:30Z		0	\N	-1	28f1a24a-b6ea-4b76-bba7-6779f81b14fe
2043	22	2017-05-31		0	\N	-1	28f1a24a-b6ea-4b76-bba7-6779f81b14fe
2044	35	O vídeo é um Webdoc sobre os benefícios da implantação de melhorias em abastecimento de água, esgotamento sanitário e controle da doença de Chagas financiadas pela Fundação Nacional de Saúde (Funasa) no estado da Paraíba (PB).	en_US	0	\N	-1	28f1a24a-b6ea-4b76-bba7-6779f81b14fe
2045	36	Submitted by Suellen Viriato Leite da Silva (suellen.silva@funasa.gov.br) on 2019-03-11T10:13:29Z\r\nNo. of bitstreams: 1\r\nteste.pdf: 81058 bytes, checksum: f764acc95d7fc9bb27499cc0e052f97f (MD5)	en	0	\N	-1	28f1a24a-b6ea-4b76-bba7-6779f81b14fe
2046	36	Made available in DSpace on 2019-03-11T10:13:30Z (GMT). No. of bitstreams: 1\r\nteste.pdf: 81058 bytes, checksum: f764acc95d7fc9bb27499cc0e052f97f (MD5)\r\n  Previous issue date: 2017-05-31	en	1	\N	-1	28f1a24a-b6ea-4b76-bba7-6779f81b14fe
2047	33	http://rcfunasa.bvsalud.org//handle/123456789/357		0	\N	-1	28f1a24a-b6ea-4b76-bba7-6779f81b14fe
2048	47	pt	en_US	0	\N	-1	28f1a24a-b6ea-4b76-bba7-6779f81b14fe
2049	48	FUNASA	en_US	0	\N	-1	28f1a24a-b6ea-4b76-bba7-6779f81b14fe
2050	62	Attribution-NonCommercial-ShareAlike 3.0 IGO	*	0	\N	-1	28f1a24a-b6ea-4b76-bba7-6779f81b14fe
2051	64	FUNASA	en_US	0	\N	-1	28f1a24a-b6ea-4b76-bba7-6779f81b14fe
2052	63	http://creativecommons.org/licenses/by-nc-sa/3.0/igo/	*	0	\N	-1	28f1a24a-b6ea-4b76-bba7-6779f81b14fe
2053	68	Doença de chagas	en_US	0	\N	-1	28f1a24a-b6ea-4b76-bba7-6779f81b14fe
2054	75	Funasa e o desafio de levar saneamento à Paraíba (PB)	en_US	0	\N	-1	28f1a24a-b6ea-4b76-bba7-6779f81b14fe
2267	33	http://rcfunasa.bvsalud.org//handle/123456789/375	\N	0	\N	-1	b683a946-16af-4acd-a050-17decd4bd085
2882	182	Saneamento Básico	en_US	0	\N	-1	1386b2cc-40f2-4213-a6d2-8d3ab04ba6bc
2883	78	Artigo de jornal	en_US	0	\N	-1	1386b2cc-40f2-4213-a6d2-8d3ab04ba6bc
2884	75	LICENSE	\N	1	\N	-1	edc044e1-bae6-4e22-b2a6-5ac50f8576c6
526	75	Materiais Multimidia	\N	0	\N	-1	47b9440a-6769-4287-b4e7-a9a79fbf4fdc
527	35		\N	0	\N	-1	c545077e-d983-473a-b621-d0213869b06d
528	75	Políticas, Planejamento, Gestão e Projetos	\N	0	\N	-1	c545077e-d983-473a-b621-d0213869b06d
529	35		\N	0	\N	-1	40951858-8246-4cb1-b095-0d20303ca115
530	75	Produção Científica	\N	0	\N	-1	40951858-8246-4cb1-b095-0d20303ca115
531	35		\N	0	\N	-1	7eaed4ff-162a-430f-8a35-1acdd53bc884
532	75	Produções Educacionais	\N	0	\N	-1	7eaed4ff-162a-430f-8a35-1acdd53bc884
533	35		\N	0	\N	-1	3d6690d8-eadd-46a6-8fea-73dbcdd3ec66
534	75	06.01.02.Controle e combate de Esquistossomose	\N	0	\N	-1	3d6690d8-eadd-46a6-8fea-73dbcdd3ec66
535	35		\N	0	\N	-1	8b6e660f-2253-4b81-9b42-a065a6964f56
536	75	Legislação	\N	0	\N	-1	8b6e660f-2253-4b81-9b42-a065a6964f56
537	35		\N	0	\N	-1	51fde179-1543-41de-9206-eaa3c75f9b59
538	75	Materiais Multimidia	\N	0	\N	-1	51fde179-1543-41de-9206-eaa3c75f9b59
539	35		\N	0	\N	-1	05915171-100e-4d10-89e4-c872711de1aa
540	75	Políticas, Planejamento, Gestão e Projetos	\N	0	\N	-1	05915171-100e-4d10-89e4-c872711de1aa
541	35		\N	0	\N	-1	c66b4475-75d3-4d34-b33a-87077ac6bdab
542	75	Produção Científica	\N	0	\N	-1	c66b4475-75d3-4d34-b33a-87077ac6bdab
543	35		\N	0	\N	-1	22e0168a-c2a8-4e0b-85ec-a8d88eafa46e
544	75	Produções Educacionais	\N	0	\N	-1	22e0168a-c2a8-4e0b-85ec-a8d88eafa46e
545	35		\N	0	\N	-1	7e294bf6-2eec-49aa-9d8f-a6d4a2cc498b
546	75	06.01.03.Controle e combate da doença de Chagas	\N	0	\N	-1	7e294bf6-2eec-49aa-9d8f-a6d4a2cc498b
547	35		\N	0	\N	-1	10b5d9e1-b62d-4c93-ba9c-d5a258b6f2c3
548	75	Legislação	\N	0	\N	-1	10b5d9e1-b62d-4c93-ba9c-d5a258b6f2c3
549	35		\N	0	\N	-1	f98570e1-e406-4857-9e8d-90c97ea8b7eb
550	75	Materiais Multimidia	\N	0	\N	-1	f98570e1-e406-4857-9e8d-90c97ea8b7eb
551	35		\N	0	\N	-1	e6c49376-930b-4689-9111-51386ff65eb8
552	75	Políticas, Planejamento, Gestão e Projetos	\N	0	\N	-1	e6c49376-930b-4689-9111-51386ff65eb8
553	35		\N	0	\N	-1	6e7329c4-fbf0-4c06-aed1-f57996b0dc02
554	75	Produção Científica	\N	0	\N	-1	6e7329c4-fbf0-4c06-aed1-f57996b0dc02
555	35		\N	0	\N	-1	ecb7bd93-4a76-4895-af27-8033ffb4b9ee
556	75	Produções Educacionais	\N	0	\N	-1	ecb7bd93-4a76-4895-af27-8033ffb4b9ee
557	35		\N	0	\N	-1	508fd417-903e-485c-8a79-1d47fecf89ec
558	75	06.01.04.Controle e combate Malária	\N	0	\N	-1	508fd417-903e-485c-8a79-1d47fecf89ec
559	35		\N	0	\N	-1	86b7a281-7358-4bd0-be35-d7b13d3a54d7
560	75	Legislação	\N	0	\N	-1	86b7a281-7358-4bd0-be35-d7b13d3a54d7
561	35		\N	0	\N	-1	c0727846-37aa-424a-a8b6-776f29a6b11c
562	75	Materiais Multimidia	\N	0	\N	-1	c0727846-37aa-424a-a8b6-776f29a6b11c
563	35		\N	0	\N	-1	69b38b68-43bc-4d73-9de6-7252271f950c
564	75	Políticas, Planejamento, Gestão e Projetos	\N	0	\N	-1	69b38b68-43bc-4d73-9de6-7252271f950c
565	35		\N	0	\N	-1	b20c5473-4f4b-4af4-b0ac-f25f63c15091
566	75	Produção Científica	\N	0	\N	-1	b20c5473-4f4b-4af4-b0ac-f25f63c15091
567	35		\N	0	\N	-1	80e08532-d009-40b6-b60b-01ad848f29e7
568	75	Produções Educacionais	\N	0	\N	-1	80e08532-d009-40b6-b60b-01ad848f29e7
569	35		\N	0	\N	-1	70a9c7ec-c890-4cb2-9978-47493f08fa8f
570	75	06.01.05.Controle e combate da Dengue	\N	0	\N	-1	70a9c7ec-c890-4cb2-9978-47493f08fa8f
571	35		\N	0	\N	-1	dd80f6f0-c10b-4172-a531-716f9dd1c230
572	75	Legislação	\N	0	\N	-1	dd80f6f0-c10b-4172-a531-716f9dd1c230
573	35		\N	0	\N	-1	98b7684c-bcff-4679-89a6-c6f0d23f0540
574	75	Materiais Multimidia	\N	0	\N	-1	98b7684c-bcff-4679-89a6-c6f0d23f0540
575	35		\N	0	\N	-1	e70c5835-3e0c-4681-b682-089b156bdd3c
576	75	Políticas, Planejamento, Gestão e Projetos	\N	0	\N	-1	e70c5835-3e0c-4681-b682-089b156bdd3c
2055	78	Vídeo	en_US	0	\N	-1	28f1a24a-b6ea-4b76-bba7-6779f81b14fe
577	35		\N	0	\N	-1	55dcf71d-31cb-43c0-b001-288d404c3890
2056	138	1	en_US	0	\N	-1	28f1a24a-b6ea-4b76-bba7-6779f81b14fe
2057	139	Brasília, DF	en_US	0	\N	-1	28f1a24a-b6ea-4b76-bba7-6779f81b14fe
2058	140	Brazil	en_US	0	\N	-1	28f1a24a-b6ea-4b76-bba7-6779f81b14fe
2059	143	Cat 3. Determinants of Health and Promoting Health throughout the Life Course	en_US	0	\N	-1	28f1a24a-b6ea-4b76-bba7-6779f81b14fe
2271	36	Made available in DSpace on 2019-05-15T02:56:49Z (GMT). No. of bitstreams: 1\nPortaria Programa Sustentar.pdf: 213493 bytes, checksum: 6a04b40b877e7bf32fcb914329e9e01b (MD5)\n  Previous issue date: 2018-05-22	en	1	\N	-1	b683a946-16af-4acd-a050-17decd4bd085
2268	18	2019-05-15T02:56:49Z	\N	0	\N	-1	b683a946-16af-4acd-a050-17decd4bd085
2269	19	2019-05-15T02:56:49Z	\N	0	\N	-1	b683a946-16af-4acd-a050-17decd4bd085
2270	22	2018-05-22	\N	0	\N	-1	b683a946-16af-4acd-a050-17decd4bd085
2380	36	Made available in DSpace on 2019-05-15T13:23:05Z (GMT). No. of bitstreams: 1\nsaltaz.jpg: 1865922 bytes, checksum: 4cc8552c3c7a762be0f5771e92a0efd2 (MD5)\n  Previous issue date: 2017-12-26	en	1	\N	-1	1446271c-d93d-42dc-a7ba-a6ca384b4448
2379	22	2017-12-26	\N	0	\N	-1	1446271c-d93d-42dc-a7ba-a6ca384b4448
2385	75	09.Programa Sustentar	\N	0	\N	-1	9b4b9979-0172-4961-9d58-10f57df85092
2885	75	license.txt	\N	0	\N	-1	c9cd3978-6216-4983-b67e-5d697ec20b81
2886	65	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	c9cd3978-6216-4983-b67e-5d697ec20b81
2887	36	Submitted by Fábio Luís de Brito (britofa@paho.org) on 2019-09-23T16:35:30Z\nNo. of bitstreams: 0	en	0	\N	-1	1386b2cc-40f2-4213-a6d2-8d3ab04ba6bc
2888	33	http://rcfunasa.bvsalud.org//handle/123456789/381	\N	0	\N	-1	1386b2cc-40f2-4213-a6d2-8d3ab04ba6bc
3023	78	Recurso Educativo		0	\N	-1	0fbb9e34-4b32-409d-a301-6a4a5e5a9ee4
2892	36	Made available in DSpace on 2019-09-23T16:35:30Z (GMT). No. of bitstreams: 0\n  Previous issue date: 2019-09-23	en	1	\N	-1	1386b2cc-40f2-4213-a6d2-8d3ab04ba6bc
2889	18	2019-09-23T16:35:30Z	\N	0	\N	-1	1386b2cc-40f2-4213-a6d2-8d3ab04ba6bc
2890	19	2019-09-23T16:35:30Z	\N	0	\N	-1	1386b2cc-40f2-4213-a6d2-8d3ab04ba6bc
2891	22	2019-09-23	\N	0	\N	-1	1386b2cc-40f2-4213-a6d2-8d3ab04ba6bc
3089	1	Marcos Antonio	\N	0	\N	-1	e1ae23f4-c9da-4c10-b7e2-8a3dc83982d2
3090	2	Silva de Almeida	\N	0	\N	-1	e1ae23f4-c9da-4c10-b7e2-8a3dc83982d2
578	75	Produção Científica	\N	0	\N	-1	55dcf71d-31cb-43c0-b001-288d404c3890
579	35		\N	0	\N	-1	58713621-70cd-4c5e-9341-28b32ba41fb9
580	75	Produções Educacionais	\N	0	\N	-1	58713621-70cd-4c5e-9341-28b32ba41fb9
581	35		\N	0	\N	-1	9d0dccbc-1024-4802-993c-933cb6cdc260
582	75	06.01.06.Controle e combate da Peste	\N	0	\N	-1	9d0dccbc-1024-4802-993c-933cb6cdc260
583	35		\N	0	\N	-1	1807e1c8-fe69-44f0-99f5-5543862721dd
584	75	Legislação	\N	0	\N	-1	1807e1c8-fe69-44f0-99f5-5543862721dd
585	35		\N	0	\N	-1	3021c2ed-dea4-4b82-a0e4-147c790655fd
586	75	Materiais Multimidia	\N	0	\N	-1	3021c2ed-dea4-4b82-a0e4-147c790655fd
587	35		\N	0	\N	-1	778fbe77-519d-43cf-8e5f-b7524f22be6d
588	75	Políticas, Planejamento, Gestão e Projetos	\N	0	\N	-1	778fbe77-519d-43cf-8e5f-b7524f22be6d
589	35		\N	0	\N	-1	a3760f39-a4f7-494b-98ef-ca6264671474
590	75	Produção Científica	\N	0	\N	-1	a3760f39-a4f7-494b-98ef-ca6264671474
591	35		\N	0	\N	-1	739c1d61-b1fb-4f93-8a6f-a20d3910c4a0
592	75	Produções Educacionais	\N	0	\N	-1	739c1d61-b1fb-4f93-8a6f-a20d3910c4a0
593	35		\N	0	\N	-1	786d3d1a-1946-4dd0-817b-dab8b0dfa161
594	75	06.01.07.História Sucam	\N	0	\N	-1	786d3d1a-1946-4dd0-817b-dab8b0dfa161
595	35		\N	0	\N	-1	c82c39e8-1b65-4647-90af-d2e6fc0e80a4
596	75	Legislação	\N	0	\N	-1	c82c39e8-1b65-4647-90af-d2e6fc0e80a4
597	35		\N	0	\N	-1	628a887f-5405-49b5-a113-8da165007f80
598	75	Materiais Multimidia	\N	0	\N	-1	628a887f-5405-49b5-a113-8da165007f80
599	35		\N	0	\N	-1	62ecff54-d3ad-4590-9773-f7a975437ddf
600	75	Políticas, Planejamento, Gestão e Projetos	\N	0	\N	-1	62ecff54-d3ad-4590-9773-f7a975437ddf
601	35		\N	0	\N	-1	63af20f3-0299-4b5b-8c39-e1343f9f944b
602	75	Produção Científica	\N	0	\N	-1	63af20f3-0299-4b5b-8c39-e1343f9f944b
603	35		\N	0	\N	-1	cedd3c7e-baf0-471f-9044-b43cca83af23
604	75	Produções Educacionais	\N	0	\N	-1	cedd3c7e-baf0-471f-9044-b43cca83af23
605	35		\N	0	\N	-1	12188074-fdf3-41c4-96c8-fdd2d1cee710
606	75	06.02.FSESP	\N	0	\N	-1	12188074-fdf3-41c4-96c8-fdd2d1cee710
607	35		\N	0	\N	-1	bc548182-4db3-4087-a94d-d059f9f386e4
608	75	06.02.01.Controle e combate de Endemias	\N	0	\N	-1	bc548182-4db3-4087-a94d-d059f9f386e4
609	35		\N	0	\N	-1	07045af3-ed80-4990-a660-6282fe0fe4fb
610	75	Legislação	\N	0	\N	-1	07045af3-ed80-4990-a660-6282fe0fe4fb
611	35		\N	0	\N	-1	f5f06691-69b5-4979-aee5-1c940a3a17b3
612	75	Materiais Multimidia	\N	0	\N	-1	f5f06691-69b5-4979-aee5-1c940a3a17b3
613	35		\N	0	\N	-1	33f44877-bc89-4386-aca3-ef3a4946d305
614	75	Políticas, Planejamento, Gestão e Projetos	\N	0	\N	-1	33f44877-bc89-4386-aca3-ef3a4946d305
615	35		\N	0	\N	-1	bdf997dd-df12-480a-ae52-8950beded503
616	75	Produção Científica	\N	0	\N	-1	bdf997dd-df12-480a-ae52-8950beded503
617	35		\N	0	\N	-1	2319137c-c5cc-4ea5-9de7-50713a7f88c4
618	75	Produções Educacionais	\N	0	\N	-1	2319137c-c5cc-4ea5-9de7-50713a7f88c4
619	35		\N	0	\N	-1	803bc41a-3cf3-4f5a-b888-26b61a5ba929
620	75	06.02.02.História FSESP	\N	0	\N	-1	803bc41a-3cf3-4f5a-b888-26b61a5ba929
621	35		\N	0	\N	-1	d42ed59c-0c22-4b9b-bebf-118132eeb353
622	75	Legislação	\N	0	\N	-1	d42ed59c-0c22-4b9b-bebf-118132eeb353
623	35		\N	0	\N	-1	3da18c61-9632-4a05-9962-27590f23772d
624	75	Materiais Multimidia	\N	0	\N	-1	3da18c61-9632-4a05-9962-27590f23772d
625	35		\N	0	\N	-1	8a758888-6213-4881-9b2b-690336684fa7
626	75	Políticas, Planejamento, Gestão e Projetos	\N	0	\N	-1	8a758888-6213-4881-9b2b-690336684fa7
627	35		\N	0	\N	-1	3f987ebb-99ce-497d-81e3-5dc76547cc98
628	75	Produção Científica	\N	0	\N	-1	3f987ebb-99ce-497d-81e3-5dc76547cc98
629	35		\N	0	\N	-1	0f76ce1d-7218-4ff1-848a-af873e4033b3
630	75	Produções Educacionais	\N	0	\N	-1	0f76ce1d-7218-4ff1-848a-af873e4033b3
1856	45	application/pdf	en_US	0	\N	-1	d450501d-bb9e-4ec6-9691-e27f33bba466
1857	171	Diagrama	en_US	0	\N	-1	d450501d-bb9e-4ec6-9691-e27f33bba466
1858	166	Alto	en_US	0	\N	-1	d450501d-bb9e-4ec6-9691-e27f33bba466
1859	181	Formação profissional	en_US	0	\N	-1	d450501d-bb9e-4ec6-9691-e27f33bba466
1860	167	Médio	en_US	0	\N	-1	d450501d-bb9e-4ec6-9691-e27f33bba466
1861	168	1	en_US	0	\N	-1	d450501d-bb9e-4ec6-9691-e27f33bba466
1862	180	Gestor	en_US	0	\N	-1	d450501d-bb9e-4ec6-9691-e27f33bba466
1863	180	Outros	en_US	1	\N	-1	d450501d-bb9e-4ec6-9691-e27f33bba466
1846	75	TESTE-1-Produções Educacionais	en_US	0	\N	-1	d450501d-bb9e-4ec6-9691-e27f33bba466
1847	35	Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus accumsan id ligula quis tempor. Maecenas finibus gravida turpis, in vehicula sem. Vestibulum condimentum vel dolor vel porta. Donec imperdiet at felis nec ornare. Mauris pellentesque sit amet tellus sed laoreet. Curabitur eget viverra lacus. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Curabitur dapibus eros eget neque iaculis, mollis imperdiet metu	en_US	0	\N	-1	d450501d-bb9e-4ec6-9691-e27f33bba466
1848	34	Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus accumsan id ligula quis tempor. Maecenas finibus gravida turpis, in vehicula sem. Vestibulum condimentum vel dolor vel porta. Donec imperdiet at felis nec ornare. Mauris pellentesque sit amet tellus sed laoreet. Curabitur eget viverra lacus. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Curabitur dapibus eros eget neque iaculis, mollis imperdiet metu	en_US	0	\N	-1	d450501d-bb9e-4ec6-9691-e27f33bba466
1864	62	Atribuição CC BY	en_US	0	\N	-1	d450501d-bb9e-4ec6-9691-e27f33bba466
1865	48	Bla bla	en_US	0	\N	-1	d450501d-bb9e-4ec6-9691-e27f33bba466
2273	145	2019-03-07		0	\N	-1	510ef6ac-d964-4857-81e9-85a00e00dc51
631	35		\N	0	\N	-1	214d281b-6762-46e2-a6a1-98d270cbf4bb
632	75	06.03.CENEPI	\N	0	\N	-1	214d281b-6762-46e2-a6a1-98d270cbf4bb
633	35		\N	0	\N	-1	9f71cf2b-168c-4efe-844e-afe0e670ccbf
634	75	06.03.01.História CENEPI	\N	0	\N	-1	9f71cf2b-168c-4efe-844e-afe0e670ccbf
635	35		\N	0	\N	-1	924a0f97-19fa-46d9-8720-b3203cbb4ad3
636	75	Legislação	\N	0	\N	-1	924a0f97-19fa-46d9-8720-b3203cbb4ad3
637	35		\N	0	\N	-1	0f289146-ce3b-42a6-b59e-3f159bb3e6f7
638	75	Materiais Multimidia	\N	0	\N	-1	0f289146-ce3b-42a6-b59e-3f159bb3e6f7
639	35		\N	0	\N	-1	b58ca63f-f2e7-411e-a5da-fe0857ba17d7
640	75	Políticas, Planejamento, Gestão e Projetos	\N	0	\N	-1	b58ca63f-f2e7-411e-a5da-fe0857ba17d7
641	35		\N	0	\N	-1	a0562a18-237a-401a-9e61-99b48c4122dd
642	75	Produção Científica	\N	0	\N	-1	a0562a18-237a-401a-9e61-99b48c4122dd
643	35		\N	0	\N	-1	d6af0d41-100d-4f6d-9bca-da31efbef9b9
644	75	Produções Educacionais	\N	0	\N	-1	d6af0d41-100d-4f6d-9bca-da31efbef9b9
645	35		\N	0	\N	-1	305fba50-26ce-48e4-af27-4ea801b1ef30
646	75	06.04.Saúde Indígena	\N	0	\N	-1	305fba50-26ce-48e4-af27-4ea801b1ef30
2274	150	2019-03-07		0	\N	-1	510ef6ac-d964-4857-81e9-85a00e00dc51
2275	151	Estadual	en_US	0	\N	-1	510ef6ac-d964-4857-81e9-85a00e00dc51
2276	149	inicial 50 final 55	en_US	0	\N	-1	510ef6ac-d964-4857-81e9-85a00e00dc51
2277	148	vol 4	en_US	0	\N	-1	510ef6ac-d964-4857-81e9-85a00e00dc51
2278	154	São Paulo	en_US	0	\N	-1	510ef6ac-d964-4857-81e9-85a00e00dc51
2279	152	Brasil	en_US	0	\N	-1	510ef6ac-d964-4857-81e9-85a00e00dc51
659	35		\N	0	\N	-1	823a9569-d81b-4871-9b0d-1a8f04de234a
660	75	06.05.Imunização / Vacinação	\N	0	\N	-1	823a9569-d81b-4871-9b0d-1a8f04de234a
2280	153	São Paulo	en_US	0	\N	-1	510ef6ac-d964-4857-81e9-85a00e00dc51
2281	157	123456789/358		0	\N	-1	510ef6ac-d964-4857-81e9-85a00e00dc51
2282	147	seção 1234 - teste	en_US	0	\N	-1	510ef6ac-d964-4857-81e9-85a00e00dc51
2283	146	XXIII	en_US	0	\N	-1	510ef6ac-d964-4857-81e9-85a00e00dc51
2284	10	teste2 - Órgão emissor	en_US	0	\N	-1	510ef6ac-d964-4857-81e9-85a00e00dc51
2285	18	2019-05-07T17:44:36Z		0	\N	-1	510ef6ac-d964-4857-81e9-85a00e00dc51
2286	19	2019-05-07T17:44:36Z		0	\N	-1	510ef6ac-d964-4857-81e9-85a00e00dc51
2287	22	2019-03-07		0	\N	-1	510ef6ac-d964-4857-81e9-85a00e00dc51
2288	35	Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit..	en_US	0	\N	-1	510ef6ac-d964-4857-81e9-85a00e00dc51
2289	41	Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras placerat.	en_US	0	\N	-1	510ef6ac-d964-4857-81e9-85a00e00dc51
2290	36	Submitted by Fábio Luís de Brito (britofa@paho.org) on 2019-05-07T17:44:36Z\r\nNo. of bitstreams: 0	en	0	\N	-1	510ef6ac-d964-4857-81e9-85a00e00dc51
2291	36	Made available in DSpace on 2019-05-07T17:44:36Z (GMT). No. of bitstreams: 0\r\n  Previous issue date: 2019-03-07	en	1	\N	-1	510ef6ac-d964-4857-81e9-85a00e00dc51
2292	32	x-1234567890	en_US	0	\N	-1	510ef6ac-d964-4857-81e9-85a00e00dc51
2293	33	http://rcfunasa.bvsalud.org//handle/123456789/359		0	\N	-1	510ef6ac-d964-4857-81e9-85a00e00dc51
2294	47	pt	en_US	0	\N	-1	510ef6ac-d964-4857-81e9-85a00e00dc51
2295	47	es	en_US	1	\N	-1	510ef6ac-d964-4857-81e9-85a00e00dc51
2296	62	CC0 1.0 Universal	*	0	\N	-1	510ef6ac-d964-4857-81e9-85a00e00dc51
2297	63	http://creativecommons.org/publicdomain/zero/1.0/	*	0	\N	-1	510ef6ac-d964-4857-81e9-85a00e00dc51
2298	65	Diário Oficial do Estado de São Paulo	en_US	0	\N	-1	510ef6ac-d964-4857-81e9-85a00e00dc51
2299	68	teste	en_US	0	\N	-1	510ef6ac-d964-4857-81e9-85a00e00dc51
2300	68	Cabeça do Fêmur	en_US	1	\N	-1	510ef6ac-d964-4857-81e9-85a00e00dc51
3024	78	Recurso Educativo		0	\N	-1	e21ca461-7f92-4cc7-8b99-9779c76e351a
2637	75	TESTE1-Produção Científica	en_US	0	\N	-1	416198eb-e102-4842-9bcc-a60fdcb450d7
1849	7	Funano	en_US	0	\N	-1	d450501d-bb9e-4ec6-9691-e27f33bba466
1850	7	Ciclano	en_US	1	\N	-1	d450501d-bb9e-4ec6-9691-e27f33bba466
1851	10	Funasa	en_US	0	\N	-1	d450501d-bb9e-4ec6-9691-e27f33bba466
2638	76	Titulo traduzido teste - TESTE1-Produção Científica	en_US	0	\N	-1	416198eb-e102-4842-9bcc-a60fdcb450d7
675	35		\N	0	\N	-1	9d445c33-454e-49dc-a493-0f5015eead12
676	75	Legislação	\N	0	\N	-1	9d445c33-454e-49dc-a493-0f5015eead12
677	35		\N	0	\N	-1	2b332fc6-9146-4623-863f-255d6566214f
678	75	Materiais Multimidia	\N	0	\N	-1	2b332fc6-9146-4623-863f-255d6566214f
679	35		\N	0	\N	-1	7df394a5-4dff-468b-b97e-0559c07fa1b9
680	75	Políticas, Planejamento, Gestão e Projetos	\N	0	\N	-1	7df394a5-4dff-468b-b97e-0559c07fa1b9
681	35		\N	0	\N	-1	a0304a67-0fff-496c-9419-d6696ba39cc1
682	75	Produção Científica	\N	0	\N	-1	a0304a67-0fff-496c-9419-d6696ba39cc1
1853	179	Ferramenta de aprendizado	en_US	0	\N	-1	d450501d-bb9e-4ec6-9691-e27f33bba466
683	35		\N	0	\N	-1	870c2ff3-ea24-4139-b31b-c643aa094c67
1854	47	pt	en_US	0	\N	-1	d450501d-bb9e-4ec6-9691-e27f33bba466
1855	178	Aula	en_US	0	\N	-1	d450501d-bb9e-4ec6-9691-e27f33bba466
1661	75	LICENSE	\N	1	\N	-1	c6f291c2-9995-454e-a838-cb645ec2de77
1866	68	Materiais de Ensino	en_US	0	\N	-1	d450501d-bb9e-4ec6-9691-e27f33bba466
1867	68	Ensino de Recuperação	en_US	1	\N	-1	d450501d-bb9e-4ec6-9691-e27f33bba466
1868	43	10 minutos	en_US	0	\N	-1	d450501d-bb9e-4ec6-9691-e27f33bba466
1869	169	Acesso à internet	en_US	0	\N	-1	d450501d-bb9e-4ec6-9691-e27f33bba466
1870	170	30 dias	en_US	0	\N	-1	d450501d-bb9e-4ec6-9691-e27f33bba466
1871	75	ORIGINAL	\N	1	\N	-1	75c62285-d1bb-4897-a31f-230c5115c6c5
2639	76	Titulo traduzido2  teste - TESTE1-Produção Científica	en_US	1	\N	-1	416198eb-e102-4842-9bcc-a60fdcb450d7
2640	9	Beltrano Fulano - TESTE1-Produção Científica	en_US	0	\N	-1	416198eb-e102-4842-9bcc-a60fdcb450d7
2641	9	TESTE1-Produção Científica - Carlos Gardel	en_US	1	\N	-1	416198eb-e102-4842-9bcc-a60fdcb450d7
1662	75	license.txt	\N	0	\N	-1	50e510a9-0bdb-4a55-b55f-dc37ea43633a
1663	65	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	50e510a9-0bdb-4a55-b55f-dc37ea43633a
1872	75	teste_upload.txt	\N	0	\N	-1	1b6078c0-fb54-4ff6-b526-890bb95184a1
1873	65	teste_upload.txt	\N	0	\N	-1	1b6078c0-fb54-4ff6-b526-890bb95184a1
1874	34		\N	0	\N	-1	1b6078c0-fb54-4ff6-b526-890bb95184a1
2642	10	FUNASA	en_US	0	\N	-1	416198eb-e102-4842-9bcc-a60fdcb450d7
2643	10	FUNASA TESTE	en_US	1	\N	-1	416198eb-e102-4842-9bcc-a60fdcb450d7
2655	64	FUNASA	en_US	0	\N	-1	416198eb-e102-4842-9bcc-a60fdcb450d7
2769	63	http://creativecommons.org/publicdomain/zero/1.0/	*	0	\N	-1	f332b151-98c1-4e28-b87e-bed0d9bf17e8
684	75	Produções Educacionais	\N	0	\N	-1	870c2ff3-ea24-4139-b31b-c643aa094c67
1875	63	http://creativecommons.org/publicdomain/zero/1.0/	*	0	\N	-1	d450501d-bb9e-4ec6-9691-e27f33bba466
1876	62	CC0 1.0 Universal	*	1	\N	-1	d450501d-bb9e-4ec6-9691-e27f33bba466
687	35		\N	0	\N	-1	f6806a22-5e75-442a-8474-1f1bf3b49bb0
688	75	Legislação	\N	0	\N	-1	f6806a22-5e75-442a-8474-1f1bf3b49bb0
689	35		\N	0	\N	-1	43c5b7d9-a1c7-4361-a0cf-0aa73a9333a7
690	75	Materiais Multimidia	\N	0	\N	-1	43c5b7d9-a1c7-4361-a0cf-0aa73a9333a7
691	35		\N	0	\N	-1	55fdca5e-d193-44a3-ada5-2ab4d65395d6
692	75	Políticas, Planejamento, Gestão e Projetos	\N	0	\N	-1	55fdca5e-d193-44a3-ada5-2ab4d65395d6
693	35		\N	0	\N	-1	0357e12e-1e20-4de1-89f8-17dfdd55fd31
694	75	Produção Científica	\N	0	\N	-1	0357e12e-1e20-4de1-89f8-17dfdd55fd31
695	35		\N	0	\N	-1	c4ae769f-b5a3-48a9-885a-c99c99c19e37
696	75	Produções Educacionais	\N	0	\N	-1	c4ae769f-b5a3-48a9-885a-c99c99c19e37
1877	75	LICENSE	\N	1	\N	-1	6a68fb46-a034-4129-b96e-b8d5209945cb
699	35		\N	0	\N	-1	3158d744-02ae-45d3-a4c1-3b8a5c22de3e
700	75	Legislação	\N	0	\N	-1	3158d744-02ae-45d3-a4c1-3b8a5c22de3e
701	35		\N	0	\N	-1	3dac7ef7-c456-42a2-8fc4-519e13b07ee0
702	75	Materiais Multimidia	\N	0	\N	-1	3dac7ef7-c456-42a2-8fc4-519e13b07ee0
703	35		\N	0	\N	-1	040fde0b-489a-4cc8-bfba-6f69ba7f4f11
704	75	Políticas, Planejamento, Gestão e Projetos	\N	0	\N	-1	040fde0b-489a-4cc8-bfba-6f69ba7f4f11
705	35		\N	0	\N	-1	e657559e-c7af-4fa3-8d0a-aba39f0ba879
706	75	Produção Científica	\N	0	\N	-1	e657559e-c7af-4fa3-8d0a-aba39f0ba879
707	35		\N	0	\N	-1	bf015865-7bd0-4282-bc70-61735421f9f1
708	75	Produções Educacionais	\N	0	\N	-1	bf015865-7bd0-4282-bc70-61735421f9f1
2301	75	TESTE-2 Legislação	en_US	0	\N	-1	510ef6ac-d964-4857-81e9-85a00e00dc51
2302	76	teste2.2 - Denominação do Ato	en_US	0	\N	-1	510ef6ac-d964-4857-81e9-85a00e00dc51
1878	75	license.txt	\N	0	\N	-1	d889cbef-ad65-49c8-a2e7-835a8262d9bc
1879	65	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	d889cbef-ad65-49c8-a2e7-835a8262d9bc
2303	78	Lei Estadual	en_US	0	\N	-1	510ef6ac-d964-4857-81e9-85a00e00dc51
2386	75	TEXT	\N	1	\N	-1	d2fd6cdc-efbe-47ba-bb06-06971d06d11b
3025	78	Recurso Educativo		0	\N	-1	534ec073-e464-4149-bf28-5cf8ad4baa5d
751	75	ORIGINAL	\N	1	\N	-1	12f6e52a-9df2-4bc6-8a4a-f88cebb87203
752	75	orientacoesparapadronizacaodedocumentostecnicos.pdf	\N	0	\N	-1	a36abd3c-a60d-454e-b3f6-c661d35d035b
753	65	orientacoesparapadronizacaodedocumentostecnicos.pdf	\N	0	\N	-1	a36abd3c-a60d-454e-b3f6-c661d35d035b
754	34		\N	0	\N	-1	a36abd3c-a60d-454e-b3f6-c661d35d035b
755	75	LICENSE	\N	1	\N	-1	da51fa58-1abe-4f80-bbc7-9e72e48e1fcf
927	75	orientacoesparapadronizacaodedocumentostecnicos.pdf.jpg	\N	0	\N	-1	91ff9e31-a61d-42bb-9fdd-405a17220205
756	75	license.txt	\N	0	\N	-1	916f5c8f-f012-4adb-8a55-1352136a4e85
757	65	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	916f5c8f-f012-4adb-8a55-1352136a4e85
928	65	Written by FormatFilter org.dspace.app.mediafilter.ImageMagickPdfThumbnailFilter on 2019-01-20T20:20:34Z (GMT).	\N	0	\N	-1	91ff9e31-a61d-42bb-9fdd-405a17220205
764	10	Fundação Nacional de Saúde (FUNASA)	en_US	0	\N	-1	1f0c95ab-3775-4094-b293-183d3b5074b2
765	18	2019-01-09T17:57:18Z		0	\N	-1	1f0c95ab-3775-4094-b293-183d3b5074b2
766	19	2019-01-09T17:57:18Z		0	\N	-1	1f0c95ab-3775-4094-b293-183d3b5074b2
767	22	2014		0	\N	-1	1f0c95ab-3775-4094-b293-183d3b5074b2
772	33	http://rcfunasa.bvsalud.org//handle/123456789/354		0	\N	-1	1f0c95ab-3775-4094-b293-183d3b5074b2
930	75	PLANO_Atuacao_Desastres_2018 WEB.pdf.txt	\N	0	\N	-1	33dc18c8-e0d8-488d-89fd-1dc632373638
931	65	Written by FormatFilter org.dspace.app.mediafilter.PDFFilter on 2019-01-20T20:20:36Z (GMT).	\N	0	\N	-1	33dc18c8-e0d8-488d-89fd-1dc632373638
932	34	Extracted text	\N	0	\N	-1	33dc18c8-e0d8-488d-89fd-1dc632373638
933	75	PLANO_Atuacao_Desastres_2018 WEB.pdf.jpg	\N	0	\N	-1	ef695971-00b7-4c43-8a47-1f3c31272310
934	65	Written by FormatFilter org.dspace.app.mediafilter.PDFBoxThumbnail on 2019-01-20T20:20:37Z (GMT).	\N	0	\N	-1	ef695971-00b7-4c43-8a47-1f3c31272310
935	34	Generated Thumbnail	\N	0	\N	-1	ef695971-00b7-4c43-8a47-1f3c31272310
936	75	reducao_de_perdas_em_saa74.pdf.txt	\N	0	\N	-1	41ca3781-3d14-4290-857b-74de1273742a
937	65	Written by FormatFilter org.dspace.app.mediafilter.PDFFilter on 2019-01-20T20:20:39Z (GMT).	\N	0	\N	-1	41ca3781-3d14-4290-857b-74de1273742a
938	34	Extracted text	\N	0	\N	-1	41ca3781-3d14-4290-857b-74de1273742a
939	75	reducao_de_perdas_em_saa74.pdf.jpg	\N	0	\N	-1	ae7ac122-7e41-4d56-8699-1a0c44e62241
940	65	Written by FormatFilter org.dspace.app.mediafilter.PDFBoxThumbnail on 2019-01-20T20:20:42Z (GMT).	\N	0	\N	-1	ae7ac122-7e41-4d56-8699-1a0c44e62241
941	34	Generated Thumbnail	\N	0	\N	-1	ae7ac122-7e41-4d56-8699-1a0c44e62241
942	75	reducao_de_perdas_em_saa74.pdf.jpg	\N	0	\N	-1	9ca1f9d3-7329-431a-8925-de7be40f98f1
943	65	Written by FormatFilter org.dspace.app.mediafilter.ImageMagickPdfThumbnailFilter on 2019-01-20T20:20:46Z (GMT).	\N	0	\N	-1	9ca1f9d3-7329-431a-8925-de7be40f98f1
944	34	IM Thumbnail	\N	0	\N	-1	9ca1f9d3-7329-431a-8925-de7be40f98f1
969	75	orientacoesparapadronizacaodedocumentostecnicos.pdf.txt	\N	0	\N	-1	f0370f2f-d71c-4799-9e2a-aa5c4f0efe12
970	65	Written by FormatFilter org.dspace.app.mediafilter.PDFFilter on 2019-01-20T20:33:44Z (GMT).	\N	0	\N	-1	f0370f2f-d71c-4799-9e2a-aa5c4f0efe12
971	34	Extracted text	\N	0	\N	-1	f0370f2f-d71c-4799-9e2a-aa5c4f0efe12
972	75	orientacoesparapadronizacaodedocumentostecnicos.pdf.jpg	\N	0	\N	-1	a35fbc18-7ef2-4f1d-9673-e6cc6330b8a9
973	65	Written by FormatFilter org.dspace.app.mediafilter.PDFBoxThumbnail on 2019-01-20T20:33:48Z (GMT).	\N	0	\N	-1	a35fbc18-7ef2-4f1d-9673-e6cc6330b8a9
974	34	Generated Thumbnail	\N	0	\N	-1	a35fbc18-7ef2-4f1d-9673-e6cc6330b8a9
975	75	orientacoesparapadronizacaodedocumentostecnicos.pdf.jpg	\N	0	\N	-1	d532b057-4536-4ca6-ac4b-537d52c2c8bc
976	65	Written by FormatFilter org.dspace.app.mediafilter.ImageMagickPdfThumbnailFilter on 2019-01-20T20:33:51Z (GMT).	\N	0	\N	-1	d532b057-4536-4ca6-ac4b-537d52c2c8bc
977	34	IM Thumbnail	\N	0	\N	-1	d532b057-4536-4ca6-ac4b-537d52c2c8bc
978	75	PLANO_Atuacao_Desastres_2018 WEB.pdf.txt	\N	0	\N	-1	3d0b7cc1-77a0-4562-a8ef-469c0f0bb11c
979	65	Written by FormatFilter org.dspace.app.mediafilter.PDFFilter on 2019-01-20T20:33:53Z (GMT).	\N	0	\N	-1	3d0b7cc1-77a0-4562-a8ef-469c0f0bb11c
768	35	A padronização de documentos é um processo que aplica regras a fim de abordar ordenadamente atividades específicas, por exemplo, as relativas à elaboração de projetos de abastecimento de água e esgotamento sanitário.	en_US	0	\N	-1	1f0c95ab-3775-4094-b293-183d3b5074b2
769	36	Submitted by Emiliano Marmonti (emarmonti@gmail.com) on 2019-01-09T17:57:18Z\r\nNo. of bitstreams: 1\r\norientacoesparapadronizacaodedocumentostecnicos.pdf: 1062348 bytes, checksum: e1032c18f29644821c1ca184abe7f627 (MD5)	en	0	\N	-1	1f0c95ab-3775-4094-b293-183d3b5074b2
770	36	Made available in DSpace on 2019-01-09T17:57:18Z (GMT). No. of bitstreams: 1\r\norientacoesparapadronizacaodedocumentostecnicos.pdf: 1062348 bytes, checksum: e1032c18f29644821c1ca184abe7f627 (MD5)\r\n  Previous issue date: 2014	en	1	\N	-1	1f0c95ab-3775-4094-b293-183d3b5074b2
771	25	Brasil. Ministério da Saúde. Fundação Nacional de Saúde.  Orientações para Padronização de Documentos Técnicos referentes a Sistemas de Abastecimento de Água (SAA) e Esgotamento Sanitário (SES). – Brasília : Funasa, 2014.  28 p. – (Série A. Normas e Manuais Técnicos)	en_US	0	\N	-1	1f0c95ab-3775-4094-b293-183d3b5074b2
773	47	pt	en_US	0	\N	-1	1f0c95ab-3775-4094-b293-183d3b5074b2
774	48	FUNASA	en_US	0	\N	-1	1f0c95ab-3775-4094-b293-183d3b5074b2
775	64	FUNASA	en_US	0	\N	-1	1f0c95ab-3775-4094-b293-183d3b5074b2
776	68	Esgotamento Profissional	en_US	0	Esgotamento Profissional	600	1f0c95ab-3775-4094-b293-183d3b5074b2
777	68	Saneamento Urbano	en_US	1	Saneamento Urbano	600	1f0c95ab-3775-4094-b293-183d3b5074b2
778	75	Orientações para Padronização de Documentos Técnicos referentes a Sistemas de Abastecimento de Água (SAA) e Esgotamento Sanitário (SES)	en_US	0	\N	-1	1f0c95ab-3775-4094-b293-183d3b5074b2
779	78	Official Document	en_US	0	\N	-1	1f0c95ab-3775-4094-b293-183d3b5074b2
780	138	1	en_US	0	\N	-1	1f0c95ab-3775-4094-b293-183d3b5074b2
781	139	Brasilia	en_US	0	\N	-1	1f0c95ab-3775-4094-b293-183d3b5074b2
782	140	Brazil	en_US	0	\N	-1	1f0c95ab-3775-4094-b293-183d3b5074b2
783	143	Cat 3. Determinants of Health and Promoting Health throughout the Life Course	en_US	0	\N	-1	1f0c95ab-3775-4094-b293-183d3b5074b2
784	75	TEXT	\N	1	\N	-1	e629b0d9-bf91-439a-9f16-632d621535b2
785	75	orientacoesparapadronizacaodedocumentostecnicos.pdf.txt	\N	0	\N	-1	34482a2e-2400-4e9f-85a2-c7e9a654af28
786	65	Written by FormatFilter org.dspace.app.mediafilter.PDFFilter on 2019-01-09T18:00:49Z (GMT).	\N	0	\N	-1	34482a2e-2400-4e9f-85a2-c7e9a654af28
787	34	Extracted text	\N	0	\N	-1	34482a2e-2400-4e9f-85a2-c7e9a654af28
788	75	THUMBNAIL	\N	1	\N	-1	972d8284-ac47-4d48-82fe-103a24fbe65b
789	75	orientacoesparapadronizacaodedocumentostecnicos.pdf.jpg	\N	0	\N	-1	15560463-2b70-4a26-9df1-e0de90c0df9e
790	65	Written by FormatFilter org.dspace.app.mediafilter.PDFBoxThumbnail on 2019-01-09T18:00:53Z (GMT).	\N	0	\N	-1	15560463-2b70-4a26-9df1-e0de90c0df9e
791	34	Generated Thumbnail	\N	0	\N	-1	15560463-2b70-4a26-9df1-e0de90c0df9e
2304	155	123456789/371	pt_BR	0	\N	-1	b1c7cc22-a459-4f55-99cc-98fc7e9829cd
2314	174	123456789/371		0	\N	-1	24fb983c-62fc-41d7-9a45-45bf55a5359c
824	10	Fundação Nacional de Saúde (FUNASA)	en_US	0	\N	-1	b37744b2-292c-4937-a401-9243b80980b3
825	10	Fundação Nacional de Saúde (FUNASA)	en_US	1	\N	-1	b37744b2-292c-4937-a401-9243b80980b3
826	75	Plano de Atuação da Funasa em Situações de Desastres	en_US	0	\N	-1	b37744b2-292c-4937-a401-9243b80980b3
827	35	O Plano de Atuação da Funasa em Situações de Desastres, instituído por meio da Portaria Funasa nº 7558, de 17 de dezembro de 2018, se propõe ampliar e melhorar os conhecimentos relativos as ações de apoio da Fundação Nacional de Saúde para atendimento de desastres e emergências, contribuindo no planejamento das ações e definição das diretrizes de atuação da instituição neste tipo de problemática que permitam apoiar Estados, Municípios e Distrito Federal, em situação de risco à saúde humana.	en_US	0	\N	-1	b37744b2-292c-4937-a401-9243b80980b3
828	39	1. INTRODUÇÃO 6\r\n2. JUSTIFICATIVA 8\r\n3. OBJETIVOS 10\r\nObjetivo geral 11\r\nObjetivos específicos 11\r\n4. GESTÃO DO RISCO DE DESASTRES 12\r\n5. AÇÕES DE PREVENÇÃO DA FUNASA 15\r\n6. ESTRUTURA ORGANIZACIONAL DA FUNASA NO APOIO A SITUAÇÕES DE\r\nDESASTRES 17\r\nComitê de Gestão em Desastres 18\r\nArticulação com agentes envolvidos em nível estadual e federal 19\r\nGrupo de Resposta em Desastres Estadual (GRD Estadual) 19\r\n7. ATUAÇÃO DA FUNASA EM SITUAÇÕES DE DEASTRES 21\r\nAcionamento 22\r\nPlanejamento das ações 23\r\nLevantamento situacional do desastre 23\r\nPlanejamento das ações a serem realizadas pelo GRD Estadual da FUNASA para\r\nauxiliar o atendimento da ocorrência e custos necessários 23\r\nRealização das ações do GRD Estadual 28\r\nAções da Coordenação de Projetos e Ações Estratégicas em Saúde Ambiental 28\r\nAções de apoio relacionadas à Educação em Saúde Ambiental 29\r\nAções de apoio relacionadas ao controle da qualidade da água para\r\nconsumo humano 30\r\nAtividades relacionadas à Engenharia de Saúde Pública 33\r\nAções relacionadas ao fornecimento emergencial de água para consumo humano 36\r\nConclusão de atividades do GRD Estadual 41\r\n8. BIOSSEGURANÇA E SAÚDE DO TRABALHADOR 42\r\n9. AÇÕES DE ESTRUTURAÇÃO 47\r\nREFERÊNCIAS BIBLIOGRÁFICAS 49\r\nAnexo I\r\nConceitos relacionados a desastres 52\r\nO Decreto nº 7.257, de 4 de agosto de 2010 (Brasil, 2010d) conceitua: 53\r\nAnexo II\r\nUnidade Móvel de Tratamento de Água de Baixa Turbidez da FUNASA (UMTA) 59	en_US	0	\N	-1	b37744b2-292c-4937-a401-9243b80980b3
829	47	pt	en_US	0	\N	-1	b37744b2-292c-4937-a401-9243b80980b3
830	78	Official Document	en_US	0	\N	-1	b37744b2-292c-4937-a401-9243b80980b3
831	68	Desastres	en_US	0	Desastres	600	b37744b2-292c-4937-a401-9243b80980b3
832	68	Planejamento em Desastres	en_US	1	Planejamento em Desastres	600	b37744b2-292c-4937-a401-9243b80980b3
833	48	FUNASA	en_US	0	\N	-1	b37744b2-292c-4937-a401-9243b80980b3
834	140	Brazil	en_US	0	\N	-1	b37744b2-292c-4937-a401-9243b80980b3
835	139	Brasilia	en_US	0	\N	-1	b37744b2-292c-4937-a401-9243b80980b3
949	65	Written by FormatFilter org.dspace.app.mediafilter.PDFBoxThumbnail on 2019-01-20T20:28:32Z (GMT).	\N	0	\N	-1	2e5c87b0-0c5d-47fb-af1a-bffe4a2305be
837	27	978-85-7346-057-5	\N	0	\N	-1	b37744b2-292c-4937-a401-9243b80980b3
839	64	FUNASA	en_US	0	\N	-1	b37744b2-292c-4937-a401-9243b80980b3
948	75	orientacoesparapadronizacaodedocumentostecnicos.pdf.jpg	\N	0	\N	-1	2e5c87b0-0c5d-47fb-af1a-bffe4a2305be
950	34	Generated Thumbnail	\N	0	\N	-1	2e5c87b0-0c5d-47fb-af1a-bffe4a2305be
951	75	orientacoesparapadronizacaodedocumentostecnicos.pdf.jpg	\N	0	\N	-1	fc2aee31-cfb0-41b6-9b61-84b092376ea9
952	65	Written by FormatFilter org.dspace.app.mediafilter.ImageMagickPdfThumbnailFilter on 2019-01-20T20:28:37Z (GMT).	\N	0	\N	-1	fc2aee31-cfb0-41b6-9b61-84b092376ea9
1053	75	PLANO_Atuacao_Desastres_2018 WEB.pdf.txt	\N	0	\N	-1	551fa807-a0c5-4594-8861-b4b6f6f6d82e
1055	34	Extracted text	\N	0	\N	-1	551fa807-a0c5-4594-8861-b4b6f6f6d82e
838	25	Brasil. Ministério da Saúde. Fundação Nacional da Saúde. Plano de atuação da Funasa em situações de desastres / Fundação Nacional de Saúde. – Brasília : Funasa, 2018. 62 p. ISBN 978-85-7346-057-5 1. Equipamentos e Provisões em Desastres. 2. Avaliação de Risco e Mitigação. 3. Desastres. 4. Saúde Ambiental. I. Título	en_US	0	\N	-1	b37744b2-292c-4937-a401-9243b80980b3
840	138	1	en_US	0	\N	-1	b37744b2-292c-4937-a401-9243b80980b3
841	75	ORIGINAL	\N	1	\N	-1	5c1126f4-8376-42d3-b83e-3f4f070a6710
1880	36	Submitted by Fábio Luís de Brito (britofa@paho.org) on 2019-05-10T13:14:32Z\nNo. of bitstreams: 1\nteste_upload.txt: 24 bytes, checksum: 8a40b4d31a53dd39dfa5b541022e09ce (MD5)	en	0	\N	-1	d450501d-bb9e-4ec6-9691-e27f33bba466
919	65	Written by FormatFilter org.dspace.app.mediafilter.PDFBoxThumbnail on 2019-01-20T20:10:57Z (GMT).	\N	0	\N	-1	24f41a56-b4f0-43f7-858d-5fcb0621541b
953	34	IM Thumbnail	\N	0	\N	-1	fc2aee31-cfb0-41b6-9b61-84b092376ea9
842	75	PLANO_Atuacao_Desastres_2018 WEB.pdf	\N	0	\N	-1	0d9ed226-7e90-48b9-807d-f0b893dd48b0
843	65	PLANO_Atuacao_Desastres_2018 WEB.pdf	\N	0	\N	-1	0d9ed226-7e90-48b9-807d-f0b893dd48b0
845	34	Main file	\N	0	\N	-1	0d9ed226-7e90-48b9-807d-f0b893dd48b0
846	75	LICENSE	\N	1	\N	-1	276a4446-ee69-4bc0-8f29-690dbf3fbaa2
847	75	license.txt	\N	0	\N	-1	599069e2-0776-4d86-8654-9c6352b3b7c7
848	65	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	599069e2-0776-4d86-8654-9c6352b3b7c7
849	36	Submitted by Emiliano Marmonti (emarmonti@gmail.com) on 2019-01-10T00:30:54Z\nNo. of bitstreams: 1\nPLANO_Atuacao_Desastres_2018 WEB.pdf: 1329667 bytes, checksum: 988c5ed45e6bf01f93d439b367eca981 (MD5)	en	0	\N	-1	b37744b2-292c-4937-a401-9243b80980b3
850	33	http://rcfunasa.bvsalud.org//handle/123456789/355	\N	0	\N	-1	b37744b2-292c-4937-a401-9243b80980b3
854	36	Made available in DSpace on 2019-01-10T00:30:54Z (GMT). No. of bitstreams: 1\nPLANO_Atuacao_Desastres_2018 WEB.pdf: 1329667 bytes, checksum: 988c5ed45e6bf01f93d439b367eca981 (MD5)\n  Previous issue date: 2018	en	1	\N	-1	b37744b2-292c-4937-a401-9243b80980b3
851	18	2019-01-10T00:30:54Z	\N	0	\N	-1	b37744b2-292c-4937-a401-9243b80980b3
852	19	2019-01-10T00:30:54Z	\N	0	\N	-1	b37744b2-292c-4937-a401-9243b80980b3
853	22	2018	\N	0	\N	-1	b37744b2-292c-4937-a401-9243b80980b3
1881	33	http://rcfunasa.bvsalud.org//handle/123456789/371	\N	0	\N	-1	d450501d-bb9e-4ec6-9691-e27f33bba466
2306	156	123456789/359		0	\N	-1	b1c7cc22-a459-4f55-99cc-98fc7e9829cd
2307	157	123456789/359		0	\N	-1	b1c7cc22-a459-4f55-99cc-98fc7e9829cd
2305	156	123456789/359		1	\N	-1	b1c7cc22-a459-4f55-99cc-98fc7e9829cd
2308	158	123456789/359		0	\N	-1	b1c7cc22-a459-4f55-99cc-98fc7e9829cd
3026	78	Recurso Educativo		0	\N	-1	428163a7-e57d-4b39-a5b8-9fd69dc65567
954	75	PLANO_Atuacao_Desastres_2018 WEB.pdf.txt	\N	0	\N	-1	b7ff174d-067a-4e2c-8e44-3a5482ba8034
955	65	Written by FormatFilter org.dspace.app.mediafilter.PDFFilter on 2019-01-20T20:28:39Z (GMT).	\N	0	\N	-1	b7ff174d-067a-4e2c-8e44-3a5482ba8034
956	34	Extracted text	\N	0	\N	-1	b7ff174d-067a-4e2c-8e44-3a5482ba8034
866	10	Fundação Nacional de Saúde (FUNASA)	en_US	0	\N	-1	25cb38d4-142c-4282-a4cc-b7be4e8f363b
867	9	Baggio, Mario Augusto	\N	0	\N	-1	25cb38d4-142c-4282-a4cc-b7be4e8f363b
868	75	Redução de Perdas em Sistemas de Abastecimento de Água	en_US	0	\N	-1	25cb38d4-142c-4282-a4cc-b7be4e8f363b
869	77	2da	en_US	0	\N	-1	25cb38d4-142c-4282-a4cc-b7be4e8f363b
870	35	Ao longo de sua história de quase três décadas, a Assemae teve sempre uma atuação contundente de defesa e apoio aos serviços públicos municipais de saneamento, e empunhou a bandeira do municipalismo, incentivando e valorizando os gestores públicos, pois reconhece que é nos municípios que se manifestam as demandas dos moradores, e é também nos municípios que as políticas públicas se consolidam.	en_US	0	\N	-1	25cb38d4-142c-4282-a4cc-b7be4e8f363b
872	47	pt	en_US	0	\N	-1	25cb38d4-142c-4282-a4cc-b7be4e8f363b
873	78	Official Document	en_US	0	\N	-1	25cb38d4-142c-4282-a4cc-b7be4e8f363b
874	68	Abastecimento de Água	en_US	0	Abastecimento de Água	600	25cb38d4-142c-4282-a4cc-b7be4e8f363b
875	143	Cat 5. Preparedness, Surveillance, and Response	en_US	0	\N	-1	25cb38d4-142c-4282-a4cc-b7be4e8f363b
876	48	FUNASA	en_US	0	\N	-1	25cb38d4-142c-4282-a4cc-b7be4e8f363b
877	140	Brazil	en_US	0	\N	-1	25cb38d4-142c-4282-a4cc-b7be4e8f363b
878	139	Brasilia	en_US	0	\N	-1	25cb38d4-142c-4282-a4cc-b7be4e8f363b
957	75	PLANO_Atuacao_Desastres_2018 WEB.pdf.jpg	\N	0	\N	-1	43fc62cf-973e-46f8-bc35-ca46c9cf1952
958	65	Written by FormatFilter org.dspace.app.mediafilter.PDFBoxThumbnail on 2019-01-20T20:28:40Z (GMT).	\N	0	\N	-1	43fc62cf-973e-46f8-bc35-ca46c9cf1952
959	34	Generated Thumbnail	\N	0	\N	-1	43fc62cf-973e-46f8-bc35-ca46c9cf1952
960	75	reducao_de_perdas_em_saa74.pdf.txt	\N	0	\N	-1	d222311e-6af9-453e-a7e8-a51be09ab3af
961	65	Written by FormatFilter org.dspace.app.mediafilter.PDFFilter on 2019-01-20T20:28:42Z (GMT).	\N	0	\N	-1	d222311e-6af9-453e-a7e8-a51be09ab3af
962	34	Extracted text	\N	0	\N	-1	d222311e-6af9-453e-a7e8-a51be09ab3af
963	75	reducao_de_perdas_em_saa74.pdf.jpg	\N	0	\N	-1	1e206441-d46b-41a3-bde6-b16ab75b9e22
964	65	Written by FormatFilter org.dspace.app.mediafilter.PDFBoxThumbnail on 2019-01-20T20:28:46Z (GMT).	\N	0	\N	-1	1e206441-d46b-41a3-bde6-b16ab75b9e22
965	34	Generated Thumbnail	\N	0	\N	-1	1e206441-d46b-41a3-bde6-b16ab75b9e22
966	75	reducao_de_perdas_em_saa74.pdf.jpg	\N	0	\N	-1	094768e3-b838-4ce5-811d-114d2fa070cb
967	65	Written by FormatFilter org.dspace.app.mediafilter.ImageMagickPdfThumbnailFilter on 2019-01-20T20:28:51Z (GMT).	\N	0	\N	-1	094768e3-b838-4ce5-811d-114d2fa070cb
968	34	IM Thumbnail	\N	0	\N	-1	094768e3-b838-4ce5-811d-114d2fa070cb
980	34	Extracted text	\N	0	\N	-1	3d0b7cc1-77a0-4562-a8ef-469c0f0bb11c
981	75	PLANO_Atuacao_Desastres_2018 WEB.pdf.jpg	\N	0	\N	-1	d7fdf9dd-5702-4353-b54f-8700d7d39cb2
982	65	Written by FormatFilter org.dspace.app.mediafilter.PDFBoxThumbnail on 2019-01-20T20:33:53Z (GMT).	\N	0	\N	-1	d7fdf9dd-5702-4353-b54f-8700d7d39cb2
983	34	Generated Thumbnail	\N	0	\N	-1	d7fdf9dd-5702-4353-b54f-8700d7d39cb2
984	75	reducao_de_perdas_em_saa74.pdf.txt	\N	0	\N	-1	2b6bf1e3-bc59-4c23-ba1b-b99c4f8b6076
985	65	Written by FormatFilter org.dspace.app.mediafilter.PDFFilter on 2019-01-20T20:33:56Z (GMT).	\N	0	\N	-1	2b6bf1e3-bc59-4c23-ba1b-b99c4f8b6076
986	34	Extracted text	\N	0	\N	-1	2b6bf1e3-bc59-4c23-ba1b-b99c4f8b6076
987	75	reducao_de_perdas_em_saa74.pdf.jpg	\N	0	\N	-1	3e3f1469-9f2d-4ad6-88f1-e11fcb9bbd73
988	65	Written by FormatFilter org.dspace.app.mediafilter.PDFBoxThumbnail on 2019-01-20T20:33:58Z (GMT).	\N	0	\N	-1	3e3f1469-9f2d-4ad6-88f1-e11fcb9bbd73
989	34	Generated Thumbnail	\N	0	\N	-1	3e3f1469-9f2d-4ad6-88f1-e11fcb9bbd73
990	75	reducao_de_perdas_em_saa74.pdf.jpg	\N	0	\N	-1	c79ad9e7-f621-4ec5-a0d9-c2bcffb8e307
871	39	Apresentação 7\r\nIntrodução 9\r\n1 Objetivo do Manual 11\r\n2 Conceituação de Perdas 13\r\n3 Produção x demanda: a inequação a ser buscada 15\r\n4 Caracterização das perdas 17\r\n4.1 Indicadores de perdas e suas variáveis, estabelecidos pelos Sistemas de\r\nInformações (adotou-se como ponto de referência o SISPERDAS da SABESP) 19\r\n4.4.1 Indicadores de Perdas 19\r\n4.1.2 Indicadores de Infraestrutura 19\r\n4.1.3 Variáveis de cálculo dos Indicadores de Perdas 20\r\n4.1.4 De Volumes e outras Variáveis 22\r\n4.2 Sistema de Informações de Controle de Perdas - SISPERDAS 23\r\n5 Conceituação das metodologias de redução de perdas 27\r\n5.1 Conceituação da IWA 28\r\n5.2 Conceituação do MASP_PERDAS – MASPP I (Foco nas Causas Especiais) 32\r\n5.3 Conceituação do MASP_PERDAS – MASPP II (Foco nas Causas Comuns) 37\r\n5.4 Comparação entre as metodologias 44\r\n6 Ações estruturais e não estruturais do programa de controle e redução de perdas 47\r\n7 Níveis de controle utilizados para tomada de decisão 49\r\n8 Conclusões e recomendações 51\r\nPlanejamento e controle da qualidade da operação de sistemas\r\nde abastecimento de água: o enfoque da operação 53\r\nReferências Bibliográficas 55\r\nApêndice A 57\r\nApêndice B 65\r\nApêndice C 67\r\nApêndice D 71\r\nApêndice E 77\r\nAnexo A (Apêndice D) - Alternativas para Planejamento e Controle da Operação de\r\nSistemas de Abastecimento de Água 79\r\nAnexo B (Apêndice E) - Termo de Referência para o Desenvolvimento dos Sistemas de\r\nInformações e de Medição Hidráulica para o Controle da\r\nOperação de um Sistema de Abastecimento de Água 89\r\nAnexo C - Lei Nº. 11.445, de 5 de janeiro de 2007 121\r\nAnexo D - Decreto nº 7.217, de 21 de junho de 2010 141	en_US	0	\N	-1	25cb38d4-142c-4282-a4cc-b7be4e8f363b
2309	162	123456789/359		0	\N	-1	b1c7cc22-a459-4f55-99cc-98fc7e9829cd
880	25	Brasil. Ministério da Saúde. Fundação Nacional de Saúde.  Redução de perdas em sistemas de abastecimento de água / Ministério da Saúde, Fundação Nacional de Saúde. 2. ed. – Brasília : Funasa, 2014.  172 p.  1. Abastecimento de água. 2. Controle de perda de água. 3. Água. I. Título. II. Série.	en_US	0	\N	-1	25cb38d4-142c-4282-a4cc-b7be4e8f363b
881	64	FUNASA	en_US	0	\N	-1	25cb38d4-142c-4282-a4cc-b7be4e8f363b
882	138	1	en_US	0	\N	-1	25cb38d4-142c-4282-a4cc-b7be4e8f363b
883	75	ORIGINAL	\N	1	\N	-1	a260f402-ab1b-48d5-8f31-e54b8246e97e
905	75	TEXT	\N	1	\N	-1	7bba6efb-709f-4b4a-b666-654168314b1c
884	75	reducao_de_perdas_em_saa74.pdf	\N	0	\N	-1	2b2be099-c0d6-40a0-9daf-83fb0c6a8328
885	65	reducao_de_perdas_em_saa74.pdf	\N	0	\N	-1	2b2be099-c0d6-40a0-9daf-83fb0c6a8328
887	34	Arquivo principal	\N	0	\N	-1	2b2be099-c0d6-40a0-9daf-83fb0c6a8328
888	63	http://creativecommons.org/licenses/by-nc-sa/3.0/igo/	*	0	\N	-1	25cb38d4-142c-4282-a4cc-b7be4e8f363b
889	62	Attribution-NonCommercial-ShareAlike 3.0 IGO	*	0	\N	-1	25cb38d4-142c-4282-a4cc-b7be4e8f363b
890	75	LICENSE	\N	1	\N	-1	2dd047b5-e43b-4ba9-8d1d-b6badc87a459
906	75	PLANO_Atuacao_Desastres_2018 WEB.pdf.txt	\N	0	\N	-1	7b26105a-af1e-4b1f-a66a-f8267a25b94b
907	65	Written by FormatFilter org.dspace.app.mediafilter.PDFFilter on 2019-01-20T20:10:50Z (GMT).	\N	0	\N	-1	7b26105a-af1e-4b1f-a66a-f8267a25b94b
891	75	license.txt	\N	0	\N	-1	d5ba2f5e-4e86-40fd-b152-3ae25ff15c7d
892	65	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	d5ba2f5e-4e86-40fd-b152-3ae25ff15c7d
893	36	Submitted by Emiliano Marmonti (emarmonti@gmail.com) on 2019-01-10T04:34:37Z\nNo. of bitstreams: 1\nreducao_de_perdas_em_saa74.pdf: 9879310 bytes, checksum: 69fe6fc72ec299bb38047f8305ec6581 (MD5)	en	0	\N	-1	25cb38d4-142c-4282-a4cc-b7be4e8f363b
894	33	http://rcfunasa.bvsalud.org//handle/123456789/356	\N	0	\N	-1	25cb38d4-142c-4282-a4cc-b7be4e8f363b
908	34	Extracted text	\N	0	\N	-1	7b26105a-af1e-4b1f-a66a-f8267a25b94b
909	75	THUMBNAIL	\N	1	\N	-1	539670a8-3427-4d5c-96ac-02b95f900003
898	36	Made available in DSpace on 2019-01-10T04:34:37Z (GMT). No. of bitstreams: 1\nreducao_de_perdas_em_saa74.pdf: 9879310 bytes, checksum: 69fe6fc72ec299bb38047f8305ec6581 (MD5)\n  Previous issue date: 2014	en	1	\N	-1	25cb38d4-142c-4282-a4cc-b7be4e8f363b
895	18	2019-01-10T04:34:37Z	\N	0	\N	-1	25cb38d4-142c-4282-a4cc-b7be4e8f363b
896	19	2019-01-10T04:34:37Z	\N	0	\N	-1	25cb38d4-142c-4282-a4cc-b7be4e8f363b
897	22	2014	\N	0	\N	-1	25cb38d4-142c-4282-a4cc-b7be4e8f363b
899	75	orientacoesparapadronizacaodedocumentostecnicos.pdf.txt	\N	0	\N	-1	91adcac7-c635-47a7-9816-5a36a00e79be
900	65	Written by FormatFilter org.dspace.app.mediafilter.PDFFilter on 2019-01-20T20:10:43Z (GMT).	\N	0	\N	-1	91adcac7-c635-47a7-9816-5a36a00e79be
901	34	Extracted text	\N	0	\N	-1	91adcac7-c635-47a7-9816-5a36a00e79be
902	75	orientacoesparapadronizacaodedocumentostecnicos.pdf.jpg	\N	0	\N	-1	dc46a916-640f-4d78-bf42-a019a5176256
903	65	Written by FormatFilter org.dspace.app.mediafilter.PDFBoxThumbnail on 2019-01-20T20:10:48Z (GMT).	\N	0	\N	-1	dc46a916-640f-4d78-bf42-a019a5176256
904	34	Generated Thumbnail	\N	0	\N	-1	dc46a916-640f-4d78-bf42-a019a5176256
910	75	PLANO_Atuacao_Desastres_2018 WEB.pdf.jpg	\N	0	\N	-1	0161965c-a80c-46ab-b33a-d596c6eb912a
911	65	Written by FormatFilter org.dspace.app.mediafilter.PDFBoxThumbnail on 2019-01-20T20:10:50Z (GMT).	\N	0	\N	-1	0161965c-a80c-46ab-b33a-d596c6eb912a
912	34	Generated Thumbnail	\N	0	\N	-1	0161965c-a80c-46ab-b33a-d596c6eb912a
913	75	TEXT	\N	1	\N	-1	9709fcb3-1e1e-4825-89cf-6774de18420b
914	75	reducao_de_perdas_em_saa74.pdf.txt	\N	0	\N	-1	9ec2493d-5731-4e86-a02e-a9e9cf3b2e12
915	65	Written by FormatFilter org.dspace.app.mediafilter.PDFFilter on 2019-01-20T20:10:53Z (GMT).	\N	0	\N	-1	9ec2493d-5731-4e86-a02e-a9e9cf3b2e12
916	34	Extracted text	\N	0	\N	-1	9ec2493d-5731-4e86-a02e-a9e9cf3b2e12
917	75	THUMBNAIL	\N	1	\N	-1	a63a3b39-a5c2-478d-b57b-c250553fa2e0
918	75	reducao_de_perdas_em_saa74.pdf.jpg	\N	0	\N	-1	24f41a56-b4f0-43f7-858d-5fcb0621541b
920	34	Generated Thumbnail	\N	0	\N	-1	24f41a56-b4f0-43f7-858d-5fcb0621541b
921	75	orientacoesparapadronizacaodedocumentostecnicos.pdf.txt	\N	0	\N	-1	2f994c23-2fe4-4031-9b44-fd2d8b3036a8
922	65	Written by FormatFilter org.dspace.app.mediafilter.PDFFilter on 2019-01-20T20:20:24Z (GMT).	\N	0	\N	-1	2f994c23-2fe4-4031-9b44-fd2d8b3036a8
923	34	Extracted text	\N	0	\N	-1	2f994c23-2fe4-4031-9b44-fd2d8b3036a8
924	75	orientacoesparapadronizacaodedocumentostecnicos.pdf.jpg	\N	0	\N	-1	3d028ecc-c3ff-4a05-acda-2afbfe231cb5
925	65	Written by FormatFilter org.dspace.app.mediafilter.PDFBoxThumbnail on 2019-01-20T20:20:28Z (GMT).	\N	0	\N	-1	3d028ecc-c3ff-4a05-acda-2afbfe231cb5
926	34	Generated Thumbnail	\N	0	\N	-1	3d028ecc-c3ff-4a05-acda-2afbfe231cb5
929	34	IM Thumbnail	\N	0	\N	-1	91ff9e31-a61d-42bb-9fdd-405a17220205
945	75	orientacoesparapadronizacaodedocumentostecnicos.pdf.txt	\N	0	\N	-1	bdd0442a-c010-4085-91e6-08ae289263d6
946	65	Written by FormatFilter org.dspace.app.mediafilter.PDFFilter on 2019-01-20T20:28:27Z (GMT).	\N	0	\N	-1	bdd0442a-c010-4085-91e6-08ae289263d6
947	34	Extracted text	\N	0	\N	-1	bdd0442a-c010-4085-91e6-08ae289263d6
991	65	Written by FormatFilter org.dspace.app.mediafilter.ImageMagickPdfThumbnailFilter on 2019-01-20T20:34:03Z (GMT).	\N	0	\N	-1	c79ad9e7-f621-4ec5-a0d9-c2bcffb8e307
992	34	IM Thumbnail	\N	0	\N	-1	c79ad9e7-f621-4ec5-a0d9-c2bcffb8e307
1670	154	São Paulo	en_US	0	\N	-1	09d7f4dc-8fce-43c0-b778-0df584c2739f
1671	152	Brasil	en_US	0	\N	-1	09d7f4dc-8fce-43c0-b778-0df584c2739f
1672	153	São Paulo	en_US	0	\N	-1	09d7f4dc-8fce-43c0-b778-0df584c2739f
1029	75	orientacoesparapadronizacaodedocumentostecnicos.pdf.jpg	\N	0	\N	-1	0f75ba2c-cff7-496b-a5f8-b02ab18a4081
1030	65	Written by FormatFilter org.dspace.app.mediafilter.ImageMagickPdfThumbnailFilter on 2019-01-20T21:23:27Z (GMT).	\N	0	\N	-1	0f75ba2c-cff7-496b-a5f8-b02ab18a4081
1031	34	IM Thumbnail	\N	0	\N	-1	0f75ba2c-cff7-496b-a5f8-b02ab18a4081
996	75	orientacoesparapadronizacaodedocumentostecnicos.pdf.txt	\N	0	\N	-1	7f497245-2823-4263-9d37-96793901a7cd
997	65	Written by FormatFilter org.dspace.app.mediafilter.PDFFilter on 2019-01-20T20:39:41Z (GMT).	\N	0	\N	-1	7f497245-2823-4263-9d37-96793901a7cd
998	34	Extracted text	\N	0	\N	-1	7f497245-2823-4263-9d37-96793901a7cd
999	75	orientacoesparapadronizacaodedocumentostecnicos.pdf.jpg	\N	0	\N	-1	6aac1840-ba1a-4fbf-98c7-3639d6baf971
1000	65	Written by FormatFilter org.dspace.app.mediafilter.ImageMagickPdfThumbnailFilter on 2019-01-20T20:39:44Z (GMT).	\N	0	\N	-1	6aac1840-ba1a-4fbf-98c7-3639d6baf971
1001	34	IM Thumbnail	\N	0	\N	-1	6aac1840-ba1a-4fbf-98c7-3639d6baf971
1002	75	PLANO_Atuacao_Desastres_2018 WEB.pdf.txt	\N	0	\N	-1	bd8f5557-4558-4906-96cf-2b0bf72fe8f5
1003	65	Written by FormatFilter org.dspace.app.mediafilter.PDFFilter on 2019-01-20T20:39:45Z (GMT).	\N	0	\N	-1	bd8f5557-4558-4906-96cf-2b0bf72fe8f5
1004	34	Extracted text	\N	0	\N	-1	bd8f5557-4558-4906-96cf-2b0bf72fe8f5
1005	75	reducao_de_perdas_em_saa74.pdf.txt	\N	0	\N	-1	43f467c7-150e-4fca-ae72-d736dd3be02e
1006	65	Written by FormatFilter org.dspace.app.mediafilter.PDFFilter on 2019-01-20T20:39:48Z (GMT).	\N	0	\N	-1	43f467c7-150e-4fca-ae72-d736dd3be02e
1007	34	Extracted text	\N	0	\N	-1	43f467c7-150e-4fca-ae72-d736dd3be02e
1008	75	reducao_de_perdas_em_saa74.pdf.jpg	\N	0	\N	-1	fd0b8087-877f-4855-ad71-9c24986821dd
1009	65	Written by FormatFilter org.dspace.app.mediafilter.ImageMagickPdfThumbnailFilter on 2019-01-20T20:39:51Z (GMT).	\N	0	\N	-1	fd0b8087-877f-4855-ad71-9c24986821dd
1010	34	IM Thumbnail	\N	0	\N	-1	fd0b8087-877f-4855-ad71-9c24986821dd
1011	75	orientacoesparapadronizacaodedocumentostecnicos.pdf.txt	\N	0	\N	-1	b769f832-39bf-4295-bafb-418932987f3d
1012	65	Written by FormatFilter org.dspace.app.mediafilter.PDFFilter on 2019-01-20T20:46:04Z (GMT).	\N	0	\N	-1	b769f832-39bf-4295-bafb-418932987f3d
1013	34	Extracted text	\N	0	\N	-1	b769f832-39bf-4295-bafb-418932987f3d
1014	75	orientacoesparapadronizacaodedocumentostecnicos.pdf.jpg	\N	0	\N	-1	44939725-96d2-4935-8030-00bb43cad6fc
1015	65	Written by FormatFilter org.dspace.app.mediafilter.ImageMagickPdfThumbnailFilter on 2019-01-20T20:46:09Z (GMT).	\N	0	\N	-1	44939725-96d2-4935-8030-00bb43cad6fc
1016	34	IM Thumbnail	\N	0	\N	-1	44939725-96d2-4935-8030-00bb43cad6fc
1017	75	PLANO_Atuacao_Desastres_2018 WEB.pdf.txt	\N	0	\N	-1	e44af120-0129-47e5-993b-09b5d17149e3
1018	65	Written by FormatFilter org.dspace.app.mediafilter.PDFFilter on 2019-01-20T20:46:12Z (GMT).	\N	0	\N	-1	e44af120-0129-47e5-993b-09b5d17149e3
1019	34	Extracted text	\N	0	\N	-1	e44af120-0129-47e5-993b-09b5d17149e3
1020	75	reducao_de_perdas_em_saa74.pdf.txt	\N	0	\N	-1	773d1a57-3eec-45c7-9d19-0c011d2e4b1f
1021	65	Written by FormatFilter org.dspace.app.mediafilter.PDFFilter on 2019-01-20T20:46:14Z (GMT).	\N	0	\N	-1	773d1a57-3eec-45c7-9d19-0c011d2e4b1f
1022	34	Extracted text	\N	0	\N	-1	773d1a57-3eec-45c7-9d19-0c011d2e4b1f
1023	75	reducao_de_perdas_em_saa74.pdf.jpg	\N	0	\N	-1	13a8e654-e35a-47f7-bce3-c709c5f56beb
1024	65	Written by FormatFilter org.dspace.app.mediafilter.ImageMagickPdfThumbnailFilter on 2019-01-20T20:46:18Z (GMT).	\N	0	\N	-1	13a8e654-e35a-47f7-bce3-c709c5f56beb
1025	34	IM Thumbnail	\N	0	\N	-1	13a8e654-e35a-47f7-bce3-c709c5f56beb
1026	75	orientacoesparapadronizacaodedocumentostecnicos.pdf.txt	\N	0	\N	-1	5c8e9a8c-d250-4519-86ee-90b00716aced
1027	65	Written by FormatFilter org.dspace.app.mediafilter.PDFFilter on 2019-01-20T21:23:24Z (GMT).	\N	0	\N	-1	5c8e9a8c-d250-4519-86ee-90b00716aced
1028	34	Extracted text	\N	0	\N	-1	5c8e9a8c-d250-4519-86ee-90b00716aced
1032	75	PLANO_Atuacao_Desastres_2018 WEB.pdf.txt	\N	0	\N	-1	c0ff9ebd-65e4-4f18-a28d-30fab3441ec9
1033	65	Written by FormatFilter org.dspace.app.mediafilter.PDFFilter on 2019-01-20T21:23:28Z (GMT).	\N	0	\N	-1	c0ff9ebd-65e4-4f18-a28d-30fab3441ec9
1034	34	Extracted text	\N	0	\N	-1	c0ff9ebd-65e4-4f18-a28d-30fab3441ec9
1035	75	PLANO_Atuacao_Desastres_2018 WEB.pdf.jpg	\N	0	\N	-1	060ff518-0b92-4a23-8b14-a53e5d45d5b1
1036	65	Written by FormatFilter org.dspace.app.mediafilter.ImageMagickPdfThumbnailFilter on 2019-01-20T21:23:29Z (GMT).	\N	0	\N	-1	060ff518-0b92-4a23-8b14-a53e5d45d5b1
1037	34	IM Thumbnail	\N	0	\N	-1	060ff518-0b92-4a23-8b14-a53e5d45d5b1
1038	75	reducao_de_perdas_em_saa74.pdf.txt	\N	0	\N	-1	103b738b-104b-4e0c-9331-6b0cae944943
1039	65	Written by FormatFilter org.dspace.app.mediafilter.PDFFilter on 2019-01-20T21:23:32Z (GMT).	\N	0	\N	-1	103b738b-104b-4e0c-9331-6b0cae944943
1040	34	Extracted text	\N	0	\N	-1	103b738b-104b-4e0c-9331-6b0cae944943
1041	75	reducao_de_perdas_em_saa74.pdf.jpg	\N	0	\N	-1	d3b78492-0db6-415b-a406-b3fcb4d9a3ac
1042	65	Written by FormatFilter org.dspace.app.mediafilter.ImageMagickPdfThumbnailFilter on 2019-01-20T21:23:35Z (GMT).	\N	0	\N	-1	d3b78492-0db6-415b-a406-b3fcb4d9a3ac
1043	34	IM Thumbnail	\N	0	\N	-1	d3b78492-0db6-415b-a406-b3fcb4d9a3ac
1044	75	orientacoesparapadronizacaodedocumentostecnicos.pdf.txt	\N	0	\N	-1	5bb00ffc-b25e-487d-a336-aa5b07b778ec
1045	65	Written by FormatFilter org.dspace.app.mediafilter.PDFFilter on 2019-01-20T21:27:05Z (GMT).	\N	0	\N	-1	5bb00ffc-b25e-487d-a336-aa5b07b778ec
1046	34	Extracted text	\N	0	\N	-1	5bb00ffc-b25e-487d-a336-aa5b07b778ec
1047	75	orientacoesparapadronizacaodedocumentostecnicos.pdf.jpg	\N	0	\N	-1	7615c83e-de9f-4751-80d3-b8a8ffbc41cd
1048	65	Written by FormatFilter org.dspace.app.mediafilter.PDFBoxThumbnail on 2019-01-20T21:27:10Z (GMT).	\N	0	\N	-1	7615c83e-de9f-4751-80d3-b8a8ffbc41cd
1049	34	Generated Thumbnail	\N	0	\N	-1	7615c83e-de9f-4751-80d3-b8a8ffbc41cd
1050	75	orientacoesparapadronizacaodedocumentostecnicos.pdf.jpg	\N	0	\N	-1	aedad30e-a19a-468a-9f45-22219de85513
1051	65	Written by FormatFilter org.dspace.app.mediafilter.ImageMagickPdfThumbnailFilter on 2019-01-20T21:27:13Z (GMT).	\N	0	\N	-1	aedad30e-a19a-468a-9f45-22219de85513
1052	34	IM Thumbnail	\N	0	\N	-1	aedad30e-a19a-468a-9f45-22219de85513
1673	163	RAk2oBEj-cY	en_US	0	\N	-1	09d7f4dc-8fce-43c0-b778-0df584c2739f
1674	9	Funasaoficial	en_US	0	\N	-1	09d7f4dc-8fce-43c0-b778-0df584c2739f
1675	10	Funasa	en_US	0	\N	-1	09d7f4dc-8fce-43c0-b778-0df584c2739f
1054	65	Written by FormatFilter org.dspace.app.mediafilter.PDFFilter on 2019-01-20T21:27:15Z (GMT).	\N	0	\N	-1	551fa807-a0c5-4594-8861-b4b6f6f6d82e
1056	75	PLANO_Atuacao_Desastres_2018 WEB.pdf.jpg	\N	0	\N	-1	8eebc70a-4b00-4482-b947-0c5e7294aae0
1057	65	Written by FormatFilter org.dspace.app.mediafilter.PDFBoxThumbnail on 2019-01-20T21:27:15Z (GMT).	\N	0	\N	-1	8eebc70a-4b00-4482-b947-0c5e7294aae0
1058	34	Generated Thumbnail	\N	0	\N	-1	8eebc70a-4b00-4482-b947-0c5e7294aae0
1059	75	PLANO_Atuacao_Desastres_2018 WEB.pdf.jpg	\N	0	\N	-1	5690cd4e-8606-4c7e-ab6d-078223839687
1060	65	Written by FormatFilter org.dspace.app.mediafilter.ImageMagickPdfThumbnailFilter on 2019-01-20T21:27:16Z (GMT).	\N	0	\N	-1	5690cd4e-8606-4c7e-ab6d-078223839687
1061	34	IM Thumbnail	\N	0	\N	-1	5690cd4e-8606-4c7e-ab6d-078223839687
1062	75	reducao_de_perdas_em_saa74.pdf.txt	\N	0	\N	-1	8b34f2e0-5993-4256-9619-3c691d85be98
1063	65	Written by FormatFilter org.dspace.app.mediafilter.PDFFilter on 2019-01-20T21:27:19Z (GMT).	\N	0	\N	-1	8b34f2e0-5993-4256-9619-3c691d85be98
1064	34	Extracted text	\N	0	\N	-1	8b34f2e0-5993-4256-9619-3c691d85be98
1065	75	reducao_de_perdas_em_saa74.pdf.jpg	\N	0	\N	-1	99df2191-1118-4f68-9ebe-0c08df306d89
1066	65	Written by FormatFilter org.dspace.app.mediafilter.PDFBoxThumbnail on 2019-01-20T21:27:22Z (GMT).	\N	0	\N	-1	99df2191-1118-4f68-9ebe-0c08df306d89
1067	34	Generated Thumbnail	\N	0	\N	-1	99df2191-1118-4f68-9ebe-0c08df306d89
1068	75	reducao_de_perdas_em_saa74.pdf.jpg	\N	0	\N	-1	c571a8dc-0d71-42e2-9b92-2b2ef5675ade
1069	65	Written by FormatFilter org.dspace.app.mediafilter.ImageMagickPdfThumbnailFilter on 2019-01-20T21:27:26Z (GMT).	\N	0	\N	-1	c571a8dc-0d71-42e2-9b92-2b2ef5675ade
1070	34	IM Thumbnail	\N	0	\N	-1	c571a8dc-0d71-42e2-9b92-2b2ef5675ade
1676	18	2019-05-08T11:18:12Z		0	\N	-1	09d7f4dc-8fce-43c0-b778-0df584c2739f
1071	1	Emiliano	\N	0	\N	-1	8080f669-d4f0-4f53-a855-35d5dc39c564
1072	2	Marmonti	\N	0	\N	-1	8080f669-d4f0-4f53-a855-35d5dc39c564
1073	3		\N	0	\N	-1	8080f669-d4f0-4f53-a855-35d5dc39c564
1677	19	2019-05-08T11:18:12Z		0	\N	-1	09d7f4dc-8fce-43c0-b778-0df584c2739f
1678	22	2019-05-08		0	\N	-1	09d7f4dc-8fce-43c0-b778-0df584c2739f
1114	3		\N	0	\N	-1	765a25ac-1a70-4bae-96b7-e593fe0caa6e
1074	1	Emiliano	\N	0	\N	-1	7ec15392-187a-4bff-be44-4a77a0735d92
1075	2	Marmonti	\N	0	\N	-1	7ec15392-187a-4bff-be44-4a77a0735d92
1076	3		\N	0	\N	-1	7ec15392-187a-4bff-be44-4a77a0735d92
1679	34	Aliquam erat volutpat. Etiam elementum quam id aliquet porta. Aliquam erat volutpat. Proin risus est, efficitur at euismod ac, porta id neque. Vestibulum ut malesuada nulla. Vivamus commodo mi id tellus faucibus, porta ultricies eros sagittis. Nullam tempus ipsum at fringilla vulputate. Nulla facilisi. Mauris dapibus leo egestas, aliquet lorem ac, fermentum nisi. Nulla vulputate placerat erat eget vestibulum. Sed auctor facilisis nisl sed volutpat. Cras euismod elit dictum eleifend luctus. Phasellus viverra est tortor, at vehicula massa interdum eu.	en_US	0	\N	-1	09d7f4dc-8fce-43c0-b778-0df584c2739f
1885	36	Made available in DSpace on 2019-05-10T13:14:32Z (GMT). No. of bitstreams: 1\nteste_upload.txt: 24 bytes, checksum: 8a40b4d31a53dd39dfa5b541022e09ce (MD5)\n  Previous issue date: 2019-05-10	en	1	\N	-1	d450501d-bb9e-4ec6-9691-e27f33bba466
1882	18	2019-05-10T13:14:32Z	\N	0	\N	-1	d450501d-bb9e-4ec6-9691-e27f33bba466
1115	4	en	\N	0	\N	-1	765a25ac-1a70-4bae-96b7-e593fe0caa6e
2310	161	123456789/359		0	\N	-1	b1c7cc22-a459-4f55-99cc-98fc7e9829cd
2311	164	123456789/359		0	\N	-1	b1c7cc22-a459-4f55-99cc-98fc7e9829cd
2312	165	123456789/359		0	\N	-1	b1c7cc22-a459-4f55-99cc-98fc7e9829cd
2313	176	123456789/371		0	\N	-1	24fb983c-62fc-41d7-9a45-45bf55a5359c
1098	1	Renato	\N	0	\N	-1	a4d10708-6a03-4a32-9b2f-245adb6b6240
1084	1	Teste	\N	0	\N	-1	463c2ddb-cbf5-4d22-b65a-88c79d578ac7
1085	2	Teste	\N	0	\N	-1	463c2ddb-cbf5-4d22-b65a-88c79d578ac7
1086	3		\N	0	\N	-1	463c2ddb-cbf5-4d22-b65a-88c79d578ac7
1087	4	en	\N	0	\N	-1	463c2ddb-cbf5-4d22-b65a-88c79d578ac7
2387	75	teste.pdf.txt	\N	0	\N	-1	0ee257a7-150e-4396-9c23-4d155ead67d5
2388	65	Written by FormatFilter org.dspace.app.mediafilter.PDFFilter on 2019-05-26T14:50:55Z (GMT).	\N	0	\N	-1	0ee257a7-150e-4396-9c23-4d155ead67d5
1099	2	Murasaki	\N	0	\N	-1	a4d10708-6a03-4a32-9b2f-245adb6b6240
1100	3		\N	0	\N	-1	a4d10708-6a03-4a32-9b2f-245adb6b6240
1101	4	en	\N	0	\N	-1	a4d10708-6a03-4a32-9b2f-245adb6b6240
2389	34	Extracted text	\N	0	\N	-1	0ee257a7-150e-4396-9c23-4d155ead67d5
2390	75	THUMBNAIL	\N	1	\N	-1	2715b220-a689-4384-89a8-78efb69abf3b
2391	75	teste.pdf.jpg	\N	0	\N	-1	069756ac-ffb4-41f5-b33c-d90e382e79b4
2392	65	Written by FormatFilter org.dspace.app.mediafilter.PDFBoxThumbnail on 2019-05-26T14:50:56Z (GMT).	\N	0	\N	-1	069756ac-ffb4-41f5-b33c-d90e382e79b4
2393	34	Generated Thumbnail	\N	0	\N	-1	069756ac-ffb4-41f5-b33c-d90e382e79b4
2394	75	TEXT	\N	1	\N	-1	d5ab3c0f-e4fb-4d5d-80bb-f66751da4850
2395	75	1413-8123-csc-21-08-2326.pdf.txt	\N	0	\N	-1	f3688f7e-ed1a-43e0-ad17-6f3638d64723
2397	34	Extracted text	\N	0	\N	-1	f3688f7e-ed1a-43e0-ad17-6f3638d64723
2461	75	Programa Nacional de Apoio ao Controle da Qualidade da Água para o Consumo Humano	en_US	0	\N	-1	33a11e84-68c9-4e4c-8aba-53990a33f7ca
2462	10	Fundação Nacional de Saúde	en_US	0	\N	-1	33a11e84-68c9-4e4c-8aba-53990a33f7ca
2463	35	Relata um pequeno resumo do Programa Nacional de Apoio ao Controle da Qualidade da Água para o Consumo Humano (PNCQA). Aborda uma rápida apresentação, com os objetivos e atribuições do programa.	en_US	0	\N	-1	33a11e84-68c9-4e4c-8aba-53990a33f7ca
2464	22	2012	\N	0	\N	-1	33a11e84-68c9-4e4c-8aba-53990a33f7ca
1112	1	Marcos	\N	0	\N	-1	765a25ac-1a70-4bae-96b7-e593fe0caa6e
1113	2	Mori	\N	0	\N	-1	765a25ac-1a70-4bae-96b7-e593fe0caa6e
1143	75	ORIGINAL	\N	1	\N	-1	93182026-e06b-4654-950f-39cc4aa0180f
1150	75	LICENSE	\N	1	\N	-1	1f55e71a-6121-4374-baf3-3f6e8881131a
1144	75	teste.pdf	\N	0	\N	-1	a5bae5f3-528a-48f5-9a62-1d9f45445a95
1145	65	teste.pdf	\N	0	\N	-1	a5bae5f3-528a-48f5-9a62-1d9f45445a95
1147	34	Disponível em http://www.youtube.com/watch?v=uyYyPIw_zXc	\N	0	\N	-1	a5bae5f3-528a-48f5-9a62-1d9f45445a95
1151	75	license.txt	\N	0	\N	-1	a15549c9-dd49-4ae1-a01b-5506f097c6ca
1152	65	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	a15549c9-dd49-4ae1-a01b-5506f097c6ca
2315	175	123456789/371		0	\N	-1	24fb983c-62fc-41d7-9a45-45bf55a5359c
2644	35	nteger ipsum diam, placerat ut elit eget, aliquam feugiat tellus. Suspendisse dui justo, mattis sed neque et, aliquam ullamcorper augue. Nullam tincidunt erat ac orci convallis viverra. Pellentesque elit ante, cursus sed mauris sed, luctus hendrerit orci. Cras urna erat, malesuada eu magna aliquet, vulputate sagittis ipsum	en_US	0	\N	-1	416198eb-e102-4842-9bcc-a60fdcb450d7
2645	41	Praesent gravida, leo nec volutpat rutrum, arcu nisi venenatis tellus, et hendrerit risus mi ut nulla. Duis non dui quis leo suscipit venenatis sed in enim. Aliquam vestibulum neque dolor, a pharetra urna viverra eu. Nam cursus, enim ac porta efficitur, est augue vestibulum dolor, quis consequat nibh urna vel felis	en_US	0	\N	-1	416198eb-e102-4842-9bcc-a60fdcb450d7
1680	35	Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla nibh nisi, luctus ac lacus quis, molestie sollicitudin massa. Nulla lacinia, nisi non sagittis rutrum, est justo maximus diam, efficitur molestie tortor risus a leo. Pellentesque varius egestas ante sit amet molestie. Sed ultricies ante id mauris semper ullamcorper. Ut efficitur lectus a velit aliquam semper. Nulla congue venenatis elementum. Vestibulum ac massa non diam tristique sodales eget sed velit. In in rhoncus sem, sed faucibus metus. Quisque vel nisi nisl. Nunc facilisis libero in massa lacinia viverra. Vivamus volutpat maximus enim, vitae sollicitudin urna dictum at.	en_US	0	\N	-1	09d7f4dc-8fce-43c0-b778-0df584c2739f
1681	41	Mauris fringilla arcu id dui tristique, id convallis nunc lacinia. Etiam vehicula ultricies sapien ac bibendum. Donec varius vitae turpis non gravida. Fusce ultrices risus enim, ut ornare magna blandit at. Curabitur id volutpat dui. Nulla facilisi. Fusce convallis magna vel velit efficitur luctus. Vestibulum et ante id neque suscipit condimentum	en_US	0	\N	-1	09d7f4dc-8fce-43c0-b778-0df584c2739f
1682	36	Submitted by Fábio Luís de Brito (britofa@paho.org) on 2019-05-08T11:18:12Z\r\nNo. of bitstreams: 0	en	0	\N	-1	09d7f4dc-8fce-43c0-b778-0df584c2739f
1683	36	Made available in DSpace on 2019-05-08T11:18:12Z (GMT). No. of bitstreams: 0\r\n  Previous issue date: 2019-05-08	en	1	\N	-1	09d7f4dc-8fce-43c0-b778-0df584c2739f
1684	45	video/mpeg	en_US	0	\N	-1	09d7f4dc-8fce-43c0-b778-0df584c2739f
1685	32	123456789		0	\N	-1	09d7f4dc-8fce-43c0-b778-0df584c2739f
1686	33	http://rcfunasa.bvsalud.org//handle/123456789/360		0	\N	-1	09d7f4dc-8fce-43c0-b778-0df584c2739f
1687	52	x-12345;		0	\N	-1	09d7f4dc-8fce-43c0-b778-0df584c2739f
1688	62	CC0 1.0 Universal	*	0	\N	-1	09d7f4dc-8fce-43c0-b778-0df584c2739f
1689	63	http://creativecommons.org/publicdomain/zero/1.0/	*	0	\N	-1	09d7f4dc-8fce-43c0-b778-0df584c2739f
1690	68	Cabeça	en_US	0	\N	-1	09d7f4dc-8fce-43c0-b778-0df584c2739f
1691	68	Macaca mulatta	en_US	1	\N	-1	09d7f4dc-8fce-43c0-b778-0df584c2739f
1692	75	Como construir uma unidade de SALTA-z	en_US	0	\N	-1	09d7f4dc-8fce-43c0-b778-0df584c2739f
1693	76	TESTE-1 Multimídia - Título em outro idioma	en_US	0	\N	-1	09d7f4dc-8fce-43c0-b778-0df584c2739f
1694	78	Vídeo	en_US	0	\N	-1	09d7f4dc-8fce-43c0-b778-0df584c2739f
1883	19	2019-05-10T13:14:32Z	\N	0	\N	-1	d450501d-bb9e-4ec6-9691-e27f33bba466
1436	152	Brasil	en_US	0	\N	-1	b1c7cc22-a459-4f55-99cc-98fc7e9829cd
1437	78	Acordo Interministerial	en_US	0	\N	-1	b1c7cc22-a459-4f55-99cc-98fc7e9829cd
1438	32	x-1234	en_US	0	\N	-1	b1c7cc22-a459-4f55-99cc-98fc7e9829cd
1439	75	TESTE-1 Legislação	en_US	0	\N	-1	b1c7cc22-a459-4f55-99cc-98fc7e9829cd
1440	76	teste - Denominação do Ato	en_US	0	\N	-1	b1c7cc22-a459-4f55-99cc-98fc7e9829cd
1441	76	teste2 - Denominação do Ato	en_US	1	\N	-1	b1c7cc22-a459-4f55-99cc-98fc7e9829cd
1442	151	Nacional	en_US	0	\N	-1	b1c7cc22-a459-4f55-99cc-98fc7e9829cd
1443	153	São Paulo	en_US	0	\N	-1	b1c7cc22-a459-4f55-99cc-98fc7e9829cd
1444	154	São Paulo	en_US	0	\N	-1	b1c7cc22-a459-4f55-99cc-98fc7e9829cd
1445	65	Diário Oficial do Estado de São Paulo	en_US	0	\N	-1	b1c7cc22-a459-4f55-99cc-98fc7e9829cd
1446	147	seção 1234 - teste	en_US	0	\N	-1	b1c7cc22-a459-4f55-99cc-98fc7e9829cd
1447	146	XXI	en_US	0	\N	-1	b1c7cc22-a459-4f55-99cc-98fc7e9829cd
1448	148	ABC-123	en_US	0	\N	-1	b1c7cc22-a459-4f55-99cc-98fc7e9829cd
1449	149	inicial 1 final 10	en_US	0	\N	-1	b1c7cc22-a459-4f55-99cc-98fc7e9829cd
1450	145	2019-05-07	\N	0	\N	-1	b1c7cc22-a459-4f55-99cc-98fc7e9829cd
1884	22	2019-05-10	\N	0	\N	-1	d450501d-bb9e-4ec6-9691-e27f33bba466
2647	32	x-321654	en_US	0	\N	-1	416198eb-e102-4842-9bcc-a60fdcb450d7
2648	47	pt	en_US	0	\N	-1	416198eb-e102-4842-9bcc-a60fdcb450d7
2401	34	Generated Thumbnail	\N	0	\N	-1	29eef076-48c8-40af-b18c-7bcac3baa316
2402	75	TEXT	\N	1	\N	-1	de0009cf-13b5-4649-86fe-90fc9eec3b30
2403	75	teste_upload.txt.txt	\N	0	\N	-1	8c007dd9-ff34-4051-a72a-3e9cce0c5c8f
2404	65	Written by FormatFilter org.dspace.app.mediafilter.HTMLFilter on 2019-05-26T14:50:57Z (GMT).	\N	0	\N	-1	8c007dd9-ff34-4051-a72a-3e9cce0c5c8f
2405	34	Extracted text	\N	0	\N	-1	8c007dd9-ff34-4051-a72a-3e9cce0c5c8f
2406	75	TEXT	\N	1	\N	-1	b9bc2a0e-639a-4587-9f6d-42fec43ffd82
2396	65	Written by FormatFilter org.dspace.app.mediafilter.PDFFilter on 2019-05-26T14:50:56Z (GMT).	\N	0	\N	-1	f3688f7e-ed1a-43e0-ad17-6f3638d64723
2398	75	THUMBNAIL	\N	1	\N	-1	0b1f1831-2e41-4c59-af71-5f537a9a1a22
2399	75	1413-8123-csc-21-08-2326.pdf.jpg	\N	0	\N	-1	29eef076-48c8-40af-b18c-7bcac3baa316
2400	65	Written by FormatFilter org.dspace.app.mediafilter.PDFBoxThumbnail on 2019-05-26T14:50:57Z (GMT).	\N	0	\N	-1	29eef076-48c8-40af-b18c-7bcac3baa316
2407	75	Portaria Programa Sustentar.pdf.txt	\N	0	\N	-1	1d3c4bdf-7b01-4175-9d09-1698499c29c5
2408	65	Written by FormatFilter org.dspace.app.mediafilter.PDFFilter on 2019-05-26T14:50:58Z (GMT).	\N	0	\N	-1	1d3c4bdf-7b01-4175-9d09-1698499c29c5
2409	34	Extracted text	\N	0	\N	-1	1d3c4bdf-7b01-4175-9d09-1698499c29c5
2410	75	THUMBNAIL	\N	1	\N	-1	0a7a2874-2f9d-477f-9044-465aae71afcd
2411	75	Portaria Programa Sustentar.pdf.jpg	\N	0	\N	-1	9dd6b47b-f9b5-47e0-8ad0-0012c5c9ef2f
2412	65	Written by FormatFilter org.dspace.app.mediafilter.PDFBoxThumbnail on 2019-05-26T14:50:59Z (GMT).	\N	0	\N	-1	9dd6b47b-f9b5-47e0-8ad0-0012c5c9ef2f
1452	10	teste - Órgão emissor	en_US	0	\N	-1	b1c7cc22-a459-4f55-99cc-98fc7e9829cd
1453	47	pt	en_US	0	\N	-1	b1c7cc22-a459-4f55-99cc-98fc7e9829cd
1454	150	2019-05-07	\N	0	\N	-1	b1c7cc22-a459-4f55-99cc-98fc7e9829cd
1455	35	Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras placerat.	en_US	0	\N	-1	b1c7cc22-a459-4f55-99cc-98fc7e9829cd
1456	41	Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras placerat.	en_US	0	\N	-1	b1c7cc22-a459-4f55-99cc-98fc7e9829cd
2180	35	Sed scelerisque finibus elementum. Sed purus dolor, porttitor eu dictum vel, dictum eget nulla. Nullam eget lacus justo. Phasellus a pellentesque urna. Donec ac lacus rutrum, pulvinar sem a, fringilla lectus. Mauris ut ipsum nec mi bibendum faucibus eget id arcu. Interdum et malesuada fames ac ante ipsum primis in faucibus. Vivamus faucibus, nibh non auctor imperdiet, nulla metus sodales eros, ut accumsan arcu orci a massa. Nunc nunc nunc, aliquam vitae accumsan nec, efficitur a nisi. In commodo turpis vel cursus congue. Donec dapibus turpis sed hendrerit semper.	en_US	0	\N	-1	ed4b6780-5f7d-429f-beab-eb44e6170bc9
2181	41	Maecenas vel felis erat. Aenean metus eros, faucibus a ex et, tincidunt ultrices elit. Vivamus ac fringilla elit, in convallis eros. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Maecenas non ullamcorper massa. Donec nisl nunc, semper a purus nec	en_US	0	\N	-1	ed4b6780-5f7d-429f-beab-eb44e6170bc9
2649	152	Brasil	en_US	0	\N	-1	416198eb-e102-4842-9bcc-a60fdcb450d7
2183	32	x-12345678910	en_US	0	\N	-1	ed4b6780-5f7d-429f-beab-eb44e6170bc9
2184	47	pt	en_US	0	\N	-1	ed4b6780-5f7d-429f-beab-eb44e6170bc9
2185	47	en	en_US	1	\N	-1	ed4b6780-5f7d-429f-beab-eb44e6170bc9
2186	152	Brasil	en_US	0	\N	-1	ed4b6780-5f7d-429f-beab-eb44e6170bc9
2187	153	SP	en_US	0	\N	-1	ed4b6780-5f7d-429f-beab-eb44e6170bc9
2188	154	São Paulo	en_US	0	\N	-1	ed4b6780-5f7d-429f-beab-eb44e6170bc9
2189	48	BLA BLA	en_US	0	\N	-1	ed4b6780-5f7d-429f-beab-eb44e6170bc9
2190	51	Projeto XXI	en_US	0	\N	-1	ed4b6780-5f7d-429f-beab-eb44e6170bc9
2316	177	123456789/371		0	\N	-1	24fb983c-62fc-41d7-9a45-45bf55a5359c
2413	34	Generated Thumbnail	\N	0	\N	-1	9dd6b47b-f9b5-47e0-8ad0-0012c5c9ef2f
2414	75	THUMBNAIL	\N	1	\N	-1	1c7b63c0-8006-4d71-a70b-1a59ce3ba62f
2415	75	saltaz.jpg.jpg	\N	0	\N	-1	2962c64d-2d70-40c7-99d0-c09489937317
2416	65	Written by FormatFilter org.dspace.app.mediafilter.ImageMagickImageThumbnailFilter on 2019-05-26T14:50:59Z (GMT).	\N	0	\N	-1	2962c64d-2d70-40c7-99d0-c09489937317
2417	34	IM Thumbnail	\N	0	\N	-1	2962c64d-2d70-40c7-99d0-c09489937317
2436	1	Isabella	\N	0	\N	-1	51f5e325-d8b5-41f3-b208-8271808ecf72
2437	2	Carvalho	\N	0	\N	-1	51f5e325-d8b5-41f3-b208-8271808ecf72
2438	3		\N	0	\N	-1	51f5e325-d8b5-41f3-b208-8271808ecf72
2439	4	pt	\N	0	\N	-1	51f5e325-d8b5-41f3-b208-8271808ecf72
2465	47	pt	en_US	0	\N	-1	33a11e84-68c9-4e4c-8aba-53990a33f7ca
2466	152	Brasil	en_US	0	\N	-1	33a11e84-68c9-4e4c-8aba-53990a33f7ca
2467	154	Brasília	en_US	0	\N	-1	33a11e84-68c9-4e4c-8aba-53990a33f7ca
2468	48	Funasa	en_US	0	\N	-1	33a11e84-68c9-4e4c-8aba-53990a33f7ca
2469	51	http://www.funasa.gov.br/web/guest/biblioteca-eletronica/publicacoes/saude-ambiental/-/asset_publisher/G0cYh3ZvWCm9/content/programa-nacional-de-apoio-ao-controle-da-qualidade-da-agua-para-consumo-humano?inheritRedirect=false&redirect=http%3A%2F%2Fwww.funasa.gov.br%2Fweb%2Fguest%2Fbiblioteca-eletronica%2Fpublicacoes%2Fsaude-ambiental%3Fp_p_id%3D101_INSTANCE_G0cYh3ZvWCm9%26p_p_lifecycle%3D0%26p_p_state%3Dnormal%26p_p_mode%3Dview%26p_p_col_id%3Dcolumn-1%26p_p_col_count%3D1%26_101_INSTANCE_G0cYh3ZvWCm9_advancedSearch%3Dfalse%26_101_INSTANCE_G0cYh3ZvWCm9_keywords%3D%26_101_INSTANCE_G0cYh3ZvWCm9_delta%3D10%26p_r_p_564233524_resetCur%3Dfalse%26_101_INSTANCE_G0cYh3ZvWCm9_cur%3D2%26_101_INSTANCE_G0cYh3ZvWCm9_andOperator%3Dtrue	en_US	0	\N	-1	33a11e84-68c9-4e4c-8aba-53990a33f7ca
2470	68	qualidade da água	en_US	0	\N	-1	33a11e84-68c9-4e4c-8aba-53990a33f7ca
2471	78	Resumo de Política	en_US	0	\N	-1	33a11e84-68c9-4e4c-8aba-53990a33f7ca
2650	153	SP	en_US	0	\N	-1	416198eb-e102-4842-9bcc-a60fdcb450d7
2651	154	São Paulo	en_US	0	\N	-1	416198eb-e102-4842-9bcc-a60fdcb450d7
2652	48	BLA BLA	en_US	0	\N	-1	416198eb-e102-4842-9bcc-a60fdcb450d7
2653	51	Projeto XXI - TESTE	en_US	0	\N	-1	416198eb-e102-4842-9bcc-a60fdcb450d7
2654	52	SERIE2;10-20	\N	0	\N	-1	416198eb-e102-4842-9bcc-a60fdcb450d7
2530	75	TEXT	\N	1	\N	-1	a761698f-3924-4e7d-9219-37f93670fdf0
2529	36	Made available in DSpace on 2019-06-10T14:46:49Z (GMT). No. of bitstreams: 1\nsan_ambiental.pdf: 6347638 bytes, checksum: 691a771e7db0948af6a196954a367b22 (MD5)\n  Previous issue date: 2014	en	1	\N	-1	3bc2d4e3-6c4f-4e12-98c7-89b38012246f
2526	18	2019-06-10T14:46:49Z	\N	0	\N	-1	3bc2d4e3-6c4f-4e12-98c7-89b38012246f
2501	75	Saneamento ambiental, sustentabilidade e permacultura em assentamentos rurais : algumas práticas e vivências	en_US	0	\N	-1	3bc2d4e3-6c4f-4e12-98c7-89b38012246f
2502	9	Fundação Nacional de Saúde	en_US	0	\N	-1	3bc2d4e3-6c4f-4e12-98c7-89b38012246f
2503	10	Fundação Nacional de Saúde	en_US	0	\N	-1	3bc2d4e3-6c4f-4e12-98c7-89b38012246f
2504	35	A presente publicação é o resultado de um esforço conjunto, realizado por pesquisadores, estudantes e moradores de um assentamento rural, visando a produção coletiva e participativa de habitação e de estruturas de saneamento ambiental. Este esforço visou, por um lado, a melhoria da qualidade de vida da própria comunidade assentada e, por outro, a geração de conhecimento acessível à população em geral, com ênfase em segmentos cujos direitos têm sido historicamente negados. Simultaneamente, destina-se à formação de pessoas, tanto estudantes de graduação e pós-graduação, quanto profissionais já atuantes na área.	en_US	0	\N	-1	3bc2d4e3-6c4f-4e12-98c7-89b38012246f
2506	47	pt	en_US	0	\N	-1	3bc2d4e3-6c4f-4e12-98c7-89b38012246f
2507	152	Brasil	en_US	0	\N	-1	3bc2d4e3-6c4f-4e12-98c7-89b38012246f
2508	153	Distrito Federal	en_US	0	\N	-1	3bc2d4e3-6c4f-4e12-98c7-89b38012246f
2509	154	Brasília	en_US	0	\N	-1	3bc2d4e3-6c4f-4e12-98c7-89b38012246f
2510	48	Funasa	en_US	0	\N	-1	3bc2d4e3-6c4f-4e12-98c7-89b38012246f
2511	51	https://funasa-my.sharepoint.com/personal/imprensa_funasa_gov_br/Documents/Biblioteca_Eletronica/Estudos_e_Pesquisas/san_ambiental.pdf	en_US	0	\N	-1	3bc2d4e3-6c4f-4e12-98c7-89b38012246f
2512	64	Fundação Nacional de Saúde	en_US	0	\N	-1	3bc2d4e3-6c4f-4e12-98c7-89b38012246f
2513	68	Saneamento	en_US	0	\N	-1	3bc2d4e3-6c4f-4e12-98c7-89b38012246f
2527	19	2019-06-10T14:46:49Z	\N	0	\N	-1	3bc2d4e3-6c4f-4e12-98c7-89b38012246f
2528	22	2014	\N	0	\N	-1	3bc2d4e3-6c4f-4e12-98c7-89b38012246f
2531	75	san_ambiental.pdf.txt	\N	0	\N	-1	b0828ac7-d229-4f84-ae1b-77d8a212c0ff
2532	65	Written by FormatFilter org.dspace.app.mediafilter.PDFFilter on 2019-06-11T03:00:42Z (GMT).	\N	0	\N	-1	b0828ac7-d229-4f84-ae1b-77d8a212c0ff
2533	34	Extracted text	\N	0	\N	-1	b0828ac7-d229-4f84-ae1b-77d8a212c0ff
2534	75	THUMBNAIL	\N	1	\N	-1	22be2e2a-2cf2-4956-a75f-bb4ff2c756b9
2535	75	san_ambiental.pdf.jpg	\N	0	\N	-1	d129fd45-13f2-414f-a2a3-cb8c153c2c08
2536	65	Written by FormatFilter org.dspace.app.mediafilter.PDFBoxThumbnail on 2019-06-11T03:00:43Z (GMT).	\N	0	\N	-1	d129fd45-13f2-414f-a2a3-cb8c153c2c08
2537	34	Generated Thumbnail	\N	0	\N	-1	d129fd45-13f2-414f-a2a3-cb8c153c2c08
2656	68	Cabeça do Úmero	en_US	0	\N	-1	416198eb-e102-4842-9bcc-a60fdcb450d7
2657	68	Dengue Grave	en_US	1	\N	-1	416198eb-e102-4842-9bcc-a60fdcb450d7
2658	78	Folder	en_US	0	\N	-1	416198eb-e102-4842-9bcc-a60fdcb450d7
2659	78	Fotografia	en_US	1	\N	-1	416198eb-e102-4842-9bcc-a60fdcb450d7
2660	63	http://creativecommons.org/publicdomain/zero/1.0/	*	0	\N	-1	416198eb-e102-4842-9bcc-a60fdcb450d7
2661	62	CC0 1.0 Universal	*	0	\N	-1	416198eb-e102-4842-9bcc-a60fdcb450d7
2662	75	LICENSE	\N	1	\N	-1	ab12cb79-aac2-414b-9946-6a754548e110
2663	75	license.txt	\N	0	\N	-1	90378b0b-c426-4551-a9f9-800896dbf44e
2664	65	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	90378b0b-c426-4551-a9f9-800896dbf44e
2665	36	Submitted by Fábio Luís de Brito (britofa@paho.org) on 2019-06-12T11:47:02Z\nNo. of bitstreams: 0	en	0	\N	-1	416198eb-e102-4842-9bcc-a60fdcb450d7
2666	33	http://rcfunasa.bvsalud.org//handle/123456789/378	\N	0	\N	-1	416198eb-e102-4842-9bcc-a60fdcb450d7
2670	36	Made available in DSpace on 2019-06-12T11:47:02Z (GMT). No. of bitstreams: 0\n  Previous issue date: 2019-06-12	en	1	\N	-1	416198eb-e102-4842-9bcc-a60fdcb450d7
2667	18	2019-06-12T11:47:02Z	\N	0	\N	-1	416198eb-e102-4842-9bcc-a60fdcb450d7
2668	19	2019-06-12T11:47:02Z	\N	0	\N	-1	416198eb-e102-4842-9bcc-a60fdcb450d7
2669	22	2019-06-12	\N	0	\N	-1	416198eb-e102-4842-9bcc-a60fdcb450d7
2696	75	Uno dos tres	en_US	0	\N	-1	98667b07-a1fd-4b74-ba08-933c0d63c1d0
2697	9	Marmonti, Gastón	en_US	0	\N	-1	98667b07-a1fd-4b74-ba08-933c0d63c1d0
2698	22	2019	\N	0	\N	-1	98667b07-a1fd-4b74-ba08-933c0d63c1d0
2699	47	en	en_US	0	\N	-1	98667b07-a1fd-4b74-ba08-933c0d63c1d0
2700	152	Argentina	en_US	0	\N	-1	98667b07-a1fd-4b74-ba08-933c0d63c1d0
2701	68	Policies and Cooperation in Science, Technology and Innovation	en_US	0	\N	-1	98667b07-a1fd-4b74-ba08-933c0d63c1d0
2702	78	Artigo de jornal	en_US	0	\N	-1	98667b07-a1fd-4b74-ba08-933c0d63c1d0
2703	75	ORIGINAL	\N	1	\N	-1	bf28708a-d254-4e0b-9189-a5704d83d883
2929	75	license.txt	\N	0	\N	-1	5bcae71d-2a79-4652-a04c-c9bf08923201
2930	65	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	5bcae71d-2a79-4652-a04c-c9bf08923201
2931	36	Submitted by Fábio Luís de Brito (britofa@paho.org) on 2019-09-23T16:37:43Z\nNo. of bitstreams: 0	en	0	\N	-1	87bf956f-41be-46d9-a741-f304c8165e94
2932	33	http://rcfunasa.bvsalud.org//handle/123456789/382	\N	0	\N	-1	87bf956f-41be-46d9-a741-f304c8165e94
2704	75	48921.pdf	\N	0	\N	-1	1c879e87-ef55-4420-9fff-a0d9ef52a1c2
2705	65	48921.pdf	\N	0	\N	-1	1c879e87-ef55-4420-9fff-a0d9ef52a1c2
2706	34		\N	0	\N	-1	1c879e87-ef55-4420-9fff-a0d9ef52a1c2
2914	75	TESTE-5 Produção Científica	en_US	0	\N	-1	87bf956f-41be-46d9-a741-f304c8165e94
2915	76	teste 5 - titulo alternativo Produção Científica	en_US	0	\N	-1	87bf956f-41be-46d9-a741-f304c8165e94
2916	9	Paulo José	en_US	0	\N	-1	87bf956f-41be-46d9-a741-f304c8165e94
2917	35	Duis eu felis nec quam placerat varius eget eget mi. Nullam tristique consectetur justo quis porta. Vestibulum finibus dolor metus, et maximus ligula tincidunt quis. Donec nec nibh vulputate, hendrerit ipsum non, faucibus sem. Aenean vitae tempus orci. Integer mauris ipsum, facilisis nec tortor sit amet, tincidunt venenatis tortor. Phasellus faucibus lectus quis nunc bibendum accumsan eu vitae velit. Pellentesque condimentum consequat ante fringilla aliquam.	en_US	0	\N	-1	87bf956f-41be-46d9-a741-f304c8165e94
2919	47	pt	en_US	0	\N	-1	87bf956f-41be-46d9-a741-f304c8165e94
2920	152	Brasil	en_US	0	\N	-1	87bf956f-41be-46d9-a741-f304c8165e94
2921	153	São Paulo	en_US	0	\N	-1	87bf956f-41be-46d9-a741-f304c8165e94
2922	154	São Paulo	en_US	0	\N	-1	87bf956f-41be-46d9-a741-f304c8165e94
2923	68	Saneamento de Hotéis	en_US	0	\N	-1	87bf956f-41be-46d9-a741-f304c8165e94
2924	182	Consórcios Intermunicipais de Saneamento Básico	en_US	0	\N	-1	87bf956f-41be-46d9-a741-f304c8165e94
2925	78	Apresentação	en_US	0	\N	-1	87bf956f-41be-46d9-a741-f304c8165e94
2926	63	http://creativecommons.org/publicdomain/zero/1.0/	*	0	\N	-1	87bf956f-41be-46d9-a741-f304c8165e94
2927	62	CC0 1.0 Universal	*	0	\N	-1	87bf956f-41be-46d9-a741-f304c8165e94
2928	75	LICENSE	\N	1	\N	-1	7e111fd6-e95d-46fa-8e6a-fc112f2c3468
2936	36	Made available in DSpace on 2019-09-23T16:37:43Z (GMT). No. of bitstreams: 0\n  Previous issue date: 2019-09-23	en	1	\N	-1	87bf956f-41be-46d9-a741-f304c8165e94
2933	18	2019-09-23T16:37:43Z	\N	0	\N	-1	87bf956f-41be-46d9-a741-f304c8165e94
2934	19	2019-09-23T16:37:43Z	\N	0	\N	-1	87bf956f-41be-46d9-a741-f304c8165e94
2935	22	2019-09-23	\N	0	\N	-1	87bf956f-41be-46d9-a741-f304c8165e94
2937	78	Recurso Educativo		0	\N	-1	d2f5671b-6c52-4952-ba85-c3a87bf72a97
3038	152	Brasil	en_US	0	\N	-1	380e731b-2df3-4f9e-84d0-16ffb0010e66
3039	78	Acordo Ministerial	en_US	0	\N	-1	380e731b-2df3-4f9e-84d0-16ffb0010e66
3040	10	FUNASA TESTE	en_US	0	\N	-1	380e731b-2df3-4f9e-84d0-16ffb0010e66
3041	32	x-123456789107869	en_US	0	\N	-1	380e731b-2df3-4f9e-84d0-16ffb0010e66
3042	75	TESTE 3 - Legislação	en_US	0	\N	-1	380e731b-2df3-4f9e-84d0-16ffb0010e66
3043	65	Diário Oficial da União	en_US	0	\N	-1	380e731b-2df3-4f9e-84d0-16ffb0010e66
2749	152	Brasil	en_US	0	\N	-1	f332b151-98c1-4e28-b87e-bed0d9bf17e8
2750	78	Decreto	en_US	0	\N	-1	f332b151-98c1-4e28-b87e-bed0d9bf17e8
2751	10	Governo do Brasil	en_US	0	\N	-1	f332b151-98c1-4e28-b87e-bed0d9bf17e8
2752	32	x-123456	en_US	0	\N	-1	f332b151-98c1-4e28-b87e-bed0d9bf17e8
2753	75	TESTE-5 Legislação	en_US	0	\N	-1	f332b151-98c1-4e28-b87e-bed0d9bf17e8
2754	76	teste 5 - Denominação do Ato	en_US	0	\N	-1	f332b151-98c1-4e28-b87e-bed0d9bf17e8
2755	151	Nacional	en_US	0	\N	-1	f332b151-98c1-4e28-b87e-bed0d9bf17e8
2756	153	São Paulo	en_US	0	\N	-1	f332b151-98c1-4e28-b87e-bed0d9bf17e8
2757	154	São Paulo	en_US	0	\N	-1	f332b151-98c1-4e28-b87e-bed0d9bf17e8
2758	65	Diário Oficial da União	en_US	0	\N	-1	f332b151-98c1-4e28-b87e-bed0d9bf17e8
2759	147	0122	en_US	0	\N	-1	f332b151-98c1-4e28-b87e-bed0d9bf17e8
2760	146	212	en_US	0	\N	-1	f332b151-98c1-4e28-b87e-bed0d9bf17e8
2761	148	ABC-123456	en_US	0	\N	-1	f332b151-98c1-4e28-b87e-bed0d9bf17e8
2762	149	12, 16	en_US	0	\N	-1	f332b151-98c1-4e28-b87e-bed0d9bf17e8
2763	145	2019-09-23	\N	0	\N	-1	f332b151-98c1-4e28-b87e-bed0d9bf17e8
2765	47	pt	en_US	0	\N	-1	f332b151-98c1-4e28-b87e-bed0d9bf17e8
2766	150	2019-09-23	\N	0	\N	-1	f332b151-98c1-4e28-b87e-bed0d9bf17e8
2767	68	Água Corporal	en_US	0	\N	-1	f332b151-98c1-4e28-b87e-bed0d9bf17e8
2768	182	Jusante	en_US	0	\N	-1	f332b151-98c1-4e28-b87e-bed0d9bf17e8
2770	62	CC0 1.0 Universal	*	0	\N	-1	f332b151-98c1-4e28-b87e-bed0d9bf17e8
2771	75	LICENSE	\N	1	\N	-1	d755ed7e-018c-4209-ae5c-a485a3172ccb
2772	75	license.txt	\N	0	\N	-1	20138169-8e01-4926-aeae-04135b3706eb
2773	65	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	20138169-8e01-4926-aeae-04135b3706eb
2774	36	Submitted by Fábio Luís de Brito (britofa@paho.org) on 2019-09-23T16:29:31Z\nNo. of bitstreams: 0	en	0	\N	-1	f332b151-98c1-4e28-b87e-bed0d9bf17e8
2775	33	http://rcfunasa.bvsalud.org//handle/123456789/379	\N	0	\N	-1	f332b151-98c1-4e28-b87e-bed0d9bf17e8
2779	36	Made available in DSpace on 2019-09-23T16:29:33Z (GMT). No. of bitstreams: 0\n  Previous issue date: 2019-09-23	en	1	\N	-1	f332b151-98c1-4e28-b87e-bed0d9bf17e8
2776	18	2019-09-23T16:29:33Z	\N	0	\N	-1	f332b151-98c1-4e28-b87e-bed0d9bf17e8
2777	19	2019-09-23T16:29:33Z	\N	0	\N	-1	f332b151-98c1-4e28-b87e-bed0d9bf17e8
2778	22	2019-09-23	\N	0	\N	-1	f332b151-98c1-4e28-b87e-bed0d9bf17e8
2981	75	TESTE-5 Produções Educacionais	en_US	0	\N	-1	d2f5671b-6c52-4952-ba85-c3a87bf72a97
2982	35	Vivamus et posuere risus, ut euismod massa. Ut consequat pretium ullamcorper. Proin vitae neque luctus, porta nisi ut, bibendum lacus. Praesent a diam rutrum, pulvinar purus ac, ornare magna. Nam eu diam volutpat est semper aliquam at vitae ante. Suspendisse pellentesque, orci ut feugiat pretium, ex ligula semper ante, non imperdiet massa turpis in massa. Donec vestibulum et diam id tempor. Vestibulum velit risus, malesuada eu diam nec, condimentum faucibus mauris. Duis interdum, ipsum et semper aliquam, enim orci scelerisque felis, vitae rutrum lacus libero in tortor.	en_US	0	\N	-1	d2f5671b-6c52-4952-ba85-c3a87bf72a97
2983	34	Vivamus et posuere risus, ut euismod massa. Ut consequat pretium ullamcorper. Proin vitae neque luctus, porta nisi ut, bibendum lacus. Praesent a diam rutrum, pulvinar purus ac, ornare magna. Nam eu diam volutpat est semper aliquam at vitae ante. Suspendisse pellentesque, orci ut feugiat pretium, ex ligula semper ante, non imperdiet massa turpis in massa. Donec vestibulum et diam id tempor. Vestibulum velit risus, malesuada eu diam nec, condimentum faucibus mauris. Duis interdum, ipsum et semper aliquam, enim orci scelerisque felis, vitae rutrum lacus libero in tortor.	en_US	0	\N	-1	d2f5671b-6c52-4952-ba85-c3a87bf72a97
2984	7	Marcos Paulo Medeiros	en_US	0	\N	-1	d2f5671b-6c52-4952-ba85-c3a87bf72a97
2985	10	Bireme	en_US	0	\N	-1	d2f5671b-6c52-4952-ba85-c3a87bf72a97
2987	179	Ferramenta de aprendizado	en_US	0	\N	-1	d2f5671b-6c52-4952-ba85-c3a87bf72a97
2988	47	pt	en_US	0	\N	-1	d2f5671b-6c52-4952-ba85-c3a87bf72a97
2989	178	Aula	en_US	0	\N	-1	d2f5671b-6c52-4952-ba85-c3a87bf72a97
2990	45	application/pdf	en_US	0	\N	-1	d2f5671b-6c52-4952-ba85-c3a87bf72a97
2991	45	application/postscript	en_US	1	\N	-1	d2f5671b-6c52-4952-ba85-c3a87bf72a97
2992	45	text/richtext	en_US	2	\N	-1	d2f5671b-6c52-4952-ba85-c3a87bf72a97
2993	171	Experimento	en_US	0	\N	-1	d2f5671b-6c52-4952-ba85-c3a87bf72a97
2994	166	Médio	en_US	0	\N	-1	d2f5671b-6c52-4952-ba85-c3a87bf72a97
2995	181	Formação permanente	en_US	0	\N	-1	d2f5671b-6c52-4952-ba85-c3a87bf72a97
2996	167	Médio	en_US	0	\N	-1	d2f5671b-6c52-4952-ba85-c3a87bf72a97
2997	168	2	en_US	0	\N	-1	d2f5671b-6c52-4952-ba85-c3a87bf72a97
2998	180	Pesquisador	en_US	0	\N	-1	d2f5671b-6c52-4952-ba85-c3a87bf72a97
2999	180	Outros	en_US	1	\N	-1	d2f5671b-6c52-4952-ba85-c3a87bf72a97
3000	62	Atribuição CC BY	en_US	0	\N	-1	d2f5671b-6c52-4952-ba85-c3a87bf72a97
3001	68	Dengue Grave	en_US	0	\N	-1	d2f5671b-6c52-4952-ba85-c3a87bf72a97
3002	182	Comunicação em Saúde	en_US	0	\N	-1	d2f5671b-6c52-4952-ba85-c3a87bf72a97
3003	63	http://creativecommons.org/publicdomain/zero/1.0/	*	0	\N	-1	d2f5671b-6c52-4952-ba85-c3a87bf72a97
3004	62	CC0 1.0 Universal	*	1	\N	-1	d2f5671b-6c52-4952-ba85-c3a87bf72a97
3005	75	LICENSE	\N	1	\N	-1	e3f4ba1b-0b3f-477f-9785-2c45c1cc53e4
3049	75	LICENSE	\N	1	\N	-1	cea631f7-6753-416e-a6f1-83b25760bf3a
3006	75	license.txt	\N	0	\N	-1	ec87a684-65b5-4c2e-9ec0-df33773c4e5b
3007	65	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	ec87a684-65b5-4c2e-9ec0-df33773c4e5b
3008	36	Submitted by Fábio Luís de Brito (britofa@paho.org) on 2019-09-23T16:40:12Z\nNo. of bitstreams: 0	en	0	\N	-1	d2f5671b-6c52-4952-ba85-c3a87bf72a97
3009	33	http://rcfunasa.bvsalud.org//handle/123456789/383	\N	0	\N	-1	d2f5671b-6c52-4952-ba85-c3a87bf72a97
3013	36	Made available in DSpace on 2019-09-23T16:40:12Z (GMT). No. of bitstreams: 0\n  Previous issue date: 2019-09-23	en	1	\N	-1	d2f5671b-6c52-4952-ba85-c3a87bf72a97
3010	18	2019-09-23T16:40:12Z	\N	0	\N	-1	d2f5671b-6c52-4952-ba85-c3a87bf72a97
3011	19	2019-09-23T16:40:12Z	\N	0	\N	-1	d2f5671b-6c52-4952-ba85-c3a87bf72a97
3012	22	2019-09-23	\N	0	\N	-1	d2f5671b-6c52-4952-ba85-c3a87bf72a97
3044	145	2019-10-24	\N	0	\N	-1	380e731b-2df3-4f9e-84d0-16ffb0010e66
3046	47	pt	en_US	0	\N	-1	380e731b-2df3-4f9e-84d0-16ffb0010e66
3047	68	dengue	en_US	0	\N	-1	380e731b-2df3-4f9e-84d0-16ffb0010e66
3048	182	Sumidouros de Água de Chuva	en_US	0	\N	-1	380e731b-2df3-4f9e-84d0-16ffb0010e66
3050	75	license.txt	\N	0	\N	-1	c2fe3a86-8006-4f44-ad3a-9689e269a3c3
3051	65	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	c2fe3a86-8006-4f44-ad3a-9689e269a3c3
3052	36	Submitted by Fábio Luís de Brito (britofa@paho.org) on 2019-10-24T13:44:18Z\nNo. of bitstreams: 0	en	0	\N	-1	380e731b-2df3-4f9e-84d0-16ffb0010e66
3053	33	http://rcfunasa.bvsalud.org//handle/123456789/384	\N	0	\N	-1	380e731b-2df3-4f9e-84d0-16ffb0010e66
3057	36	Made available in DSpace on 2019-10-24T13:44:19Z (GMT). No. of bitstreams: 0\n  Previous issue date: 2019-10-24	en	1	\N	-1	380e731b-2df3-4f9e-84d0-16ffb0010e66
3054	18	2019-10-24T13:44:19Z	\N	0	\N	-1	380e731b-2df3-4f9e-84d0-16ffb0010e66
3055	19	2019-10-24T13:44:19Z	\N	0	\N	-1	380e731b-2df3-4f9e-84d0-16ffb0010e66
2822	75	TESTE-5 Multimídia	en_US	0	\N	-1	e85ea3c1-9d09-4c0e-aaa8-33aca608cbb5
2823	76	TESTE-5 Multimídia - Título em outro idioma	en_US	0	\N	-1	e85ea3c1-9d09-4c0e-aaa8-33aca608cbb5
2824	9	João da Silva	en_US	0	\N	-1	e85ea3c1-9d09-4c0e-aaa8-33aca608cbb5
2825	10	Bireme	en_US	0	\N	-1	e85ea3c1-9d09-4c0e-aaa8-33aca608cbb5
2826	47	pt	en_US	0	\N	-1	e85ea3c1-9d09-4c0e-aaa8-33aca608cbb5
2827	35	Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis vel mi suscipit, auctor purus ut, aliquet nulla. Curabitur a volutpat mi, id commodo turpis. Nam quis gravida mauris. Interdum et malesuada fames ac ante ipsum primis in faucibus. Pellentesque a porttitor massa. Aenean pretium turpis ligula, auctor condimentum felis luctus non.	en_US	0	\N	-1	e85ea3c1-9d09-4c0e-aaa8-33aca608cbb5
2828	152	Brasil	en_US	0	\N	-1	e85ea3c1-9d09-4c0e-aaa8-33aca608cbb5
2829	153	São Paulo	en_US	0	\N	-1	e85ea3c1-9d09-4c0e-aaa8-33aca608cbb5
2830	154	São Paulo	en_US	0	\N	-1	e85ea3c1-9d09-4c0e-aaa8-33aca608cbb5
2831	78	Animação	en_US	0	\N	-1	e85ea3c1-9d09-4c0e-aaa8-33aca608cbb5
2832	78	Software	en_US	1	\N	-1	e85ea3c1-9d09-4c0e-aaa8-33aca608cbb5
2834	68	Água Corporal	en_US	0	\N	-1	e85ea3c1-9d09-4c0e-aaa8-33aca608cbb5
2835	182	Qualidade da Água	en_US	0	\N	-1	e85ea3c1-9d09-4c0e-aaa8-33aca608cbb5
2836	45	text/css	en_US	0	\N	-1	e85ea3c1-9d09-4c0e-aaa8-33aca608cbb5
2837	63	http://creativecommons.org/publicdomain/zero/1.0/	*	0	\N	-1	e85ea3c1-9d09-4c0e-aaa8-33aca608cbb5
2838	62	CC0 1.0 Universal	*	0	\N	-1	e85ea3c1-9d09-4c0e-aaa8-33aca608cbb5
3056	22	2019-10-24	\N	0	\N	-1	380e731b-2df3-4f9e-84d0-16ffb0010e66
3069	10	Fundação Nacional de Saúde (FUNASA)	en_US	0	\N	-1	2c23936e-e138-4502-8ec3-e8c71bb851b1
3070	75	Manual de Saneamento	en_US	0	\N	-1	2c23936e-e138-4502-8ec3-e8c71bb851b1
3071	64	FUNASA	en_US	0	\N	-1	2c23936e-e138-4502-8ec3-e8c71bb851b1
3072	1	Suellen	\N	0	\N	-1	5ee61fad-2de8-4f98-834b-c327dfed413c
3073	2	Viriato Leite da Silva	\N	0	\N	-1	5ee61fad-2de8-4f98-834b-c327dfed413c
3074	3		\N	0	\N	-1	5ee61fad-2de8-4f98-834b-c327dfed413c
3075	4	pt	\N	0	\N	-1	5ee61fad-2de8-4f98-834b-c327dfed413c
3076	75	Manual de Saneamento	en_US	0	\N	-1	0a2460c5-e7b6-4e59-8342-35dd4514da7c
3077	64	FUNASA	en_US	0	\N	-1	0a2460c5-e7b6-4e59-8342-35dd4514da7c
3091	3		\N	0	\N	-1	e1ae23f4-c9da-4c10-b7e2-8a3dc83982d2
3092	4	en	\N	0	\N	-1	e1ae23f4-c9da-4c10-b7e2-8a3dc83982d2
\.


--
-- Name: metadatavalue_seq; Type: SEQUENCE SET; Schema: public; Owner: funasauser
--

SELECT pg_catalog.setval('public.metadatavalue_seq', 3097, true);


--
-- Data for Name: most_recent_checksum; Type: TABLE DATA; Schema: public; Owner: funasauser
--

COPY public.most_recent_checksum (to_be_processed, expected_checksum, current_checksum, last_process_start_date, last_process_end_date, checksum_algorithm, matched_prev_checksum, result, bitstream_id) FROM stdin;
\.


--
-- Data for Name: registrationdata; Type: TABLE DATA; Schema: public; Owner: funasauser
--

COPY public.registrationdata (registrationdata_id, email, token, expires) FROM stdin;
1	emarmonti@gmail.com	7f690ee6fc898df943ad03e7e5cb28ac	\N
2	emarmonti@siu.edu.ar	4d5a271ac514a54e28f50740c5c279d0	\N
3	emarmonti@hotmail.com	131b7f9ebd489ebc58d1279e9e1cbc74	\N
8	isabella@agenciawebnauta.com	0117326ef5fd1550817a7c06e5b12e6a	\N
\.


--
-- Name: registrationdata_seq; Type: SEQUENCE SET; Schema: public; Owner: funasauser
--

SELECT pg_catalog.setval('public.registrationdata_seq', 10, true);


--
-- Data for Name: requestitem; Type: TABLE DATA; Schema: public; Owner: funasauser
--

COPY public.requestitem (requestitem_id, token, allfiles, request_email, request_name, request_date, accept_request, decision_date, expires, request_message, item_id, bitstream_id) FROM stdin;
\.


--
-- Name: requestitem_seq; Type: SEQUENCE SET; Schema: public; Owner: funasauser
--

SELECT pg_catalog.setval('public.requestitem_seq', 1, false);


--
-- Data for Name: resourcepolicy; Type: TABLE DATA; Schema: public; Owner: funasauser
--

COPY public.resourcepolicy (policy_id, resource_type_id, resource_id, action_id, start_date, end_date, rpname, rptype, rpdescription, eperson_id, epersongroup_id, dspace_object) FROM stdin;
2	4	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	ea38e67d-c827-487c-b429-13be16d4a6c5
52	4	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	e13aa597-d0ce-44df-a774-e65c5b8ce61c
3	4	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	0c873029-343e-4740-bd26-c976c9b2c6c2
53	4	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	62cb0c79-b578-470b-9e81-6a712fea7281
4	4	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	1f757c54-5850-4cbe-ae02-284cfaccc1e7
36	4	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	b09f6eb0-f79f-489a-a7e8-bb87486bc1b2
5	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	afd22d8d-4201-4482-888c-c06b85307651
20	4	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	e8be30cd-3daa-4118-8548-8731d7495020
6	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	afd22d8d-4201-4482-888c-c06b85307651
7	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	afd22d8d-4201-4482-888c-c06b85307651
1581	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	510ef6ac-d964-4857-81e9-85a00e00dc51
8	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	4b0ebee1-3f02-43c5-bdac-923b17a459bb
2281	2	\N	0	\N	\N	\N	TYPE_SUBMISSION	\N	cd410caa-8ed0-4822-8722-8eab234a8b4c	\N	351126ff-3ed8-4ee6-bb98-54a08e436331
2674	2	\N	0	\N	\N	\N	TYPE_SUBMISSION	\N	5ee61fad-2de8-4f98-834b-c327dfed413c	\N	2c23936e-e138-4502-8ec3-e8c71bb851b1
9	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	4b0ebee1-3f02-43c5-bdac-923b17a459bb
10	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	4b0ebee1-3f02-43c5-bdac-923b17a459bb
2282	2	\N	1	\N	\N	\N	TYPE_SUBMISSION	\N	cd410caa-8ed0-4822-8722-8eab234a8b4c	\N	351126ff-3ed8-4ee6-bb98-54a08e436331
11	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	240b86fb-057a-4098-b4a9-16362bd4d88e
2283	2	\N	3	\N	\N	\N	TYPE_SUBMISSION	\N	cd410caa-8ed0-4822-8722-8eab234a8b4c	\N	351126ff-3ed8-4ee6-bb98-54a08e436331
12	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	240b86fb-057a-4098-b4a9-16362bd4d88e
13	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	240b86fb-057a-4098-b4a9-16362bd4d88e
2675	2	\N	1	\N	\N	\N	TYPE_SUBMISSION	\N	5ee61fad-2de8-4f98-834b-c327dfed413c	\N	2c23936e-e138-4502-8ec3-e8c71bb851b1
14	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	f02c8749-274c-4492-ba7b-cc33c3b8db61
2284	2	\N	4	\N	\N	\N	TYPE_SUBMISSION	\N	cd410caa-8ed0-4822-8722-8eab234a8b4c	\N	351126ff-3ed8-4ee6-bb98-54a08e436331
15	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	f02c8749-274c-4492-ba7b-cc33c3b8db61
16	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	f02c8749-274c-4492-ba7b-cc33c3b8db61
2285	2	\N	2	\N	\N	\N	TYPE_SUBMISSION	\N	cd410caa-8ed0-4822-8722-8eab234a8b4c	\N	351126ff-3ed8-4ee6-bb98-54a08e436331
17	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	28df2a70-de20-4c58-a5c8-e3c24e688cee
2676	2	\N	3	\N	\N	\N	TYPE_SUBMISSION	\N	5ee61fad-2de8-4f98-834b-c327dfed413c	\N	2c23936e-e138-4502-8ec3-e8c71bb851b1
18	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	28df2a70-de20-4c58-a5c8-e3c24e688cee
19	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	28df2a70-de20-4c58-a5c8-e3c24e688cee
2677	2	\N	4	\N	\N	\N	TYPE_SUBMISSION	\N	5ee61fad-2de8-4f98-834b-c327dfed413c	\N	2c23936e-e138-4502-8ec3-e8c71bb851b1
1226	0	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	b1f9e084-1af0-4671-a7a6-29f55d92e4e5
21	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	19737605-9de5-494c-b19e-7118aa37b963
2678	2	\N	2	\N	\N	\N	TYPE_SUBMISSION	\N	5ee61fad-2de8-4f98-834b-c327dfed413c	\N	2c23936e-e138-4502-8ec3-e8c71bb851b1
22	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	19737605-9de5-494c-b19e-7118aa37b963
23	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	19737605-9de5-494c-b19e-7118aa37b963
24	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	f5a61cfd-721a-4eba-bf4f-4fa931159f12
2679	2	\N	0	\N	\N	\N	TYPE_SUBMISSION	\N	5ee61fad-2de8-4f98-834b-c327dfed413c	\N	0a2460c5-e7b6-4e59-8342-35dd4514da7c
25	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	f5a61cfd-721a-4eba-bf4f-4fa931159f12
26	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	f5a61cfd-721a-4eba-bf4f-4fa931159f12
2680	2	\N	1	\N	\N	\N	TYPE_SUBMISSION	\N	5ee61fad-2de8-4f98-834b-c327dfed413c	\N	0a2460c5-e7b6-4e59-8342-35dd4514da7c
27	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	bf82b5db-01cb-402c-81a9-8249ff7395a6
2681	2	\N	3	\N	\N	\N	TYPE_SUBMISSION	\N	5ee61fad-2de8-4f98-834b-c327dfed413c	\N	0a2460c5-e7b6-4e59-8342-35dd4514da7c
28	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	bf82b5db-01cb-402c-81a9-8249ff7395a6
29	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	bf82b5db-01cb-402c-81a9-8249ff7395a6
30	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	2aa863cf-c22a-4dae-8aed-2f08b702420a
2682	2	\N	4	\N	\N	\N	TYPE_SUBMISSION	\N	5ee61fad-2de8-4f98-834b-c327dfed413c	\N	0a2460c5-e7b6-4e59-8342-35dd4514da7c
31	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	2aa863cf-c22a-4dae-8aed-2f08b702420a
32	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	2aa863cf-c22a-4dae-8aed-2f08b702420a
2683	2	\N	2	\N	\N	\N	TYPE_SUBMISSION	\N	5ee61fad-2de8-4f98-834b-c327dfed413c	\N	0a2460c5-e7b6-4e59-8342-35dd4514da7c
33	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	d72bd580-c8d7-46af-ad71-ee7a50bbd582
34	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	d72bd580-c8d7-46af-ad71-ee7a50bbd582
35	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	d72bd580-c8d7-46af-ad71-ee7a50bbd582
2458	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	d2f5671b-6c52-4952-ba85-c3a87bf72a97
1582	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	6c09d5c6-7db2-4d59-a23c-a0cff7ea31da
37	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	0607dd1b-5468-48ef-8905-8d07d253d1f7
1583	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	fa9b00c5-369d-4db7-bec8-45627225438d
38	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	0607dd1b-5468-48ef-8905-8d07d253d1f7
39	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	0607dd1b-5468-48ef-8905-8d07d253d1f7
2459	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	e3f4ba1b-0b3f-477f-9785-2c45c1cc53e4
40	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	d52095c9-d548-4f66-9dad-d84f4928ded7
1832	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	b7cc4d08-a40f-4400-bca5-3039f8c965b3
41	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	d52095c9-d548-4f66-9dad-d84f4928ded7
42	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	d52095c9-d548-4f66-9dad-d84f4928ded7
43	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	f805ab68-cf57-431a-affc-8ce7f9778fe7
1833	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	50ffad89-623b-41e4-986a-c3a2feaade8c
44	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	f805ab68-cf57-431a-affc-8ce7f9778fe7
45	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	f805ab68-cf57-431a-affc-8ce7f9778fe7
1834	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	ddbfcf61-6825-46a0-afe5-f307b4bdefe9
46	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	5f662caf-e96c-432e-8137-a17afe17283b
47	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	5f662caf-e96c-432e-8137-a17afe17283b
48	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	5f662caf-e96c-432e-8137-a17afe17283b
49	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	fc9b46f8-dd31-4298-9f47-73af77f1c56d
50	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	fc9b46f8-dd31-4298-9f47-73af77f1c56d
51	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	fc9b46f8-dd31-4298-9f47-73af77f1c56d
54	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	c32fae4a-fdfa-4498-a50a-bc9285fbb3a0
55	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	c32fae4a-fdfa-4498-a50a-bc9285fbb3a0
56	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	c32fae4a-fdfa-4498-a50a-bc9285fbb3a0
57	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	8f327435-da4d-4bbe-99f2-df602eddf8fb
58	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	8f327435-da4d-4bbe-99f2-df602eddf8fb
59	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	8f327435-da4d-4bbe-99f2-df602eddf8fb
60	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	b73c9ead-ff11-4e99-bcd0-86186ccd10aa
69	4	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	050033bb-42bb-4d2e-be49-3bb13979f6b3
61	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	b73c9ead-ff11-4e99-bcd0-86186ccd10aa
62	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	b73c9ead-ff11-4e99-bcd0-86186ccd10aa
1227	0	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	d6834eae-2c8a-4ff3-85b8-022bdee1d3dd
63	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	fd415204-97cc-4568-938b-467f663aab73
70	4	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	bf24224f-e566-4c37-a5f1-27a1867114e6
1228	0	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	a3226bcc-9f1c-4216-9d44-8f1dcb06288b
64	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	fd415204-97cc-4568-938b-467f663aab73
65	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	fd415204-97cc-4568-938b-467f663aab73
86	4	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	ca5ff7d4-3470-4ef2-90ca-dc563214be58
66	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	19cefe3e-817f-4584-8647-e1e0345ca422
1229	0	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	c85acf18-4bc6-49d8-aeb1-9ac4b2666956
102	4	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	7a290d59-1bed-4a4f-a6a1-02e191774a8f
67	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	19cefe3e-817f-4584-8647-e1e0345ca422
68	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	19cefe3e-817f-4584-8647-e1e0345ca422
1230	0	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	75885d51-2fb0-4968-a3de-fe0c53eceb6b
929	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	1f0c95ab-3775-4094-b293-183d3b5074b2
118	4	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	6c5dd78a-94ba-4ba9-ba37-401a80442dd5
71	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	3bf97251-0d2c-497a-b1c0-2fb8f089d5d9
2460	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	ec87a684-65b5-4c2e-9ec0-df33773c4e5b
72	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	3bf97251-0d2c-497a-b1c0-2fb8f089d5d9
73	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	3bf97251-0d2c-497a-b1c0-2fb8f089d5d9
74	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	24a1c3ff-d7a4-4e39-92ca-bbbd1ef02a13
75	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	24a1c3ff-d7a4-4e39-92ca-bbbd1ef02a13
76	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	24a1c3ff-d7a4-4e39-92ca-bbbd1ef02a13
77	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	60f00aaf-c385-4dcb-b9a4-ed59d23e3feb
78	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	60f00aaf-c385-4dcb-b9a4-ed59d23e3feb
79	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	60f00aaf-c385-4dcb-b9a4-ed59d23e3feb
80	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	2a26db78-5987-40be-b908-a20da0086e8b
81	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	2a26db78-5987-40be-b908-a20da0086e8b
82	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	2a26db78-5987-40be-b908-a20da0086e8b
2296	2	\N	0	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	4efe5ddd-8bc9-43b6-a95d-bfedee710730
83	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	4e7863f5-b198-47e4-8eb1-688af9155b78
2297	2	\N	1	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	4efe5ddd-8bc9-43b6-a95d-bfedee710730
84	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	4e7863f5-b198-47e4-8eb1-688af9155b78
85	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	4e7863f5-b198-47e4-8eb1-688af9155b78
2611	2	\N	0	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	0fbb9e34-4b32-409d-a301-6a4a5e5a9ee4
2298	2	\N	3	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	4efe5ddd-8bc9-43b6-a95d-bfedee710730
87	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	b85655ce-7a32-438b-9211-a8b12ec6dcfd
2299	2	\N	4	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	4efe5ddd-8bc9-43b6-a95d-bfedee710730
88	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	b85655ce-7a32-438b-9211-a8b12ec6dcfd
89	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	b85655ce-7a32-438b-9211-a8b12ec6dcfd
2612	2	\N	1	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	0fbb9e34-4b32-409d-a301-6a4a5e5a9ee4
90	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	33d85721-7ff3-4926-ae80-084bb178dd97
2300	2	\N	2	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	4efe5ddd-8bc9-43b6-a95d-bfedee710730
91	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	33d85721-7ff3-4926-ae80-084bb178dd97
92	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	33d85721-7ff3-4926-ae80-084bb178dd97
2301	2	\N	0	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	9213adb3-98f4-4d42-b36f-a044402c752a
93	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	9a582dff-81aa-4021-9f30-f75871aeb9eb
2613	2	\N	3	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	0fbb9e34-4b32-409d-a301-6a4a5e5a9ee4
2302	2	\N	1	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	9213adb3-98f4-4d42-b36f-a044402c752a
94	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	9a582dff-81aa-4021-9f30-f75871aeb9eb
95	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	9a582dff-81aa-4021-9f30-f75871aeb9eb
96	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	681bb445-6fc8-49c1-9915-1d418f2ac4d1
2303	2	\N	3	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	9213adb3-98f4-4d42-b36f-a044402c752a
2614	2	\N	4	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	0fbb9e34-4b32-409d-a301-6a4a5e5a9ee4
97	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	681bb445-6fc8-49c1-9915-1d418f2ac4d1
98	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	681bb445-6fc8-49c1-9915-1d418f2ac4d1
2304	2	\N	4	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	9213adb3-98f4-4d42-b36f-a044402c752a
99	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	96f9e582-cb6e-441e-a361-97f5e69b8ff2
2305	2	\N	2	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	9213adb3-98f4-4d42-b36f-a044402c752a
100	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	96f9e582-cb6e-441e-a361-97f5e69b8ff2
101	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	96f9e582-cb6e-441e-a361-97f5e69b8ff2
2615	2	\N	2	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	0fbb9e34-4b32-409d-a301-6a4a5e5a9ee4
103	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	88d41f3a-a149-4dc5-81a2-84380835533a
2306	2	\N	0	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	2b63d710-d77a-46ed-a02d-8f12284d093d
930	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	12f6e52a-9df2-4bc6-8a4a-f88cebb87203
104	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	88d41f3a-a149-4dc5-81a2-84380835533a
105	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	88d41f3a-a149-4dc5-81a2-84380835533a
106	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	41b5c503-8ca0-435f-8103-3e692593b755
931	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	a36abd3c-a60d-454e-b3f6-c661d35d035b
2307	2	\N	1	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	2b63d710-d77a-46ed-a02d-8f12284d093d
107	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	41b5c503-8ca0-435f-8103-3e692593b755
108	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	41b5c503-8ca0-435f-8103-3e692593b755
109	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	728d1b2f-f32f-4ba9-80ff-922deca5458b
2308	2	\N	3	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	2b63d710-d77a-46ed-a02d-8f12284d093d
110	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	728d1b2f-f32f-4ba9-80ff-922deca5458b
111	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	728d1b2f-f32f-4ba9-80ff-922deca5458b
2309	2	\N	4	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	2b63d710-d77a-46ed-a02d-8f12284d093d
112	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	a2561e5d-7cbf-464d-b6e6-6178bddd9bae
2310	2	\N	2	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	2b63d710-d77a-46ed-a02d-8f12284d093d
113	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	a2561e5d-7cbf-464d-b6e6-6178bddd9bae
114	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	a2561e5d-7cbf-464d-b6e6-6178bddd9bae
115	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	25c745b0-5b75-44bd-91fb-f468f52c377b
116	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	25c745b0-5b75-44bd-91fb-f468f52c377b
117	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	25c745b0-5b75-44bd-91fb-f468f52c377b
119	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	357da42e-ffb4-43f7-bb59-3b66f6d09b1f
120	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	357da42e-ffb4-43f7-bb59-3b66f6d09b1f
121	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	357da42e-ffb4-43f7-bb59-3b66f6d09b1f
932	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	da51fa58-1abe-4f80-bbc7-9e72e48e1fcf
122	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	8a52ac60-0cb5-4d6f-8b4c-a9cd65b62d0a
933	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	916f5c8f-f012-4adb-8a55-1352136a4e85
123	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	8a52ac60-0cb5-4d6f-8b4c-a9cd65b62d0a
124	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	8a52ac60-0cb5-4d6f-8b4c-a9cd65b62d0a
2311	2	\N	0	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	d1483857-e58d-4d41-9d56-e70a642ca5f8
125	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	d851294f-191c-46a0-abf4-d338042d5971
1231	0	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	fa813a90-86ff-4f16-8639-424d9db60bf7
126	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	d851294f-191c-46a0-abf4-d338042d5971
127	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	d851294f-191c-46a0-abf4-d338042d5971
1232	0	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	67d54727-eeb4-4daa-8c41-40fd40134cad
128	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	fbe5350a-c8ba-4a39-98e2-bd742a6be202
1991	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	1446271c-d93d-42dc-a7ba-a6ca384b4448
1233	0	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	6bb85bb3-b2a7-4cfc-8fe5-eda2707287b4
129	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	fbe5350a-c8ba-4a39-98e2-bd742a6be202
130	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	fbe5350a-c8ba-4a39-98e2-bd742a6be202
2312	2	\N	1	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	d1483857-e58d-4d41-9d56-e70a642ca5f8
131	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	3afa7efe-2891-4c47-b396-c83d56ff9d90
1992	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	9496fe87-9539-44d1-8ca3-4d62c300194d
132	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	3afa7efe-2891-4c47-b396-c83d56ff9d90
133	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	3afa7efe-2891-4c47-b396-c83d56ff9d90
2313	2	\N	3	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	d1483857-e58d-4d41-9d56-e70a642ca5f8
1993	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	df71148b-a7aa-4c7f-9496-b0eaee0aae6f
2314	2	\N	4	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	d1483857-e58d-4d41-9d56-e70a642ca5f8
1994	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	f927872e-3dba-4482-af19-719b731d7fea
138	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	c087e9be-29f7-437f-b0da-bddb0b2ab183
139	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	c087e9be-29f7-437f-b0da-bddb0b2ab183
2315	2	\N	2	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	d1483857-e58d-4d41-9d56-e70a642ca5f8
140	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	f2c7e15a-2db1-4099-9d26-78ba2c16b8da
2316	2	\N	0	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	5465b2d4-cc89-4a55-bf57-b27704f9d683
141	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	f2c7e15a-2db1-4099-9d26-78ba2c16b8da
142	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	f2c7e15a-2db1-4099-9d26-78ba2c16b8da
1995	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	bc954f78-c223-4b19-ad6c-059227740671
143	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	cd75101b-abb6-46ef-ac88-3af552f33478
134	4	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	683bfc83-3cc1-4f22-83d3-c9ee4ea2c82b
144	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	cd75101b-abb6-46ef-ac88-3af552f33478
145	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	cd75101b-abb6-46ef-ac88-3af552f33478
2317	2	\N	1	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	5465b2d4-cc89-4a55-bf57-b27704f9d683
146	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	b55202c0-1e3b-4eba-909d-54f7fad48b9c
137	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	c087e9be-29f7-437f-b0da-bddb0b2ab183
147	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	b55202c0-1e3b-4eba-909d-54f7fad48b9c
148	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	b55202c0-1e3b-4eba-909d-54f7fad48b9c
2318	2	\N	3	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	5465b2d4-cc89-4a55-bf57-b27704f9d683
149	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	6ef94e51-16d7-4cec-9359-a94d499e8337
2319	2	\N	4	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	5465b2d4-cc89-4a55-bf57-b27704f9d683
150	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	6ef94e51-16d7-4cec-9359-a94d499e8337
151	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	6ef94e51-16d7-4cec-9359-a94d499e8337
2320	2	\N	2	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	5465b2d4-cc89-4a55-bf57-b27704f9d683
153	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	411dd125-33df-451a-87c9-7dca418b665e
2321	2	\N	0	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	6466da00-ee69-4ea7-a7b4-3bbdbbf104ae
154	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	411dd125-33df-451a-87c9-7dca418b665e
155	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	411dd125-33df-451a-87c9-7dca418b665e
156	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	7db66edb-3f9f-4c24-8fa2-0a4b11efb0b8
2322	2	\N	1	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	6466da00-ee69-4ea7-a7b4-3bbdbbf104ae
157	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	7db66edb-3f9f-4c24-8fa2-0a4b11efb0b8
158	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	7db66edb-3f9f-4c24-8fa2-0a4b11efb0b8
2323	2	\N	3	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	6466da00-ee69-4ea7-a7b4-3bbdbbf104ae
159	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	b2020a23-0063-4efe-b770-9c9a5a099b42
135	4	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	435bcf56-d368-4f2f-8e7f-4bafd3367063
136	4	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	f0cb7fe8-e5c5-4d33-9530-b38f96535074
160	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	b2020a23-0063-4efe-b770-9c9a5a099b42
161	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	b2020a23-0063-4efe-b770-9c9a5a099b42
152	4	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	342ea849-01c8-41cd-b812-44638b5c22ef
162	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	6a8d7523-aace-4c61-9a7f-9133ae72d7b0
168	4	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	e88afa75-f030-4a94-8c91-72257614e295
163	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	6a8d7523-aace-4c61-9a7f-9133ae72d7b0
164	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	6a8d7523-aace-4c61-9a7f-9133ae72d7b0
2324	2	\N	4	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	6466da00-ee69-4ea7-a7b4-3bbdbbf104ae
165	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	3449a99e-7799-4ba0-bd51-63ae8ee23093
2325	2	\N	2	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	6466da00-ee69-4ea7-a7b4-3bbdbbf104ae
166	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	3449a99e-7799-4ba0-bd51-63ae8ee23093
167	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	3449a99e-7799-4ba0-bd51-63ae8ee23093
169	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	1e0e772a-32a3-4fef-99c9-2aeab683bae2
170	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	1e0e772a-32a3-4fef-99c9-2aeab683bae2
171	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	1e0e772a-32a3-4fef-99c9-2aeab683bae2
172	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	909a8161-d474-4b0e-afdc-5a5ae63c3a6c
173	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	909a8161-d474-4b0e-afdc-5a5ae63c3a6c
174	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	909a8161-d474-4b0e-afdc-5a5ae63c3a6c
175	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	f6ed7993-8237-4ef0-9cc4-0573e90e75d2
176	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	f6ed7993-8237-4ef0-9cc4-0573e90e75d2
177	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	f6ed7993-8237-4ef0-9cc4-0573e90e75d2
178	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	66151470-c472-418e-a958-e93c235b10e4
179	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	66151470-c472-418e-a958-e93c235b10e4
180	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	66151470-c472-418e-a958-e93c235b10e4
181	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	d46da801-96a5-42ca-90a0-0ed42a484f3b
934	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	e629b0d9-bf91-439a-9f16-632d621535b2
182	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	d46da801-96a5-42ca-90a0-0ed42a484f3b
183	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	d46da801-96a5-42ca-90a0-0ed42a484f3b
217	4	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	6805171d-b16f-46e4-b7a1-2d91aafb9037
1240	2	\N	0	\N	\N	\N	TYPE_SUBMISSION	\N	a4d10708-6a03-4a32-9b2f-245adb6b6240	\N	c54373cb-b02d-4935-add5-f3c17ae29223
186	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	f3152358-78b0-495c-8086-12b8a7a6e7c4
1241	2	\N	1	\N	\N	\N	TYPE_SUBMISSION	\N	a4d10708-6a03-4a32-9b2f-245adb6b6240	\N	c54373cb-b02d-4935-add5-f3c17ae29223
187	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	f3152358-78b0-495c-8086-12b8a7a6e7c4
188	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	f3152358-78b0-495c-8086-12b8a7a6e7c4
937	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	972d8284-ac47-4d48-82fe-103a24fbe65b
189	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	87416815-8bb9-42a5-98eb-5aefce3bfbcf
1242	2	\N	3	\N	\N	\N	TYPE_SUBMISSION	\N	a4d10708-6a03-4a32-9b2f-245adb6b6240	\N	c54373cb-b02d-4935-add5-f3c17ae29223
190	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	87416815-8bb9-42a5-98eb-5aefce3bfbcf
191	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	87416815-8bb9-42a5-98eb-5aefce3bfbcf
1243	2	\N	4	\N	\N	\N	TYPE_SUBMISSION	\N	a4d10708-6a03-4a32-9b2f-245adb6b6240	\N	c54373cb-b02d-4935-add5-f3c17ae29223
192	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	24b8f080-dac2-454c-aba3-16201b523039
1244	2	\N	2	\N	\N	\N	TYPE_SUBMISSION	\N	a4d10708-6a03-4a32-9b2f-245adb6b6240	\N	c54373cb-b02d-4935-add5-f3c17ae29223
193	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	24b8f080-dac2-454c-aba3-16201b523039
194	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	24b8f080-dac2-454c-aba3-16201b523039
195	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	e666ae2f-259c-4fff-8884-df1c6401bbf9
196	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	e666ae2f-259c-4fff-8884-df1c6401bbf9
197	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	e666ae2f-259c-4fff-8884-df1c6401bbf9
198	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	289a3f50-e20c-442b-b1af-a6dc0e973bd5
199	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	289a3f50-e20c-442b-b1af-a6dc0e973bd5
200	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	289a3f50-e20c-442b-b1af-a6dc0e973bd5
2130	3	\N	3	\N	\N	\N	\N	\N	\N	9e6cee53-8569-420a-9e75-d704e5f3517c	6ef94e51-16d7-4cec-9359-a94d499e8337
202	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	efa858af-f6b2-44c4-abf0-e469f1353d10
2241	2	\N	0	\N	\N	\N	TYPE_SUBMISSION	\N	cd410caa-8ed0-4822-8722-8eab234a8b4c	\N	98667b07-a1fd-4b74-ba08-933c0d63c1d0
203	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	efa858af-f6b2-44c4-abf0-e469f1353d10
204	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	efa858af-f6b2-44c4-abf0-e469f1353d10
2242	2	\N	1	\N	\N	\N	TYPE_SUBMISSION	\N	cd410caa-8ed0-4822-8722-8eab234a8b4c	\N	98667b07-a1fd-4b74-ba08-933c0d63c1d0
205	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	1ba431f3-259a-4751-9ae9-22d5a110ae53
2243	2	\N	3	\N	\N	\N	TYPE_SUBMISSION	\N	cd410caa-8ed0-4822-8722-8eab234a8b4c	\N	98667b07-a1fd-4b74-ba08-933c0d63c1d0
206	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	1ba431f3-259a-4751-9ae9-22d5a110ae53
207	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	1ba431f3-259a-4751-9ae9-22d5a110ae53
208	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	3011dd24-c2db-46ef-b5d1-895e38d9b930
2244	2	\N	4	\N	\N	\N	TYPE_SUBMISSION	\N	cd410caa-8ed0-4822-8722-8eab234a8b4c	\N	98667b07-a1fd-4b74-ba08-933c0d63c1d0
209	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	3011dd24-c2db-46ef-b5d1-895e38d9b930
210	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	3011dd24-c2db-46ef-b5d1-895e38d9b930
2245	2	\N	2	\N	\N	\N	TYPE_SUBMISSION	\N	cd410caa-8ed0-4822-8722-8eab234a8b4c	\N	98667b07-a1fd-4b74-ba08-933c0d63c1d0
211	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	110adbb2-e44d-4c83-80e6-d404b4741ed4
212	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	110adbb2-e44d-4c83-80e6-d404b4741ed4
213	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	110adbb2-e44d-4c83-80e6-d404b4741ed4
214	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	9683b122-799f-4d4e-92b8-8f57283e964f
215	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	9683b122-799f-4d4e-92b8-8f57283e964f
216	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	9683b122-799f-4d4e-92b8-8f57283e964f
2246	1	\N	2	\N	\N	\N	TYPE_SUBMISSION	\N	cd410caa-8ed0-4822-8722-8eab234a8b4c	\N	bf28708a-d254-4e0b-9189-a5704d83d883
2247	1	\N	4	\N	\N	\N	TYPE_SUBMISSION	\N	cd410caa-8ed0-4822-8722-8eab234a8b4c	\N	bf28708a-d254-4e0b-9189-a5704d83d883
218	4	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	043d9a3f-684c-4fc2-a642-4df251ff0ce6
2248	1	\N	3	\N	\N	\N	TYPE_SUBMISSION	\N	cd410caa-8ed0-4822-8722-8eab234a8b4c	\N	bf28708a-d254-4e0b-9189-a5704d83d883
219	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	995b6a10-b9dc-4f43-bd81-b6249cd8b191
2249	1	\N	1	\N	\N	\N	TYPE_SUBMISSION	\N	cd410caa-8ed0-4822-8722-8eab234a8b4c	\N	bf28708a-d254-4e0b-9189-a5704d83d883
2250	1	\N	0	\N	\N	\N	TYPE_SUBMISSION	\N	cd410caa-8ed0-4822-8722-8eab234a8b4c	\N	bf28708a-d254-4e0b-9189-a5704d83d883
220	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	995b6a10-b9dc-4f43-bd81-b6249cd8b191
221	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	995b6a10-b9dc-4f43-bd81-b6249cd8b191
222	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	617031b7-af6b-4fa3-9644-dc5ade438caf
223	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	617031b7-af6b-4fa3-9644-dc5ade438caf
224	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	617031b7-af6b-4fa3-9644-dc5ade438caf
225	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	5b1045d7-6c9e-4446-ae09-6831ea31e1cc
184	4	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	7709d357-75c7-4039-bfcf-f2297e7493e9
185	4	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	e43ea389-e3e6-410b-bbc3-75bce3a6474f
226	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	5b1045d7-6c9e-4446-ae09-6831ea31e1cc
227	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	5b1045d7-6c9e-4446-ae09-6831ea31e1cc
201	4	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	08285b26-0b55-48c0-aae2-bd4c60dece4b
228	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	0a4d3518-c6fa-4a84-bec3-453eafd845b7
2251	0	\N	0	\N	\N	\N	TYPE_SUBMISSION	\N	cd410caa-8ed0-4822-8722-8eab234a8b4c	\N	1c879e87-ef55-4420-9fff-a0d9ef52a1c2
229	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	0a4d3518-c6fa-4a84-bec3-453eafd845b7
230	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	0a4d3518-c6fa-4a84-bec3-453eafd845b7
2252	0	\N	1	\N	\N	\N	TYPE_SUBMISSION	\N	cd410caa-8ed0-4822-8722-8eab234a8b4c	\N	1c879e87-ef55-4420-9fff-a0d9ef52a1c2
231	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	c513be3f-2789-46b7-bc33-0feea0e7e628
2253	0	\N	3	\N	\N	\N	TYPE_SUBMISSION	\N	cd410caa-8ed0-4822-8722-8eab234a8b4c	\N	1c879e87-ef55-4420-9fff-a0d9ef52a1c2
2254	0	\N	4	\N	\N	\N	TYPE_SUBMISSION	\N	cd410caa-8ed0-4822-8722-8eab234a8b4c	\N	1c879e87-ef55-4420-9fff-a0d9ef52a1c2
232	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	c513be3f-2789-46b7-bc33-0feea0e7e628
233	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	c513be3f-2789-46b7-bc33-0feea0e7e628
2255	0	\N	2	\N	\N	\N	TYPE_SUBMISSION	\N	cd410caa-8ed0-4822-8722-8eab234a8b4c	\N	1c879e87-ef55-4420-9fff-a0d9ef52a1c2
234	4	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	54def7e9-b01c-4405-831b-f55d391bc8db
235	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	5539833b-6142-452e-bea3-fc373b058c14
2256	2	\N	0	\N	\N	\N	TYPE_SUBMISSION	\N	cd410caa-8ed0-4822-8722-8eab234a8b4c	\N	c80bc66c-a22e-43ae-8149-4fb687e2aad1
236	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	5539833b-6142-452e-bea3-fc373b058c14
237	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	5539833b-6142-452e-bea3-fc373b058c14
2257	2	\N	1	\N	\N	\N	TYPE_SUBMISSION	\N	cd410caa-8ed0-4822-8722-8eab234a8b4c	\N	c80bc66c-a22e-43ae-8149-4fb687e2aad1
238	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	ef2b53fa-b6fb-4962-a523-53ff8c1e65fa
2258	2	\N	3	\N	\N	\N	TYPE_SUBMISSION	\N	cd410caa-8ed0-4822-8722-8eab234a8b4c	\N	c80bc66c-a22e-43ae-8149-4fb687e2aad1
239	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	ef2b53fa-b6fb-4962-a523-53ff8c1e65fa
240	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	ef2b53fa-b6fb-4962-a523-53ff8c1e65fa
2259	2	\N	4	\N	\N	\N	TYPE_SUBMISSION	\N	cd410caa-8ed0-4822-8722-8eab234a8b4c	\N	c80bc66c-a22e-43ae-8149-4fb687e2aad1
241	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	701fb3d8-8ea8-43b9-ad0a-27e0a053f41f
242	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	701fb3d8-8ea8-43b9-ad0a-27e0a053f41f
243	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	701fb3d8-8ea8-43b9-ad0a-27e0a053f41f
2131	3	\N	3	\N	\N		TYPE_CUSTOM		\N	20d44fc9-5933-4c33-8e9b-22fa73c0e866	b55202c0-1e3b-4eba-909d-54f7fad48b9c
244	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	82ad2994-8a8a-4734-8924-089e49902749
2140	3	\N	3	\N	\N	\N	\N	\N	\N	609ddd28-e6f3-41a2-a670-e0c2776bcca7	c087e9be-29f7-437f-b0da-bddb0b2ab183
245	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	82ad2994-8a8a-4734-8924-089e49902749
246	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	82ad2994-8a8a-4734-8924-089e49902749
2471	2	\N	0	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	a96c12d6-537a-46d9-9b12-5e6e3841afea
247	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	3004c43c-f694-4d5d-bc56-d89e562d8810
1248	4	\N	1	\N	\N		TYPE_CUSTOM		\N	2749c445-d9b3-4641-bbd5-c292cbc31c3e	9b4b9979-0172-4961-9d58-10f57df85092
248	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	3004c43c-f694-4d5d-bc56-d89e562d8810
249	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	3004c43c-f694-4d5d-bc56-d89e562d8810
2472	2	\N	1	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	a96c12d6-537a-46d9-9b12-5e6e3841afea
250	4	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	0122bff8-45c5-4403-9af8-4d92e63bf462
251	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	2255af62-ea0f-441e-8cef-c95a842d0c8f
2473	2	\N	3	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	a96c12d6-537a-46d9-9b12-5e6e3841afea
252	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	2255af62-ea0f-441e-8cef-c95a842d0c8f
253	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	2255af62-ea0f-441e-8cef-c95a842d0c8f
2474	2	\N	4	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	a96c12d6-537a-46d9-9b12-5e6e3841afea
254	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	5f35338b-62e5-48be-9737-7ec419eb9fc9
2475	2	\N	2	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	a96c12d6-537a-46d9-9b12-5e6e3841afea
255	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	5f35338b-62e5-48be-9737-7ec419eb9fc9
256	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	5f35338b-62e5-48be-9737-7ec419eb9fc9
1252	4	\N	3	\N	\N		TYPE_CUSTOM		\N	2749c445-d9b3-4641-bbd5-c292cbc31c3e	9b4b9979-0172-4961-9d58-10f57df85092
257	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	beaabaf0-bfc2-411f-9a6d-e6135d699097
2476	2	\N	0	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	a933e90f-022f-487e-bb25-c1e3f9de5e6c
258	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	beaabaf0-bfc2-411f-9a6d-e6135d699097
259	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	beaabaf0-bfc2-411f-9a6d-e6135d699097
2023	0	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	\N
260	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	ee0feefe-84c4-4d99-b69c-06445074d7ff
2477	2	\N	1	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	a933e90f-022f-487e-bb25-c1e3f9de5e6c
261	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	ee0feefe-84c4-4d99-b69c-06445074d7ff
262	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	ee0feefe-84c4-4d99-b69c-06445074d7ff
263	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	1f9d14c8-64db-41c2-9867-9641e5d112b1
2025	1	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	b6a93f95-1b06-48ac-8422-c0ff627bc780
2024	0	\N	0	\N	\N	\N	TYPE_CUSTOM		\N	582e3083-b833-4022-a81e-04220f4eca76	2966e974-c340-4197-94de-d6815d41bf0d
264	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	1f9d14c8-64db-41c2-9867-9641e5d112b1
265	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	1f9d14c8-64db-41c2-9867-9641e5d112b1
266	4	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	c338e24b-54ce-439e-80fb-6aea64047d8c
1257	4	\N	4	\N	\N		TYPE_CUSTOM		\N	2749c445-d9b3-4641-bbd5-c292cbc31c3e	9b4b9979-0172-4961-9d58-10f57df85092
267	4	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	58411222-09a0-4a4c-a0aa-a16fed8c8057
2478	2	\N	3	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	a933e90f-022f-487e-bb25-c1e3f9de5e6c
268	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	4ee1cee2-a251-4b2d-9205-e12ad4a8499a
1630	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	c6f291c2-9995-454e-a838-cb645ec2de77
1629	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	09d7f4dc-8fce-43c0-b778-0df584c2739f
269	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	4ee1cee2-a251-4b2d-9205-e12ad4a8499a
270	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	4ee1cee2-a251-4b2d-9205-e12ad4a8499a
271	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	8380299d-ae45-4b0b-bab1-3f2769dfdca8
1258	0	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	5727043c-4c89-4e29-a594-6b8fe56ad3f7
272	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	8380299d-ae45-4b0b-bab1-3f2769dfdca8
273	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	8380299d-ae45-4b0b-bab1-3f2769dfdca8
1259	0	\N	4	\N	\N		TYPE_CUSTOM		\N	2749c445-d9b3-4641-bbd5-c292cbc31c3e	5727043c-4c89-4e29-a594-6b8fe56ad3f7
274	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	f4897015-28c0-46b4-9b1c-0312bbe14f19
1260	0	\N	3	\N	\N		TYPE_CUSTOM		\N	2749c445-d9b3-4641-bbd5-c292cbc31c3e	5727043c-4c89-4e29-a594-6b8fe56ad3f7
1261	0	\N	1	\N	\N		TYPE_CUSTOM		\N	2749c445-d9b3-4641-bbd5-c292cbc31c3e	5727043c-4c89-4e29-a594-6b8fe56ad3f7
275	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	f4897015-28c0-46b4-9b1c-0312bbe14f19
276	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	f4897015-28c0-46b4-9b1c-0312bbe14f19
1262	0	\N	0	\N	\N		TYPE_CUSTOM		\N	2749c445-d9b3-4641-bbd5-c292cbc31c3e	5727043c-4c89-4e29-a594-6b8fe56ad3f7
277	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	cf051540-fc52-47a6-9247-7cca3089b0d2
2616	2	\N	0	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	e21ca461-7f92-4cc7-8b99-9779c76e351a
1263	3	\N	1	\N	\N		TYPE_CUSTOM		\N	2749c445-d9b3-4641-bbd5-c292cbc31c3e	3dac7ef7-c456-42a2-8fc4-519e13b07ee0
278	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	cf051540-fc52-47a6-9247-7cca3089b0d2
279	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	cf051540-fc52-47a6-9247-7cca3089b0d2
280	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	0f8aee5b-53cc-46b2-af21-4b7fea33f4a8
1264	3	\N	3	\N	\N		TYPE_CUSTOM		\N	2749c445-d9b3-4641-bbd5-c292cbc31c3e	3dac7ef7-c456-42a2-8fc4-519e13b07ee0
2617	2	\N	1	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	e21ca461-7f92-4cc7-8b99-9779c76e351a
281	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	0f8aee5b-53cc-46b2-af21-4b7fea33f4a8
282	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	0f8aee5b-53cc-46b2-af21-4b7fea33f4a8
1265	2	\N	1	\N	\N		TYPE_CUSTOM		\N	2749c445-d9b3-4641-bbd5-c292cbc31c3e	28f1a24a-b6ea-4b76-bba7-6779f81b14fe
283	4	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	131515f5-0c56-4276-94dd-054d41a4f959
284	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	2db4aa27-37b4-454e-86d1-24dd3185a968
285	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	2db4aa27-37b4-454e-86d1-24dd3185a968
286	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	2db4aa27-37b4-454e-86d1-24dd3185a968
287	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	6fbf8d40-a83f-4977-bf0f-2fbdc397a975
1245	4	\N	0	\N	\N		TYPE_CUSTOM		\N	2749c445-d9b3-4641-bbd5-c292cbc31c3e	9b4b9979-0172-4961-9d58-10f57df85092
288	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	6fbf8d40-a83f-4977-bf0f-2fbdc397a975
289	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	6fbf8d40-a83f-4977-bf0f-2fbdc397a975
290	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	7e531fe1-bf4a-4d2e-a697-b8ccaf587377
291	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	7e531fe1-bf4a-4d2e-a697-b8ccaf587377
292	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	7e531fe1-bf4a-4d2e-a697-b8ccaf587377
293	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	e6dd595d-9bc9-4ec0-a594-1e9c8d541133
294	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	e6dd595d-9bc9-4ec0-a594-1e9c8d541133
295	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	e6dd595d-9bc9-4ec0-a594-1e9c8d541133
296	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	f8f0c20b-e38b-47ee-8788-2c675649e67c
297	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	f8f0c20b-e38b-47ee-8788-2c675649e67c
298	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	f8f0c20b-e38b-47ee-8788-2c675649e67c
299	4	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	265b2c85-db13-4fe1-ab54-4134f76d252b
300	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	4e77e1c7-3c74-4ced-ba10-bad97ecd405d
1870	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	24fb983c-62fc-41d7-9a45-45bf55a5359c
301	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	4e77e1c7-3c74-4ced-ba10-bad97ecd405d
302	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	4e77e1c7-3c74-4ced-ba10-bad97ecd405d
965	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	b37744b2-292c-4937-a401-9243b80980b3
303	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	3bbcfa02-d7d2-4733-9f3d-45ad29a8117a
347	4	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	f7af0744-1ec4-437f-88db-205b9666f652
966	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	5c1126f4-8376-42d3-b83e-3f4f070a6710
304	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	3bbcfa02-d7d2-4733-9f3d-45ad29a8117a
305	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	3bbcfa02-d7d2-4733-9f3d-45ad29a8117a
1631	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	50e510a9-0bdb-4a55-b55f-dc37ea43633a
306	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	cd65d599-6ac3-470c-9eb6-75f9aed99357
967	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	0d9ed226-7e90-48b9-807d-f0b893dd48b0
1099	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	5bb00ffc-b25e-487d-a336-aa5b07b778ec
307	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	cd65d599-6ac3-470c-9eb6-75f9aed99357
308	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	cd65d599-6ac3-470c-9eb6-75f9aed99357
968	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	276a4446-ee69-4bc0-8f29-690dbf3fbaa2
309	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	9f225cd4-4db1-4fb2-b976-ea4e9ae18656
2479	2	\N	4	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	a933e90f-022f-487e-bb25-c1e3f9de5e6c
969	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	599069e2-0776-4d86-8654-9c6352b3b7c7
310	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	9f225cd4-4db1-4fb2-b976-ea4e9ae18656
311	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	9f225cd4-4db1-4fb2-b976-ea4e9ae18656
2132	3	\N	3	\N	\N		TYPE_CUSTOM		\N	20d44fc9-5933-4c33-8e9b-22fa73c0e866	cd75101b-abb6-46ef-ac88-3af552f33478
312	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	f2af2366-3fec-449c-9571-fe170605a28e
2260	2	\N	2	\N	\N	\N	TYPE_SUBMISSION	\N	cd410caa-8ed0-4822-8722-8eab234a8b4c	\N	c80bc66c-a22e-43ae-8149-4fb687e2aad1
2032	1	\N	1	\N	\N		TYPE_CUSTOM		\N	2749c445-d9b3-4641-bbd5-c292cbc31c3e	d2fd6cdc-efbe-47ba-bb06-06971d06d11b
313	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	f2af2366-3fec-449c-9571-fe170605a28e
314	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	f2af2366-3fec-449c-9571-fe170605a28e
315	4	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	777e1210-3ec0-459a-aca6-29b715063e73
2480	2	\N	2	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	a933e90f-022f-487e-bb25-c1e3f9de5e6c
316	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	ea7f0fea-6dd7-4907-beef-d60d62f7a0d9
1103	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	aedad30e-a19a-468a-9f45-22219de85513
317	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	ea7f0fea-6dd7-4907-beef-d60d62f7a0d9
318	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	ea7f0fea-6dd7-4907-beef-d60d62f7a0d9
2031	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	d2fd6cdc-efbe-47ba-bb06-06971d06d11b
319	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	79f9afe4-97a6-42a4-a906-f80f360ad656
2481	2	\N	0	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	fa0c8a49-a6bf-4d87-805d-5233c36c82ea
320	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	79f9afe4-97a6-42a4-a906-f80f360ad656
321	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	79f9afe4-97a6-42a4-a906-f80f360ad656
1105	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	551fa807-a0c5-4594-8861-b4b6f6f6d82e
322	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	828c145d-a069-48d4-857b-9ee667d38c68
1871	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	35120e12-4729-4a25-a25b-572399403a63
323	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	828c145d-a069-48d4-857b-9ee667d38c68
324	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	828c145d-a069-48d4-857b-9ee667d38c68
2482	2	\N	1	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	fa0c8a49-a6bf-4d87-805d-5233c36c82ea
325	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	ac22c96b-12db-4e4a-82c9-63e1c5af3de3
1872	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	4afdf8ac-bf2a-4d7d-9020-24aaa7344ce7
326	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	ac22c96b-12db-4e4a-82c9-63e1c5af3de3
327	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	ac22c96b-12db-4e4a-82c9-63e1c5af3de3
2483	2	\N	3	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	fa0c8a49-a6bf-4d87-805d-5233c36c82ea
328	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	f68dd0f4-475b-4b2d-9cd1-8236b29ff7b4
1109	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	5690cd4e-8606-4c7e-ab6d-078223839687
329	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	f68dd0f4-475b-4b2d-9cd1-8236b29ff7b4
330	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	f68dd0f4-475b-4b2d-9cd1-8236b29ff7b4
2035	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	0ee257a7-150e-4396-9c23-4d155ead67d5
331	4	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	6599bbd5-7809-439a-85d2-dd0c607838cc
2484	2	\N	4	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	fa0c8a49-a6bf-4d87-805d-5233c36c82ea
332	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	8742eb33-87b7-4f31-8ed8-be8788d16368
1111	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	8b34f2e0-5993-4256-9619-3c691d85be98
333	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	8742eb33-87b7-4f31-8ed8-be8788d16368
334	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	8742eb33-87b7-4f31-8ed8-be8788d16368
2036	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	2715b220-a689-4384-89a8-78efb69abf3b
335	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	048560cc-de2b-4693-969c-61d493365d18
2037	1	\N	1	\N	\N		TYPE_CUSTOM		\N	2749c445-d9b3-4641-bbd5-c292cbc31c3e	2715b220-a689-4384-89a8-78efb69abf3b
336	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	048560cc-de2b-4693-969c-61d493365d18
337	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	048560cc-de2b-4693-969c-61d493365d18
338	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	bb4c6911-03b5-480e-819e-6a760460e9a1
339	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	bb4c6911-03b5-480e-819e-6a760460e9a1
340	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	bb4c6911-03b5-480e-819e-6a760460e9a1
341	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	893f8288-3bfe-4656-9c84-4fbb6f695849
342	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	893f8288-3bfe-4656-9c84-4fbb6f695849
343	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	893f8288-3bfe-4656-9c84-4fbb6f695849
344	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	2f7c5598-12bd-41ee-a1f4-625b8d93f2ef
345	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	2f7c5598-12bd-41ee-a1f4-625b8d93f2ef
346	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	2f7c5598-12bd-41ee-a1f4-625b8d93f2ef
348	4	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	4de09263-c707-4a67-b45a-f9de6a6edac0
349	4	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	7590066c-de6e-4a65-9565-25e1bd3b87f6
350	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	90601c90-b68b-4ea2-8b12-e13ccc6eb0e5
351	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	90601c90-b68b-4ea2-8b12-e13ccc6eb0e5
352	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	90601c90-b68b-4ea2-8b12-e13ccc6eb0e5
353	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	673a6a9d-1cdd-4613-ac3b-1814c8831656
354	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	673a6a9d-1cdd-4613-ac3b-1814c8831656
355	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	673a6a9d-1cdd-4613-ac3b-1814c8831656
356	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	f9de8b0b-92ab-4726-9a25-387f0a8d2720
357	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	f9de8b0b-92ab-4726-9a25-387f0a8d2720
358	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	f9de8b0b-92ab-4726-9a25-387f0a8d2720
359	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	9611172c-b2e0-4bfa-8f3c-57d9f82bb480
360	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	9611172c-b2e0-4bfa-8f3c-57d9f82bb480
361	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	9611172c-b2e0-4bfa-8f3c-57d9f82bb480
2485	2	\N	2	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	fa0c8a49-a6bf-4d87-805d-5233c36c82ea
362	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	22b91317-4740-4caa-bb89-5a45c9c311f3
2133	3	\N	3	\N	\N		TYPE_CUSTOM		\N	20d44fc9-5933-4c33-8e9b-22fa73c0e866	f2c7e15a-2db1-4099-9d26-78ba2c16b8da
1115	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	c571a8dc-0d71-42e2-9b92-2b2ef5675ade
363	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	22b91317-4740-4caa-bb89-5a45c9c311f3
364	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	22b91317-4740-4caa-bb89-5a45c9c311f3
365	4	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	01bf637b-7e76-4610-88b6-b85270d50e0c
2134	3	\N	3	\N	\N		TYPE_CUSTOM		\N	20d44fc9-5933-4c33-8e9b-22fa73c0e866	c087e9be-29f7-437f-b0da-bddb0b2ab183
366	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	645f03ae-c3bd-4ff3-94c3-31acc342036c
2040	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	069756ac-ffb4-41f5-b33c-d90e382e79b4
367	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	645f03ae-c3bd-4ff3-94c3-31acc342036c
368	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	645f03ae-c3bd-4ff3-94c3-31acc342036c
2041	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	d5ab3c0f-e4fb-4d5d-80bb-f66751da4850
369	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	4f1937a8-4952-4ad7-8517-a3b777ef3ed7
370	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	4f1937a8-4952-4ad7-8517-a3b777ef3ed7
371	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	4f1937a8-4952-4ad7-8517-a3b777ef3ed7
372	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	9c1f759e-1c23-443e-b601-dd4b5a867d98
2043	0	\N	0	\N	\N	\N	TYPE_CUSTOM		\N	582e3083-b833-4022-a81e-04220f4eca76	f3688f7e-ed1a-43e0-ad17-6f3638d64723
373	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	9c1f759e-1c23-443e-b601-dd4b5a867d98
374	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	9c1f759e-1c23-443e-b601-dd4b5a867d98
2044	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	0b1f1831-2e41-4c59-af71-5f537a9a1a22
375	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	eb746f42-f39e-484c-8ad7-51b355b7f227
376	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	eb746f42-f39e-484c-8ad7-51b355b7f227
377	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	eb746f42-f39e-484c-8ad7-51b355b7f227
378	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	a6ba185b-3885-4be2-9bb5-dc61de428543
2046	0	\N	0	\N	\N	\N	TYPE_CUSTOM		\N	582e3083-b833-4022-a81e-04220f4eca76	29eef076-48c8-40af-b18c-7bcac3baa316
379	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	a6ba185b-3885-4be2-9bb5-dc61de428543
380	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	a6ba185b-3885-4be2-9bb5-dc61de428543
2047	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	de0009cf-13b5-4649-86fe-90fc9eec3b30
381	4	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	927e147b-5d98-4bc8-be35-941cdaf90018
382	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	c5d79dda-0dfe-4acb-ba9b-b9850715b7f5
2141	2	\N	0	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	861af420-dd5d-497c-83d4-f06ebcfc9528
383	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	c5d79dda-0dfe-4acb-ba9b-b9850715b7f5
384	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	c5d79dda-0dfe-4acb-ba9b-b9850715b7f5
385	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	a44d06ae-fd12-4b30-b17e-24944c917470
2142	2	\N	1	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	861af420-dd5d-497c-83d4-f06ebcfc9528
386	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	a44d06ae-fd12-4b30-b17e-24944c917470
387	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	a44d06ae-fd12-4b30-b17e-24944c917470
2143	2	\N	3	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	861af420-dd5d-497c-83d4-f06ebcfc9528
388	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	f38cddca-d777-4d6b-b104-867d27969d2a
2144	2	\N	4	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	861af420-dd5d-497c-83d4-f06ebcfc9528
389	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	f38cddca-d777-4d6b-b104-867d27969d2a
390	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	f38cddca-d777-4d6b-b104-867d27969d2a
391	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	48de73ab-3a92-4c08-a1ae-4c7cf43e8341
2145	2	\N	2	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	861af420-dd5d-497c-83d4-f06ebcfc9528
392	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	48de73ab-3a92-4c08-a1ae-4c7cf43e8341
393	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	48de73ab-3a92-4c08-a1ae-4c7cf43e8341
394	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	a89ae057-da72-458a-8b54-c2c01c59633e
395	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	a89ae057-da72-458a-8b54-c2c01c59633e
396	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	a89ae057-da72-458a-8b54-c2c01c59633e
397	4	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	1f1e123d-71ba-45d8-a436-9866334f6679
398	4	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	4a04d20c-9629-456f-a426-cc82d587d3cb
399	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	b824b5fd-76a7-4fd8-87a3-6d2942b62eb0
400	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	b824b5fd-76a7-4fd8-87a3-6d2942b62eb0
401	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	b824b5fd-76a7-4fd8-87a3-6d2942b62eb0
402	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	40a29a62-25aa-491f-8791-ec96017b4e12
1652	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	3e935853-f1c6-47a7-9e22-2a457109ee60
403	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	40a29a62-25aa-491f-8791-ec96017b4e12
404	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	40a29a62-25aa-491f-8791-ec96017b4e12
405	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	79922945-f438-4446-bc33-6565320adebf
1653	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	3e935853-f1c6-47a7-9e22-2a457109ee60
406	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	79922945-f438-4446-bc33-6565320adebf
407	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	79922945-f438-4446-bc33-6565320adebf
1654	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	3e935853-f1c6-47a7-9e22-2a457109ee60
408	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	63035ee2-cc1c-4302-9d66-ebf6901744a4
1655	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	70511c74-d0ea-42c8-8bbf-f8446f544022
409	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	63035ee2-cc1c-4302-9d66-ebf6901744a4
410	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	63035ee2-cc1c-4302-9d66-ebf6901744a4
411	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	c1a15047-56a4-43bf-aaf6-fd0e6477f98f
1656	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	70511c74-d0ea-42c8-8bbf-f8446f544022
412	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	c1a15047-56a4-43bf-aaf6-fd0e6477f98f
413	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	c1a15047-56a4-43bf-aaf6-fd0e6477f98f
1657	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	70511c74-d0ea-42c8-8bbf-f8446f544022
414	4	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	fa19502e-672d-4ce0-b465-111ab855321a
415	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	70366e28-2101-47c1-abc4-3711331158f2
1658	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	7f76cd2d-725a-479d-999f-6581b07371ac
416	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	70366e28-2101-47c1-abc4-3711331158f2
417	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	70366e28-2101-47c1-abc4-3711331158f2
418	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	4a253056-b197-44af-b8e6-13f826ad9a22
1659	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	7f76cd2d-725a-479d-999f-6581b07371ac
1660	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	7f76cd2d-725a-479d-999f-6581b07371ac
419	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	4a253056-b197-44af-b8e6-13f826ad9a22
420	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	4a253056-b197-44af-b8e6-13f826ad9a22
1661	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	90c56da0-ae13-4f05-aa67-be54c7bad83a
1662	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	90c56da0-ae13-4f05-aa67-be54c7bad83a
1663	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	90c56da0-ae13-4f05-aa67-be54c7bad83a
1664	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	d43aa0c1-4c5f-4c36-bf52-1df23a753b59
1665	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	d43aa0c1-4c5f-4c36-bf52-1df23a753b59
1666	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	d43aa0c1-4c5f-4c36-bf52-1df23a753b59
421	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	d3b46df8-f992-4cc2-824c-1efbbd369775
995	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	25cb38d4-142c-4282-a4cc-b7be4e8f363b
422	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	d3b46df8-f992-4cc2-824c-1efbbd369775
423	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	d3b46df8-f992-4cc2-824c-1efbbd369775
1667	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	65dac126-89fc-463c-ba18-63d827a920c5
424	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	5eff5609-7edc-4d4f-98d3-a7a561862a93
996	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	a260f402-ab1b-48d5-8f31-e54b8246e97e
2049	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	8c007dd9-ff34-4051-a72a-3e9cce0c5c8f
425	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	5eff5609-7edc-4d4f-98d3-a7a561862a93
426	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	5eff5609-7edc-4d4f-98d3-a7a561862a93
997	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	2b2be099-c0d6-40a0-9daf-83fb0c6a8328
427	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	fdae48ca-2993-46f9-b543-c623e2f23a28
2146	2	\N	0	\N	\N	\N	TYPE_SUBMISSION	\N	5ee61fad-2de8-4f98-834b-c327dfed413c	\N	33a11e84-68c9-4e4c-8aba-53990a33f7ca
998	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	2dd047b5-e43b-4ba9-8d1d-b6badc87a459
428	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	fdae48ca-2993-46f9-b543-c623e2f23a28
429	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	fdae48ca-2993-46f9-b543-c623e2f23a28
1668	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	65dac126-89fc-463c-ba18-63d827a920c5
430	4	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	68c53a2c-0fd6-42a1-9c67-3387ebe11972
999	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	d5ba2f5e-4e86-40fd-b152-3ae25ff15c7d
431	4	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	5a2d5225-d585-4549-8758-a2c186dcb42a
1669	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	65dac126-89fc-463c-ba18-63d827a920c5
432	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	8d1bb197-7f21-44c8-8b4f-1aa584dcc189
2050	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	b9bc2a0e-639a-4587-9f6d-42fec43ffd82
1670	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	e8aa370e-19da-4d55-bb48-c53fff30c7b2
433	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	8d1bb197-7f21-44c8-8b4f-1aa584dcc189
434	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	8d1bb197-7f21-44c8-8b4f-1aa584dcc189
435	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	6a4f724e-ee9e-41c4-9418-275558f5b865
2147	2	\N	1	\N	\N	\N	TYPE_SUBMISSION	\N	5ee61fad-2de8-4f98-834b-c327dfed413c	\N	33a11e84-68c9-4e4c-8aba-53990a33f7ca
1671	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	e8aa370e-19da-4d55-bb48-c53fff30c7b2
436	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	6a4f724e-ee9e-41c4-9418-275558f5b865
437	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	6a4f724e-ee9e-41c4-9418-275558f5b865
1672	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	e8aa370e-19da-4d55-bb48-c53fff30c7b2
438	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	84d45869-0e52-4f3c-8468-7419f86c5727
1673	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	907454e2-0671-4ddf-9725-3509a9c3a454
439	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	84d45869-0e52-4f3c-8468-7419f86c5727
440	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	84d45869-0e52-4f3c-8468-7419f86c5727
2052	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	1d3c4bdf-7b01-4175-9d09-1698499c29c5
441	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	9a4df270-972f-4ab6-9fb0-5f96e79db5da
2148	2	\N	3	\N	\N	\N	TYPE_SUBMISSION	\N	5ee61fad-2de8-4f98-834b-c327dfed413c	\N	33a11e84-68c9-4e4c-8aba-53990a33f7ca
1674	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	907454e2-0671-4ddf-9725-3509a9c3a454
442	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	9a4df270-972f-4ab6-9fb0-5f96e79db5da
443	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	9a4df270-972f-4ab6-9fb0-5f96e79db5da
1675	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	907454e2-0671-4ddf-9725-3509a9c3a454
444	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	0daedcc9-d2b3-4833-bfe4-a0eeaee838b2
2053	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	0a7a2874-2f9d-477f-9044-465aae71afcd
1676	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	1633cc84-63f4-4adf-986b-7da47de84bad
445	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	0daedcc9-d2b3-4833-bfe4-a0eeaee838b2
446	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	0daedcc9-d2b3-4833-bfe4-a0eeaee838b2
447	4	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	e062cd7e-5965-432f-89e4-7d30ea154e87
2149	2	\N	4	\N	\N	\N	TYPE_SUBMISSION	\N	5ee61fad-2de8-4f98-834b-c327dfed413c	\N	33a11e84-68c9-4e4c-8aba-53990a33f7ca
448	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	44560ab4-adc2-443e-a599-1a440bfc5c48
1677	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	1633cc84-63f4-4adf-986b-7da47de84bad
1678	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	1633cc84-63f4-4adf-986b-7da47de84bad
449	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	44560ab4-adc2-443e-a599-1a440bfc5c48
450	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	44560ab4-adc2-443e-a599-1a440bfc5c48
451	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	640da60a-12ee-48e4-90d5-9d3609e18051
1679	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	a1e46639-3086-442e-a8ea-efcc9193e674
2055	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	9dd6b47b-f9b5-47e0-8ad0-0012c5c9ef2f
452	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	640da60a-12ee-48e4-90d5-9d3609e18051
453	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	640da60a-12ee-48e4-90d5-9d3609e18051
454	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	8db9f9d0-d195-407a-923d-a0de4a20bfed
1680	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	a1e46639-3086-442e-a8ea-efcc9193e674
1681	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	a1e46639-3086-442e-a8ea-efcc9193e674
455	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	8db9f9d0-d195-407a-923d-a0de4a20bfed
456	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	8db9f9d0-d195-407a-923d-a0de4a20bfed
2056	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	1c7b63c0-8006-4d71-a70b-1a59ce3ba62f
457	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	85683df6-16a7-4ded-b5fd-74f04e3b8080
458	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	85683df6-16a7-4ded-b5fd-74f04e3b8080
459	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	85683df6-16a7-4ded-b5fd-74f04e3b8080
460	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	bdb6f30c-459c-48a3-ac6f-1a861a004953
461	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	bdb6f30c-459c-48a3-ac6f-1a861a004953
462	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	bdb6f30c-459c-48a3-ac6f-1a861a004953
463	4	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	f46e680e-8e04-426a-b055-c66c18163caa
464	4	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	12f102df-9e17-4bbd-8a46-6879014fd76b
465	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	ca5e06ab-e7d9-4963-8747-67003deb6b31
466	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	ca5e06ab-e7d9-4963-8747-67003deb6b31
467	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	ca5e06ab-e7d9-4963-8747-67003deb6b31
468	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	7e9ba303-9d53-4c40-90b9-4f68d86270f2
469	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	7e9ba303-9d53-4c40-90b9-4f68d86270f2
470	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	7e9ba303-9d53-4c40-90b9-4f68d86270f2
471	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	3f84afbc-9185-4a3f-b3c9-569c3e9da89b
472	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	3f84afbc-9185-4a3f-b3c9-569c3e9da89b
473	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	3f84afbc-9185-4a3f-b3c9-569c3e9da89b
474	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	0aa9ece4-f742-4c0a-8040-cdf4d8faf5b9
475	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	0aa9ece4-f742-4c0a-8040-cdf4d8faf5b9
476	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	0aa9ece4-f742-4c0a-8040-cdf4d8faf5b9
477	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	f597ed21-6f76-41b8-8c1d-57f763859fad
478	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	f597ed21-6f76-41b8-8c1d-57f763859fad
479	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	f597ed21-6f76-41b8-8c1d-57f763859fad
480	4	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	6ad2c279-e29e-402c-a09b-cadf0a19207f
481	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	9c532e18-a50a-4815-bbcc-a2e5d9c2b65f
496	4	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	a6dbaa98-ed1f-40f8-bdf9-8822d64a800d
2150	2	\N	2	\N	\N	\N	TYPE_SUBMISSION	\N	5ee61fad-2de8-4f98-834b-c327dfed413c	\N	33a11e84-68c9-4e4c-8aba-53990a33f7ca
482	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	9c532e18-a50a-4815-bbcc-a2e5d9c2b65f
483	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	9c532e18-a50a-4815-bbcc-a2e5d9c2b65f
484	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	105d0e1a-d561-459b-8322-0e985510883b
2058	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	2962c64d-2d70-40c7-99d0-c09489937317
485	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	105d0e1a-d561-459b-8322-0e985510883b
486	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	105d0e1a-d561-459b-8322-0e985510883b
487	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	130b1879-7c73-446f-95cb-dfa274fd8361
488	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	130b1879-7c73-446f-95cb-dfa274fd8361
489	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	130b1879-7c73-446f-95cb-dfa274fd8361
490	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	0de8081c-86c1-4318-96a2-61ff4a5eafd8
1004	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	7bba6efb-709f-4b4a-b666-654168314b1c
491	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	0de8081c-86c1-4318-96a2-61ff4a5eafd8
492	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	0de8081c-86c1-4318-96a2-61ff4a5eafd8
493	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	a12c7960-d301-433f-b967-55d86845070b
494	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	a12c7960-d301-433f-b967-55d86845070b
495	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	a12c7960-d301-433f-b967-55d86845070b
1007	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	539670a8-3427-4d5c-96ac-02b95f900003
497	4	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	2c944a82-e4a1-4d58-b31e-3c96236eb34d
498	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	3bbe59c8-460c-4879-bad9-50a6607ac8f0
499	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	3bbe59c8-460c-4879-bad9-50a6607ac8f0
500	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	3bbe59c8-460c-4879-bad9-50a6607ac8f0
501	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	6486917f-01cd-4e4d-b606-af71d92a14fa
1010	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	9709fcb3-1e1e-4825-89cf-6774de18420b
502	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	6486917f-01cd-4e4d-b606-af71d92a14fa
503	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	6486917f-01cd-4e4d-b606-af71d92a14fa
504	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	9f65562a-b18b-429c-892e-5740150f30ce
505	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	9f65562a-b18b-429c-892e-5740150f30ce
506	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	9f65562a-b18b-429c-892e-5740150f30ce
507	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	0e56849a-8a47-4e6a-a208-7af588a91310
1013	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	a63a3b39-a5c2-478d-b57b-c250553fa2e0
508	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	0e56849a-8a47-4e6a-a208-7af588a91310
509	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	0e56849a-8a47-4e6a-a208-7af588a91310
510	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	11c01b5a-3ef7-4298-a9da-18739a99fa62
1812	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	d450501d-bb9e-4ec6-9691-e27f33bba466
511	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	11c01b5a-3ef7-4298-a9da-18739a99fa62
512	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	11c01b5a-3ef7-4298-a9da-18739a99fa62
1813	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	75c62285-d1bb-4897-a31f-230c5115c6c5
513	4	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	ae79c603-8cb2-40f8-9d07-c69363f0039a
514	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	9bc40373-4a2a-46ff-847c-714cb460e549
1814	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	1b6078c0-fb54-4ff6-b526-890bb95184a1
515	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	9bc40373-4a2a-46ff-847c-714cb460e549
516	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	9bc40373-4a2a-46ff-847c-714cb460e549
1815	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	6a68fb46-a034-4129-b96e-b8d5209945cb
517	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	0ebec10d-4478-49ab-93f9-154d33b27b48
2501	2	\N	0	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	4bfa33a5-6844-4768-a282-9dac09cd5770
1816	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	d889cbef-ad65-49c8-a2e7-835a8262d9bc
518	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	0ebec10d-4478-49ab-93f9-154d33b27b48
519	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	0ebec10d-4478-49ab-93f9-154d33b27b48
520	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	bccab95d-41a0-417f-8c60-c4930d2ee64b
2502	2	\N	1	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	4bfa33a5-6844-4768-a282-9dac09cd5770
521	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	bccab95d-41a0-417f-8c60-c4930d2ee64b
522	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	bccab95d-41a0-417f-8c60-c4930d2ee64b
2503	2	\N	3	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	4bfa33a5-6844-4768-a282-9dac09cd5770
523	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	de089951-60b0-4a0f-96f0-808a6dbdee71
2504	2	\N	4	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	4bfa33a5-6844-4768-a282-9dac09cd5770
524	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	de089951-60b0-4a0f-96f0-808a6dbdee71
525	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	de089951-60b0-4a0f-96f0-808a6dbdee71
526	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	9945f686-7847-4d78-9b8c-154e2a2bb296
2505	2	\N	2	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	4bfa33a5-6844-4768-a282-9dac09cd5770
527	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	9945f686-7847-4d78-9b8c-154e2a2bb296
528	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	9945f686-7847-4d78-9b8c-154e2a2bb296
2506	2	\N	0	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	a0c1ee92-b2b4-4f58-adae-4a8101e93aa7
529	4	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	0a540eac-23c0-4dca-9943-d006688c005b
530	4	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	1b9b305d-dc05-42d2-b4b1-47e95b8cc167
2507	2	\N	1	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	a0c1ee92-b2b4-4f58-adae-4a8101e93aa7
531	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	2b0ca2ad-7e28-4a9c-b0a3-63b4f4b5f427
2508	2	\N	3	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	a0c1ee92-b2b4-4f58-adae-4a8101e93aa7
532	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	2b0ca2ad-7e28-4a9c-b0a3-63b4f4b5f427
533	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	2b0ca2ad-7e28-4a9c-b0a3-63b4f4b5f427
534	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	c63831fc-1419-470b-8f44-bdf13b06618c
2509	2	\N	4	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	a0c1ee92-b2b4-4f58-adae-4a8101e93aa7
535	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	c63831fc-1419-470b-8f44-bdf13b06618c
536	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	c63831fc-1419-470b-8f44-bdf13b06618c
2510	2	\N	2	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	a0c1ee92-b2b4-4f58-adae-4a8101e93aa7
537	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	e0cb29a5-a7e7-4183-a647-59027c0c8c2e
2511	2	\N	0	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	6435afc7-5bfc-43d1-a557-286efaaf8ed4
538	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	e0cb29a5-a7e7-4183-a647-59027c0c8c2e
539	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	e0cb29a5-a7e7-4183-a647-59027c0c8c2e
540	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	21f3514c-8861-4b5f-ac3f-d4b88441adcc
2512	2	\N	1	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	6435afc7-5bfc-43d1-a557-286efaaf8ed4
2513	2	\N	3	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	6435afc7-5bfc-43d1-a557-286efaaf8ed4
2514	2	\N	4	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	6435afc7-5bfc-43d1-a557-286efaaf8ed4
2515	2	\N	2	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	6435afc7-5bfc-43d1-a557-286efaaf8ed4
2618	2	\N	3	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	e21ca461-7f92-4cc7-8b99-9779c76e351a
2619	2	\N	4	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	e21ca461-7f92-4cc7-8b99-9779c76e351a
1933	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	ed4b6780-5f7d-429f-beab-eb44e6170bc9
541	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	21f3514c-8861-4b5f-ac3f-d4b88441adcc
542	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	21f3514c-8861-4b5f-ac3f-d4b88441adcc
543	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	95824968-09b5-45c3-a5ff-f6c8fad3cba5
1934	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	ad33886e-87fb-4206-a2de-6feb2995e006
2516	2	\N	0	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	e15414f8-b998-4844-a3e6-fd616616a97d
544	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	95824968-09b5-45c3-a5ff-f6c8fad3cba5
545	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	95824968-09b5-45c3-a5ff-f6c8fad3cba5
1935	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	e67500f7-2f48-4894-816e-bd8d52c46382
546	4	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	f43b5db9-d9fe-4f67-b1df-48dd4cf237af
2381	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	f332b151-98c1-4e28-b87e-bed0d9bf17e8
547	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	76a4baa0-c312-47de-abd8-38d342f5648a
2382	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	d755ed7e-018c-4209-ae5c-a485a3172ccb
548	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	76a4baa0-c312-47de-abd8-38d342f5648a
549	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	76a4baa0-c312-47de-abd8-38d342f5648a
2517	2	\N	1	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	e15414f8-b998-4844-a3e6-fd616616a97d
550	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	433ec679-855f-4e2e-8302-b485271cd68f
2383	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	20138169-8e01-4926-aeae-04135b3706eb
551	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	433ec679-855f-4e2e-8302-b485271cd68f
552	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	433ec679-855f-4e2e-8302-b485271cd68f
2518	2	\N	3	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	e15414f8-b998-4844-a3e6-fd616616a97d
553	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	86ccc8a7-5a8e-468d-b03c-4ce0436bc4dd
2519	2	\N	4	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	e15414f8-b998-4844-a3e6-fd616616a97d
554	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	86ccc8a7-5a8e-468d-b03c-4ce0436bc4dd
555	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	86ccc8a7-5a8e-468d-b03c-4ce0436bc4dd
556	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	7cf1f5ae-d764-4d10-904d-1d8052283126
2520	2	\N	2	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	e15414f8-b998-4844-a3e6-fd616616a97d
557	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	7cf1f5ae-d764-4d10-904d-1d8052283126
558	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	7cf1f5ae-d764-4d10-904d-1d8052283126
2521	2	\N	0	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	a9e375db-ed27-49a4-ab37-1f71e3344c07
559	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	1a948c76-f0c1-42ea-8a98-090bb3c0e952
2266	2	\N	0	\N	\N	\N	TYPE_SUBMISSION	\N	cd410caa-8ed0-4822-8722-8eab234a8b4c	\N	1948e980-ac90-4c67-9d57-375b10c0978a
560	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	1a948c76-f0c1-42ea-8a98-090bb3c0e952
561	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	1a948c76-f0c1-42ea-8a98-090bb3c0e952
2522	2	\N	1	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	a9e375db-ed27-49a4-ab37-1f71e3344c07
562	4	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	f090f032-d9d9-4ec2-9490-16e3db96212b
2267	2	\N	1	\N	\N	\N	TYPE_SUBMISSION	\N	cd410caa-8ed0-4822-8722-8eab234a8b4c	\N	1948e980-ac90-4c67-9d57-375b10c0978a
563	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	30edbd28-6241-4876-ae87-818171fb29ea
2268	2	\N	3	\N	\N	\N	TYPE_SUBMISSION	\N	cd410caa-8ed0-4822-8722-8eab234a8b4c	\N	1948e980-ac90-4c67-9d57-375b10c0978a
564	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	30edbd28-6241-4876-ae87-818171fb29ea
565	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	30edbd28-6241-4876-ae87-818171fb29ea
2523	2	\N	3	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	a9e375db-ed27-49a4-ab37-1f71e3344c07
566	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	0bfb3ac9-90de-4934-b39b-178edde5c7ef
2269	2	\N	4	\N	\N	\N	TYPE_SUBMISSION	\N	cd410caa-8ed0-4822-8722-8eab234a8b4c	\N	1948e980-ac90-4c67-9d57-375b10c0978a
567	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	0bfb3ac9-90de-4934-b39b-178edde5c7ef
568	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	0bfb3ac9-90de-4934-b39b-178edde5c7ef
2270	2	\N	2	\N	\N	\N	TYPE_SUBMISSION	\N	cd410caa-8ed0-4822-8722-8eab234a8b4c	\N	1948e980-ac90-4c67-9d57-375b10c0978a
569	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	5b79fd4a-7656-4ddd-8860-b292b48350e6
2524	2	\N	4	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	a9e375db-ed27-49a4-ab37-1f71e3344c07
570	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	5b79fd4a-7656-4ddd-8860-b292b48350e6
571	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	5b79fd4a-7656-4ddd-8860-b292b48350e6
2525	2	\N	2	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	a9e375db-ed27-49a4-ab37-1f71e3344c07
572	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	6ce04d42-1a73-46e1-b145-4f43f004cd70
573	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	6ce04d42-1a73-46e1-b145-4f43f004cd70
574	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	6ce04d42-1a73-46e1-b145-4f43f004cd70
575	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	73c5e039-5fd5-45ca-8b42-e46dfc33d06c
576	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	73c5e039-5fd5-45ca-8b42-e46dfc33d06c
577	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	73c5e039-5fd5-45ca-8b42-e46dfc33d06c
578	4	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	ef9c52da-c800-4fb6-8ecb-6851e26a2794
579	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	5d2a1df2-7371-435c-b241-b3c9539b6049
580	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	5d2a1df2-7371-435c-b241-b3c9539b6049
581	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	5d2a1df2-7371-435c-b241-b3c9539b6049
582	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	c60c6dbc-67c4-42e9-adaf-acc0c82822ac
2620	2	\N	2	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	e21ca461-7f92-4cc7-8b99-9779c76e351a
583	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	c60c6dbc-67c4-42e9-adaf-acc0c82822ac
584	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	c60c6dbc-67c4-42e9-adaf-acc0c82822ac
2621	2	\N	0	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	534ec073-e464-4149-bf28-5cf8ad4baa5d
585	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	0ce316b3-41f3-4a74-8bfc-e0ee3cfe4000
2622	2	\N	1	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	534ec073-e464-4149-bf28-5cf8ad4baa5d
586	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	0ce316b3-41f3-4a74-8bfc-e0ee3cfe4000
587	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	0ce316b3-41f3-4a74-8bfc-e0ee3cfe4000
588	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	36ea01fe-9920-424a-a9bb-b5de23ec2c7d
2623	2	\N	3	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	534ec073-e464-4149-bf28-5cf8ad4baa5d
589	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	36ea01fe-9920-424a-a9bb-b5de23ec2c7d
590	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	36ea01fe-9920-424a-a9bb-b5de23ec2c7d
2624	2	\N	4	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	534ec073-e464-4149-bf28-5cf8ad4baa5d
591	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	1652f904-9088-4fa5-bd63-9ff1e6efcf97
2625	2	\N	2	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	534ec073-e464-4149-bf28-5cf8ad4baa5d
592	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	1652f904-9088-4fa5-bd63-9ff1e6efcf97
593	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	1652f904-9088-4fa5-bd63-9ff1e6efcf97
594	4	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	1b279197-328f-4ff1-a8a3-60e842b4d099
2626	2	\N	0	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	428163a7-e57d-4b39-a5b8-9fd69dc65567
595	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	bf95d0b0-a562-4c96-9252-5b2ed9bcfb64
2627	2	\N	1	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	428163a7-e57d-4b39-a5b8-9fd69dc65567
596	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	bf95d0b0-a562-4c96-9252-5b2ed9bcfb64
597	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	bf95d0b0-a562-4c96-9252-5b2ed9bcfb64
598	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	7001f4bb-55d0-4a1f-bde5-e514920a429b
599	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	7001f4bb-55d0-4a1f-bde5-e514920a429b
600	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	7001f4bb-55d0-4a1f-bde5-e514920a429b
601	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	9edbbc8c-bc1b-42ba-8914-1d9e9db2347f
658	4	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	04ae4009-f11b-486e-929a-2512280f4227
602	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	9edbbc8c-bc1b-42ba-8914-1d9e9db2347f
603	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	9edbbc8c-bc1b-42ba-8914-1d9e9db2347f
604	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	85429d43-9926-4439-8704-20e18bb5679b
605	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	85429d43-9926-4439-8704-20e18bb5679b
606	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	85429d43-9926-4439-8704-20e18bb5679b
607	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	dc0136e1-f792-4aac-a8ea-16e09675995c
608	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	dc0136e1-f792-4aac-a8ea-16e09675995c
609	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	dc0136e1-f792-4aac-a8ea-16e09675995c
610	4	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	8d8d2fbb-cae3-4073-a46d-d4e01d204cad
611	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	ef8e7e2c-eeeb-439d-b7f9-ade465fc4f68
612	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	ef8e7e2c-eeeb-439d-b7f9-ade465fc4f68
613	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	ef8e7e2c-eeeb-439d-b7f9-ade465fc4f68
2536	2	\N	0	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	d97e2d78-7a2c-413d-9749-2c004d3f95a9
614	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	79300c61-6d47-405d-9a9a-d1e8f0204305
2537	2	\N	1	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	d97e2d78-7a2c-413d-9749-2c004d3f95a9
615	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	79300c61-6d47-405d-9a9a-d1e8f0204305
616	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	79300c61-6d47-405d-9a9a-d1e8f0204305
617	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	9e61e347-ce40-43c5-a332-f5683442b1fa
2538	2	\N	3	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	d97e2d78-7a2c-413d-9749-2c004d3f95a9
618	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	9e61e347-ce40-43c5-a332-f5683442b1fa
619	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	9e61e347-ce40-43c5-a332-f5683442b1fa
2539	2	\N	4	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	d97e2d78-7a2c-413d-9749-2c004d3f95a9
620	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	d3672c54-1ef2-471a-ba24-239a3990fc75
2540	2	\N	2	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	d97e2d78-7a2c-413d-9749-2c004d3f95a9
621	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	d3672c54-1ef2-471a-ba24-239a3990fc75
622	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	d3672c54-1ef2-471a-ba24-239a3990fc75
623	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	ef53ffdb-0f3a-492e-874c-fcd8fba11d06
2541	2	\N	0	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	7a3e90a0-98d3-431e-9432-1ede8f95757f
624	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	ef53ffdb-0f3a-492e-874c-fcd8fba11d06
625	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	ef53ffdb-0f3a-492e-874c-fcd8fba11d06
2542	2	\N	1	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	7a3e90a0-98d3-431e-9432-1ede8f95757f
626	4	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	a14ae54e-0797-4324-8b82-9846be3aa9fd
627	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	01712afa-c526-4f73-94ae-02734ce15c96
2176	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	3bc2d4e3-6c4f-4e12-98c7-89b38012246f
2543	2	\N	3	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	7a3e90a0-98d3-431e-9432-1ede8f95757f
628	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	01712afa-c526-4f73-94ae-02734ce15c96
629	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	01712afa-c526-4f73-94ae-02734ce15c96
2177	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	fe7ea1de-7497-4d64-93b5-a6b56d21eee8
630	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	9b63b2f1-f8e9-42f3-8d4f-a49a3f16e914
2178	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	73328566-b3cc-4516-a70f-3d7fe821151b
631	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	9b63b2f1-f8e9-42f3-8d4f-a49a3f16e914
632	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	9b63b2f1-f8e9-42f3-8d4f-a49a3f16e914
2544	2	\N	4	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	7a3e90a0-98d3-431e-9432-1ede8f95757f
633	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	c23dcaad-e9fa-4c6b-8d86-4fd2f3c125e9
2179	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	5bfb5579-17ed-4113-b850-5d52fe90f1f7
634	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	c23dcaad-e9fa-4c6b-8d86-4fd2f3c125e9
635	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	c23dcaad-e9fa-4c6b-8d86-4fd2f3c125e9
2180	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	cf9c4758-a326-4605-b96c-86f858c213c6
636	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	5e78e0bf-da34-4c8b-ab86-2a6b9f8d63a8
2545	2	\N	2	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	7a3e90a0-98d3-431e-9432-1ede8f95757f
2276	2	\N	0	\N	\N	\N	TYPE_SUBMISSION	\N	cd410caa-8ed0-4822-8722-8eab234a8b4c	\N	fd7979d1-2f9d-43c1-921b-16286ad57b19
637	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	5e78e0bf-da34-4c8b-ab86-2a6b9f8d63a8
638	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	5e78e0bf-da34-4c8b-ab86-2a6b9f8d63a8
639	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	127e289a-cced-4934-91ee-0bd505946855
2277	2	\N	1	\N	\N	\N	TYPE_SUBMISSION	\N	cd410caa-8ed0-4822-8722-8eab234a8b4c	\N	fd7979d1-2f9d-43c1-921b-16286ad57b19
2546	2	\N	0	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	65aff6e2-e01f-4ea7-b76a-854578347fce
640	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	127e289a-cced-4934-91ee-0bd505946855
641	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	127e289a-cced-4934-91ee-0bd505946855
2278	2	\N	3	\N	\N	\N	TYPE_SUBMISSION	\N	cd410caa-8ed0-4822-8722-8eab234a8b4c	\N	fd7979d1-2f9d-43c1-921b-16286ad57b19
642	4	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	f1e4428f-78dc-4c65-93b0-a5fd4a291f23
643	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	a4c357bb-03ad-445b-b073-d6c5a8a9ce33
2279	2	\N	4	\N	\N	\N	TYPE_SUBMISSION	\N	cd410caa-8ed0-4822-8722-8eab234a8b4c	\N	fd7979d1-2f9d-43c1-921b-16286ad57b19
2547	2	\N	1	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	65aff6e2-e01f-4ea7-b76a-854578347fce
644	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	a4c357bb-03ad-445b-b073-d6c5a8a9ce33
645	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	a4c357bb-03ad-445b-b073-d6c5a8a9ce33
2280	2	\N	2	\N	\N	\N	TYPE_SUBMISSION	\N	cd410caa-8ed0-4822-8722-8eab234a8b4c	\N	fd7979d1-2f9d-43c1-921b-16286ad57b19
646	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	96931619-4af6-4562-9d21-45a09a3a369f
2548	2	\N	3	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	65aff6e2-e01f-4ea7-b76a-854578347fce
647	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	96931619-4af6-4562-9d21-45a09a3a369f
648	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	96931619-4af6-4562-9d21-45a09a3a369f
649	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	35210960-6f4c-4dde-9ee3-063f923c3dc3
2549	2	\N	4	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	65aff6e2-e01f-4ea7-b76a-854578347fce
650	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	35210960-6f4c-4dde-9ee3-063f923c3dc3
651	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	35210960-6f4c-4dde-9ee3-063f923c3dc3
2550	2	\N	2	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	65aff6e2-e01f-4ea7-b76a-854578347fce
652	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	631514ab-cb74-4a79-a03d-ea3e718ee702
2551	2	\N	0	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	7f9c8b1b-3a70-4b8b-8900-c6d095e1db00
653	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	631514ab-cb74-4a79-a03d-ea3e718ee702
654	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	631514ab-cb74-4a79-a03d-ea3e718ee702
655	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	a5f66249-7b4d-4084-a7b2-76a4ce0f2483
2552	2	\N	1	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	7f9c8b1b-3a70-4b8b-8900-c6d095e1db00
656	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	a5f66249-7b4d-4084-a7b2-76a4ce0f2483
657	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	a5f66249-7b4d-4084-a7b2-76a4ce0f2483
2553	2	\N	3	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	7f9c8b1b-3a70-4b8b-8900-c6d095e1db00
659	4	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	7482f96f-4d1c-42ef-935b-afa2a5bc1045
660	4	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	86b6a785-abca-429f-991c-d473d49502ee
661	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	9ac23e05-d27e-4732-83a1-dc07ce94c3e5
1171	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	28f1a24a-b6ea-4b76-bba7-6779f81b14fe
2554	2	\N	4	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	7f9c8b1b-3a70-4b8b-8900-c6d095e1db00
662	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	9ac23e05-d27e-4732-83a1-dc07ce94c3e5
663	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	9ac23e05-d27e-4732-83a1-dc07ce94c3e5
2181	2	\N	0	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	d2550a87-9f59-4d60-aca3-bd9b955bfa4d
664	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	47b9440a-6769-4287-b4e7-a9a79fbf4fdc
2399	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	e85ea3c1-9d09-4c0e-aaa8-33aca608cbb5
2182	2	\N	1	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	d2550a87-9f59-4d60-aca3-bd9b955bfa4d
665	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	47b9440a-6769-4287-b4e7-a9a79fbf4fdc
666	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	47b9440a-6769-4287-b4e7-a9a79fbf4fdc
667	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	c545077e-d983-473a-b621-d0213869b06d
2183	2	\N	3	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	d2550a87-9f59-4d60-aca3-bd9b955bfa4d
2400	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	c05c05d3-d9ac-4896-8ed1-46ac985ae51c
668	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	c545077e-d983-473a-b621-d0213869b06d
669	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	c545077e-d983-473a-b621-d0213869b06d
2184	2	\N	4	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	d2550a87-9f59-4d60-aca3-bd9b955bfa4d
670	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	40951858-8246-4cb1-b095-0d20303ca115
2555	2	\N	2	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	7f9c8b1b-3a70-4b8b-8900-c6d095e1db00
2185	2	\N	2	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	d2550a87-9f59-4d60-aca3-bd9b955bfa4d
671	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	40951858-8246-4cb1-b095-0d20303ca115
672	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	40951858-8246-4cb1-b095-0d20303ca115
2401	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	e61f61ed-6bf9-4e74-91be-f0bdf50bc671
673	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	7eaed4ff-162a-430f-8a35-1acdd53bc884
2186	2	\N	0	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	7612424e-b29d-4a55-b8de-61f3ac6bfb59
674	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	7eaed4ff-162a-430f-8a35-1acdd53bc884
675	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	7eaed4ff-162a-430f-8a35-1acdd53bc884
2187	2	\N	1	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	7612424e-b29d-4a55-b8de-61f3ac6bfb59
676	4	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	3d6690d8-eadd-46a6-8fea-73dbcdd3ec66
677	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	8b6e660f-2253-4b81-9b42-a065a6964f56
2188	2	\N	3	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	7612424e-b29d-4a55-b8de-61f3ac6bfb59
2556	2	\N	0	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	f1228c2e-1e8e-4e61-b4ce-a569f98cc534
678	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	8b6e660f-2253-4b81-9b42-a065a6964f56
679	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	8b6e660f-2253-4b81-9b42-a065a6964f56
2189	2	\N	4	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	7612424e-b29d-4a55-b8de-61f3ac6bfb59
680	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	51fde179-1543-41de-9206-eaa3c75f9b59
2190	2	\N	2	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	7612424e-b29d-4a55-b8de-61f3ac6bfb59
681	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	51fde179-1543-41de-9206-eaa3c75f9b59
682	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	51fde179-1543-41de-9206-eaa3c75f9b59
683	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	05915171-100e-4d10-89e4-c872711de1aa
2557	2	\N	1	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	f1228c2e-1e8e-4e61-b4ce-a569f98cc534
684	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	05915171-100e-4d10-89e4-c872711de1aa
685	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	05915171-100e-4d10-89e4-c872711de1aa
686	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	c66b4475-75d3-4d34-b33a-87077ac6bdab
687	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	c66b4475-75d3-4d34-b33a-87077ac6bdab
688	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	c66b4475-75d3-4d34-b33a-87077ac6bdab
2558	2	\N	3	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	f1228c2e-1e8e-4e61-b4ce-a569f98cc534
689	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	22e0168a-c2a8-4e0b-85ec-a8d88eafa46e
2559	2	\N	4	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	f1228c2e-1e8e-4e61-b4ce-a569f98cc534
690	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	22e0168a-c2a8-4e0b-85ec-a8d88eafa46e
691	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	22e0168a-c2a8-4e0b-85ec-a8d88eafa46e
692	4	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	7e294bf6-2eec-49aa-9d8f-a6d4a2cc498b
2560	2	\N	2	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	f1228c2e-1e8e-4e61-b4ce-a569f98cc534
693	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	10b5d9e1-b62d-4c93-ba9c-d5a258b6f2c3
2561	2	\N	0	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	b4c46f03-496f-42a2-98f7-6739e324de11
694	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	10b5d9e1-b62d-4c93-ba9c-d5a258b6f2c3
695	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	10b5d9e1-b62d-4c93-ba9c-d5a258b6f2c3
696	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	f98570e1-e406-4857-9e8d-90c97ea8b7eb
2562	2	\N	1	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	b4c46f03-496f-42a2-98f7-6739e324de11
697	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	f98570e1-e406-4857-9e8d-90c97ea8b7eb
698	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	f98570e1-e406-4857-9e8d-90c97ea8b7eb
2563	2	\N	3	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	b4c46f03-496f-42a2-98f7-6739e324de11
699	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	e6c49376-930b-4689-9111-51386ff65eb8
2564	2	\N	4	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	b4c46f03-496f-42a2-98f7-6739e324de11
700	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	e6c49376-930b-4689-9111-51386ff65eb8
701	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	e6c49376-930b-4689-9111-51386ff65eb8
702	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	6e7329c4-fbf0-4c06-aed1-f57996b0dc02
703	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	6e7329c4-fbf0-4c06-aed1-f57996b0dc02
704	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	6e7329c4-fbf0-4c06-aed1-f57996b0dc02
1172	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	93182026-e06b-4654-950f-39cc4aa0180f
705	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	ecb7bd93-4a76-4895-af27-8033ffb4b9ee
1961	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	b683a946-16af-4acd-a050-17decd4bd085
1173	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	a5bae5f3-528a-48f5-9a62-1d9f45445a95
706	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	ecb7bd93-4a76-4895-af27-8033ffb4b9ee
707	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	ecb7bd93-4a76-4895-af27-8033ffb4b9ee
708	4	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	508fd417-903e-485c-8a79-1d47fecf89ec
709	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	86b7a281-7358-4bd0-be35-d7b13d3a54d7
710	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	86b7a281-7358-4bd0-be35-d7b13d3a54d7
711	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	86b7a281-7358-4bd0-be35-d7b13d3a54d7
712	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	c0727846-37aa-424a-a8b6-776f29a6b11c
713	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	c0727846-37aa-424a-a8b6-776f29a6b11c
714	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	c0727846-37aa-424a-a8b6-776f29a6b11c
715	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	69b38b68-43bc-4d73-9de6-7252271f950c
716	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	69b38b68-43bc-4d73-9de6-7252271f950c
717	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	69b38b68-43bc-4d73-9de6-7252271f950c
718	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	b20c5473-4f4b-4af4-b0ac-f25f63c15091
719	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	b20c5473-4f4b-4af4-b0ac-f25f63c15091
720	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	b20c5473-4f4b-4af4-b0ac-f25f63c15091
721	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	80e08532-d009-40b6-b60b-01ad848f29e7
1174	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	1f55e71a-6121-4374-baf3-3f6e8881131a
1962	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	4658a0b2-50e4-444a-b4ac-e4d6d7aa559c
722	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	80e08532-d009-40b6-b60b-01ad848f29e7
723	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	80e08532-d009-40b6-b60b-01ad848f29e7
1175	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	a15549c9-dd49-4ae1-a01b-5506f097c6ca
724	4	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	70a9c7ec-c890-4cb2-9978-47493f08fa8f
725	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	dd80f6f0-c10b-4172-a531-716f9dd1c230
1963	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	e5e4b3e2-45fe-4ff9-8766-bee1f235ad36
2191	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	a761698f-3924-4e7d-9219-37f93670fdf0
726	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	dd80f6f0-c10b-4172-a531-716f9dd1c230
727	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	dd80f6f0-c10b-4172-a531-716f9dd1c230
1964	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	dbcfe7c2-b2ab-4cef-a7e2-1574b7387410
728	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	98b7684c-bcff-4679-89a6-c6f0d23f0540
2565	2	\N	2	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	b4c46f03-496f-42a2-98f7-6739e324de11
1965	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	8a5f262f-0da7-41bc-82ad-8f7eb1609617
729	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	98b7684c-bcff-4679-89a6-c6f0d23f0540
730	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	98b7684c-bcff-4679-89a6-c6f0d23f0540
731	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	e70c5835-3e0c-4681-b682-089b156bdd3c
2566	2	\N	0	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	fec6cee0-40ae-40ab-8b42-b2adf77d55a4
2193	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	b0828ac7-d229-4f84-ae1b-77d8a212c0ff
732	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	e70c5835-3e0c-4681-b682-089b156bdd3c
733	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	e70c5835-3e0c-4681-b682-089b156bdd3c
734	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	55dcf71d-31cb-43c0-b001-288d404c3890
2194	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	22be2e2a-2cf2-4956-a75f-bb4ff2c756b9
735	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	55dcf71d-31cb-43c0-b001-288d404c3890
736	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	55dcf71d-31cb-43c0-b001-288d404c3890
1561	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	b1c7cc22-a459-4f55-99cc-98fc7e9829cd
737	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	58713621-70cd-4c5e-9341-28b32ba41fb9
2567	2	\N	1	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	fec6cee0-40ae-40ab-8b42-b2adf77d55a4
738	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	58713621-70cd-4c5e-9341-28b32ba41fb9
739	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	58713621-70cd-4c5e-9341-28b32ba41fb9
2568	2	\N	3	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	fec6cee0-40ae-40ab-8b42-b2adf77d55a4
740	4	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	9d0dccbc-1024-4802-993c-933cb6cdc260
2196	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	d129fd45-13f2-414f-a2a3-cb8c153c2c08
741	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	1807e1c8-fe69-44f0-99f5-5543862721dd
2569	2	\N	4	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	fec6cee0-40ae-40ab-8b42-b2adf77d55a4
742	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	1807e1c8-fe69-44f0-99f5-5543862721dd
743	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	1807e1c8-fe69-44f0-99f5-5543862721dd
744	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	3021c2ed-dea4-4b82-a0e4-147c790655fd
2570	2	\N	2	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	fec6cee0-40ae-40ab-8b42-b2adf77d55a4
745	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	3021c2ed-dea4-4b82-a0e4-147c790655fd
746	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	3021c2ed-dea4-4b82-a0e4-147c790655fd
2628	2	\N	3	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	428163a7-e57d-4b39-a5b8-9fd69dc65567
747	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	778fbe77-519d-43cf-8e5f-b7524f22be6d
2629	2	\N	4	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	428163a7-e57d-4b39-a5b8-9fd69dc65567
748	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	778fbe77-519d-43cf-8e5f-b7524f22be6d
749	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	778fbe77-519d-43cf-8e5f-b7524f22be6d
2422	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	1386b2cc-40f2-4213-a6d2-8d3ab04ba6bc
750	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	a3760f39-a4f7-494b-98ef-ca6264671474
2423	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	edc044e1-bae6-4e22-b2a6-5ac50f8576c6
751	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	a3760f39-a4f7-494b-98ef-ca6264671474
752	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	a3760f39-a4f7-494b-98ef-ca6264671474
2630	2	\N	2	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	428163a7-e57d-4b39-a5b8-9fd69dc65567
753	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	739c1d61-b1fb-4f93-8a6f-a20d3910c4a0
2424	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	c9cd3978-6216-4983-b67e-5d697ec20b81
754	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	739c1d61-b1fb-4f93-8a6f-a20d3910c4a0
755	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	739c1d61-b1fb-4f93-8a6f-a20d3910c4a0
756	4	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	786d3d1a-1946-4dd0-817b-dab8b0dfa161
757	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	c82c39e8-1b65-4647-90af-d2e6fc0e80a4
758	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	c82c39e8-1b65-4647-90af-d2e6fc0e80a4
759	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	c82c39e8-1b65-4647-90af-d2e6fc0e80a4
760	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	628a887f-5405-49b5-a113-8da165007f80
761	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	628a887f-5405-49b5-a113-8da165007f80
762	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	628a887f-5405-49b5-a113-8da165007f80
763	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	62ecff54-d3ad-4590-9773-f7a975437ddf
764	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	62ecff54-d3ad-4590-9773-f7a975437ddf
765	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	62ecff54-d3ad-4590-9773-f7a975437ddf
766	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	63af20f3-0299-4b5b-8c39-e1343f9f944b
767	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	63af20f3-0299-4b5b-8c39-e1343f9f944b
768	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	63af20f3-0299-4b5b-8c39-e1343f9f944b
769	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	cedd3c7e-baf0-471f-9044-b43cca83af23
770	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	cedd3c7e-baf0-471f-9044-b43cca83af23
771	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	cedd3c7e-baf0-471f-9044-b43cca83af23
772	4	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	12188074-fdf3-41c4-96c8-fdd2d1cee710
773	4	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	bc548182-4db3-4087-a94d-d059f9f386e4
774	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	07045af3-ed80-4990-a660-6282fe0fe4fb
775	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	07045af3-ed80-4990-a660-6282fe0fe4fb
776	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	07045af3-ed80-4990-a660-6282fe0fe4fb
777	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	f5f06691-69b5-4979-aee5-1c940a3a17b3
778	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	f5f06691-69b5-4979-aee5-1c940a3a17b3
779	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	f5f06691-69b5-4979-aee5-1c940a3a17b3
780	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	33f44877-bc89-4386-aca3-ef3a4946d305
781	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	33f44877-bc89-4386-aca3-ef3a4946d305
782	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	33f44877-bc89-4386-aca3-ef3a4946d305
2197	2	\N	0	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	54274d99-b0a7-41f5-bfbb-321d3e01d787
783	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	bdf997dd-df12-480a-ae52-8950beded503
2571	2	\N	0	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	61cec1fe-92dd-4e5f-8cb0-cd838ac093f0
2198	2	\N	1	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	54274d99-b0a7-41f5-bfbb-321d3e01d787
784	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	bdf997dd-df12-480a-ae52-8950beded503
785	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	bdf997dd-df12-480a-ae52-8950beded503
786	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	2319137c-c5cc-4ea5-9de7-50713a7f88c4
2199	2	\N	3	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	54274d99-b0a7-41f5-bfbb-321d3e01d787
2572	2	\N	1	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	61cec1fe-92dd-4e5f-8cb0-cd838ac093f0
787	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	2319137c-c5cc-4ea5-9de7-50713a7f88c4
788	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	2319137c-c5cc-4ea5-9de7-50713a7f88c4
2200	2	\N	4	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	54274d99-b0a7-41f5-bfbb-321d3e01d787
789	4	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	803bc41a-3cf3-4f5a-b888-26b61a5ba929
1564	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	b46e66b6-fef8-4551-844b-f48b51f18887
790	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	d42ed59c-0c22-4b9b-bebf-118132eeb353
2201	2	\N	2	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	54274d99-b0a7-41f5-bfbb-321d3e01d787
791	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	d42ed59c-0c22-4b9b-bebf-118132eeb353
792	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	d42ed59c-0c22-4b9b-bebf-118132eeb353
2573	2	\N	3	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	61cec1fe-92dd-4e5f-8cb0-cd838ac093f0
793	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	3da18c61-9632-4a05-9962-27590f23772d
1565	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	9df5ca2c-3147-401a-9d3c-1638a6f02ad0
794	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	3da18c61-9632-4a05-9962-27590f23772d
795	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	3da18c61-9632-4a05-9962-27590f23772d
2574	2	\N	4	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	61cec1fe-92dd-4e5f-8cb0-cd838ac093f0
796	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	8a758888-6213-4881-9b2b-690336684fa7
2575	2	\N	2	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	61cec1fe-92dd-4e5f-8cb0-cd838ac093f0
797	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	8a758888-6213-4881-9b2b-690336684fa7
798	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	8a758888-6213-4881-9b2b-690336684fa7
799	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	3f987ebb-99ce-497d-81e3-5dc76547cc98
2576	2	\N	0	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	d7ff7622-8d60-4892-9132-d44c6321e8a6
800	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	3f987ebb-99ce-497d-81e3-5dc76547cc98
801	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	3f987ebb-99ce-497d-81e3-5dc76547cc98
2577	2	\N	1	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	d7ff7622-8d60-4892-9132-d44c6321e8a6
802	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	0f76ce1d-7218-4ff1-848a-af873e4033b3
2578	2	\N	3	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	d7ff7622-8d60-4892-9132-d44c6321e8a6
803	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	0f76ce1d-7218-4ff1-848a-af873e4033b3
804	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	0f76ce1d-7218-4ff1-848a-af873e4033b3
805	4	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	214d281b-6762-46e2-a6a1-98d270cbf4bb
2579	2	\N	4	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	d7ff7622-8d60-4892-9132-d44c6321e8a6
806	4	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	9f71cf2b-168c-4efe-844e-afe0e670ccbf
807	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	924a0f97-19fa-46d9-8720-b3203cbb4ad3
2580	2	\N	2	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	d7ff7622-8d60-4892-9132-d44c6321e8a6
808	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	924a0f97-19fa-46d9-8720-b3203cbb4ad3
809	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	924a0f97-19fa-46d9-8720-b3203cbb4ad3
2581	2	\N	0	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	7009fa9d-a02c-4910-a62f-5c3f2b8f28a2
810	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	0f289146-ce3b-42a6-b59e-3f159bb3e6f7
2582	2	\N	1	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	7009fa9d-a02c-4910-a62f-5c3f2b8f28a2
811	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	0f289146-ce3b-42a6-b59e-3f159bb3e6f7
812	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	0f289146-ce3b-42a6-b59e-3f159bb3e6f7
813	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	b58ca63f-f2e7-411e-a5da-fe0857ba17d7
2583	2	\N	3	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	7009fa9d-a02c-4910-a62f-5c3f2b8f28a2
814	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	b58ca63f-f2e7-411e-a5da-fe0857ba17d7
815	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	b58ca63f-f2e7-411e-a5da-fe0857ba17d7
2584	2	\N	4	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	7009fa9d-a02c-4910-a62f-5c3f2b8f28a2
816	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	a0562a18-237a-401a-9e61-99b48c4122dd
2585	2	\N	2	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	7009fa9d-a02c-4910-a62f-5c3f2b8f28a2
817	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	a0562a18-237a-401a-9e61-99b48c4122dd
818	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	a0562a18-237a-401a-9e61-99b48c4122dd
819	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	d6af0d41-100d-4f6d-9bca-da31efbef9b9
2440	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	87bf956f-41be-46d9-a741-f304c8165e94
820	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	d6af0d41-100d-4f6d-9bca-da31efbef9b9
821	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	d6af0d41-100d-4f6d-9bca-da31efbef9b9
2441	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	7e111fd6-e95d-46fa-8e6a-fc112f2c3468
822	4	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	305fba50-26ce-48e4-af27-4ea801b1ef30
2442	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	5bcae71d-2a79-4652-a04c-c9bf08923201
2636	2	\N	0	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	34cefcb9-0d95-4de6-938f-9217bcc9399b
2637	2	\N	1	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	34cefcb9-0d95-4de6-938f-9217bcc9399b
2638	2	\N	3	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	34cefcb9-0d95-4de6-938f-9217bcc9399b
2639	2	\N	4	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	34cefcb9-0d95-4de6-938f-9217bcc9399b
2640	2	\N	2	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	34cefcb9-0d95-4de6-938f-9217bcc9399b
2659	2	\N	0	\N	\N	\N	TYPE_SUBMISSION	\N	28194931-611a-42cc-89c7-b133dc63c893	\N	01abe899-e6b3-49d1-87b3-08a163471785
2660	2	\N	1	\N	\N	\N	TYPE_SUBMISSION	\N	28194931-611a-42cc-89c7-b133dc63c893	\N	01abe899-e6b3-49d1-87b3-08a163471785
2661	2	\N	3	\N	\N	\N	TYPE_SUBMISSION	\N	28194931-611a-42cc-89c7-b133dc63c893	\N	01abe899-e6b3-49d1-87b3-08a163471785
2662	2	\N	4	\N	\N	\N	TYPE_SUBMISSION	\N	28194931-611a-42cc-89c7-b133dc63c893	\N	01abe899-e6b3-49d1-87b3-08a163471785
839	4	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	823a9569-d81b-4871-9b0d-1a8f04de234a
2663	2	\N	2	\N	\N	\N	TYPE_SUBMISSION	\N	28194931-611a-42cc-89c7-b133dc63c893	\N	01abe899-e6b3-49d1-87b3-08a163471785
888	4	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	9b4b9979-0172-4961-9d58-10f57df85092
872	4	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	5e8bca7b-a019-4138-9939-7951646ad23c
2586	2	\N	0	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	3371e717-1768-4f52-8eee-3ff331e3d90e
2587	2	\N	1	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	3371e717-1768-4f52-8eee-3ff331e3d90e
856	4	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	6b2e2ac5-98ee-4257-a54a-f24c7cb8fb01
2588	2	\N	3	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	3371e717-1768-4f52-8eee-3ff331e3d90e
2589	2	\N	4	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	3371e717-1768-4f52-8eee-3ff331e3d90e
2590	2	\N	2	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	3371e717-1768-4f52-8eee-3ff331e3d90e
2591	2	\N	0	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	f2d20e8d-cc45-4737-a1f8-6dc97d45f981
2592	2	\N	1	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	f2d20e8d-cc45-4737-a1f8-6dc97d45f981
2593	2	\N	3	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	f2d20e8d-cc45-4737-a1f8-6dc97d45f981
2594	2	\N	4	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	f2d20e8d-cc45-4737-a1f8-6dc97d45f981
2595	2	\N	2	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	f2d20e8d-cc45-4737-a1f8-6dc97d45f981
2596	2	\N	0	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	253193d7-2a6f-4636-9ebc-08c8cc1723ac
2597	2	\N	1	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	253193d7-2a6f-4636-9ebc-08c8cc1723ac
2598	2	\N	3	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	253193d7-2a6f-4636-9ebc-08c8cc1723ac
2599	2	\N	4	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	253193d7-2a6f-4636-9ebc-08c8cc1723ac
857	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	9d445c33-454e-49dc-a493-0f5015eead12
2600	2	\N	2	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	253193d7-2a6f-4636-9ebc-08c8cc1723ac
858	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	9d445c33-454e-49dc-a493-0f5015eead12
859	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	9d445c33-454e-49dc-a493-0f5015eead12
860	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	2b332fc6-9146-4623-863f-255d6566214f
861	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	2b332fc6-9146-4623-863f-255d6566214f
862	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	2b332fc6-9146-4623-863f-255d6566214f
863	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	7df394a5-4dff-468b-b97e-0559c07fa1b9
864	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	7df394a5-4dff-468b-b97e-0559c07fa1b9
865	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	7df394a5-4dff-468b-b97e-0559c07fa1b9
866	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	a0304a67-0fff-496c-9419-d6696ba39cc1
867	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	a0304a67-0fff-496c-9419-d6696ba39cc1
868	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	a0304a67-0fff-496c-9419-d6696ba39cc1
869	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	870c2ff3-ea24-4139-b31b-c643aa094c67
2222	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	416198eb-e102-4842-9bcc-a60fdcb450d7
870	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	870c2ff3-ea24-4139-b31b-c643aa094c67
871	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	870c2ff3-ea24-4139-b31b-c643aa094c67
2223	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	ab12cb79-aac2-414b-9946-6a754548e110
873	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	f6806a22-5e75-442a-8474-1f1bf3b49bb0
2224	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	90378b0b-c426-4551-a9f9-800896dbf44e
874	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	f6806a22-5e75-442a-8474-1f1bf3b49bb0
875	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	f6806a22-5e75-442a-8474-1f1bf3b49bb0
876	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	43c5b7d9-a1c7-4361-a0cf-0aa73a9333a7
877	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	43c5b7d9-a1c7-4361-a0cf-0aa73a9333a7
878	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	43c5b7d9-a1c7-4361-a0cf-0aa73a9333a7
879	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	55fdca5e-d193-44a3-ada5-2ab4d65395d6
880	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	55fdca5e-d193-44a3-ada5-2ab4d65395d6
881	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	55fdca5e-d193-44a3-ada5-2ab4d65395d6
882	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	0357e12e-1e20-4de1-89f8-17dfdd55fd31
883	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	0357e12e-1e20-4de1-89f8-17dfdd55fd31
884	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	0357e12e-1e20-4de1-89f8-17dfdd55fd31
2656	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	380e731b-2df3-4f9e-84d0-16ffb0010e66
885	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	c4ae769f-b5a3-48a9-885a-c99c99c19e37
2657	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	cea631f7-6753-416e-a6f1-83b25760bf3a
886	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	c4ae769f-b5a3-48a9-885a-c99c99c19e37
887	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	c4ae769f-b5a3-48a9-885a-c99c99c19e37
2658	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	c2fe3a86-8006-4f44-ad3a-9689e269a3c3
889	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	3158d744-02ae-45d3-a4c1-3b8a5c22de3e
2669	2	\N	0	\N	\N	\N	TYPE_SUBMISSION	\N	5ee61fad-2de8-4f98-834b-c327dfed413c	\N	01ac3eb0-7858-420b-9131-19cf28abf13e
890	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	3158d744-02ae-45d3-a4c1-3b8a5c22de3e
891	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	3158d744-02ae-45d3-a4c1-3b8a5c22de3e
892	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	3dac7ef7-c456-42a2-8fc4-519e13b07ee0
2670	2	\N	1	\N	\N	\N	TYPE_SUBMISSION	\N	5ee61fad-2de8-4f98-834b-c327dfed413c	\N	01ac3eb0-7858-420b-9131-19cf28abf13e
893	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	3dac7ef7-c456-42a2-8fc4-519e13b07ee0
894	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	3dac7ef7-c456-42a2-8fc4-519e13b07ee0
2671	2	\N	3	\N	\N	\N	TYPE_SUBMISSION	\N	5ee61fad-2de8-4f98-834b-c327dfed413c	\N	01ac3eb0-7858-420b-9131-19cf28abf13e
895	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	040fde0b-489a-4cc8-bfba-6f69ba7f4f11
2672	2	\N	4	\N	\N	\N	TYPE_SUBMISSION	\N	5ee61fad-2de8-4f98-834b-c327dfed413c	\N	01ac3eb0-7858-420b-9131-19cf28abf13e
896	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	040fde0b-489a-4cc8-bfba-6f69ba7f4f11
897	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	040fde0b-489a-4cc8-bfba-6f69ba7f4f11
898	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	e657559e-c7af-4fa3-8d0a-aba39f0ba879
2673	2	\N	2	\N	\N	\N	TYPE_SUBMISSION	\N	5ee61fad-2de8-4f98-834b-c327dfed413c	\N	01ac3eb0-7858-420b-9131-19cf28abf13e
899	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	e657559e-c7af-4fa3-8d0a-aba39f0ba879
900	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	e657559e-c7af-4fa3-8d0a-aba39f0ba879
901	3	\N	0	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	bf015865-7bd0-4282-bc70-61735421f9f1
2225	2	\N	0	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	05387bb7-4eb6-49e7-9061-6b7c2c6bb446
902	3	\N	10	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	bf015865-7bd0-4282-bc70-61735421f9f1
903	3	\N	9	\N	\N	\N	\N	\N	\N	582e3083-b833-4022-a81e-04220f4eca76	bf015865-7bd0-4282-bc70-61735421f9f1
2601	2	\N	0	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	202142cf-284f-499e-95a9-5ebb2522750a
2226	2	\N	1	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	05387bb7-4eb6-49e7-9061-6b7c2c6bb446
2227	2	\N	3	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	05387bb7-4eb6-49e7-9061-6b7c2c6bb446
2602	2	\N	1	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	202142cf-284f-499e-95a9-5ebb2522750a
2228	2	\N	4	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	05387bb7-4eb6-49e7-9061-6b7c2c6bb446
2229	2	\N	2	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	05387bb7-4eb6-49e7-9061-6b7c2c6bb446
2603	2	\N	3	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	202142cf-284f-499e-95a9-5ebb2522750a
2604	2	\N	4	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	202142cf-284f-499e-95a9-5ebb2522750a
2605	2	\N	2	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	202142cf-284f-499e-95a9-5ebb2522750a
2606	2	\N	0	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	beb1e339-b679-44de-be95-b17bb1255c7a
2607	2	\N	1	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	beb1e339-b679-44de-be95-b17bb1255c7a
2608	2	\N	3	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	beb1e339-b679-44de-be95-b17bb1255c7a
2609	2	\N	4	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	beb1e339-b679-44de-be95-b17bb1255c7a
2610	2	\N	2	\N	\N	\N	TYPE_SUBMISSION	\N	51f5e325-d8b5-41f3-b208-8271808ecf72	\N	beb1e339-b679-44de-be95-b17bb1255c7a
2664	2	\N	0	\N	\N	\N	TYPE_SUBMISSION	\N	5ee61fad-2de8-4f98-834b-c327dfed413c	\N	d03bfdfd-3c94-4b1d-8abd-b78d465c5daa
2665	2	\N	1	\N	\N	\N	TYPE_SUBMISSION	\N	5ee61fad-2de8-4f98-834b-c327dfed413c	\N	d03bfdfd-3c94-4b1d-8abd-b78d465c5daa
2666	2	\N	3	\N	\N	\N	TYPE_SUBMISSION	\N	5ee61fad-2de8-4f98-834b-c327dfed413c	\N	d03bfdfd-3c94-4b1d-8abd-b78d465c5daa
2667	2	\N	4	\N	\N	\N	TYPE_SUBMISSION	\N	5ee61fad-2de8-4f98-834b-c327dfed413c	\N	d03bfdfd-3c94-4b1d-8abd-b78d465c5daa
2668	2	\N	2	\N	\N	\N	TYPE_SUBMISSION	\N	5ee61fad-2de8-4f98-834b-c327dfed413c	\N	d03bfdfd-3c94-4b1d-8abd-b78d465c5daa
\.


--
-- Name: resourcepolicy_seq; Type: SEQUENCE SET; Schema: public; Owner: funasauser
--

SELECT pg_catalog.setval('public.resourcepolicy_seq', 2693, true);


--
-- Data for Name: schema_version; Type: TABLE DATA; Schema: public; Owner: funasauser
--

COPY public.schema_version (installed_rank, version, description, type, script, checksum, installed_by, installed_on, execution_time, success) FROM stdin;
1	1	<< Flyway Baseline >>	BASELINE	<< Flyway Baseline >>	\N	funasauser	2019-01-05 20:14:21.24297	0	t
2	1.1	Initial DSpace 1.1 database schema	SQL	V1.1__Initial_DSpace_1.1_database_schema.sql	1147897299	funasauser	2019-01-05 20:14:21.672013	378	t
3	1.2	Upgrade to DSpace 1.2 schema	SQL	V1.2__Upgrade_to_DSpace_1.2_schema.sql	903973515	funasauser	2019-01-05 20:14:22.069141	54	t
4	1.3	Upgrade to DSpace 1.3 schema	SQL	V1.3__Upgrade_to_DSpace_1.3_schema.sql	-783235991	funasauser	2019-01-05 20:14:22.141113	55	t
5	1.3.9	Drop constraint for DSpace 1 4 schema	JDBC	org.dspace.storage.rdbms.migration.V1_3_9__Drop_constraint_for_DSpace_1_4_schema	-1	funasauser	2019-01-05 20:14:22.214377	9	t
6	1.4	Upgrade to DSpace 1.4 schema	SQL	V1.4__Upgrade_to_DSpace_1.4_schema.sql	-831219528	funasauser	2019-01-05 20:14:22.242686	118	t
7	1.5	Upgrade to DSpace 1.5 schema	SQL	V1.5__Upgrade_to_DSpace_1.5_schema.sql	-1234304544	funasauser	2019-01-05 20:14:22.377044	155	t
8	1.5.9	Drop constraint for DSpace 1 6 schema	JDBC	org.dspace.storage.rdbms.migration.V1_5_9__Drop_constraint_for_DSpace_1_6_schema	-1	funasauser	2019-01-05 20:14:22.549083	5	t
9	1.6	Upgrade to DSpace 1.6 schema	SQL	V1.6__Upgrade_to_DSpace_1.6_schema.sql	-495469766	funasauser	2019-01-05 20:14:22.575528	61	t
10	1.7	Upgrade to DSpace 1.7 schema	SQL	V1.7__Upgrade_to_DSpace_1.7_schema.sql	-589640641	funasauser	2019-01-05 20:14:22.657769	11	t
11	1.8	Upgrade to DSpace 1.8 schema	SQL	V1.8__Upgrade_to_DSpace_1.8_schema.sql	-171791117	funasauser	2019-01-05 20:14:22.692285	10	t
12	3.0	Upgrade to DSpace 3.x schema	SQL	V3.0__Upgrade_to_DSpace_3.x_schema.sql	-1098885663	funasauser	2019-01-05 20:14:22.732184	23	t
13	4.0	Upgrade to DSpace 4.x schema	SQL	V4.0__Upgrade_to_DSpace_4.x_schema.sql	1191833374	funasauser	2019-01-05 20:14:22.772685	44	t
14	4.9.2015.10.26	DS-2818 registry update	SQL	V4.9_2015.10.26__DS-2818_registry_update.sql	1675451156	funasauser	2019-01-05 20:14:22.832915	15	t
15	5.0.2014.08.08	DS-1945 Helpdesk Request a Copy	SQL	V5.0_2014.08.08__DS-1945_Helpdesk_Request_a_Copy.sql	-1208221648	funasauser	2019-01-05 20:14:22.867159	5	t
16	5.0.2014.09.25	DS 1582 Metadata For All Objects drop constraint	JDBC	org.dspace.storage.rdbms.migration.V5_0_2014_09_25__DS_1582_Metadata_For_All_Objects_drop_constraint	-1	funasauser	2019-01-05 20:14:22.890596	2	t
17	5.0.2014.09.26	DS-1582 Metadata For All Objects	SQL	V5.0_2014.09.26__DS-1582_Metadata_For_All_Objects.sql	1509433410	funasauser	2019-01-05 20:14:22.907906	71	t
18	5.6.2016.08.23	DS-3097	SQL	V5.6_2016.08.23__DS-3097.sql	410632858	funasauser	2019-01-05 20:14:22.998512	10	t
19	5.7.2017.04.11	DS-3563 Index metadatavalue resource type id column	SQL	V5.7_2017.04.11__DS-3563_Index_metadatavalue_resource_type_id_column.sql	912059617	funasauser	2019-01-05 20:14:23.02477	6	t
20	5.7.2017.05.05	DS 3431 Add Policies for BasicWorkflow	JDBC	org.dspace.storage.rdbms.migration.V5_7_2017_05_05__DS_3431_Add_Policies_for_BasicWorkflow	-1	funasauser	2019-01-05 20:14:23.045959	74	t
21	6.0.2015.03.06	DS 2701 Dso Uuid Migration	JDBC	org.dspace.storage.rdbms.migration.V6_0_2015_03_06__DS_2701_Dso_Uuid_Migration	-1	funasauser	2019-01-05 20:14:23.13814	44	t
22	6.0.2015.03.07	DS-2701 Hibernate migration	SQL	V6.0_2015.03.07__DS-2701_Hibernate_migration.sql	-542830952	funasauser	2019-01-05 20:14:23.202306	579	t
23	6.0.2015.08.31	DS 2701 Hibernate Workflow Migration	JDBC	org.dspace.storage.rdbms.migration.V6_0_2015_08_31__DS_2701_Hibernate_Workflow_Migration	-1	funasauser	2019-01-05 20:14:23.808865	31	t
24	6.0.2016.01.03	DS-3024	SQL	V6.0_2016.01.03__DS-3024.sql	95468273	funasauser	2019-01-05 20:14:23.861199	18	t
25	6.0.2016.01.26	DS 2188 Remove DBMS Browse Tables	JDBC	org.dspace.storage.rdbms.migration.V6_0_2016_01_26__DS_2188_Remove_DBMS_Browse_Tables	-1	funasauser	2019-01-05 20:14:23.89978	63	t
26	6.0.2016.02.25	DS-3004-slow-searching-as-admin	SQL	V6.0_2016.02.25__DS-3004-slow-searching-as-admin.sql	-1623115511	funasauser	2019-01-05 20:14:23.981957	26	t
27	6.0.2016.04.01	DS-1955 Increase embargo reason	SQL	V6.0_2016.04.01__DS-1955_Increase_embargo_reason.sql	283892016	funasauser	2019-01-05 20:14:24.026223	12	t
28	6.0.2016.04.04	DS-3086-OAI-Performance-fix	SQL	V6.0_2016.04.04__DS-3086-OAI-Performance-fix.sql	445863295	funasauser	2019-01-05 20:14:24.056419	19	t
29	6.0.2016.04.14	DS-3125-fix-bundle-bitstream-delete-rights	SQL	V6.0_2016.04.14__DS-3125-fix-bundle-bitstream-delete-rights.sql	-699277527	funasauser	2019-01-05 20:14:24.093421	6	t
30	6.0.2016.05.10	DS-3168-fix-requestitem item id column	SQL	V6.0_2016.05.10__DS-3168-fix-requestitem_item_id_column.sql	-1122969100	funasauser	2019-01-05 20:14:24.114932	17	t
31	6.0.2016.07.21	DS-2775	SQL	V6.0_2016.07.21__DS-2775.sql	-126635374	funasauser	2019-01-05 20:14:24.148574	23	t
32	6.0.2016.07.26	DS-3277 fix handle assignment	SQL	V6.0_2016.07.26__DS-3277_fix_handle_assignment.sql	-284088754	funasauser	2019-01-05 20:14:24.187826	9	t
33	6.0.2016.08.23	DS-3097	SQL	V6.0_2016.08.23__DS-3097.sql	-1986377895	funasauser	2019-01-05 20:14:24.211135	6	t
34	6.1.2017.01.03	DS 3431 Add Policies for BasicWorkflow	JDBC	org.dspace.storage.rdbms.migration.V6_1_2017_01_03__DS_3431_Add_Policies_for_BasicWorkflow	-1	funasauser	2019-01-05 20:14:24.231181	71	t
\.


--
-- Data for Name: site; Type: TABLE DATA; Schema: public; Owner: funasauser
--

COPY public.site (uuid) FROM stdin;
44f60f35-fb87-4dd7-98cc-eb861476c8b0
\.


--
-- Data for Name: subscription; Type: TABLE DATA; Schema: public; Owner: funasauser
--

COPY public.subscription (subscription_id, eperson_id, collection_id) FROM stdin;
1	cd410caa-8ed0-4822-8722-8eab234a8b4c	f2c7e15a-2db1-4099-9d26-78ba2c16b8da
\.


--
-- Name: subscription_seq; Type: SEQUENCE SET; Schema: public; Owner: funasauser
--

SELECT pg_catalog.setval('public.subscription_seq', 1, true);


--
-- Data for Name: tasklistitem; Type: TABLE DATA; Schema: public; Owner: funasauser
--

COPY public.tasklistitem (tasklist_id, workflow_id, eperson_id) FROM stdin;
\.


--
-- Name: tasklistitem_seq; Type: SEQUENCE SET; Schema: public; Owner: funasauser
--

SELECT pg_catalog.setval('public.tasklistitem_seq', 1, false);


--
-- Data for Name: versionhistory; Type: TABLE DATA; Schema: public; Owner: funasauser
--

COPY public.versionhistory (versionhistory_id) FROM stdin;
\.


--
-- Name: versionhistory_seq; Type: SEQUENCE SET; Schema: public; Owner: funasauser
--

SELECT pg_catalog.setval('public.versionhistory_seq', 1, false);


--
-- Data for Name: versionitem; Type: TABLE DATA; Schema: public; Owner: funasauser
--

COPY public.versionitem (versionitem_id, version_number, version_date, version_summary, versionhistory_id, eperson_id, item_id) FROM stdin;
\.


--
-- Name: versionitem_seq; Type: SEQUENCE SET; Schema: public; Owner: funasauser
--

SELECT pg_catalog.setval('public.versionitem_seq', 1, false);


--
-- Data for Name: webapp; Type: TABLE DATA; Schema: public; Owner: funasauser
--

COPY public.webapp (webapp_id, appname, url, started, isui) FROM stdin;
105	OAI	http://rcfunasa.bvsalud.org/	2019-06-01 13:51:55.476	0
65	XMLUI	http://rcfunasa.bvsalud.org/	2019-04-12 19:13:04.898	1
66	REST	http://rcfunasa.bvsalud.org/	2019-04-12 19:13:32.44	0
67	OAI	http://rcfunasa.bvsalud.org/	2019-04-12 19:33:56.327	0
5	OAI	http://rcfunasa.bvsalud.org/	2019-01-05 20:24:41.83	0
6	OAI	http://rcfunasa.bvsalud.org/	2019-01-05 20:27:34.448	0
69	REST	http://rcfunasa.bvsalud.org/	2019-04-12 19:35:09.989	0
70	OAI	http://rcfunasa.bvsalud.org/	2019-05-01 11:07:13.621	0
72	REST	http://rcfunasa.bvsalud.org/	2019-05-01 11:08:36.123	0
73	OAI	http://rcfunasa.bvsalud.org/	2019-05-09 10:10:40.478	0
13	OAI	http://rcfunasa.bvsalud.org/	2019-01-05 20:39:20.561	0
14	XMLUI	http://rcfunasa.bvsalud.org/	2019-01-05 20:39:45.15	1
74	XMLUI	http://rcfunasa.bvsalud.org/	2019-05-09 10:11:16.585	1
16	OAI	http://rcfunasa.bvsalud.org/	2019-01-09 10:20:20.931	0
17	XMLUI	http://rcfunasa.bvsalud.org/	2019-01-09 10:20:51.601	1
75	REST	http://rcfunasa.bvsalud.org/	2019-05-09 10:11:46.56	0
19	OAI	http://rcfunasa.bvsalud.org/	2019-01-09 15:47:03.415	0
76	OAI	http://rcfunasa.bvsalud.org/	2019-05-09 10:45:09.356	0
108	OAI	http://rcfunasa.bvsalud.org/	2019-06-04 11:22:29.649	0
78	REST	http://rcfunasa.bvsalud.org/	2019-05-09 10:46:08.678	0
23	XMLUI	http://rcfunasa.bvsalud.org/	2019-01-10 02:26:32.647	1
79	OAI	http://rcfunasa.bvsalud.org/	2019-05-10 09:31:40.838	0
49	OAI	http://rcfunasa.bvsalud.org/	2019-01-30 22:06:07.869	0
50	XMLUI	http://rcfunasa.bvsalud.org/	2019-01-30 22:06:36.438	1
51	REST	http://rcfunasa.bvsalud.org/	2019-01-30 22:06:56.529	0
52	OAI	http://rcfunasa.bvsalud.org/	2019-03-21 12:58:48.764	0
53	XMLUI	http://rcfunasa.bvsalud.org/	2019-03-21 12:59:26.965	1
81	REST	http://rcfunasa.bvsalud.org/	2019-05-10 09:32:48.132	0
111	OAI	http://rcfunasa.bvsalud.org/	2019-06-04 11:31:46.184	0
85	OAI	http://rcfunasa.bvsalud.org/	2019-05-15 09:21:05.222	0
58	OAI	http://rcfunasa.bvsalud.org/	2019-03-26 02:56:59.739	0
59	XMLUI	http://rcfunasa.bvsalud.org/	2019-03-26 02:57:31.069	1
60	REST	http://rcfunasa.bvsalud.org/	2019-03-26 02:57:53.382	0
61	OAI	http://rcfunasa.bvsalud.org/	2019-03-31 12:52:49.306	0
63	REST	http://rcfunasa.bvsalud.org/	2019-03-31 12:53:41.922	0
114	XMLUI	http://rcfunasa.bvsalud.org/	2019-08-03 11:09:22.238	1
88	XMLUI	http://rcfunasa.bvsalud.org/	2019-05-27 04:06:31.551	1
89	REST	http://rcfunasa.bvsalud.org/	2019-05-27 04:07:13.954	0
90	OAI	http://rcfunasa.bvsalud.org/	2019-05-27 04:12:49.081	0
91	XMLUI	http://rcfunasa.bvsalud.org/	2019-05-27 04:13:17.597	1
115	REST	http://rcfunasa.bvsalud.org/	2019-08-03 11:10:05.834	0
116	OAI	http://rcfunasa.bvsalud.org/	2019-08-03 11:11:08.429	0
96	OAI	http://rcfunasa.bvsalud.org/	2019-05-30 13:42:41.201	0
97	XMLUI	http://rcfunasa.bvsalud.org/	2019-05-30 13:43:15.363	1
119	XMLUI	http://rcfunasa.bvsalud.org/	2019-08-06 11:13:51.542	1
120	OAI	http://rcfunasa.bvsalud.org/	2019-08-06 11:15:14.721	0
100	XMLUI	http://rcfunasa.bvsalud.org/	2019-06-01 12:34:30.03	1
121	XMLUI	http://rcfunasa.bvsalud.org/	2019-08-06 11:15:49.879	1
103	XMLUI	http://rcfunasa.bvsalud.org/	2019-06-01 13:28:09.164	1
124	XMLUI	http://rcfunasa.bvsalud.org/	2019-08-07 02:56:17.205	1
128	OAI	http://rcfunasa.bvsalud.org/	2019-08-31 17:39:15.099	0
129	XMLUI	http://rcfunasa.bvsalud.org/	2019-08-31 17:39:52.837	1
130	REST	http://rcfunasa.bvsalud.org/	2019-08-31 17:40:25.58	0
\.


--
-- Name: webapp_seq; Type: SEQUENCE SET; Schema: public; Owner: funasauser
--

SELECT pg_catalog.setval('public.webapp_seq', 130, true);


--
-- Data for Name: workflowitem; Type: TABLE DATA; Schema: public; Owner: funasauser
--

COPY public.workflowitem (workflow_id, state, multiple_titles, published_before, multiple_files, item_id, collection_id, owner) FROM stdin;
\.


--
-- Name: workflowitem_seq; Type: SEQUENCE SET; Schema: public; Owner: funasauser
--

SELECT pg_catalog.setval('public.workflowitem_seq', 21, true);


--
-- Data for Name: workspaceitem; Type: TABLE DATA; Schema: public; Owner: funasauser
--

COPY public.workspaceitem (workspace_item_id, multiple_titles, published_before, multiple_files, stage_reached, page_reached, item_id, collection_id) FROM stdin;
158	t	t	t	2	1	351126ff-3ed8-4ee6-bb98-54a08e436331	c087e9be-29f7-437f-b0da-bddb0b2ab183
146	t	t	t	2	1	54274d99-b0a7-41f5-bfbb-321d3e01d787	c087e9be-29f7-437f-b0da-bddb0b2ab183
190	t	t	t	2	1	a0c1ee92-b2b4-4f58-adae-4a8101e93aa7	cd75101b-abb6-46ef-ac88-3af552f33478
211	t	t	t	2	1	0fbb9e34-4b32-409d-a301-6a4a5e5a9ee4	6ef94e51-16d7-4cec-9359-a94d499e8337
202	t	t	t	2	1	fec6cee0-40ae-40ab-8b42-b2adf77d55a4	f2c7e15a-2db1-4099-9d26-78ba2c16b8da
12	t	t	t	2	1	c54373cb-b02d-4935-add5-f3c17ae29223	8a52ac60-0cb5-4d6f-8b4c-a9cd65b62d0a
191	t	t	t	2	1	6435afc7-5bfc-43d1-a557-286efaaf8ed4	b55202c0-1e3b-4eba-909d-54f7fad48b9c
161	t	t	t	2	1	4efe5ddd-8bc9-43b6-a95d-bfedee710730	c087e9be-29f7-437f-b0da-bddb0b2ab183
203	t	t	t	2	1	61cec1fe-92dd-4e5f-8cb0-cd838ac093f0	cd75101b-abb6-46ef-ac88-3af552f33478
192	t	t	t	2	1	e15414f8-b998-4844-a3e6-fd616616a97d	6ef94e51-16d7-4cec-9359-a94d499e8337
162	t	t	t	2	1	9213adb3-98f4-4d42-b36f-a044402c752a	c087e9be-29f7-437f-b0da-bddb0b2ab183
149	t	t	t	2	1	05387bb7-4eb6-49e7-9061-6b7c2c6bb446	c087e9be-29f7-437f-b0da-bddb0b2ab183
141	t	t	t	2	1	861af420-dd5d-497c-83d4-f06ebcfc9528	c087e9be-29f7-437f-b0da-bddb0b2ab183
142	t	t	t	2	1	33a11e84-68c9-4e4c-8aba-53990a33f7ca	cd75101b-abb6-46ef-ac88-3af552f33478
163	t	t	t	2	1	2b63d710-d77a-46ed-a02d-8f12284d093d	f2c7e15a-2db1-4099-9d26-78ba2c16b8da
193	t	t	t	2	1	a9e375db-ed27-49a4-ab37-1f71e3344c07	6ef94e51-16d7-4cec-9359-a94d499e8337
204	t	t	t	2	1	d7ff7622-8d60-4892-9132-d44c6321e8a6	cd75101b-abb6-46ef-ac88-3af552f33478
164	t	t	t	2	1	d1483857-e58d-4d41-9d56-e70a642ca5f8	f2c7e15a-2db1-4099-9d26-78ba2c16b8da
152	t	t	t	4	1	98667b07-a1fd-4b74-ba08-933c0d63c1d0	b55202c0-1e3b-4eba-909d-54f7fad48b9c
183	t	t	t	2	1	a96c12d6-537a-46d9-9b12-5e6e3841afea	cd75101b-abb6-46ef-ac88-3af552f33478
153	t	t	t	2	1	c80bc66c-a22e-43ae-8149-4fb687e2aad1	f2c7e15a-2db1-4099-9d26-78ba2c16b8da
165	t	t	t	2	1	5465b2d4-cc89-4a55-bf57-b27704f9d683	f2c7e15a-2db1-4099-9d26-78ba2c16b8da
219	t	t	t	2	1	d03bfdfd-3c94-4b1d-8abd-b78d465c5daa	96931619-4af6-4562-9d21-45a09a3a369f
144	t	t	t	2	1	d2550a87-9f59-4d60-aca3-bd9b955bfa4d	f2c7e15a-2db1-4099-9d26-78ba2c16b8da
212	t	t	t	2	1	e21ca461-7f92-4cc7-8b99-9779c76e351a	6ef94e51-16d7-4cec-9359-a94d499e8337
155	t	t	t	2	1	1948e980-ac90-4c67-9d57-375b10c0978a	c087e9be-29f7-437f-b0da-bddb0b2ab183
145	t	t	t	2	1	7612424e-b29d-4a55-b8de-61f3ac6bfb59	c087e9be-29f7-437f-b0da-bddb0b2ab183
166	t	t	t	2	1	6466da00-ee69-4ea7-a7b4-3bbdbbf104ae	f2c7e15a-2db1-4099-9d26-78ba2c16b8da
205	t	t	t	2	1	7009fa9d-a02c-4910-a62f-5c3f2b8f28a2	cd75101b-abb6-46ef-ac88-3af552f33478
184	t	t	t	2	1	a933e90f-022f-487e-bb25-c1e3f9de5e6c	cd75101b-abb6-46ef-ac88-3af552f33478
157	t	t	t	2	1	fd7979d1-2f9d-43c1-921b-16286ad57b19	c087e9be-29f7-437f-b0da-bddb0b2ab183
185	t	t	t	2	1	fa0c8a49-a6bf-4d87-805d-5233c36c82ea	cd75101b-abb6-46ef-ac88-3af552f33478
196	t	t	t	2	1	d97e2d78-7a2c-413d-9749-2c004d3f95a9	c087e9be-29f7-437f-b0da-bddb0b2ab183
206	t	t	t	2	1	3371e717-1768-4f52-8eee-3ff331e3d90e	cd75101b-abb6-46ef-ac88-3af552f33478
197	t	t	t	2	1	7a3e90a0-98d3-431e-9432-1ede8f95757f	c087e9be-29f7-437f-b0da-bddb0b2ab183
207	t	t	t	2	1	f2d20e8d-cc45-4737-a1f8-6dc97d45f981	b55202c0-1e3b-4eba-909d-54f7fad48b9c
198	t	t	t	2	1	65aff6e2-e01f-4ea7-b76a-854578347fce	c087e9be-29f7-437f-b0da-bddb0b2ab183
199	t	t	t	2	1	7f9c8b1b-3a70-4b8b-8900-c6d095e1db00	c087e9be-29f7-437f-b0da-bddb0b2ab183
213	t	t	t	2	1	534ec073-e464-4149-bf28-5cf8ad4baa5d	6ef94e51-16d7-4cec-9359-a94d499e8337
208	t	t	t	2	1	253193d7-2a6f-4636-9ebc-08c8cc1723ac	b55202c0-1e3b-4eba-909d-54f7fad48b9c
189	t	t	t	2	1	4bfa33a5-6844-4768-a282-9dac09cd5770	b55202c0-1e3b-4eba-909d-54f7fad48b9c
200	t	t	t	2	1	f1228c2e-1e8e-4e61-b4ce-a569f98cc534	f2c7e15a-2db1-4099-9d26-78ba2c16b8da
209	t	t	t	2	1	202142cf-284f-499e-95a9-5ebb2522750a	b55202c0-1e3b-4eba-909d-54f7fad48b9c
201	t	t	t	2	1	b4c46f03-496f-42a2-98f7-6739e324de11	f2c7e15a-2db1-4099-9d26-78ba2c16b8da
210	t	t	t	2	1	beb1e339-b679-44de-be95-b17bb1255c7a	b55202c0-1e3b-4eba-909d-54f7fad48b9c
220	t	t	t	2	1	01ac3eb0-7858-420b-9131-19cf28abf13e	b2020a23-0063-4efe-b770-9c9a5a099b42
214	t	t	t	2	1	428163a7-e57d-4b39-a5b8-9fd69dc65567	6ef94e51-16d7-4cec-9359-a94d499e8337
221	t	t	t	2	1	2c23936e-e138-4502-8ec3-e8c71bb851b1	b2020a23-0063-4efe-b770-9c9a5a099b42
216	t	t	t	2	1	34cefcb9-0d95-4de6-938f-9217bcc9399b	c087e9be-29f7-437f-b0da-bddb0b2ab183
222	t	t	t	2	1	0a2460c5-e7b6-4e59-8342-35dd4514da7c	b2020a23-0063-4efe-b770-9c9a5a099b42
218	t	t	t	2	1	01abe899-e6b3-49d1-87b3-08a163471785	b55202c0-1e3b-4eba-909d-54f7fad48b9c
\.


--
-- Name: workspaceitem_seq; Type: SEQUENCE SET; Schema: public; Owner: funasauser
--

SELECT pg_catalog.setval('public.workspaceitem_seq', 224, true);


--
-- Name: bitstream bitstream_id_unique; Type: CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.bitstream
    ADD CONSTRAINT bitstream_id_unique UNIQUE (uuid);


--
-- Name: bitstream bitstream_pkey; Type: CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.bitstream
    ADD CONSTRAINT bitstream_pkey PRIMARY KEY (uuid);


--
-- Name: bitstream bitstream_uuid_key; Type: CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.bitstream
    ADD CONSTRAINT bitstream_uuid_key UNIQUE (uuid);


--
-- Name: bitstreamformatregistry bitstreamformatregistry_pkey; Type: CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.bitstreamformatregistry
    ADD CONSTRAINT bitstreamformatregistry_pkey PRIMARY KEY (bitstream_format_id);


--
-- Name: bitstreamformatregistry bitstreamformatregistry_short_description_key; Type: CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.bitstreamformatregistry
    ADD CONSTRAINT bitstreamformatregistry_short_description_key UNIQUE (short_description);


--
-- Name: bundle2bitstream bundle2bitstream_pkey; Type: CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.bundle2bitstream
    ADD CONSTRAINT bundle2bitstream_pkey PRIMARY KEY (bitstream_id, bundle_id, bitstream_order);


--
-- Name: bundle bundle_id_unique; Type: CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.bundle
    ADD CONSTRAINT bundle_id_unique UNIQUE (uuid);


--
-- Name: bundle bundle_pkey; Type: CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.bundle
    ADD CONSTRAINT bundle_pkey PRIMARY KEY (uuid);


--
-- Name: bundle bundle_uuid_key; Type: CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.bundle
    ADD CONSTRAINT bundle_uuid_key UNIQUE (uuid);


--
-- Name: checksum_history checksum_history_pkey; Type: CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.checksum_history
    ADD CONSTRAINT checksum_history_pkey PRIMARY KEY (check_id);


--
-- Name: checksum_results checksum_results_pkey; Type: CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.checksum_results
    ADD CONSTRAINT checksum_results_pkey PRIMARY KEY (result_code);


--
-- Name: collection2item collection2item_pkey; Type: CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.collection2item
    ADD CONSTRAINT collection2item_pkey PRIMARY KEY (collection_id, item_id);


--
-- Name: collection collection_id_unique; Type: CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.collection
    ADD CONSTRAINT collection_id_unique UNIQUE (uuid);


--
-- Name: collection collection_pkey; Type: CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.collection
    ADD CONSTRAINT collection_pkey PRIMARY KEY (uuid);


--
-- Name: collection collection_uuid_key; Type: CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.collection
    ADD CONSTRAINT collection_uuid_key UNIQUE (uuid);


--
-- Name: community2collection community2collection_pkey; Type: CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.community2collection
    ADD CONSTRAINT community2collection_pkey PRIMARY KEY (collection_id, community_id);


--
-- Name: community2community community2community_pkey; Type: CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.community2community
    ADD CONSTRAINT community2community_pkey PRIMARY KEY (parent_comm_id, child_comm_id);


--
-- Name: community community_id_unique; Type: CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.community
    ADD CONSTRAINT community_id_unique UNIQUE (uuid);


--
-- Name: community community_pkey; Type: CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.community
    ADD CONSTRAINT community_pkey PRIMARY KEY (uuid);


--
-- Name: community community_uuid_key; Type: CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.community
    ADD CONSTRAINT community_uuid_key UNIQUE (uuid);


--
-- Name: doi doi_doi_key; Type: CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.doi
    ADD CONSTRAINT doi_doi_key UNIQUE (doi);


--
-- Name: doi doi_pkey; Type: CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.doi
    ADD CONSTRAINT doi_pkey PRIMARY KEY (doi_id);


--
-- Name: dspaceobject dspaceobject_pkey; Type: CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.dspaceobject
    ADD CONSTRAINT dspaceobject_pkey PRIMARY KEY (uuid);


--
-- Name: eperson eperson_email_key; Type: CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.eperson
    ADD CONSTRAINT eperson_email_key UNIQUE (email);


--
-- Name: eperson eperson_id_unique; Type: CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.eperson
    ADD CONSTRAINT eperson_id_unique UNIQUE (uuid);


--
-- Name: eperson eperson_netid_key; Type: CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.eperson
    ADD CONSTRAINT eperson_netid_key UNIQUE (netid);


--
-- Name: eperson eperson_pkey; Type: CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.eperson
    ADD CONSTRAINT eperson_pkey PRIMARY KEY (uuid);


--
-- Name: eperson eperson_uuid_key; Type: CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.eperson
    ADD CONSTRAINT eperson_uuid_key UNIQUE (uuid);


--
-- Name: epersongroup2eperson epersongroup2eperson_pkey; Type: CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.epersongroup2eperson
    ADD CONSTRAINT epersongroup2eperson_pkey PRIMARY KEY (eperson_group_id, eperson_id);


--
-- Name: epersongroup2workspaceitem epersongroup2workspaceitem_pkey; Type: CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.epersongroup2workspaceitem
    ADD CONSTRAINT epersongroup2workspaceitem_pkey PRIMARY KEY (workspace_item_id, eperson_group_id);


--
-- Name: epersongroup epersongroup_id_unique; Type: CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.epersongroup
    ADD CONSTRAINT epersongroup_id_unique UNIQUE (uuid);


--
-- Name: epersongroup epersongroup_pkey; Type: CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.epersongroup
    ADD CONSTRAINT epersongroup_pkey PRIMARY KEY (uuid);


--
-- Name: epersongroup epersongroup_uuid_key; Type: CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.epersongroup
    ADD CONSTRAINT epersongroup_uuid_key UNIQUE (uuid);


--
-- Name: fileextension fileextension_pkey; Type: CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.fileextension
    ADD CONSTRAINT fileextension_pkey PRIMARY KEY (file_extension_id);


--
-- Name: group2group group2group_pkey; Type: CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.group2group
    ADD CONSTRAINT group2group_pkey PRIMARY KEY (parent_id, child_id);


--
-- Name: group2groupcache group2groupcache_pkey; Type: CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.group2groupcache
    ADD CONSTRAINT group2groupcache_pkey PRIMARY KEY (parent_id, child_id);


--
-- Name: handle handle_handle_key; Type: CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.handle
    ADD CONSTRAINT handle_handle_key UNIQUE (handle);


--
-- Name: handle handle_pkey; Type: CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.handle
    ADD CONSTRAINT handle_pkey PRIMARY KEY (handle_id);


--
-- Name: harvested_collection harvested_collection_pkey; Type: CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.harvested_collection
    ADD CONSTRAINT harvested_collection_pkey PRIMARY KEY (id);


--
-- Name: harvested_item harvested_item_pkey; Type: CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.harvested_item
    ADD CONSTRAINT harvested_item_pkey PRIMARY KEY (id);


--
-- Name: item2bundle item2bundle_pkey; Type: CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.item2bundle
    ADD CONSTRAINT item2bundle_pkey PRIMARY KEY (bundle_id, item_id);


--
-- Name: item item_id_unique; Type: CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.item
    ADD CONSTRAINT item_id_unique UNIQUE (uuid);


--
-- Name: item item_pkey; Type: CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.item
    ADD CONSTRAINT item_pkey PRIMARY KEY (uuid);


--
-- Name: item item_uuid_key; Type: CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.item
    ADD CONSTRAINT item_uuid_key UNIQUE (uuid);


--
-- Name: metadatafieldregistry metadatafieldregistry_pkey; Type: CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.metadatafieldregistry
    ADD CONSTRAINT metadatafieldregistry_pkey PRIMARY KEY (metadata_field_id);


--
-- Name: metadataschemaregistry metadataschemaregistry_namespace_key; Type: CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.metadataschemaregistry
    ADD CONSTRAINT metadataschemaregistry_namespace_key UNIQUE (namespace);


--
-- Name: metadataschemaregistry metadataschemaregistry_pkey; Type: CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.metadataschemaregistry
    ADD CONSTRAINT metadataschemaregistry_pkey PRIMARY KEY (metadata_schema_id);


--
-- Name: metadatavalue metadatavalue_pkey; Type: CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.metadatavalue
    ADD CONSTRAINT metadatavalue_pkey PRIMARY KEY (metadata_value_id);


--
-- Name: registrationdata registrationdata_email_key; Type: CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.registrationdata
    ADD CONSTRAINT registrationdata_email_key UNIQUE (email);


--
-- Name: registrationdata registrationdata_pkey; Type: CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.registrationdata
    ADD CONSTRAINT registrationdata_pkey PRIMARY KEY (registrationdata_id);


--
-- Name: requestitem requestitem_pkey; Type: CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.requestitem
    ADD CONSTRAINT requestitem_pkey PRIMARY KEY (requestitem_id);


--
-- Name: requestitem requestitem_token_key; Type: CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.requestitem
    ADD CONSTRAINT requestitem_token_key UNIQUE (token);


--
-- Name: resourcepolicy resourcepolicy_pkey; Type: CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.resourcepolicy
    ADD CONSTRAINT resourcepolicy_pkey PRIMARY KEY (policy_id);


--
-- Name: schema_version schema_version_pk; Type: CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.schema_version
    ADD CONSTRAINT schema_version_pk PRIMARY KEY (installed_rank);


--
-- Name: site site_pkey; Type: CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.site
    ADD CONSTRAINT site_pkey PRIMARY KEY (uuid);


--
-- Name: subscription subscription_pkey; Type: CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.subscription
    ADD CONSTRAINT subscription_pkey PRIMARY KEY (subscription_id);


--
-- Name: tasklistitem tasklistitem_pkey; Type: CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.tasklistitem
    ADD CONSTRAINT tasklistitem_pkey PRIMARY KEY (tasklist_id);


--
-- Name: versionhistory versionhistory_pkey; Type: CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.versionhistory
    ADD CONSTRAINT versionhistory_pkey PRIMARY KEY (versionhistory_id);


--
-- Name: versionitem versionitem_pkey; Type: CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.versionitem
    ADD CONSTRAINT versionitem_pkey PRIMARY KEY (versionitem_id);


--
-- Name: webapp webapp_pkey; Type: CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.webapp
    ADD CONSTRAINT webapp_pkey PRIMARY KEY (webapp_id);


--
-- Name: workflowitem workflowitem_pkey; Type: CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.workflowitem
    ADD CONSTRAINT workflowitem_pkey PRIMARY KEY (workflow_id);


--
-- Name: workspaceitem workspaceitem_pkey; Type: CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.workspaceitem
    ADD CONSTRAINT workspaceitem_pkey PRIMARY KEY (workspace_item_id);


--
-- Name: bit_bitstream_fk_idx; Type: INDEX; Schema: public; Owner: funasauser
--

CREATE INDEX bit_bitstream_fk_idx ON public.bitstream USING btree (bitstream_format_id);


--
-- Name: bitstream_id_idx; Type: INDEX; Schema: public; Owner: funasauser
--

CREATE INDEX bitstream_id_idx ON public.bitstream USING btree (bitstream_id);


--
-- Name: bundle2bitstream_bitstream; Type: INDEX; Schema: public; Owner: funasauser
--

CREATE INDEX bundle2bitstream_bitstream ON public.bundle2bitstream USING btree (bitstream_id);


--
-- Name: bundle2bitstream_bundle; Type: INDEX; Schema: public; Owner: funasauser
--

CREATE INDEX bundle2bitstream_bundle ON public.bundle2bitstream USING btree (bundle_id);


--
-- Name: bundle_id_idx; Type: INDEX; Schema: public; Owner: funasauser
--

CREATE INDEX bundle_id_idx ON public.bundle USING btree (bundle_id);


--
-- Name: bundle_primary; Type: INDEX; Schema: public; Owner: funasauser
--

CREATE INDEX bundle_primary ON public.bundle USING btree (primary_bitstream_id);


--
-- Name: ch_result_fk_idx; Type: INDEX; Schema: public; Owner: funasauser
--

CREATE INDEX ch_result_fk_idx ON public.checksum_history USING btree (result);


--
-- Name: checksum_history_bitstream; Type: INDEX; Schema: public; Owner: funasauser
--

CREATE INDEX checksum_history_bitstream ON public.checksum_history USING btree (bitstream_id);


--
-- Name: collecion2item_collection; Type: INDEX; Schema: public; Owner: funasauser
--

CREATE INDEX collecion2item_collection ON public.collection2item USING btree (collection_id);


--
-- Name: collecion2item_item; Type: INDEX; Schema: public; Owner: funasauser
--

CREATE INDEX collecion2item_item ON public.collection2item USING btree (item_id);


--
-- Name: collection_bitstream; Type: INDEX; Schema: public; Owner: funasauser
--

CREATE INDEX collection_bitstream ON public.collection USING btree (logo_bitstream_id);


--
-- Name: collection_id_idx; Type: INDEX; Schema: public; Owner: funasauser
--

CREATE INDEX collection_id_idx ON public.collection USING btree (collection_id);


--
-- Name: collection_submitter; Type: INDEX; Schema: public; Owner: funasauser
--

CREATE INDEX collection_submitter ON public.collection USING btree (submitter);


--
-- Name: collection_template; Type: INDEX; Schema: public; Owner: funasauser
--

CREATE INDEX collection_template ON public.collection USING btree (template_item_id);


--
-- Name: collection_workflow1; Type: INDEX; Schema: public; Owner: funasauser
--

CREATE INDEX collection_workflow1 ON public.collection USING btree (workflow_step_1);


--
-- Name: collection_workflow2; Type: INDEX; Schema: public; Owner: funasauser
--

CREATE INDEX collection_workflow2 ON public.collection USING btree (workflow_step_2);


--
-- Name: collection_workflow3; Type: INDEX; Schema: public; Owner: funasauser
--

CREATE INDEX collection_workflow3 ON public.collection USING btree (workflow_step_3);


--
-- Name: community2collection_collection; Type: INDEX; Schema: public; Owner: funasauser
--

CREATE INDEX community2collection_collection ON public.community2collection USING btree (collection_id);


--
-- Name: community2collection_community; Type: INDEX; Schema: public; Owner: funasauser
--

CREATE INDEX community2collection_community ON public.community2collection USING btree (community_id);


--
-- Name: community2community_child; Type: INDEX; Schema: public; Owner: funasauser
--

CREATE INDEX community2community_child ON public.community2community USING btree (child_comm_id);


--
-- Name: community2community_parent; Type: INDEX; Schema: public; Owner: funasauser
--

CREATE INDEX community2community_parent ON public.community2community USING btree (parent_comm_id);


--
-- Name: community_admin; Type: INDEX; Schema: public; Owner: funasauser
--

CREATE INDEX community_admin ON public.community USING btree (admin);


--
-- Name: community_bitstream; Type: INDEX; Schema: public; Owner: funasauser
--

CREATE INDEX community_bitstream ON public.community USING btree (logo_bitstream_id);


--
-- Name: community_id_idx; Type: INDEX; Schema: public; Owner: funasauser
--

CREATE INDEX community_id_idx ON public.community USING btree (community_id);


--
-- Name: doi_doi_idx; Type: INDEX; Schema: public; Owner: funasauser
--

CREATE INDEX doi_doi_idx ON public.doi USING btree (doi);


--
-- Name: doi_object; Type: INDEX; Schema: public; Owner: funasauser
--

CREATE INDEX doi_object ON public.doi USING btree (dspace_object);


--
-- Name: doi_resource_id_and_type_idx; Type: INDEX; Schema: public; Owner: funasauser
--

CREATE INDEX doi_resource_id_and_type_idx ON public.doi USING btree (resource_id, resource_type_id);


--
-- Name: eperson_email_idx; Type: INDEX; Schema: public; Owner: funasauser
--

CREATE INDEX eperson_email_idx ON public.eperson USING btree (email);


--
-- Name: eperson_group_id_idx; Type: INDEX; Schema: public; Owner: funasauser
--

CREATE INDEX eperson_group_id_idx ON public.epersongroup USING btree (eperson_group_id);


--
-- Name: eperson_id_idx; Type: INDEX; Schema: public; Owner: funasauser
--

CREATE INDEX eperson_id_idx ON public.eperson USING btree (eperson_id);


--
-- Name: epersongroup2eperson_group; Type: INDEX; Schema: public; Owner: funasauser
--

CREATE INDEX epersongroup2eperson_group ON public.epersongroup2eperson USING btree (eperson_group_id);


--
-- Name: epersongroup2eperson_person; Type: INDEX; Schema: public; Owner: funasauser
--

CREATE INDEX epersongroup2eperson_person ON public.epersongroup2eperson USING btree (eperson_id);


--
-- Name: epersongroup2workspaceitem_group; Type: INDEX; Schema: public; Owner: funasauser
--

CREATE INDEX epersongroup2workspaceitem_group ON public.epersongroup2workspaceitem USING btree (eperson_group_id);


--
-- Name: epersongroup_unique_idx_name; Type: INDEX; Schema: public; Owner: funasauser
--

CREATE UNIQUE INDEX epersongroup_unique_idx_name ON public.epersongroup USING btree (name);


--
-- Name: epg2wi_workspace_fk_idx; Type: INDEX; Schema: public; Owner: funasauser
--

CREATE INDEX epg2wi_workspace_fk_idx ON public.epersongroup2workspaceitem USING btree (workspace_item_id);


--
-- Name: fe_bitstream_fk_idx; Type: INDEX; Schema: public; Owner: funasauser
--

CREATE INDEX fe_bitstream_fk_idx ON public.fileextension USING btree (bitstream_format_id);


--
-- Name: group2group_child; Type: INDEX; Schema: public; Owner: funasauser
--

CREATE INDEX group2group_child ON public.group2group USING btree (child_id);


--
-- Name: group2group_parent; Type: INDEX; Schema: public; Owner: funasauser
--

CREATE INDEX group2group_parent ON public.group2group USING btree (parent_id);


--
-- Name: group2groupcache_child; Type: INDEX; Schema: public; Owner: funasauser
--

CREATE INDEX group2groupcache_child ON public.group2groupcache USING btree (child_id);


--
-- Name: group2groupcache_parent; Type: INDEX; Schema: public; Owner: funasauser
--

CREATE INDEX group2groupcache_parent ON public.group2groupcache USING btree (parent_id);


--
-- Name: handle_handle_idx; Type: INDEX; Schema: public; Owner: funasauser
--

CREATE INDEX handle_handle_idx ON public.handle USING btree (handle);


--
-- Name: handle_object; Type: INDEX; Schema: public; Owner: funasauser
--

CREATE INDEX handle_object ON public.handle USING btree (resource_id);


--
-- Name: handle_resource_id_and_type_idx; Type: INDEX; Schema: public; Owner: funasauser
--

CREATE INDEX handle_resource_id_and_type_idx ON public.handle USING btree (resource_legacy_id, resource_type_id);


--
-- Name: harvested_collection_collection; Type: INDEX; Schema: public; Owner: funasauser
--

CREATE INDEX harvested_collection_collection ON public.harvested_collection USING btree (collection_id);


--
-- Name: harvested_item_item; Type: INDEX; Schema: public; Owner: funasauser
--

CREATE INDEX harvested_item_item ON public.harvested_item USING btree (item_id);


--
-- Name: item2bundle_bundle; Type: INDEX; Schema: public; Owner: funasauser
--

CREATE INDEX item2bundle_bundle ON public.item2bundle USING btree (bundle_id);


--
-- Name: item2bundle_item; Type: INDEX; Schema: public; Owner: funasauser
--

CREATE INDEX item2bundle_item ON public.item2bundle USING btree (item_id);


--
-- Name: item_collection; Type: INDEX; Schema: public; Owner: funasauser
--

CREATE INDEX item_collection ON public.item USING btree (owning_collection);


--
-- Name: item_id_idx; Type: INDEX; Schema: public; Owner: funasauser
--

CREATE INDEX item_id_idx ON public.item USING btree (item_id);


--
-- Name: item_submitter; Type: INDEX; Schema: public; Owner: funasauser
--

CREATE INDEX item_submitter ON public.item USING btree (submitter_id);


--
-- Name: metadatafield_schema_idx; Type: INDEX; Schema: public; Owner: funasauser
--

CREATE INDEX metadatafield_schema_idx ON public.metadatafieldregistry USING btree (metadata_schema_id);


--
-- Name: metadatafieldregistry_idx_element_qualifier; Type: INDEX; Schema: public; Owner: funasauser
--

CREATE INDEX metadatafieldregistry_idx_element_qualifier ON public.metadatafieldregistry USING btree (element, qualifier);


--
-- Name: metadataschemaregistry_unique_idx_short_id; Type: INDEX; Schema: public; Owner: funasauser
--

CREATE UNIQUE INDEX metadataschemaregistry_unique_idx_short_id ON public.metadataschemaregistry USING btree (short_id);


--
-- Name: metadatavalue_field_fk_idx; Type: INDEX; Schema: public; Owner: funasauser
--

CREATE INDEX metadatavalue_field_fk_idx ON public.metadatavalue USING btree (metadata_field_id);


--
-- Name: metadatavalue_field_object; Type: INDEX; Schema: public; Owner: funasauser
--

CREATE INDEX metadatavalue_field_object ON public.metadatavalue USING btree (metadata_field_id, dspace_object_id);


--
-- Name: metadatavalue_object; Type: INDEX; Schema: public; Owner: funasauser
--

CREATE INDEX metadatavalue_object ON public.metadatavalue USING btree (dspace_object_id);


--
-- Name: most_recent_checksum_bitstream; Type: INDEX; Schema: public; Owner: funasauser
--

CREATE INDEX most_recent_checksum_bitstream ON public.most_recent_checksum USING btree (bitstream_id);


--
-- Name: mrc_result_fk_idx; Type: INDEX; Schema: public; Owner: funasauser
--

CREATE INDEX mrc_result_fk_idx ON public.most_recent_checksum USING btree (result);


--
-- Name: requestitem_bitstream; Type: INDEX; Schema: public; Owner: funasauser
--

CREATE INDEX requestitem_bitstream ON public.requestitem USING btree (bitstream_id);


--
-- Name: requestitem_item; Type: INDEX; Schema: public; Owner: funasauser
--

CREATE INDEX requestitem_item ON public.requestitem USING btree (item_id);


--
-- Name: resourcepolicy_group; Type: INDEX; Schema: public; Owner: funasauser
--

CREATE INDEX resourcepolicy_group ON public.resourcepolicy USING btree (epersongroup_id);


--
-- Name: resourcepolicy_idx_rptype; Type: INDEX; Schema: public; Owner: funasauser
--

CREATE INDEX resourcepolicy_idx_rptype ON public.resourcepolicy USING btree (rptype);


--
-- Name: resourcepolicy_object; Type: INDEX; Schema: public; Owner: funasauser
--

CREATE INDEX resourcepolicy_object ON public.resourcepolicy USING btree (dspace_object);


--
-- Name: resourcepolicy_person; Type: INDEX; Schema: public; Owner: funasauser
--

CREATE INDEX resourcepolicy_person ON public.resourcepolicy USING btree (eperson_id);


--
-- Name: resourcepolicy_type_id_idx; Type: INDEX; Schema: public; Owner: funasauser
--

CREATE INDEX resourcepolicy_type_id_idx ON public.resourcepolicy USING btree (resource_type_id, resource_id);


--
-- Name: schema_version_s_idx; Type: INDEX; Schema: public; Owner: funasauser
--

CREATE INDEX schema_version_s_idx ON public.schema_version USING btree (success);


--
-- Name: subscription_collection; Type: INDEX; Schema: public; Owner: funasauser
--

CREATE INDEX subscription_collection ON public.subscription USING btree (collection_id);


--
-- Name: subscription_person; Type: INDEX; Schema: public; Owner: funasauser
--

CREATE INDEX subscription_person ON public.subscription USING btree (eperson_id);


--
-- Name: tasklist_workflow_fk_idx; Type: INDEX; Schema: public; Owner: funasauser
--

CREATE INDEX tasklist_workflow_fk_idx ON public.tasklistitem USING btree (workflow_id);


--
-- Name: versionitem_item; Type: INDEX; Schema: public; Owner: funasauser
--

CREATE INDEX versionitem_item ON public.versionitem USING btree (item_id);


--
-- Name: versionitem_person; Type: INDEX; Schema: public; Owner: funasauser
--

CREATE INDEX versionitem_person ON public.versionitem USING btree (eperson_id);


--
-- Name: workspaceitem_coll; Type: INDEX; Schema: public; Owner: funasauser
--

CREATE INDEX workspaceitem_coll ON public.workspaceitem USING btree (collection_id);


--
-- Name: workspaceitem_item; Type: INDEX; Schema: public; Owner: funasauser
--

CREATE INDEX workspaceitem_item ON public.workspaceitem USING btree (item_id);


--
-- Name: bitstream bitstream_bitstream_format_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.bitstream
    ADD CONSTRAINT bitstream_bitstream_format_id_fkey FOREIGN KEY (bitstream_format_id) REFERENCES public.bitstreamformatregistry(bitstream_format_id);


--
-- Name: bitstream bitstream_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.bitstream
    ADD CONSTRAINT bitstream_uuid_fkey FOREIGN KEY (uuid) REFERENCES public.dspaceobject(uuid);


--
-- Name: bundle2bitstream bundle2bitstream_bitstream_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.bundle2bitstream
    ADD CONSTRAINT bundle2bitstream_bitstream_id_fkey FOREIGN KEY (bitstream_id) REFERENCES public.bitstream(uuid);


--
-- Name: bundle2bitstream bundle2bitstream_bundle_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.bundle2bitstream
    ADD CONSTRAINT bundle2bitstream_bundle_id_fkey FOREIGN KEY (bundle_id) REFERENCES public.bundle(uuid);


--
-- Name: bundle bundle_primary_bitstream_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.bundle
    ADD CONSTRAINT bundle_primary_bitstream_id_fkey FOREIGN KEY (primary_bitstream_id) REFERENCES public.bitstream(uuid);


--
-- Name: bundle bundle_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.bundle
    ADD CONSTRAINT bundle_uuid_fkey FOREIGN KEY (uuid) REFERENCES public.dspaceobject(uuid);


--
-- Name: checksum_history checksum_history_bitstream_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.checksum_history
    ADD CONSTRAINT checksum_history_bitstream_id_fkey FOREIGN KEY (bitstream_id) REFERENCES public.bitstream(uuid);


--
-- Name: checksum_history checksum_history_result_fkey; Type: FK CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.checksum_history
    ADD CONSTRAINT checksum_history_result_fkey FOREIGN KEY (result) REFERENCES public.checksum_results(result_code);


--
-- Name: collection2item collection2item_collection_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.collection2item
    ADD CONSTRAINT collection2item_collection_id_fkey FOREIGN KEY (collection_id) REFERENCES public.collection(uuid);


--
-- Name: collection2item collection2item_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.collection2item
    ADD CONSTRAINT collection2item_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.item(uuid);


--
-- Name: collection collection_admin_fkey; Type: FK CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.collection
    ADD CONSTRAINT collection_admin_fkey FOREIGN KEY (admin) REFERENCES public.epersongroup(uuid);


--
-- Name: collection collection_submitter_fkey; Type: FK CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.collection
    ADD CONSTRAINT collection_submitter_fkey FOREIGN KEY (submitter) REFERENCES public.epersongroup(uuid);


--
-- Name: collection collection_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.collection
    ADD CONSTRAINT collection_uuid_fkey FOREIGN KEY (uuid) REFERENCES public.dspaceobject(uuid);


--
-- Name: collection collection_workflow_step_1_fkey; Type: FK CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.collection
    ADD CONSTRAINT collection_workflow_step_1_fkey FOREIGN KEY (workflow_step_1) REFERENCES public.epersongroup(uuid);


--
-- Name: collection collection_workflow_step_2_fkey; Type: FK CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.collection
    ADD CONSTRAINT collection_workflow_step_2_fkey FOREIGN KEY (workflow_step_2) REFERENCES public.epersongroup(uuid);


--
-- Name: collection collection_workflow_step_3_fkey; Type: FK CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.collection
    ADD CONSTRAINT collection_workflow_step_3_fkey FOREIGN KEY (workflow_step_3) REFERENCES public.epersongroup(uuid);


--
-- Name: community2collection community2collection_collection_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.community2collection
    ADD CONSTRAINT community2collection_collection_id_fkey FOREIGN KEY (collection_id) REFERENCES public.collection(uuid);


--
-- Name: community2collection community2collection_community_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.community2collection
    ADD CONSTRAINT community2collection_community_id_fkey FOREIGN KEY (community_id) REFERENCES public.community(uuid);


--
-- Name: community2community community2community_child_comm_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.community2community
    ADD CONSTRAINT community2community_child_comm_id_fkey FOREIGN KEY (child_comm_id) REFERENCES public.community(uuid);


--
-- Name: community2community community2community_parent_comm_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.community2community
    ADD CONSTRAINT community2community_parent_comm_id_fkey FOREIGN KEY (parent_comm_id) REFERENCES public.community(uuid);


--
-- Name: community community_admin_fkey; Type: FK CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.community
    ADD CONSTRAINT community_admin_fkey FOREIGN KEY (admin) REFERENCES public.epersongroup(uuid);


--
-- Name: community community_logo_bitstream_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.community
    ADD CONSTRAINT community_logo_bitstream_id_fkey FOREIGN KEY (logo_bitstream_id) REFERENCES public.bitstream(uuid);


--
-- Name: community community_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.community
    ADD CONSTRAINT community_uuid_fkey FOREIGN KEY (uuid) REFERENCES public.dspaceobject(uuid);


--
-- Name: doi doi_dspace_object_fkey; Type: FK CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.doi
    ADD CONSTRAINT doi_dspace_object_fkey FOREIGN KEY (dspace_object) REFERENCES public.dspaceobject(uuid);


--
-- Name: eperson eperson_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.eperson
    ADD CONSTRAINT eperson_uuid_fkey FOREIGN KEY (uuid) REFERENCES public.dspaceobject(uuid);


--
-- Name: epersongroup2eperson epersongroup2eperson_eperson_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.epersongroup2eperson
    ADD CONSTRAINT epersongroup2eperson_eperson_group_id_fkey FOREIGN KEY (eperson_group_id) REFERENCES public.epersongroup(uuid);


--
-- Name: epersongroup2eperson epersongroup2eperson_eperson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.epersongroup2eperson
    ADD CONSTRAINT epersongroup2eperson_eperson_id_fkey FOREIGN KEY (eperson_id) REFERENCES public.eperson(uuid);


--
-- Name: epersongroup2workspaceitem epersongroup2workspaceitem_eperson_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.epersongroup2workspaceitem
    ADD CONSTRAINT epersongroup2workspaceitem_eperson_group_id_fkey FOREIGN KEY (eperson_group_id) REFERENCES public.epersongroup(uuid);


--
-- Name: epersongroup2workspaceitem epersongroup2workspaceitem_workspace_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.epersongroup2workspaceitem
    ADD CONSTRAINT epersongroup2workspaceitem_workspace_item_id_fkey FOREIGN KEY (workspace_item_id) REFERENCES public.workspaceitem(workspace_item_id);


--
-- Name: epersongroup epersongroup_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.epersongroup
    ADD CONSTRAINT epersongroup_uuid_fkey FOREIGN KEY (uuid) REFERENCES public.dspaceobject(uuid);


--
-- Name: fileextension fileextension_bitstream_format_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.fileextension
    ADD CONSTRAINT fileextension_bitstream_format_id_fkey FOREIGN KEY (bitstream_format_id) REFERENCES public.bitstreamformatregistry(bitstream_format_id);


--
-- Name: group2group group2group_child_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.group2group
    ADD CONSTRAINT group2group_child_id_fkey FOREIGN KEY (child_id) REFERENCES public.epersongroup(uuid);


--
-- Name: group2group group2group_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.group2group
    ADD CONSTRAINT group2group_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.epersongroup(uuid);


--
-- Name: group2groupcache group2groupcache_child_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.group2groupcache
    ADD CONSTRAINT group2groupcache_child_id_fkey FOREIGN KEY (child_id) REFERENCES public.epersongroup(uuid);


--
-- Name: group2groupcache group2groupcache_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.group2groupcache
    ADD CONSTRAINT group2groupcache_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.epersongroup(uuid);


--
-- Name: handle handle_resource_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.handle
    ADD CONSTRAINT handle_resource_id_fkey FOREIGN KEY (resource_id) REFERENCES public.dspaceobject(uuid);


--
-- Name: harvested_collection harvested_collection_collection_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.harvested_collection
    ADD CONSTRAINT harvested_collection_collection_id_fkey FOREIGN KEY (collection_id) REFERENCES public.collection(uuid);


--
-- Name: harvested_item harvested_item_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.harvested_item
    ADD CONSTRAINT harvested_item_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.item(uuid);


--
-- Name: item2bundle item2bundle_bundle_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.item2bundle
    ADD CONSTRAINT item2bundle_bundle_id_fkey FOREIGN KEY (bundle_id) REFERENCES public.bundle(uuid);


--
-- Name: item2bundle item2bundle_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.item2bundle
    ADD CONSTRAINT item2bundle_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.item(uuid);


--
-- Name: item item_owning_collection_fkey; Type: FK CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.item
    ADD CONSTRAINT item_owning_collection_fkey FOREIGN KEY (owning_collection) REFERENCES public.collection(uuid);


--
-- Name: item item_submitter_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.item
    ADD CONSTRAINT item_submitter_id_fkey FOREIGN KEY (submitter_id) REFERENCES public.eperson(uuid);


--
-- Name: item item_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.item
    ADD CONSTRAINT item_uuid_fkey FOREIGN KEY (uuid) REFERENCES public.dspaceobject(uuid);


--
-- Name: metadatafieldregistry metadatafieldregistry_metadata_schema_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.metadatafieldregistry
    ADD CONSTRAINT metadatafieldregistry_metadata_schema_id_fkey FOREIGN KEY (metadata_schema_id) REFERENCES public.metadataschemaregistry(metadata_schema_id);


--
-- Name: metadatavalue metadatavalue_dspace_object_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.metadatavalue
    ADD CONSTRAINT metadatavalue_dspace_object_id_fkey FOREIGN KEY (dspace_object_id) REFERENCES public.dspaceobject(uuid) ON DELETE CASCADE;


--
-- Name: metadatavalue metadatavalue_metadata_field_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.metadatavalue
    ADD CONSTRAINT metadatavalue_metadata_field_id_fkey FOREIGN KEY (metadata_field_id) REFERENCES public.metadatafieldregistry(metadata_field_id);


--
-- Name: most_recent_checksum most_recent_checksum_bitstream_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.most_recent_checksum
    ADD CONSTRAINT most_recent_checksum_bitstream_id_fkey FOREIGN KEY (bitstream_id) REFERENCES public.bitstream(uuid);


--
-- Name: most_recent_checksum most_recent_checksum_result_fkey; Type: FK CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.most_recent_checksum
    ADD CONSTRAINT most_recent_checksum_result_fkey FOREIGN KEY (result) REFERENCES public.checksum_results(result_code);


--
-- Name: requestitem requestitem_bitstream_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.requestitem
    ADD CONSTRAINT requestitem_bitstream_id_fkey FOREIGN KEY (bitstream_id) REFERENCES public.bitstream(uuid);


--
-- Name: requestitem requestitem_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.requestitem
    ADD CONSTRAINT requestitem_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.item(uuid);


--
-- Name: resourcepolicy resourcepolicy_dspace_object_fkey; Type: FK CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.resourcepolicy
    ADD CONSTRAINT resourcepolicy_dspace_object_fkey FOREIGN KEY (dspace_object) REFERENCES public.dspaceobject(uuid) ON DELETE CASCADE;


--
-- Name: resourcepolicy resourcepolicy_eperson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.resourcepolicy
    ADD CONSTRAINT resourcepolicy_eperson_id_fkey FOREIGN KEY (eperson_id) REFERENCES public.eperson(uuid);


--
-- Name: resourcepolicy resourcepolicy_epersongroup_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.resourcepolicy
    ADD CONSTRAINT resourcepolicy_epersongroup_id_fkey FOREIGN KEY (epersongroup_id) REFERENCES public.epersongroup(uuid);


--
-- Name: site site_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.site
    ADD CONSTRAINT site_uuid_fkey FOREIGN KEY (uuid) REFERENCES public.dspaceobject(uuid);


--
-- Name: subscription subscription_collection_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.subscription
    ADD CONSTRAINT subscription_collection_id_fkey FOREIGN KEY (collection_id) REFERENCES public.collection(uuid);


--
-- Name: subscription subscription_eperson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.subscription
    ADD CONSTRAINT subscription_eperson_id_fkey FOREIGN KEY (eperson_id) REFERENCES public.eperson(uuid);


--
-- Name: tasklistitem tasklistitem_eperson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.tasklistitem
    ADD CONSTRAINT tasklistitem_eperson_id_fkey FOREIGN KEY (eperson_id) REFERENCES public.eperson(uuid);


--
-- Name: tasklistitem tasklistitem_workflow_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.tasklistitem
    ADD CONSTRAINT tasklistitem_workflow_id_fkey FOREIGN KEY (workflow_id) REFERENCES public.workflowitem(workflow_id);


--
-- Name: versionitem versionitem_eperson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.versionitem
    ADD CONSTRAINT versionitem_eperson_id_fkey FOREIGN KEY (eperson_id) REFERENCES public.eperson(uuid);


--
-- Name: versionitem versionitem_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.versionitem
    ADD CONSTRAINT versionitem_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.item(uuid);


--
-- Name: versionitem versionitem_versionhistory_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.versionitem
    ADD CONSTRAINT versionitem_versionhistory_id_fkey FOREIGN KEY (versionhistory_id) REFERENCES public.versionhistory(versionhistory_id);


--
-- Name: workflowitem workflowitem_collection_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.workflowitem
    ADD CONSTRAINT workflowitem_collection_id_fkey FOREIGN KEY (collection_id) REFERENCES public.collection(uuid);


--
-- Name: workflowitem workflowitem_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.workflowitem
    ADD CONSTRAINT workflowitem_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.item(uuid);


--
-- Name: workflowitem workflowitem_owner_fkey; Type: FK CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.workflowitem
    ADD CONSTRAINT workflowitem_owner_fkey FOREIGN KEY (owner) REFERENCES public.eperson(uuid);


--
-- Name: workspaceitem workspaceitem_collection_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.workspaceitem
    ADD CONSTRAINT workspaceitem_collection_id_fk FOREIGN KEY (collection_id) REFERENCES public.collection(uuid);


--
-- Name: workspaceitem workspaceitem_collection_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.workspaceitem
    ADD CONSTRAINT workspaceitem_collection_id_fkey FOREIGN KEY (collection_id) REFERENCES public.collection(uuid);


--
-- Name: workspaceitem workspaceitem_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: funasauser
--

ALTER TABLE ONLY public.workspaceitem
    ADD CONSTRAINT workspaceitem_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.item(uuid);


--
-- PostgreSQL database dump complete
--

