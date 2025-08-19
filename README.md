# 🍕ScoopMe(스쿱미)
> 내 주변 식당의 음식을 주문하고, 맛집 정보를 커뮤니티에 공유 및 소통할 수 있는 간편 픽업 서비스
<img width="1000" height="543" alt="image" src="https://github.com/user-attachments/assets/51bada0d-71b9-45e9-957c-4d8dc4d72c36" />

## 앱 소개
- 개발 기간: 25.05.10 ~ 25.06.30 (유지보수 중)
- 구성 인원: iOS 개발(1인), 백엔드(1인), 디자이너(1인)
- 최소 버전: iOS 16.0 +
  
## 기술스택
<img width="448" height="91" alt="image" src="https://github.com/user-attachments/assets/20b3c0ee-d130-413e-a598-28438ff5f171" />

## 기능소개

|   이메일/소셜 로그인 기능   |   내 주변 가게 조회 기능   |    주문 결제 기능   |   주문상태 확인 기능   |
|  :-------------: |  :-------------: |  :-------------: |  :-------------: |
| <img width=200 src="https://github.com/user-attachments/assets/ad6a5811-d8cd-41a4-8ab8-c43915f4deac"> | <img width=200 src="https://github.com/user-attachments/assets/b3a27c3b-fa93-44cc-ba58-ed80a82ffa4f"> | <img width=200 src="https://github.com/user-attachments/assets/ee5d4832-3125-4d1c-9c95-361df8a9aee4"> | <img width=200 src="https://github.com/user-attachments/assets/456415c6-7437-476c-9cb5-381ba35535a5"> |

|   채팅 및 알림 기능   |   커뮤니티 게시글 작성 기능   |    게시글 조회 및 댓글 기능   |
|  :-------------: |  :-------------: |  :-------------: |
| <img width=200 src="https://github.com/user-attachments/assets/8e24ea1b-6c38-4af6-a859-f01dbc1469ea"> | <img width=200 src="https://github.com/user-attachments/assets/2cfb5cf1-4ee1-4cd8-9703-a04a9e9b7a60"> | <img width=200 src="https://github.com/user-attachments/assets/075bccee-8240-46fa-8796-58b56edecdb7"> |

## 앱 구조
- 모듈화 아키텍처와 Repository Pattern을 활용해 전체적인 아키텍처로 사용했습니다
</br>
<img width="853" height="245" alt="image" src="https://github.com/user-attachments/assets/fff73415-cdb8-45cd-a9f7-790ecaf4d48f" />
</br></br>

- SwiftUI에서는 기존 UIKit에서 사용하던 MVVM 패턴이 불필요한 데이터 바인딩 과정을 거치게 한다고 판단해 새로운 구조를 도입해보고자 했습니다</br>
- 비즈니스 로직을 각 View에 주입해 데이터 관리는 해당 View에서만 실행되게끔 하고자 Repository 패턴을 사용했습니다.</br>
- 추후 기능 및 개발 인원의 확장, 단위 테스트 등에 유연한 대처를 하기 위해 모듈화 아키텍쳐를 도입했습니다.

## 상세기능
### 1. 네트워크 모듈 설계
- 재사용성과 확장성을 고려해 타 프로젝트에서도 사용 가능하도록 독립적인 코어 모듈로 설계했습니다.
- 스쿱미의 Login, Payment, Community와 같은 도메인 기능 모듈이 해당 네트워크 모듈을 채택하여 네트워크 기능을 제공받습니다.
- HTTPRequest 구조체에 method chaining 기법을 적용했습니다.</br>
  ㄴ baseURL, path, parameters, jsonBody, headers 등 각 요소를 구성하는 메서드로 SwiftUI의 선언형에 안맞게 구성하였습니다.
- 네트워크 구현체에는 Response 유무에 따라 HTTPResponse와 EmtpyHTTPResponse를 반환값으로 활용해 적절히 사용 가능합니다.

</br>

```swift
extension HTTPRequest: Requestable {
    
    public var successCodes: Set<Int> {...}
    
    public var urlString: String {...}
    
    public func addBaseURL(_ url: String) -> Self {...}
    
    public func addPath(_ path: String) -> Self {...}
    
    public func addParameters(_ params: [String: String?]?) -> Self {...}
    
    public func addJSONBody(_ body: [String: Any]?) -> Self {...}
    
    public func addMultipartData(_ multipartData: MultipartFormData?) -> Self {...}
    
    public func addHeaders(_ headers: [String: String]) -> Self {...}
    
    public func setCachePolicy(_ policy: URLRequest.CachePolicy) -> Self {...}
    
    public func urlRequest() throws -> URLRequest {...}
}
```

```swift
public struct HTTPResponse<T: Decodable>: Responsable {
    public typealias ResponseType = T
    
    public var statusCode: Int
    public var response: ResponseType
    public var headers: [String : String]?
}

public struct EmptyResponse: Decodable {
    public init() { }
}
```

### 2. 채팅 및 PushNotification
- 서버에서 받은 채팅은 Realm을 활용해 로컬DB에 저장합니다.
- SwiftUI에서 사용할 수 있도록 제공되는 Realm의 @ObservedResults 프로퍼티 래퍼를 통해 데이터의 변경사항을 자동으로 감지하여 UI를 구현합니다.
- 상대방과의 채팅방에 진입할 시 로컬에 저장된 가장 최근 메시지 타임스탬프를 기준으로 서버통신하여 새로운 메시지를 받아 realm에 업데이트합니다.
- 소켓통신의 경우, 상대방과의 메시지 누락을 방지하기 위해 서버통신이 이루어지기 전 소켓 연결을 먼저 진행합니다.
- 만약 상대방과의 채팅방에 있는 경우, 해당 상대의 채팅 메시지는 notification이 오지 않도록 합니다. </br>
  ㄴ 다만 상대방과의 채팅방에 있는 상태에서 background로 전환될 시 다시 notification이 수신되도록 분기처리를 진행했습니다.

### 3. 커뮤니티 내 이미지 갯수에 따른 동적 View 구성
<img width="474" height="312" alt="image" src="https://github.com/user-attachments/assets/9b88c547-a056-4a8d-9fd9-73a4f416c538" />
</br></br>

- 커뮤니티 게시글 포스팅 시 최소 0개부터 최대 5개까지의 이미지를 서버에 업로드 할 수 있습니다.</br>
- 이에 따라 커뮤니티 게시글 조회 시, 게시글마다 이미지의 갯수가 달라 UI적으로 분기처리가 불가피했습니다.</br>
- 기본적으로 이미지 1개에 대한 범용적인 UI 컴포넌트를 구성하였으며 나머지는 아래와 같이 구성했습니다.</br>
  ㄴ 1~2개: frame의 height를 고정하고 width는 각 화면의 여백에 따라 크기가 결정되도록 동적 구성</br>
  ㄴ 3개 이상: 별도의 MultiImageCell을 구성하여 디자인 의도에 따라 고정 이미지의 frame을 설정한 후 나머지는 여백에 동적 배치되도록 구성



