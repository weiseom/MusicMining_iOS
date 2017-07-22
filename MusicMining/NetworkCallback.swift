
protocol NetworkCallback {
    func networkResult(resultData : Any, code : Int)
    func networkFailed()
}
