import { Device } from '@capacitor/device';

export const getDeviceInfo = async () => {
  try {
    return await Device.getInfo();
  } catch (err) {
    console.error(err)
  }
}