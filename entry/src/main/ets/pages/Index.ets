import { sensor } from '@kit.SensorServiceKit';
import { BusinessError } from '@kit.BasicServicesKit';
import PermissionsUtil from '../utils/PermissionsUtil';

@Builder
export function IndexBuilder() {
  Index();
}

@Entry({ routeName: 'Index' })
@Component
struct Index {
  pageInfos: NavPathStack = new NavPathStack()

  @State accelerometer: string = '';
  @State gyroscope: string = '';
  @State light: string = '';
  @State pressure: string = '';
  @State humidity: string = '';
  @State temperature: string = '';
  @State orientation: string = '';
  @State gravity: string = '';
  @State heartData: number = 0;
  @State pedometer: number = 0;
  private uiContext = this.getUIContext();
  private realContext = this.uiContext.getHostContext()

  aboutToAppear(): void {
    const INTERVAL = 200000000;
    PermissionsUtil.requestPermissions([
      'ohos.permission.ACCELEROMETER',
      'ohos.permission.ACTIVITY_MOTION',
      'ohos.permission.GYROSCOPE',
      'ohos.permission.READ_HEALTH_DATA'], this.realContext!)
    sensor.getSensorList((error: BusinessError, data: Array<sensor.Sensor>) => {
      if (error) {
        console.error('getSensorList failed');
      } else {
        console.info('getSensorList success');
        for (let i = 0; i < data.length; i++) {
          console.info(JSON.stringify(data[i]));
        }
      }
    })
    try {
      sensor.on(sensor.SensorId.ACCELEROMETER, (data) => {
        this.accelerometer = `x:${data.x.toFixed(2)}, y:${data.y.toFixed(2)}, z:${data.z.toFixed(2)}`;
      }, { interval: INTERVAL });
    } catch (error) {
      let e: BusinessError = error as BusinessError;
      console.error(`Accelerometer error: ${e.message}`);
    }

    try {
        sensor.on(sensor.SensorId.PEDOMETER, (data: sensor.PedometerResponse) => {
          console.info(`Succeeded in invoking on. Step count: ${data.steps}`);
          this.pedometer = data.steps
        }, { interval: INTERVAL });
    } catch (error) {
      let e: BusinessError = error as BusinessError;
      console.error(`Failed to invoke on. Code: ${e.code}, message: ${e.message}`);
    }

    try {
      sensor.on(sensor.SensorId.GYROSCOPE, (data) => {
        this.gyroscope = `x:${data.x.toFixed(2)}, y:${data.y.toFixed(2)}, z:${data.z.toFixed(2)}`;
      }, { interval: INTERVAL });
    } catch (error) {
      console.error('Gyroscope failed.');
    }

    try {
      sensor.on(sensor.SensorId.GRAVITY, (data: sensor.GravityResponse) => {
        this.gravity = `x:${data.x.toFixed(2)}, y:${data.y.toFixed(2)}, z:${data.z.toFixed(2)}`;
        console.info(`Succeeded in invoking on. X-coordinate component:: ${data.x}`);
        console.info(`Succeeded in invoking on. Y-coordinate component:: ${data.y}`);
        console.info(`Succeeded in invoking on. Z-coordinate component:: ${data.z}`);
      }, { interval: INTERVAL });
      setTimeout(() => {
        sensor.off(sensor.SensorId.GRAVITY);
      }, 500);
    } catch (error) {
      let e: BusinessError = error as BusinessError;
      console.error(`Failed to invoke on. Code: ${e.code}, message: ${e.message}`);
    }

    try {
      sensor.on(sensor.SensorId.HEART_RATE, (data: sensor.HeartRateResponse) => {
        this.heartData = data.heartRate
      }, { interval: INTERVAL });
      setTimeout(() => {
        sensor.off(sensor.SensorId.HEART_RATE);
      }, 500);
    } catch (error) {
      let e: BusinessError = error as BusinessError;
      console.error(`Failed to invoke on. Code: ${e.code}, message: ${e.message}`);
    }

    try {
      sensor.on(sensor.SensorId.AMBIENT_LIGHT, (data) => {
        this.light = `Light: ${data.intensity.toFixed(2)} lx`;
      }, { interval: INTERVAL });
    } catch (error) {
      console.error('Light sensor failed.');
    }


    try {
      sensor.on(sensor.SensorId.BAROMETER, (data) => {
        this.pressure = `Pressure: ${data.pressure.toFixed(2)} hPa`;
      }, { interval: INTERVAL });
    } catch (error) {
      console.error('Barometer failed.');
    }

    try {
      sensor.on(sensor.SensorId.HUMIDITY, (data) => {
        this.humidity = `Humidity: ${data.humidity.toFixed(2)}%`;
      }, { interval: INTERVAL });
    } catch (error) {
      console.error('Humidity sensor failed.');
    }

    try {
      sensor.on(sensor.SensorId.AMBIENT_TEMPERATURE, (data) => {
        this.temperature = `Temp: ${data.temperature.toFixed(2)} °C`;
      }, { interval: INTERVAL });
    } catch (error) {
      console.error('Temperature sensor failed.');
    }

    try {
      sensor.on(sensor.SensorId.ORIENTATION, (data) => {
        this.orientation = `Pitch: ${data.alpha.toFixed(2)}, Roll: ${data.beta.toFixed(2)}, Yaw: ${data.gamma.toFixed(2)}`;
      }, { interval: INTERVAL });
    } catch (error) {
      console.error('Orientation sensor failed.');
    }
  }

  aboutToDisappear(): void {
    sensor.off(sensor.SensorId.ACCELEROMETER);
    sensor.off(sensor.SensorId.GRAVITY);
    sensor.off(sensor.SensorId.GYROSCOPE);
    sensor.off(sensor.SensorId.AMBIENT_LIGHT);
    sensor.off(sensor.SensorId.BAROMETER);
    sensor.off(sensor.SensorId.HUMIDITY);
    sensor.off(sensor.SensorId.AMBIENT_TEMPERATURE);
    sensor.off(sensor.SensorId.ORIENTATION);
    sensor.off(sensor.SensorId.HEART_RATE);

  }

  build() {
    Navigation(this.pageInfos) {
      Scroll() {
        Column({ space: 15 }) {
          Text('Sensor Dashboard').fontSize(24).fontWeight(FontWeight.Bold)
          Text(`accelerometer ${this.accelerometer}`)
          Text(`gyroscope ${this.gyroscope}`)
          Text(`light ${this.light}`)
          Text(`pressure ${this.pressure}`)
          Text(`humidity ${this.humidity}`)
          Text(`temperature ${this.temperature}`)
          Text(`orientation ${this.orientation}`)
          Text(`gravity ${this.gravity}`)
          Text(`heartData ${this.heartData}`)
          Text(`pedometer ${this.pedometer}`)
          Blank().height('5%')
          Button('Vibration Page').onClick(()=>{
            this.pageInfos.pushPathByName('Vibrate', '');
          })
        }.padding(20)
      }.width('100%').height('100%')
    }
    .hideTitleBar(true)
  }
}
