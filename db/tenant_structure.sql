--
-- PostgreSQL database dump
--

\restrict Q2ReIU4esmeP4VUU2H6C23w1mBi9VivWc68Kb9bRyPD38ccTc94y0BOiXm3WS6N

-- Dumped from database version 15.17
-- Dumped by pg_dump version 15.17

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.ar_internal_metadata OWNER TO postgres;

--
-- Name: categorias; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE categorias (
    id bigint NOT NULL,
    nome character varying NOT NULL,
    descricao text,
    ativo boolean DEFAULT true NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE categorias OWNER TO postgres;

--
-- Name: categorias_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE categorias_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE categorias_id_seq OWNER TO postgres;

--
-- Name: categorias_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE categorias_id_seq OWNED BY public.categorias.id;


--
-- Name: escolas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.escolas (
    id bigint NOT NULL,
    nome character varying NOT NULL,
    slug character varying NOT NULL,
    schema_name character varying NOT NULL,
    cnpj character varying NOT NULL,
    email character varying NOT NULL,
    telefone character varying NOT NULL,
    ativo boolean NOT NULL,
    metadata jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    rede_id bigint
);


ALTER TABLE public.escolas OWNER TO postgres;

--
-- Name: escolas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.escolas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.escolas_id_seq OWNER TO postgres;

--
-- Name: escolas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.escolas_id_seq OWNED BY public.escolas.id;


--
-- Name: estudantes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE estudantes (
    id bigint NOT NULL,
    matricula character varying,
    turma character varying,
    serie integer,
    data_nascimento date,
    responsavel_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    nivel_escolaridade integer
);


ALTER TABLE estudantes OWNER TO postgres;

--
-- Name: estudantes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE estudantes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE estudantes_id_seq OWNER TO postgres;

--
-- Name: estudantes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE estudantes_id_seq OWNED BY public.estudantes.id;


--
-- Name: perfis; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.perfis (
    id bigint NOT NULL,
    nome character varying,
    cpf character varying,
    data_nascimento date,
    telefone character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    user_id bigint NOT NULL
);


ALTER TABLE public.perfis OWNER TO postgres;

--
-- Name: perfis_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE perfis_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE perfis_id_seq OWNER TO postgres;

--
-- Name: perfis_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE perfis_id_seq OWNED BY public.perfis.id;


--
-- Name: permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.permissions (
    id bigint NOT NULL,
    nome character varying,
    recurso character varying,
    acao character varying,
    descricao character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.permissions OWNER TO postgres;

--
-- Name: permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.permissions_id_seq OWNER TO postgres;

--
-- Name: permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.permissions_id_seq OWNED BY public.permissions.id;


--
-- Name: produtos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE produtos (
    id bigint NOT NULL,
    nome character varying NOT NULL,
    descricao text,
    preco numeric(10,2) NOT NULL,
    estoque integer DEFAULT 0 NOT NULL,
    ativo boolean DEFAULT true NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    categoria_id bigint NOT NULL
);


ALTER TABLE produtos OWNER TO postgres;

--
-- Name: produtos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE produtos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE produtos_id_seq OWNER TO postgres;

--
-- Name: produtos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE produtos_id_seq OWNED BY public.produtos.id;


--
-- Name: redes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.redes (
    id bigint NOT NULL,
    nome character varying NOT NULL,
    slug character varying NOT NULL,
    descricao text,
    metadata jsonb DEFAULT '{}'::jsonb NOT NULL,
    ativo boolean DEFAULT true NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.redes OWNER TO postgres;

--
-- Name: redes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.redes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.redes_id_seq OWNER TO postgres;

--
-- Name: redes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.redes_id_seq OWNED BY public.redes.id;


--
-- Name: responsaveis; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE responsaveis (
    id bigint NOT NULL,
    relacao_parental integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    user_id bigint NOT NULL
);


ALTER TABLE responsaveis OWNER TO postgres;

--
-- Name: responsaveis_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE responsaveis_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE responsaveis_id_seq OWNER TO postgres;

--
-- Name: responsaveis_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE responsaveis_id_seq OWNED BY public.responsaveis.id;


--
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    id bigint NOT NULL,
    nome character varying,
    descricao character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.roles_id_seq OWNER TO postgres;

--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;


--
-- Name: roles_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles_permissions (
    role_id bigint NOT NULL,
    permission_id bigint NOT NULL
);


ALTER TABLE public.roles_permissions OWNER TO postgres;

--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


ALTER TABLE public.schema_migrations OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    username character varying DEFAULT ''::character varying NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp(6) without time zone,
    remember_created_at timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: users_roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users_roles (
    user_id bigint NOT NULL,
    role_id bigint NOT NULL
);


ALTER TABLE public.users_roles OWNER TO postgres;

--
-- Name: categorias id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY categorias ALTER COLUMN id SET DEFAULT nextval('public.categorias_id_seq'::regclass);


--
-- Name: escolas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.escolas ALTER COLUMN id SET DEFAULT nextval('public.escolas_id_seq'::regclass);


--
-- Name: estudantes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY estudantes ALTER COLUMN id SET DEFAULT nextval('public.estudantes_id_seq'::regclass);


--
-- Name: perfis id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY perfis ALTER COLUMN id SET DEFAULT nextval('public.perfis_id_seq'::regclass);


--
-- Name: permissions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions ALTER COLUMN id SET DEFAULT nextval('public.permissions_id_seq'::regclass);


--
-- Name: produtos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY produtos ALTER COLUMN id SET DEFAULT nextval('public.produtos_id_seq'::regclass);


--
-- Name: redes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.redes ALTER COLUMN id SET DEFAULT nextval('public.redes_id_seq'::regclass);


--
-- Name: responsaveis id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY responsaveis ALTER COLUMN id SET DEFAULT nextval('public.responsaveis_id_seq'::regclass);


--
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: categorias categorias_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY categorias
    ADD CONSTRAINT categorias_pkey PRIMARY KEY (id);


--
-- Name: escolas escolas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.escolas
    ADD CONSTRAINT escolas_pkey PRIMARY KEY (id);


--
-- Name: estudantes estudantes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.estudantes
    ADD CONSTRAINT estudantes_pkey PRIMARY KEY (id);


--
-- Name: perfis perfis_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.perfis
    ADD CONSTRAINT perfis_pkey PRIMARY KEY (id);


--
-- Name: permissions permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);


--
-- Name: produtos produtos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produtos
    ADD CONSTRAINT produtos_pkey PRIMARY KEY (id);


--
-- Name: redes redes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.redes
    ADD CONSTRAINT redes_pkey PRIMARY KEY (id);


--
-- Name: responsaveis responsaveis_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.responsaveis
    ADD CONSTRAINT responsaveis_pkey PRIMARY KEY (id);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_categorias_on_ativo; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_categorias_on_ativo ON categorias USING btree (ativo);


--
-- Name: index_categorias_on_nome; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_categorias_on_nome ON categorias USING btree (nome);


--
-- Name: index_escolas_on_cnpj; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_escolas_on_cnpj ON public.escolas USING btree (cnpj);


--
-- Name: index_escolas_on_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_escolas_on_email ON public.escolas USING btree (email);


--
-- Name: index_escolas_on_rede_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_escolas_on_rede_id ON public.escolas USING btree (rede_id);


--
-- Name: index_escolas_on_schema_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_escolas_on_schema_name ON public.escolas USING btree (schema_name);


--
-- Name: index_escolas_on_slug; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_escolas_on_slug ON public.escolas USING btree (slug);


--
-- Name: index_estudantes_on_responsavel_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_estudantes_on_responsavel_id ON estudantes USING btree (responsavel_id);


--
-- Name: index_perfis_on_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_perfis_on_user_id ON perfis USING btree (user_id);


--
-- Name: index_permissions_on_acao_and_recurso; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_permissions_on_acao_and_recurso ON public.permissions USING btree (acao, recurso);


--
-- Name: index_permissions_on_nome; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_permissions_on_nome ON public.permissions USING btree (nome);


--
-- Name: index_produtos_on_ativo; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_produtos_on_ativo ON produtos USING btree (ativo);


--
-- Name: index_produtos_on_categoria_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_produtos_on_categoria_id ON produtos USING btree (categoria_id);


--
-- Name: index_produtos_on_nome; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_produtos_on_nome ON produtos USING btree (nome);


--
-- Name: index_redes_on_slug; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_redes_on_slug ON public.redes USING btree (slug);


--
-- Name: index_responsaveis_on_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_responsaveis_on_user_id ON responsaveis USING btree (user_id);


--
-- Name: index_roles_on_nome; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_roles_on_nome ON public.roles USING btree (nome);


--
-- Name: index_roles_permissions_on_permission_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_roles_permissions_on_permission_id ON public.roles_permissions USING btree (permission_id);


--
-- Name: index_roles_permissions_on_role_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_roles_permissions_on_role_id ON public.roles_permissions USING btree (role_id);


--
-- Name: index_roles_permissions_on_role_id_and_permission_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_roles_permissions_on_role_id_and_permission_id ON public.roles_permissions USING btree (role_id, permission_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


--
-- Name: index_users_on_username; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_users_on_username ON public.users USING btree (username);


--
-- Name: index_users_roles_on_role_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_users_roles_on_role_id ON public.users_roles USING btree (role_id);


--
-- Name: index_users_roles_on_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_users_roles_on_user_id ON public.users_roles USING btree (user_id);


--
-- Name: index_users_roles_on_user_id_and_role_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_users_roles_on_user_id_and_role_id ON public.users_roles USING btree (user_id, role_id);


--
-- Name: responsaveis fk_rails_1f3932202a; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY responsaveis
    ADD CONSTRAINT fk_rails_1f3932202a FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: estudantes fk_rails_45856ffe21; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY estudantes
    ADD CONSTRAINT fk_rails_45856ffe21 FOREIGN KEY (responsavel_id) REFERENCES public.responsaveis(id);


--
-- Name: users_roles fk_rails_4a41696df6; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_roles
    ADD CONSTRAINT fk_rails_4a41696df6 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: roles_permissions fk_rails_7e67517ffc; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles_permissions
    ADD CONSTRAINT fk_rails_7e67517ffc FOREIGN KEY (role_id) REFERENCES public.roles(id);


--
-- Name: roles_permissions fk_rails_bd31d44a77; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles_permissions
    ADD CONSTRAINT fk_rails_bd31d44a77 FOREIGN KEY (permission_id) REFERENCES public.permissions(id);


--
-- Name: produtos fk_rails_dc32f10a74; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY produtos
    ADD CONSTRAINT fk_rails_dc32f10a74 FOREIGN KEY (categoria_id) REFERENCES public.categorias(id);


--
-- Name: perfis fk_rails_e2353d3085; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY perfis
    ADD CONSTRAINT fk_rails_e2353d3085 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: users_roles fk_rails_eb7b4658f8; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_roles
    ADD CONSTRAINT fk_rails_eb7b4658f8 FOREIGN KEY (role_id) REFERENCES public.roles(id);


--
-- Name: escolas fk_rails_fdbbe8e809; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.escolas
    ADD CONSTRAINT fk_rails_fdbbe8e809 FOREIGN KEY (rede_id) REFERENCES public.redes(id);


--
-- PostgreSQL database dump complete
--

\unrestrict Q2ReIU4esmeP4VUU2H6C23w1mBi9VivWc68Kb9bRyPD38ccTc94y0BOiXm3WS6N

