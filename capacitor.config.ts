import { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'fail.vic.plato',
  appName: 'plato',
  webDir: 'dist',
  server: {
    androidScheme: 'https'
  }
};

export default config;
