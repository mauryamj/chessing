---
name: supabase-rls-checklist
description: Step-by-step checklist for verifying and writing Row Level Security policies on Supabase tables for the Chessing project. Use when the user asks about database security, RLS, Supabase policies, or data isolation between users.
---

# Skill: Supabase Row Level Security (RLS) Checklist

## Why This Matters

Chessing uses Supabase with anon key authentication. Without RLS, **any authenticated user can read or write any other user's games, profile, and FCM tokens** — even though the client-side code filters by `user_id`. RLS enforces isolation at the database level.

## Tables That MUST Have RLS

| Table | Required Policies |
|-------|------------------|
| `profiles` | SELECT own row; UPDATE own row; no DELETE |
| `games` | SELECT/INSERT/DELETE own rows only |
| `moves` | SELECT/INSERT own game's moves only |
| `fcm_tokens` | SELECT/INSERT/DELETE own tokens only |
| `theory_bookmarks` | SELECT/INSERT/DELETE own bookmarks |
| `theory_progress` | SELECT/INSERT own progress |
| `theory_entries` | SELECT for all authenticated users (read-only content) |

## How to Verify RLS is Enabled

In Supabase Dashboard → Table Editor → select table → "RLS" badge should show "Enabled".

Or via SQL:
```sql
SELECT tablename, rowsecurity
FROM pg_tables
WHERE schemaname = 'public';
-- rowsecurity = true means RLS is ON
```

## Standard Policy Templates

### profiles
```sql
-- Enable RLS
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- Users can only see their own profile
CREATE POLICY "profiles_select_own"
ON profiles FOR SELECT
USING (auth.uid() = id);

-- Users can only update their own profile
CREATE POLICY "profiles_update_own"
ON profiles FOR UPDATE
USING (auth.uid() = id)
WITH CHECK (auth.uid() = id);
```

### games
```sql
ALTER TABLE games ENABLE ROW LEVEL SECURITY;

CREATE POLICY "games_select_own"
ON games FOR SELECT
USING (auth.uid() = user_id);

CREATE POLICY "games_insert_own"
ON games FOR INSERT
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "games_delete_own"
ON games FOR DELETE
USING (auth.uid() = user_id);
```

### moves
```sql
ALTER TABLE moves ENABLE ROW LEVEL SECURITY;

CREATE POLICY "moves_select_own"
ON moves FOR SELECT
USING (
  EXISTS (
    SELECT 1 FROM games
    WHERE games.id = moves.game_id
    AND games.user_id = auth.uid()
  )
);

CREATE POLICY "moves_insert_own"
ON moves FOR INSERT
WITH CHECK (
  EXISTS (
    SELECT 1 FROM games
    WHERE games.id = moves.game_id
    AND games.user_id = auth.uid()
  )
);
```

### fcm_tokens
```sql
ALTER TABLE fcm_tokens ENABLE ROW LEVEL SECURITY;

CREATE POLICY "fcm_tokens_own"
ON fcm_tokens FOR ALL
USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);
```

## Verifying Stats Integrity (Server-Side Computation)

The Dart client currently calls `updateStats()` directly. Replace with a PostgreSQL function:

```sql
CREATE OR REPLACE FUNCTION record_game_result(
  p_game_id UUID,
  p_player_won BOOLEAN,
  p_is_draw BOOLEAN,
  p_bot_elo INTEGER
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER  -- runs as postgres, bypasses RLS
AS $$
DECLARE
  v_user_id UUID := auth.uid();
  v_current_rating INTEGER;
  v_k INTEGER;
  v_expected FLOAT;
  v_new_rating INTEGER;
BEGIN
  SELECT current_rating INTO v_current_rating FROM profiles WHERE id = v_user_id;
  -- Elo calculation server-side ...
  UPDATE profiles SET
    current_rating = v_new_rating,
    wins = wins + (CASE WHEN p_player_won THEN 1 ELSE 0 END),
    losses = losses + (CASE WHEN NOT p_player_won AND NOT p_is_draw THEN 1 ELSE 0 END),
    draws = draws + (CASE WHEN p_is_draw THEN 1 ELSE 0 END),
    games_played = games_played + 1
  WHERE id = v_user_id;
END;
$$;
```

## Steps to Apply

1. Open Supabase Dashboard → SQL Editor.
2. Apply each policy block per table above.
3. Test with `supabase.from('profiles').select().neq('id', currentUserId)` — should return 0 rows.
4. Update `ProfileRepository.updateStats()` to call the Edge Function or RPC instead of direct update.

## References
- [Supabase RLS docs](https://supabase.com/docs/guides/database/postgres/row-level-security)
- `lib/core/supabase/repositories/profile_repository.dart` — `updateStats()`
- `lib/core/supabase/repositories/games_repository.dart` — `uploadGame()`
