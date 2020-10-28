
import SwiftyJSON

struct PicModel {
    let id: Int
    let author: String
    let width: Int
    let height: Int
    let url: String
    let downloadUrl: String
}

extension PicModel: Decodable {
    enum PicModelCodingKeys: String, CodingKey {
        case id, author, width, height, url, downloadUrl
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PicModelCodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        author = try container.decode(String.self, forKey: .author)
        width = try container.decode(Int.self, forKey: .width)
        height = try container.decode(Int.self, forKey: .height)
        url = try container.decode(String.self, forKey: .url)
        downloadUrl = try container.decode(String.self, forKey: .downloadUrl)
    }
}
