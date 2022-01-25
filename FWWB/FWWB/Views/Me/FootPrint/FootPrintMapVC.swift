//
//  FootPrintMapVC.swift
//  FWWB
//
//  Created by 叶正茂 on 2019/3/23.
//  Copyright © 2019 fwwb. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class FootPrintMapVC:UIViewController{
    
    var mapNodes : [MyMapNode] = []
    
    @IBOutlet weak var mapview: MKMapView!
    
    
    @IBAction func returnPage(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        readMapNode()
        
        mapNodes.sort { (l1, l2) -> Bool in
            l1.time < l2.time}
        
        mapview.mapType = MKMapType.standard
        mapview.delegate = self
        mapview.showsUserLocation = false
        var cnt : Int = 1
        // 显示标签点
        for epos in mapNodes {
            let outcircle = MKCircle(center: epos.location.coordinate, radius: 5 as CLLocationDistance)
            let incircle = MKCircle(center: epos.location.coordinate, radius: 10 as CLLocationDistance)
            outcircle.title = "out"
            incircle.title = "in"
            self.mapview.addOverlay(incircle)
            self.mapview.addOverlay(outcircle)
            
        }
        // 左上，右下定位点
        var ltp,rbp : CLLocationCoordinate2D
        ltp = mapNodes[0].location.coordinate
        rbp = mapNodes[0].location.coordinate
        
        // 显示路径
        for i in 1 ..< mapNodes.count {
            showRoute(source: mapNodes[i-1].location.coordinate, destination: mapNodes[i].location.coordinate)
            //储存定点
            if(mapNodes[i].location.coordinate.longitude < ltp.longitude){ltp.longitude = mapNodes[i].location.coordinate.longitude}
            if(mapNodes[i].location.coordinate.latitude < ltp.latitude){ltp.latitude = mapNodes[i].location.coordinate.latitude}
            if(mapNodes[i].location.coordinate.longitude > rbp.longitude){rbp.longitude = mapNodes[i].location.coordinate.longitude}
            if(mapNodes[i].location.coordinate.latitude > rbp.latitude){rbp.latitude = mapNodes[i].location.coordinate.latitude}
            
        }
        // 显示范围
        let center = CLLocationCoordinate2D(latitude: (ltp.latitude+rbp.latitude)/2.0, longitude: (ltp.longitude+rbp.longitude)/2.0)
        // 距离计算
        let topRight = CLLocation(latitude: ltp.latitude, longitude: rbp.longitude)
        let topLeft = CLLocation(latitude: ltp.latitude, longitude: ltp.longitude)
        let bottmRight = CLLocation(latitude: rbp.latitude, longitude: rbp.longitude)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: topLeft.distance(from: bottmRight) + 1000, longitudinalMeters: topRight.distance(from: topLeft) + 1000)
        self.mapview.setRegion(region, animated: true)
    }
    
    private func readMapNode(){
        //
        mapNodes.append(MyMapNode(location: CLLocation(latitude: 30.6570, longitude: 104.0650), time: Date().addingTimeInterval(10)))
        mapNodes.append(MyMapNode(location: CLLocation(latitude: 30.65552, longitude: 104.077758), time: Date().addingTimeInterval(20)))
        mapNodes.append(MyMapNode(location: CLLocation(latitude: 30.654845, longitude: 104.081412), time: Date().addingTimeInterval(30)))
    }
    
    // 计算并显示两点间的路线
    private func showRoute(source:CLLocationCoordinate2D,destination:CLLocationCoordinate2D){
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: source))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
        request.transportType = .automobile
        let directions = MKDirections(request: request)
        directions.calculate { (response, error) in
            guard let directionResponse = response else{return}
            for route in directionResponse.routes{
                self.mapview.addOverlay(route.polyline)
            }
        }
    }
    
}


// MapView代理
extension FootPrintMapVC:MKMapViewDelegate{
    // renderer
    public func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
            renderer.strokeColor = UIColor.orange
            renderer.lineWidth = 1.0
            return renderer
        }
        print(overlay.title!)
        let circle = MKCircleRenderer(overlay: overlay)
        if overlay.title == "in"{
            circle.strokeColor = UIColor.blue
        }
        if overlay.title == "out"{
            circle.strokeColor = UIColor.white
        }
        //circle.strokeColor = UIColor.orange
        return circle
    }
}
