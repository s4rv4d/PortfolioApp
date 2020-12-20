//
//  ItemRowView.swift
//  PortfolioApp
//
//  Created by Sarvad Shetty on 20/12/2020.
//

import SwiftUI

struct ItemRowView: View {
    
    @ObservedObject var item: Item
    
    var body: some View {
        NavigationLink(destination: EditItemView(item: item)) {
            Text(item.itemTitle)
        }
    }
}

struct ItemRowView_Previews: PreviewProvider {
    static var previews: some View {
        ItemRowView(item: Item.example)
    }
}
