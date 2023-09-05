<script setup lang="ts">
import { onMounted } from 'vue'
import { getSafeAreaInsets } from '@/plugins/SafeAreaPlugin'
import { activateSuppressLongPress } from '@/plugins/LongPressPlugin'
import { RouterView } from 'vue-router'
import Navigation from '@/components/core/Navigation.vue'

onMounted( async () => {
  const safeAreaInsets = await getSafeAreaInsets()
  document.documentElement.style.setProperty('--safe-area-inset-top', `${safeAreaInsets.top}px`);
  document.documentElement.style.setProperty('--safe-area-inset-bottom', `${safeAreaInsets.bottom}px`);
  document.documentElement.style.setProperty('--safe-area-inset-left', `${safeAreaInsets.left}px`);
  document.documentElement.style.setProperty('--safe-area-inset-right', `${safeAreaInsets.right}px`);
  await activateSuppressLongPress()
})
</script>

<template>
  <RouterView />
  <Navigation />
</template>
