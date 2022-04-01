# Upbit3TicRule

# **💡 Background**

### **목적 및 계기**

- 업비트 Open API를 이용하여 떨어짐을 실시간으로 감시하고 알림을 보내고자 만들게됨
- FCM을 사용해보고, Swift에서 네트워크 통신을 이용해보기 위해 개발하게됨

---

# **🛠 Development**

- Back-end

OracleCloud, Java(SpringBoot)

- Front-end

Swift

파일구조

- DummyJson:
    - Network통신을 하기 전에 사용할 JSON data을 관리하는 폴더
- Models
    - realm에 저장될 데이터를 관리하고, struct 타입의 파일들을 관리함
- View
    - Controller에서 사용되는 TableView의 Cell, CollectionView의 Cell, CustomView 등 View와 관련된 파일을 관리합니다.
- Service
    - Network통신과 관련된 파일들을 관리함.
- Controller
    - realm data를 View와 연결하는 부분과 클릭, swipe등 이벤트를 담당함.
- Backup
    - 임시 백업폴더 파일
- Utils
    - 날짜, Timer, IAP, AppStoreReview, Alert 등 Util과 관련된 파일을 담당합니다.

---

## **Tech Stack**

- Back-end
- Front-end
    - Swift
    - Realm

## **Features & Screens**

### 시세**, 알람설정 페이지**

![메인 알람 설정](https://user-images.githubusercontent.com/45157159/161238369-892e07ac-3831-41d3-8fba-e72d3151cab6.png)

- SpringBoot에서 업비트 OpenAPI 가공해서 전달하였습니다.
- 코인 정보를 FCM의 Topic을 이용하여 등록하였습니다.
- 하락폭의 정보를 볼 수 있습니다.
- 알람을 받을 코인들을 설정 할 수 있습니다.

### 알람 이력, 자산 목록

![알람 이력](https://user-images.githubusercontent.com/45157159/161238407-b121702a-8c9e-4644-9b5e-02fd0caab7ed.png)

- Upbit의 AccessKey와 SecretKey을 입력하면 자산 정보를 볼 수 있습니다.
- 전달 받은 알람들을 볼 수 있습니다.
- 알람이력의 경우 NotificationCenter에서 알람목록을 캐치하여 Realm에 저장하였습니다.

---

# **🛫 Result**

- 협업을 처음으로 진행한 프로젝트인데, 전달받은 json 데이터를 정확하게 요청하는게 어려웠다.
- 상대방에게 생각한 로직을 이해시키기가 어려웠고, 흐름도까지 그려서 제공을 했다.
- 업비트 Open API와 통신하기 위해서 Enum을 사용했는데 URLSession을 이용했는데, Enum으로 어떤 API를 요청 할 수 있음을 알 수 있었다.

 

- Enum과 API 요청 주소 예시

```swift
import Foundation

enum NetworkAPI {
    case market(MarketAPI)
}

extension NetworkAPI {
    var baseURL: String {
        return "http://152.67.217.201:8080"
    }
    
    var path: String {
        switch self {
        case .market(let api): return api.path
        }
    }
}

enum MarketAPI {
    case allMarkets
}

extension MarketAPI {
    var path: String {
        switch self {
        case .allMarkets:
            return "/market/all"
        }
    }
}
```
