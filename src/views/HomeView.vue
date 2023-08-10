<script setup lang="ts">
import { requestHKAuthorization, queryData } from '@/plugins/HealthKitPlugin'
import { ref } from 'vue'

const loading = ref(true);
const data = ref<any[]>([]); 

const getWaterIntake = async () => {
  try {
    const water = await queryData();
    data.value = water || [];
    console.log(water)
    loading.value = false;
  } catch (error) {
    console.log(error)
  }
}
</script>

<template>
  <main>
    <p>Hello world!</p>
    <button @click="requestHKAuthorization">
      Request authorization
    </button>

    <button @click="getWaterIntake">GET WATER</button>
    <br>
    <ul
      v-if="!loading && data" 
      v-for="el in data"
    >
      <li :key="el.uuid">{{ el.value }} {{ el.unitName }}</li>
    </ul>
    <div v-else>
      loading...
    </div>
  </main>
</template>
