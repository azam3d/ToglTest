
import Moya
import UIKit
import SwiftyJSON

class TabCell: UICollectionViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
        }
    }
    var pics = [PicModel]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
                        
        fetchData()
    }
    
    @objc func fetchData() {
        let provider = MoyaProvider<PicService>()
        provider.request(.getPics) { [weak self] result in
            switch result {
            case let .success(moyaResponse):
                let data = moyaResponse.data
                
                let json = JSON(data)
                print(json)
                
                print("Fetch Home Data")
                
                self?.pics = [PicModel]()
                
                for (_, subJson): (String, JSON) in json {
                    let id = subJson["id"].intValue
                    let author = subJson["author"].stringValue
                    let width = subJson["width"].intValue
                    let height = subJson["height"].intValue
                    let url = subJson["url"].stringValue
                    let downloadUrl = subJson["download_url"].stringValue
                    
                    let pic = PicModel(id: id, author: author, width: width, height: height, url: url, downloadUrl: downloadUrl)
                    self?.pics.append(pic)
                }
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            case let .failure(error):
                DispatchQueue.main.async {
                    print(error.errorDescription!)
                }
            }
        }
    }
    
}

extension TabCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "picCell", for: indexPath) as? PicCell else {
            fatalError()
        }
        if let url = URL(string: pics[indexPath.row].downloadUrl) {
            cell.pic.kf.setImage(with: url)
        }
        return cell
    }
    
}

extension TabCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 3 - 20, height: collectionView.frame.width / 3 - 20)
    }
}

class PicCell: UICollectionViewCell {
    @IBOutlet weak var pic: UIImageView!
}
