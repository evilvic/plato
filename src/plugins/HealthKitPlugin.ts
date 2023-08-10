import { registerPlugin } from '@capacitor/core'

interface HealthKitPlugin {
    requestAuthorization: (
        options: { 
            all: string[], 
            read: string[], 
            write: string[] 
        }
    ) => Promise<void>
    queryHKitSampleType: (
        options: {
            startDate: string,
            endDate: string,
            limit: number,
            sampleName: string
        }
    ) => Promise<{ countReturn: number, resultData: any[] }>
}

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
  const jsDate = new Date(date);
  const isoDate = jsDate.toISOString();
  
  return isoDate;
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
    console.log(error);
  }
}


// {"countReturn":1,"resultData":[{"value":500,"endDate":"2023-08-10T02:55:00Z","source":"Salud","startDate":"2023-08-10T02:55:00Z","uuid":"E789521C-8A1A-4910-B8F4-FDD1A892CED7","sourceBundleId":"com.apple.Health","unitName":"milliliter","duration":0}]}