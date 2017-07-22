

class NetworkModel {

    internal let baseURL = ""
    
    var view : NetworkCallback
    init(_ view : NetworkCallback) {
        self.view = view
    }
    
    func getStringNonOptional(_ value : String?) -> String {
        if let value_ = value{
            return value_
        } else {
            return ""
        }
    }
    
    func getIntNonOptional(_ value : Int? ) -> Int {
        if let value_ = value {
            return value_
        }else {
            return 0
        }
    }
}
