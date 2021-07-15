import UIKit
import Combine

class ViewController: UIViewController, Storyboarded {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    weak var coordinator: MainCoordinator?
    
    @IBAction func moveSearchViewController(_ sender: Any) {
        let searchViewController = SearchViewController.instantiate()
        self.navigationController?.pushViewController(searchViewController, animated: true)
    }
}
