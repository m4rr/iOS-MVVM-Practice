//
//  ContentView.swift
//  Shared
//
//  Created by Marat Say on 7/6/20.
//

import SwiftUI

struct ContentView: View {

  private(set) var deps: Dependencies

  @State private var data: [PhotoInfo] = []
  @State private var isLoading: Bool = true
  @State private var isDetailsPresented: Bool = false


  let gridItem = GridItem(.adaptive(minimum: itemMinWidth, maximum: itemMinWidth * 2),
                          spacing: outerSpace)

  var body: some View {

    NavigationView {

      ZStack {

        ProgressView()
          .opacity(isLoading ? 1 : 0)

        ScrollView {

          LazyVGrid(columns: [gridItem], spacing: outerSpace) {

            ForEach(data, id: \.id) { row in

              PhotoItemView(viewModel: .init(info: row, deps.photos))
                .sheet(isPresented: $isDetailsPresented, onDismiss: {
                  // on dismiss
                }, content: {
                  PhotoDetailsView(isPresented: $isDetailsPresented, viewModel: .init(photoInfo: row))
                })
                .onTapGesture {
                  isDetailsPresented.toggle()
                }

            }

          } // LazyVGrid
          .padding(.all, outerSpace)

        } // ScrollView

      } // ZStack
      .navigationTitle("Photo Lib")
      .onAppear(perform: {
        deps.photos.topPopular(query: "cars") { result in
          isLoading = false

          switch result {
          case .success(let photos):
            data = photos
          case .failure(let err):
            // FIXME: err
            ()
          }
        }
      }) // onAppear

    } // NavigationView
    .frame(minWidth: 300, idealWidth: 400, maxWidth: .infinity,
           minHeight: 300, idealHeight: 500, maxHeight: .infinity, alignment: .center)

  }

}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView(deps: Dependencies())
//      .frame(width: 1080/2, height: 1980/2, alignment: .center)
  }
}
