-- ============================================================
-- ArtisanRescue — Patch de sécurité
-- À exécuter dans Supabase → SQL Editor → New query → Run
-- Corrige : n'importe qui avec la clé publique pouvait réécrire
-- les numéros de paiement / le prix / supprimer des artisans.
-- ============================================================

-- Seul un administrateur connecté (via Supabase Auth) peut modifier
-- les numéros de paiement, le prix de déverrouillage, etc.
drop policy if exists "public update settings" on admin_settings;
create policy "admin only update settings" on admin_settings
  for update using (auth.role() = 'authenticated');

-- Seul un administrateur connecté peut supprimer un compte artisan
drop policy if exists "public delete artisans" on artisans;
create policy "admin only delete artisans" on artisans
  for delete using (auth.role() = 'authenticated');

-- Les colonnes admin_username / admin_password ne servent plus à la
-- connexion (remplacées par un vrai compte Supabase Auth ci-dessous).
-- On les vide pour ne plus laisser traîner d'identifiants en clair.
update admin_settings set admin_username = null, admin_password = null where id = 1;
