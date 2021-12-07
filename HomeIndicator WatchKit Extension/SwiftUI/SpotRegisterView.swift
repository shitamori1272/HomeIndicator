//
//  SpotRegisterView.swift
//  HomeIndicator WatchKit Extension
//
//  Created by 下森周平 on 2021/06/06.
//  Copyright © 2021 Shitamori. All rights reserved.
//

import SwiftUI
import MapKit

struct SpotRegisterView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @State var mapRegion: MKCoordinateRegion
    
    @State private var newName: String = ""
    
    @ObservedObject var viewModel = SpotRegisiterViewModel()
    
    var body: some View {
        VStack {
            ZStack {
                Map(coordinateRegion: $mapRegion)
                Plus()
                    .stroke(lineWidth: 3)
                    .frame(width: 20, height: 20, alignment: .center)
            }
            TextField("施設名を入力してください", text: $newName)
            Button("この地点を登録する") {
                viewModel.registerButtonTapped(name: newName, coordinates: mapRegion.center)
                presentationMode.wrappedValue.dismiss()
            }.disabled(newName.isEmpty)
        }
        .onAppear {
        }
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
        let mapRegion = MKCoordinateRegion(center: .init(), span: .init())
        SpotRegisterView(mapRegion: mapRegion)
    }
}
