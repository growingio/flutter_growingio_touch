# flutter_growingio_touch

The Flutter plugin for GrowingIO Touch.

## flutter 插件获取安装

在flutter项目中，根据 [dart pub 安装文档](https://pub.dev/packages/flutter_growingio_touch#-installing-tab-) 进行插件安装

## 插件的初始化
由于插件需要获取应用的生命周期，为了数据的准确性，SDK 需要单独在原生项目中进行初始化；同时更好的兼容“flutter + native”开发模式

### iOS 的初始化
  
  在原生项目应用中首次需要的地方导入头文件
  ```objc
  #import <Growing.h>
  #import <GrowingTouchCoreKit/GrowingTouchCoreKit.h>
  ```
  进行SDK的初始化（一般在`AppDelegate`中的`application:didFinishLaunchingWithOptions:`方法中），仅需要初始化一次即可
  
  ```objc
  [Growing startWithAccountId:@"GrowingIO官网申请的项目ID"];
  [GrowingTouch start];
  [GrowingTouch setDebugEnable:YES];
  [GrowingTouch setEventPopupEnable:YES];
  ```
特别需要注意的是：请确保 `[GrowingTouch start]`;在 `[Growing startWithAccountId:@"GrowingIO官网申请的项目ID"]`; 之后调用

### Android 的初始化
  
  在原生项目应用中首次需要的地方导入头文件
  
  ```java
  import com.growingio.android.sdk.collection.GrowingIO;
  import com.growingio.android.sdk.gtouch.GrowingTouch;
  import com.growingio.android.sdk.gtouch.config.GTouchConfig;
  ```
  进行SDK的初始化（一般在`MyFlutterApplication`中的`onCreate`方法中），仅需要初始化一次即可
  
  ```java
     
  GrowingIO.startWithConfiguration(this, new Configuration()
                .setTestMode(false)
                .setDebugMode(false));

  GrowingTouch.startWithConfig(this, new GTouchConfig()
                .setEventPopupShowTimeout(5000)
                .setEventPopupEnable(false)
                .setUploadExceptionEnable(false)
                .setDebugEnable(BuildConfig.DEBUG));
  ```
  特别需要注意的是：请确保 `GrowingTouch.startWithConfig` 在 `GrowingIO.startWithConfiguration` 之后调用

## package文件引用

```java
 
 import 'package:flutter_growingio_touch/flutter_growingio_touch.dart';

```

## flutter API 使用说明

1 设置弹窗开关
1.1 `GrowingTouch.eventPopupEnable = enable`

设置弹窗的开关，可以在初始化的时候选择关闭弹窗功能，这样弹窗SDK就不会在APP的logo页和闪屏页显示弹窗，然后在APP的内容页打开时再打开弹窗开关。

1.2 参数说明

| 参数名 | 参数类型| 必填 | 默认值 | 说明 |
--------|--------|-----|-------|------
| enable|  bool | 是   | true  |开关触达弹窗功能，true开启，false关闭

1.3 代码示例

```java 
GrowingTouch.eventPopupEnable = true;
```

2 获取弹窗开关状态

2.1 `GrowingTouch.eventPopupEnable;`获取弹窗开关状态

2.2 代码示例

```java
bool state = await GrowingTouch.eventPopupEnable;
```

3 打开弹窗并触发“打开App”事件

3.1 `GrowingTouch.enableEventPopupAndGenerateAppOpenEvent();`

打开弹窗并触发"打开APP"事件。

应用场景时：担心弹窗SDK在APP启动的Logo页或者闪屏页显示弹窗，这时可以选择在初始化时关闭弹窗开关，然后在APP的内容页打开时再打开弹窗开关。

如果只是单纯调用`GrowingTouch.setEventPopupEnable(true);`只会打开弹窗开关，并不会触发"打开APP"的弹窗事件。调用该API则会打开弹窗的同时触发一个"打开APP"的弹窗事件。（"打开APP" 对应的是触发时机选择“打开App时”）。

3.2 代码示例

```java
bool state = await GrowingTouch.eventPopupEnable;
if (!state) {
  GrowingTouch.enableEventPopupAndGenerateAppOpenEvent();
}
```

4 弹窗是否正在显示

4.1 `GrowingTouch.isEventPopupShowing()`弹窗是否正在显示

4.2 代码示例

```java
bool showing = await GrowingTouch.isEventPopupShowing();
```

5 弹窗事件的监听

5.1 `GrowingTouch.setEventPopupListener(listener)`

通过监听获取事件和参数，您可以根据事件和参数以及您的业务场景执行相关的交互。

5.2 代码示例

```java

GrowingTouch.setEventPopupListener({
    /**
     * 弹窗显示成功
     *
     * @param eventId   埋点事件名称
     * @param eventType 事件类型，system(弹窗SDK内置的事件)或custom(用户自定义的埋点事件)
     */
    onLoadSuccess: (eventId, eventType) => {
      console.log('FlutterApp onLoadSuccess: eventId = ' + eventId + ', eventType = ' + eventType);
    },

    /**
     * 弹窗加载失败
     *
     * @param eventId     埋点事件名称
     * @param eventType   事件类型，system(弹窗SDK内置的事件)或custom(用户自定义的埋点事件)
     * @param errorCode   错误码
     * @param description 错误描述
     */
    onLoadFailed: (eventId, eventType, errorCode, description) => {
      console.log('FlutterApp onLoadFailed: eventId = ' + eventId + ', eventType = ' + eventType + ', errorCode = ' + errorCode + ', description = ' + description);
    },

    /**
     * 用户点击了弹窗的有效内容。弹窗SDK现在只提供跳转APP内部界面和H5界面两种处理方式。
     * 您可以在这里接管跳转事件，处理需要跳转的url。您也可以自定义Url协议，实现更多业务和交互功能。
     *
     * @param eventId   埋点事件名称
     * @param eventType 事件类型，system(弹窗SDK内置的事件)或custom(用户自定义的埋点事件)
     * @param openUrl   跳转的url
     */
    onClicked: (eventId, eventType, openUrl) => {
      console.log('FlutterApp onClicked: eventId = ' + eventId + ', eventType = ' + eventType + ', openUrl = ' + openUrl);
    },

    /**
     * 用户关闭了弹窗
     *
     * @param eventId   埋点事件名称
     * @param eventType 事件类型，system(弹窗SDK内置的事件)或custom(用户自定义的埋点事件)
     */
    onCancel: (eventId, eventType) => {
      console.log('FlutterApp onCancel: eventId = ' + eventId + ', eventType = ' + eventType);
    },

    /**
     * 弹窗显示超时
     *
     * @param eventId   埋点事件名称
     * @param eventType 事件类型，system(弹窗SDK内置的事件)或custom(用户自定义的埋点事件)
     */
    onTimeout: (eventId, eventType) => {
      console.log('FlutterApp onTimeout: eventId = ' + eventId + ', eventType = ' + eventType);
    },
  });

```

## 注意事项

iOS 弹窗的点击跳转依赖原生的导航控制器，因此若需要点击弹窗事件进行跳转，可通过如下2种方式实现

1. 在弹窗事件监听者的方法中接管跳转事件，在flutter中实现页面跳转

2. 在原生项目中添加导航控制器，确保弹窗点击跳转时能获取到原生的导航控制器

3. 其他具体使用请参考此仓库中的demo
