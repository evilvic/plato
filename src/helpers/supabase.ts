import { createClient } from '@supabase/supabase-js'
import { CapacitorPreferencesAdapter as storage } from '@/plugins/Preferences'

const supabaseUrl = import.meta.env.VITE_SB_URL
const supabaseKey = import.meta.env.VITE_SB_KEY

export const supabase = createClient(
  supabaseUrl, 
  supabaseKey,
  { auth: { storage } }
)
