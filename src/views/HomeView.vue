<script setup lang="ts">
import { requestHKAuthorization } from '@/plugins/HealthKitPlugin'
</script>

<template>
  <main>
    <p>Hello world!</p>
    <button @click="requestHKAuthorization">
      Request authorization
    </button>
  </main>
</template>
