//
//  InfoPanelView.swift
//  Pinch
//
//  Created by Petar Iliev on 6/20/23.
//

import SwiftUI

struct InfoPanelView: View {
    
    // MARK: - Properties
    var scale: CGFloat
    var offset: CGSize
    
    // MARK: - State
    @State private var panelVisible: Bool = false
    
    var body: some View {
        HStack {
            
            // MARK: - Symbol
            Image(systemName: "circle.circle")
                .symbolRenderingMode(.hierarchical)
                .resizable()
                .frame(width: 30, height: 30.0)
                .onLongPressGesture(minimumDuration: 1) {
                    withAnimation(.easeOut) {
                        panelVisible.toggle()
                    }
                }
            
            Spacer()
            
            // MARK: - Info Panel
            HStack() {
                Spacer()
                Image(systemName: "arrow.up.left.and.arrow.down.right")
                Text("\(scale)")
                Spacer()
                Image(systemName: "arrow.left.and.right")
                Text("\(offset.width)")
                Spacer()
                Image(systemName: "arrow.up.and.down")
                Text("\(offset.height)")
                Spacer()
            }
            .font(.footnote)
            .padding(8)
            .background(.ultraThinMaterial)
            .cornerRadius(8)
            .frame(maxWidth: 420)
            .opacity(panelVisible ? 1 : 0)
            
            Spacer()
        }
    }
}

struct InfoPanelView_Previews: PreviewProvider {
    static var previews: some View {
        InfoPanelView(scale: 1, offset: .zero)
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
