// import { registerPlugin } from '@capacitor/core'

interface SafeAreaInsets {
  top: number;
  bottom: number;
  left: number;
  right: number;
}

const SafeArea = registerPlugin('SafeAreaPlugin');

export const getSafeAreaInsets = async (): Promise<SafeAreaInsets> => {
  try {
    return await SafeArea.getInsets()
  } catch (err) {
    console.error(err)
    return { top: 0, bottom: 0, left: 0, right: 0 }
  }
}