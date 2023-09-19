import { ref } from 'vue'
import { defineStore } from 'pinia'

export const useSessionStore = defineStore('session', () => {
  const email = ref('')

  function setEmail(val: string) {
    email.value = val
  }

  return {
    email,
    setEmail
  }
})