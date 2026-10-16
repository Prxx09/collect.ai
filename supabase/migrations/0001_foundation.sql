-- CollectAI foundation: synthetic data only.
-- Tenant isolation must be enforced by authenticated service endpoints and RLS.
create extension if not exists pgcrypto;

create table if not exists public.tenants (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  created_at timestamptz not null default now()
);
create table if not exists public.tenant_members (
  tenant_id uuid not null references public.tenants(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  role text not null check (role in ('admin','reviewer','operator','viewer')),
  primary key (tenant_id,user_id)
);
create table if not exists public.borrowers (
  id uuid primary key default gen_random_uuid(),
  tenant_id uuid not null references public.tenants(id),
  external_ref text not null,
  display_name text not null,
  synthetic boolean not null default true check (synthetic = true),
  created_at timestamptz not null default now(),
  unique (tenant_id,external_ref),
  unique (tenant_id,id)
);
create table if not exists public.loan_accounts (
  id uuid primary key default gen_random_uuid(),
  tenant_id uuid not null references public.tenants(id),
  borrower_id uuid not null,
  account_ref text not null,
  currency_code char(3) not null default 'INR',
  outstanding_minor bigint not null check (outstanding_minor >= 0),
  overdue_minor bigint not null check (overdue_minor >= 0),
  ledger_version bigint not null default 1,
  created_at timestamptz not null default now(),
  foreign key (tenant_id,borrower_id) references public.borrowers(tenant_id,id),
  unique (tenant_id,account_ref),
  unique (tenant_id,id)
);
create table if not exists public.collection_cases (
  id uuid primary key default gen_random_uuid(),
  tenant_id uuid not null references public.tenants(id),
  loan_account_id uuid not null,
  case_ref text not null,
  status text not null default 'OPEN' check (status in ('OPEN','REVIEW','DISPUTED','RESOLVED')),
  created_at timestamptz not null default now(),
  foreign key (tenant_id,loan_account_id) references public.loan_accounts(tenant_id,id),
  unique (tenant_id,case_ref),
  unique (tenant_id,id)
);
create table if not exists public.policy_versions (
  id uuid primary key default gen_random_uuid(),
  tenant_id uuid not null references public.tenants(id),
  version text not null,
  policy_json jsonb not null,
  active boolean not null default false,
  created_at timestamptz not null default now(),
  unique (tenant_id,version),
  unique (tenant_id,id)
);
create table if not exists public.agent_actions (
  id uuid primary key default gen_random_uuid(),
  tenant_id uuid not null references public.tenants(id),
  case_id uuid not null,
  idempotency_key text not null,
  action_type text not null,
  state text not null check (state in ('REQUESTED','BLOCKED','COMMITTED','FAILED','UNKNOWN')),
  details jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  foreign key (tenant_id,case_id) references public.collection_cases(tenant_id,id),
  unique (tenant_id,idempotency_key),
  unique (tenant_id,id)
);
create table if not exists public.audit_events (
  id bigint generated always as identity primary key,
  tenant_id uuid not null references public.tenants(id),
  case_id uuid,
  action_id uuid,
  event_type text not null,
  payload jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  foreign key (tenant_id,case_id) references public.collection_cases(tenant_id,id),
  foreign key (tenant_id,action_id) references public.agent_actions(tenant_id,id)
);

-- No table is accessible to authenticated or anonymous clients until RLS policies
-- are explicitly approved and installed. Service-role use must be server-only.
alter table public.tenants enable row level security;
alter table public.tenant_members enable row level security;
alter table public.borrowers enable row level security;
alter table public.loan_accounts enable row level security;
alter table public.collection_cases enable row level security;
alter table public.policy_versions enable row level security;
alter table public.agent_actions enable row level security;
alter table public.audit_events enable row level security;
