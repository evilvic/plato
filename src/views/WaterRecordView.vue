<script setup lang="ts">
import { ref } from 'vue'
import { saveData } from '@/plugins/HealthKitPlugin'

const water = ref<number | null>(null)

const handleSaveWater = () => {
  if (water.value !== null) {
    saveData(water.value, 'water')
  }
}

</script>

<template>
  <main class="water-record">
    
    <input
      type="number"
      placeholder="0"
      v-model="water"
    >
    <button
      @click="handleSaveWater"
    >
      Guardar agua
    </button>

  </main>
</template>

<style scoped lang="scss">
main {
  padding: 0 16px;
  padding-top: calc(60px + var(--safe-area-inset-top));
  padding-bottom: calc(48px + var(--safe-area-inset-bottom) + 60px);
  height: 100%;
  overflow-y: auto;
}
  .water-record {
    display: flex;
    flex-direction: column;
    align-items: center;
  }

  input {
  margin: 12px 0;
}
</style>