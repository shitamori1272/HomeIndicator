//
//  SpotRegisterView.swift
//  HomeIndicator WatchKit Extension
//
//  Created by 下森周平 on 2021/06/06.
//  Copyright © 2021 Shitamori. All rights reserved.
//

import SwiftUI
import MapKit
import Foundation

struct SpotRegisterView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var newName: String = ""
    @State private var mapCameraPosition: MapCameraPosition = .automatic
    
    @StateObject var viewModel: SpotRegisiterViewModel = SpotRegisiterViewModel()
    
    var body: some View {
        VStack {
            ZStack {
                Map(position: $mapCameraPosition) {
                    UserAnnotation()
                }
                .onMapCameraChange { context in
                    viewModel.mapRegion = context.region
                }
                Plus()
                    .stroke(lineWidth: 3)
                    .frame(width: 20, height: 20, alignment: .center)
            }
            TextField(localized("spot_register.input_name_placeholder", "登録名の入力"), text: $newName)
            Button(localized("spot_register.register_current_spot", "この地点を登録する")) {
                viewModel.registerButtonTapped(name: newName, coordinates: viewModel.mapRegion.center)
                dismiss()
            }.disabled(newName.isEmpty)
        }
        .onAppear {
            mapCameraPosition = .region(viewModel.mapRegion)
        }
    }

    private func localized(_ key: String, _ fallback: String) -> String {
        NSLocalizedString(key, tableName: nil, bundle: .main, value: fallback, comment: "")
    }
}

private struct Plus: Shape {
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
            path.move(to: CGPoint(x: rect.minX, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        }
    }
}


struct SpotRegisterView_Previews: PreviewProvider {
    static var previews: some View {
        SpotRegisterView()
    }
}
