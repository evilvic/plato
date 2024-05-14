import { Camera, CameraResultType } from '@capacitor/camera';

const takePicture = async () => {
  const image = await Camera.getPhoto({
    quality: 90,
    allowEditing: true,
    resultType: CameraResultType.Uri
  });

  var imageUrl = image.webPath;
};

export const checkPermissions = async () => {
  const cameraPermissions = await Camera.checkPermissions();

  console.log(cameraPermissions); // {"camera":"prompt","photos":"prompt"}

  if (cameraPermissions.camera === 'prompt') {
    const permissionRequest = await Camera.requestPermissions();
    console.log(permissionRequest);
  }
}