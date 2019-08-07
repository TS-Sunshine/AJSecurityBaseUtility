# AJSecurityBaseUtility

### 对iOS生物识别API的封装。可以直接使用



### 用时可以使用 :

```
pod 'AJSecurityBaseUtility'
```





#### 采用单例的方法封装 。。。。。具体实现逻辑请看源码吧！

##### 一. 调用方法

```objectivec
- (void)evaluatePolicy:(NSString *)localizedReasonfallbackTitle:(NSString *)title

SuccesResult:(void(^)(void))backSucces

FailureResult:(TouchIdValidationFailureBack)backFailure;
```

此方法直接调用系统的生物识别模块，前提是用户已经在系统中打开，否则调用失败。



##### 二. 对手机支持的生物识别进行一系列判断的方法封装

- 是否支持TouchID或者FaceID

  ```objectivec
  - (BOOL)isCanUseBiometrics;
  ```

- 是否是FaceID

  ```objectivec
  - (BOOL)isFaceID;
  ```

- 生物识别开关是否打开

  ```objectivec
  -(BOOL)isBiometricsOpened;
  ```

- 是否开启生物识别

  ```objectivec
  - (void)biometricsWith:(BOOL)open;
  ```

- 返回设备上生物识别的错误状态

  ```objectivec
  - (LAError)deviceBiometricsState;
  ```

- 判断指纹库是否变化

  ```objectivec
  - (BOOL)biometricsLibraryDidChanged NS_AVAILABLE(10_11, 9_0);
  ```

  

  #### 

  

  

  
   
