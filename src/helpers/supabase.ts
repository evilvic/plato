import { createClient } from '@supabase/supabase-js'
import { CapacitorPreferencesAdapter } from '@/plugins/Preferences'

const supabaseUrl = import.meta.env.VITE_SB_URL
const supabaseKey = import.meta.env.VITE_SB_KEY

export const supabase = createClient(
  supabaseUrl, 
  supabaseKey,
  {
    auth: {
      storage: CapacitorPreferencesAdapter
    }
  }
)


export const signIn = async () => {
  const { data, error } = await supabase.auth.signUp({
    email: 'vic.pero@icloud.com',
    password: '123456',
  })

  console.log(data, error)
}
