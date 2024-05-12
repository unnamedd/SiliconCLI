import SiliconLibrary
import SwiftTUI

// MARK: - DetailsView

struct DetailsView: View {

  // MARK: - Private Properties
  
  private let application: SiliconLibrary.Application
  
  // MARK: - Init

  init(for application: SiliconLibrary.Application) {
    self.application = application
  }

  // MARK: - Lifecycle

  var body: some View {
    VStack {
      headerView
        .padding(.horizontal)

      Divider()
        .style(.heavy)

      mainInfoView
        .padding(.horizontal)

      moreInfoView
        .padding(.horizontal)
    }
  }
}

// MARK: - Content Views

private extension DetailsView {

  var headerView: some View {
    HStack(spacing: 0) {
      Text(application.name)
        .bold()

      if let version = application.version {
        Text(" (v")
        Text("\(version)")
          .bold()
        Text(")")
      }
    }
  }

  var mainInfoView: some View {
    VStack {
      Spacer()
        .frame(height: 1)

      Text("Main Information")
        .bold()
        .underline()

      Spacer()
        .frame(height: 1)

      if let bundleIdentifier = application.bundleID {
        HStack {
          Text("Bundle Identifier ")
          Spacer()
          Text(bundleIdentifier)
            .bold()
        }
      }

      HStack {
        Text("Package")
        Spacer()
        Text(application.architecture)
          .bold()
      }

      HStack {
        Text("Architecture\(application.architectures.count > 1 ? "s" : "") ")
        Spacer()

        ForEach(application.architectures, id:\.self) { arch in
          Text(" \(arch) ")
            .bold()
            .background(arch == "x86_64" ? .brightMagenta : .yellow)
            .foregroundColor(arch == "x86_64" ? .white : .black)
        }
      }
    }
  }

  var moreInfoView: some View {
    VStack {
      Text("")

      if application.isAppleSiliconReady || application.isSystemApp || application.isElectronApp {
        Text("More")
          .bold()
          .underline()

        Spacer()
          .frame(height: 1)
      }

      HStack(spacing: 1) {
        if application.isAppleSiliconReady {
          Text(" Apple Silicon ")
            .bold()
            .background(.brightRed)
            .foregroundColor(.white)
        }

        if application.isSystemApp {
          Text(" System App ")
            .bold()
            .background(.brightBlack)
            .foregroundColor(.brightYellow)
        }

        if application.isElectronApp {
          Text(" Electron-based App ")
            .bold()
            .background(.brightGreen)
            .foregroundColor(.brightBlack)
        }
      }
    }
  }
}
