<script setup lang="ts">
import { ref } from 'vue'
import { saveData } from '@/plugins/HealthKitPlugin'
import { createRecord } from '@/plugins/CloudKitPlugin';
import { takePicture } from '@/plugins/Camera';
import { analyzeFoodEntry } from '@/helpers/openai';
// import { FOOD_ANALYSIS_DATA } from '@/helpers/webData';
import type { FoodItem, FoodEntry } from '@/plugins/CloudKitPlugin';

type Totals = {
  calories: string;
  fat: string;
  protein: string;
  sugar: string;
};

type AnalysisResult = {
  items: FoodItem[];
  total: Totals;
};

const food = ref<string>('')
const imageDataUrl = ref<string | null>(null);
const analysisResult = ref<AnalysisResult | null>(null);

const handleSaveFood = async () => {
  if (food.value !== '' && imageDataUrl.value) {

    const items = analysisResult.value?.items
    const totals = analysisResult.value?.total

    // Crear el registro en CloudKit
    if (analysisResult.value) {
      await saveData(Number(analysisResult.value.total.calories), 'dietaryEnergy');
      await saveData(Number(analysisResult.value.total.fat.replace(/[a-zA-Z]/g, '')), 'totalFat');
      await saveData(Number(analysisResult.value.total.protein.replace(/[a-zA-Z]/g, '')), 'protein');
      await saveData(Number(analysisResult.value.total.sugar.replace(/[a-zA-Z]/g, '')), 'carbohydrates');
      const foodEntry: FoodEntry = {
        items: items || [],
        totals: totals || { calories: '', fat: '', protein: '', sugar: '' },
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
  const parsedResult = result ? JSON.parse(result) : {};
  analysisResult.value = parsedResult;
};

</script>

<template>
  <main class="food-record">

    <img 
      v-if="imageDataUrl"
      :src="imageDataUrl"
      alt="Food Image"
      class="food-record__image"
    />

    <button v-else @click="handleTakePicture">
      Tomar foto
    </button>

    <textarea v-model="food" />

    <button @click="analyzeFood">
      Analizar comida
    </button>

    <div 
      v-if="analysisResult"
      class="food-record__items"
    >
      <div 
        v-for="item in analysisResult.items"
        class="food-record__item"
      >
        <div class="food-record__item-food">
          <p>{{ item.quantity }}</p>
          <p>{{ item.food }}</p>
        </div>
        <div class="food-record__item-qty">
          <p>{{ item.calories }}Cal</p>
          <p>{{ item.fat }}</p>
          <p>{{ item.protein }}</p>
          <p>{{ item.sugar }}</p>
        </div>
      </div>
    </div>

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
.food-record {
  display: flex;
  flex-direction: column;
  align-items: center;
  &__image {
    width: 100%;
    margin: 12px 0;
  }
  &__items {
    width: 100%;
  }
  &__item-food {
    display: flex;
    justify-content: space-between;
    margin: 12px 0 0;
    border-bottom: 1px solid #ccc;
  }
  &__item-qty {
    display: flex;
    justify-content: space-between;
    margin: 4px 0 12px;
  }
}
button {
  margin: 12px 0;
}
</style>