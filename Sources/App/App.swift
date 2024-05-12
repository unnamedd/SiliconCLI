import SwiftTUI

@main
struct SiliconCLI {
  static func main() {
    Application(
      rootView: MainView(
        manager: ApplicationsManager()
      )
    )
    .start()
  }
}
