import { registerPlugin } from '@capacitor/core'

interface SafeAreaInsets {
  top: number;
  bottom: number;
  left: number;
  right: number;
}

interface SafeAreaPlugin {
  getInsets: () => Promise<SafeAreaInsets>;
}

const SafeArea = registerPlugin<SafeAreaPlugin>('SafeAreaPlugin')

export const getSafeAreaInsets = async (): Promise<SafeAreaInsets> => {
  try {
    return await SafeArea.getInsets()
  } catch (err) {
    console.error(err)
    return { top: 59, bottom: 34, left: 0, right: 0 }
  }
}