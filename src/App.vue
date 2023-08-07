<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { supabase } from '@/services/supabase'

import type { Ref } from 'vue'

interface Country {
  id: number
  name: string
}

const countries: Ref<Country[]> = ref([])

async function getCountries() {
  const { data } = await supabase.from('countries').select()
  countries.value = data || []
}

onMounted(() => {
  getCountries()
})
</script>

<template>
  <ul>
    <li 
      v-for="country in countries" 
      :key="country.id"
    >
      {{ country.name }}
    </li>
  </ul>
  <RouterView />
</template>

<style scoped>
</style>
