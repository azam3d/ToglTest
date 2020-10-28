
import Moya

enum PicService {
    case getPics
}

extension PicService: TargetType {
    
    var baseURL: URL {
        return URL(string: "https://picsum.photos/v2")!
    }
    
    var path: String {
        switch self {
        case .getPics:
            return "/list"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getPics:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getPics:
            return .requestPlain
        }
    }
    
    var sampleData: Data {
        switch self {
        case .getPics:
            return "Half measures are as bad as nothing at all.".utf8Encoded
        }
    }
    
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
    
}
