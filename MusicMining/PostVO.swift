
class PostVO{
    
    var id : Int?
    var title : String?
    var content : String?
    var imgUrl : String?
    
    init(){}
    
    // 썸네일을 위한 초기화 구문
    init(id : Int?, title : String?, content : String?){
        self.id = id
        self.title = title
        self.content = content
    }
    
    // 게시물을 다루기 위한 초기화 구문.
    init(id : Int?, title : String?, content : String? , imgUrl : String?){
        self.id = id
        self.title = title
        self.content = content
        self.imgUrl = imgUrl
    }
}
