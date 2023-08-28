//
//  AdaptivePagingScrollView.swift
//  Sport_Baze
//
//  Created by Андрій Кузьмич on 18.08.2023.
//

import SwiftUI

struct AdaptivePagingScrollView: View {
    
    private let items: [AnyView]
    private let itemPadding: CGFloat
    private let itemSpacing: CGFloat
    private let itemWidth: CGFloat
    private let itemsAmount: Int
    private let contentWidth: CGFloat
    
    private let leadingOffset: CGFloat
    private let scrollDampingFactor: CGFloat = 0.66
    
    @Binding var currentPageIndex: Int
    @Binding var onNavigating: Bool
    @State var activeNavigation = false
    @State var activeTap = true
    
    @State private var currentScrollOffset: CGFloat = 0
    @State private var gestureDragOffset: CGFloat = 0
    @GestureState private var dragOffset: CGFloat = 0
    
    
    init<A: View>(currentPageIndex: Binding<Int>,
                  onNavigating: Binding<Bool>,
                  itemsAmount: Int,
                  itemWidth: CGFloat,
                  itemPadding: CGFloat,
                  pageWidth: CGFloat,
                  @ViewBuilder content: () -> A) {
        
        let views = content()
        self.items = [AnyView(views)]
        
        self._currentPageIndex = currentPageIndex
        self._onNavigating = onNavigating
        
        self.itemsAmount = itemsAmount
        self.itemSpacing = itemPadding
        self.itemWidth = itemWidth
        self.itemPadding = itemPadding
        self.contentWidth = (itemWidth+itemPadding)*CGFloat(itemsAmount)
        
        let itemRemain = (pageWidth-itemWidth-2*itemPadding)/2
        self.leadingOffset = itemRemain + itemPadding
    }
    
    private func countOffset(for pageIndex: Int) -> CGFloat {
        
        let activePageOffset = CGFloat(pageIndex) * (itemWidth + itemPadding)
        return leadingOffset - activePageOffset
    }
    
    // 02
    private func countPageIndex(for offset: CGFloat) -> Int {
        
        guard (itemsAmount ) > 1 else { return 0 }
        //        if  itemsAmount > 0{
        let offset = countLogicalOffset(offset)
        let floatIndex = (offset)/(itemWidth + itemPadding)
        
        var index = Int(round(floatIndex))
        if max(index, 0) >= itemsAmount {
            index = itemsAmount - 1
        }
        return min(max(index, 0), itemsAmount)
        
    }
    
    // 03
    private func countCurrentScrollOffset() -> CGFloat {
        return countOffset(for: currentPageIndex) + gestureDragOffset
    }
    
    // 04
    private func countLogicalOffset(_ trueOffset: CGFloat) -> CGFloat {
        return (trueOffset-leadingOffset) * -1.0
    }
    
    var body: some View {
        // 01
        GeometryReader { viewGeometry in
            HStack(alignment: .center, spacing: itemSpacing) {
                ForEach(items.indices, id: \.self) { itemIndex in
                    items[itemIndex].frame(width: itemWidth)
                        .disabled(!activeTap)
                    
                }
            }
        }
        .onAppear { // 02
            currentScrollOffset = countOffset(for: currentPageIndex)
            
        }
        .background(Color.black.opacity(0.00001)) // hack - this allows gesture recognizing even when background is transparent
        .frame(width: contentWidth)
        .offset(x: self.currentScrollOffset, y: 0)
        .simultaneousGesture( // 03
            DragGesture(minimumDistance: 1, coordinateSpace: .local)
                .updating($dragOffset) { value, state, _ in
                    state = value.translation.width
                }
            
                .onChanged { value in // 04
                    gestureDragOffset = value.translation.width
                    currentScrollOffset = countCurrentScrollOffset()
                    self.onNavigating = false
                    self.activeTap = false
                }
                .onEnded { value in // 05
                    let cleanOffset = (value.predictedEndTranslation.width - gestureDragOffset)
                    let velocityDiff = cleanOffset * scrollDampingFactor
                    if (itemsAmount  ) >= 1{
                        
                        var newPageIndex = countPageIndex(for: currentScrollOffset + velocityDiff)
                        
                        let currentItemOffset = CGFloat(currentPageIndex) * (itemWidth + itemPadding)
                        if currentScrollOffset < -(currentItemOffset),
                           newPageIndex == currentPageIndex {
                            newPageIndex += 1
                        }
                        withAnimation(.interpolatingSpring(mass: 0.1,
                                                           stiffness: 15,
                                                           damping: 3,
                                                           initialVelocity: 0)) {
                            self.currentPageIndex = newPageIndex
                            
                        }
                    }
                    
                    
                    
                    gestureDragOffset = 0
                    withAnimation(.interpolatingSpring(mass: 0.1,
                                                       stiffness: 15,
                                                       damping: 3,
                                                       initialVelocity: 0)) {
                        self.currentScrollOffset = self.countCurrentScrollOffset()
                        self.onNavigating = true
                        self.activeTap = true
                    }
                }
        )
    }
}

