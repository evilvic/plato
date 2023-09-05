<script setup lang="ts">
import { queryData } from '@/plugins/HealthKitPlugin'
import { ref, onMounted } from 'vue'

const loading = ref(true);
const data = ref<any[]>([]);

onMounted(() => {
  getWaterIntake();
})

const getWaterIntake = async () => {
  const water = await queryData();
  data.value = water || [];
  loading.value = false;
}
</script>

<template>
  <main>
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
