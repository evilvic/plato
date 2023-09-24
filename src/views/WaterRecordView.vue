<script setup lang="ts">
import { ref } from 'vue'

const water = ref<number>(0)

const handleSave = () => {
  console.log(water.value)
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
      @click="handleSave"
    >
      Guardar
    </button>
  </main>
</template>

<style scoped lang="scss">
  .water-record {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 16px;
  }
</style>