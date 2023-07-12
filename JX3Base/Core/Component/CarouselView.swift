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
    
    private var timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
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
                        .background(Color.gray)
                        .frame(width: geo.size.width, height: geo.size.height)
                        .clipped()
                        .offset(x: distance(id) * geo.size.width + dragValue)
                        .zIndex(Double(data.count) - abs(distance(id)))
                })
                
                VStack {
                    Spacer()
                    HStack(spacing: 10) {
                        ForEach(0..<data.count, id: \.self, content: { index in
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color.white)
                                .opacity(index == curIndex ? 1 : 0.4)
                                .frame(width: 20, height: 4)
                        })
                    }
                    .padding(.bottom)
                }
                .zIndex(Double(data.count + 1))
            }
            .highPriorityGesture(DragGesture().onChanged({ value in
                if !timerAnimating {
                    draging = true
                    dragValue = value.translation.width
                }
            }).onEnded({ value in
                if draging {
                    // 左边划 正
                    // 右边划 负
                    let tWidth = value.translation.width
                    withAnimation(.spring()) {
                        if tWidth > 0 {
                            if tWidth > geo.size.width / 2 {
                                var next = curIndex - 1
                                if next == -1 {
                                    next = data.count - 1
                                }
                                curIndex = next
                            }
                        } else {
                            if abs(tWidth) > geo.size.width / 2 {
                                var next = curIndex + 1
                                if next == data.count {
                                    next = 0
                                }
                                curIndex = next
                            }
                        }
                        dragValue = 0
                        draging = false
                    }
                }
            }))
        }
        .onReceive(timer, perform: { _ in
            timerAnimating = true
            if !draging && !self.data.isEmpty {
                let duration = 0.3
                withAnimation(.linear(duration: duration)) {
                    self.curIndex += 1
                    self.curIndex %= self.data.count
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: {
                    timerAnimating = false
                })
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
