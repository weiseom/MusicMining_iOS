class ComposerVO{
    
    var musician_name : String?
    var musician_id : Int?
    var role_num : Int?
    
    init(){}
    
    init(role_num : Int?, musician_id : Int?, musician_name : String?) {
        self.role_num = role_num
        self.musician_id = musician_id
        self.musician_name = musician_name
    }    
}
