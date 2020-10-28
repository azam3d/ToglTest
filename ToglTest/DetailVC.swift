
import Alamofire
import Kingfisher
import Moya
import UIKit
import SwiftyJSON

class DetailVC: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
        }
    }
    @IBOutlet weak var tabUnderlineCenter: NSLayoutConstraint!
    private var pics = [PicModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
    }
    
    @objc func fetchData() {
        let provider = MoyaProvider<PicService>()
        provider.request(.getPics) { [weak self] result in
            switch result {
            case let .success(moyaResponse):
                let data = moyaResponse.data
                
                let json = JSON(data)
//                print(json)
                
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
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var prevPage = 0
        let pageWidth = scrollView.frame.width
        let fractionalPage = scrollView.contentOffset.x / pageWidth
        let page = lround(Double(fractionalPage))
        
        if prevPage != page {
            prevPage = page
        }
        if page == 1 {
            tabUnderlineCenter.constant = 30
        } else {
            tabUnderlineCenter.constant = -30
        }
    }
    
}

extension DetailVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tabCell", for: indexPath) as? TabCell else {
            fatalError()
        }
        cell.pics = pics
        return cell
    }
    
}

extension DetailVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}
