<script setup lang="ts">
import authService from '@/helpers/authService'

import { ref } from 'vue'

const email = ref<string>('')

const handleLogin = async () => {
  console.log(email.value)
  try {
    await authService.sendOtp(email.value)
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