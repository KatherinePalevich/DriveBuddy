//
//  MapView.swift
//  DriveBuddy
//
//  Created by Katherine Palevich on 5/29/21.
//


//code taken from https://codakuma.com/the-line-is-a-dot-to-you/
import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    
    @Binding var lineCoordinates: [CLLocationCoordinate2D]

    var currentLocation: CLLocationCoordinate2D?
    var withAnnotation: MKPointAnnotation?
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        
        init(_ parent: MapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let routePolyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: routePolyline)
                renderer.strokeColor = UIColor.systemBlue
                renderer.lineWidth = 5
                return renderer
            }
            return MKOverlayRenderer()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        let region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(), latitudinalMeters: 200, longitudinalMeters: 200)
        mapView.setRegion(region, animated: false)
        mapView.region = region
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        let polyline = MKPolyline(coordinates: lineCoordinates, count: lineCoordinates.count)
        uiView.addOverlay(polyline)

//        if let currentLocation = self.currentLocation {
//            if let annotation = self.withAnnotation {
//                uiView.removeAnnotation(annotation)
//            }
//            uiView.showsUserLocation = true
//            let region = MKCoordinateRegion(center: currentLocation, latitudinalMeters: 800, longitudinalMeters: 800)
//            uiView.setRegion(region, animated: true)
//        } else if let annotation = self.withAnnotation {
//            uiView.removeAnnotations(uiView.annotations)
//            uiView.addAnnotation(annotation)
//        }
    }
    
    

}
