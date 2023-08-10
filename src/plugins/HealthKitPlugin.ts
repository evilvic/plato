import { registerPlugin } from '@capacitor/core'

// ----- TS-DEFS -----

interface SampleType {
  value: number
  endDate: string
  source: string
  startDate: string
  uuid: string
  sourceBundleId: string
  unitName: string
  duration: number

}

type AuthOptions = {
  all: string[]
  read: string[]
  write: string[]
}

type QueryOptions = {
  startDate: string
  endDate: string
  limit: number
  sampleName: string
}

interface HealthKitPlugin {
  requestAuthorization: (options: AuthOptions) => Promise<void>
  queryHKitSampleType: (options: QueryOptions) => Promise<{
    countReturn: number,
    resultData: SampleType[]
  }>
}

// ----- END  TS-DEFS -----

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
