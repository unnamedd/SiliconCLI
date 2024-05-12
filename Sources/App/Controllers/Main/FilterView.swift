import SwiftTUI

struct FilterView: View {
  
  // MARK: - Properties
  
  @ObservedObject var manager: ApplicationsManager
  
  // MARK: - Lifecycle
  
  var body: some View {
    VStack {
      Text("Arch")
        .bold()
      
      Divider()
        .style(.heavy)
      
      let filters = [ApplicationsManager.Filter.silicon, .electron, .intel, .system]
      
      ForEach(filters, id:\.self) { filter in
        Button(filter.description ) {
          manager.filter(by: filter)
        }
        .bold(manager.filter == filter)
      }
      .padding(.horizontal, 1)
      
      if manager.filter != .none {
        Divider()
          .style(.heavy)
          .padding(.horizontal, 1)
        
        Button("Clear Filter") {
          manager.filter(by: .none)
        }
        .padding(.horizontal, 1)
      }
    }
  }
}
