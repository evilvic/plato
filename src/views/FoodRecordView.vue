<script setup lang="ts">
import { ref } from 'vue'
// import { saveData } from '@/plugins/HealthKitPlugin'
import { createRecord } from '@/plugins/CloudKitPlugin';
import { takePicture } from '@/plugins/Camera';
import { analyzeFoodEntry } from '@/helpers/openai';

const food = ref<string>('')
const imageDataUrl = ref<string | null>(null);
const analysisResult = ref<string | null>(null);

const handleSaveFood = async () => {
  if (food.value !== '' && imageDataUrl.value) {
    // Analizar la comida
    const result = await analyzeFoodEntry(food.value);
    const parsedResult = result ? JSON.parse(result) : '';
    analysisResult.value = parsedResult;
    

    const items = parsedResult.items


    const totals = parsedResult.total;

    // Crear el registro en CloudKit
    if (analysisResult.value) {
      const foodEntry = {
        items,
        totals,
        description: food.value,
        images: [imageDataUrl.value],
      };
      await createRecord(foodEntry);
    }
  }
};

const handleTakePicture = async () => {
  const picture = await takePicture();
  if (picture) {
    imageDataUrl.value = picture;
  }
};

const analyzeFood = async () => {
  const result = await analyzeFoodEntry(food.value);
  console.log('Food analysis:', result);
};

</script>

<template>
  <main class="water-record">

    <img v-if="imageDataUrl" :src="imageDataUrl" alt="Food Image" />

    <button v-else @click="handleTakePicture">
      Tomar foto
    </button>

    <textarea v-model="food" />

    <button @click="analyzeFood">
      Analizar comida
    </button>

    <button @click="handleSaveFood">
      Guardar comida
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
  button {
    margin: 12px 0;
  }
</style>