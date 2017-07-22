
class UserVO{

    var user_id : String?
    var passwd : String?
    var name : String?
    var gender : Int?
    var birth : String?
    
    init() {
    }
    
    init(user_id : String?, passwd : String?, name : String?, gender : Int?, birth : String?) {
        self.user_id = user_id
        self.passwd = passwd
        self.name = name
        self.gender = gender
        self.birth = birth
    }
    
}
