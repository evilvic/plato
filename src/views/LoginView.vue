<script setup lang="ts">
  import { ref } from 'vue'
  import { useRouter } from 'vue-router'
  import { useSessionStore } from '@/stores/session'
  import authService from '@/helpers/authService'

  const router = useRouter()
  const session = useSessionStore()

  const email = ref<string>('')

  const handleLogin = async () => {
    session.setEmail(email.value)
    try {
      await authService.sendOtp(email.value)
      router.push('/otp')
    } catch (err) {
      console.error(err)
    }
  }
</script>

<template>
  <div class="login">
    <input 
      type="text"
      placeholder="hello@plato.com"
      v-model="email"
    >
    <button
      @click="handleLogin"
    >
      Iniciar
    </button>
  </div>
</template>

<style scoped lang="scss">
  .login {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 16px;
  }
</style>