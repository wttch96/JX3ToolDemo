//
//  CarouselView.swift
//  JX3Demo
//
//  Created by Wttch on 2023/7/9.
//

import SwiftUI
import Combine


struct CarouselView<T: Identifiable, Content: View>: View {
    
    private let data: [T]
    private let content: (T) -> Content
    
    init(_ data: [T], @ViewBuilder content: @escaping (T) -> Content ) {
        self.data = data
        self.content = content
    }
    
    @State var curIndex = 0
    
    private var timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
    
    // 定时器动画中
    @State private var timerAnimating = false
    // 拖动中
    @State private var draging = false
    @State private var dragValue: CGFloat = 0
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(0..<data.count, id: \.self ,content: { id in
                    let item = data[id]
                    
                    content(item)
                        .scaledToFill()
                        .frame(width: geo.size.width, height: geo.size.height)
                        .clipped()
                        .offset(x: distance(id) * geo.size.width + dragValue)
                        .zIndex(Double(data.count) - abs(distance(id)))
                })
            }
            .gesture(DragGesture().onChanged({ value in
                draging = true
                dragValue = value.translation.width
            }).onEnded({ value in
                if value.translation.width > geo.size.width/2 {
                    withAnimation(.spring()) {
                        curIndex -= 1
                        if curIndex == -1 {
                            curIndex = 9
                        }
                        dragValue = 0
                        draging = false
                    }
                } else {
                    withAnimation(.spring()) {
                        curIndex += 1
                        if curIndex == 10 {
                            curIndex = 0
                        }
                        dragValue = 0
                        draging = false
                    }
                }
            }))
        }
        .onReceive(timer, perform: { _ in
            if !draging {
                withAnimation(.linear(duration: 0.5)) {
                    self.curIndex += 1
                    self.curIndex %= self.data.count
                }
            }
        })
    }
    
    
    private func distance(_ id: Int) -> Double {
        if curIndex == 0 && id == self.data.count - 1 {
            return -1
        }
        
        if id == 0 && curIndex == self.data.count - 1 {
            return 1
        }
        
        return Double(id - curIndex)
    }
}

struct CarouselView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CarouselView(dev.news) { new in
                WebCacheableImage(new, folderName: "news", urlFormat: { $0.img }, fileNameFormat: { "\($0.id)" })
            }
            .frame(width: 400, height: 200)
            .background(Color.red)
            .cornerRadius(16)
            
            Spacer()
        }
    }
}
