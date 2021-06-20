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
    //if true, already have all points needed to draw polyline
    var done : Bool

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
                renderer.strokeColor = UIColor.systemPurple
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
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = !done
        var center = CLLocationCoordinate2D()
        if !done {
            mapView.userTrackingMode = .follow
        } else {
            center = lineCoordinates.first ?? CLLocationCoordinate2D()
        }
        let region = MKCoordinateRegion(
            center: center, latitudinalMeters: 200, longitudinalMeters: 200)
        mapView.region = region
        mapView.delegate = context.coordinator
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        let polyline = MKPolyline(coordinates: lineCoordinates, count: lineCoordinates.count)
        uiView.addOverlay(polyline)
    }
}
