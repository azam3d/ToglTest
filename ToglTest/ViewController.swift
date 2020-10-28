
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var table: UITableView! {
        didSet {
            table.dataSource = self
            table.delegate = self
        }
    }
    @IBOutlet weak var yellowButton: UIButton!
    @IBOutlet weak var yellowButtonTop: NSLayoutConstraint!
    @IBOutlet weak var homeBackgroundHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }


}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = table.contentOffset.y
//        print(yOffset)

        if yOffset < 0 {
            homeBackgroundHeight.constant = 350 - yOffset
        }
        yellowButtonTop.constant = 266 - yOffset
        if yOffset > 256 {
            yellowButtonTop.constant = 10
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        if indexPath.row == 0 {
            cell = table.dequeueReusableCell(withIdentifier: "transparentCell", for: indexPath)
        } else {
            cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        }
        return cell
    }
    
    
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 226 + 50
        }
        return 160
    }
}
