import UIKit
import Combine

class ViewController: UIViewController, Storyboarded {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    var coordinator: MainCoordinator?
    
    @IBAction func moveSearchViewController(_ sender: Any) {
        coordinator?.showSearchViewController()
    }
}
