import { Camera, CameraResultType } from '@capacitor/camera';

export const checkPermissions = async () => {
  const cameraPermissions = await Camera.checkPermissions();

  console.log(cameraPermissions); // {"camera":"prompt","photos":"prompt"}

  if (cameraPermissions.camera === 'prompt') {
    const permissionRequest = await Camera.requestPermissions();
    console.log(permissionRequest);
  }
}

export const takePicture = async () => {
  const image = await Camera.getPhoto({
    quality: 90,
    allowEditing: true,
    resultType: CameraResultType.DataUrl
  });

  return image.dataUrl
};