<script setup lang="ts">
import { requestHKAuthorization } from '@/plugins/HealthKitPlugin'
import { queryData } from '@/plugins/HealthKitPlugin'
import { formatTimeToHHMM, formatDateToYYYYMMDD, formatDateWithTodayAndYesterday } from '@/helpers/dayjs'
import { ref, computed, onMounted } from 'vue'

interface WaterData {
  value: number;
  source: string;
  unitName: string;
  uuid: string;
  endDate: string;
  duration: number;
  sourceBundleId: string;
  startDate: string;
}

const loading = ref<boolean>(false);
const data = ref<Record<string, WaterData[]>>({});

const castedData = computed(() => data.value as Record<string, WaterData[]>);

onMounted(() => {
  // requestHKAuthorization()
  getWaterIntake();
  // getHarcodedWater();
})

const getWaterIntake = async () => {
  const water: WaterData[] = await queryData() || [];
  data.value = groupByDate(water);
  loading.value = false;
}

const getHarcodedWater = () => {
  const water = [
    {
      "value":400,
      "source":"Health",
      "unitName":"milliliter",
      "uuid":"25024F31-3517-42BF-ADE8-72FFDF74D447",
      "endDate":"2023-08-31T18:16:00Z",
      "duration":0,
      "sourceBundleId":"com.apple.Health",
      "startDate":"2023-09-07T18:16:00Z"
    },
    {
      "value":200,
      "source":"Health",
      "unitName":"milliliter",
      "uuid":"25024F31-3517-42BF-ADE8-72FFDF74D447",
      "endDate":"2023-08-31T18:16:00Z",
      "duration":0,
      "sourceBundleId":"com.apple.Health",
      "startDate":"2023-09-05T18:16:00Z"
    },
    {
      "value":350,
      "source":"Health",
      "unitName":"milliliter",
      "uuid":"25024F31-3517-42BF-ADE8-72FFDF74D447",
      "endDate":"2023-08-31T18:16:00Z",
      "duration":0,
      "sourceBundleId":"com.apple.Health",
      "startDate":"2023-09-06T18:16:00Z"
    },
  ]

  data.value = groupByDate(water);
}

const groupByDate = (waterData: WaterData[]): Record<string, WaterData[]> => {
  const grouped: Record<string, WaterData[]> = {};

  waterData.forEach(item => {
    const dateKey = formatDateToYYYYMMDD(item.startDate);
    if (!grouped[dateKey]) {
      grouped[dateKey] = [];
    }
    grouped[dateKey].push(item);
  });

  const sortedDates = Object.keys(grouped).sort((a, b) => new Date(b).getTime() - new Date(a).getTime());
  
  const orderedData: Record<string, WaterData[]> = {};
  sortedDates.forEach(date => {
    orderedData[date] = grouped[date];
  });

  return orderedData;
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
    <div v-for="(entries, date) in castedData" :key="date">
      <h3>  {{ formatDateWithTodayAndYesterday(date) }} </h3>
      <ul
        class="container"
        v-if="!loading && data"
      >
        <li
          class="card"
          v-for="entry in entries"
          :key="entry.uuid"
        >
          <span class="card__qty">{{ entry.value }} ml</span>
          <span class="card__bottom">
            {{ formatTimeToHHMM(entry.startDate) }}
          </span>
        </li>
      </ul>
    </div>
  </main>
</template>


<style scoped lang="scss">
@import '@/styles/variables.scss';

main {
  padding: 0 16px;
}
h3 {
  margin: 12px 0 6px;
}
h3::first-letter {
    text-transform: capitalize;
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