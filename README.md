# flutter_growingio_touch

The Flutter plugin for GrowingIO Touch.

## flutter 插件获取安装

在flutter项目中，根据 [dart pub 安装文档](https://pub.dev/packages/flutter_growingio_touch#-installing-tab-) 进行插件安装

## 插件的初始化
由于插件需要获取应用的生命周期，为了数据的准确性，SDK 需要单独在原生项目中进行初始化；同时更好的兼容“flutter + native”开发模式

### iOS 的初始化
  
  ```objc
  [Growing startWithAccountId:@"GrowingIO官网申请的项目ID"];
  [GrowingTouch start];
  [GrowingTouch setDebugEnable:YES];
  [GrowingTouch setEventPopupEnable:YES];
  ```
特别需要注意的是：请确保 ==[GrowingTouch start];==在== [Growing startWithAccountId:@"GrowingIO官网申请的项目ID"]; == 之后调用

## API 使用说明

