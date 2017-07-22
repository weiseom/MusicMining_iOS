
import Alamofire
import SwiftyJSON
import FacebookCore

class LoginModel : NetworkModel {
    
    static let CODE_FB_CB = 100
    static let CODE_KT_CB = 101
    static let CODE_LOGIN_DEFAULT = 200
    static let CODE_LOGIN_SNS = 201
    static let CODE_REGISTER = 202
    static let CODE_FIND_PW = 203
    
    let sm = SessionModel()
    
    // login 요청
    func postDefaultLogin(user_id : String, passwd : String, case_ : Int) {
        let params = [
            "user_id" : user_id,
            "passwd" : passwd,
            "case" : case_
            ] as [String : Any]
        
        Alamofire.request("\(baseURL)/login", method: .post, parameters: params , encoding: JSONEncoding.default).responseJSON() { res in
            switch res.result {
            case .success :
                self.sm.setID(user_id)
                self.view.networkResult(resultData: "", code: LoginModel.CODE_LOGIN_DEFAULT)
            case .failure(let err) :
                self.view.networkFailed()
            }
        }
    }
    
    // sns로 login 요청
    func postSnsLogin(user_id : String, case_ : Int) {
        let params = [
            "user_id" : user_id,
            "case" : case_
            ] as [String : Any]
        print("로그인중일듯!!!!")
        Alamofire.request("\(baseURL)/login", method: .post, parameters: params , encoding: JSONEncoding.default).responseJSON() { res in
            switch res.result {
            case .success :
                self.view.networkResult(resultData: "", code: LoginModel.CODE_LOGIN_SNS)
            case .failure(let err) :
                self.view.networkFailed()
            }
        }
    }
    
    // Default 회원가입 요청
    func postRegister(object : UserVO) {
        let obj = object
        let params = [
            "user_id" : getStringNonOptional(obj.user_id),
            "passwd" : getStringNonOptional(obj.passwd),
            "name" : getStringNonOptional(obj.name),
            "gender" : getIntNonOptional(obj.gender),
            "birth" : getStringNonOptional(obj.birth),
        ] as [String : Any]
        
        Alamofire.request("\(baseURL)/login/regist", method: .post, parameters: params , encoding: JSONEncoding.default).responseJSON() { res in
            switch res.result {
            case .success :
                self.view.networkResult(resultData: "", code: LoginModel.CODE_REGISTER)
            case .failure(let err) :
                self.view.networkFailed()
            }
        }
    }
    
    func postFindPasswd(user_id : String){
        let params = [
            "user_id" : user_id
            ]
        Alamofire.request("\(baseURL)/login/findpw", method: .post, parameters: params , encoding: JSONEncoding.default).responseJSON() { res in
            switch res.result {
            case .success :
                self.view.networkResult(resultData: "", code: LoginModel.CODE_FIND_PW)
            case .failure(let err) :
                self.view.networkFailed()
            }
        }
    }
    
    
    // 카카오톡 로그인 fetch 시도
    func fetchKakaoProfile() {
        let session: KOSession = KOSession.shared();
        if session.isOpen() {
            session.close()
        }
        session.open(completionHandler: {(error) in
            if error == nil {
                if session.isOpen() {
                    KOSessionTask.meTask{ (userData, error) in
                        if error == nil {
                            let user = (userData as! KOUser)
                            let numID = user.id as Int
                            let id = "\(numID)"
                            
                            self.sm.setID(id)
                            self.postSnsLogin(user_id: id, case_: 0)
                        } else {
                            print("Fetching Failed")
                        }
                    }
                } else {
                    print("error : \(error.debugDescription)")
                    self.view.networkFailed()
                }
            } else {
                print("error : \(error.debugDescription)")
                self.view.networkFailed()
            }
        })
    }
    
    // 페북 로그인
    func fetchFBProfile() {
        let connection = GraphRequestConnection()
        connection.add(UserDataRequest()) {
            (response: HTTPURLResponse?, result: GraphRequestResult<UserDataRequest>) in
            switch result {
            case .success(let graphResponse) :
                print(graphResponse.id)
                self.sm.setID(graphResponse.id)
                self.postSnsLogin(user_id: graphResponse.id, case_: 0)
            case .failed :
                self.view.networkFailed()
            }
        }
        connection.start()
    }
    
    // 페이스북 로그인을 위한 구조체
    struct UserDataRequest: GraphRequestProtocol {
        struct Response: GraphResponseProtocol {
            
            var id = ""
            var email = ""
            var name = ""
            var url = ""
            
            init(rawResponse: Any?) {
                if let data = rawResponse as? [String: Any] {
                    if let id = data["id"] {
                        self.id = id as! String
                    }
                    if let email = data["email"] {
                        self.email = email as! String
                    }
                    if let name = data["name"] {
                        self.name = name as! String
                    }
                    if let url = (data["picture"] as? [String: [String: String]])?["data"]?["url"] {
                        self.url = url
                    }
                }
            }
        }
        public let graphPath = "me"
        public let parameters: [String:Any]? = ["fields" : "id, email, name, picture{url}"]
        public let accessToken: AccessToken? = AccessToken.current
        public let httpMethod: GraphRequestHTTPMethod = .GET
        public let apiVersion: GraphAPIVersion = GraphAPIVersion.defaultVersion
    }
}
