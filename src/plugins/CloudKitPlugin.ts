import { registerPlugin } from '@capacitor/core'
import { FOOD_DATA } from '@/helpers/webData';
import { convertLocalFileToBase64 } from '@/plugins/Filesystem';

export interface FoodItem {
  food: string;
  quantity: string;
  calories: number;
  fat: number;
  protein: number;
  sugar: number;
}

export interface FoodEntry {
  uuid?: string;
  description: string;
  creationDate?: string;
  items: FoodItem[];
  totals?: {
    calories: number;
    fat: number;
    protein: number;
    sugar: number;
  };
  images?: string[];
  imageBase64?: string[];
}

export interface CloudKitPlugin {
  createRecord(options: { 
    recordType: string; 
    fields: Record<string, any>;
  }): Promise<{ recordName: string }>;
  fetchRecords(options: {
    recordType: string;
  }): Promise<{ records: FoodEntry[] }>;
}

const CloudKit = registerPlugin<CloudKitPlugin>('CloudKitPlugin')

export const createRecord = async (entry: FoodEntry) => {
  try {
      await CloudKit.createRecord({ 
          recordType: 'FoodEntry', 
          fields: { 
            description: entry.description,
            items: entry.items.map(item => JSON.stringify(item)),
            totals: JSON.stringify(entry.totals),
            images: entry.images,
          }
      });
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
      const items = (record.items || []).map((item: any) => JSON.parse(item) as FoodItem);
      const totals = record.totals ? JSON.parse(record.totals as any) : { calories: 0, fat: 0, protein: 0, sugar: 0 };
      return { 
        ...record, 
        images, 
        imageBase64,
        uuid: record.uuid,
        creationDate: record.creationDate,
        totals,
        items
      };
    }));
    return processedRecords;
  } catch (error) {
    console.error('Failed to fetch records', error);
    return FOOD_DATA;
  }
}