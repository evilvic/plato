<script setup lang="ts">
import { requestHKAuthorization } from '@/plugins/HealthKitPlugin'
import { queryData } from '@/plugins/HealthKitPlugin'
import { fetchRecords } from '@/plugins/CloudKitPlugin'
import { checkPermissions } from '@/plugins/Camera'
import { formatTimeToHHMM, formatDateToYYYYMMDD, formatDateWithTodayAndYesterday } from '@/helpers/dayjs'
import { ref, computed, onMounted } from 'vue'

interface BaseHealthData {
  dataType: 'water' | 'weight' | 'workout' | 'cloudKitEntry';
  value: number;
  source: string;
  unitName: string;
  uuid: string;
  endDate: string;
  duration: number;
  sourceBundleId: string;
  startDate: string;
}

interface WorkoutHealthData extends BaseHealthData {
  workoutActivityName?: string;
  totalDistance?: number;
  totalEnergyBurned?: number;
  totalFlightsClimbed?: number;
  totalSwimmingStrokeCount?: number;
  workoutActivityId?: number;
}

type HealthData = BaseHealthData | WorkoutHealthData;

const loading = ref<boolean>(false);
const data = ref<Record<string, HealthData[]>>({});

const castedData = computed(() => data.value as Record<string, HealthData[]>);

onMounted(() => {
  checkPermissions()
  requestHKAuthorization()
  getWaterIntake();
  getWeight();
  getWorkouts();
  getFood();
})

const getWaterIntake = async () => {
  const waterData = await queryData("water") as HealthData[] || [];

  const formattedData: HealthData[] = waterData.map(entry => ({
    dataType: 'water',
    value: entry.value,
    source: entry.source,
    unitName: 'ml',
    uuid: entry.uuid,
    endDate: entry.endDate,
    duration: entry.duration,
    sourceBundleId: entry.sourceBundleId,
    startDate: entry.startDate,
  }));

  addToDataByDate(formattedData);
  loading.value = false;
}

const getWeight = async () => {
  const weightData = await queryData("weight") as HealthData[] || [];

  const formattedData: HealthData[] = weightData.map(entry => ({
    dataType: 'weight',
    value: entry.value,
    source: entry.source,
    unitName: 'kg',
    uuid: entry.uuid,
    endDate: entry.endDate,
    duration: entry.duration,
    sourceBundleId: entry.sourceBundleId,
    startDate: entry.startDate,
  }));

  addToDataByDate(formattedData);
  loading.value = false;
}

const getWorkouts = async () => {
  const workoutData = await queryData("workout") as HealthData[] || [];
  console.log(workoutData);

  const formattedData: HealthData[] = workoutData.map(entry => 
  'workoutActivityName' in entry ? {
    dataType: 'workout',
    value: (entry.totalDistance ? entry.totalDistance / 1000 : -1), 
    unitName: entry.workoutActivityName === "Walking" ? 'km' : 'km',
    uuid: entry.uuid,
    endDate: entry.endDate,
    duration: entry.duration,
    source: entry.source,
    sourceBundleId: entry.sourceBundleId,
    startDate: entry.startDate,
    workoutActivityName: entry.workoutActivityName
  } : entry
);

  addToDataByDate(formattedData);
  loading.value = false;
}

const getFood = async () => {
  try {
    const records = await fetchRecords();
    console.log('Fetched records from CloudKit:', records);

    const formattedData: HealthData[] = records.map(entry => ({
      dataType: 'cloudKitEntry',
      value: 1,
      unitName: 'meal',
      uuid: (entry as { uuid: string }).uuid,
      startDate: entry.creationDate,
      endDate: entry.creationDate,
      source: 'CloudKit',
      sourceBundleId: 'fail.vic,plato',
      duration: 0,
    }));

    addToDataByDate(formattedData);
    loading.value = false;
  } catch (error) {
    console.error('Failed to fetch records from CloudKit', error);
    loading.value = false;
  }
};



const groupByDate = (healthData: HealthData[]): Record<string, HealthData[]> => {
  const grouped: Record<string, HealthData[]> = {};

  healthData.forEach(item => {
    const dateKey = formatDateToYYYYMMDD(item.startDate);
    if (!grouped[dateKey]) {
      grouped[dateKey] = [];
    }
    grouped[dateKey].push(item);
  });

  Object.keys(grouped).forEach(date => {
    grouped[date].sort((a, b) => new Date(a.startDate).getTime() - new Date(b.startDate).getTime());
  });

  const sortedDates = Object.keys(grouped).sort((a, b) => new Date(b).getTime() - new Date(a).getTime());
  
  const orderedData: Record<string, HealthData[]> = {};
  sortedDates.forEach(date => {
    orderedData[date] = grouped[date];
  });

  return orderedData;
}

const addToDataByDate = (formattedData: HealthData[]) => {
  formattedData.forEach(item => {
    const dateKey = formatDateToYYYYMMDD(item.startDate);
    if (!data.value[dateKey]) {
      data.value[dateKey] = [];
    }
    data.value[dateKey].push(item);
  });

  // Ordena las fechas después de agregar los datos
  const orderedData = groupByDate(Object.values(data.value).flat());
  data.value = orderedData;
}

</script>

<template>
  <main>
    <div v-for="(entries, date) in castedData" :key="date">
      <h3> {{ formatDateWithTodayAndYesterday(date) }} </h3>
      <ul class="container" v-if="!loading && data">
        <li class="card" v-for="entry in entries" :key="entry.uuid">
          <!-- Condición actualizada: Si es entrenamiento y es caminata o nado, muestra distancia. De lo contrario, muestra como antes. -->
          <span class="card__qty">
            {{
              entry.dataType === 'cloudKitEntry'
                ? entry.value + ' ' + entry.unitName
                : entry.dataType === 'workout' && 'workoutActivityName' in entry &&
                  (entry.workoutActivityName === "Walking" || entry.workoutActivityName === "Other")
                ? (Math.floor(entry.value * 100) / 100).toFixed(2) + ' ' + entry.unitName
                : entry.value + ' ' + entry.unitName
            }}
          </span>
          <span class="card__bottom" :class="{
            'card__bottom--weight': entry.dataType === 'weight',
            'card__bottom--workout': entry.dataType === 'workout',
            'card__bottom--cloudKitEntry': entry.dataType === 'cloudKitEntry'
          }">
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
  padding-top: calc(60px + var(--safe-area-inset-top));
  padding-bottom: calc(48px + var(--safe-area-inset-bottom) + 60px);
  height: 100%;
  overflow-y: auto;
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
  background: $bg-29;
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
    &--weight {
      background: $red;
    }
    &--workout {
      background: $green;
    }
    &--cloudKitEntry {
      background: $purple;
    }
  }
}
</style>