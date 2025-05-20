//
//  HomeCategoryCell.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/20/25.
//

import SwiftUI
import SCMLogger

struct HomeCategoryCell: View {
    
    @State private var testCategoryText: [String] = [
        "커피", "패스트푸드", "디저트", "베이커리", "더보기", "한식", "일식", "분식", "샐러드", "샌드위치"
    ]
    @State private var testCategoryImage: [Image] = [
        Image(.coffee), Image(.fastFood), Image(.dessert), Image(.bakery), Image(.more),
        Image(.hansik), Image(.ilsik), Image(.bunsik), Image(.salad), Image(.sandwich)
    ]
    
    @State private var selectedCategory: Int = 0
    @State private var showMoreCategory: Bool = false
    
    private let categorySpacing = (UIScreen.main.bounds.size.width - 320) / 4
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            topCategory
            
            if showMoreCategory {
                bottomCategory
                .transition(.move(edge: .top).combined(with: .opacity))
                .id("category_\(selectedCategory)")
            }
        }
    }
    
    private var topCategory: some View {
        HStack(spacing: categorySpacing) {
            ForEach(0..<5, id: \.self) { index in
                HomeCategoryButtonCell(
                    image: testCategoryImage[index],
                    title: testCategoryText[index],
                    isSelected: (index == selectedCategory && testCategoryText[selectedCategory] != "더보기") ? true : false
                )
                .asButton {
                    if index == 4 && testCategoryText[index] == "더보기" {
                        changeCategory(show: true, switch: 9)
                    } else {
                        selectedCategory = index
                    }
                    Log.debug("버튼 클릭")
                }
            }
        }
    }
    
    private var bottomCategory: some View {
        HStack(spacing: categorySpacing) {
            ForEach(5..<testCategoryText.count, id: \.self) { index in
                HomeCategoryButtonCell(
                    image: testCategoryImage[index],
                    title: testCategoryText[index],
                    isSelected: (index == selectedCategory) ? true : false
                )
                .asButton {
                    if index == 9 && testCategoryText[index] == "접기" {
                        changeCategory(show: false, switch: 4)
                    } else {
                        selectedCategory = index
                    }
                    Log.debug("버튼 클릭")
                }
            }
        }
    }
}

extension HomeCategoryCell {
    
    private func changeCategory(show: Bool, switch index: Int) {
        withAnimation(.easeInOut) {
            testCategoryText.swapAt(4, 9)
            testCategoryImage.swapAt(4, 9)
            testCategoryText[index] = (index == 4) ? "더보기" : "접기"
            showMoreCategory = show
        }
    }
}

#Preview {
    HomeCategoryCell()
}
