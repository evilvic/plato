import { registerPlugin } from '@capacitor/core'
import { FOOD_DATA } from '@/helpers/webData';
import { convertLocalFileToBase64 } from '@/plugins/Filesystem';

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
  images?: string[];
  imageBase64?: string[];
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
    const processedRecords = await Promise.all(records.map(async record => {
      const images = record.images || [];
      const imageBase64 = await Promise.all(images.map((img: string) => convertLocalFileToBase64(img)));
      return { ...record, images, imageBase64 ,uuid: record.uuid, creationDate: record.creationDate };
    }));
    console.log('Fetched records', processedRecords);
    return processedRecords;
  } catch (error) {
    console.error('Failed to fetch records', error);
    return FOOD_DATA;
  }
}