//
//  MapView.swift
//  IPCameras
//
//  Created by Lova on 2021/4/4.
//

import Combine
import MapKit
import SwiftUI

// struct MapView_LibraryContent: LibraryContentProvider {
//    static var views: [LibraryItem] {
//        [LibraryItem(MapView())]
//    }
// }

//

struct MapView: UIViewRepresentable {
    @State var model = ViedModel()

    @Binding var mapType: MKMapType
    @Binding var coordinateRegion: MKCoordinateRegion?
    @Binding var userTrackingMode: MKUserTrackingMode
    @Binding var annotations: [MKAnnotation]

    func makeUIView(context: Context) -> MKMapView {
        let map = MKMapView(frame: .zero)

        map.delegate = context.coordinator

        self.setup(map: map)

        return map
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        self.setup(map: uiView)

        uiView.delegate = context.coordinator
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    init(mapType: Binding<MKMapType> = .constant(.standard),
         region: Binding<MKCoordinateRegion?> = .constant(nil),
         isZoomEnabled: Binding<Bool> = .constant(true),
         isScrollEnabled: Binding<Bool> = .constant(true),
         showsUserLocation: Binding<Bool> = .constant(true),
         userTrackingMode: Binding<MKUserTrackingMode> = .constant(.follow),
         annotations: Binding<[MKAnnotation]> = .constant([]),
         selectedAnnotations: Binding<[MKAnnotation]> = .constant([])) {
        //
        self._mapType = mapType
        self._coordinateRegion = region
        self._userTrackingMode = userTrackingMode
        self._annotations = annotations
    }
}

extension MapView {
    private func setup(map: MKMapView) {
        map.mapType = self.mapType

        if let region = self.coordinateRegion {
            map.region = region
        }

        map.userTrackingMode = self.userTrackingMode
        map.showsUserLocation = true
    }
}

// MARK: - For Coordinator MapViewDelegate

private
extension MapView {
    func annotationView(annotation: MKAnnotation) -> MKAnnotationView? {
//        self.annotationsView(annotation)
        nil
    }
}

// struct MapView_Previews: PreviewProvider {
//    class Anno: NSObject, MKAnnotation {
//        var coordinate: CLLocationCoordinate2D
//
//        init(lat: Double, lng: Double) {
//            self.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
//        }
//    }
//
//    @State static var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 25.015, longitude: 121.55),
//                                                  latitudinalMeters: 1000, longitudinalMeters: 1000)
//
//    @State static var trackingMode: MKUserTrackingMode = .follow
//
//    static var annotationView: (MKAnnotation) -> MKAnnotationView? = { _ in
//        nil
//    }
//
//    static var previews: some View {
//        MapView(coordinateRegion: $region,
//                userTrackingMode: $trackingMode,
//                annotations: .constant([Anno(lat: 25.01, lng: 121.55)]),
//                annotationsView: annotationView)
//    }
// }

/* ---------------------------------------------------- */
extension MapView {
    class ViedModel: ObservableObject {}
}

/* ---------------------------------------------------- */

// MARK: - MapViewCoordinator

extension MapView {
    final class Coordinator: NSObject, MKMapViewDelegate {
        let delegate: MapView

        init(_ delegate: MapView) {
            self.delegate = delegate
        }
    }
}

// MARK: - User Location

extension MapView.Coordinator {
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {}
}

// MARK: - Annotation

extension MapView.Coordinator {
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {}

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {}

//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        self.delegate.annotationView(annotation: annotation)
//    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {}

    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {}

    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {}

    //    func mapView(_ mapView: MKMapView, clusterAnnotationForMemberAnnotations memberAnnotations: [MKAnnotation]) -> MKClusterAnnotation {}
}

// MARK: - Overlay

extension MapView.Coordinator {
//    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {}
}

// MARK: - Gestures

extension MapView.Coordinator {
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        self.delegate.coordinateRegion = mapView.region
    }

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {}

    func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
        self.delegate.userTrackingMode = mode
    }
}
