-- ============================================================
-- ArtisanRescue — schéma de base de données Supabase
-- À copier-coller intégralement dans : Supabase → SQL Editor → New query → Run
-- ============================================================

-- Table des artisans
create table if not exists artisans (
  id text primary key,
  name text not null,
  sector text,
  metier text,
  country text,
  city text,
  phone text unique,
  password text,
  rating numeric default 0,
  reviews_count integer default 0,
  status text default 'actif',
  bio text,
  joined date default current_date
);

-- Table des déverrouillages payés (clients du marketplace)
create table if not exists transactions (
  id text primary key,
  artisan text,
  method text,
  payer_name text,
  payer_account text,
  artisan_sector text,
  artisan_metier text,
  artisan_country text,
  artisan_city text,
  amount numeric,
  date text
);

-- Table des avis clients
create table if not exists reviews (
  id text primary key,
  artisan_id text references artisans(id) on delete cascade,
  artisan_name text,
  rating integer,
  comment text,
  payer_name text,
  date text
);

-- Table des paramètres admin (une seule ligne, id = 1)
create table if not exists admin_settings (
  id integer primary key default 1,
  admin_username text default 'admin',
  admin_password text default 'admin123',
  unlock_price numeric default 2000,
  currency text default 'FCFA',
  numbers jsonb default '{
    "Orange Money": "+225 07 00 00 00 00",
    "MTN Mobile Money": "+225 05 00 00 00 00",
    "Moov Money": "+225 01 00 00 00 00",
    "Wave": "+225 07 11 11 11 11",
    "Carte bancaire": "IBAN CI93 CI001 00001 00000000000 12"
  }'::jsonb
);

-- Ligne de paramètres par défaut (une seule fois)
insert into admin_settings (id) values (1)
on conflict (id) do nothing;

-- ============================================================
-- Sécurité (Row Level Security)
-- ⚠️ Configuration simplifiée pour démarrer facilement : tout le monde
-- (via la clé publique "anon") peut lire ET écrire sur ces tables.
-- C'est volontairement permissif pour que l'app fonctionne sans backend
-- personnalisé. Voir les explications de sécurité fournies à côté de
-- ce fichier avant d'aller en production avec de vrais paiements.
-- ============================================================

alter table artisans enable row level security;
alter table transactions enable row level security;
alter table reviews enable row level security;
alter table admin_settings enable row level security;

create policy "public read artisans" on artisans for select using (true);
create policy "public insert artisans" on artisans for insert with check (true);
create policy "public update artisans" on artisans for update using (true);
create policy "public delete artisans" on artisans for delete using (true);

create policy "public read transactions" on transactions for select using (true);
create policy "public insert transactions" on transactions for insert with check (true);

create policy "public read reviews" on reviews for select using (true);
create policy "public insert reviews" on reviews for insert with check (true);

create policy "public read settings" on admin_settings for select using (true);
create policy "public update settings" on admin_settings for update using (true);
