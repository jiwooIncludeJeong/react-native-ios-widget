import {NativeModules} from 'react-native';

const NativeSharedDefaults = NativeModules.SharedDefaults;

class SharedDefaults {
  public async set(obj: Record<string, any>) {
    try {
      const res: boolean = await NativeSharedDefaults.set(JSON.stringify(obj));
      return res;
    } catch (e) {
      console.warn('[SHARED DEFAULTS]', e);
      return false;
    }
  }
}

export default new SharedDefaults();
