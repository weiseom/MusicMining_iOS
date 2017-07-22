
class VideoVO{
    
    // 하이라이트 비디오 url, 썸네일url, 음악id, 제목, 가수이름, 앨범 이름, 앨범 이미지 url
    var highlight_video_url : String?
    var thumbnail_url : String?
    var music_id : Int?
    var title : String?
    var musician_name : String?
    var album_name : String?
    var album_image_url : String?
    
    // default 생성자
    init(){}
    
    // video 영상 생성자
    init(highlight_video_url :String?, thumbnail_url : String?, music_id: Int?, title : String?, musician_name : String?, album_name : String?, album_image_url : String?) {
        self.highlight_video_url = highlight_video_url
        self.thumbnail_url = thumbnail_url
        self.music_id = music_id
        self.title = title
        self.musician_name = musician_name
        self.album_name = album_name
        self.album_image_url = album_image_url
    }
 
}
