基于 react-native-orientation 修改和新增

使用方法：

npm install react-native-orientation-mk --save
react-native link react-native-orientation-mk
ios需要 pod install

自动link 不成功需要手动link

ios :
1.设备方向需要勾选 Portait,Landscape Left,Landscape Right

2.需要将rootVC 替换成 OrientationViewController

#import "OrientationViewController.h"

...
OrientationViewController *rootViewController = [[OrientationViewController alloc]initWithOrientation:UIInterfaceOrientationMaskPortrait];
rootViewController.view = rootView;
self.window.rootViewController = rootViewController;
...




js 中  常用方法，其他可去react-native-orientation npm官网查看

import Orientation from 'react-native-orientation-hfjy'

获取方向
       Orientation.getOrientation((res) => {})

设置横竖屏
    Orientation.lockToPortrait()
    Orientation.lockToLandscape()


监听转屏
    Orientation.addOrientationListener(this._changeOrientation)
    Orientation.removeOrientationListener(this._changeOrientation)


  _changeOrientation = (res) => {
    this.setState({ orientation: res })
  }



解锁屏幕
Orientation.unlockAllOrientations()

