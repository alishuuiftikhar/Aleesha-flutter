-- 1. ANNOUNCEMENTS TABLE
CREATE TABLE IF NOT EXISTS announcements (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  image_url TEXT,
  status TEXT DEFAULT 'published', -- 'published', 'draft'
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 2. ENSURE SEATS HAVE 'disabled' STATUS
-- Existing seats status is 'available'. Let's ensure we can have 'disabled'.
-- ALTER TABLE seats ALTER COLUMN status SET DEFAULT 'available';

-- 3. ENSURE RESERVATION CONSTRAINTS
-- (student_id, reservation_date) and (seat_id, reservation_date) unique constraints
-- should already exist from previous schema, but adding them if missing.
-- ALTER TABLE reservations ADD CONSTRAINT unique_student_res_date UNIQUE (student_id, reservation_date);
-- ALTER TABLE reservations ADD CONSTRAINT unique_seat_res_date UNIQUE (seat_id, reservation_date);

-- 4. RLS FOR ANNOUNCEMENTS
ALTER TABLE announcements ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Announcements are viewable by everyone." ON announcements FOR SELECT USING (true);
CREATE POLICY "Only admins can manage announcements." ON announcements FOR ALL USING (
  EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin')
);

-- 5. FUNCTION TO GET SERVER TIME
CREATE OR REPLACE FUNCTION get_server_time()
RETURNS TIMESTAMP WITH TIME ZONE AS $$
  SELECT now();
$$ LANGUAGE sql STABLE;
