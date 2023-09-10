import { Preferences } from '@capacitor/preferences'

interface StorageAdapter {
  getItem: (key: string) => Promise<any | null>;
  setItem: (key: string, value: any) => Promise<void>;
  removeItem: (key: string) => Promise<void>;
}

export const CapacitorPreferencesAdapter: StorageAdapter = {
  async getItem(key) {
    const { value } = await Preferences.get({ key });
    return value || null;
  },

  async setItem(key, value) {
    await Preferences.set({ key, value });
  },

  async removeItem(key) {
    await Preferences.remove({ key });
  },
};