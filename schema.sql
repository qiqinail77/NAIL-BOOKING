-- 美甲预约簿 database setup (run once in Supabase SQL editor)
create table if not exists public.bookings (
  id text primary key,
  name text not null,
  phone text,
  date date not null,
  time time,
  source text default 'IG',
  deposit boolean default false,
  deposit_amount numeric,
  service text,
  style text,
  price numeric,
  prev_visits integer,
  status text default 'booked' check (status in ('booked','done','cancelled')),
  notes text,
  photos text[] default '{}',
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);
grant all on public.bookings to authenticated, service_role;
alter table public.bookings enable row level security;
drop policy if exists "signed-in users manage bookings" on public.bookings;
create policy "signed-in users manage bookings" on public.bookings
  for all to authenticated using (true) with check (true);

-- private photo bucket
insert into storage.buckets (id, name, public) values ('photos','photos', false)
  on conflict (id) do nothing;
drop policy if exists "signed-in users manage photos" on storage.objects;
create policy "signed-in users manage photos" on storage.objects
  for all to authenticated using (bucket_id = 'photos') with check (bucket_id = 'photos');
