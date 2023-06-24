//
//  ContentView.swift
//  Pinch
//
//  Created by Petar Iliev on 6/15/23.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - State
    @State private var isAnimating: Bool = false
    @State private var imageScale: CGFloat = 1.0
    @State private var imageOffset: CGSize = .zero
    @State private var drawerOpen: Bool = false
    @State private var chevronOpen: Bool = false
    @State private var pageID: Int = 0
    
    // MARK: - Properties
    let pages: [Page] = pagesData
    var currentImage: String {
        return pages[pageID].imageName
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.clear
                
                // MARK: - Page Image
                Image(currentImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .padding()
                    .shadow(color: .black.opacity(0.2), radius: 12, x: 2, y: 2)
                    .opacity(isAnimating ? 1 : 0)
                    .offset(imageOffset)
                    .animation(.easeOut, value: isAnimating)
                    .scaleEffect(imageScale)
                    .onTapGesture(count: 2) {
                        withAnimation(.spring()) {
                            imageScale = imageScale == 3.0 ? 1.0 : 3.0
                            imageOffset = .zero
                        }
                    }
                    // MARK: - DragGesture
                    .gesture(DragGesture()
                        .onChanged({ value in
                            withAnimation(.linear(duration: 1)) {
                                imageOffset = value.translation
                            }
                            
                        })
                            .onEnded({ _ in
                                withAnimation(.linear) {
                                    if imageScale == 1.0 { imageOffset = .zero }
                                }
                                
                            })
                    )
                    // MARK: MagnificationGesture
                    .gesture(MagnificationGesture()
                        .onChanged({ distance in
                            withAnimation(.linear) {
                                if imageScale >= 0 && imageScale <= 5 {
                                    imageScale = distance
                                } else if imageScale > 5 {
                                    imageScale = 5
                                } else if imageScale <= 1 {
                                    imageScale = 1
                                }
                            }
                        })
                            .onEnded({ _ in
                                if imageScale > 5 {
                                    imageScale = 5
                                } else if imageScale < 1 {
                                    imageScale = 1
                                    imageOffset = .zero
                                }
                            }))
            } //: ZStack
            .navigationTitle("Pinch & Zoom")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                isAnimating = true
            }
            .overlay(alignment: .top) {
                InfoPanelView(scale: imageScale, offset: imageOffset)
                    .padding(.horizontal)
                    .padding(.top, 30)
            }
            .overlay(alignment: .bottom) {
                Group {
                    HStack {
                        // Scale down
                        Button {
                            withAnimation(.spring()) { if imageScale > 1 { imageScale -= 1 } }
                        } label: {
                            ControlImageView(icon: "minus.magnifyingglass")
                        }
                        
                        // Reset
                        Button {
                            withAnimation(.spring()) { imageScale = 1 }
                        } label: {
                            ControlImageView(icon: "arrow.up.left.and.down.right.magnifyingglass")
                        }
                        
                        // Scale up
                        Button {
                            withAnimation(.spring()) { if imageScale < 5 { imageScale += 1 } }
                        } label: {
                            ControlImageView(icon: "plus.magnifyingglass")
                        }

                    } //: Controls
                    .padding(EdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20))
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .opacity(isAnimating ? 1 : 0)
                }
            }
            // MARK: - Drawer
            .overlay(alignment: .topTrailing) {
                HStack {
                    // Handle
                    Image(systemName: chevronOpen ? "chevron.compact.right" : "chevron.compact.left")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 40)
                        .padding(8)
                        .foregroundStyle(.secondary)
                        .onTapGesture {
                            withAnimation(.easeOut) {
                                drawerOpen.toggle()
                            }
                            chevronOpen.toggle()
                        }
                    
                    // Thubmanils
                    ForEach(pages) { page in
                        Image(page.thumbnailName)
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(5)
                            .frame(width: 90)
                            .shadow(radius: 4)
                            .onTapGesture {
                                pageID = page.id
                            }
                    }
                    
                    Spacer()
                    
                } //: Drawer
                .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8))
                .background(.ultraThinMaterial)
                .cornerRadius(12)
                .opacity(isAnimating ? 1 : 0)
                .frame(width: 260)
                .padding(.top, UIScreen.main.bounds.height / 12)
                .offset(x: drawerOpen ? 15 : 215)
            }
        } //: NavigationStack
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
