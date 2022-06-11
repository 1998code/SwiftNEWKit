import SwiftUI
 
@available(iOS 14, macOS 11.0, *)
public struct AnimatedMenuBar: View {
    @Binding var selectedIndex: Int
    @Namespace private var menuItemTransition
 
    var menuItems = [ "Travel", "Nature", "Architecture" ]
 
    public init(selectedIndex: Binding<Int>, menuItems: [String] = [ "Travel", "Nature", "Architecture" ]) {
        self._selectedIndex = selectedIndex
        self.menuItems = menuItems
    }
 
    public var body: some View {
 
        HStack {
            Spacer()
 
            ForEach(menuItems.indices) { index in
 
                if index == selectedIndex {
                    Text(menuItems[index])
                        .padding(.horizontal)
                        .padding(.vertical, 4)
                        .background(Capsule().foregroundColor(Color.purple))
                        .foregroundColor(.white)
                        .matchedGeometryEffect(id: "menuItem", in: menuItemTransition)
                } else {
                    Text(menuItems[index])
                        .padding(.horizontal)
                        .padding(.vertical, 4)
                        .background(Capsule().foregroundColor(Color( red: 244, green: 244, blue: 244)))
                        .onTapGesture {
                            selectedIndex = index
                        }
                }
 
                Spacer()
            }
 
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .padding()
        .animation(.easeInOut, value: selectedIndex)
 
    }
}
