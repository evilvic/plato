import { registerPlugin } from '@capacitor/core'


export interface CloudKitPlugin {
  createRecord(options: { 
    recordType: string; 
    fields: Record<string, any>; 
  }): Promise<{ recordName: string }>;
}

const CloudKit = registerPlugin<CloudKitPlugin>('CloudKitPlugin')

export const createRecord = async () => {
  try {
      await CloudKit.createRecord({ 
          recordType: 'FoodEntry', 
          fields: { description: 'Apple' }
      });
      console.log('Record created successfully');
  } catch (error) {
      console.error('Failed to create record', error);
  }
};