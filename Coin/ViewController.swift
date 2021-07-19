import UIKit
import Combine
import SocketIO

class ViewController: UIViewController, Storyboarded {
  
    let manager =  SocketManager(socketURL: URL(string: "http://34.64.77.122:8080/socket")!,
                                 config: [.log(true),
                                          .forceWebsockets(true),
                                          .path("/socket")])
    
    lazy var socket:SocketIOClient = manager.defaultSocket
    
    override func viewDidLoad() {
        super.viewDidLoad()
        connectSocket()
    }
    
    var coordinator: MainCoordinator?
    
    @IBAction func moveSearchViewController(_ sender: Any) {
        coordinator?.showSearchViewController()
    }
    
    func connectSocket() {
        socket.on("message") { data, ack in
            print("message",data,ack)
        }
    
        socket.on("tickers") { data, ack in
            print("tickers",data,ack)
        }
        
        socket.connect()
    }
}
