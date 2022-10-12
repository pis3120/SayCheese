/*
See the License.txt file for this sample’s licensing information.
*/

import SwiftUI

@main
struct SwiftUI_JJaseCamApp: App {
    var body: some Scene {
        WindowGroup {
            CameraView(name: .constant(nil), scrum: .constant(DailyScrum.sampleData[0]))
        }
    }
}
