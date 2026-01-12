import { vibrator } from '@kit.SensorServiceKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { resourceManager } from '@kit.LocalizationKit';


@Builder
export function VibrateBuilder() {
  Vibrate();
}

const fileName: string = 'MarchVibrate.json';
const fileNameStomp: string = 'stompClap.json';

@Component
struct Vibrate {
  pageInfos: NavPathStack = new NavPathStack()
  uiContext = this.getUIContext();

  build() {
    NavDestination() {
      Column() {
        Button('Haptic Feedback').onClick(()=>{
          this.hapticFeedBack()
        })
        Blank().height('5%')
        Button('Music Feedback').onClick(()=>{
          this.vibrateFromFile()
        })
        Blank().height('5%')
        Button('Music Feedback Queen').onClick(()=>{
          this.vibrateFromFileQueen()
        })
      }

    }
    .onReady((context: NavDestinationContext) =>{
      this.pageInfos = context.pathStack
    })
    .title('Vibrate')
  }

  hapticFeedBack(){
    try {
      // Check whether 'haptic.notice.success' is supported.
      vibrator.isSupportEffect('haptic.notice.success', (err: BusinessError, state: boolean) => {
        if (err) {
          console.error(`Failed to query effect. Code: ${err.code}, message: ${err.message}`);
          return;
        }
        console.info('Succeed in querying effect');
        if (state) {
          try {
            vibrator.startVibration({
              type: 'preset',
              effectId: 'haptic.notice.success',
              count: 1
            }, {
              usage: 'notification' // The switch control is subject to the selected type.
            }, (error: BusinessError) => {
              if (error) {
                console.error(`Failed to start vibration. Code: ${error.code}, message: ${error.message}`);
                return;
              }
              console.info('Succeed in starting vibration');

            });
          } catch (err) {
            let e: BusinessError = err as BusinessError;
            console.error(`An unexpected error occurred. Code: ${e.code}, message: ${e.message}`);
          }
        }
      })
    } catch (error) {
      let e: BusinessError = error as BusinessError;
      console.error(`An unexpected error occurred. Code: ${e.code}, message: ${e.message}`);
    }
  }

  vibrateFromFile(){
    // Obtain the file descriptor of the vibration configuration file.
    let rawFd: resourceManager.RawFileDescriptor | undefined =
      this.uiContext.getHostContext()?.resourceManager.getRawFdSync(fileName);
    if (rawFd !== undefined) {
      // Start vibration.
      try {
        vibrator.startVibration({
          type: 'file',
          hapticFd: { fd: rawFd.fd, offset: rawFd.offset, length: rawFd.length }
        }, {
          id: 0,
          usage: 'alarm' // The switch control is subject to the selected type.
        }, (error: BusinessError) => {
          if (error) {
            console.error(`Failed to start vibration. Code: ${error.code}, message: ${error.message}`);
            return;
          }
          console.info('Succeed in starting vibration');
        });
      } catch (err) {
        let e: BusinessError = err as BusinessError;
        console.error(`An unexpected error occurred. Code: ${e.code}, message: ${e.message}`);
      }
    }
    // Close the file descriptor of the vibration configuration file.
    this.uiContext.getHostContext()?.resourceManager.closeRawFdSync(fileName);
  }

  vibrateFromFileQueen(){
    // Obtain the file descriptor of the vibration configuration file.
    let rawFd: resourceManager.RawFileDescriptor | undefined =
      this.uiContext.getHostContext()?.resourceManager.getRawFdSync(fileNameStomp);
    if (rawFd !== undefined) {
      // Start vibration.
      try {
        vibrator.startVibration({
          type: 'file',
          hapticFd: { fd: rawFd.fd, offset: rawFd.offset, length: rawFd.length }
        }, {
          id: 0,
          usage: 'alarm' // The switch control is subject to the selected type.
        }, (error: BusinessError) => {
          if (error) {
            console.error(`Failed to start vibration. Code: ${error.code}, message: ${error.message}`);
            return;
          }
          console.info('Succeed in starting vibration');
        });
      } catch (err) {
        let e: BusinessError = err as BusinessError;
        console.error(`An unexpected error occurred. Code: ${e.code}, message: ${e.message}`);
      }
    }
    // Close the file descriptor of the vibration configuration file.
    this.uiContext.getHostContext()?.resourceManager.closeRawFdSync(fileNameStomp);
  }
}