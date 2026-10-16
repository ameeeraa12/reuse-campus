-- Run once in Supabase: SQL Editor > New query > Run
create table public.listings (
  id uuid primary key default gen_random_uuid(),
  owner uuid not null default auth.uid() references auth.users(id) on delete cascade,
  owner_name text not null,
  title text not null,
  category text not null,
  mode text not null check (mode in ('giveaway','exchange')),
  wanted text,
  condition text not null,
  description text,
  status text not null default 'available' check (status in ('available','claimed')),
  created_at timestamptz not null default now()
);
create table public.requests (
  id uuid primary key default gen_random_uuid(),
  listing_id uuid not null references public.listings(id) on delete cascade,
  requester uuid not null default auth.uid() references auth.users(id) on delete cascade,
  requester_name text not null,
  contact text not null,
  message text,
  created_at timestamptz not null default now()
);
create index on public.listings (category, status);
alter table public.listings enable row level security;
alter table public.requests enable row level security;

create policy "anyone can browse" on public.listings for select using (true);
create policy "owners create" on public.listings for insert to authenticated with check (owner = auth.uid());
create policy "owners update" on public.listings for update to authenticated using (owner = auth.uid());
create policy "owners delete" on public.listings for delete to authenticated using (owner = auth.uid());

create policy "students request" on public.requests for insert to authenticated with check (requester = auth.uid());
create policy "owner or requester reads" on public.requests for select to authenticated
  using (requester = auth.uid() or exists (select 1 from public.listings l where l.id = listing_id and l.owner = auth.uid()));

-- Run once in Supabase SQL Editor if you already ran schema.sql earlier
alter table public.listings add column if not exists image_url text;
insert into storage.buckets (id, name, public) values ('item-images','item-images',true) on conflict (id) do nothing;
create policy "public read images" on storage.objects for select using (bucket_id = 'item-images');
create policy "upload own images" on storage.objects for insert to authenticated
  with check (bucket_id = 'item-images' and (storage.foldername(name))[1] = auth.uid()::text);
create policy "delete own images" on storage.objects for delete to authenticated
  using (bucket_id = 'item-images' and (storage.foldername(name))[1] = auth.uid()::text);
