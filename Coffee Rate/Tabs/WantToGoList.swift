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
    
    //vars for deletion
    @State private var itemToDelete: WantToGoItem? = nil;
    @State private var showingDeleteAlert = false;
    
    var body: some View {
        NavigationStack(path: $navigationPath){
            //List of want to go items
            List{
                ForEach(items){ item in
                    NavigationLink(value: item){
                        ListCell(item: item)
                    }
                    .swipeActions {
                        Button("Delete") {
                            self.itemToDelete = item
                            showingDeleteAlert = true
                        }
                        .tint(.red)
                    }
                } //end of ForEach
                .confirmationDialog(
                    Text("Are you sure you want to delete this item?"),
                    isPresented: $showingDeleteAlert,
                    titleVisibility: .visible
                ) {
                    Button("Delete", role: .destructive) {
                        if let placeToDelete = itemToDelete {
                            withAnimation {
                                deleteItem(placeToDelete)
                            }
                        }
                    }
                    .tint(.red)
                }
                
            }
            .navigationTitle("Want To Go")
 
            //want to go item navigation
            .navigationDestination(for: WantToGoItem.self) { item in
                WantToGoView(item: item, navigationPath: $navigationPath)
            }

            //navigation to add want to go item and rating
            .navigationDestination(for: String.self) { value in
                switch value {
                case "Add Want To Go":
                    AddWantToGo(navigationPath: $navigationPath)
                case "Add Rating":
                    AddRating(navigationPath: $navigationPath)
                default:
                    Text("Unknown destination")
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

    func deleteItem(_ item : WantToGoItem) {
        modelContext.delete(item);
    }
    
}

struct ListCell: View {
    @Environment(\.colorScheme) var colorScheme;
    
    var item: WantToGoItem
    
    // get color based on visited or not
    var cupBackgroundColor : Color {
        get {
            if (colorScheme == .dark) {
                if (item.hasVisited) {
                    return Color(red: 50/256, green: 150/256, blue: 50/256)
                } else if (!item.hasVisited) {
                    return Color(red: 150/256, green: 50/256, blue: 50/256)
                } else {
                    return Color(.lightGray);
                }
            }
            if (item.hasVisited) {
                return Color(red: 50/256, green: 160/256, blue: 50/256)
            } else if (!item.hasVisited) {
                return Color(red: 200/256, green: 50/256, blue: 50/256)
            } else {
                return Color(.darkGray);
            }
        }
    }
    
    var body: some View{
        HStack{
            Image(systemName: "cup.and.saucer.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .foregroundStyle(cupBackgroundColor)
                .shadow(color: .black.opacity(0.2), radius: 1, y: 2)
                .padding(.trailing, 10)
            Text(item.name)
                .font(.title2)
                .fontWeight(.medium)
        }
    }
}

#Preview {
    ContentView()
}
