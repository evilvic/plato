import { registerPlugin } from '@capacitor/core'
import type { HealthKitPlugin } from '@/plugins/HealthKitPlugin.types'

const HealthKit = registerPlugin<HealthKitPlugin>('HealthKitPlugin')

export const requestHKAuthorization = async () => {
    try {
        await HealthKit.requestAuthorization({
            all: ["water"],
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
  
const today = new Date();
const oneWeekAgo = new Date(today.getTime() - 7 * 24 * 60 * 60 * 1000);

export const queryData = async () => {
  try {
    const { countReturn, resultData } = await HealthKit.queryHKitSampleType({
      startDate: formatDateToISO8601(oneWeekAgo),
      endDate: formatDateToISO8601(today),
      limit: 25,
      sampleName: "water",
    });
    return resultData;
  } catch (error) {
    console.error(error);
  }
}

export const saveData = async (value: number) => {
  try {
    const response = await HealthKit.saveHKitSampleType({
      date: formatDateToISO8601(today),
      sampleName: "water",
      value: value,
    });
    console.log(response);
  } catch (error) {
    console.error(error);
  }
}
