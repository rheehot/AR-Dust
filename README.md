# ARDust  
> ARKit를 이용해 시각화 한 미세 먼지 정보 앱   

<img width="400" src="https://user-images.githubusercontent.com/33486820/62941482-18204400-be11-11e9-8fd7-26ad1ba8a91c.gif"> 


<img width="400" src="https://user-images.githubusercontent.com/33486820/62941535-3ab25d00-be11-11e9-81a8-05b72e49adf5.gif"> 

</br>

## 앱 소개

<img width="977" alt="image" src="https://user-images.githubusercontent.com/33486820/62939498-697a0480-be0c-11e9-957a-1e2d6dd8ec1f.png">  


<img width="977" alt="image" src="https://user-images.githubusercontent.com/33486820/62939286-e193fa80-be0b-11e9-8f4f-14a84c3ef4f5.png">


## 배경  

<img width="977" alt="image" src="https://user-images.githubusercontent.com/33486820/62939091-66cadf80-be0b-11e9-928b-c5a7f816adba.png">  

</br>

## 사용한 기술 & 아키텍쳐

<img width="977" alt="image" src="https://user-images.githubusercontent.com/33486820/62939154-8eba4300-be0b-11e9-996f-d8e65f70156e.png">  

<img width="977" alt="스크린샷 2019-08-13 오후 8 54 18" src="https://user-images.githubusercontent.com/33486820/63030248-fbf1d500-beec-11e9-9f6d-ec726e0d9dd7.png">

- Tool & Language : `Xcode`, `Swift4`
- iOS Framework : `CoreData`, `CoreLocation`, `ARKit`, `SceneKit(3D)`, `SpriteKit(2D)`
- 외부라이브러리 : [Alamofire](https://github.com/Alamofire/Alamofire), [Hero Transition](https://github.com/HeroTransitions/Hero)(뷰 전환애니메이션)

</br>

## 실시간 미세먼지 정보 기능  

<img width="977" alt="image" src="https://user-images.githubusercontent.com/33486820/62940103-c6c28580-be0d-11e9-9ae8-deb0c3e5d08a.png">



- 농도범위 좋음(0 ~ 15)
- 농도범위 보통(16 ~ 35)
- 농도범위 나쁨(36 ~ 75)
- 농도범위 매우나쁨(76 ~ )
  
출처: [에어코리아](http://www.airkorea.or.kr/web)  

</br>

## 미세먼지 시각화 기능    

<img width="977" alt="image" src="https://user-images.githubusercontent.com/33486820/62941847-fbd0d700-be11-11e9-9b3f-b13fb4270298.png">  

<img width="977" alt="image" src="https://user-images.githubusercontent.com/33486820/62941881-1440f180-be12-11e9-8f7d-77ebf3e8d972.png">

</br>

## TODO: 추가 기능  

<img width="977" alt="image" src="https://user-images.githubusercontent.com/33486820/62941092-2de13980-be10-11e9-9636-ca4ee398d289.png">

- 기상청 API를 활용하여 날씨 기능도 추가 할 수 있도록 한다.
- Firebase Cloud Message(FCM)과 연동하여 미세먼지 경보를 알릴 수 있도록 한다
- 다른 SNS와 연동하여 공유기능을 확대한다
