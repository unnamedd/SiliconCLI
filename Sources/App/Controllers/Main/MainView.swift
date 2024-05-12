import SiliconLibrary
import SwiftTUI

// MARK: - MainView

struct MainView: View {

  // MARK: - Private Properties

  @State private var selected = 0
  @State private var filterVisible = false

  private var applications: Applications {
    manager.applications
  }

  private var hasContent: Bool {
    switch manager.state {
    case .loading, .error, .initial:
      false
    case .list:
      manager.totalCount > 0
    }
  }

  // MARK: - Properties

  @ObservedObject var manager: ApplicationsManager

  // MARK: - Views

  var body: some View {
    containerView
      .onAppear {
        manager.scan()
      }
  }
}

// MARK: - Container Views

private extension MainView {
  var containerView: some View {
    ZStack(alignment: .topTrailing) {
      VStack {
        headerView

        switch manager.state {
        case .list:
          contentView
        default:
          stateView
        }

        footerView
      }
    }
    .border(.rounded)
  }

  var headerView: some View {
    HStack {
      if hasContent {
        Text("Silicon")
          .foregroundColor(.orange)
          .bold()
          .padding(.left)
      }
    }
    .padding(.horizontal)
  }

  var contentView: some View {
    HStack(spacing: 0) {
      listView
        .border(style: .rounded)
        .padding(.left)

      detailsView
        .frame(maxWidth: .infinity)
        .border(style: .rounded)
        .padding(.right)
    }
  }

  var stateView: some View {
    VStack {
      Spacer()
      HStack {
        Spacer()
        switch manager.state {
        case .loading:
          loadingView
        default:
          Text(manager.state.description)
        }
        Spacer()
      }
      Spacer()
    }
  }

  var loadingView: some View {
    VStack(alignment: .center) {
      Text("Loading applications")

      HStack {
        Text("using")
        Text("Silicon")
          .bold()
          .foregroundColor(.orange)
      }

      Spacer()
        .frame(height: 2)

      Text("Please wait...")
    }
  }

  var footerView: some View {
    StatusBar(
      current: selected,
      total: manager.totalCount,
      showInfo: hasContent
    )
    .padding(.horizontal)
    .environment(\.buildConfiguration, manager.buildConfiguration)
  }
}

// MARK: - Content Views

private extension MainView {
  var listView: some View {
    VStack {
      HStack {
        Button("Filter\(filterVisible ? " ↑" : "")") {
          filterVisible.toggle()
        }
        .bold(filterVisible)
        .underline(filterVisible)
        .padding(.left)
       
        if manager.isFilterActive {
          HStack(spacing: 0) {
            Text("(by ")
            Text(manager.filter.description)
              .underline()
              .bold()
            Text(")")
          }
        }
      }

      if filterVisible, hasContent {
        FilterView(
          manager: manager
        )
        .border(.rounded)
      }

      Divider()
        .style(.heavy)
        .frame(height: 1)

      ScrollView {
        VStack {
          ForEach(Array(applications.enumerated()), id: \.offset) { index, application in
            Button(action: { }, hover: { selected = index }) {
              RowView(
                for: application,
                isCurrent: selected == index
              )
            }
          }
        }
      }
    }
    .frame(maxWidth: 30)
  }

  var detailsView: some View {
    VStack {
      DetailsView(
        for: manager.application(
          at: selected
        )
      )

      Spacer()
    }
  }
}
