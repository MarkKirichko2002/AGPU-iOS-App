//
//  NetworkManager.swift
//  AGPU
//
//  Created by Марк Киричко on 25.04.2025.
//

import Network

final class NetworkManager {
    
    let monitor = NWPathMonitor()
    
    var internetConnectionHandler: ((NWPath)->Void)?
    
    func startCheckInternet() {
        let queue = DispatchQueue(label: "Monitor")
        monitor.pathUpdateHandler = { path in
            self.internetConnectionHandler?(path)
        }
        monitor.start(queue: queue)
    }
    
    func registerInternetConnectionHandler(block: @escaping(NWPath)->Void) {
        self.internetConnectionHandler = block
    }
}
