-- WARNING: This schema is for context only and is not meant to be run.
-- Table order and constraints may not be valid for execution.

CREATE TABLE public.branches (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  name character varying NOT NULL,
  code character varying NOT NULL UNIQUE,
  address character varying,
  city character varying,
  country_code character varying NOT NULL DEFAULT 'ARG'::character varying,
  phone character varying,
  email character varying,
  timezone character varying NOT NULL DEFAULT 'America/Argentina/Buenos_Aires'::character varying,
  is_active boolean NOT NULL DEFAULT true,
  logo_url character varying,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT branches_pkey PRIMARY KEY (id)
);
CREATE TABLE public.roles (
  id integer NOT NULL DEFAULT nextval('roles_id_seq'::regclass),
  name character varying NOT NULL UNIQUE,
  description text,
  is_system boolean NOT NULL DEFAULT false,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT roles_pkey PRIMARY KEY (id)
);
CREATE TABLE public.permissions (
  id integer NOT NULL DEFAULT nextval('permissions_id_seq'::regclass),
  resource character varying NOT NULL,
  action character varying NOT NULL,
  description text,
  CONSTRAINT permissions_pkey PRIMARY KEY (id)
);
CREATE TABLE public.role_permissions (
  role_id integer NOT NULL,
  permission_id integer NOT NULL,
  granted_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT role_permissions_pkey PRIMARY KEY (role_id, permission_id),
  CONSTRAINT role_permissions_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id),
  CONSTRAINT role_permissions_permission_id_fkey FOREIGN KEY (permission_id) REFERENCES public.permissions(id)
);
CREATE TABLE public.users (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  branch_id uuid,
  email character varying NOT NULL UNIQUE,
  username character varying NOT NULL UNIQUE,
  password_hash character varying NOT NULL,
  first_name character varying NOT NULL,
  last_name character varying NOT NULL,
  phone_number character varying,
  date_of_birth date,
  avatar_url character varying,
  status USER-DEFINED NOT NULL DEFAULT 'pending_verification'::user_status_enum,
  email_verified boolean NOT NULL DEFAULT false,
  phone_verified boolean NOT NULL DEFAULT false,
  two_factor_enabled boolean NOT NULL DEFAULT false,
  two_factor_secret character varying,
  last_login_at timestamp with time zone,
  last_login_ip inet,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  device_token character varying,
  CONSTRAINT users_pkey PRIMARY KEY (id),
  CONSTRAINT users_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id)
);
CREATE TABLE public.user_roles (
  user_id uuid NOT NULL,
  role_id integer NOT NULL,
  assigned_at timestamp with time zone NOT NULL DEFAULT now(),
  assigned_by uuid,
  CONSTRAINT user_roles_pkey PRIMARY KEY (user_id, role_id),
  CONSTRAINT user_roles_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id),
  CONSTRAINT user_roles_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id),
  CONSTRAINT user_roles_assigned_by_fkey FOREIGN KEY (assigned_by) REFERENCES public.users(id)
);
CREATE TABLE public.audit_logs (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  user_id uuid,
  branch_id uuid,
  action USER-DEFINED NOT NULL,
  resource_type character varying NOT NULL,
  resource_id character varying,
  ip_address inet,
  user_agent character varying,
  metadata jsonb,
  occurred_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT audit_logs_pkey PRIMARY KEY (id),
  CONSTRAINT audit_logs_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id),
  CONSTRAINT audit_logs_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id)
);
CREATE TABLE public.membership_plans (
  id integer NOT NULL DEFAULT nextval('membership_plans_id_seq'::regclass),
  branch_id uuid NOT NULL,
  name character varying NOT NULL,
  description text,
  billing_cycle USER-DEFINED NOT NULL,
  price numeric NOT NULL,
  currency_code character varying NOT NULL DEFAULT 'ARS'::character varying,
  duration_days integer NOT NULL,
  max_freeze_days integer NOT NULL DEFAULT 15,
  is_active boolean NOT NULL DEFAULT true,
  features jsonb,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT membership_plans_pkey PRIMARY KEY (id),
  CONSTRAINT membership_plans_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id)
);
CREATE TABLE public.memberships (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  user_id uuid NOT NULL,
  plan_id integer NOT NULL,
  branch_id uuid NOT NULL,
  status USER-DEFINED NOT NULL DEFAULT 'pending_payment'::membership_status_enum,
  start_date date NOT NULL,
  end_date date NOT NULL,
  auto_renew boolean NOT NULL DEFAULT false,
  external_subscription_id character varying,
  notes text,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT memberships_pkey PRIMARY KEY (id),
  CONSTRAINT memberships_plan_id_fkey FOREIGN KEY (plan_id) REFERENCES public.membership_plans(id),
  CONSTRAINT memberships_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id),
  CONSTRAINT memberships_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id)
);
CREATE TABLE public.membership_freezes (
  id integer NOT NULL DEFAULT nextval('membership_freezes_id_seq'::regclass),
  membership_id uuid NOT NULL,
  requested_by uuid,
  freeze_start date NOT NULL,
  freeze_end date NOT NULL,
  reason character varying,
  is_active boolean NOT NULL DEFAULT true,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT membership_freezes_pkey PRIMARY KEY (id),
  CONSTRAINT membership_freezes_membership_id_fkey FOREIGN KEY (membership_id) REFERENCES public.memberships(id),
  CONSTRAINT membership_freezes_requested_by_fkey FOREIGN KEY (requested_by) REFERENCES public.users(id)
);
CREATE TABLE public.invoices (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  membership_id uuid NOT NULL,
  branch_id uuid NOT NULL,
  invoice_number character varying NOT NULL UNIQUE,
  status USER-DEFINED NOT NULL DEFAULT 'draft'::invoice_status_enum,
  subtotal numeric NOT NULL,
  tax_amount numeric NOT NULL DEFAULT 0,
  discount_amount numeric NOT NULL DEFAULT 0,
  total numeric NOT NULL,
  currency_code character varying NOT NULL DEFAULT 'ARS'::character varying,
  due_date date,
  paid_at timestamp with time zone,
  notes text,
  pdf_url character varying,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  payment_link character varying,
  CONSTRAINT invoices_pkey PRIMARY KEY (id),
  CONSTRAINT invoices_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id),
  CONSTRAINT invoices_membership_id_fkey FOREIGN KEY (membership_id) REFERENCES public.memberships(id)
);
CREATE TABLE public.payment_methods (
  id integer NOT NULL DEFAULT nextval('payment_methods_id_seq'::regclass),
  user_id uuid NOT NULL,
  gateway USER-DEFINED NOT NULL,
  token character varying,
  last_four character varying,
  card_brand character varying,
  expiry_month smallint,
  expiry_year smallint,
  is_default boolean NOT NULL DEFAULT false,
  is_active boolean NOT NULL DEFAULT true,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT payment_methods_pkey PRIMARY KEY (id),
  CONSTRAINT payment_methods_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id)
);
CREATE TABLE public.transactions (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  invoice_id uuid NOT NULL,
  payment_method_id integer,
  type USER-DEFINED NOT NULL,
  status USER-DEFINED NOT NULL DEFAULT 'pending'::transaction_status_enum,
  amount numeric NOT NULL,
  currency_code character varying NOT NULL DEFAULT 'ARS'::character varying,
  gateway USER-DEFINED NOT NULL,
  gateway_reference character varying,
  processed_at timestamp with time zone,
  failure_reason character varying,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT transactions_pkey PRIMARY KEY (id),
  CONSTRAINT transactions_payment_method_id_fkey FOREIGN KEY (payment_method_id) REFERENCES public.payment_methods(id),
  CONSTRAINT transactions_invoice_id_fkey FOREIGN KEY (invoice_id) REFERENCES public.invoices(id)
);
CREATE TABLE public.mercadopago_transactions (
  id integer NOT NULL DEFAULT nextval('mercadopago_transactions_id_seq'::regclass),
  transaction_id uuid NOT NULL UNIQUE,
  mp_payment_id character varying,
  mp_preference_id character varying,
  mp_external_reference character varying,
  mp_status character varying,
  mp_status_detail character varying,
  mp_payment_method_id character varying,
  mp_payment_type_id character varying,
  mp_installments integer,
  raw_response jsonb,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT mercadopago_transactions_pkey PRIMARY KEY (id),
  CONSTRAINT mercadopago_transactions_transaction_id_fkey FOREIGN KEY (transaction_id) REFERENCES public.transactions(id)
);
CREATE TABLE public.attendance_records (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  user_id uuid NOT NULL,
  branch_id uuid NOT NULL,
  check_in timestamp with time zone NOT NULL DEFAULT now(),
  check_out timestamp with time zone,
  method USER-DEFINED NOT NULL DEFAULT 'qr_code'::check_in_method_enum,
  notes character varying,
  CONSTRAINT attendance_records_pkey PRIMARY KEY (id),
  CONSTRAINT attendance_records_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id),
  CONSTRAINT attendance_records_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id)
);
CREATE TABLE public.muscle_groups (
  id integer NOT NULL DEFAULT nextval('muscle_groups_id_seq'::regclass),
  parent_id integer,
  name character varying NOT NULL,
  name_en character varying,
  wger_muscle_id integer UNIQUE,
  body_part character varying,
  CONSTRAINT muscle_groups_pkey PRIMARY KEY (id),
  CONSTRAINT muscle_groups_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.muscle_groups(id)
);
CREATE TABLE public.exercise_catalog (
  id integer NOT NULL DEFAULT nextval('exercise_catalog_id_seq'::regclass),
  wger_exercise_id integer UNIQUE,
  name character varying NOT NULL,
  name_en character varying,
  description text,
  instructions jsonb,
  category USER-DEFINED NOT NULL,
  difficulty USER-DEFINED NOT NULL DEFAULT 'intermediate'::difficulty_level_enum,
  equipment character varying,
  video_url character varying,
  thumbnail_url character varying,
  is_custom boolean NOT NULL DEFAULT false,
  created_by uuid,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT exercise_catalog_pkey PRIMARY KEY (id),
  CONSTRAINT exercise_catalog_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id)
);
CREATE TABLE public.exercise_muscle_groups (
  exercise_id integer NOT NULL,
  muscle_group_id integer NOT NULL,
  is_primary boolean NOT NULL DEFAULT true,
  CONSTRAINT exercise_muscle_groups_pkey PRIMARY KEY (exercise_id, muscle_group_id),
  CONSTRAINT exercise_muscle_groups_exercise_id_fkey FOREIGN KEY (exercise_id) REFERENCES public.exercise_catalog(id),
  CONSTRAINT exercise_muscle_groups_muscle_group_id_fkey FOREIGN KEY (muscle_group_id) REFERENCES public.muscle_groups(id)
);
CREATE TABLE public.mesocycles (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  trainer_id uuid,
  member_id uuid NOT NULL,
  branch_id uuid NOT NULL,
  name character varying NOT NULL,
  goal USER-DEFINED NOT NULL,
  difficulty USER-DEFINED NOT NULL,
  start_date date NOT NULL,
  end_date date NOT NULL,
  total_weeks integer NOT NULL,
  deload_week_interval integer NOT NULL DEFAULT 4,
  notes text,
  is_active boolean NOT NULL DEFAULT true,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT mesocycles_pkey PRIMARY KEY (id),
  CONSTRAINT mesocycles_trainer_id_fkey FOREIGN KEY (trainer_id) REFERENCES public.users(id),
  CONSTRAINT mesocycles_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.users(id),
  CONSTRAINT mesocycles_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id)
);
CREATE TABLE public.microcycles (
  id integer NOT NULL DEFAULT nextval('microcycles_id_seq'::regclass),
  mesocycle_id uuid NOT NULL,
  week_number smallint NOT NULL CHECK (week_number >= 1),
  week_start_date date NOT NULL,
  week_end_date date NOT NULL,
  is_deload boolean NOT NULL DEFAULT false,
  target_volume_sets integer,
  target_intensity_pct numeric,
  notes text,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT microcycles_pkey PRIMARY KEY (id),
  CONSTRAINT microcycles_mesocycle_id_fkey FOREIGN KEY (mesocycle_id) REFERENCES public.mesocycles(id)
);
CREATE TABLE public.routine_templates (
  id integer NOT NULL DEFAULT nextval('routine_templates_id_seq'::regclass),
  created_by uuid,
  branch_id uuid NOT NULL,
  name character varying NOT NULL,
  description text,
  goal USER-DEFINED NOT NULL,
  difficulty USER-DEFINED NOT NULL,
  estimated_duration_min integer,
  template_data jsonb,
  is_public boolean NOT NULL DEFAULT false,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT routine_templates_pkey PRIMARY KEY (id),
  CONSTRAINT routine_templates_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id),
  CONSTRAINT routine_templates_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id)
);
CREATE TABLE public.routine_sessions (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  microcycle_id integer,
  template_id integer,
  user_id uuid NOT NULL,
  name character varying NOT NULL,
  scheduled_date date NOT NULL,
  started_at timestamp with time zone,
  completed_at timestamp with time zone,
  actual_duration_min integer,
  status USER-DEFINED NOT NULL DEFAULT 'planned'::session_status_enum,
  perceived_effort smallint CHECK (perceived_effort >= 1 AND perceived_effort <= 10),
  trainer_notes text,
  member_notes text,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT routine_sessions_pkey PRIMARY KEY (id),
  CONSTRAINT routine_sessions_microcycle_id_fkey FOREIGN KEY (microcycle_id) REFERENCES public.microcycles(id),
  CONSTRAINT routine_sessions_template_id_fkey FOREIGN KEY (template_id) REFERENCES public.routine_templates(id),
  CONSTRAINT routine_sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id)
);
CREATE TABLE public.session_exercises (
  id integer NOT NULL DEFAULT nextval('session_exercises_id_seq'::regclass),
  session_id uuid NOT NULL,
  exercise_id integer NOT NULL,
  order_index smallint NOT NULL,
  superset_group smallint,
  notes character varying,
  CONSTRAINT session_exercises_pkey PRIMARY KEY (id),
  CONSTRAINT session_exercises_session_id_fkey FOREIGN KEY (session_id) REFERENCES public.routine_sessions(id),
  CONSTRAINT session_exercises_exercise_id_fkey FOREIGN KEY (exercise_id) REFERENCES public.exercise_catalog(id)
);
CREATE TABLE public.exercise_sets (
  id integer NOT NULL DEFAULT nextval('exercise_sets_id_seq'::regclass),
  session_exercise_id integer NOT NULL,
  set_number smallint NOT NULL CHECK (set_number >= 1),
  prescribed_reps smallint,
  prescribed_weight_kg numeric,
  reps smallint,
  weight numeric,
  weight_unit USER-DEFINED NOT NULL DEFAULT 'kg'::weight_unit_enum,
  rpe numeric CHECK (rpe >= 1::numeric AND rpe <= 10::numeric),
  rest_seconds integer,
  duration_seconds integer,
  is_warmup boolean NOT NULL DEFAULT false,
  is_failure boolean NOT NULL DEFAULT false,
  notes character varying,
  logged_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT exercise_sets_pkey PRIMARY KEY (id),
  CONSTRAINT exercise_sets_session_exercise_id_fkey FOREIGN KEY (session_exercise_id) REFERENCES public.session_exercises(id)
);
CREATE TABLE public.weight_history (
  id integer NOT NULL DEFAULT nextval('weight_history_id_seq'::regclass),
  user_id uuid NOT NULL,
  measured_at timestamp with time zone NOT NULL DEFAULT now(),
  weight_kg numeric NOT NULL CHECK (weight_kg > 0::numeric),
  body_fat_pct numeric CHECK (body_fat_pct >= 3::numeric AND body_fat_pct <= 70::numeric),
  muscle_mass_kg numeric,
  hydration_pct numeric,
  is_fasted boolean NOT NULL DEFAULT true,
  notes character varying,
  CONSTRAINT weight_history_pkey PRIMARY KEY (id),
  CONSTRAINT weight_history_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id)
);
CREATE TABLE public.anthropometric_measurements (
  id integer NOT NULL DEFAULT nextval('anthropometric_measurements_id_seq'::regclass),
  user_id uuid NOT NULL,
  measured_by uuid,
  session_date date NOT NULL,
  measurement_site USER-DEFINED NOT NULL,
  value_mm numeric,
  value_cm numeric,
  notes character varying,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT anthropometric_measurements_pkey PRIMARY KEY (id),
  CONSTRAINT anthropometric_measurements_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id),
  CONSTRAINT anthropometric_measurements_measured_by_fkey FOREIGN KEY (measured_by) REFERENCES public.users(id)
);
CREATE TABLE public.supplement_catalog (
  id integer NOT NULL DEFAULT nextval('supplement_catalog_id_seq'::regclass),
  name character varying NOT NULL UNIQUE,
  common_name character varying,
  description text,
  form USER-DEFINED,
  default_dosage_unit USER-DEFINED,
  recommended_daily_dose numeric,
  evidence_level character CHECK (evidence_level = ANY (ARRAY['A'::bpchar, 'B'::bpchar, 'C'::bpchar, 'D'::bpchar])),
  notes text,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT supplement_catalog_pkey PRIMARY KEY (id)
);
CREATE TABLE public.supplement_consumption (
  id integer NOT NULL DEFAULT nextval('supplement_consumption_id_seq'::regclass),
  user_id uuid NOT NULL,
  supplement_id integer NOT NULL,
  session_id uuid,
  consumed_at timestamp with time zone NOT NULL DEFAULT now(),
  dosage numeric NOT NULL,
  dosage_unit USER-DEFINED NOT NULL,
  timing character varying,
  notes character varying,
  CONSTRAINT supplement_consumption_pkey PRIMARY KEY (id),
  CONSTRAINT supplement_consumption_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id),
  CONSTRAINT supplement_consumption_supplement_id_fkey FOREIGN KEY (supplement_id) REFERENCES public.supplement_catalog(id),
  CONSTRAINT supplement_consumption_session_id_fkey FOREIGN KEY (session_id) REFERENCES public.routine_sessions(id)
);
CREATE TABLE public.fatigue_indicators (
  id integer NOT NULL DEFAULT nextval('fatigue_indicators_id_seq'::regclass),
  user_id uuid NOT NULL,
  microcycle_id integer,
  week_start_date date NOT NULL,
  week_end_date date NOT NULL,
  sessions_planned integer NOT NULL DEFAULT 0,
  sessions_completed integer NOT NULL DEFAULT 0,
  total_sets integer NOT NULL DEFAULT 0,
  total_reps integer NOT NULL DEFAULT 0,
  volume_load_kg numeric NOT NULL DEFAULT 0,
  avg_rpe numeric,
  max_rpe numeric,
  failure_sets_count integer NOT NULL DEFAULT 0,
  acute_workload numeric,
  chronic_workload numeric,
  acwr numeric,
  fatigue_score numeric CHECK (fatigue_score >= 0::numeric AND fatigue_score <= 100::numeric),
  fatigue_level USER-DEFINED,
  deload_recommended boolean NOT NULL DEFAULT false,
  algorithm_version character varying NOT NULL DEFAULT '1.0.0'::character varying,
  computation_metadata jsonb,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT fatigue_indicators_pkey PRIMARY KEY (id),
  CONSTRAINT fatigue_indicators_microcycle_id_fkey FOREIGN KEY (microcycle_id) REFERENCES public.microcycles(id),
  CONSTRAINT fatigue_indicators_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id)
);
CREATE TABLE public.predictive_alerts (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  user_id uuid NOT NULL,
  triggered_by_fatigue_id integer,
  alert_type USER-DEFINED NOT NULL,
  title character varying NOT NULL,
  message text NOT NULL,
  payload jsonb,
  status USER-DEFINED NOT NULL DEFAULT 'pending'::alert_status_enum,
  sent_in_app boolean NOT NULL DEFAULT false,
  sent_via_email boolean NOT NULL DEFAULT false,
  sent_via_whatsapp boolean NOT NULL DEFAULT false,
  email_sent_at timestamp with time zone,
  whatsapp_sent_at timestamp with time zone,
  acknowledged_at timestamp with time zone,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT predictive_alerts_pkey PRIMARY KEY (id),
  CONSTRAINT predictive_alerts_triggered_by_fatigue_id_fkey FOREIGN KEY (triggered_by_fatigue_id) REFERENCES public.fatigue_indicators(id),
  CONSTRAINT predictive_alerts_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id)
);
CREATE TABLE public.alembic_version (
  version_num character varying NOT NULL,
  CONSTRAINT alembic_version_pkey PRIMARY KEY (version_num)
);
CREATE TABLE public.trainer_athlete_link (
  id uuid NOT NULL,
  trainer_id uuid NOT NULL,
  athlete_id uuid NOT NULL,
  status USER-DEFINED NOT NULL DEFAULT 'pending'::link_status_enum,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT trainer_athlete_link_pkey PRIMARY KEY (id),
  CONSTRAINT trainer_athlete_link_athlete_id_fkey FOREIGN KEY (athlete_id) REFERENCES public.users(id),
  CONSTRAINT trainer_athlete_link_trainer_id_fkey FOREIGN KEY (trainer_id) REFERENCES public.users(id)
);
CREATE TABLE public.supplement_logs (
  id uuid NOT NULL,
  user_id uuid NOT NULL,
  supplement_name character varying NOT NULL,
  dose_grams numeric NOT NULL,
  date date NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT supplement_logs_pkey PRIMARY KEY (id),
  CONSTRAINT supplement_logs_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id)
);