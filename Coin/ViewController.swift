import UIKit
import Combine

class ViewController: UIViewController {

    private var vm = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vm.fetchSearchCoins()
    }
}

