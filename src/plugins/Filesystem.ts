import { Filesystem } from '@capacitor/filesystem';

export async function convertLocalFileToBase64(filePath: string) {
  try {
    const result = await Filesystem.readFile({
      path: filePath,
    });

    const data = result.data.toString(); 
    const cleanData = data.replace("dataimage/jpegbase64", "");
    
    const base64String =  `data:image/jpeg;base64,${cleanData}`;

    return base64String;
  } catch (e) {
    console.error('Error reading file', e);
    return '';
  }
}