import { registerPlugin } from '@capacitor/core'


export interface CloudKitPlugin {
  createRecord(options: { 
    recordType: string; 
    fields: Record<string, any>;
  }): Promise<{ recordName: string }>;
  fetchRecords(options: {
    recordType: string;
  }): Promise<{ records: Record<string, any>[] }>;
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

export const fetchRecords = async () => {
  try {
      const { records } = await CloudKit.fetchRecords({ recordType: 'FoodEntry' });
      console.log('Fetched records', records);
  } catch (error) {
      console.error('Failed to fetch records', error);
  }
}