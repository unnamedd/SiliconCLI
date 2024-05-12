import SiliconLibrary
import SwiftTUI

struct RowView: View {

  // MARK: - Private Properties
  
  private let isCurrent: Bool
  
  private let application: SiliconLibrary.Application

  // MARK: - Init

  init(for application: SiliconLibrary.Application, isCurrent: Bool) {
    self.application = application
    self.isCurrent = isCurrent
  }

  // MARK: - Lifecycle

  var body: some View {
    VStack {
      Text(application.name)
        .bold(isCurrent)
    } 
    .padding(.horizontal)
  }
}
