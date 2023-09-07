<script setup lang="ts">
import { requestHKAuthorization } from '@/plugins/HealthKitPlugin'
import { queryData } from '@/plugins/HealthKitPlugin'
import { formatTimeToHHMM } from '@/helpers/dayjs'
import { ref, onMounted } from 'vue'

const loading = ref(false);
const data = ref<any[]>([]);

onMounted(() => {
  requestHKAuthorization()
  getWaterIntake();
  // data.value = [
  // {
  //   "value":372,
  //   "source":"Health",
  //   "unitName":"milliliter",
  //   "uuid":"25024F31-3517-42BF-ADE8-72FFDF74D447",
  //   "endDate":"2023-08-31T18:16:00Z",
  //   "duration":0,
  //   "sourceBundleId":"com.apple.Health",
  //   "startDate":"2023-08-31T18:16:00Z"
  // }
  // ]
})

const getWaterIntake = async () => {
  const water = await queryData();
  data.value = water || [];
  loading.value = false;
}
/*
{
  "value":372,
  "source":"Health",
  "unitName":"milliliter",
  "uuid":"25024F31-3517-42BF-ADE8-72FFDF74D447",
  "endDate":"2023-08-31T18:16:00Z",
  "duration":0,
  "sourceBundleId":"com.apple.Health",
  "startDate":"2023-08-31T18:16:00Z"
}
*/
</script>

<template>
  <main>
    <ul
      class="container"
      v-if="!loading && data"
    >
      <li
        class="card"
        v-for="el in data"
        :key="el.uuid"
      >
        <span class="card__qty">{{ el.value }} ml</span>
        <span class="card__bottom">
          {{ formatTimeToHHMM(el.startDate) }}
        </span>
      </li>
    </ul>
    <div v-else>
      loading...
    </div>
  </main>
</template>


<style scoped lang="scss">
@import '@/styles/variables.scss';

main {
  padding: 0 16px;
}
.container {
  display: flex;
  flex-wrap: wrap;
  list-style: none;
  gap: 16px;
}
.card {
  width: calc((100vw - 64px) / 3);
  height: calc((100vw - 64px) / 3);
  background-color: $bg-29;
  border-radius: 8px;
  position: relative;
  display: flex;
  justify-content: center;
  align-items: center;
  &__qty{
    font-size: 16px;
    font-weight: 700;
  }
  &__bottom {
    background: $blue;
    width: 100%;
    height: 16px;
    position: absolute;
    bottom: 0;
    border-radius: 0 0 8px 8px;
    color: $bg-09;
    display: flex;
    justify-content: center;
    align-items: center;
    font-size: 12px;
    font-weight: 700;
  }
}
</style>