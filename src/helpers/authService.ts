import { supabase } from '@/helpers/supabase'

const authService = {
  async sendOtp(email: string) {
    const { data, error } = await supabase
      .auth
      .signInWithOtp({ email })

    return { data, error }
  },

  async verifyOtp(email: string, token: string) {
    const { data, error } = await supabase
      .auth
      .verifyOtp({ email, token, type: 'email' })

    return { data, error }
  },

  async signOut() {
    const { error } = await supabase
      .auth
      .signOut()

    if (error) throw error;
  },

  async isAuthenticated(): Promise<boolean> {
    const { data, error } = await supabase
      .auth
      .getSession()
    if (error) throw error;
    return data.session ? true : false
  },

}

export default authService