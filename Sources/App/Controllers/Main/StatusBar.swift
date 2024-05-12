import Combine
import Foundation
import SwiftTUI

struct StatusBar: View {
  @Environment(\.buildConfiguration) private var buildConfiguration
 
  // MARK: - Properties
  
  let current: Int
  let total: Int
  let showInfo: Bool
  
  // MARK: - Lifecycle
  
  var body: some View {
    HStack {
      if showInfo {
        Text("Application:")
        
        let indicator = total == 0 ? String(total) : String(current + 1)
        Text(indicator)
          .bold()
          .underline()
          .foregroundColor(.brightBlue)

        Divider()
          .style(.heavy)
          .frame(height: 1)
        
        Text("\(total)")
          .bold()
        
        if buildConfiguration != .release {
          HStack(spacing: 0) {
            Spacer()
            
            Text("[Build: ")
            
            Text(buildConfiguration.description)
              .underline()
              .bold()
              .foregroundColor(.orange)
            
            Text("]")
          }
        }
      }
    }
  }
}
