//
// Copyright (c) Vatsal Manot
//

import CorePersistence
import Swallow
import SwiftUIZ

public struct _AxisSizeReader<Content: View>: View {
    let axis: Axis
    let content: (CGSize) -> Content
    
    public init(
        _ axis: Axis,
        content: @escaping (CGSize) -> Content
    ) {
        self.axis = axis
        self.content = content
    }
    
    public var body: some View {
        IntrinsicSizeReader { proxy in
            ZStack {
                if axis == .horizontal {
                    HStack {
                        Spacer()
                    }
                } else if axis == .horizontal {
                    VStack {
                        Spacer()
                    }
                }
                
                content(proxy)
            }
        }
    }
}

extension LazyVGrid {
    public init(
        alignment: HorizontalAlignment = .center,
        spacing: CGFloat? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.init(columns: [.flexible()], spacing: spacing) {
            content()
        }
    }
}

public struct LTAccountsScene: View {
    @StateObject var store: LTAccountsStore = LTDataStore.shared.accounts
    
    public init() {
        
    }
    
    public var body: some View {
        XStack(alignment: .topLeading) {
            LazyVGrid(
                columns: [.adaptive(minimum: 126, alignment: .leading)],
                alignment: .leading,
                spacing: 16
            ) {
                NewAccountButton()
                
                ForEach($store.accounts) { $account in
                    Cell(account: $account)
                }
                .modifier(_CellStyle())
            }
            .environmentObject(store)
            .padding()
        }
    }
    
    private struct NewAccountButton: View {
        @EnvironmentObject var store: LTAccountsStore
        
        var body: some View {
            PresentationLink {
                _AccountSelectionPicker()
            } label: {
                Image(systemName: .plus)
                    .font(.title)
                    .foregroundColor(.secondary)
                    .imageScale(.large)
            }
            .buttonStyle(AnyButtonStyle {
                $0.label.modifier(_CellStyle())
            })
        }
    }
    private struct Cell: View {
        @EnvironmentObject var store: LTAccountsStore
        
        @Binding var account: LTAccount
        
        var accountType: LTAccountTypeDescription {
            store[account.accountType]
        }
        
        var body: some View {
            EditableText(
                "Untitled Account",
                text: $account.accountDescription
            )
            .modifier(_CellStyle())
        }
    }
}

extension Color {
    public static let alertBackgroundColor = Color.adaptable(
        light: .unimplemented,
        dark: Color(hexadecimal: "1b1b1c")
    )
    
    public static let accountModalBackgroundColor = Color.adaptable(
        light: .unimplemented,
        dark: Color(cube256: .sRGB, red: 29, green: 29, blue: 30)
    )
}

struct _AccountSelectionPicker: View {
    @EnvironmentObject var store: LTAccountsStore
    
    var body: some View {
        NavigationStack {
            content
                .formStyle(.grouped)
                .frame(height: 500)
                .toolbar {
                    ToolbarItemGroup {
                        Button {
                            
                        } label: {
                            Image(systemName: .questionmark)
                                .imageScale(.medium)
                                .font(.subheadline.weight(.semibold))
                        }
                        .modify {
                            if #available(macOS 14.0, *) {
                                $0.buttonBorderShape(.circle)
                            } else {
                                $0
                            }
                        }
                    }
                    
                    ToolbarItemGroup(placement: .cancellationAction) {
                        DismissPresentationButton("Cancel")
                    }
                }
                .scrollContentBackground(.hidden)
                .navigationTitle("Accounts")
                //.navigationSubtitle("Add an account provider.")
                //.toolbarBackground(.hidden, for: .windowToolbar)
        }
        .frame(width: 448, height: 560)
        .background(Color.accountModalBackgroundColor.ignoresSafeArea())
        .toolbarBackground(.hidden, for: .automatic)
    }
    
    private var content: some View {
        Form {
            List {
                ForEach(store.accountTypes, id: \.accountType) { account in
                    Button {
                        
                    } label: {
                        HStack {
                            if let image = account.icon {
                                image
                                    .resizable()
                                    .squareFrame(sideLength: 28)
                            }
                            
                            Text(account.title)
                                .font(.title3)
                                .foregroundStyle(Color.label)
                        }
                    }
                    .buttonStyle(.borderless)
                    .padding(.vertical, 12)
                    .frame(width: .greedy)
                }
            }
        }
    }
}

struct _CellStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(CGSize(width: 126, height: 60))
            .background {
                HoverReader { proxy in
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.quaternary)
                        .overlay {
                            if proxy.isHovering {
                                Color.gray.opacity(0.1)
                                    .clipShape(
                                        RoundedRectangle(cornerRadius: 12)
                                    )
                                    .transition(.opacity)
                            }
                        }
                        .animation(.snappy.speed(2), value: proxy.isHovering)
                        .shadow(color: Color.black, radius: 7)
                }
            }
        
    }
}

public struct HoverProxy: Hashable {
    public var isHovering: Bool
}

public struct HoverReader<Content: View>: View {
    let content: (HoverProxy) -> Content
    
    public init(@ViewBuilder content: @escaping (HoverProxy) -> Content) {
        self.content = content
    }
    
    @State var isHovering: Bool = false
    
    public var body: some View {
        content(HoverProxy(isHovering: isHovering))
            .onHover {
                guard isHovering != $0 else {
                    return
                }
                
                isHovering = $0
            }
    }
}
