//
//  HomeCategoryCell.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/20/25.
//

import SwiftUI
import SCMLogger
import SCMScoopInfo

struct HomeCategoryCell: View {
    
    @StateObject private var foodCategoryRepository: AnyFoodCategoryDisplayable
    
    @State private var selectedCategory: Int = 0
    @State private var showMoreCategory: Bool = false
    
    init(repository: AnyFoodCategoryDisplayable) {
        self._foodCategoryRepository = StateObject(wrappedValue: repository)
    }
    
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
                    image: foodCategoryRepository.categoryImages[index],
                    title: foodCategoryRepository.categoryNames[index],
                    isSelected: (index == selectedCategory && foodCategoryRepository.categoryNames[selectedCategory] != "더보기") ? true : false
                )
                .asButton {
                    if index == 4 && foodCategoryRepository.categoryNames[index] == "더보기" {
                        changeCategory(show: true, switch: 9)
                    } else {
                        selectedCategory = index
                        foodCategoryRepository.selectedCategory = Category.from(foodCategoryRepository.categoryNames[index])
                        
                        Log.debug("현재 선택한 카테고리: \(foodCategoryRepository.categoryNames[index])")
                    }
                    Log.debug("버튼 클릭")
                }
            }
        }
    }
    
    private var bottomCategory: some View {
        HStack(spacing: categorySpacing) {
            ForEach(5..<foodCategoryRepository.categoryNames.count, id: \.self) { index in
                HomeCategoryButtonCell(
                    image: foodCategoryRepository.categoryImages[index],
                    title: foodCategoryRepository.categoryNames[index],
                    isSelected: (index == selectedCategory) ? true : false
                )
                .asButton {
                    if index == 9 && foodCategoryRepository.categoryNames[index] == "접기" {
                        changeCategory(show: false, switch: 4)
                    } else {
                        selectedCategory = index
                        foodCategoryRepository.selectedCategory = Category.from(foodCategoryRepository.categoryNames[index])
                        
                        Log.debug("현재 선택한 카테고리: \(foodCategoryRepository.categoryNames[index])")
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
            foodCategoryRepository.categoryNames.swapAt(4, 9)
            foodCategoryRepository.categoryImages.swapAt(4, 9)
            foodCategoryRepository.categoryNames[index] = (index == 4) ? "더보기" : "접기"
            showMoreCategory = show
        }
    }
}

#Preview {
    HomeCategoryCell(repository: DIContainer.shared.foodCategoryRepository)
}
