//
//  AGPULocationDetailViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 17.07.2023.
//

import UIKit
import MapKit

final class AGPULocationDetailViewController: UIViewController {
    
    var annotation: MKAnnotation!
    
    @IBOutlet var LocationName: UILabel!
    @IBOutlet var LocationDetail: UILabel!
    
    // MARK: - Init
    init(
        annotation: MKAnnotation
    ) {
        self.annotation = annotation
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LocationName.text = annotation.title!
        LocationDetail.text = annotation.subtitle!
    }
    
    @IBAction func GoToMap() {
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: annotation.coordinate, addressDictionary: nil))
        mapItem.name = annotation.title ?? ""
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
}
