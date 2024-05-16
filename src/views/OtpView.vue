<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useSessionStore } from '@/stores/session'
import authService from '@/helpers/authService'

const router = useRouter()
const session = useSessionStore()

const otp = ref<string>('')

const handleOtp = async () => {
  try {
    await authService.verifyOtp(session.email, otp.value)
    router.push('/')
  } catch (err) {
    console.error(err)
  }
}
</script>

<template>
  <div class="otp">
    <input
      type="text"
      :value="session.email"
      disabled
    >
    <input
      type="text"
      placeholder="123456"
      v-model="otp"
    >
    <button
      @click="handleOtp"
    >
      Iniciar
    </button>
  </div>
</template>

<style scoped lang="scss">
  .otp {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 16px;
  }
</style>