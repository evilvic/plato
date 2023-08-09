import { registerPlugin } from '@capacitor/core'

interface HealthKitPlugin {
    requestAuthorization: (
        options: { 
            all: string[], 
            read: string[], 
            write: string[] 
        }
    ) => Promise<void>
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