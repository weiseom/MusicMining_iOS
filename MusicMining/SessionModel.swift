
class SessionModel {
    
    let userDefault = UserDefaults.standard
    private let idKey = "userId"
    
    func setSessionData(){
    }
    
    func setID(_ id : String){
        self.userDefault.set(id, forKey: idKey)
        self.userDefault.synchronize()
    }
    
    func getID() -> String{
        if let id = userDefault.string(forKey: idKey){
            return id
        }
        return ""
    }
}
