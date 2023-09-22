<script setup lang="ts">
import { ref } from 'vue'

const water = ref<number>(0)

const handleSave = () => {
  console.log(water.value)
}

</script>

<template>
  <div class="water-record">
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
  </div>
</template>