
class SongVO{
    
    // 음악id, 제목, 가수이름, 피처링가수이름, 음악 url, 앨범 이미지 url
    var music_id : Int?
    var title : String?
    var musician_name : String?
    var featuring_musician_name : String?
    var music_url : String?
    var album_image_url : String?
    
    // 앨범 이름, 가사, 장르, 작곡가, 작사가, 그룹이름, 좋아요 수
    var album_name : String?
    var lyrics : String?
    var genre : String?
    var role_num : Int?
    var group_name : String?
    var like : Int?
    var musician_id : Int?
    var cvo : [ComposerVO]?
    //var composerVO : ComposerVO?
    
    
    // default 생성자
    init(){}
    
    // player ( with music url )
    init(music_url :String?, music_id: Int?, title : String?, musician_name : String?, featuring_musician_name : String?, album_image_url : String?) {
        self.music_id = music_id
        self.title = title
        self.musician_name = musician_name
        self.featuring_musician_name = featuring_musician_name
        self.music_url = music_url
        self.album_image_url = album_image_url
    }
    
    // playlist ( no music url )
    init(music_id: Int?, title : String?, musician_name : String?, featuring_musician_name : String?, album_image_url : String?){
        self.music_id = music_id
        self.title = title
        self.musician_name = musician_name
        self.featuring_musician_name = featuring_musician_name
        self.album_image_url = album_image_url
    }
    
    // DetailSongInfo
    init(like : Int?, music_id : Int?, title : String?, music_url :String?, album_image_url : String?, album_name : String?, lyrics : String?, genre : String?, cvo : [ComposerVO]?){
        self.music_id = music_id
        self.title = title
        self.music_url = music_url
        self.album_image_url = album_image_url
        self.album_name = album_name
        self.lyrics = lyrics
        self.genre = genre
        self.like = like
        self.cvo = cvo
    }
}
