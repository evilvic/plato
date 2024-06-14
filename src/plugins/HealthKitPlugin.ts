import { registerPlugin } from '@capacitor/core'
import type { HealthKitPlugin } from '@/plugins/HealthKitPlugin.types'
import { WATER_DATA, WEIGHT_DATA, WORKOUT_DATA } from '@/helpers/webData'

const HealthKit = registerPlugin<HealthKitPlugin>('HealthKitPlugin')

export const requestHKAuthorization = async () => {
    try {
        await HealthKit.requestAuthorization({
            all: ["water", "weight", "workout", "dietaryEnergy"],
            read: [],
            write: [],
        })
    } catch (error) {
        console.error(error)
    }
}

function formatDateToISO8601(date: string | number | Date): string {
  return new Date(date).toISOString();
}

export const queryData = async (sample: string) => {
  const today = new Date();
  const oneWeekAgo = new Date(today.getTime() - 7 * 24 * 60 * 60 * 1000);
  try {
    const { countReturn, resultData } = await HealthKit.queryHKitSampleType({
      startDate: formatDateToISO8601(oneWeekAgo),
      endDate: formatDateToISO8601(today),
      limit: 25,
      sampleName: sample,
    });
    return resultData;
  } catch (error) {
    console.error(error);
    return sample === "water" ? WATER_DATA : sample === "weight" ? WEIGHT_DATA : WORKOUT_DATA;
  }
}

export const saveData = async (value: number, sample: string) => {
  const today = new Date();
  try {
    const response = await HealthKit.saveHKitSampleType({
      date: formatDateToISO8601(today),
      sampleName: sample,
      value: value,
    });
  } catch (error) {
    console.error(error);
  }
}

