import { registerPlugin } from '@capacitor/core';

const SuppressLongPress = registerPlugin<SuppressLongPressPlugin>('SuppressLongPressPlugin');

interface SuppressLongPressPlugin {
  activate(): Promise<void>;
}

export const activateSuppressLongPress = async (): Promise<void> => {
  try {
    return await SuppressLongPress.activate();
  } catch (err) {
    console.error(err);
  }
}