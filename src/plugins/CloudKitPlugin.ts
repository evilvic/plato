import { registerPlugin } from '@capacitor/core'
import { FOOD_DATA } from '@/helpers/webData';


export interface CloudKitPlugin {
  createRecord(options: { 
    recordType: string; 
    fields: Record<string, any>;
  }): Promise<{ recordName: string }>;
  fetchRecords(options: {
    recordType: string;
  }): Promise<{ records: Record<string, any>[] }>;
}

interface Entry {
  uuid: string;
  creationDate: string;
  description: string;
}

const CloudKit = registerPlugin<CloudKitPlugin>('CloudKitPlugin')

export const createRecord = async (description: string, images: string[]) => {
  try {
      await CloudKit.createRecord({ 
          recordType: 'FoodEntry', 
          fields: { description, images }
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
    return records;
  } catch (error) {
    console.error('Failed to fetch records', error);
    return FOOD_DATA;
  }
}