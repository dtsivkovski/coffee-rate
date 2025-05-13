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
    //@Query //uncommented for testing
    var items: [WantToGoItem] = []
    
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        Text("Logo Linking to All Ratings Map Here") //replace with header + logo
            .padding()
        NavigationStack(path: $navigationPath){
            //List of want to go items
            List{
                ForEach(items){ item in
                    //replace VStack with ListCell and maybe ZStack with rounded rectangle
                    NavigationLink(value: item){
                        ListCell(item :item)
                    }
                } //end of ForEach
                .onDelete(perform: deleteItems)
            }
            .navigationTitle("Want To Go")
            
            .toolbar{
                Button(action: addShop) {
                    Image(systemName: "rectangle.stack.fill.badge.plus")
                        .foregroundColor(Color(red: 15/255, green: 102/255, blue: 23/255))
                }
                .buttonStyle(.bordered)
                .background(Color.white)
                
            }
            .navigationDestination(for: WantToGoItem.self) { item in
                WantToGoView(item: item, navigationPath: $navigationPath)
            }
        }
    }//end of body
    func deleteItems(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(items[index])
        }
    }
    
    func addShop(){
        let newShop = WantToGoItem(name: "New Coffee Shop", hasVisited: false)
        modelContext.insert(newShop)
    }
    
}

struct ListCell: View {
    var item: WantToGoItem
    
    var body: some View{
        HStack{
            Image(systemName: "cup.and.saucer.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 50)
                .padding(20)
            Text(item.name)
                .font(.title2)
        }
    }
}

#Preview {
    WantToGoList(items: [
        WantToGoItem(name: "Long Dog Coffee and Treats", hasVisited: false, latitude: 33.789180, longitude: -117.853625),
        WantToGoItem(name: "Contra", hasVisited: false, latitude: 33.789180, longitude: -117.853625)
    ])
}



