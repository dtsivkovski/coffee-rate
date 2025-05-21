//
//  WantToGoList.swift
//  Coffee Rate
//
//  Created by Daniel Tsivkovski on 4/29/25.
//

import SwiftUI
import SwiftData

struct WantToGoList: View {
    @Environment(\.modelContext) var modelContext
    @Query var items: [WantToGoItem]
    
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $navigationPath){
            //List of want to go items
            List{
                ForEach(items){ item in
                    //replace VStack with ListCell and maybe ZStack with rounded rectangle
                    NavigationLink(value: item){
                        ListCell(item: item)
                    }
                } //end of ForEach
                .onDelete(perform: deleteItems)
            }
            .navigationTitle("Want To Go")
            
            //want to go item navigation
            .navigationDestination(for: WantToGoItem.self) { item in
                WantToGoView(item: item, navigationPath: $navigationPath)
            }
            
            // navigate to AddWantToGo View
            .navigationDestination(for: String.self) { value in
                if value == "Add Want To Go" {
                    AddWantToGo(navigationPath: $navigationPath)
                }
            }
            .toolbar{
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(value: "Add Want To Go") {
                        Image(systemName: "rectangle.stack.fill.badge.plus")
                    }
                }
            }
            
            
        }
        
    }//end of body
    func deleteItems(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(items[index])
        }
    }
    
}

struct ListCell: View {
    var item: WantToGoItem
    
    var body: some View{
        HStack{
            Image(systemName: "cup.and.saucer.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .padding(.trailing, 10)
            Text(item.name)
                .font(.title2)
        }
    }
}

#Preview {
    ContentView()
}
