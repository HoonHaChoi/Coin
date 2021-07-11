import UIKit
import Combine

class ViewController: UIViewController, Storyboarded {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func moveSearchViewController(_ sender: Any) {
        let searchViewController = SearchViewController.instantiate()
        self.navigationController?.pushViewController(searchViewController, animated: true)
    }
}
