--
-- PostgreSQL database dump
--

\restrict D2ddzN0uzTWIE8aKe0rZtvJaGXjbreCcuXV9WEyUETwYlZl6QeSxd9tbCnm3Gmj

-- Dumped from database version 18.3
-- Dumped by pg_dump version 18.3

-- Started on 2026-08-23 09:17:39

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 219 (class 1259 OID 16389)
-- Name: cache; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cache (
    key character varying(255) NOT NULL,
    value text NOT NULL,
    expiration bigint NOT NULL
);


ALTER TABLE public.cache OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16397)
-- Name: cache_locks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cache_locks (
    key character varying(255) NOT NULL,
    owner character varying(255) NOT NULL,
    expiration bigint NOT NULL
);


ALTER TABLE public.cache_locks OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16405)
-- Name: migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.migrations (
    id integer NOT NULL,
    migration character varying(255) NOT NULL,
    batch integer NOT NULL
);


ALTER TABLE public.migrations OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16411)
-- Name: migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.migrations_id_seq OWNER TO postgres;

--
-- TOC entry 4950 (class 0 OID 0)
-- Dependencies: 222
-- Name: migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.migrations_id_seq OWNED BY public.migrations.id;


--
-- TOC entry 223 (class 1259 OID 16412)
-- Name: personal_access_tokens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.personal_access_tokens (
    id bigint NOT NULL,
    tokenable_type character varying(255) NOT NULL,
    tokenable_id bigint NOT NULL,
    name text NOT NULL,
    token character varying(64) NOT NULL,
    abilities text,
    last_used_at timestamp(0) without time zone,
    expires_at timestamp(0) without time zone,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.personal_access_tokens OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 16422)
-- Name: personal_access_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.personal_access_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.personal_access_tokens_id_seq OWNER TO postgres;

--
-- TOC entry 4951 (class 0 OID 0)
-- Dependencies: 224
-- Name: personal_access_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.personal_access_tokens_id_seq OWNED BY public.personal_access_tokens.id;


--
-- TOC entry 225 (class 1259 OID 16423)
-- Name: points; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.points (
    id bigint NOT NULL,
    siswa_id bigint NOT NULL,
    tanggal date NOT NULL,
    deskripsi character varying(255) NOT NULL,
    kategori character varying(255) NOT NULL,
    point_positif integer DEFAULT 0 NOT NULL,
    point_negatif integer DEFAULT 0 NOT NULL,
    input_by bigint NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.points OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 16438)
-- Name: points_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.points_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.points_id_seq OWNER TO postgres;

--
-- TOC entry 4952 (class 0 OID 0)
-- Dependencies: 226
-- Name: points_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.points_id_seq OWNED BY public.points.id;


--
-- TOC entry 227 (class 1259 OID 16439)
-- Name: siswa; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.siswa (
    id bigint NOT NULL,
    nama_siswa character varying(255) NOT NULL,
    kelas smallint NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.siswa OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 16445)
-- Name: siswa_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.siswa_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.siswa_id_seq OWNER TO postgres;

--
-- TOC entry 4953 (class 0 OID 0)
-- Dependencies: 228
-- Name: siswa_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.siswa_id_seq OWNED BY public.siswa.id;


--
-- TOC entry 229 (class 1259 OID 16446)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    username character varying(255) NOT NULL,
    password character varying(255) NOT NULL,
    role character varying(255) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 16455)
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- TOC entry 4954 (class 0 OID 0)
-- Dependencies: 230
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- TOC entry 4753 (class 2604 OID 16456)
-- Name: migrations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.migrations ALTER COLUMN id SET DEFAULT nextval('public.migrations_id_seq'::regclass);


--
-- TOC entry 4754 (class 2604 OID 16457)
-- Name: personal_access_tokens id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personal_access_tokens ALTER COLUMN id SET DEFAULT nextval('public.personal_access_tokens_id_seq'::regclass);


--
-- TOC entry 4755 (class 2604 OID 16458)
-- Name: points id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.points ALTER COLUMN id SET DEFAULT nextval('public.points_id_seq'::regclass);


--
-- TOC entry 4758 (class 2604 OID 16459)
-- Name: siswa id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.siswa ALTER COLUMN id SET DEFAULT nextval('public.siswa_id_seq'::regclass);


--
-- TOC entry 4759 (class 2604 OID 16460)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 4933 (class 0 OID 16389)
-- Dependencies: 219
-- Data for Name: cache; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4934 (class 0 OID 16397)
-- Dependencies: 220
-- Data for Name: cache_locks; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4935 (class 0 OID 16405)
-- Dependencies: 221
-- Data for Name: migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.migrations (id, migration, batch) VALUES (1, '2026_01_01_000001_create_users_table', 1);
INSERT INTO public.migrations (id, migration, batch) VALUES (2, '2026_01_01_000002_create_siswa_table', 1);
INSERT INTO public.migrations (id, migration, batch) VALUES (3, '2026_01_01_000003_create_points_table', 1);
INSERT INTO public.migrations (id, migration, batch) VALUES (4, '2019_12_14_000001_create_personal_access_tokens_table', 2);
INSERT INTO public.migrations (id, migration, batch) VALUES (5, '2026_05_06_164452_create_cache_table', 3);


--
-- TOC entry 4937 (class 0 OID 16412)
-- Dependencies: 223
-- Data for Name: personal_access_tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (1, 'App\Models\User', 1, 'auth-token', '52bd6d779b42afabf3afd24d6a4f31b270aacb79abf9768b81686cd743752f65', '["*"]', NULL, NULL, '2026-05-06 16:45:56', '2026-05-06 16:45:56');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (2, 'App\Models\User', 2, 'auth-token', 'ec4b5b4c1a9bd7c7da6a7b83f1e212143fedb566278d0f5baa518d4f29e543bb', '["*"]', '2026-05-06 16:46:25', NULL, '2026-05-06 16:46:12', '2026-05-06 16:46:25');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (3, 'App\Models\User', 1, 'auth-token', '19100e666a10de065163f2250c4b9be7373308b8530ce6792a9f8509f84de19e', '["*"]', NULL, NULL, '2026-05-06 16:46:33', '2026-05-06 16:46:33');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (6, 'App\Models\User', 1, 'auth-token', 'b63bec5b112239d884364a4d29e33375cb8aeaa278acb6995dae90c7dafabe96', '["*"]', '2026-05-06 20:56:59', NULL, '2026-05-06 20:52:01', '2026-05-06 20:56:59');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (4, 'App\Models\User', 1, 'auth-token', 'c2fc7f4f0967170167297d9eb5b09f74ba51928e2a4998e03ea750a41f4f3dce', '["*"]', '2026-05-06 20:47:39', NULL, '2026-05-06 16:46:34', '2026-05-06 20:47:39');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (8, 'App\Models\User', 3, 'auth-token', 'd4e8cc0ef282e79c93b851ef527a2054aec22c1ee363148c074eb9dcef0901c3', '["*"]', '2026-05-06 21:03:24', NULL, '2026-05-06 21:00:01', '2026-05-06 21:03:24');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (10, 'App\Models\User', 3, 'auth-token', 'fd8990964dabfea5c8cb469318d354ad0ed41862245445a93579f61f04a79881', '["*"]', '2026-05-07 06:51:22', NULL, '2026-05-06 21:16:23', '2026-05-07 06:51:22');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (7, 'App\Models\User', 1, 'auth-token', '8efafedd002a0395c0006e6828875efda06d94bb96389f25ac64b3367f059aa1', '["*"]', '2026-05-06 20:59:50', NULL, '2026-05-06 20:58:42', '2026-05-06 20:59:50');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (5, 'App\Models\User', 1, 'auth-token', '247e4b97c8cc32a985dcc82d1c33463ea21cee6a2f136081c7c55bbe03a60f0f', '["*"]', '2026-05-06 20:51:48', NULL, '2026-05-06 20:47:51', '2026-05-06 20:51:48');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (9, 'App\Models\User', 3, 'auth-token', '5c755dc4ece4f831b5c6a02e6c276ccc2782692b8ed4f7d087a3e09b44a1fea5', '["*"]', '2026-05-06 21:16:14', NULL, '2026-05-06 21:03:52', '2026-05-06 21:16:14');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (12, 'App\Models\User', 3, 'auth-token', '70ecf2132d6a5042bb7b3e7e72d56402738b655367d1757d0c9f41f4649c1b1c', '["*"]', NULL, NULL, '2026-05-07 14:06:29', '2026-05-07 14:06:29');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (11, 'App\Models\User', 3, 'auth-token', '1236f8f2cafab2faea2805b5490448a2d1480a3901f19a5884d85f5154596290', '["*"]', '2026-05-07 14:06:30', NULL, '2026-05-07 14:06:26', '2026-05-07 14:06:30');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (14, 'App\Models\User', 3, 'auth-token', 'a8701c54247c70d8b2f16586f2770d5a4a9c0163038e20bf3ac900ae47fb0c6d', '["*"]', '2026-05-07 14:16:58', NULL, '2026-05-07 14:16:55', '2026-05-07 14:16:58');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (16, 'App\Models\User', 3, 'auth-token', '92a119ade24c923bc645744f6ff024a64148e4b8ebfa39bd4c008d523590ed23', '["*"]', '2026-05-08 09:47:12', NULL, '2026-05-07 14:34:44', '2026-05-08 09:47:12');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (15, 'App\Models\User', 3, 'auth-token', 'a261a59599a468a6f44b179fe416503e0fc5db2baf1a7e7e45adda6e18928736', '["*"]', '2026-05-07 14:34:30', NULL, '2026-05-07 14:34:28', '2026-05-07 14:34:30');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (17, 'App\Models\User', 3, 'auth-token', 'ab5925071e58ae6be41cb2408e9244c3bd87edd7a796b3bbc217d505c1ed4a85', '["*"]', '2026-05-08 10:23:26', NULL, '2026-05-08 10:23:25', '2026-05-08 10:23:26');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (23, 'App\Models\User', 3, 'auth-token', '59fa7df399ecaeadff4cb15d134a3ce6d6d3a4f1f8b423527b300487a23f9c76', '["*"]', '2026-05-10 21:26:21', NULL, '2026-05-09 19:11:22', '2026-05-10 21:26:21');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (18, 'App\Models\User', 3, 'auth-token', '471bff20e8403113e5d1764c99548777b68fbeabb2d2645bbfe1277a75546d42', '["*"]', '2026-05-08 10:23:39', NULL, '2026-05-08 10:23:26', '2026-05-08 10:23:39');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (19, 'App\Models\User', 3, 'auth-token', '23d5930b6a47d1f4e2c2aad64cbc97f87ea863bc431614c7366931ad63942104', '["*"]', '2026-05-09 18:26:28', NULL, '2026-05-09 18:26:25', '2026-05-09 18:26:28');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (25, 'App\Models\User', 3, 'auth-token', '3f1d86bf0c8739985b3319e7e3c992e8da13d02fbe3447afe8b77f30732cb527', '["*"]', NULL, NULL, '2026-05-11 15:54:58', '2026-05-11 15:54:58');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (26, 'App\Models\User', 3, 'auth-token', '4f1330480cf5dd79bd84e6abb8d78c88c744c6f8034afd4e2097709ac5182002', '["*"]', NULL, NULL, '2026-05-11 15:54:59', '2026-05-11 15:54:59');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (27, 'App\Models\User', 3, 'auth-token', 'fac2126c0c56a2d4eca168631c20d4edb0e98f54aa4a22020e97bb94952c0828', '["*"]', NULL, NULL, '2026-05-11 15:55:00', '2026-05-11 15:55:00');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (28, 'App\Models\User', 3, 'auth-token', '2bf69d2b7faf251443cddc7cf87bc863974bb9fb29ef0983d7f7021848ef853c', '["*"]', NULL, NULL, '2026-05-11 15:55:01', '2026-05-11 15:55:01');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (29, 'App\Models\User', 3, 'auth-token', '5c97a3cdaebbe355a4e3736fdb29fe9017ed6461989b64958c12db6251db9c35', '["*"]', NULL, NULL, '2026-05-11 15:55:02', '2026-05-11 15:55:02');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (20, 'App\Models\User', 3, 'auth-token', 'e5d3357a590b890b9da2b2627c884816c49a42d0727d5ef29663cd11955d7155', '["*"]', '2026-05-09 19:43:06', NULL, '2026-05-09 18:26:27', '2026-05-09 19:43:06');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (30, 'App\Models\User', 3, 'auth-token', 'b0b04e8801b7857bc2833990efaf42111b2418981139dcac993944ee5d6671d5', '["*"]', NULL, NULL, '2026-05-11 15:55:03', '2026-05-11 15:55:03');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (21, 'App\Models\User', 3, 'auth-token', '4dccba5577a01a97214219bd434e7d07448a90a1b9bb0b082e24d18e664bc165', '["*"]', '2026-05-09 18:46:25', NULL, '2026-05-09 18:46:24', '2026-05-09 18:46:25');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (24, 'App\Models\User', 3, 'auth-token', '39ead2d7e9f43a512179a17f510db666969aacdbdeca3f80bcafe1ec01e5055d', '["*"]', '2026-05-10 20:43:02', NULL, '2026-05-10 20:43:01', '2026-05-10 20:43:02');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (22, 'App\Models\User', 4, 'auth-token', 'b0cd7971252be77abb0400c221f31fe46d1e96cab078e92449513cfd98777c9f', '["*"]', '2026-05-09 19:10:49', NULL, '2026-05-09 19:10:48', '2026-05-09 19:10:49');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (13, 'App\Models\User', 3, 'auth-token', '2ea86c8df48284aa25e3ed757861825ed9507195922199220a4e4dcf7f1937af', '["*"]', '2026-05-07 14:16:43', NULL, '2026-05-07 14:06:55', '2026-05-07 14:16:43');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (31, 'App\Models\User', 3, 'auth-token', 'c13e43fd1b01209bee93d4924d0bd34e7009a30d9bc5ea5230c9324837679519', '["*"]', NULL, NULL, '2026-05-11 15:55:04', '2026-05-11 15:55:04');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (32, 'App\Models\User', 3, 'auth-token', 'c301b1705d46748e4107f7c1faffd23e39a70d68e263d3be907c2408fbc1f6df', '["*"]', NULL, NULL, '2026-05-11 15:55:05', '2026-05-11 15:55:05');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (33, 'App\Models\User', 3, 'auth-token', '133bf55a670ce49da9efead833795431c19754987a583da729579eb28b21cc32', '["*"]', NULL, NULL, '2026-05-11 15:55:06', '2026-05-11 15:55:06');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (35, 'App\Models\User', 3, 'auth-token', '6f262cc9bb5053ac46d2ba4ca0db2eb07e8c97faab3b5a691a4becf4d3a8b9be', '["*"]', '2026-05-11 17:16:46', NULL, '2026-05-11 17:15:58', '2026-05-11 17:16:46');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (36, 'App\Models\User', 1, 'auth-token', 'ceba23705f16e364730ff9c8db05e2915eeb7455ab16a1297c9bc731c15bf229', '["*"]', '2026-05-11 17:18:34', NULL, '2026-05-11 17:18:31', '2026-05-11 17:18:34');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (39, 'App\Models\User', 4, 'auth-token', '9ec1c0122e00195c0ebc0a803b7f7380fe6ff0be7fff8f0a5e2ae70314ee33f3', '["*"]', '2026-05-11 21:01:44', NULL, '2026-05-11 21:01:44', '2026-05-11 21:01:44');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (37, 'App\Models\User', 1, 'auth-token', '5189094e05c43cedf394437481638a01858b691ad0d1c2546ce01385516a871c', '["*"]', '2026-05-11 21:00:42', NULL, '2026-05-11 20:59:35', '2026-05-11 21:00:42');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (34, 'App\Models\User', 3, 'auth-token', 'cb38831b32a298c3ca8d51345868a6a743c09e706c1463fec6d7b4a419f6e3db', '["*"]', '2026-05-11 20:59:22', NULL, '2026-05-11 15:55:07', '2026-05-11 20:59:22');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (38, 'App\Models\User', 3, 'auth-token', 'f14e31e8a00403e192f89e9ab33923144741d7134789ccaa36b4cede01bb333b', '["*"]', '2026-05-11 21:01:22', NULL, '2026-05-11 21:01:22', '2026-05-11 21:01:22');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (40, 'App\Models\User', 6, 'auth-token', '4c148cfc5a1836a064fd50a8708b3df1497c92cc0acb06c80690312fecd0f012', '["*"]', '2026-05-11 21:01:58', NULL, '2026-05-11 21:01:57', '2026-05-11 21:01:58');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (41, 'App\Models\User', 5, 'auth-token', '3eca023fc766438ba355fea26743216233a444c2cbca25e9a306f7f26517d8cf', '["*"]', '2026-05-11 21:02:21', NULL, '2026-05-11 21:02:20', '2026-05-11 21:02:21');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (42, 'App\Models\User', 1, 'auth-token', 'ebc958fef384b2dd1b07736c847f984987842d5f5e38a3de96ceb091f04dcc68', '["*"]', '2026-05-12 20:40:43', NULL, '2026-05-11 21:02:57', '2026-05-12 20:40:43');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (44, 'App\Models\User', 4, 'auth-token', 'db6a67641013a49789ceffd154f7656e0dcb4e64c19b544307e86aa90f5ab455', '["*"]', '2026-05-12 19:51:07', NULL, '2026-05-12 19:51:07', '2026-05-12 19:51:07');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (43, 'App\Models\User', 1, 'auth-token', '7571e99c2f3744fb93967036ace461bdab9ffec9a8784b85abf2ef0cf3a4137c', '["*"]', '2026-05-12 19:50:52', NULL, '2026-05-12 19:50:36', '2026-05-12 19:50:52');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (76, 'App\Models\User', 5, 'auth-token', '1bfc5f5c5f87ac403d12f6646d4e5802f2a6b4dba324223b8370766f5f544e25', '["*"]', '2026-05-16 15:54:04', NULL, '2026-05-16 15:54:02', '2026-05-16 15:54:04');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (45, 'App\Models\User', 1, 'auth-token', '114b277015714a719bf3a509b17f9df80c66f7cf94fbe8838342d38397d8d331', '["*"]', '2026-05-12 19:52:06', NULL, '2026-05-12 19:51:47', '2026-05-12 19:52:06');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (46, 'App\Models\User', 6, 'auth-token', '9518ed4f42f2876f58d60fb57be222c725f47ced7f82870bea089940954a7ba2', '["*"]', '2026-05-12 19:52:21', NULL, '2026-05-12 19:52:20', '2026-05-12 19:52:21');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (47, 'App\Models\User', 4, 'auth-token', '8ab9886e5a7d4171e29794f60890428262cf3e3098d86359f068e59615a4d1b1', '["*"]', '2026-05-12 19:52:33', NULL, '2026-05-12 19:52:32', '2026-05-12 19:52:33');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (70, 'App\Models\User', 1, 'auth-token', '1454cac99b832164bcc947c76f0e96fb8993a60c41af8b50f791c25a4fa9e186', '["*"]', '2026-05-14 19:45:01', NULL, '2026-05-14 19:42:46', '2026-05-14 19:45:01');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (72, 'App\Models\User', 5, 'auth-token', '68f8f1050b60def97a7e10c2a8322947eaa5e8852065a903f82c17b97fd563e4', '["*"]', NULL, NULL, '2026-05-14 19:45:18', '2026-05-14 19:45:18');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (73, 'App\Models\User', 5, 'auth-token', '6a0e12c471dbc9b368a4d1a306dba19fa8011ae43f6626fcad60e7dbbfa3bad3', '["*"]', NULL, NULL, '2026-05-14 19:45:19', '2026-05-14 19:45:19');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (71, 'App\Models\User', 5, 'auth-token', '691d1451725d4c12b9e92d04da281b10aac5ccb5504c5dd8d3b82bc0b9c327fe', '["*"]', '2026-05-14 19:45:21', NULL, '2026-05-14 19:45:17', '2026-05-14 19:45:21');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (81, 'App\Models\User', 5, 'auth-token', '4d5f0166a0be60ec9c5df8d6d7b46bf88e4167780a3c884e953b2948e44872b6', '["*"]', '2026-05-17 19:23:05', NULL, '2026-05-17 19:23:02', '2026-05-17 19:23:05');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (83, 'App\Models\User', 1, 'auth-token', '4dd4a3405d840329790cf92281d7a9b82431a575d0a3986ea79a4f209c3e0e08', '["*"]', '2026-05-18 09:08:39', NULL, '2026-05-18 09:08:19', '2026-05-18 09:08:39');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (85, 'App\Models\User', 7, 'auth-token', 'd1ba0954b4052982ad9238b5d567b376f988a16eef19a2b31c3323fbe4b4b68e', '["*"]', '2026-05-18 09:15:54', NULL, '2026-05-18 09:15:18', '2026-05-18 09:15:54');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (48, 'App\Models\User', 4, 'auth-token', '64d46adb177340d4eb71ac54b6ffdf4129ae83bc2f5ada9af754b233ed721882', '["*"]', '2026-05-12 20:38:37', NULL, '2026-05-12 19:53:07', '2026-05-12 20:38:37');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (49, 'App\Models\User', 6, 'auth-token', 'd07c6eb9eff8c97b9c0aa26be947b745b3cb7629a2a2157a3523a66e75120e3b', '["*"]', '2026-05-12 20:39:11', NULL, '2026-05-12 20:39:10', '2026-05-12 20:39:11');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (50, 'App\Models\User', 1, 'auth-token', '2e2a3efa1c9aca3fcb8b454294fc83fd95fb5a7ec8dac2cf2a4ff10cbc5578e2', '["*"]', '2026-05-12 20:41:03', NULL, '2026-05-12 20:41:00', '2026-05-12 20:41:03');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (51, 'App\Models\User', 1, 'auth-token', '1f5812dc1fe9ab041145d6be90abfedc4535fcc98646886c8535d788d58edeb7', '["*"]', NULL, NULL, '2026-05-14 19:42:28', '2026-05-14 19:42:28');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (52, 'App\Models\User', 1, 'auth-token', 'd0d41817d0979836e91251d501a8593d960147a9aee9fa430b3b64ac3db4a6fc', '["*"]', NULL, NULL, '2026-05-14 19:42:30', '2026-05-14 19:42:30');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (53, 'App\Models\User', 1, 'auth-token', 'f9d50cb05935711d26fa7b6816c80f4d89e351a738c093d153011182f016f8a1', '["*"]', NULL, NULL, '2026-05-14 19:42:31', '2026-05-14 19:42:31');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (54, 'App\Models\User', 1, 'auth-token', '362593853d559b6f483a2f80a8ecfc29e5ff39da690b3c77c599f0a06a5cd7dd', '["*"]', NULL, NULL, '2026-05-14 19:42:32', '2026-05-14 19:42:32');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (55, 'App\Models\User', 1, 'auth-token', 'e840875efc5f5ab951842bfdb9a42039149e7df16c4a3910000db42e217abd19', '["*"]', NULL, NULL, '2026-05-14 19:42:33', '2026-05-14 19:42:33');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (56, 'App\Models\User', 1, 'auth-token', '237321e8439dc24c78c98138e5c25024194a8a43643bbc9c5bd6fc391afc8712', '["*"]', NULL, NULL, '2026-05-14 19:42:33', '2026-05-14 19:42:33');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (57, 'App\Models\User', 1, 'auth-token', '40cee3916a9f1a3d230eea8f4847cf3a6085847c61bf4323a2fd31b6f0a3b8b1', '["*"]', NULL, NULL, '2026-05-14 19:42:34', '2026-05-14 19:42:34');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (58, 'App\Models\User', 1, 'auth-token', '9162e829c382594fff5501394ca340e282c21278e71a85eb9049ce0074fa21d2', '["*"]', NULL, NULL, '2026-05-14 19:42:35', '2026-05-14 19:42:35');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (59, 'App\Models\User', 1, 'auth-token', '3b5461c14052623e021a94687e71271e3e142ca652bb2b2b1a869aff47a9585b', '["*"]', NULL, NULL, '2026-05-14 19:42:36', '2026-05-14 19:42:36');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (60, 'App\Models\User', 1, 'auth-token', 'b9c5ec23f9a62039f3718fd7234477c20ee2a8b43cc7381f5054f263fd5d1262', '["*"]', NULL, NULL, '2026-05-14 19:42:37', '2026-05-14 19:42:37');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (61, 'App\Models\User', 1, 'auth-token', '9ada3aec4a5594b6790e1e77cca6bc6ce94f2c85f50a19eb2f1400c16b58e3d2', '["*"]', NULL, NULL, '2026-05-14 19:42:38', '2026-05-14 19:42:38');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (62, 'App\Models\User', 1, 'auth-token', '917faadbd4f0664fd63066fdc480da2faad38ea252c887d02db46504941afd2f', '["*"]', NULL, NULL, '2026-05-14 19:42:39', '2026-05-14 19:42:39');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (63, 'App\Models\User', 1, 'auth-token', 'cebd4b9fc3dfaf59c104f49689a1e3ff4f1908897d15ac6b7a32f00c4e4554da', '["*"]', NULL, NULL, '2026-05-14 19:42:40', '2026-05-14 19:42:40');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (64, 'App\Models\User', 1, 'auth-token', '0794ef8ddcb338baaaafe88a7d0ab1c9e240981a125596ee96c659eaf7e28add', '["*"]', NULL, NULL, '2026-05-14 19:42:40', '2026-05-14 19:42:40');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (65, 'App\Models\User', 1, 'auth-token', '0249df8c1cd54bea51c2b1ee9fe22ad54910849d4fddc460c24a699523bb4b0a', '["*"]', NULL, NULL, '2026-05-14 19:42:41', '2026-05-14 19:42:41');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (66, 'App\Models\User', 1, 'auth-token', 'cb6aa47d4fcc37c0df8583f4d5413847fa06b8e9dcbe9d7329c9b9c09755b2df', '["*"]', NULL, NULL, '2026-05-14 19:42:42', '2026-05-14 19:42:42');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (67, 'App\Models\User', 1, 'auth-token', '9e62107c9d1ff960f7b9792801867a6d191bac9fcd772b9fc56209a5af798362', '["*"]', NULL, NULL, '2026-05-14 19:42:43', '2026-05-14 19:42:43');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (68, 'App\Models\User', 1, 'auth-token', '29b22532f203be6c6f6e55f0e54011c98cd3fc58974e78f937169dc500e8d65d', '["*"]', NULL, NULL, '2026-05-14 19:42:44', '2026-05-14 19:42:44');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (69, 'App\Models\User', 1, 'auth-token', '776842fe3ad8e3807ce650cab31ecd87f268eff4b35102ae55af8e7211cdb554', '["*"]', NULL, NULL, '2026-05-14 19:42:45', '2026-05-14 19:42:45');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (78, 'App\Models\User', 1, 'auth-token', '6f6358abcacd6c6d921531665dc3ef28b7b9f340bdf09e7a7278d8b0950fb890', '["*"]', '2026-05-16 16:41:25', NULL, '2026-05-16 16:39:49', '2026-05-16 16:41:25');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (77, 'App\Models\User', 3, 'auth-token', '95ac957f35cde21618e3722be2ee9841862220002f1229b9af3aef86a4272c2a', '["*"]', '2026-05-16 16:38:59', NULL, '2026-05-16 15:54:14', '2026-05-16 16:38:59');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (74, 'App\Models\User', 5, 'auth-token', 'a0319b4ccc73cf1473bf7796de4865682dbd828e35c506762a0fbf328175f297', '["*"]', '2026-05-14 21:29:59', NULL, '2026-05-14 19:45:20', '2026-05-14 21:29:59');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (75, 'App\Models\User', 5, 'auth-token', '5016075617e87c0d5cef962595bfcff5c8b23ad6e653c424020efc10e558380b', '["*"]', '2026-05-14 21:30:14', NULL, '2026-05-14 21:30:13', '2026-05-14 21:30:14');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (79, 'App\Models\User', 3, 'auth-token', 'dea85b9ad1e9e20813bc5c5d40b52d1ffbfb219804f6f3d0226cee1c7ad29d8e', '["*"]', '2026-05-16 16:41:53', NULL, '2026-05-16 16:41:52', '2026-05-16 16:41:53');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (82, 'App\Models\User', 5, 'auth-token', '21c128c41014cf512c9e59cc629d08fdfa43f3178b995bc8609b418e35ee642a', '["*"]', '2026-05-17 19:45:43', NULL, '2026-05-17 19:23:04', '2026-05-17 19:45:43');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (80, 'App\Models\User', 1, 'auth-token', '39152b4c8e53f3b84eb28130af35647efb07b5690f57ca854803661fe2643df5', '["*"]', NULL, NULL, '2026-05-16 21:10:10', '2026-05-16 21:10:10');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (84, 'App\Models\User', 1, 'auth-token', 'acc8b7dbd75be7f928c7fe042ad8e951b21e55cb43fe42b301c1d4a72638db6a', '["*"]', '2026-05-18 09:15:07', NULL, '2026-05-18 09:14:31', '2026-05-18 09:15:07');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (86, 'App\Models\User', 1, 'auth-token', 'd2f808f633d1ecc40079d2fab7cc54e30f6ade9a291f758ff797ce03d1242d3b', '["*"]', '2026-05-18 09:16:08', NULL, '2026-05-18 09:16:02', '2026-05-18 09:16:08');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (87, 'App\Models\User', 5, 'auth-token', '0ad3ff8c746098cd38c7c476db65608911241e92ace818f036885a3a89f84a7a', '["*"]', '2026-05-18 19:27:37', NULL, '2026-05-18 19:27:34', '2026-05-18 19:27:37');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (88, 'App\Models\User', 5, 'auth-token', '2392db28eb926109b50de5474a0688e47b765c2cf04c2b6e9a83dc3c5181d071', '["*"]', NULL, NULL, '2026-05-18 19:27:35', '2026-05-18 19:27:35');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (89, 'App\Models\User', 5, 'auth-token', 'be7f5cec757c29bca2fa98212a7a30995ec80a70b1408b8a85735bbd969e7538', '["*"]', '2026-05-18 19:27:50', NULL, '2026-05-18 19:27:36', '2026-05-18 19:27:50');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (90, 'App\Models\User', 1, 'auth-token', '0ea4a56dca313f28d12ea52f405cfe51c59b1154288ee3f085f62732d0ef6740', '["*"]', '2026-05-18 19:28:06', NULL, '2026-05-18 19:28:00', '2026-05-18 19:28:06');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (112, 'App\Models\User', 4, 'auth-token', '7f4da4db783c670e2817a7e200a0fcb03ddb4c76b4249464150d0cbcaa8849cc', '["*"]', '2026-05-29 06:25:42', NULL, '2026-05-23 16:28:03', '2026-05-29 06:25:42');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (111, 'App\Models\User', 4, 'auth-token', '618be028f561008397f49b937c36ac8323b0813bd7a231e79088780ec644c519', '["*"]', '2026-05-23 16:26:56', NULL, '2026-05-23 15:28:20', '2026-05-23 16:26:56');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (94, 'App\Models\User', 8, 'auth-token', 'c4f52204a6153d57869633d408580c0e94dfce7eb57e7b473e033bec1b763769', '["*"]', '2026-05-19 12:54:27', NULL, '2026-05-19 12:46:45', '2026-05-19 12:54:27');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (110, 'App\Models\User', 5, 'auth-token', '313dee1ce6a907803d3cd9e3dccd231956ce2b30e5f407c0cf9e5bc024018b0d', '["*"]', '2026-05-22 21:17:06', NULL, '2026-05-22 20:07:36', '2026-05-22 21:17:06');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (101, 'App\Models\User', 6, 'auth-token', 'acd98428188bcd4540a07cc757236d074264c448a23f968b88988cd976942698', '["*"]', '2026-05-23 15:28:10', NULL, '2026-05-19 21:07:10', '2026-05-23 15:28:10');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (98, 'App\Models\User', 4, 'auth-token', '919565e090bd6b0bec75c336e926568b126778dba976ddfea7b4b212cb2adbb2', '["*"]', '2026-05-19 20:12:32', NULL, '2026-05-19 20:10:23', '2026-05-19 20:12:32');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (99, 'App\Models\User', 4, 'auth-token', 'a9a3dcd56ed48663d016617f34a08580435b917973d587ce31dca80f77463d93', '["*"]', '2026-05-19 20:47:13', NULL, '2026-05-19 20:13:42', '2026-05-19 20:47:13');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (113, 'App\Models\User', 3, 'auth-token', 'b8d948cc68f330a7393bfe15a095eb7672070236006b95c10bd0e72d6084787b', '["*"]', '2026-05-23 19:44:58', NULL, '2026-05-23 19:44:57', '2026-05-23 19:44:58');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (102, 'App\Models\User', 5, 'auth-token', '1229da9a64fb2d5e0f6a83c4e1f11440d718ef52e58ddc36f598515107a567ab', '["*"]', NULL, NULL, '2026-05-22 20:07:28', '2026-05-22 20:07:28');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (103, 'App\Models\User', 5, 'auth-token', '5da67578263e03262a2f2ecbaadc601a3a96973386ae330808d3119805f21f1e', '["*"]', NULL, NULL, '2026-05-22 20:07:30', '2026-05-22 20:07:30');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (104, 'App\Models\User', 5, 'auth-token', '7595bd13d86ad7bfc864a413692d006d7dbe5feb1b1f958b4257cc74413e37a9', '["*"]', NULL, NULL, '2026-05-22 20:07:31', '2026-05-22 20:07:31');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (96, 'App\Models\User', 6, 'auth-token', '5accf31ee518fbef23b7f879e86c229db7666775e91c4acb9035df1da1e03666', '["*"]', '2026-05-19 20:08:20', NULL, '2026-05-19 19:53:03', '2026-05-19 20:08:20');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (105, 'App\Models\User', 5, 'auth-token', 'baff07cfc04c1ae8febf5a538788e7f3c5664b2c49de468b33ad7e2dced67c93', '["*"]', NULL, NULL, '2026-05-22 20:07:32', '2026-05-22 20:07:32');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (106, 'App\Models\User', 5, 'auth-token', '60194317a4edd14e00b6f562b91d2d9d8c70403641766dfc28469f1ff875aae0', '["*"]', NULL, NULL, '2026-05-22 20:07:33', '2026-05-22 20:07:33');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (107, 'App\Models\User', 5, 'auth-token', 'a29fe4cc240f087766973147683120456c305561db70f308783fb38fd5d8215e', '["*"]', NULL, NULL, '2026-05-22 20:07:34', '2026-05-22 20:07:34');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (97, 'App\Models\User', 6, 'auth-token', 'c7862509960bd3c9491a19c05e4917851173a45428a608e8b4abcafa03b38e4d', '["*"]', '2026-05-19 20:09:42', NULL, '2026-05-19 20:08:57', '2026-05-19 20:09:42');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (91, 'App\Models\User', 5, 'auth-token', '6ea92150da7b5126c55c75d0be9f4978dc6f709e5c683533c2f695a159ce1ffe', '["*"]', '2026-05-18 21:03:02', NULL, '2026-05-18 19:28:34', '2026-05-18 21:03:02');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (109, 'App\Models\User', 5, 'auth-token', '665e1e460003a9d0f7e07bfa018d88e581837a7a387876de8fae0c9b3158b880', '["*"]', NULL, NULL, '2026-05-22 20:07:36', '2026-05-22 20:07:36');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (92, 'App\Models\User', 5, 'auth-token', '239d303b0c8631caa046805fc8727db2ff5476d0e7defc3fadd69494262be94b', '["*"]', '2026-05-18 21:05:12', NULL, '2026-05-18 21:04:37', '2026-05-18 21:05:12');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (108, 'App\Models\User', 5, 'auth-token', '9563d0cff413e33cd6408fc411ce45b7ae3bc13be27517cca66723c434a9df46', '["*"]', '2026-05-22 20:07:38', NULL, '2026-05-22 20:07:35', '2026-05-22 20:07:38');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (93, 'App\Models\User', 1, 'auth-token', '86a4d7683780aaf4fdb3d3b073713e778cafba51e11a39f47b91942434fd7cff', '["*"]', '2026-05-19 12:46:36', NULL, '2026-05-19 12:46:16', '2026-05-19 12:46:36');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (95, 'App\Models\User', 1, 'auth-token', 'ee0358c046096a14379ff8768941aff59f504604d3edc0bb28533cc7f7c4d508', '["*"]', '2026-05-19 12:56:42', NULL, '2026-05-19 12:55:08', '2026-05-19 12:56:42');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (100, 'App\Models\User', 6, 'auth-token', '086dc141f07b168aa57e26de86a942ad145f1cf55c08779110143ebc2735a884', '["*"]', '2026-05-19 21:02:27', NULL, '2026-05-19 20:47:59', '2026-05-19 21:02:27');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (114, 'App\Models\User', 1, 'auth-token', '8fe051d41df7c5ca432fc35ac28f94bbaaefa8e195460a9461547a82cfd5f5a1', '["*"]', '2026-05-23 19:45:50', NULL, '2026-05-23 19:45:22', '2026-05-23 19:45:50');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (115, 'App\Models\User', 3, 'auth-token', 'aae62da29cb6b5bdb2bea65ff546d0429f698759230840dc6925948bf31c064a', '["*"]', '2026-05-23 20:04:51', NULL, '2026-05-23 19:46:11', '2026-05-23 20:04:51');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (116, 'App\Models\User', 3, 'auth-token', 'abb7ae22b7f18d2312cea2a67cd619b554c3e0bdda5b52cf0338ec3bfe0f0507', '["*"]', '2026-05-23 20:22:58', NULL, '2026-05-23 20:05:01', '2026-05-23 20:22:58');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (117, 'App\Models\User', 5, 'auth-token', '3b77948a0bd51eb7f0598001acb01e2a0c80ca5b2f22dd5506902c771bfccfc1', '["*"]', NULL, NULL, '2026-05-25 19:46:43', '2026-05-25 19:46:43');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (118, 'App\Models\User', 5, 'auth-token', '44faf8ab834a281460780e88b68b9719ca11f046bfa4f8e4cfbecba91f02c4d3', '["*"]', NULL, NULL, '2026-05-25 19:46:45', '2026-05-25 19:46:45');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (119, 'App\Models\User', 5, 'auth-token', 'b6daca46404dff2e3eba30542703c56f7ed1a1266175552c6c5806edd4d9a9f4', '["*"]', NULL, NULL, '2026-05-25 19:46:46', '2026-05-25 19:46:46');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (120, 'App\Models\User', 5, 'auth-token', '84ace7e3f4af2894edfdae093efad7db07f2e66482c2306cc57a8682f01aab07', '["*"]', NULL, NULL, '2026-05-25 19:46:47', '2026-05-25 19:46:47');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (121, 'App\Models\User', 3, 'auth-token', 'f732d558a753e1b3522acabc6588661acde3c31ab5a1c4ce22a099437a3febee', '["*"]', NULL, NULL, '2026-05-25 19:46:48', '2026-05-25 19:46:48');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (122, 'App\Models\User', 3, 'auth-token', 'c9fbd79682da4c75d9437b86bebeb5e72c8b559537a9c572f92d9ff6353a2a70', '["*"]', NULL, NULL, '2026-05-25 19:46:49', '2026-05-25 19:46:49');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (123, 'App\Models\User', 3, 'auth-token', '34ec0abfd2976e3d7db2b7449b14f47b8b291aef2245263b5939b56e82616e03', '["*"]', NULL, NULL, '2026-05-25 19:46:49', '2026-05-25 19:46:49');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (124, 'App\Models\User', 5, 'auth-token', '3bbf85a0b95ac5ef872001661b6d33e6623f72577a16a9e60e7900e8c161da97', '["*"]', NULL, NULL, '2026-05-25 19:46:50', '2026-05-25 19:46:50');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (125, 'App\Models\User', 5, 'auth-token', 'cf8f5f0c87b197240f1d4cce422cf95cd106b7ed01845a7168bb4a3a939a86b8', '["*"]', NULL, NULL, '2026-05-25 19:46:51', '2026-05-25 19:46:51');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (126, 'App\Models\User', 5, 'auth-token', 'd92d56691cc2b2cb44bd606cadeae38cebc077af8f41c11d417315474665a04a', '["*"]', NULL, NULL, '2026-05-25 19:46:52', '2026-05-25 19:46:52');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (127, 'App\Models\User', 5, 'auth-token', '8102d89667bf1c720be0da4b3921383c34477dfd86f6cb2663f65b5a27b173ba', '["*"]', NULL, NULL, '2026-05-25 19:46:53', '2026-05-25 19:46:53');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (128, 'App\Models\User', 5, 'auth-token', '46a1f804e4561b09e0448fb9bae1af4c707abd0e7b936744c6711c987c43a8c8', '["*"]', NULL, NULL, '2026-05-25 19:46:54', '2026-05-25 19:46:54');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (129, 'App\Models\User', 5, 'auth-token', '016b00f160fcaf713c298870d497c31d856712b57080d467de23687339259fbe', '["*"]', NULL, NULL, '2026-05-25 19:46:54', '2026-05-25 19:46:54');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (130, 'App\Models\User', 5, 'auth-token', '151ba9662895c29e55012e57b53d79815f42ad95decfabafc4c6d85136d43237', '["*"]', NULL, NULL, '2026-05-25 19:46:55', '2026-05-25 19:46:55');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (131, 'App\Models\User', 5, 'auth-token', 'c39f8f214a526f2dec432912c110a89759223efe447052e244877f89e880cd1f', '["*"]', NULL, NULL, '2026-05-25 19:46:56', '2026-05-25 19:46:56');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (132, 'App\Models\User', 5, 'auth-token', 'f823630259b0b0721f75381cfff731715fa9d359c1bfbcbafde6af710eabc2e7', '["*"]', NULL, NULL, '2026-05-25 19:46:57', '2026-05-25 19:46:57');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (133, 'App\Models\User', 5, 'auth-token', '3bda3ccc708058643494248ecb38bc8ec34906f249210a08984ac10c9f2c8919', '["*"]', NULL, NULL, '2026-05-25 19:46:58', '2026-05-25 19:46:58');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (134, 'App\Models\User', 5, 'auth-token', '8e52782e2be8fa1123653d830219a4b4ab26e8662a6682452af07742a87149b9', '["*"]', NULL, NULL, '2026-05-25 19:46:59', '2026-05-25 19:46:59');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (135, 'App\Models\User', 5, 'auth-token', '5dcabccf1acc3973adc4dee4a419ad78c35b374e8cb362d6b099eecd713b90cc', '["*"]', NULL, NULL, '2026-05-25 19:46:59', '2026-05-25 19:46:59');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (136, 'App\Models\User', 5, 'auth-token', '5761975db44591311e876dbc6e8b2d2ec11169760a95661a29a00b0117f038c5', '["*"]', NULL, NULL, '2026-05-25 19:47:00', '2026-05-25 19:47:00');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (137, 'App\Models\User', 5, 'auth-token', 'dcdc92ca2589096c8b78d7602882d90fef4c3faa6751571d0dfb4a1e4f190c84', '["*"]', NULL, NULL, '2026-05-25 19:47:01', '2026-05-25 19:47:01');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (139, 'App\Models\User', 5, 'auth-token', 'c67b737628d66f8ea2bdb2f1defcf871bede5e0b896d6f81aa95c0ef12caf103', '["*"]', NULL, NULL, '2026-05-25 19:47:03', '2026-05-25 19:47:03');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (140, 'App\Models\User', 5, 'auth-token', '13b2ed6c495d52037c41a0383b654a1da411ed2167a78ee06f1b6d2ab2db1189', '["*"]', NULL, NULL, '2026-05-25 19:47:04', '2026-05-25 19:47:04');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (141, 'App\Models\User', 5, 'auth-token', 'b5fc0dfea92b264177ffdec1da2682b0dccc088a5a1c9860c036321d5dd78b0e', '["*"]', NULL, NULL, '2026-05-25 19:47:04', '2026-05-25 19:47:04');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (138, 'App\Models\User', 5, 'auth-token', '5a2769df3069713786e69ee035ebdf36d27d9a5e08fe23f2934a6a86cf85ff8d', '["*"]', '2026-05-25 19:47:06', NULL, '2026-05-25 19:47:02', '2026-05-25 19:47:06');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (143, 'App\Models\User', 3, 'auth-token', '22b5a75e750b0083ebdef5d2ac32faf77a52730ad520f3109e3c021837491a50', '["*"]', '2026-05-25 21:01:49', NULL, '2026-05-25 20:47:04', '2026-05-25 21:01:49');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (144, 'App\Models\User', 3, 'auth-token', '38ff527687c7dba77b735d9a476dca410bcbdd6e6fb24e020fcedf7fd608741c', '["*"]', '2026-05-25 21:02:12', NULL, '2026-05-25 21:02:09', '2026-05-25 21:02:12');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (145, 'App\Models\User', 3, 'auth-token', '61a35a05465a33b0a99ec34930a52c63da6a621ec9cd73ff9476839371630b4a', '["*"]', '2026-05-25 21:02:51', NULL, '2026-05-25 21:02:12', '2026-05-25 21:02:51');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (147, 'App\Models\User', 8, 'auth-token', '28ae9f60e5acbdc7000777a63182cfc0b32bdb99e43eccf945ab0aa780ec2f58', '["*"]', NULL, NULL, '2026-05-26 13:17:39', '2026-05-26 13:17:39');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (148, 'App\Models\User', 8, 'auth-token', '82088c5ff45ab9433c864b8669527d8244a732a556443a532f65560165d7190e', '["*"]', NULL, NULL, '2026-05-26 13:17:40', '2026-05-26 13:17:40');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (149, 'App\Models\User', 8, 'auth-token', '7164b794b89b77f122311a5c8705216317cf1510c20a7adf446429eea0305c9c', '["*"]', NULL, NULL, '2026-05-26 13:17:40', '2026-05-26 13:17:40');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (146, 'App\Models\User', 8, 'auth-token', 'cb1a8d192c8d70f22cd121551b9e4aca957fb76ddabb76a37f157a13629276dc', '["*"]', '2026-05-26 13:17:41', NULL, '2026-05-26 13:17:37', '2026-05-26 13:17:41');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (150, 'App\Models\User', 8, 'auth-token', '4559393390dcaa0d6d3c9f26c5f400c35193d89d50e5a1319bf046d46e8c9f4c', '["*"]', '2026-05-26 13:19:01', NULL, '2026-05-26 13:19:00', '2026-05-26 13:19:01');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (151, 'App\Models\User', 1, 'auth-token', '8cc88d5dbda374afcd85a27cf2250bdc0e8294fce82c94dde85cfb1d03cccc8e', '["*"]', NULL, NULL, '2026-05-26 13:28:19', '2026-05-26 13:28:19');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (152, 'App\Models\User', 8, 'auth-token', 'b7abbddcf5dda0f4da5d7cead83de1373f70a1299b6498f01a0e4afe717fadf7', '["*"]', '2026-05-26 13:44:49', NULL, '2026-05-26 13:44:48', '2026-05-26 13:44:49');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (153, 'App\Models\User', 8, 'auth-token', '7971fafc107e19310866a12495667b802b6c99c64f523cc4c47586a2a45496b3', '["*"]', '2026-05-26 13:45:41', NULL, '2026-05-26 13:45:36', '2026-05-26 13:45:41');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (154, 'App\Models\User', 8, 'auth-token', '0053d2caf829854d779e7f6744268a024e369d74666d6ffa8a95b2bf3b67e73c', '["*"]', '2026-05-26 13:45:58', NULL, '2026-05-26 13:45:53', '2026-05-26 13:45:58');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (142, 'App\Models\User', 5, 'auth-token', '00c0159dcc7fd23acbaccff7f97bba6fe9a9bef67ee6b3c8e574a6d2c0a3254f', '["*"]', '2026-05-25 20:34:55', NULL, '2026-05-25 19:47:05', '2026-05-25 20:34:55');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (155, 'App\Models\User', 1, 'auth-token', '5215d8888f4c04bc94b7e4345cf07377b1b160017a4dbf452164155863bb4774', '["*"]', NULL, NULL, '2026-05-26 13:46:17', '2026-05-26 13:46:17');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (156, 'App\Models\User', 8, 'auth-token', 'fb199621745334f1b8cb7caa49bad285a394adf605319e6d368616d51a728e1c', '["*"]', '2026-05-26 13:58:47', NULL, '2026-05-26 13:58:38', '2026-05-26 13:58:47');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (163, 'App\Models\User', 6, 'auth-token', 'f1c10e5cc1c5081d1bf63872c1fefb69c75048f8cf76c1619df6a90fb12f588c', '["*"]', '2026-05-26 19:45:35', NULL, '2026-05-26 19:37:26', '2026-05-26 19:45:35');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (157, 'App\Models\User', 8, 'auth-token', '97308cafa9d70df19294594cc79442ec7f1c31e7c703a2eb2251a7009abcc6ca', '["*"]', '2026-05-26 13:59:08', NULL, '2026-05-26 13:59:03', '2026-05-26 13:59:08');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (158, 'App\Models\User', 8, 'auth-token', '0eccd5e4b3657571653a64a125713054216d8ac3835ef95eab3ad3825fa546ae', '["*"]', '2026-05-26 14:00:26', NULL, '2026-05-26 13:59:54', '2026-05-26 14:00:26');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (159, 'App\Models\User', 6, 'auth-token', '49c5ac5c920f4e3c31c01de13019146a68f8c0c7bc681eddf283eae6781a7906', '["*"]', NULL, NULL, '2026-05-26 19:26:21', '2026-05-26 19:26:21');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (160, 'App\Models\User', 6, 'auth-token', '882c86f7251b7c5577c05d491f24e6d22d0a1502738c3f0525b098b8456bbbcf', '["*"]', '2026-05-26 19:26:29', NULL, '2026-05-26 19:26:22', '2026-05-26 19:26:29');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (161, 'App\Models\User', 6, 'auth-token', '4498731a80ca46eaede6c91cb9f2ffe3f8347a333e77f22011f65de224f5a8fb', '["*"]', '2026-05-26 19:30:44', NULL, '2026-05-26 19:30:39', '2026-05-26 19:30:44');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (164, 'App\Models\User', 6, 'auth-token', '3287512e7ba5ef6fc6859f57f0b99717891b4ac5a43e021a01871059e779248f', '["*"]', '2026-05-26 19:46:33', NULL, '2026-05-26 19:46:29', '2026-05-26 19:46:33');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (162, 'App\Models\User', 6, 'auth-token', '844a40d4c8784ff74ba45fa8a7a9d7add04d75f95090f1ecd09e1dae97d0cefd', '["*"]', '2026-05-26 19:31:51', NULL, '2026-05-26 19:31:01', '2026-05-26 19:31:51');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (165, 'App\Models\User', 6, 'auth-token', 'fe5cf8f066dc8ed62012fdc13496beac1208b93e1769ff1eee2706a059b4f7a5', '["*"]', '2026-05-26 19:46:49', NULL, '2026-05-26 19:46:45', '2026-05-26 19:46:49');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (166, 'App\Models\User', 8, 'auth-token', '4ebf958e9fbb42caa7d283a348ba9ed9ce1c14ddafafd6e330041c96cc577c91', '["*"]', '2026-05-26 19:49:53', NULL, '2026-05-26 19:49:48', '2026-05-26 19:49:53');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (167, 'App\Models\User', 4, 'auth-token', 'c53d7848f9532261d2bf51139a33ae463606d5fbdb529ec1c56d0a4ccb80afa7', '["*"]', '2026-05-29 07:10:26', NULL, '2026-05-29 06:26:02', '2026-05-29 07:10:26');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (168, 'App\Models\User', 6, 'auth-token', '881b7b53f43d5d6391ea3258cad0224f55780a2464efae8e1521c63b52a7411b', '["*"]', '2026-05-29 07:09:25', NULL, '2026-05-29 07:07:25', '2026-05-29 07:09:25');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (200, 'App\Models\User', 8, 'auth-token', '281775c29ced2fd7bbbd9c9ee436cf06d98ea5f464148a65f1add7dec25b70d0', '["*"]', '2026-06-13 07:17:55', NULL, '2026-06-13 07:14:08', '2026-06-13 07:17:55');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (169, 'App\Models\User', 4, 'auth-token', '6bd99edfd9fa5fbe5173c6dc687a7d81bd06864900b078e675d41b3ad33f3b1e', '["*"]', '2026-05-29 07:10:56', NULL, '2026-05-29 07:10:44', '2026-05-29 07:10:56');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (170, 'App\Models\User', 3, 'auth-token', '6240217f33849df27d9604dc374df28ebfa82af2e2a47c4630f86e99b390d5fe', '["*"]', '2026-05-29 07:20:24', NULL, '2026-05-29 07:20:19', '2026-05-29 07:20:24');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (195, 'App\Models\User', 8, 'auth-token', '4cf866385af638586f7df3b1b9d1594cd3a6fed4692506de40f1a50e165f439a', '["*"]', '2026-06-03 09:40:15', NULL, '2026-06-03 09:38:38', '2026-06-03 09:40:15');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (174, 'App\Models\User', 4, 'auth-token', 'a0dfcfd96d6eeb48a3daec399b8808075f98bef66bb98d716c62fa271a4a9a4a', '["*"]', '2026-05-29 08:05:39', NULL, '2026-05-29 07:33:54', '2026-05-29 08:05:39');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (181, 'App\Models\User', 6, 'auth-token', '5a4327f4871749acf39efa406acac854a25f4a76788dfd9f96a734f3c308ba6f', '["*"]', '2026-05-29 11:42:03', NULL, '2026-05-29 11:35:27', '2026-05-29 11:42:03');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (196, 'App\Models\User', 8, 'auth-token', '9bb9d3d854b97cc9a555be74f67f1d92d37d79311dc8adadff6f60f44e34d799', '["*"]', '2026-06-03 09:44:32', NULL, '2026-06-03 09:44:28', '2026-06-03 09:44:32');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (175, 'App\Models\User', 6, 'auth-token', '8390b9e953293880ffb8c2fd0fac0295db6fc9a3032b30f645a4d798538124a7', '["*"]', '2026-05-29 08:06:22', NULL, '2026-05-29 08:05:53', '2026-05-29 08:06:22');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (197, 'App\Models\User', 8, 'auth-token', 'd0304c4c1351947146557d8f8b38cd3fe70ce54d27efce560aaf1545d79c0035', '["*"]', '2026-06-03 09:45:09', NULL, '2026-06-03 09:45:05', '2026-06-03 09:45:09');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (198, 'App\Models\User', 8, 'auth-token', 'a5656215709cc401f82a7e005851063e36c4ea90326e9bfed2c55b1c391ab083', '["*"]', NULL, NULL, '2026-06-12 16:53:10', '2026-06-12 16:53:10');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (205, 'App\Models\User', 6, 'auth-token', 'c8acb1a0dd9537db0d6f85135c662478cb6d3959b08f7deb9df7b59c8609d528', '["*"]', '2026-06-14 06:49:37', NULL, '2026-06-14 06:48:18', '2026-06-14 06:49:37');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (180, 'App\Models\User', 6, 'auth-token', '74505ef0ac31d845fb9e55e5d8195369fdc1165a8bf264ce5235a9c30573e72b', '["*"]', '2026-05-29 11:35:18', NULL, '2026-05-29 11:33:48', '2026-05-29 11:35:18');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (202, 'App\Models\User', 4, 'auth-token', '8cee363085760bdfdb2157cb410b534852f854b320d9cfe06734cbcd9007311d', '["*"]', '2026-06-13 15:08:31', NULL, '2026-06-13 15:01:35', '2026-06-13 15:08:31');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (199, 'App\Models\User', 8, 'auth-token', '89132cac1a7abd7f1234090bedc75b6c4cc4def568c16fe607794b1f94049f76', '["*"]', '2026-06-12 16:54:43', NULL, '2026-06-12 16:53:12', '2026-06-12 16:54:43');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (187, 'App\Models\User', 6, 'auth-token', 'd1f1f4bcc1e9ddcab31c13399c7097af2a07501d0fa3b1e6fa46215e0d415137', '["*"]', '2026-05-30 16:44:58', NULL, '2026-05-30 16:36:09', '2026-05-30 16:44:58');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (188, 'App\Models\User', 1, 'auth-token', '57563b25b3cf0721ef001d1a9a7afeabbdf26547e6e2ce71c7503140795bb21b', '["*"]', NULL, NULL, '2026-05-30 16:47:23', '2026-05-30 16:47:23');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (171, 'App\Models\User', 3, 'auth-token', 'c7a4863652e1a251b113152948ab429fdbf38c8c3d04946d6832600b4f09662c', '["*"]', '2026-05-29 07:29:07', NULL, '2026-05-29 07:23:47', '2026-05-29 07:29:07');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (178, 'App\Models\User', 6, 'auth-token', '63ab5d8523d479150b25976b4ece5bb514454f254a7cd106fd8945dba52e7760', '["*"]', '2026-05-29 11:33:34', NULL, '2026-05-29 11:31:59', '2026-05-29 11:33:34');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (179, 'App\Models\User', 6, 'auth-token', '25def8794c2a27888489e746fd1853cc866c0e2315c486404bcb14f197883a33', '["*"]', NULL, NULL, '2026-05-29 11:33:45', '2026-05-29 11:33:45');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (176, 'App\Models\User', 6, 'auth-token', 'd7ed368b0d4dacc4a0a9b2766f8af226db9f3737a8800cc4dd97048c2c82e91f', '["*"]', '2026-05-29 08:11:23', NULL, '2026-05-29 08:06:43', '2026-05-29 08:11:23');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (172, 'App\Models\User', 1, 'auth-token', '8193fc5eba9d2977a32320a9f14e6cf014e17c46378b40366da1a399b1052a7b', '["*"]', '2026-05-29 07:32:28', NULL, '2026-05-29 07:30:57', '2026-05-29 07:32:28');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (189, 'App\Models\User', 1, 'auth-token', 'f42225e43686c758589efbe45d040cef3cf7a0c4da93038513d12bd16980c5cc', '["*"]', NULL, NULL, '2026-05-30 16:47:26', '2026-05-30 16:47:26');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (173, 'App\Models\User', 1, 'auth-token', '584f0fbe4804c8cbfcfb28a4b23afc7011c2941d163a1a11363bea19431fd412', '["*"]', '2026-05-29 07:33:40', NULL, '2026-05-29 07:33:17', '2026-05-29 07:33:40');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (190, 'App\Models\User', 8, 'auth-token', 'dfac5c003a22f8e6e9251e9b7faf04631500db56022fd7fc145869d4d4e20a75', '["*"]', NULL, NULL, '2026-06-03 09:32:58', '2026-06-03 09:32:58');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (191, 'App\Models\User', 8, 'auth-token', '853c7ed1a7db8e1a196c3f87660d89252d91766dde0a0c44d3c75b3b46c60c95', '["*"]', NULL, NULL, '2026-06-03 09:33:00', '2026-06-03 09:33:00');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (192, 'App\Models\User', 8, 'auth-token', 'a849aaf4d96f32383f601400daac28f921657faedc8de508ba6b9df41e57d5b5', '["*"]', NULL, NULL, '2026-06-03 09:33:01', '2026-06-03 09:33:01');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (177, 'App\Models\User', 6, 'auth-token', 'da94befe8a1becc4b4f1eb818cae687e0d4afc404df2e64e488409cf032c7547', '["*"]', '2026-05-29 08:28:37', NULL, '2026-05-29 08:11:39', '2026-05-29 08:28:37');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (193, 'App\Models\User', 8, 'auth-token', '1962b2716154b5860b2d73620271ef1c58adb45fc05f107044849f840bc60ca9', '["*"]', NULL, NULL, '2026-06-03 09:33:02', '2026-06-03 09:33:02');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (194, 'App\Models\User', 8, 'auth-token', '50aa71af8f39046d2df32967d33d2ac539e2537d93cc5b9539509e49680080f4', '["*"]', '2026-06-03 09:33:05', NULL, '2026-06-03 09:33:02', '2026-06-03 09:33:05');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (203, 'App\Models\User', 4, 'auth-token', '0fbc82b8e39d12a581af1054a0445af1bbb3ad919ed966ef02e0b3d974168d83', '["*"]', NULL, NULL, '2026-06-13 15:09:26', '2026-06-13 15:09:26');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (182, 'App\Models\User', 6, 'auth-token', '5d9405de9b0180727d05474fc19ade6eaaf04ddc44e3732d11b6f41d4d3015c1', '["*"]', '2026-05-29 13:26:29', NULL, '2026-05-29 13:15:22', '2026-05-29 13:26:29');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (183, 'App\Models\User', 6, 'auth-token', '093c0d33b051829537722a6744cbdd6d6b5a2275b4dbee0bd21bc432f6885cdd', '["*"]', NULL, NULL, '2026-05-30 16:36:05', '2026-05-30 16:36:05');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (184, 'App\Models\User', 6, 'auth-token', 'a9e1d267e0b2f64c1da09a337585eac12c02e8b0017696498f034f94aec550b6', '["*"]', NULL, NULL, '2026-05-30 16:36:07', '2026-05-30 16:36:07');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (185, 'App\Models\User', 6, 'auth-token', '8e27c9fdf13d8c30357b89cc2cbcece8b3bcc29e355c8f3364b32073eb3d9f85', '["*"]', NULL, NULL, '2026-05-30 16:36:08', '2026-05-30 16:36:08');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (186, 'App\Models\User', 6, 'auth-token', 'a60273fe5a1b8ae4b740e54a8fd95e9a3de79fec80e849e6278ce2d77350a3da', '["*"]', NULL, NULL, '2026-05-30 16:36:08', '2026-05-30 16:36:08');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (201, 'App\Models\User', 3, 'auth-token', '7641d3d420cb2f72ed3bc8a1bcdb3fe39f630b018fdd716872bf2adc833d926c', '["*"]', '2026-06-13 14:55:38', NULL, '2026-06-13 13:54:17', '2026-06-13 14:55:38');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (204, 'App\Models\User', 4, 'auth-token', '959ef37bda7b29cf32d7ab6941a608969a6eed348c8764cf744555b7047a8b4a', '["*"]', '2026-06-13 15:09:31', NULL, '2026-06-13 15:09:27', '2026-06-13 15:09:31');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (206, 'App\Models\User', 6, 'auth-token', '464e21260c8d96c6ebe8f09ba5801619c3079e504ed070786a99ad0d18f500fd', '["*"]', '2026-06-14 06:55:41', NULL, '2026-06-14 06:51:42', '2026-06-14 06:55:41');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (207, 'App\Models\User', 1, 'auth-token', '956e815b9bccffcf64103b1ea669afe19a8f3a22a337f7378e267cb7314e1c2b', '["*"]', '2026-06-14 06:56:47', NULL, '2026-06-14 06:56:39', '2026-06-14 06:56:47');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (212, 'App\Models\User', 8, 'auth-token', '2d639ebddeeb4864348c2a791a02231153d1918e06a8cb2b874c160299781c27', '["*"]', NULL, NULL, '2026-06-14 20:37:18', '2026-06-14 20:37:18');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (208, 'App\Models\User', 6, 'auth-token', 'ef4abb7dd2750399e7aa876b04a437d5c47990634ba87e44d3bef600a83f3e78', '["*"]', '2026-06-14 07:01:19', NULL, '2026-06-14 06:57:10', '2026-06-14 07:01:19');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (209, 'App\Models\User', 4, 'auth-token', 'aa5e8440752f7943ed6b2022135afe8d20f7ebda5fd8a40d19c3dfc9cf1c71b4', '["*"]', '2026-06-14 16:33:49', NULL, '2026-06-14 16:07:25', '2026-06-14 16:33:49');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (210, 'App\Models\User', 4, 'auth-token', '516bf575096efbd7ced6bd3caa2ebef05dbb279826422fc821c79a6e99053fff', '["*"]', '2026-06-14 16:46:05', NULL, '2026-06-14 16:34:00', '2026-06-14 16:46:05');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (211, 'App\Models\User', 4, 'auth-token', '5892a9b4f84717b8a111a414b50048b9f9018bfc22a587214e59b9d0414042c3', '["*"]', '2026-06-14 20:27:19', NULL, '2026-06-14 19:43:30', '2026-06-14 20:27:19');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (213, 'App\Models\User', 8, 'auth-token', '87d971029a1dd00ffb6f9a073501463787e3f5af1b01ae1e30e4e51ed7bbf758', '["*"]', '2026-06-14 20:37:24', NULL, '2026-06-14 20:37:19', '2026-06-14 20:37:24');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (236, 'App\Models\User', 1, 'auth-token', 'b8bd592ce385ecd9a436839085c129851e9d08b70bd8edb8331779222fe60e7a', '["*"]', '2026-07-15 21:52:16', NULL, '2026-07-15 21:51:40', '2026-07-15 21:52:16');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (237, 'App\Models\User', 1, 'auth-token', '5becc8dae130e9bffeff1c32d6099a99b71fc5485308afe2461107e4117720d0', '["*"]', NULL, NULL, '2026-07-30 14:43:52', '2026-07-30 14:43:52');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (238, 'App\Models\User', 1, 'auth-token', '4c6b8a1d38092d361aa9e18588c5b478e18035436c4adcebfd4f7d65fec1c0d6', '["*"]', '2026-07-30 14:44:55', NULL, '2026-07-30 14:44:26', '2026-07-30 14:44:55');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (225, 'App\Models\User', 4, 'auth-token', 'c38a2e3c1ca720cd4fafe5169191a9e6e28fb95dc084666b82982edfc86cc78b', '["*"]', '2026-06-16 13:44:45', NULL, '2026-06-16 12:41:34', '2026-06-16 13:44:45');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (226, 'App\Models\User', 4, 'auth-token', '3938c92189404c463eaea29f70c26feea15c6622ec4d07ce913deab1e45d9c90', '["*"]', NULL, NULL, '2026-06-17 06:44:34', '2026-06-17 06:44:34');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (227, 'App\Models\User', 4, 'auth-token', 'eb4c65d23e3263446b8bd6d4285460b8a6fd4390efcbcb8f04a332c14b0e5a06', '["*"]', NULL, NULL, '2026-06-17 06:44:36', '2026-06-17 06:44:36');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (228, 'App\Models\User', 4, 'auth-token', 'e161fba013454c40013e101543882c6345051e4fd5d3cb1ffdb8557f99ab2edc', '["*"]', NULL, NULL, '2026-06-17 06:44:37', '2026-06-17 06:44:37');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (229, 'App\Models\User', 4, 'auth-token', '0e856235fe107eac7caf5058e5bf689a7b51cc6b3e48ddf527b00f8789b9631e', '["*"]', NULL, NULL, '2026-06-17 06:44:37', '2026-06-17 06:44:37');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (230, 'App\Models\User', 4, 'auth-token', '39731bb11d5f028815102a147e0f0fe6e553fb54019c26f4ea474e3a6dac1fad', '["*"]', NULL, NULL, '2026-06-17 06:44:38', '2026-06-17 06:44:38');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (217, 'App\Models\User', 4, 'auth-token', 'ffbaa2976d00cb7af771061ae09a8974f7373c3e5d78bd921f1486cd743f2fa4', '["*"]', '2026-06-15 07:32:10', NULL, '2026-06-15 06:51:57', '2026-06-15 07:32:10');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (214, 'App\Models\User', 4, 'auth-token', 'a62c9f2ae2e27d16cdb72fdb09cde9dcf45a7fcff2e71f225ce09b4d33c585ab', '["*"]', '2026-06-14 20:48:59', NULL, '2026-06-14 20:39:23', '2026-06-14 20:48:59');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (215, 'App\Models\User', 4, 'auth-token', '951df00fac7e9a229b02305a56473c345154b6dae654e0263a5997bcb62bab45', '["*"]', '2026-06-14 21:11:28', NULL, '2026-06-14 20:49:07', '2026-06-14 21:11:28');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (220, 'App\Models\User', 4, 'auth-token', '721cfbe9c4fbd24eff9ee07331499b6743b2c04c8923c632367381efa7a5d774', '["*"]', '2026-06-15 16:52:35', NULL, '2026-06-15 15:47:41', '2026-06-15 16:52:35');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (216, 'App\Models\User', 4, 'auth-token', '3d7baee37b471d405480855b44116f67e6444ab6337853ae3df0d40493058958', '["*"]', '2026-06-15 06:51:51', NULL, '2026-06-15 06:19:11', '2026-06-15 06:51:51');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (221, 'App\Models\User', 4, 'auth-token', 'a05d178753da6e9645985babe8c4cc36b9e1e73a0c0b6885443730b4543d6be1', '["*"]', NULL, NULL, '2026-06-16 12:41:29', '2026-06-16 12:41:29');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (222, 'App\Models\User', 4, 'auth-token', '20f56e52be9ef8065d204f67e31ff082d7b41899faa547265ad4ca878ade02ce', '["*"]', NULL, NULL, '2026-06-16 12:41:31', '2026-06-16 12:41:31');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (223, 'App\Models\User', 4, 'auth-token', 'b687e9502ede9d6beea0f40c9fc07fba8ae5549f13b4a8959f7ce30ead8eca1c', '["*"]', NULL, NULL, '2026-06-16 12:41:32', '2026-06-16 12:41:32');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (224, 'App\Models\User', 4, 'auth-token', '3aeb3cd0939c5a4150b0ce64ceb4671d74901f168db1015af85fd4b1d76c3577', '["*"]', NULL, NULL, '2026-06-16 12:41:33', '2026-06-16 12:41:33');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (231, 'App\Models\User', 4, 'auth-token', 'b4cf3cc2357e6505e6e27c1252ad295dd20f1660cea405a415ec4b2fe0358573', '["*"]', NULL, NULL, '2026-06-17 06:44:39', '2026-06-17 06:44:39');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (232, 'App\Models\User', 4, 'auth-token', '1c680a73a66266833540381fa80bd93365bc7deb50af76a3ef227b87b65ab933', '["*"]', NULL, NULL, '2026-06-17 06:44:40', '2026-06-17 06:44:40');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (233, 'App\Models\User', 4, 'auth-token', '1a98de2c1c989ac4148886de1e76ca5981c334f11976ec73bc0e46d4157719a2', '["*"]', NULL, NULL, '2026-06-17 06:44:41', '2026-06-17 06:44:41');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (239, 'App\Models\User', 8, 'auth-token', '9bd6defbace5a7e558f3af09fb5f37c48400f985b265c021b36615c4e2742bc5', '["*"]', '2026-07-30 14:45:14', NULL, '2026-07-30 14:45:09', '2026-07-30 14:45:14');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (248, 'App\Models\User', 8, 'auth-token', 'ec96bd909573229f510cb5dc218b5984de61f6e826a26950934c3c0ebd919879', '["*"]', '2026-08-05 14:09:07', NULL, '2026-08-04 20:40:51', '2026-08-05 14:09:07');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (218, 'App\Models\User', 4, 'auth-token', 'fe9994506e5da46808061a339637d6793c67bc92cccaa80a18f9c9a8397723ba', '["*"]', '2026-06-15 08:37:32', NULL, '2026-06-15 07:54:03', '2026-06-15 08:37:32');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (246, 'App\Models\User', 8, 'auth-token', 'ad11b9731bbd412635bb50ac6900ccd66fc924e6d2914a7f5d8826eb3a8c9662', '["*"]', '2026-08-02 16:20:00', NULL, '2026-08-01 12:41:23', '2026-08-02 16:20:00');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (242, 'App\Models\User', 1, 'auth-token', 'be230231a0c00e6c4b52f39f5ea23f31033f968a999417758f320db0a50ccf2f', '["*"]', '2026-07-31 07:53:21', NULL, '2026-07-31 07:49:58', '2026-07-31 07:53:21');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (234, 'App\Models\User', 4, 'auth-token', '90a019a9fd0dea1e579a016598838f5fd7849a5a5067e2f6aba8cdc5d8b6ffd4', '["*"]', '2026-06-17 06:45:58', NULL, '2026-06-17 06:44:42', '2026-06-17 06:45:58');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (235, 'App\Models\User', 1, 'auth-token', 'd5a3be18d004b62809ecaeded97883222ecd163454fd442463fd5181881a8560', '["*"]', NULL, NULL, '2026-07-15 21:51:39', '2026-07-15 21:51:39');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (243, 'App\Models\User', 1, 'auth-token', 'c23884735e2d68968e2ed0972a5c7653ce30eb442e0d32b757bde0d56e0f3b66', '["*"]', NULL, NULL, '2026-07-31 21:01:50', '2026-07-31 21:01:50');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (219, 'App\Models\User', 4, 'auth-token', 'd818418249ef71ad8aa260023616b53640c8383bc186ffedbff094ec00e2768a', '["*"]', '2026-06-15 15:46:36', NULL, '2026-06-15 15:45:54', '2026-06-15 15:46:36');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (240, 'App\Models\User', 1, 'auth-token', '58c3308b7ac244fc3209b10986d85f6ffa7ee2db94ab82a0963f3d5e94c343aa', '["*"]', '2026-07-31 07:45:00', NULL, '2026-07-31 07:44:07', '2026-07-31 07:45:00');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (244, 'App\Models\User', 8, 'auth-token', '142ea1bc935ad5e8eb478334c06f09a058e1945b96f69589164a9a1227e038c8', '["*"]', '2026-07-31 21:02:13', NULL, '2026-07-31 21:02:08', '2026-07-31 21:02:13');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (241, 'App\Models\User', 8, 'auth-token', '5866f91b65e5e6a9b2f919b788f050699ce446e76e02acace8befc5c58acd85c', '["*"]', '2026-07-31 07:49:47', NULL, '2026-07-31 07:46:40', '2026-07-31 07:49:47');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (245, 'App\Models\User', 1, 'auth-token', 'e6808810440ec925ee99935146f040cb09d93b8fefceb0fc6deefbc4d348c81f', '["*"]', '2026-08-01 12:40:59', NULL, '2026-08-01 12:40:42', '2026-08-01 12:40:59');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (249, 'App\Models\User', 8, 'auth-token', '6c7bc08654165a79c6ba82aba81290bd255610b5538e2c4aff7e81bd93caf53d', '["*"]', '2026-08-05 15:31:45', NULL, '2026-08-05 15:31:40', '2026-08-05 15:31:45');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (250, 'App\Models\User', 8, 'auth-token', '4a72a8debd0d51881f975b4a09b57dcea6f1913547f1cb3fc131d58b3b78e0cb', '["*"]', '2026-08-05 16:30:15', NULL, '2026-08-05 16:30:10', '2026-08-05 16:30:15');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (247, 'App\Models\User', 1, 'auth-token', '2fa00a7a4c9b1fd7dc41614d486597a86a23edd9ee0ff2b95dd494285e2a872c', '["*"]', '2026-08-04 20:40:39', NULL, '2026-08-04 19:58:42', '2026-08-04 20:40:39');
INSERT INTO public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) VALUES (251, 'App\Models\User', 1, 'auth-token', '3d358379af759d9e38714e390174a12056c3a003bfe9636f97439b42de5aa427', '["*"]', NULL, NULL, '2026-08-08 21:28:53', '2026-08-08 21:28:53');


--
-- TOC entry 4939 (class 0 OID 16423)
-- Dependencies: 225
-- Data for Name: points; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4941 (class 0 OID 16439)
-- Dependencies: 227
-- Data for Name: siswa; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (239, 'Abdillah Ilham Pradana', 11, '2026-08-04 20:17:29', '2026-08-04 20:17:29');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (240, 'Abdullah Ihsan Al Atsary', 11, '2026-08-04 20:17:29', '2026-08-04 20:17:29');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (241, 'Abdullah Aqil Al Zuhdi', 11, '2026-08-04 20:17:29', '2026-08-04 20:17:29');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (242, 'Ahmad Zaki Musyafa''', 11, '2026-08-04 20:17:29', '2026-08-04 20:17:29');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (243, 'Aydan Nooriel Imni', 11, '2026-08-04 20:17:29', '2026-08-04 20:17:29');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (244, 'Azharuddiya Syamsi', 11, '2026-08-04 20:17:29', '2026-08-04 20:17:29');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (245, 'Bangga Agung Widodo', 11, '2026-08-04 20:17:29', '2026-08-04 20:17:29');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (246, 'Hisyam Alwan Muflih', 11, '2026-08-04 20:17:29', '2026-08-04 20:17:29');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (247, 'Kelvin Muhammad Al Faqih', 11, '2026-08-04 20:17:29', '2026-08-04 20:17:29');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (248, 'Khoirul Umam Al Wafa', 11, '2026-08-04 20:17:29', '2026-08-04 20:17:29');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (249, 'Miqdad', 11, '2026-08-04 20:17:29', '2026-08-04 20:17:29');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (250, 'Moh. Zulfian Sheehan Yusuf Iskandar', 11, '2026-08-04 20:17:29', '2026-08-04 20:17:29');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (251, 'Muhammad Abbas Fudhail', 11, '2026-08-04 20:17:29', '2026-08-04 20:17:29');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (252, 'Muhammad Athiq Al Karim', 11, '2026-08-04 20:17:29', '2026-08-04 20:17:29');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (253, 'Muhammad Dhamar Agratha', 11, '2026-08-04 20:17:29', '2026-08-04 20:17:29');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (254, 'Muhamad Dimas Arrijalu', 11, '2026-08-04 20:17:29', '2026-08-04 20:17:29');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (255, 'Muhammad Fakhri', 11, '2026-08-04 20:17:29', '2026-08-04 20:17:29');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (256, 'Muhammad Farabi Alviansyah', 11, '2026-08-04 20:17:29', '2026-08-04 20:17:29');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (257, 'Muhammad Ibrahim Sholeh', 11, '2026-08-04 20:17:29', '2026-08-04 20:17:29');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (258, 'Muhammad Ikhsan Kamil', 11, '2026-08-04 20:17:29', '2026-08-04 20:17:29');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (259, 'Muhammad Kiromim Baroroh', 11, '2026-08-04 20:17:29', '2026-08-04 20:17:29');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (260, 'Muhammad Sulthonul Aulya'' Fahrezy', 11, '2026-08-04 20:17:29', '2026-08-04 20:17:29');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (261, 'Muhammad Sulton Al Mufid', 11, '2026-08-04 20:17:29', '2026-08-04 20:17:29');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (262, 'Muhammad Wafa Musthofa', 11, '2026-08-04 20:17:29', '2026-08-04 20:17:29');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (263, 'Muhammad Yugi Bagus Arkawardana', 11, '2026-08-04 20:17:29', '2026-08-04 20:17:29');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (264, 'Muhammad Zidan Maulana', 11, '2026-08-04 20:17:29', '2026-08-04 20:17:29');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (265, 'Muhammad Zulfikar Alfi', 11, '2026-08-04 20:17:29', '2026-08-04 20:17:29');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (266, 'Mukhbit Yafi'' Azzam Achmad', 11, '2026-08-04 20:17:29', '2026-08-04 20:17:29');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (267, 'Rafa Fauzi Lahdji', 11, '2026-08-04 20:17:29', '2026-08-04 20:17:29');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (268, 'Rafandra Rasyid Athaullah', 11, '2026-08-04 20:17:29', '2026-08-04 20:17:29');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (269, 'Raihan Satria Hamaddi', 11, '2026-08-04 20:17:29', '2026-08-04 20:17:29');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (270, 'Roihan Ali Ar Raashid', 11, '2026-08-04 20:17:29', '2026-08-04 20:17:29');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (271, 'Uwais Al Atsary', 11, '2026-08-04 20:17:29', '2026-08-04 20:17:29');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (272, 'Wildan Rifqi Ar Rosyidi', 11, '2026-08-04 20:17:29', '2026-08-04 20:17:29');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (273, 'Yusuf Habibie Rahman', 11, '2026-08-04 20:17:29', '2026-08-04 20:17:29');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (274, 'Zaidan Aghniya Ilman', 11, '2026-08-04 20:17:29', '2026-08-04 20:17:29');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (275, 'Zaki El Thabrany Yusuf', 11, '2026-08-04 20:17:29', '2026-08-04 20:17:29');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (276, 'Ridho Azam Faruqi', 11, '2026-08-04 20:17:29', '2026-08-04 20:17:29');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (277, 'Salman Alfarisi Maftuh', 11, '2026-08-04 20:17:29', '2026-08-04 20:17:29');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (278, 'Ahmad', 10, '2026-08-04 20:20:01', '2026-08-04 20:20:01');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (280, 'Ahmad Faiq Izzuddin', 10, '2026-08-04 20:20:01', '2026-08-04 20:20:01');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (281, 'Ahmad Hafidz Asy Syahmi Ati`Ullah', 10, '2026-08-04 20:20:01', '2026-08-04 20:20:01');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (282, 'Ahmad Shafin Ghaffarel Zahid', 10, '2026-08-04 20:20:01', '2026-08-04 20:20:01');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (283, 'Ali Abdurrohman', 10, '2026-08-04 20:20:01', '2026-08-04 20:20:01');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (284, 'Alifrizky Ahmadghani Yogaputra', 10, '2026-08-04 20:20:01', '2026-08-04 20:20:01');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (285, 'Arga Fikhi Prastyo', 10, '2026-08-04 20:20:01', '2026-08-04 20:20:01');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (286, 'Azmi Rafisyah', 10, '2026-08-04 20:20:01', '2026-08-04 20:20:01');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (287, 'Dendi Ghulman Hilmy Rafi', 10, '2026-08-04 20:20:01', '2026-08-04 20:20:01');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (288, 'Excel Ibra Afendra', 10, '2026-08-04 20:20:01', '2026-08-04 20:20:01');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (289, 'Failasuf Ahfiyan Masyhuri', 10, '2026-08-04 20:20:01', '2026-08-04 20:20:01');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (290, 'Falih Nur Ali Fansyah', 10, '2026-08-04 20:20:01', '2026-08-04 20:20:01');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (291, 'Faraj Abdurrohman', 10, '2026-08-04 20:20:01', '2026-08-04 20:20:01');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (292, 'Fawwaz Ahmad Syaddad', 10, '2026-08-04 20:20:01', '2026-08-04 20:20:01');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (293, 'Fiqri Hanif Ramadhan', 10, '2026-08-04 20:20:01', '2026-08-04 20:20:01');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (294, 'Ghulam Hadzaqi Nafhan', 10, '2026-08-04 20:20:01', '2026-08-04 20:20:01');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (295, 'Ibnu Hafiz Al Furqon', 10, '2026-08-04 20:20:01', '2026-08-04 20:20:01');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (296, 'Iqbaal Sabilul Muttaqin', 10, '2026-08-04 20:20:01', '2026-08-04 20:20:01');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (297, 'Keanu Rafa Akbar Ardiansyah', 10, '2026-08-04 20:20:01', '2026-08-04 20:20:01');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (298, 'Kiandra Aditya Jabar Widiarto', 10, '2026-08-04 20:20:01', '2026-08-04 20:20:01');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (299, 'Mohammad Fauzi Mukhtar Mansoor', 10, '2026-08-04 20:20:01', '2026-08-04 20:20:01');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (300, 'Muhammad Jami'' Albani Romadhon', 10, '2026-08-04 20:20:01', '2026-08-04 20:20:01');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (301, 'Muhammad Abid', 10, '2026-08-04 20:20:01', '2026-08-04 20:20:01');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (302, 'Muhammad Al Abid Suja''i', 10, '2026-08-04 20:20:01', '2026-08-04 20:20:01');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (303, 'Muhammad Ammar Rachmadi', 10, '2026-08-04 20:20:01', '2026-08-04 20:20:01');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (304, 'Muhammad Asep Maulana', 10, '2026-08-04 20:20:01', '2026-08-04 20:20:01');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (305, 'Muhammad Burhan Ibrahim', 10, '2026-08-04 20:20:01', '2026-08-04 20:20:01');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (306, 'Muhammad Fadly Rahman', 10, '2026-08-04 20:20:01', '2026-08-04 20:20:01');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (307, 'Muhammad Farhan Ibrahim', 10, '2026-08-04 20:20:01', '2026-08-04 20:20:01');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (308, 'Muhammad Fathan Arrizqi', 10, '2026-08-04 20:20:01', '2026-08-04 20:20:01');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (309, 'Muhammad Habil Abdurrohman', 10, '2026-08-04 20:20:01', '2026-08-04 20:20:01');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (310, 'Muhammad Iqbal Setiawan', 10, '2026-08-04 20:20:01', '2026-08-04 20:20:01');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (311, 'Muhammad Nabil Al-Fath', 10, '2026-08-04 20:20:01', '2026-08-04 20:20:01');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (312, 'Muhammad Nuril Avinsyah', 10, '2026-08-04 20:20:01', '2026-08-04 20:20:01');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (313, 'Muhammad Rafi Mubarok', 10, '2026-08-04 20:20:01', '2026-08-04 20:20:01');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (314, 'Muhammad Ramdhan Putra Prasetia', 10, '2026-08-04 20:20:01', '2026-08-04 20:20:01');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (315, 'Muhammad Rayyan Tizza El Hamidy', 10, '2026-08-04 20:20:01', '2026-08-04 20:20:01');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (316, 'Muhammad Satria Muzakki', 10, '2026-08-04 20:20:01', '2026-08-04 20:20:01');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (317, 'Muhammad Syarief Hidayatullah Arrafik', 10, '2026-08-04 20:20:01', '2026-08-04 20:20:01');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (318, 'Muhammad Tsabit Addin', 10, '2026-08-04 20:20:01', '2026-08-04 20:20:01');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (319, 'Muhammad Yahya', 10, '2026-08-04 20:20:01', '2026-08-04 20:20:01');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (320, 'Naufal Abdullah', 10, '2026-08-04 20:20:01', '2026-08-04 20:20:01');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (321, 'Qotadah Ahmad', 10, '2026-08-04 20:20:01', '2026-08-04 20:20:01');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (322, 'Raditya Wahyu Pratama', 10, '2026-08-04 20:20:01', '2026-08-04 20:20:01');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (323, 'Ralilur Rahman Ramadhani', 10, '2026-08-04 20:20:01', '2026-08-04 20:20:01');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (324, 'Rifqy Hanif', 10, '2026-08-04 20:20:01', '2026-08-04 20:20:01');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (325, 'Romy Zhiyaulhaq Shaleh', 10, '2026-08-04 20:20:01', '2026-08-04 20:20:01');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (326, 'Sholih Utsaimin', 10, '2026-08-04 20:20:01', '2026-08-04 20:20:01');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (327, 'Sulaim', 10, '2026-08-04 20:20:01', '2026-08-04 20:20:01');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (328, 'Syafiq', 10, '2026-08-04 20:20:01', '2026-08-04 20:20:01');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (329, 'Wildan Fakhri Ardhani', 10, '2026-08-04 20:20:01', '2026-08-04 20:20:01');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (330, 'Abu Bahris Taufiq', 9, '2026-08-04 20:24:08', '2026-08-04 20:24:08');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (331, 'Achmad Fawwaz Al Hafiy', 9, '2026-08-04 20:24:08', '2026-08-04 20:24:08');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (332, 'Achvi Akbar Jagad Putra', 9, '2026-08-04 20:24:08', '2026-08-04 20:24:08');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (333, 'Aditya Wicaksono Pratama', 9, '2026-08-04 20:24:08', '2026-08-04 20:24:08');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (334, 'Ahmad', 9, '2026-08-04 20:24:08', '2026-08-04 20:24:08');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (335, 'Ahmad Fathir Azzamy', 9, '2026-08-04 20:24:08', '2026-08-04 20:24:08');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (336, 'Ahmad Habib Al Anshori', 9, '2026-08-04 20:24:08', '2026-08-04 20:24:08');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (337, 'Ahmad Habib Ashari', 9, '2026-08-04 20:24:08', '2026-08-04 20:24:08');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (338, 'Ahmad Labib Firdausy', 9, '2026-08-04 20:24:08', '2026-08-04 20:24:08');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (339, 'Ahyan Nawfal Ali', 9, '2026-08-04 20:24:08', '2026-08-04 20:24:08');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (340, 'Aiko Hafizh Rizaldi', 9, '2026-08-04 20:24:08', '2026-08-04 20:24:08');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (341, 'Alif Akbar Bilqisti', 9, '2026-08-04 20:24:08', '2026-08-04 20:24:08');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (342, 'Alif Zaidan Zidna Ismail', 9, '2026-08-04 20:24:08', '2026-08-04 20:24:08');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (343, 'Alkhalifi Rizky Mayza', 9, '2026-08-04 20:24:08', '2026-08-04 20:24:08');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (344, 'Ammar Zaidan', 9, '2026-08-04 20:24:08', '2026-08-04 20:24:08');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (345, 'Ammar Zulfadhli', 9, '2026-08-04 20:24:08', '2026-08-04 20:24:08');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (346, 'Arshavin Zamir Nizar', 9, '2026-08-04 20:24:08', '2026-08-04 20:24:08');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (347, 'Aryoga Hadjuan Alfarisi', 9, '2026-08-04 20:24:08', '2026-08-04 20:24:08');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (348, 'Assandhrya Zhian Alfarezel', 9, '2026-08-04 20:24:08', '2026-08-04 20:24:08');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (349, 'Azfer Zabir Syah', 9, '2026-08-04 20:24:08', '2026-08-04 20:24:08');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (350, 'Dzaky Rizki Ramadhan Kuswanto', 9, '2026-08-04 20:24:08', '2026-08-04 20:24:08');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (351, 'Eileen Kurniawan', 9, '2026-08-04 20:24:08', '2026-08-04 20:24:08');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (352, 'Farel Wihar Athallah', 9, '2026-08-04 20:24:08', '2026-08-04 20:24:08');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (353, 'Faruq Rashiidan Fuad', 9, '2026-08-04 20:24:08', '2026-08-04 20:24:08');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (354, 'Fathan Ahmad Hammami', 9, '2026-08-04 20:24:08', '2026-08-04 20:24:08');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (355, 'Freyviano Muhammad Alraisya', 9, '2026-08-04 20:24:08', '2026-08-04 20:24:08');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (356, 'Galih Muazam Rizkian Pamujo', 9, '2026-08-04 20:24:08', '2026-08-04 20:24:08');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (357, 'Gavin Ibrahim Ahmad', 9, '2026-08-04 20:24:08', '2026-08-04 20:24:08');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (358, 'Gilang Ramadhan', 9, '2026-08-04 20:24:08', '2026-08-04 20:24:08');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (359, 'Hadiid Panca Fadhila', 9, '2026-08-04 20:24:08', '2026-08-04 20:24:08');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (360, 'Hajar Herdiansyah Hermanto', 9, '2026-08-04 20:24:08', '2026-08-04 20:24:08');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (361, 'Hamim Muhammad Rizky', 9, '2026-08-04 20:24:08', '2026-08-04 20:24:08');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (362, 'Hamzah', 9, '2026-08-04 20:24:08', '2026-08-04 20:24:08');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (363, 'Khrisna Fetrianno', 9, '2026-08-04 20:24:08', '2026-08-04 20:24:08');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (364, 'Kotob Al Haq', 9, '2026-08-04 20:24:08', '2026-08-04 20:24:08');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (365, 'Laits Fatih Al-Abqary', 9, '2026-08-04 20:24:08', '2026-08-04 20:24:08');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (366, 'Marcelio Yudha Eldiansyah', 9, '2026-08-04 20:24:08', '2026-08-04 20:24:08');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (367, 'Mirza Maziz An - Nazrin', 9, '2026-08-04 20:24:08', '2026-08-04 20:24:08');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (368, 'Moch. Fikri Rizal Syahputra', 9, '2026-08-04 20:24:08', '2026-08-04 20:24:08');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (369, 'Moch Nouvaldo Karim Wibowo', 9, '2026-08-04 20:24:08', '2026-08-04 20:24:08');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (370, 'Moh. Faiq El-Kholil', 9, '2026-08-04 20:24:08', '2026-08-04 20:24:08');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (371, 'Muchammad Adel Saif', 9, '2026-08-04 20:24:08', '2026-08-04 20:24:08');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (372, 'Muchammad Al Khalifi Dzikri', 9, '2026-08-04 20:24:08', '2026-08-04 20:24:08');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (373, 'Muchammad Fathul Alim', 9, '2026-08-04 20:24:08', '2026-08-04 20:24:08');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (374, 'Muchammad Irfan Abdullah', 9, '2026-08-04 20:24:08', '2026-08-04 20:24:08');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (375, 'Muchammad Salahuddin Al Ayyubi', 9, '2026-08-04 20:24:08', '2026-08-04 20:24:08');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (376, 'Muhammad Abdurrahman Al Hudzaifi', 9, '2026-08-04 20:24:08', '2026-08-04 20:24:08');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (377, 'Muhammad Dzaky Hafidzulloh', 9, '2026-08-04 20:24:08', '2026-08-04 20:24:08');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (378, 'Mochammad Fa''iq', 9, '2026-08-04 20:24:08', '2026-08-04 20:24:08');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (379, 'Muhammad Fashihu Lisan', 9, '2026-08-04 20:24:08', '2026-08-04 20:24:08');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (380, 'Muhammad Ghifari Albani', 9, '2026-08-04 20:24:08', '2026-08-04 20:24:08');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (381, 'Muhammad Haniffathin Al Fawwaz', 9, '2026-08-04 20:24:08', '2026-08-04 20:24:08');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (382, 'Muhammad Ibrahim Syaukah Attaqiy', 9, '2026-08-04 20:24:08', '2026-08-04 20:24:08');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (383, 'Muhammad Irfan Saifuddin', 9, '2026-08-04 20:24:08', '2026-08-04 20:24:08');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (384, 'Muhammad Kaffa Elmizan Vanindano', 9, '2026-08-04 20:24:08', '2026-08-04 20:24:08');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (385, 'Muhammad Mumtaazul Falah Muhdi', 9, '2026-08-04 20:24:08', '2026-08-04 20:24:08');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (386, 'Muhammad Nabhan Al Miqdam', 9, '2026-08-04 20:24:08', '2026-08-04 20:24:08');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (387, 'Muhammad Nabhan Albharra', 9, '2026-08-04 20:24:08', '2026-08-04 20:24:08');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (388, 'Muhammad Nabil Firdausy', 9, '2026-08-04 20:24:08', '2026-08-04 20:24:08');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (389, 'Muhammad Nazeef Hisyam Rizqullah', 9, '2026-08-04 20:24:08', '2026-08-04 20:24:08');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (390, 'Muhammad Rasyad Zulkarnain', 9, '2026-08-04 20:24:08', '2026-08-04 20:24:08');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (391, 'Muhammad Zahir Ishaag', 9, '2026-08-04 20:24:08', '2026-08-04 20:24:08');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (392, 'Muhammad Arrizky Maulana Ihsan', 9, '2026-08-04 20:24:08', '2026-08-04 20:24:08');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (393, 'Nabil Rafa Altair', 9, '2026-08-04 20:24:08', '2026-08-04 20:24:08');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (394, 'Omar Sadat Al Fikri', 9, '2026-08-04 20:24:08', '2026-08-04 20:24:08');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (395, 'Putra Abraham Nur Ihsan', 9, '2026-08-04 20:24:08', '2026-08-04 20:24:08');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (396, 'Putra Ibrahim Nur Ihsan', 9, '2026-08-04 20:24:08', '2026-08-04 20:24:08');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (397, 'Radhika Hanif Komaruddin', 9, '2026-08-04 20:24:08', '2026-08-04 20:24:08');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (398, 'Rafandra Bagas Pratama', 9, '2026-08-04 20:24:08', '2026-08-04 20:24:08');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (399, 'Raffasya Rafif Azka Widodo', 9, '2026-08-04 20:24:08', '2026-08-04 20:24:08');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (400, 'Rasya Muhammad Athaya', 9, '2026-08-04 20:24:08', '2026-08-04 20:24:08');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (401, 'Rayyan Akil Fairuz Zikri', 9, '2026-08-04 20:24:08', '2026-08-04 20:24:08');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (402, 'Rendra Dean Averill', 9, '2026-08-04 20:24:08', '2026-08-04 20:24:08');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (403, 'Rizaniansyah Radithya Aji', 9, '2026-08-04 20:24:08', '2026-08-04 20:24:08');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (404, 'Rizki Putra Aulia', 9, '2026-08-04 20:24:08', '2026-08-04 20:24:08');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (405, 'Rizqi Dafiqi Daiman', 9, '2026-08-04 20:24:08', '2026-08-04 20:24:08');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (406, 'Uwais Al Qorni Maftuh', 9, '2026-08-04 20:24:08', '2026-08-04 20:24:08');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (407, 'Zacky Ferdinansyah Al-Hakim', 9, '2026-08-04 20:24:08', '2026-08-04 20:24:08');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (408, 'Zainuddin Ardy Zidane', 9, '2026-08-04 20:24:08', '2026-08-04 20:24:08');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (409, 'Abdullah Uwais Ats Tsauri', 8, '2026-08-04 20:29:38', '2026-08-04 20:29:38');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (410, 'Abid Aqila Kayungga', 8, '2026-08-04 20:29:38', '2026-08-04 20:29:38');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (411, 'Achmad Al-Rasyad Adhistira', 8, '2026-08-04 20:29:38', '2026-08-04 20:29:38');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (412, 'Achmad Fatoni', 8, '2026-08-04 20:29:38', '2026-08-04 20:29:38');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (413, 'Al Ghifran Nabhan Pradipta', 8, '2026-08-04 20:29:38', '2026-08-04 20:29:38');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (414, 'Ashim Bin Tsabit', 8, '2026-08-04 20:29:38', '2026-08-04 20:29:38');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (415, 'Aufar Zavier Ramadhan', 8, '2026-08-04 20:29:38', '2026-08-04 20:29:38');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (416, 'Azka Nuriz Zahin', 8, '2026-08-04 20:29:38', '2026-08-04 20:29:38');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (417, 'Azriel Zidane Alrasyid', 8, '2026-08-04 20:29:38', '2026-08-04 20:29:38');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (418, 'Bryan Dimas Andika', 8, '2026-08-04 20:29:38', '2026-08-04 20:29:38');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (419, 'Carel Bravedo Rimbono', 8, '2026-08-04 20:29:38', '2026-08-04 20:29:38');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (420, 'Dahliz Nur Muhammad', 8, '2026-08-04 20:29:38', '2026-08-04 20:29:38');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (421, 'Damon Ramadhan Ahmad', 8, '2026-08-04 20:29:38', '2026-08-04 20:29:38');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (422, 'Fadil Wahyu Priyambada', 8, '2026-08-04 20:29:38', '2026-08-04 20:29:38');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (423, 'Faeyza Rahmatullah', 8, '2026-08-04 20:29:38', '2026-08-04 20:29:38');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (424, 'Fahim Khoiru Insan', 8, '2026-08-04 20:29:38', '2026-08-04 20:29:38');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (425, 'Fauzullah Zhaki Hamdani', 8, '2026-08-04 20:29:38', '2026-08-04 20:29:38');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (426, 'Fawwaz Abdillah Mar''i', 8, '2026-08-04 20:29:38', '2026-08-04 20:29:38');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (427, 'Hisyam Fattan Rafisqy Mashuri', 8, '2026-08-04 20:29:38', '2026-08-04 20:29:38');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (428, 'Ibrahim Khorulfashilin Riffat', 8, '2026-08-04 20:29:38', '2026-08-04 20:29:38');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (429, 'M. Lazuardi Athariusjavas Alcantara', 8, '2026-08-04 20:29:38', '2026-08-04 20:29:38');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (430, 'M.Nizam As Shahabi', 8, '2026-08-04 20:29:38', '2026-08-04 20:29:38');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (431, 'Marvel Khalif Edgina Kayana', 8, '2026-08-04 20:29:38', '2026-08-04 20:29:38');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (432, 'Mochammad Althaf Prawira Wardhana', 8, '2026-08-04 20:29:38', '2026-08-04 20:29:38');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (433, 'Muhammad Abdillah Azzam', 8, '2026-08-04 20:29:38', '2026-08-04 20:29:38');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (434, 'Muhammad Abdurrozaq', 8, '2026-08-04 20:29:38', '2026-08-04 20:29:38');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (435, 'Muhammad Afan Muzakki', 8, '2026-08-04 20:29:38', '2026-08-04 20:29:38');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (436, 'Muhammad Alif Fathoni', 8, '2026-08-04 20:29:38', '2026-08-04 20:29:38');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (437, 'Muhammad Asyraf Aufar As-Syakib', 8, '2026-08-04 20:29:38', '2026-08-04 20:29:38');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (438, 'Muhammad Faiz Akbar Rachmadi', 8, '2026-08-04 20:29:38', '2026-08-04 20:29:38');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (439, 'Muhammad Farhan', 8, '2026-08-04 20:29:38', '2026-08-04 20:29:38');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (440, 'Muhammad Hafidz Zulkarnain', 8, '2026-08-04 20:29:38', '2026-08-04 20:29:38');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (441, 'Muhammad Hanif', 8, '2026-08-04 20:29:38', '2026-08-04 20:29:38');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (442, 'Muhammad Isa Aminuddin', 8, '2026-08-04 20:29:38', '2026-08-04 20:29:38');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (443, 'Muhammad Lintang Rasendriya', 8, '2026-08-04 20:29:38', '2026-08-04 20:29:38');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (444, 'Muhammad Taufiqur Rohman', 8, '2026-08-04 20:29:38', '2026-08-04 20:29:38');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (445, 'Muhammad Uwais Al Qarny Wibisono', 8, '2026-08-04 20:29:38', '2026-08-04 20:29:38');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (446, 'Mujahid Al Khafi', 8, '2026-08-04 20:29:38', '2026-08-04 20:29:38');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (447, 'Narendra Diaz Ibrahim', 8, '2026-08-04 20:29:38', '2026-08-04 20:29:38');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (448, 'Naufal Afham Dhiya El Haq', 8, '2026-08-04 20:29:38', '2026-08-04 20:29:38');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (449, 'Nazril Al-Khalis Ramadhan Prasetyo', 8, '2026-08-04 20:29:38', '2026-08-04 20:29:38');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (450, 'Putra Airlangga Panca Nugraha', 8, '2026-08-04 20:29:38', '2026-08-04 20:29:38');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (451, 'Rafif Syafrizal Ardzabilly Syakur', 8, '2026-08-04 20:29:38', '2026-08-04 20:29:38');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (452, 'Yahya Alfatih', 8, '2026-08-04 20:29:38', '2026-08-04 20:29:38');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (453, 'Zaid Mudzakir Ar Rosyad', 8, '2026-08-04 20:29:38', '2026-08-04 20:29:38');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (454, 'Zaki M. Nurdin', 8, '2026-08-04 20:29:38', '2026-08-04 20:29:38');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (455, 'Zhafran Naqila Al-Azhar', 8, '2026-08-04 20:29:38', '2026-08-04 20:29:38');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (456, 'Zul Fadhli Akbar Prastyo', 8, '2026-08-04 20:29:38', '2026-08-04 20:29:38');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (457, 'al-hasan', 7, '2026-08-04 20:35:16', '2026-08-04 20:35:16');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (458, 'hanif al-hafidz', 7, '2026-08-04 20:35:16', '2026-08-04 20:35:16');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (459, 'fathir', 7, '2026-08-04 20:35:16', '2026-08-04 20:35:16');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (460, 'ibrahim achmad', 7, '2026-08-04 20:35:16', '2026-08-04 20:35:16');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (461, 'fathani', 7, '2026-08-04 20:35:16', '2026-08-04 20:35:16');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (462, 'abdullah novel', 7, '2026-08-04 20:35:16', '2026-08-04 20:35:16');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (463, 'abdurrahman', 7, '2026-08-04 20:35:16', '2026-08-04 20:35:16');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (464, 'hasbian', 7, '2026-08-04 20:35:16', '2026-08-04 20:35:16');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (465, 'ja''far', 7, '2026-08-04 20:35:16', '2026-08-04 20:35:16');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (466, 'farhan ts', 7, '2026-08-04 20:35:16', '2026-08-04 20:35:16');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (467, 'muhammad kahil', 7, '2026-08-04 20:35:16', '2026-08-04 20:35:16');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (468, 'azizan', 7, '2026-08-04 20:35:16', '2026-08-04 20:35:16');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (469, 'm. alawy', 7, '2026-08-04 20:35:16', '2026-08-04 20:35:16');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (470, 'azzam syarif', 7, '2026-08-04 20:35:16', '2026-08-04 20:35:16');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (471, 'm.khalifah', 7, '2026-08-04 20:35:16', '2026-08-04 20:35:16');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (472, 'arjuna', 7, '2026-08-04 20:35:16', '2026-08-04 20:35:16');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (473, 'ahmad fatih', 7, '2026-08-04 20:35:16', '2026-08-04 20:35:16');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (474, 'ibrahim', 7, '2026-08-04 20:35:16', '2026-08-04 20:35:16');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (475, 'm.afif', 7, '2026-08-04 20:35:16', '2026-08-04 20:35:16');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (476, 'm.hibban', 7, '2026-08-04 20:35:16', '2026-08-04 20:35:16');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (477, 'al ayyubi', 7, '2026-08-04 20:35:16', '2026-08-04 20:35:16');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (478, 'al-khalifi sakha', 7, '2026-08-04 20:35:16', '2026-08-04 20:35:16');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (479, 'kinseyfan', 7, '2026-08-04 20:35:16', '2026-08-04 20:35:16');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (480, 'al-farisi', 7, '2026-08-04 20:35:16', '2026-08-04 20:35:16');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (481, 'm.musa', 7, '2026-08-04 20:35:16', '2026-08-04 20:35:16');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (482, 'agha rafie', 7, '2026-08-04 20:35:16', '2026-08-04 20:35:16');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (483, 'hafizh hadi', 7, '2026-08-04 20:35:16', '2026-08-04 20:35:16');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (484, 'zhafran', 7, '2026-08-04 20:35:16', '2026-08-04 20:35:16');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (485, 'zaid alif', 7, '2026-08-04 20:35:16', '2026-08-04 20:35:16');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (486, 'nur hasan', 7, '2026-08-04 20:35:16', '2026-08-04 20:35:16');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (487, 'rizky azka', 7, '2026-08-04 20:35:16', '2026-08-04 20:35:16');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (488, 'qowwam bilhaq', 7, '2026-08-04 20:35:16', '2026-08-04 20:35:16');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (489, 'm.safir', 7, '2026-08-04 20:35:16', '2026-08-04 20:35:16');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (490, 'reiza', 7, '2026-08-04 20:35:16', '2026-08-04 20:35:16');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (491, 'uways al-qorny', 7, '2026-08-04 20:35:16', '2026-08-04 20:35:16');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (492, 'salman m.', 7, '2026-08-04 20:35:16', '2026-08-04 20:35:16');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (493, 'naufal ibnu', 7, '2026-08-04 20:35:16', '2026-08-04 20:35:16');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (494, 'm.wahyu', 7, '2026-08-04 20:35:16', '2026-08-04 20:35:16');
INSERT INTO public.siswa (id, nama_siswa, kelas, created_at, updated_at) VALUES (495, 'musthofa', 7, '2026-08-04 20:35:16', '2026-08-04 20:35:16');


--
-- TOC entry 4943 (class 0 OID 16446)
-- Dependencies: 229
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.users (id, username, password, role, created_at, updated_at) VALUES (1, 'admin', '$2y$12$8rNE./h/KQoNiAvIZC/b2.1EXDyR9n9i7/xfMQKYnONz3w/T/d33m', 'admin', '2026-05-06 16:26:37', '2026-05-06 20:48:07');
INSERT INTO public.users (id, username, password, role, created_at, updated_at) VALUES (6, 'rafa', '$2y$12$ZS5EWA09R4ue6u3k3uMHC.Yan5owYGlaWD1eVjriHTdBTe0POd4vq', 'qism', '2026-05-06 20:48:59', '2026-05-12 19:52:06');
INSERT INTO public.users (id, username, password, role, created_at, updated_at) VALUES (5, 'syamsi', '$2y$12$NiC6x2NTP9by3uuPYvAG5.B.YHLlqAbYUAZa371LDIleUYcPM7DKy', 'qism', '2026-05-06 20:48:47', '2026-05-14 19:44:22');
INSERT INTO public.users (id, username, password, role, created_at, updated_at) VALUES (3, 'zidan', '$2y$12$tsIuvCRofQp8LWwt/126duuuC1xY3K5blOFAJhVq8WJikFZK8Dy5G', 'qism', '2026-05-06 20:48:28', '2026-05-29 07:31:29');
INSERT INTO public.users (id, username, password, role, created_at, updated_at) VALUES (4, 'kiromim', '$2y$12$xz9Pc4U7KwT3YmO1mJRXpeTuLRrPJJmc/AP5OblUdFiBfDKg8lK3q', 'qism', '2026-05-06 20:48:39', '2026-05-29 07:33:41');
INSERT INTO public.users (id, username, password, role, created_at, updated_at) VALUES (8, 'test', '$2y$12$z1Pgy1pDq.XGsLXEFMzrDuyvPZZ.x7mSPpmKvHXTqWXq8tiyJk9D2', 'qism', '2026-05-19 12:46:35', '2026-07-30 14:44:55');


--
-- TOC entry 4955 (class 0 OID 0)
-- Dependencies: 222
-- Name: migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.migrations_id_seq', 5, true);


--
-- TOC entry 4956 (class 0 OID 0)
-- Dependencies: 224
-- Name: personal_access_tokens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.personal_access_tokens_id_seq', 251, true);


--
-- TOC entry 4957 (class 0 OID 0)
-- Dependencies: 226
-- Name: points_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.points_id_seq', 4368, true);


--
-- TOC entry 4958 (class 0 OID 0)
-- Dependencies: 228
-- Name: siswa_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.siswa_id_seq', 495, true);


--
-- TOC entry 4959 (class 0 OID 0)
-- Dependencies: 230
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 8, true);


--
-- TOC entry 4765 (class 2606 OID 16462)
-- Name: cache_locks cache_locks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cache_locks
    ADD CONSTRAINT cache_locks_pkey PRIMARY KEY (key);


--
-- TOC entry 4762 (class 2606 OID 16464)
-- Name: cache cache_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cache
    ADD CONSTRAINT cache_pkey PRIMARY KEY (key);


--
-- TOC entry 4767 (class 2606 OID 16466)
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- TOC entry 4770 (class 2606 OID 16468)
-- Name: personal_access_tokens personal_access_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personal_access_tokens
    ADD CONSTRAINT personal_access_tokens_pkey PRIMARY KEY (id);


--
-- TOC entry 4772 (class 2606 OID 16470)
-- Name: personal_access_tokens personal_access_tokens_token_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personal_access_tokens
    ADD CONSTRAINT personal_access_tokens_token_unique UNIQUE (token);


--
-- TOC entry 4775 (class 2606 OID 16472)
-- Name: points points_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.points
    ADD CONSTRAINT points_pkey PRIMARY KEY (id);


--
-- TOC entry 4779 (class 2606 OID 16474)
-- Name: siswa siswa_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.siswa
    ADD CONSTRAINT siswa_pkey PRIMARY KEY (id);


--
-- TOC entry 4781 (class 2606 OID 16476)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 4783 (class 2606 OID 16478)
-- Name: users users_username_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_unique UNIQUE (username);


--
-- TOC entry 4760 (class 1259 OID 16479)
-- Name: cache_expiration_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX cache_expiration_index ON public.cache USING btree (expiration);


--
-- TOC entry 4763 (class 1259 OID 16480)
-- Name: cache_locks_expiration_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX cache_locks_expiration_index ON public.cache_locks USING btree (expiration);


--
-- TOC entry 4768 (class 1259 OID 16481)
-- Name: personal_access_tokens_expires_at_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX personal_access_tokens_expires_at_index ON public.personal_access_tokens USING btree (expires_at);


--
-- TOC entry 4773 (class 1259 OID 16482)
-- Name: personal_access_tokens_tokenable_type_tokenable_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX personal_access_tokens_tokenable_type_tokenable_id_index ON public.personal_access_tokens USING btree (tokenable_type, tokenable_id);


--
-- TOC entry 4776 (class 1259 OID 16483)
-- Name: points_tanggal_kategori_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX points_tanggal_kategori_index ON public.points USING btree (tanggal, kategori);


--
-- TOC entry 4777 (class 1259 OID 16484)
-- Name: siswa_kelas_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX siswa_kelas_index ON public.siswa USING btree (kelas);


--
-- TOC entry 4784 (class 2606 OID 16485)
-- Name: points points_input_by_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.points
    ADD CONSTRAINT points_input_by_foreign FOREIGN KEY (input_by) REFERENCES public.users(id);


--
-- TOC entry 4785 (class 2606 OID 16490)
-- Name: points points_siswa_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.points
    ADD CONSTRAINT points_siswa_id_foreign FOREIGN KEY (siswa_id) REFERENCES public.siswa(id) ON DELETE CASCADE;


-- Completed on 2026-08-23 09:17:40

--
-- PostgreSQL database dump complete
--

\unrestrict D2ddzN0uzTWIE8aKe0rZtvJaGXjbreCcuXV9WEyUETwYlZl6QeSxd9tbCnm3Gmj

