# ReUse Campus

Student exchange platform for textbooks, lab coats, calculators and other reusable supplies.
Static front end (index.html) + Supabase (Postgres + Auth) for all data. Nothing is stored locally.

## The 6 modules
1. **Accounts**: sign up / sign in with Supabase Auth (name kept in user metadata).
2. **Item listings**: create, view, delete listings (`listings` table).
3. **Category search**: category chips, text search, giveaway/exchange and status filters.
4. **Item requests**: a student sends a message + contact; only the owner sees it (`requests` table).
5. **Availability status**: owner marks an item Available or Claimed.
6. **Interface & hosting**: responsive UI, row-level security policies, Vercel deployment.

## Deploy (about 10 minutes)
1. supabase.com > New project. SQL Editor > paste `schema.sql` > Run.
2. Authentication > Providers > Email. For quick testing, turn off "Confirm email".
3. Project Settings > API: copy the Project URL and the `anon` public key into the top of the script in `index.html`.
4. Push this folder to your own GitHub repo.
5. vercel.com > Add New Project > import the repo > Deploy (no build settings needed).
6. Authentication > URL Configuration: set Site URL to your Vercel URL.

The anon key is meant to be public; the RLS policies in `schema.sql` are what protect the data.
