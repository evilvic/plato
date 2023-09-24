// ----- TS-DEFS -----

export interface SampleType {
  value: number
  endDate: string
  source: string
  startDate: string
  uuid: string
  sourceBundleId: string
  unitName: string
  duration: number
}

export type AuthOptions = {
  all: string[]
  read: string[]
  write: string[]
}

export type QueryOptions = {
  startDate: string
  endDate: string
  limit: number
  sampleName: string
}

export interface HealthKitPlugin {
  requestAuthorization: (options: AuthOptions) => Promise<void>
  queryHKitSampleType: (options: QueryOptions) => Promise<{
    countReturn: number,
    resultData: SampleType[]
  }>
  saveHKitSampleType: (options: {
    date: string
    sampleName: string
    value: number
  }) => Promise<void>
}

// ----- END  TS-DEFS -----