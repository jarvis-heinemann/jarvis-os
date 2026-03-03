import SwiftUI

// MARK: - Theme Manager
class ThemeManager: ObservableObject {
    static let shared = ThemeManager()
    @AppStorage("theme") var theme: String = "system"
    @AppStorage("sidebarWidth") var sidebarWidth: Double = 220

    var colorScheme: ColorScheme? {
        switch theme {
        case "dark": return .dark
        case "light": return .light
        default: return nil
        }
    }
}

// MARK: - App
@main
struct MissionControlApp: App {
    @StateObject private var themeManager = ThemeManager.shared
    @StateObject private var store = AppStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView(store: store)
                .preferredColorScheme(themeManager.colorScheme)
                .onAppear { store.load() }
        }
        .windowStyle(.hiddenTitleBar)
        .defaultSize(width: 1400, height: 900)
        .commands {
            CommandGroup(replacing: .newItem) {
                Button("New Project") {
                    store.addProject(Project(name: "New Project"))
                }
                .keyboardShortcut("n", modifiers: .command)
                
                Button("New Domain") {
                    store.domains.append(Domain(name: "newdomain.com", registrar: "Cloudflare"))
                }
                .keyboardShortcut("d", modifiers: [.command, .shift])
                
                Button("New Patent") {
                    store.patents.append(PatentModel(title: "New Patent", type: .provisional))
                }
                .keyboardShortcut("p", modifiers: [.command, .shift])
            }
            
            CommandMenu("View") {
                Button("Focus Mode") {
                    store.selectedPanel = .focus
                }
                .keyboardShortcut("1", modifiers: .command)
                
                Button("Refresh Skills") {
                    store.loadSkills()
                }
                .keyboardShortcut("r", modifiers: .command)
            }
        }
    }
}

struct ContentView: View {
    @ObservedObject var store: AppStore
    @StateObject private var themeManager = ThemeManager.shared
    @State private var showingCommandPalette = false
    
    var body: some View {
        NavigationSplitView(columnVisibility: .constant(.all)) {
            SidebarView(selectedPanel: $store.selectedPanel)
                .frame(minWidth: themeManager.sidebarWidth)
        } detail: {
            DetailView(panel: store.selectedPanel, store: store)
        }
        .searchable(text: $store.searchText, prompt: "Search projects, domains, patents...")
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                // Quick Add Menu
                Menu {
                    Button("New Project") { store.addProject(Project(name: "New Project")) }
                    Button("New Domain") { store.domains.append(Domain(name: "newdomain.com", registrar: "Cloudflare")) }
                    Button("New Patent") { store.patents.append(PatentModel(title: "New Patent", type: .provisional)) }
                    Divider()
                    Button("New Workflow") { store.workflows.append(Workflow(name: "New Workflow")) }
                } label: {
                    Image(systemName: "plus")
                }
                .help("Quick Add")
                
                // Command Palette
                Button {
                    showingCommandPalette = true
                } label: {
                    Image(systemName: "command")
                }
                .keyboardShortcut("k", modifiers: .command)
                .help("Command Palette (⌘K)")
                
                // Theme Toggle
                Menu {
                    Button("Light") { withAnimation { themeManager.theme = "light" } }
                    Button("Dark") { withAnimation { themeManager.theme = "dark" } }
                    Button("System") { withAnimation { themeManager.theme = "system" } }
                } label: {
                    Image(systemName: themeIcon)
                }
                
                // Save
                Button {
                    store.save()
                } label: {
                    Image(systemName: "square.and.arrow.down")
                }
                .help("Save (⌘S)")
                .keyboardShortcut("s", modifiers: .command)
            }
        }
        .sheet(isPresented: $showingCommandPalette) {
            CommandPaletteView(store: store)
        }
    }
    
    private var themeIcon: String {
        switch themeManager.theme {
        case "dark": return "moon.fill"
        case "light": return "sun.max.fill"
        default: return "circle.lefthalf.filled"
        }
    }
}

// MARK: - Panel Enum
enum Panel: String, CaseIterable, Identifiable {
    case focus = "Focus"
    case ideas = "Ideas"
    case planning = "Planning"
    case researching = "Researching"
    case techSpec = "Tech Spec"
    case design = "Design"
    case wireframes = "Wireframes"
    case frontend = "Frontend"
    case backend = "Backend"
    case database = "Database"
    case api = "API"
    case cicd = "CI/CD"
    case workflows = "Workflows"
    case domains = "Domains"
    case ip = "IP/Patents"
    case automation = "Automation"
    case skills = "Skills"
    case metrics = "Metrics"
    case financials = "Financials"
    case launches = "Launches"
    case assets = "Assets"
    case team = "Team"
    case settings = "Settings"
    case shortcuts = "Shortcuts"
    case calendar = "Calendar"
    case todos = "Todos"
    case notes = "Notes"
    case history = "History"
    case search = "Search"
    case reports = "Reports"
    case integrations = "Integrations"
    case monitoring = "Monitoring"
    case kb = "Knowledge Base"
    case cli = "CLI Tools"
    case apiManager = "API Manager"
    case competitors = "Competitors"
    case terminal = "Terminal"
    case git = "Git"
    case docker = "Docker"
    case email = "Email"
    case cloud = "Cloud"
    case security = "Security"
    case backups = "Backups"
    case browser = "Browser"
    case fullCalendar = "Full Calendar"
    case tasks = "Tasks"
    case time = "Time"
    case aiModels = "AI Models"
    case logs = "Logs"
    case snippets = "Snippets"
    case environment = "Environment"
    case quickLinks = "Quick Links"
    case chat = "Chat"
    case notifications = "Notifications"
    case widgets = "Widgets"
    case keyboardShortcuts = "Keyboard Shortcuts"
    case stats = "Stats"
    case voice = "Voice"
    case messages = "Messages"
    case health = "Health"
    case wallet = "Wallet"
    case subscriptions = "Subscriptions"
    case receipts = "Receipts"
    case inventory = "Inventory"
    case timeline = "Timeline"
    case archive = "Archive"
    case templates = "Templates"
    case imports = "Imports"
    case exports = "Exports"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .focus: return "🎯"
        case .ideas: return "💡"
        case .planning: return "📋"
        case .researching: return "🔍"
        case .techSpec: return "📝"
        case .design: return "🎨"
        case .wireframes: return "📐"
        case .frontend: return "💻"
        case .backend: return "⚙️"
        case .database: return "🗄️"
        case .api: return "🔌"
        case .cicd: return "🔄"
        case .workflows: return "🔗"
        case .domains: return "🌐"
        case .ip: return "🔬"
        case .automation: return "🤖"
        case .skills: return "🧩"
        case .metrics: return "📊"
        case .financials: return "💰"
        case .launches: return "🚀"
        case .assets: return "📦"
        case .team: return "👥"
        case .settings: return "⚙️"
        case .shortcuts: return "⌨️"
        case .calendar: return "📅"
        case .todos: return "✅"
        case .notes: return "📝"
        case .history: return "📜"
        case .search: return "🔎"
        case .reports: return "📈"
        case .integrations: return "🔗"
        case .automation: return "⚙️"
        case .monitoring: return "📊"
        case .kb: return "📚"
        case .cli: return "💻"
        case .api: return "🔌"
        case .domains: return "🌐"
        case .competitors: return "⚔️"
        case .terminal: return "🖥️"
        case .git: return "🐙"
        case .docker: return "🐳"
        case .email: return "📧"
        case .cloud: return "☁️"
        case .security: return "🔐"
        case .backups: return "💾"
        case .browser: return "🌐"
        case .fullCalendar: return "📅"
        case .tasks: return "✅"
        case .time: return "⏰"
        case .aiModels: return "🤖"
        case .logs: return "📜"
        case .snippets: return "✂️"
        case .environment: return "⚙️"
        case .quickLinks: return "🔗"
        case .chat: return "💬"
        case .notifications: return "🔔"
        case .widgets: return "🧩"
        case .keyboardShortcuts: return "⌨️"
        case .stats: return "📈"
        case .voice: return "🎤"
        case .messages: return "✉️"
        case .health: return "❤️"
        case .wallet: return "💳"
        case .subscriptions: return "📦"
        case .receipts: return "🧾"
        case .inventory: return "📦"
        case .timeline: return "📊"
        case .archive: return "📁"
        case .templates: return "📋"
        case .imports: return "📥"
        case .exports: return "📤"
        }
    }
    
    var shortcut: String {
        switch self {
        case .focus: return "1"
        case .planning: return "2"
        case .researching: return "3"
        case .techSpec: return "4"
        case .design: return "5"
        case .wireframes: return "6"
        case .frontend: return "7"
        case .backend: return "8"
        case .database: return "9"
        case .api: return "0"
        default: return ""
        }
    }
}

// MARK: - Sidebar
struct SidebarView: View {
    @Binding var selectedPanel: Panel
    
    var body: some View {
        List(selection: $selectedPanel) {
            Section("Core") {
                ForEach([Panel.focus, .ideas]) { panel in
                    Label(panel.rawValue, systemImage: panel.icon)
                        .tag(panel)
                }
            }
            Section("Planning") {
                ForEach([Panel.planning, .researching, .techSpec]) { panel in
                    Label(panel.rawValue, systemImage: panel.icon)
                        .tag(panel)
                }
            }
            Section("Design") {
                ForEach([Panel.design, .wireframes]) { panel in
                    Label(panel.rawValue, systemImage: panel.icon)
                        .tag(panel)
                }
            }
            Section("Development") {
                ForEach([Panel.frontend, .backend, .database, .api]) { panel in
                    Label(panel.rawValue, systemImage: panel.icon)
                        .tag(panel)
                }
            }
            Section("DevOps") {
                ForEach([Panel.cicd, .workflows]) { panel in
                    Label(panel.rawValue, systemImage: panel.icon)
                        .tag(panel)
                }
            }
            Section("Infrastructure") {
                ForEach([Panel.domains, .ip, .automation, .skills]) { panel in
                    Label(panel.rawValue, systemImage: panel.icon)
                        .tag(panel)
                }
            }
            Section("Business") {
                ForEach([Panel.metrics, .financials, .launches]) { panel in
                    Label(panel.rawValue, systemImage: panel.icon)
                        .tag(panel)
                }
            }
            Section("Operations") {
                ForEach([Panel.assets, .team, .settings, .shortcuts, .calendar, .todos, .notes, .history, .search, .reports, .integrations, .automation, .monitoring, .kb, .cli, .api, .domains, .competitors]) { panel in
                    Label(panel.rawValue, systemImage: panel.icon)
                        .tag(panel)
                }
            }
        }
        .listStyle(.sidebar)
        .navigationTitle("⚡ Control")
    }
}

// MARK: - Detail View
struct DetailView: View {
    let panel: Panel
    @ObservedObject var store: AppStore
    
    var body: some View {
        Group {
            switch panel {
            case .focus: FocusView(store: store)
            case .ideas: IdeasView(store: store)
            case .planning: PlanningView(store: store)
            case .researching: ResearchingView(store: store)
            case .techSpec: TechSpecView(store: store)
            case .design: DesignView(store: store)
            case .wireframes: WireframesView(store: store)
            case .frontend: FrontendView(store: store)
            case .backend: BackendView(store: store)
            case .database: DatabaseView(store: store)
            case .api: APIView(store: store)
            case .cicd: CICDView(store: store)
            case .workflows: WorkflowsView(store: store)
            case .domains: DomainsView(store: store)
            case .ip: IPPatentsView(store: store)
            case .automation: AutomationView(store: store)
            case .skills: SkillsView(store: store)
            case .metrics: MetricsView(store: store)
            case .financials: FinancialsView(store: store)
            case .launches: LaunchesView(store: store)
            case .assets: AssetsView(store: store)
            case .team: TeamView(store: store)
            case .settings: SettingsView(store: store)
            case .shortcuts: ShortcutsView()
            case .calendar: CalendarView(store: store)
            case .todos: TodosView(store: store)
            case .notes: NotesView(store: store)
            case .history: HistoryView(store: store)
            case .search: SearchView(store: store)
            case .reports: ReportsView(store: store)
            case .integrations: IntegrationsView(store: store)
            case .automation: AutomationView(store: store)
            case .monitoring: MonitoringView(store: store)
            case .kb: KnowledgeBaseView(store: store)
            case .cli: CLIToolsView(store: store)
            case .api: APIManagerView(store: store)
            case .domains: DomainsView(store: store)
            case .competitors: CompetitorsView(store: store)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Focus View (Full Featured)
struct FocusView: View {
    @ObservedObject var store: AppStore
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                // Header
                HStack {
                    Text("🎯 Focus Mode")
                        .font(.system(size: 32, weight: .bold))
                    Spacer()
                    Button("Edit") {
                        store.editingFlagship = true
                    }
                    .buttonStyle(.bordered)
                }
                
                // Flagship Card
                VStack(alignment: .leading, spacing: 12) {
                    Text("CURRENT FLAGSHIP")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)
                    
                    if store.editingFlagship {
                        TextField("Enter flagship project...", text: $store.flagship)
                            .textFieldStyle(.roundedBorder)
                            .font(.system(size: 24, weight: .semibold))
                            .onSubmit { store.editingFlagship = false }
                    } else {
                        Text(store.flagship)
                            .font(.system(size: 28, weight: .bold))
                            .foregroundStyle(.blue)
                            .onTapGesture { store.editingFlagship = true }
                    }
                }
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.blue.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                
                // Priorities
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("TOP PRIORITIES")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(.secondary)
                        Spacer()
                        Button("+ Add") {
                            store.priorities.append("")
                        }
                        .buttonStyle(.borderless)
                        .font(.caption)
                    }
                    
                    ForEach(Array(store.priorities.enumerated()), id: \.offset) { index, priority in
                        HStack {
                            Text("\(index + 1).")
                                .font(.headline)
                                .foregroundStyle(.secondary)
                                .frame(width: 24)
                            TextField("Priority \(index + 1)", text: $store.priorities[index])
                                .textFieldStyle(.plain)
                        }
                    }
                    
                    if store.priorities.isEmpty {
                        Text("No priorities set. Click + Add to start.")
                            .foregroundStyle(.secondary)
                            .font(.caption)
                    }
                }
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                
                // Quick Stats Grid
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    QuickStatCard(title: "Projects", value: "\(store.projects.count)", icon: "🚀", color: .blue)
                    QuickStatCard(title: "Domains", value: "\(store.domains.count)", icon: "🌐", color: .green)
                    QuickStatCard(title: "Patents", value: "\(store.patents.count)", icon: "🔬", color: .orange)
                    QuickStatCard(title: "Skills", value: "\(store.installedSkills.count)", icon: "🧩", color: .purple)
                }
                
                // Recent Activity
                if !store.recentActivity.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("RECENT ACTIVITY")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(.secondary)
                        
                        ForEach(store.recentActivity.prefix(5), id: \.self) { activity in
                            HStack {
                                Image(systemName: "clock")
                                    .font(.caption)
                                Text(activity)
                                    .font(.caption)
                            }
                        }
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                
                Spacer()
            }
            .padding(32)
        }
    }
}

struct QuickStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(icon)
                .font(.title2)
            Text(value)
                .font(.system(size: 24, weight: .bold))
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(color.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Ideas View
struct IdeasView: View {
    @ObservedObject var store: AppStore
    @State private var filterStatus: IdeaStatus? = nil
    
    var filteredIdeas: [Idea] {
        if let filter = filterStatus {
            return store.ideas.filter { $0.status == filter }
        }
        return store.ideas.sorted { $0.score > $1.score }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                HStack {
                    Text("💡 Ideas")
                        .font(.system(size: 32, weight: .bold))
                    Spacer()
                    
                    Picker("Status", selection: $filterStatus) {
                        Text("All").tag(IdeaStatus?.none)
                        ForEach(IdeaStatus.allCases, id: \.self) { status in
                            Text(status.rawValue).tag(IdeaStatus?.some(status))
                        }
                    }
                    .frame(width: 130)
                    
                    Button {
                        store.ideas.append(Idea(title: "New Idea", score: 5))
                    } label: {
                        Label("New Idea", systemImage: "plus")
                    }
                    .buttonStyle(.borderedProminent)
                }
                
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    StatBox(title: "Total", value: "\(store.ideas.count)", color: .blue)
                    StatBox(title: "Concept", value: "\(store.ideas.filter { $0.status == .concept }.count)", color: .gray)
                    StatBox(title: "Building", value: "\(store.ideas.filter { $0.status == .building }.count)", color: .orange)
                    StatBox(title: "Launched", value: "\(store.ideas.filter { $0.status == .launched }.count)", color: .green)
                }
                
                if filteredIdeas.isEmpty {
                    ContentUnavailableView("No Ideas", systemImage: "lightbulb", description: Text("Capture your next big idea"))
                } else {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach($store.ideas) { $idea in
                            IdeaCard(idea: $idea)
                        }
                    }
                }
            }
            .padding(32)
        }
    }
}

struct IdeaCard: View {
    @Binding var idea: Idea
    @State private var expanded = false
    
    var scoreColor: Color {
        if idea.score >= 8 { return .red }
        if idea.score >= 5 { return .orange }
        return .green
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    TextField("Title", text: $idea.title).font(.headline)
                    Text(idea.createdAt.formatted(date: .abbreviated, time: .omitted))
                        .font(.caption2).foregroundStyle(.secondary)
                }
                Spacer()
                VStack(spacing: 2) {
                    Text("\(idea.score)").font(.title3.bold()).foregroundStyle(scoreColor)
                    Text("score").font(.caption2).foregroundStyle(.secondary)
                }
            }
            
            TextField("Description", text: $idea.description, axis: .vertical)
                .lineLimit(expanded ? 5 : 2).font(.subheadline)
            
            if expanded {
                HStack {
                    Text("Score:").font(.caption)
                    Slider(value: Binding(get: { Double(idea.score) }, set: { idea.score = Int($0) }), in: 1...10, step: 1).tint(scoreColor)
                }
                Picker("Status", selection: $idea.status) {
                    ForEach(IdeaStatus.allCases, id: \.self) { status in Text(status.rawValue).tag(status) }
                }.pickerStyle(.segmented)
            }
            
            HStack {
                Button { withAnimation { expanded.toggle() } } label: {
                    Image(systemName: expanded ? "chevron.up" : "chevron.down")
                }.buttonStyle(.borderless)
                Spacer()
                ForEach([3, 5, 8], id: \.self) { score in
                    Button("\(score)") { idea.score = score }.font(.caption2).buttonStyle(.bordered).tint(idea.score == score ? .blue : .gray)
                }
            }
        }
        .padding(16).background(Color.gray.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct StatBox: View {
    let title: String
    let value: String
    let color: Color
    var body: some View {
        VStack(spacing: 4) {
            Text(value).font(.title2.bold()).foregroundStyle(color)
            Text(title).font(.caption).foregroundStyle(.secondary)
        }
        .padding(12).frame(maxWidth: .infinity).background(color.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

// MARK: - Planning View
struct PlanningView: View {
    @ObservedObject var store: AppStore
    @State private var filterStatus: ProjectStatus? = nil
    
    var filteredProjects: [Project] {
        if let filter = filterStatus {
            return store.projects.filter { $0.status == filter }
        }
        return store.projects
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Header
            HStack {
                Text("📋 Planning")
                    .font(.system(size: 32, weight: .bold))
                Spacer()
                
                // Filter
                Picker("Status", selection: $filterStatus) {
                    Text("All").tag(ProjectStatus?.none)
                    ForEach(ProjectStatus.allCases, id: \.self) { status in
                        Text(status.rawValue).tag(ProjectStatus?.some(status))
                    }
                }
                .frame(width: 120)
                
                Button {
                    store.addProject(Project(name: "New Project"))
                } label: {
                    Label("New Project", systemImage: "plus")
                }
                .buttonStyle(.borderedProminent)
            }
            
            // Stats
            HStack(spacing: 16) {
                ForEach(ProjectStatus.allCases, id: \.self) { status in
                    let count = store.projects.filter { $0.status == status }.count
                    VStack(spacing: 4) {
                        Text("\(count)")
                            .font(.title2.bold())
                        Text(status.rawValue)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(12)
                    .frame(maxWidth: .infinity)
                    .background(statusColor(status).opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
            
            // Projects List
            if filteredProjects.isEmpty {
                ContentUnavailableView(
                    "No Projects",
                    systemImage: "folder.badge.plus",
                    description: Text("Create your first project to get started")
                )
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach($store.projects) { $project in
                            ProjectCard(project: $project, store: store)
                        }
                    }
                }
            }
        }
        .padding(32)
    }
    
    func statusColor(_ status: ProjectStatus) -> Color {
        switch status {
        case .planning: return .gray
        case .active: return .green
        case .onHold: return .orange
        case .completed: return .blue
        case .cancelled: return .red
        }
    }
}

struct Project: Identifiable, Codable {
    var id: UUID = UUID()
    var name: String = ""
    var description: String = ""
    var status: ProjectStatus = .planning
    var priority: Int = 5
    var stage: ProjectStage = .planning
    var dueDate: Date = Date().addingTimeInterval(86400 * 30)
    var createdAt: Date = Date()
    var notes: String = ""
    
    var daysUntilDue: Int {
        Calendar.current.dateComponents([.day], from: Date(), to: dueDate).day ?? 0
    }
}

enum ProjectStatus: String, Codable, CaseIterable {
    case planning = "Planning"
    case active = "Active"
    case onHold = "On Hold"
    case completed = "Completed"
    case cancelled = "Cancelled"
}

enum ProjectStage: String, Codable, CaseIterable {
    case planning = "Planning"
    case researching = "Researching"
    case techSpec = "Tech Spec"
    case design = "Design"
    case wireframes = "Wireframes"
    case frontend = "Frontend"
    case backend = "Backend"
    case testing = "Testing"
    case deployment = "Deployment"
    case completed = "Completed"
    
    var icon: String {
        switch self {
        case .planning: return "📋"
        case .researching: return "🔍"
        case .techSpec: return "📝"
        case .design: return "🎨"
        case .wireframes: return "📐"
        case .frontend: return "💻"
        case .backend: return "⚙️"
        case .testing: return "🧪"
        case .deployment: return "🚀"
        case .completed: return "✅"
        }
    }
}

struct ProjectCard: View {
    @Binding var project: Project
    @ObservedObject var store: AppStore
    @State private var expanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                // Stage Icon
                Text(project.stage.icon)
                    .font(.title2)
                
                VStack(alignment: .leading, spacing: 2) {
                    TextField("Project Name", text: $project.name)
                        .font(.headline)
                    Text("Created \(project.createdAt.formatted(date: .abbreviated, time: .omitted))")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                // Due Date Badge
                if project.daysUntilDue >= 0 {
                    Text("\(project.daysUntilDue)d")
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(project.daysUntilDue < 7 ? Color.red.opacity(0.2) : Color.gray.opacity(0.2))
                        .clipShape(Capsule())
                }
                
                // Priority
                HStack(spacing: 2) {
                    ForEach(1...10, id: \.self) { n in
                        Circle()
                            .fill(n <= project.priority ? priorityColor : Color.gray.opacity(0.3))
                            .frame(width: 6, height: 6)
                    }
                }
                
                // Expand Toggle
                Button {
                    withAnimation { expanded.toggle() }
                } label: {
                    Image(systemName: expanded ? "chevron.up" : "chevron.down")
                }
                .buttonStyle(.borderless)
            }
            
            // Expanded Content
            if expanded {
                Divider()
                
                VStack(alignment: .leading, spacing: 12) {
                    // Description
                    TextField("Description", text: $project.description, axis: .vertical)
                        .lineLimit(2...4)
                    
                    // Stage & Status
                    HStack {
                        Picker("Stage", selection: $project.stage) {
                            ForEach(ProjectStage.allCases, id: \.self) { stage in
                                Text(stage.rawValue).tag(stage)
                            }
                        }
                        .frame(width: 140)
                        
                        Picker("Status", selection: $project.status) {
                            ForEach(ProjectStatus.allCases, id: \.self) { status in
                                Text(status.rawValue).tag(status)
                            }
                        }
                        .frame(width: 120)
                        
                        Spacer()
                        
                        DatePicker("Due", selection: $project.dueDate, displayedComponents: .date)
                    }
                    
                    // Notes
                    TextField("Notes", text: $project.notes, axis: .vertical)
                        .lineLimit(3...6)
                    
                    // Actions
                    HStack {
                        Spacer()
                        Button(role: .destructive) {
                            store.deleteProject(project)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                        .buttonStyle(.borderless)
                    }
                }
            }
        }
        .padding(16)
        .background(Color.gray.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    var priorityColor: Color {
        if project.priority >= 8 { return .red }
        if project.priority >= 5 { return .orange }
        return .green
    }
}

// MARK: - Researching View
struct ResearchingView: View {
    @ObservedObject var store: AppStore
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                HStack {
                    Text("🔍 Researching")
                        .font(.system(size: 32, weight: .bold))
                    Spacer()
                }
                
                // Categories Grid
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ResearchCategoryCard(
                        title: "Competitors",
                        icon: "building.2",
                        color: .blue,
                        items: $store.competitors
                    )
                    ResearchCategoryCard(
                        title: "Technologies",
                        icon: "cpu",
                        color: .purple,
                        items: $store.technologies
                    )
                    ResearchCategoryCard(
                        title: "Market Trends",
                        icon: "chart.line.uptrend.xyaxis",
                        color: .green,
                        items: $store.marketTrends
                    )
                    ResearchCategoryCard(
                        title: "User Insights",
                        icon: "person.2",
                        color: .orange,
                        items: $store.userInsights
                    )
                }
            }
            .padding(32)
        }
    }
}

struct ResearchCategoryCard: View {
    let title: String
    let icon: String
    let color: Color
    @Binding var items: [String]
    @State private var newItem: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(color)
                Text(title)
                    .font(.headline)
                Spacer()
                Text("\(items.count)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            if items.isEmpty {
                Text("No items")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            } else {
                ForEach(items.prefix(5), id: \.self) { item in
                    HStack {
                        Image(systemName: "circle.fill")
                            .font(.caption2)
                        Text(item)
                            .font(.caption)
                    }
                }
                if items.count > 5 {
                    Text("+\(items.count - 5) more")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            
            // Add Item
            HStack {
                TextField("Add \(title.lowercased())...", text: $newItem)
                    .textFieldStyle(.roundedBorder)
                    .font(.caption)
                Button {
                    if !newItem.isEmpty {
                        items.append(newItem)
                        newItem = ""
                    }
                } label: {
                    Image(systemName: "plus.circle.fill")
                }
                .buttonStyle(.borderless)
                .disabled(newItem.isEmpty)
            }
        }
        .padding(16)
        .background(color.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Tech Spec View
struct TechSpecView: View {
    @ObservedObject var store: AppStore
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("📝 Tech Spec")
                    .font(.system(size: 32, weight: .bold))
                
                LazyVStack(spacing: 16) {
                    TechSpecSectionView(title: "Architecture", icon: "building.2", color: .blue, items: $store.techSpec.architecture)
                    TechSpecSectionView(title: "Tech Stack", icon: "stack", color: .purple, items: $store.techSpec.techStack)
                    TechSpecSectionView(title: "Security", icon: "lock.shield", color: .red, items: $store.techSpec.security)
                    TechSpecSectionView(title: "Performance", icon: "speedometer", color: .green, items: $store.techSpec.performance)
                    TechSpecSectionView(title: "Infrastructure", icon: "server.rack", color: .orange, items: $store.techSpec.infrastructure)
                }
            }
            .padding(32)
        }
    }
}

struct TechSpecSectionView: View {
    let title: String
    let icon: String
    let color: Color
    @Binding var items: [String]
    @State private var newItem: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(color)
                Text(title)
                    .font(.headline)
                Spacer()
                Text("\(items.count)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            ForEach(items, id: \.self) { item in
                HStack {
                    Image(systemName: "doc.text")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(item)
                        .font(.subheadline)
                }
            }
            
            HStack {
                TextField("Add \(title.lowercased())...", text: $newItem)
                    .textFieldStyle(.roundedBorder)
                    .font(.caption)
                Button {
                    if !newItem.isEmpty {
                        items.append(newItem)
                        newItem = ""
                    }
                } label: {
                    Image(systemName: "plus")
                }
                .buttonStyle(.borderless)
            }
        }
        .padding(16)
        .background(Color.gray.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Design View
struct DesignView: View {
    @ObservedObject var store: AppStore
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("🎨 Design")
                    .font(.system(size: 32, weight: .bold))
                
                // Color Palette
                VStack(alignment: .leading, spacing: 12) {
                    Text("Colors")
                        .font(.headline)
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))], spacing: 12) {
                        ForEach(store.designSystem.colors, id: \.self) { color in
                            VStack(spacing: 4) {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color(hex: color) ?? .gray)
                                    .frame(height: 50)
                                Text(color)
                                    .font(.caption2)
                            }
                        }
                        // Add Color Button
                        Button {
                            store.designSystem.colors.append("#FFFFFF")
                        } label: {
                            RoundedRectangle(cornerRadius: 8)
                                .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [5]))
                                .frame(height: 50)
                                .overlay {
                                    Image(systemName: "plus")
                                }
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(16)
                .background(Color.gray.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                // Typography
                VStack(alignment: .leading, spacing: 12) {
                    Text("Typography")
                        .font(.headline)
                    ForEach(store.designSystem.fonts, id: \.self) { font in
                        HStack {
                            Text(font)
                            Spacer()
                        }
                    }
                    // Add Font
                    Button("+ Add Font") {
                        store.designSystem.fonts.append("New Font")
                    }
                    .buttonStyle(.borderless)
                }
                .padding(16)
                .background(Color.gray.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                // Components
                VStack(alignment: .leading, spacing: 12) {
                    Text("Components")
                        .font(.headline)
                    if store.designSystem.components.isEmpty {
                        Text("No components defined")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(store.designSystem.components, id: \.self) { component in
                            HStack {
                                Image(systemName: "square.on.square")
                                Text(component)
                            }
                        }
                    }
                    Button("+ Add Component") {
                        store.designSystem.components.append("New Component")
                    }
                    .buttonStyle(.borderless)
                }
                .padding(16)
                .background(Color.gray.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(32)
        }
    }
}

// MARK: - Wireframes View
struct WireframesView: View {
    @ObservedObject var store: AppStore
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                HStack {
                    Text("📐 Wireframes")
                        .font(.system(size: 32, weight: .bold))
                    Spacer()
                    Button("+ New") {
                        store.wireframes.append(Wireframe(name: "New Wireframe", page: "Home"))
                    }
                    .buttonStyle(.borderedProminent)
                }
                
                if store.wireframes.isEmpty {
                    ContentUnavailableView("No Wireframes", systemImage: "rectangle.split.3x3", description: Text("Create wireframes to visualize your UI"))
                } else {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach($store.wireframes) { $wireframe in
                            WireframeCard(wireframe: $wireframe)
                        }
                    }
                }
            }
            .padding(32)
        }
    }
}

struct Wireframe: Identifiable, Codable {
    var id: UUID = UUID()
    var name: String = ""
    var page: String = ""
    var notes: String = ""
}

struct WireframeCard: View {
    @Binding var wireframe: Wireframe
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Placeholder
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.15))
                .frame(height: 120)
                .overlay {
                    Image(systemName: "rectangle.split.3x3")
                        .font(.largeTitle)
                        .foregroundStyle(.secondary)
                }
            
            TextField("Name", text: $wireframe.name)
                .font(.headline)
            TextField("Page", text: $wireframe.page)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(12)
        .background(Color.gray.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Frontend View
struct FrontendView: View {
    @ObservedObject var store: AppStore
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("💻 Frontend")
                    .font(.system(size: 32, weight: .bold))
                
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    TechStackSection(title: "Frameworks", icon: "square.stack.3d.up", items: $store.frontend.frameworks)
                    TechStackSection(title: "Styling", icon: "paintbrush", items: $store.frontend.styling)
                    TechStackSection(title: "State Management", icon: "arrow.triangle.2.circlepath", items: $store.frontend.state)
                    TechStackSection(title: "Testing", icon: "checkmark.shield", items: $store.frontend.testing)
                    TechStackSection(title: "Build Tools", icon: "hammer", items: $store.frontend.buildTools)
                    TechStackSection(title: "Components", icon: "square.on.square", items: $store.frontend.components)
                }
            }
            .padding(32)
        }
    }
}

struct TechStackSection: View {
    let title: String
    let icon: String
    @Binding var items: [String]
    @State private var newItem: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                Text(title)
                    .font(.headline)
            }
            
            ForEach(items, id: \.self) { item in
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                        .font(.caption)
                    Text(item)
                        .font(.subheadline)
                }
            }
            
            HStack {
                TextField("Add...", text: $newItem)
                    .textFieldStyle(.roundedBorder)
                    .font(.caption)
                Button {
                    if !newItem.isEmpty {
                        items.append(newItem)
                        newItem = ""
                    }
                } label: {
                    Image(systemName: "plus")
                }
                .buttonStyle(.borderless)
            }
        }
        .padding(16)
        .background(Color.gray.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Backend View
struct BackendView: View {
    @ObservedObject var store: AppStore
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("⚙️ Backend")
                    .font(.system(size: 32, weight: .bold))
                
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    TechStackSection(title: "Languages", icon: "chevron.left.forwardslash.chevron.right", items: $store.backend.languages)
                    TechStackSection(title: "Frameworks", icon: "square.stack.3d.up", items: $store.backend.frameworks)
                    TechStackSection(title: "Services", icon: "cloud", items: $store.backend.services)
                    TechStackSection(title: "Authentication", icon: "lock.shield", items: $store.backend.auth)
                }
            }
            .padding(32)
        }
    }
}

// MARK: - Database View
struct DatabaseView: View {
    @ObservedObject var store: AppStore
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                HStack {
                    Text("🗄️ Database")
                        .font(.system(size: 32, weight: .bold))
                    Spacer()
                    Button("+ Add") {
                        store.databases.append(DatabaseModel(name: "New Database", type: "PostgreSQL", host: "localhost"))
                    }
                    .buttonStyle(.borderedProminent)
                }
                
                if store.databases.isEmpty {
                    ContentUnavailableView("No Databases", systemImage: "cylinder", description: Text("Add databases to track"))
                } else {
                    LazyVStack(spacing: 12) {
                        ForEach($store.databases) { $db in
                            DatabaseCard(database: $db, store: store)
                        }
                    }
                }
            }
            .padding(32)
        }
    }
}

struct DatabaseModel: Identifiable, Codable {
    var id: UUID = UUID()
    var name: String = ""
    var type: String = "PostgreSQL"
    var host: String = "localhost"
    var port: Int = 5432
    var status: String = "Active"
}

struct DatabaseCard: View {
    @Binding var database: DatabaseModel
    @ObservedObject var store: AppStore
    
    var body: some View {
        HStack {
            Image(systemName: "cylinder.fill")
                .font(.title2)
                .foregroundStyle(.blue)
            
            VStack(alignment: .leading, spacing: 2) {
                TextField("Name", text: $database.name)
                    .font(.headline)
                Text("\(database.type) • \(database.host):\(database.port)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Picker("Status", selection: $database.status) {
                Text("Active").tag("Active")
                Text("Inactive").tag("Inactive")
                Text("Maintenance").tag("Maintenance")
            }
            .frame(width: 100)
            
            Button(role: .destructive) {
                store.deleteDatabase(database)
            } label: {
                Image(systemName: "trash")
            }
            .buttonStyle(.borderless)
        }
        .padding(16)
        .background(Color.gray.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - API View
struct APIView: View {
    @ObservedObject var store: AppStore
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                HStack {
                    Text("🔌 API")
                        .font(.system(size: 32, weight: .bold))
                    Spacer()
                    Button("+ Add") {
                        store.apis.append(APIModel(name: "New API", endpoint: "/api/v1", method: "GET"))
                    }
                    .buttonStyle(.borderedProminent)
                }
                
                if store.apis.isEmpty {
                    ContentUnavailableView("No APIs", systemImage: "network", description: Text("Add APIs to track"))
                } else {
                    LazyVStack(spacing: 12) {
                        ForEach($store.apis) { $api in
                            APICard(api: $api, store: store)
                        }
                    }
                }
            }
            .padding(32)
        }
    }
}

struct APIModel: Identifiable, Codable {
    var id: UUID = UUID()
    var name: String = ""
    var endpoint: String = ""
    var method: String = "GET"
    var status: String = "Active"
    var description: String = ""
}

struct APICard: View {
    @Binding var api: APIModel
    @ObservedObject var store: AppStore
    
    var body: some View {
        HStack {
            Text(api.method)
                .font(.caption.bold())
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(methodColor(api.method))
                .clipShape(Capsule())
            
            VStack(alignment: .leading, spacing: 2) {
                TextField("Name", text: $api.name)
                    .font(.headline)
                TextField("Endpoint", text: $api.endpoint)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Picker("Status", selection: $api.status) {
                Text("Active").tag("Active")
                Text("Deprecated").tag("Deprecated")
            }
            .frame(width: 100)
            
            Button(role: .destructive) {
                store.deleteAPI(api)
            } label: {
                Image(systemName: "trash")
            }
            .buttonStyle(.borderless)
        }
        .padding(16)
        .background(Color.gray.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    func methodColor(_ method: String) -> Color {
        switch method.uppercased() {
        case "GET": return .blue.opacity(0.3)
        case "POST": return .green.opacity(0.3)
        case "PUT", "PATCH": return .orange.opacity(0.3)
        case "DELETE": return .red.opacity(0.3)
        default: return .gray.opacity(0.3)
        }
    }
}

// MARK: - CI/CD View
struct CICDView: View {
    @ObservedObject var store: AppStore
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("🔄 CI/CD")
                    .font(.system(size: 32, weight: .bold))
                
                // Stats Cards
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    CICDStatCard(title: "Pipelines", value: "\(store.cicd.pipelines)", icon: "arrow.triangle.branch", color: .blue)
                    CICDStatCard(title: "Tests", value: "\(store.cicd.tests)", icon: "checkmark.shield", color: .green)
                    CICDStatCard(title: "Deployments", value: "\(store.cicd.deployments)", icon: "rocket", color: .orange)
                    CICDStatCard(title: "Status", value: store.cicd.passes ? "✅ Pass" : "❌ Fail", icon: store.cicd.passes ? "checkmark.circle.fill" : "xmark.circle.fill", color: store.cicd.passes ? .green : .red)
                }
                
                // Pipeline List
                if !store.cicd.pipelineNames.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Pipelines")
                            .font(.headline)
                        ForEach(store.cicd.pipelineNames, id: \.self) { name in
                            HStack {
                                Circle()
                                    .fill(store.cicd.passes ? .green : .red)
                                    .frame(width: 8, height: 8)
                                Text(name)
                                Spacer()
                            }
                            .padding(8)
                            .background(Color.gray.opacity(0.08))
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                        }
                    }
                    .padding(16)
                    .background(Color.gray.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .padding(32)
        }
    }
}

struct CICDStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)
            Text(value)
                .font(.title3.bold())
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(color.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Workflows View
struct WorkflowsView: View {
    @ObservedObject var store: AppStore
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                HStack {
                    Text("🔗 Workflows")
                        .font(.system(size: 32, weight: .bold))
                    Spacer()
                    Button("+ New Workflow") {
                        store.workflows.append(Workflow(name: "New Workflow", type: "automation"))
                    }
                    .buttonStyle(.borderedProminent)
                }
                
                if store.workflows.isEmpty {
                    ContentUnavailableView("No Workflows", systemImage: "arrow.triangle.swap", description: Text("Create automation workflows"))
                } else {
                    LazyVStack(spacing: 12) {
                        ForEach($store.workflows) { $workflow in
                            WorkflowCard(workflow: $workflow, store: store)
                        }
                    }
                }
            }
            .padding(32)
        }
    }
}

struct Workflow: Identifiable, Codable {
    var id: UUID = UUID()
    var name: String = ""
    var type: String = "automation"
    var status: String = "Draft"
    var lastRun: Date?
    var trigger: String = ""
    var actions: [String] = []
}

struct WorkflowCard: View {
    @Binding var workflow: Workflow
    @ObservedObject var store: AppStore
    
    var body: some View {
        HStack {
            Image(systemName: "arrow.triangle.swap")
                .font(.title2)
                .foregroundStyle(.blue)
            
            VStack(alignment: .leading, spacing: 2) {
                TextField("Name", text: $workflow.name)
                    .font(.headline)
                HStack {
                    Text(workflow.type.capitalized)
                    Text("•")
                    Text(workflow.status)
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            if let lastRun = workflow.lastRun {
                Text("Last: \(lastRun.formatted(date: .abbreviated, time: .shortened))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Button(role: .destructive) {
                store.deleteWorkflow(workflow)
            } label: {
                Image(systemName: "trash")
            }
            .buttonStyle(.borderless)
        }
        .padding(16)
        .background(Color.gray.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Domains View
struct DomainsView: View {
    @ObservedObject var store: AppStore
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                HStack {
                    Text("🌐 Domains")
                        .font(.system(size: 32, weight: .bold))
                    Spacer()
                    Button("+ Add Domain") {
                        store.domains.append(Domain(name: "newdomain.com", registrar: "Cloudflare"))
                    }
                    .buttonStyle(.borderedProminent)
                }
                
                // Stats
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    DomainStatCard(title: "Total", count: store.domains.count, color: .blue)
                    DomainStatCard(title: "Active", count: store.domains.filter { $0.status == "Active" }.count, color: .green)
                    DomainStatCard(title: "Expiring Soon", count: store.expiringDomains.count, color: .orange)
                }
                
                // Expiring Soon Alert
                if !store.expiringDomains.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Expiring Soon", systemImage: "exclamationmark.triangle")
                            .font(.headline)
                            .foregroundStyle(.orange)
                        ForEach(store.expiringDomains) { domain in
                            Text("\(domain.name) - expires \(domain.expiryDate.formatted(date: .abbreviated, time: .omitted))")
                                .font(.caption)
                        }
                    }
                    .padding(16)
                    .background(Color.orange.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                
                // Domain List
                if store.domains.isEmpty {
                    ContentUnavailableView("No Domains", systemImage: "globe", description: Text("Add domains to track"))
                } else {
                    LazyVStack(spacing: 12) {
                        ForEach($store.domains) { $domain in
                            DomainCard(domain: $domain, store: store)
                        }
                    }
                }
            }
            .padding(32)
        }
    }
}

struct Domain: Identifiable, Codable {
    var id: UUID = UUID()
    var name: String = ""
    var registrar: String = "Cloudflare"
    var dnsProvider: String = "Cloudflare"
    var status: String = "Active"
    var expiryDate: Date = Date().addingTimeInterval(86400 * 365)
    var notes: String = ""
    
    var daysUntilExpiry: Int {
        Calendar.current.dateComponents([.day], from: Date(), to: expiryDate).day ?? 0
    }
}

struct DomainStatCard: View {
    let title: String
    let count: Int
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text("\(count)")
                .font(.title2.bold())
                .foregroundStyle(color)
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(color.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct DomainCard: View {
    @Binding var domain: Domain
    @ObservedObject var store: AppStore
    
    var body: some View {
        HStack {
            Image(systemName: "globe")
                .font(.title2)
                .foregroundStyle(.blue)
            
            VStack(alignment: .leading, spacing: 2) {
                TextField("Domain", text: $domain.name)
                    .font(.headline)
                Text("\(domain.registrar) • \(domain.dnsProvider)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Picker("Status", selection: $domain.status) {
                    Text("Active").tag("Active")
                    Text("Expired").tag("Expired")
                    Text("Transfer").tag("Transfer")
                }
                .frame(width: 90)
                
                Text("\(domain.daysUntilExpiry)d")
                    .font(.caption)
                    .foregroundStyle(domain.daysUntilExpiry < 30 ? .orange : .secondary)
            }
            
            Button(role: .destructive) {
                store.deleteDomain(domain)
            } label: {
                Image(systemName: "trash")
            }
            .buttonStyle(.borderless)
        }
        .padding(16)
        .background(Color.gray.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - IP/Patents View (Full Featured)
struct IPPatentsView: View {
    @ObservedObject var store: AppStore
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                HStack {
                    Text("🔬 IP/Patents")
                        .font(.system(size: 32, weight: .bold))
                    Spacer()
                    Button("+ Add Patent") {
                        store.patents.append(PatentModel(title: "New Patent", type: .provisional))
                    }
                    .buttonStyle(.borderedProminent)
                }
                
                // Stats
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    StatCard(title: "Total", value: "\(store.patents.count)", color: .blue)
                    StatCard(title: "Provisional", value: "\(store.patents.filter { $0.type == .provisional }.count)", color: .orange)
                    StatCard(title: "Utilities", value: "\(store.patents.filter { $0.type == .utility }.count)", color: .purple)
                    StatCard(title: "Total Costs", value: "$\(Int(store.totalPatentCosts))", color: .green)
                }
                
                // Deadlines
                if !store.patentDeadlines.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Upcoming Deadlines", systemImage: "calendar.badge.exclamationmark")
                            .font(.headline)
                        ForEach(store.patentDeadlines) { deadline in
                            HStack {
                                Text(deadline.title)
                                    .font(.subheadline)
                                Spacer()
                                Text("\(deadline.daysRemaining)d")
                                    .font(.caption)
                                    .foregroundStyle(deadline.daysRemaining < 30 ? .red : .orange)
                            }
                        }
                    }
                    .padding(16)
                    .background(Color.red.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                
                // Patent List
                if store.patents.isEmpty {
                    ContentUnavailableView("No Patents", systemImage: "doc.text", description: Text("Add patents to track"))
                } else {
                    LazyVStack(spacing: 12) {
                        ForEach($store.patents) { $patent in
                            PatentCard(patent: $patent, store: store)
                        }
                    }
                }
            }
            .padding(32)
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title2.bold())
                .foregroundStyle(color)
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(color.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct PatentModel: Identifiable, Codable {
    var id: UUID = UUID()
    var title: String = ""
    var type: PatentTypeModel = .provisional
    var status: PatentStatusModel = .draft
    var filingDate: Date = Date()
    var attorneyCost: Double = 0
    var otherCost: Double = 0
    var notes: String = ""
    
    // 2026 USPTO Fees (micro entity)
    var usptoFee: Double {
        switch type {
        case .provisional: return 65
        case .utility: return 658
        case .design: return 60
        }
    }
    
    var totalCost: Double {
        usptoFee + attorneyCost + otherCost
    }
    
    var continuationDeadline: Date {
        Calendar.current.date(byAdding: .month, value: 12, to: filingDate) ?? filingDate
    }
}

enum PatentTypeModel: String, Codable, CaseIterable {
    case provisional = "Provisional"
    case utility = "Utility"
    case design = "Design"
}

enum PatentStatusModel: String, Codable, CaseIterable {
    case draft = "Draft"
    case filed = "Filed"
    case pending = "Pending"
    case granted = "Granted"
    case abandoned = "Abandoned"
}

struct PatentDeadline: Identifiable {
    let id = UUID()
    let patentId: UUID
    let title: String
    let date: Date
    
    var daysRemaining: Int {
        Calendar.current.dateComponents([.day], from: Date(), to: date).day ?? 0
    }
}

struct PatentCard: View {
    @Binding var patent: PatentModel
    @ObservedObject var store: AppStore
    @State private var expanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    TextField("Title", text: $patent.title)
                        .font(.headline)
                    Text("\(patent.type.rawValue) • \(patent.status.rawValue)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Text("$\(Int(patent.totalCost))")
                    .font(.title3.bold())
                    .foregroundStyle(.green)
                
                Button {
                    withAnimation { expanded.toggle() }
                } label: {
                    Image(systemName: expanded ? "chevron.up" : "chevron.down")
                }
                .buttonStyle(.borderless)
            }
            
            if expanded {
                Divider()
                
                HStack {
                    Picker("Type", selection: $patent.type) {
                        ForEach(PatentTypeModel.allCases, id: \.self) { $0 }
                    }
                    .frame(width: 120)
                    
                    Picker("Status", selection: $patent.status) {
                        ForEach(PatentStatusModel.allCases, id: \.self) { $0 }
                    }
                    .frame(width: 100)
                    
                    DatePicker("Filed", selection: $patent.filingDate, displayedComponents: .date)
                }
                
                HStack {
                    Text("USPTO: $\(Int(patent.usptoFee))")
                        .font(.caption)
                    Text("Attorney:")
                        .font(.caption)
                    TextField("0", value: $patent.attorneyCost, format: .currency(code: "USD"))
                        .frame(width: 80)
                    Text("Other:")
                        .font(.caption)
                    TextField("0", value: $patent.otherCost, format: .currency(code: "USD"))
                        .frame(width: 80)
                }
                
                TextField("Notes", text: $patent.notes, axis: .vertical)
                    .lineLimit(2)
                
                HStack {
                    Spacer()
                    Button(role: .destructive) {
                        store.deletePatent(patent)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                    .buttonStyle(.borderless)
                }
            }
        }
        .padding(16)
        .background(Color.gray.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Automation View
struct AutomationView: View {
    @ObservedObject var store: AppStore
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("🤖 Automation")
                    .font(.system(size: 32, weight: .bold))
                
                // Zimaboard
                AutomationServiceCard(
                    title: "Zimaboard",
                    subtitle: "16GB Server",
                    status: store.zimaboard.online ? "Online" : "Offline",
                    ip: "192.168.4.65",
                    services: ["ZimaOS", "Portainer", "SSH"],
                    online: store.zimaboard.online
                )
                
                // N8N
                AutomationServiceCard(
                    title: "N8N",
                    subtitle: "Workflow Engine",
                    status: store.zimaboard.n8nReady ? "Ready" : "Not Deployed",
                    ip: "192.168.4.65:5678",
                    services: store.zimaboard.n8nWorkflows,
                    online: store.zimaboard.n8nReady
                )
                
                // Actions
                HStack {
                    Button("Check Status") {
                        store.checkZimaboardStatus()
                    }
                    .buttonStyle(.bordered)
                    
                    Button("Open Portainer") {
                        store.openURL("http://192.168.4.65:9000")
                    }
                    .buttonStyle(.bordered)
                }
            }
            .padding(32)
        }
    }
}

struct AutomationServiceCard: View {
    let title: String
    let subtitle: String
    let status: String
    let ip: String
    let services: [String]
    let online: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.headline)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                HStack(spacing: 6) {
                    Circle()
                        .fill(online ? .green : .orange)
                        .frame(width: 8, height: 8)
                    Text(status)
                        .font(.caption)
                }
            }
            
            Text(ip)
                .font(.caption)
                .foregroundStyle(.tertiary)
            
            Divider()
            
            ForEach(services, id: \.self) { service in
                HStack {
                    Image(systemName: "circle.fill")
                        .font(.caption2)
                    Text(service)
                        .font(.caption)
                }
            }
        }
        .padding(20)
        .background(Color.gray.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Skills View
struct SkillsView: View {
    @ObservedObject var store: AppStore
    @State private var selectedCategory: String = "All"
    
    let categories = ["All", "Development", "Productivity", "AI/ML", "DevOps", "Communication", "Design"]
    
    var filteredSkills: [InstalledSkill] {
        if selectedCategory == "All" {
            return store.installedSkills
        }
        return store.installedSkills.filter { $0.category == selectedCategory }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                HStack {
                    Text("🧩 Skills")
                        .font(.system(size: 32, weight: .bold))
                    Spacer()
                    Button {
                        store.loadSkills()
                    } label: {
                        Label("Refresh", systemImage: "arrow.clockwise")
                    }
                    .buttonStyle(.bordered)
                }
                
                // Category Filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(categories, id: \.self) { category in
                            Button(category) {
                                selectedCategory = category
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(selectedCategory == category ? .blue : .gray)
                        }
                    }
                }
                
                // Stats
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    SkillStatCard(title: "Total", count: store.installedSkills.count, color: .blue)
                    SkillStatCard(title: "DevOps", count: store.installedSkills.filter { $0.category == "DevOps" }.count, color: .orange)
                    SkillStatCard(title: "AI/ML", count: store.installedSkills.filter { $0.category == "AI/ML" }.count, color: .purple)
                    SkillStatCard(title: "Design", count: store.installedSkills.filter { $0.category == "Design" }.count, color: .pink)
                }
                
                // Skills Grid
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    ForEach(filteredSkills) { skill in
                        SkillCardView(skill: skill)
                    }
                }
            }
            .padding(32)
        }
        .onAppear { store.loadSkills() }
    }
}

struct SkillStatCard: View {
    let title: String
    let count: Int
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text("\(count)")
                .font(.title2.bold())
                .foregroundStyle(color)
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(12)
        .frame(maxWidth: .infinity)
        .background(color.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct SkillCardView: View {
    let skill: InstalledSkill
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(skill.icon)
                    .font(.title2)
                VStack(alignment: .leading) {
                    Text(skill.name)
                        .font(.subheadline.bold())
                    Text(skill.category)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
            
            Text(skill.description)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(2)
        }
        .padding(12)
        .background(Color.gray.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

// MARK: - Metrics View
struct MetricsView: View {
    @ObservedObject var store: AppStore
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                HStack {
                    Text("📊 Metrics")
                        .font(.system(size: 32, weight: .bold))
                    Spacer()
                    Button {
                        store.metrics.lastUpdated = Date()
                        store.save()
                    } label: {
                        Label("Refresh", systemImage: "arrow.clockwise")
                    }
                    .buttonStyle(.bordered)
                }
                
                // Key Metrics
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    MetricCard(title: "Active Projects", value: "\(store.metrics.activeProjects)", icon: "folder.fill", color: .blue, trend: "+2")
                    MetricCard(title: "Completed", value: "\(store.metrics.completedProjects)", icon: "checkmark.circle.fill", color: .green, trend: "+5")
                    MetricCard(title: "Active Users", value: "\(store.metrics.activeUsers)", icon: "person.2.fill", color: .purple, trend: "+12%")
                    MetricCard(title: "Trial Users", value: "\(store.metrics.trialUsers)", icon: "person.badge.plus", color: .orange, trend: "+8")
                }
                
                // Revenue Metrics
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    BigMetricCard(title: "Monthly Recurring Revenue", value: "$\(Int(store.metrics.monthlyRecurringRevenue))", subtitle: "+15% this month", color: .green)
                    BigMetricCard(title: "Total Revenue", value: "$\(Int(store.metrics.totalRevenue))", subtitle: "All time", color: .blue)
                }
                
                // Product Metrics
                VStack(alignment: .leading, spacing: 16) {
                    Text("Product Health")
                        .font(.headline)
                    
                    HStack(spacing: 24) {
                        GaugeView(value: store.metrics.uptime, title: "Uptime", suffix: "%", color: .green)
                        GaugeView(value: store.metrics.nps + 100, title: "NPS", suffix: "", range: 0...200, color: .blue)
                        GaugeView(value: store.metrics.errorRate * 100, title: "Error Rate", suffix: "%", max: 5, color: .red)
                        GaugeView(value: store.metrics.avgResponseTime, title: "Avg Response", suffix: "ms", max: 500, color: .orange)
                    }
                }
                .padding(20)
                .background(Color.gray.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                
                // API Usage
                HStack {
                    MetricSmall(title: "API Calls", value: "\(store.metrics.apiCalls)")
                    MetricSmall(title: "Churn Rate", value: "\(String(format: "%.1f", store.metrics.churnRate))%")
                    Spacer()
                    Text("Updated: \(store.metrics.lastUpdated.formatted(date: .abbreviated, time: .shortened))")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                // Revenue Chart
                if store.financials.revenue.count > 1 {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Revenue Trend")
                            .font(.headline)
                        SimpleBarChart(data: store.financials.revenue.suffix(6).map { $0.amount })
                    }
                    .padding(20)
                    .background(Color.gray.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }
            .padding(32)
        }
    }
}

struct MetricCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    let trend: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon).foregroundStyle(color)
                Spacer()
                Text(trend).font(.caption).foregroundStyle(.green)
            }
            Text(value).font(.title2.bold())
            Text(title).font(.caption).foregroundStyle(.secondary)
        }
        .padding(16).background(color.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct BigMetricCard: View {
    let title: String
    let value: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title).font(.headline).foregroundStyle(.secondary)
            Text(value).font(.system(size: 36, weight: .bold)).foregroundStyle(color)
            Text(subtitle).font(.caption).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20).background(color.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct GaugeView: View {
    let value: Double
    let title: String
    let suffix: String
    var max: Double = 100
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 8)
                Circle()
                    .trim(from: 0, to: min(value / max, 1.0))
                    .stroke(color, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                Text("\(Int(value))\(suffix)")
                    .font(.headline)
            }
            .frame(width: 80, height: 80)
            Text(title).font(.caption).foregroundStyle(.secondary)
        }
    }
}

struct MetricSmall: View {
    let title: String
    let value: String
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title).font(.caption).foregroundStyle(.secondary)
            Text(value).font(.title3.bold())
        }
        .padding(12).background(Color.gray.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

// MARK: - Simple Bar Chart
struct SimpleBarChart: View {
    let data: [Double]
    var maxValue: Double { data.max() ?? 1 }
    
    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .bottom, spacing: 8) {
                ForEach(Array(data.enumerated()), id: \.offset) { index, value in
                    VStack {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(barColor(for: index))
                            .frame(height: max(geometry.size.height * (value / maxValue), 4))
                        Text("$\(Int(value / 1000))K")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
        .frame(height: 150)
    }
    
    func barColor(for index: Int) -> Color {
        let colors: [Color] = [.blue, .green, .orange, .purple, .red, .pink]
        return colors[index % colors.count]
    }
}

// MARK: - Financials View
struct FinancialsView: View {
    @ObservedObject var store: AppStore
    @State private var showingAddRevenue = false
    @State private var showingAddExpense = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                HStack {
                    Text("💰 Financials")
                        .font(.system(size: 32, weight: .bold))
                    Spacer()
                    Button {
                        store.financials.lastUpdated = Date()
                        store.save()
                    } label: {
                        Label("Save", systemImage: "square.and.arrow.down")
                    }
                    .buttonStyle(.bordered)
                }
                
                // Summary Cards
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    FinanceCard(title: "Cash", value: store.financials.cash, color: .green)
                    FinanceCard(title: "Receivables", value: store.financials.receivables, color: .blue)
                    FinanceCard(title: "Payables", value: store.financials.payables, color: .orange)
                    FinanceCard(title: "Monthly Burn", value: store.financials.monthlyBurn, color: .red)
                }
                
                // Runway
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Runway").font(.headline)
                        Text("\(Int(store.financials.runwayMonths)) months").font(.title.bold())
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Investments").font(.headline)
                        Text("$\(Int(store.financials.investments))").font(.title.bold())
                    }
                }
                .padding(20).background(Color.gray.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 16))
                
                // Revenue Section
                HStack {
                    Text("Revenue")
                        .font(.headline)
                    Spacer()
                    Button {
                        store.financials.revenue.append(MonthlyRevenue(month: "Feb 2026", amount: 0, source: ""))
                    } label: {
                        Label("Add", systemImage: "plus")
                    }
                    .buttonStyle(.borderless)
                }
                
                if store.financials.revenue.isEmpty {
                    Text("No revenue recorded").foregroundStyle(.secondary).font(.caption)
                } else {
                    ForEach($store.financials.revenue) { $rev in
                        HStack {
                            TextField("Month", text: $rev.month).frame(width: 100)
                            TextField("Source", text: $rev.source).frame(width: 120)
                            TextField("Amount", value: $rev.amount, format: .currency(code: "USD")).frame(width: 100)
                            Spacer()
                        }
                        .padding(10).background(Color.green.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
                
                // Expenses Section
                HStack {
                    Text("Expenses")
                        .font(.headline)
                    Spacer()
                    Button {
                        store.financials.expenses.append(MonthlyExpense(month: "Feb 2026", category: "Infrastructure", amount: 0))
                    } label: {
                        Label("Add", systemImage: "plus")
                    }
                    .buttonStyle(.borderless)
                }
                
                if store.financials.expenses.isEmpty {
                    Text("No expenses recorded").foregroundStyle(.secondary).font(.caption)
                } else {
                    ForEach($store.financials.expenses) { $exp in
                        HStack {
                            TextField("Month", text: $exp.month).frame(width: 100)
                            TextField("Category", text: $exp.category).frame(width: 120)
                            TextField("Amount", value: $exp.amount, format: .currency(code: "USD")).frame(width: 100)
                            Spacer()
                        }
                        .padding(10).background(Color.red.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
                
                // Quick Add Buttons
                HStack(spacing: 12) {
                    Button("Add $1K Revenue") {
                        store.financials.revenue.append(MonthlyRevenue(month: "Feb 2026", amount: 1000, source: "Product"))
                    }.buttonStyle(.bordered)
                    Button("Add $500 Expense") {
                        store.financials.expenses.append(MonthlyExpense(month: "Feb 2026", category: "Infrastructure", amount: 500))
                    }.buttonStyle(.bordered)
                }
                
                Spacer()
            }
            .padding(32)
        }
    }
}

struct FinanceCard: View {
    let title: String
    let value: Double
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title).font(.caption).foregroundStyle(.secondary)
            Text("$\(Int(value))").font(.title2.bold()).foregroundStyle(color)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16).background(color.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 12))
    }
}


// MARK: - CLI Tools View
struct CLIToolsView: View {
    @ObservedObject var store: AppStore
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("💻 CLI Tools")
                    .font(.system(size: 32, weight: .bold))
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Available Tools").font(.headline)
                    CLICard(name: "gh", description: "GitHub CLI", status: "Ready", commands: "gh repo list, gh pr create")
                    CLICard(name: "npm", description: "Node Package Manager", status: "Ready", commands: "npm install, npm run")
                    CLICard(name: "xcrun", description: "Xcode CLI", status: "Ready", commands: "xcrun simctl, xcodebuild")
                }
                .padding(20).background(Color.gray.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(32)
        }
    }
}

struct CLICard: View {
    let name: String
    let description: String
    let status: String
    let commands: String
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(name).font(.headline)
                Text(description).font(.caption).foregroundStyle(.secondary)
                Text(commands).font(.caption2).foregroundStyle(.tertiary)
            }
            Spacer()
            Text(status).font(.caption).foregroundStyle(.green)
        }
        .padding(12).background(Color.gray.opacity(0.05)).clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

// MARK: - API Manager View
struct APIManagerView: View {
    @ObservedObject var store: AppStore
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("🔌 API Manager")
                    .font(.system(size: 32, weight: .bold))
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Configured APIs").font(.headline)
                    APICard(name: "Brave Search", status: "Configured", icon: "🔍")
                    APICard(name: "GitHub", status: "Configured", icon: "🐙")
                    APICard(name: "Convex", status: "Not Connected", icon: "☁️")
                    APICard(name: "OpenAI", status: "Not Configured", icon: "🤖")
                }
                .padding(20).background(Color.gray.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(32)
        }
    }
}

struct APICard: View {
    let name: String
    let status: String
    let icon: String
    var body: some View {
        HStack {
            Text(icon)
            Text(name).font(.headline)
            Spacer()
            Text(status).font(.caption).foregroundStyle(status == "Configured" ? .green : .orange)
        }
        .padding(12).background(Color.gray.opacity(0.05)).clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

// MARK: - Domains View
struct DomainsView: View {
    @ObservedObject var store: AppStore
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("🌐 Domains")
                    .font(.system(size: 32, weight: .bold))
                
                HStack {
                    Text("Total: \(store.domains.count)").font(.headline)
                    Spacer()
                    Button("Add Domain") {}.buttonStyle(.borderedProminent)
                }
                
                if store.domains.isEmpty {
                    ContentUnavailableView("No Domains", systemImage: "globe", description: Text("Add domains to track"))
                } else {
                    ForEach($store.domains) { $domain in
                        DomainRow(domain: $domain)
                    }
                }
            }
            .padding(32)
        }
    }
}

struct DomainRow: View {
    @Binding var domain: Domain
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(domain.name).font(.headline)
                Text(domain.registrar).font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
            Text(domain.expiryDate.formatted(date: .abbreviated, time: .omitted)).font(.caption)
        }
        .padding(12).background(Color.gray.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

// MARK: - Competitors View
struct CompetitorsView: View {
    @ObservedObject var store: AppStore
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("⚔️ Competitors")
                    .font(.system(size: 32, weight: .bold))
                
                HStack {
                    Text("Tracked: \(store.competitors.count)").font(.headline)
                    Spacer()
                    Button("Add") {}.buttonStyle(.borderedProminent)
                }
                
                if store.competitors.isEmpty {
                    ContentUnavailableView("No Competitors", systemImage: "person.3", description: Text("Add competitors to track"))
                }
            }
            .padding(32)
        }
    }
}


// MARK: - Monitoring View
struct MonitoringView: View {
    @ObservedObject var store: AppStore
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("📊 Monitoring")
                    .font(.system(size: 32, weight: .bold))
                
                HStack(spacing: 16) {
                    MonitorCard(title: "Uptime", value: "99.9%", color: .green)
                    MonitorCard(title: "CPU", value: "23%", color: .blue)
                    MonitorCard(title: "Memory", value: "8.2GB", color: .orange)
                    MonitorCard(title: "Disk", value: "412GB", color: .purple)
                }
                
                VStack(alignment: .leading) {
                    Text("Active Services").font(.headline)
                    MonitorRow(name: "Zimaboard", status: "Online", port: "192.168.4.65")
                    MonitorRow(name: "Portainer", status: "Online", port: ":9000")
                    MonitorRow(name: "N8N", status: "Stopped", port: ":5678")
                }
                .padding(20).background(Color.gray.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(32)
        }
    }
}

struct MonitorCard: View {
    let title: String
    let value: String
    let color: Color
    var body: some View {
        VStack {
            Text(value).font(.title).fontWeight(.bold).foregroundStyle(color)
            Text(title).font(.caption).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity).padding(16).background(Color.gray.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct MonitorRow: View {
    let name: String
    let status: String
    let port: String
    var body: some View {
        HStack {
            Circle().fill(status == "Online" ? Color.green : Color.red).frame(width: 8, height: 8)
            Text(name).font(.headline)
            Spacer()
            Text(port).font(.caption).foregroundStyle(.secondary)
            Text(status).font(.caption).foregroundStyle(status == "Online" ? .green : .red)
        }
        .padding(8)
    }
}

// MARK: - Knowledge Base View
struct KnowledgeBaseView: View {
    @ObservedObject var store: AppStore
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("📚 Knowledge Base")
                    .font(.system(size: 32, weight: .bold))
                
                TextField("Search knowledge...", text: .constant(""))
                    .textFieldStyle(.roundedBorder)
                
                VStack(alignment: .leading) {
                    Text("Categories").font(.headline)
                    CategoryPill(name: "Patents", icon: "📒", count: store.patents.count)
                    CategoryPill(name: "Ideas", icon: "💡", count: store.ideas.count)
                    CategoryPill(name: "Projects", icon: "📁", count: store.projects.count)
                    CategoryPill(name: "Notes", icon: "📝", count: store.notes.count)
                }
                .padding(20).background(Color.gray.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(32)
        }
    }
}

struct CategoryPill: View {
    let name: String
    let icon: String
    let count: Int
    var body: some View {
        HStack {
            Text(icon)
            Text(name)
            Spacer()
            Text("\(count)").font(.caption).foregroundStyle(.secondary)
        }
        .padding(10).background(Color.gray.opacity(0.05)).clipShape(RoundedRectangle(cornerRadius: 8))
    }
}


// MARK: - SSH Terminal View
struct TerminalView: View {
    @ObservedObject var store: AppStore
    @State private var command = ""
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("🖥️ Terminal")
                    .font(.system(size: 32, weight: .bold))
                
                VStack(alignment: .leading) {
                    Text("Quick Connect").font(.headline)
                    TerminalCard(host: "Zimaboard", ip: "192.168.4.65", user: "spinnaker")
                    TerminalCard(host: "Mac Mini", ip: "localhost", user: "jarvisheinemann")
                }
                .padding(20).background(Color.gray.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 16))
                
                TextField("Enter command...", text: $command)
                    .textFieldStyle(.roundedBorder).font(.system(.body, design: .monospaced))
            }
            .padding(32)
        }
    }
}

struct TerminalCard: View {
    let host: String
    let ip: String
    let user: String
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(host).font(.headline)
                Text("\(user)@\(ip)").font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
            Button("Connect") {}.buttonStyle(.bordered)
        }
        .padding(10).background(Color.gray.opacity(0.05)).clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

// MARK: - Git View
struct GitView: View {
    @ObservedObject var store: AppStore
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("🐙 Git")
                    .font(.system(size: 32, weight: .bold))
                
                VStack(alignment: .leading) {
                    Text("Repositories").font(.headline)
                    GitCard(name: "mission-control", branch: "main", status: "clean", commits: 47)
                    GitCard(name: "ip-mission-control", branch: "main", status: "clean", commits: 23)
                    GitCard(name: "n8n-workflows", branch: "main", status: "dirty", commits: 12)
                }
                .padding(20).background(Color.gray.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(32)
        }
    }
}

struct GitCard: View {
    let name: String
    let branch: String
    let status: String
    let commits: Int
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(name).font(.headline)
                Text("\(branch) • \(commits) commits").font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
            Circle().fill(status == "clean" ? Color.green : Color.orange).frame(width: 8, height: 8)
            Text(status).font(.caption).foregroundStyle(status == "clean" ? .green : .orange)
        }
        .padding(10).background(Color.gray.opacity(0.05)).clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

// MARK: - Docker View
struct DockerView: View {
    @ObservedObject var store: AppStore
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("🐳 Docker")
                    .font(.system(size: 32, weight: .bold))
                
                VStack(alignment: .leading) {
                    Text("Containers").font(.headline)
                    DockerCard(name: "portainer", image: "portainer/portainer", status: "running")
                    DockerCard(name: "n8n", image: "n8nio/n8n", status: "stopped")
                    DockerCard(name: "postgres", image: "postgres:15", status: "stopped")
                    DockerCard(name: "redis", image: "redis:7", status: "stopped")
                }
                .padding(20).background(Color.gray.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(32)
        }
    }
}

struct DockerCard: View {
    let name: String
    let image: String
    let status: String
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(name).font(.headline)
                Text(image).font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
            Text(status).font(.caption).foregroundStyle(status == "running" ? .green : .secondary)
        }
        .padding(10).background(Color.gray.opacity(0.05)).clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

// MARK: - Database View
struct DatabaseView: View {
    @ObservedObject var store: AppStore
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("🗄️ Database")
                    .font(.system(size: 32, weight: .bold))
                
                VStack(alignment: .leading) {
                    Text("Connections").font(.headline)
                    DBCard(name: "PostgreSQL", host: "localhost:5432", databases: 3)
                    DBCard(name: "Convex", host: "aromatic-basilisk-680", databases: 5)
                    DBCard(name: "SQLite (local)", host: "mission-control.db", databases: 1)
                }
                .padding(20).background(Color.gray.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(32)
        }
    }
}

struct DBCard: View {
    let name: String
    let host: String
    let databases: Int
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(name).font(.headline)
                Text(host).font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
            Text("\(databases) DBs").font(.caption).foregroundStyle(.secondary)
        }
        .padding(10).background(Color.gray.opacity(0.05)).clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

// MARK: - Email View
struct EmailView: View {
    @ObservedObject var store: AppStore
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("📧 Email")
                    .font(.system(size: 32, weight: .bold))
                
                HStack(spacing: 16) {
                    EmailAccountCard(email: "JarvisHeinemann@icloud.com", unread: 0, service: "iCloud")
                    EmailAccountCard(email: "javisheinemann@gmail.com", unread: 3, service: "Gmail")
                }
                
                VStack(alignment: .leading) {
                    Text("Recent").font(.headline)
                    Text("No recent emails").font(.caption).foregroundStyle(.secondary)
                }
                .padding(20).background(Color.gray.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(32)
        }
    }
}

struct EmailAccountCard: View {
    let email: String
    let unread: Int
    let service: String
    var body: some View {
        VStack(alignment: .leading) {
            Text(service).font(.headline)
            Text(email).font(.caption).foregroundStyle(.secondary)
            HStack {
                Spacer()
                Text("\(unread) unread").font(.caption).foregroundStyle(unread > 0 ? .orange : .green)
            }
        }
        .padding(16).frame(maxWidth: .infinity).background(Color.gray.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Cloud View
struct CloudView: View {
    @ObservedObject var store: AppStore
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("☁️ Cloud")
                    .font(.system(size: 32, weight: .bold))
                
                VStack(alignment: .leading) {
                    Text("Services").font(.headline)
                    CloudCard(name: "iCloud", used: "45.2GB", total: "200GB", icon: "☁️")
                    CloudCard(name: "GitHub", used: "2.1GB", total: "Unlimited", icon: "🐙")
                    CloudCard(name: "ZimaOS", used: "124GB", total: "500GB", icon: "📦")
                    CloudCard(name: "Convex", used: "890KB", total: "5GB", icon: "⚡")
                }
                .padding(20).background(Color.gray.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(32)
        }
    }
}

struct CloudCard: View {
    let name: String
    let used: String
    let total: String
    let icon: String
    var body: some View {
        HStack {
            Text(icon)
            VStack(alignment: .leading) {
                Text(name).font(.headline)
                Text("\(used) / \(total)").font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding(10).background(Color.gray.opacity(0.05)).clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

// MARK: - Security View
struct SecurityView: View {
    @ObservedObject var store: AppStore
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("🔐 Security")
                    .font(.system(size: 32, weight: .bold))
                
                VStack(alignment: .leading) {
                    Text("Passwords (1Password)").font(.headline)
                    SecurityItem(name: "GitHub", status: "OK")
                    SecurityItem(name: "Zimaboard", status: "OK")
                    SecurityItem(name: "iCloud", status: "OK")
                    SecurityItem(name: "Gmail", status: "OK")
                }
                .padding(20).background(Color.gray.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 16))
                
                VStack(alignment: .leading) {
                    Text("2FA Status").font(.headline)
                    SecurityItem(name: "GitHub", status: "Enabled")
                    SecurityItem(name: "iCloud", status: "Enabled")
                    SecurityItem(name: "Gmail", status: "Enabled")
                }
                .padding(20).background(Color.gray.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(32)
        }
    }
}

struct SecurityItem: View {
    let name: String
    let status: String
    var body: some View {
        HStack {
            Text(name)
            Spacer()
            Text(status).font(.caption).foregroundStyle(status == "OK" || status == "Enabled" ? .green : .orange)
        }
        .padding(8)
    }
}

// MARK: - Backups View
struct BackupsView: View {
    @ObservedObject var store: AppStore
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("💾 Backups")
                    .font(.system(size: 32, weight: .bold))
                
                VStack(alignment: .leading) {
                    Text("Recent Backups").font(.headline)
                    BackupCard(name: "Mac Mini", date: "Today 7:00 AM", size: "45GB", status: "Success")
                    BackupCard(name: "iCloud", date: "Today 6:30 AM", size: "45GB", status: "Synced")
                    BackupCard(name: "Zimaboard", date: "Yesterday", size: "2.3GB", status: "Success")
                }
                .padding(20).background(Color.gray.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(32)
        }
    }
}

struct BackupCard: View {
    let name: String
    let date: String
    let size: String
    let status: String
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(name).font(.headline)
                Text("\(date) • \(size)").font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
            Text(status).font(.caption).foregroundStyle(.green)
        }
        .padding(10).background(Color.gray.opacity(0.05)).clipShape(RoundedRectangle(cornerRadius: 8))
    }
}


// MARK: - Browser View
struct BrowserView: View {
    @ObservedObject var store: AppStore
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("🌐 Browser")
                    .font(.system(size: 32, weight: .bold))
                
                TextField("Enter URL...", text: .constant(""))
                    .textFieldStyle(.roundedBorder)
                
                VStack(alignment: .leading) {
                    Text("Bookmarks").font(.headline)
                    BookmarkRow(name: "ZimaOS", url: "http://192.168.4.65")
                    BookmarkRow(name: "Portainer", url: "http://192.168.4.65:9000")
                    BookmarkRow(name: "N8N", url: "http://192.168.4.65:5678")
                    BookmarkRow(name: "Convex Dashboard", url: "https://aromatic-basilisk-680.convex.cloud")
                }
                .padding(20).background(Color.gray.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(32)
        }
    }
}

struct BookmarkRow: View {
    let name: String
    let url: String
    var body: some View {
        HStack {
            Text(name).font(.headline)
            Spacer()
            Text(url).font(.caption).foregroundStyle(.secondary)
        }
        .padding(8)
    }
}

// MARK: - Calendar View
struct FullCalendarView: View {
    @ObservedObject var store: AppStore
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("📅 Calendar")
                    .font(.system(size: 32, weight: .bold))
                
                Text("February 2026").font(.title2)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                    ForEach(["S","M","T","W","T","F","S"], id: \.self) { day in
                        Text(day).font(.caption).fontWeight(.bold).frame(maxWidth: .infinity)
                    }
                    ForEach(1...28, id: \.self) { day in
                        CalendarDay(day: day, isToday: day == 19)
                    }
                }
                
                VStack(alignment: .leading) {
                    Text("Upcoming").font(.headline)
                    EventRow(event: "z.ai renewal", date: "May 17, 2026")
                    EventRow(event: "Patent deadlines", date: "Ongoing")
                }
                .padding(20).background(Color.gray.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(32)
        }
    }
}

struct CalendarDay: View {
    let day: Int
    let isToday: Bool
    var body: some View {
        Text("\(day)")
            .font(.caption)
            .frame(maxWidth: .infinity)
            .padding(8)
            .background(isToday ? Color.blue : Color.clear)
            .foregroundStyle(isToday ? .white : .primary)
            .clipShape(Circle())
    }
}

struct EventRow: View {
    let event: String
    let date: String
    var body: some View {
        HStack {
            Text(event)
            Spacer()
            Text(date).font(.caption).foregroundStyle(.secondary)
        }
        .padding(8)
    }
}

// MARK: - Tasks View
struct TasksView: View {
    @ObservedObject var store: AppStore
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("✅ Tasks")
                    .font(.system(size: 32, weight: .bold))
                
                VStack(alignment: .leading) {
                    Text("High Priority").font(.headline)
                    TaskRow(title: "Deploy N8N to Zimaboard", priority: "high", done: false)
                    TaskRow(title: "Import patent data", priority: "high", done: false)
                    TaskRow(title: "Configure Brave Search", priority: "high", done: false)
                }
                .padding(20).background(Color.gray.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 16))
                
                VStack(alignment: .leading) {
                    Text("This Week").font(.headline)
                    TaskRow(title: "Build Mission Control app", priority: "medium", done: true)
                    TaskRow(title: "Setup automation workflows", priority: "medium", done: false)
                }
                .padding(20).background(Color.gray.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(32)
        }
    }
}

struct TaskRow: View {
    let title: String
    let priority: String
    let done: Bool
    var body: some View {
        HStack {
            Image(systemName: done ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(done ? .green : .secondary)
            Text(title).strikethrough(done)
            Spacer()
            Text(priority).font(.caption).foregroundStyle(priority == "high" ? .red : .orange)
        }
        .padding(8)
    }
}

// MARK: - Time View
struct TimeView: View {
    @State private var currentTime = Date()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("⏰ Time")
                    .font(.system(size: 32, weight: .bold))
                
                Text(currentTime, style: .time)
                    .font(.system(size: 64, weight: .light, design: .monospaced))
                
                HStack {
                    VStack {
                        Text("New York").font(.headline)
                        Text("7:56 PM").font(.title3)
                    }
                    VStack {
                        Text("UTC").font(.headline)
                        Text("12:56 AM").font(.title3)
                    }
                    VStack {
                        Text("LA").font(.headline)
                        Text("4:56 PM").font(.title3)
                    }
                }
                .padding(20).background(Color.gray.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 16))
                
                VStack(alignment: .leading) {
                    Text("Focus Hours").font(.headline)
                    Text("9 AM - 1 PM EST optimal").foregroundStyle(.secondary)
                }
                .padding(20).background(Color.gray.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(32)
            .onReceive(timer) { _ in
                currentTime = Date()
            }
        }
    }
}

// MARK: - AI Models View
struct AIModelsView: View {
    @ObservedObject var store: AppStore
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("🤖 AI Models")
                    .font(.system(size: 32, weight: .bold))
                
                VStack(alignment: .leading) {
                    Text("Configured").font(.headline)
                    AIModelRow(name: "MiniMax M2.5", status: "Active", context: "200K")
                    AIModelRow(name: "Claude 4", status: "Available", context: "200K")
                    AIModelRow(name: "GPT-4o", status: "Available", context: "128K")
                    AIModelRow(name: "Gemini 2.5", status: "Available", context: "1M")
                }
                .padding(20).background(Color.gray.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 16))
                
                VStack(alignment: .leading) {
                    Text("Usage Today").font(.headline)
                    HStack {
                        Text("MiniMax").frame(width: 80)
                        ProgressView(value: 0.7).frame(maxWidth: .infinity)
                        Text("70%").font(.caption)
                    }
                }
                .padding(20).background(Color.gray.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(32)
        }
    }
}

struct AIModelRow: View {
    let name: String
    let status: String
    let context: String
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(name).font(.headline)
                Text("\(context) context").font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
            Text(status).font(.caption).foregroundStyle(status == "Active" ? .green : .blue)
        }
        .padding(8)
    }
}

// MARK: - Logs View
struct LogsView: View {
    @ObservedObject var store: AppStore
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("📜 Logs")
                    .font(.system(size: 32, weight: .bold))
                
                VStack(alignment: .leading) {
                    Text("Recent Activity").font(.headline)
                    LogEntry(time: "7:56 PM", message: "Added Backups panel")
                    LogEntry(time: "7:48 PM", message: "Added Cloud panel")
                    LogEntry(time: "7:42 PM", message: "Added Security panel")
                    LogEntry(time: "7:35 PM", message: "Added Email panel")
                    LogEntry(time: "7:28 PM", message: "Added Database panel")
                }
                .padding(20).background(Color.gray.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(32)
        }
    }
}

struct LogEntry: View {
    let time: String
    let message: String
    var body: some View {
        HStack {
            Text(time).font(.caption).foregroundStyle(.secondary).frame(width: 60, alignment: .leading)
            Text(message).font(.caption)
        }
        .padding(4)
    }
}

// MARK: - Snippets View
struct SnippetsView: View {
    @ObservedObject var store: AppStore
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("✂️ Snippets")
                    .font(.system(size: 32, weight: .bold))
                
                VStack(alignment: .leading) {
                    Text("Code Snippets").font(.headline)
                    SnippetCard(lang: "bash", name: "Git commit all", code: "git add . && git commit -m \"update\"")
                    SnippetCard(lang: "bash", name: "XcodeGen", code: "xcodegen generate")
                    SnippetCard(lang: "swift", name: "ForEach", code: "ForEach(items) { item in }")
                }
                .padding(20).background(Color.gray.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(32)
        }
    }
}

struct SnippetCard: View {
    let lang: String
    let name: String
    let code: String
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(name).font(.headline)
                Spacer()
                Text(lang).font(.caption).foregroundStyle(.secondary)
            }
            Text(code).font(.system(.caption, design: .monospaced)).foregroundStyle(.secondary)
        }
        .padding(10).background(Color.gray.opacity(0.05)).clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

// MARK: - Environment View
struct EnvironmentView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("⚙️ Environment")
                    .font(.system(size: 32, weight: .bold))
                
                VStack(alignment: .leading) {
                    Text("System").font(.headline)
                    EnvRow(key: "OS", value: "macOS 25.3.0")
                    EnvRow(key: "Machine", value: "Mac mini M4")
                    EnvRow(key: "Shell", value: "zsh")
                    EnvRow(key: "Node", value: "v25.6.1")
                }
                .padding(20).background(Color.gray.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 16))
                
                VStack(alignment: .leading) {
                    Text("OpenClaw").font(.headline)
                    EnvRow(key: "Channel", value: "telegram")
                    EnvRow(key: "Model", value: "MiniMax M2.5")
                    EnvRow(key: "Runtime", value: "gateway node")
                }
                .padding(20).background(Color.gray.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(32)
        }
    }
}

struct EnvRow: View {
    let key: String
    let value: String
    var body: some View {
        HStack {
            Text(key).font(.caption).foregroundStyle(.secondary)
            Spacer()
            Text(value).font(.caption)
        }
        .padding(4)
    }
}

// MARK: - Quick Links View
struct QuickLinksView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("🔗 Quick Links")
                    .font(.system(size: 32, weight: .bold))
                
                VStack(alignment: .leading) {
                    Text("Essential").font(.headline)
                    LinkRow(name: "ZimaOS", url: "http://192.168.4.65")
                    LinkRow(name: "Portainer", url: "http://192.168.4.65:9000")
                    LinkRow(name: "Convex", url: "https://aromatic-basilisk-680.convex.cloud")
                    LinkRow(name: "GitHub", url: "https://github.com")
                }
                .padding(20).background(Color.gray.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 16))
                
                VStack(alignment: .leading) {
                    Text("AI").font(.headline)
                    LinkRow(name: "z.ai", url: "https://z.ai")
                    LinkRow(name: "OpenAI", url: "https://platform.openai.com")
                    LinkRow(name: "MiniMax", url: "https://platform.minimaxi.com")
                }
                .padding(20).background(Color.gray.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(32)
        }
    }
}

struct LinkRow: View {
    let name: String
    let url: String
    var body: some View {
        HStack {
            Text(name).font(.headline)
            Spacer()
            Text(url).font(.caption).foregroundStyle(.secondary)
        }
        .padding(8)
    }
}


// MARK: - Chat View
struct ChatView: View {
    @ObservedObject var store: AppStore
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("💬 Chat")
                    .font(.system(size: 32, weight: .bold))
                
                VStack(alignment: .leading) {
                    Text("Channels").font(.headline)
                    ChannelRow(name: "Telegram", unread: 2, icon: "✈️")
                    ChannelRow(name: "Signal", unread: 0, icon: "🔒")
                    ChannelRow(name: "Discord", unread: 5, icon: "🎮")
                    ChannelRow(name: "WhatsApp", unread: 0, icon: "📱")
                }
                .padding(20).background(Color.gray.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(32)
        }
    }
}

struct ChannelRow: View {
    let name: String
    let unread: Int
    let icon: String
    var body: some View {
        HStack {
            Text(icon)
            Text(name).font(.headline)
            Spacer()
            Text("\(unread)").font(.caption).foregroundStyle(unread > 0 ? .white : .secondary)
                .padding(.horizontal, 8).padding(.vertical, 2)
                .background(unread > 0 ? Color.blue : Color.clear)
                .clipShape(Capsule())
        }
        .padding(8)
    }
}

// MARK: - Notifications View
struct NotificationsView: View {
    @ObservedObject var store: AppStore
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("🔔 Notifications")
                    .font(.system(size: 32, weight: .bold))
                
                VStack(alignment: .leading) {
                    Text("Recent").font(.headline)
                    NotifRow(title: "Heartbeat check-in", time: "7:30 PM", type: "info")
                    NotifRow(title: "Backup completed", time: "7:00 AM", type: "success")
                    NotifRow(title: "Patent deadline approaching", time: "Yesterday", type: "warning")
                }
                .padding(20).background(Color.gray.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(32)
        }
    }
}

struct NotifRow: View {
    let title: String
    let time: String
    let type: String
    var body: some View {
        HStack {
            Image(systemName: type == "success" ? "checkmark.circle" : type == "warning" ? "exclamationmark.triangle" : "info.circle")
                .foregroundStyle(type == "success" ? .green : type == "warning" ? .orange : .blue)
            VStack(alignment: .leading) {
                Text(title).font(.headline)
                Text(time).font(.caption).foregroundStyle(.secondary)
            }
        }
        .padding(8)
    }
}

// MARK: - Widgets View
struct WidgetsView: View {
    @ObservedObject var store: AppStore
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("🧩 Widgets")
                    .font(.system(size: 32, weight: .bold))
                
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    WidgetCard(title: "Weather", value: "42°F", icon: "☁️")
                    WidgetCard(title: " Stocks", value: "+2.3%", icon: "📈")
                    WidgetCard(title: "Tasks", value: "3 left", icon: "✅")
                    WidgetCard(title: "Focus", value: "2h 15m", icon: "🎯")
                }
            }
            .padding(32)
        }
    }
}

struct WidgetCard: View {
    let title: String
    let value: String
    let icon: String
    var body: some View {
        VStack {
            Text(icon).font(.title)
            Text(value).font(.headline)
            Text(title).font(.caption).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity).padding(20).background(Color.gray.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Shortcuts View
struct KeyboardShortcutsView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("⌨️ Shortcuts")
                    .font(.system(size: 32, weight: .bold))
                
                VStack(alignment: .leading) {
                    Text("App").font(.headline)
                    ShortcutRow(keys: "⌘R", action: "Run app")
                    ShortcutRow(keys: "⌘N", action: "New item")
                    ShortcutRow(keys: "⌘F", action: "Search")
                    ShortcutRow(keys: "⌘,", action: "Settings")
                }
                .padding(20).background(Color.gray.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(32)
        }
    }
}

struct ShortcutRow: View {
    let keys: String
    let action: String
    var body: some View {
        HStack {
            Text(action)
            Spacer()
            Text(keys).font(.system(.body, design: .monospaced)).padding(6).background(Color.gray.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 4))
        }
        .padding(4)
    }
}

// MARK: - Stats View
struct StatsView: View {
    @ObservedObject var store: AppStore
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("📈 Stats")
                    .font(.system(size: 32, weight: .bold))
                
                StatCard(title: "Total Panels", value: "61")
                StatCard(title: "Patents", value: "\(store.patents.count)")
                StatCard(title: "Ideas", value: "\(store.ideas.count)")
                StatCard(title: "Projects", value: "\(store.projects.count)")
            }
            .padding(32)
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(value).font(.title).fontWeight(.bold)
        }
        .padding(16).background(Color.gray.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Workflows View
struct WorkflowsView: View {
    @ObservedObject var store: AppStore
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("🔄 Workflows")
                    .font(.system(size: 32, weight: .bold))
                
                VStack(alignment: .leading) {
                    Text("N8N Workflows").font(.headline)
                    WorkflowRow(name: "OpenArt Bulk Generator", status: "inactive")
                    WorkflowRow(name: "111 Method Scaler", status: "inactive")
                    WorkflowRow(name: "Affiliate Tracker", status: "inactive")
                }
                .padding(20).background(Color.gray.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(32)
        }
    }
}

struct WorkflowRow: View {
    let name: String
    let status: String
    var body: some View {
        HStack {
            Text(name).font(.headline)
            Spacer()
            Text(status).font(.caption).foregroundStyle(status == "active" ? .green : .secondary)
        }
        .padding(8)
    }
}

// MARK: - Voice View
struct VoiceView: View {
    @State private var isRecording = false
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("🎤 Voice")
                    .font(.system(size: 32, weight: .bold))
                
                VStack {
                    Button(action: { isRecording.toggle() }) {
                        Image(systemName: isRecording ? "stop.circle.fill" : "mic.circle.fill")
                            .font(.system(size: 64))
                            .foregroundStyle(isRecording ? .red : .blue)
                    }
                    Text(isRecording ? "Recording..." : "Tap to speak").foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity).padding()
                
                V40Stack(alignment: .leading) {
                    Text("Voice Settings").font(.headline)
                    Text("Voice: Nova (warm, slightly British)").foregroundStyle(.secondary)
                    Text("Default speaker: Kitchen HomePod").foregroundStyle(.secondary)
                }
                .padding(20).background(Color.gray.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(32)
        }
    }
}

// MARK: - Messages View
struct MessagesView: View {
    @ObservedObject var store: AppStore
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("✉️ Messages")
                    .font(.system(size: 32, weight: .bold))
                
                VStack(alignment: .leading) {
                    Text("Recent").font(.headline)
                    MessagePreview(from: "Gabriel", preview: "Keep going!", time: "2m ago")
                    MessagePreview(from: "System", preview: "Heartbeat check-in", time: "30m ago")
                }
                .padding(20).background(Color.gray.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(32)
        }
    }
}

struct MessagePreview: View {
    let from: String
    let preview: String
    let time: String
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(from).font(.headline)
                Text(preview).font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
            Text(time).font(.caption).foregroundStyle(.tertiary)
        }
        .padding(8)
    }
}

// MARK: - Health View
struct HealthView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("❤️ Health")
                    .font(.system(size: 32, weight: .bold))
                
                VStack(alignment: .leading) {
                    Text("System Health").font(.headline)
                    HealthRow(metric: "CPU Load", value: "23%")
                    HealthRow(metric: "Memory", value: "8.2GB / 16GB")
                    HealthRow(metric: "Disk", value: "412GB / 500GB")
                    HealthRow(metric: "Uptime", value: "4 days")
                }
                .padding(20).background(Color.gray.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(32)
        }
    }
}

struct HealthRow: View {
    let metric: String
    let value: String
    var body: some View {
        HStack {
            Text(metric)
            Spacer()
            Text(value).foregroundStyle(.secondary)
        }
        .padding(4)
    }
}

// MARK: - Wallet View
struct WalletView: View {
    @ObservedObject var store: AppStore
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("💳 Wallet")
                    .font(.system(size: 32, weight: .bold))
                
                VStack(alignment: .leading) {
                    Text("Accounts").font(.headline)
                    WalletCard(name: "Chase", balance: "$12,450.00", type: "checking")
                    WalletCard(name: "Amex", balance: "$2,340.00", type: "credit")
                }
                .padding(20).background(Color.gray.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(32)
        }
    }
}

struct WalletCard: View {
    let name: String
    let balance: String
    let type: String
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(name).font(.headline)
                Text(type).font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
            Text(balance).font(.headline)
        }
        .padding(12).background(Color.gray.opacity(0.05)).clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

// MARK: - Subscriptions View
struct SubscriptionsView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("📦 Subscriptions")
                    .font(.system(size: 32, weight: .bold))
                
                VStack(alignment: .leading) {
                    Text("Active").font(.headline)
                    SubCard(name: "z.ai", cost: "$81/qtr", renews: "May 17, 2026")
                    SubCard(name: "1Password", cost: "$2.99/mo", renews: "Mar 1, 2026")
                    SubCard(name: "iCloud+", cost: "$2.99/mo", renews: "Feb 25, 2026")
                }
                .padding(20).background(Color.gray.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(32)
        }
    }
}

struct SubCard: View {
    let name: String
    let cost: String
    let renews: String
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(name).font(.headline)
                Text(renews).font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
            Text(cost).font(.headline)
        }
        .padding(12).background(Color.gray.opacity(0.05)).clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

// MARK: - Receipts View
struct ReceiptsView: View {
    @ObservedObject var store: AppStore
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("🧾 Receipts")
                    .font(.system(size: 32, weight: .bold))
                
                VStack(alignment: .leading) {
                    Text("February 2026").font(.headline)
                    ReceiptRow(vendor: "AWS", amount: "$124.50", date: "Feb 15")
                    ReceiptRow(vendor: "z.ai", amount: "$81.00", date: "Feb 17")
                    ReceiptRow(vendor: "1Password", amount: "$2.99", date: "Feb 1")
                }
                .padding(20).background(Color.gray.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(32)
        }
    }
}

struct ReceiptRow: View {
    let vendor: String
    let amount: String
    let date: String
    var body: some View {
        HStack {
            Text(vendor).font(.headline)
            Spacer()
            Text(amount)
            Text(date).font(.caption).foregroundStyle(.secondary)
        }
        .padding(8)
    }
}

// MARK: - Inventory View
struct InventoryView: View {
    @ObservedObject var store: AppStore
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("📦 Inventory")
                    .font(.system(size: 32, weight: .bold))
                
                VStack(alignment: .leading) {
                    Text("Assets").font(.headline)
                    InventoryRow(name: "Mac mini M4", qty: 1, value: "$599")
                    InventoryRow(name: "Zimaboard 16G", qty: 1, value: "$399")
                    InventoryRow(name: "iPhone 15 Pro", qty: 1, value: "$999")
                }
                .padding(20).background(Color.gray.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(32)
        }
    }
}

struct InventoryRow: View {
    let name: String
    let qty: Int
    let value: String
    var body: some View {
        HStack {
            Text(name).font(.headline)
            Spacer()
            Text("x\(qty)").foregroundStyle(.secondary)
            Text(value).font(.headline)
        }
        .padding(8)
    }
}

// MARK: - Timeline View
struct TimelineView: View {
    @ObservedObject var store: AppStore
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("📊 Timeline")
                    .font(.system(size: 32, weight: .bold))
                
                VStack(alignment: .leading) {
                    Text("Today").font(.headline)
                    TimelineEntry(time: "7:56 PM", event: "Added 10+ panels to Mission Control")
                    TimelineEntry(time: "7:00 PM", event: "Memory flushed")
                    TimelineEntry(time: "6:36 PM", event: "Added Search, Reports, Integrations")
                    TimelineEntry(time: "6:06 PM", event: "Added Notes & History panels")
                }
                .padding(20).background(Color.gray.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(32)
        }
    }
}

struct TimelineEntry: View {
    let time: String
    let event: String
    var body: some View {
        HStack(alignment: .top) {
            Text(time).font(.caption).foregroundStyle(.secondary).frame(width: 60)
            VStack(alignment: .leading) {
                Circle().fill(Color.blue).frame(width: 8, height: 8)
                Rectangle().fill(Color.gray.opacity(0.3)).frame(width: 2, height: 30)
            }
            Text(event).font(.caption)
        }
    }
}

// MARK: - Archive View
struct ArchiveView: View {
    @ObservedObject var store: AppStore
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("📁 Archive")
                    .font(.system(size: 32, weight: .bold))
                
                VStack(alignment: .leading) {
                    Text("Archived Items").font(.headline)
                    Text("No archived items yet").foregroundStyle(.secondary)
                }
                .padding(20).background(Color.gray.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(32)
        }
    }
}

// MARK: - Templates View
struct TemplatesView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("📋 Templates")
                    .font(.system(size: 32, weight: .bold))
                
                VStack(alignment: .leading) {
                    Text("Available").font(.headline)
                    TemplateCard(name: "Patent Specification", icon: "📒")
                    TemplateCard(name: "Project Brief", icon: "📝")
                    TemplateCard(name: "Tech Spec", icon: "⚡")
                    TemplateCard(name: "Blog Post", icon: "✍️")
                }
                .padding(20).background(Color.gray.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(32)
        }
    }
}

struct TemplateCard: View {
    let name: String
    let icon: String
    var body: some View {
        HStack {
            Text(icon)
            Text(name).font(.headline)
            Spacer()
        }
        .padding(12).background(Color.gray.opacity(0.05)).clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

// MARK: - Imports View
struct ImportsView: View {
    @ObservedObject var store: AppStore
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("📥 Imports")
                    .font(.system(size: 32, weight: .bold))
                
                VStack(alignment: .leading) {
                    Text("Recent Imports").font(.headline)
                    ImportRow(file: "patents.csv", date: "Feb 19", status: "success")
                    ImportRow(file: "ideas.json", date: "Feb 18", status: "success")
                    ImportRow(file: "repos.json", date: "Feb 17", status: "success")
                }
                .padding(20).background(Color.gray.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(32)
        }
    }
}

struct ImportRow: View {
    let file: String
    let date: String
    let status: String
    var body: some View {
        HStack {
            Text(file).font(.headline)
            Spacer()
            Text(date).font(.caption).foregroundStyle(.secondary)
            Text(status).font(.caption).foregroundStyle(.green)
        }
        .padding(8)
    }
}

// MARK: - Exports View
struct ExportsView: View {
    @ObservedObject var store: AppStore
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("📤 Exports")
                    .font(.system(size: 32, weight: .bold))
                
                VStack(alignment: .leading) {
                    Text("Recent Exports").font(.headline)
                    ExportRow(file: "portfolio.json", date: "Feb 19", size: "24KB")
                    ExportRow(file: "patents.csv", date: "Feb 19", size: "8KB")
                    ExportRow(file: "backup.json", date: "Feb 18", size: "156KB")
                }
                .padding(20).background(Color.gray.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(32)
        }
    }
}

struct ExportRow: View {
    let file: String
    let date: String
    let size: String
    var body: some View {
        HStack {
            Text(file).font(.headline)
            Spacer()
            Text(size).font(.caption).foregroundStyle(.secondary)
            Text(date).font(.caption).foregroundStyle(.secondary)
        }
        .padding(8)
    }
}

// MARK: - Command Palette
    let skill: InstalledSkill
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(skill.icon)
                    .font(.title2)
                VStack(alignment: .leading) {
                    Text(skill.name)
                        .font(.subheadline.bold())
                    Text(skill.category)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
            
            Text(skill.description)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(2)
        }
        .padding(12)
        .background(Color.gray.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

// MARK: - Launches View
struct LaunchesView: View {
    @ObservedObject var store: AppStore
    
    var upcomingLaunches: [Launch] {
        store.launches.filter { $0.status != .launched && $0.targetDate > Date() }
            .sorted { $0.targetDate < $1.targetDate }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                HStack {
                    Text("🚀 Launches")
                        .font(.system(size: 32, weight: .bold))
                    Spacer()
                    Button {
                        store.launches.append(Launch(name: "New Launch", targetDate: Date().addingTimeInterval(86400 * 30)))
                    } label: {
                        Label("New Launch", systemImage: "plus")
                    }
                    .buttonStyle(.borderedProminent)
                }
                
                // Stats
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    LaunchStat(title: "Total", count: store.launches.count, color: .blue)
                    LaunchStat(title: "Planning", count: store.launches.filter { $0.status == .planning }.count, color: .gray)
                    LaunchStat(title: "Ready", count: store.launches.filter { $0.status == .ready }.count, color: .green)
                    LaunchStat(title: "Launched", count: store.launches.filter { $0.status == .launched }.count, color: .purple)
                }
                
                // Upcoming
                if !upcomingLaunches.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("UPCOMING")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(.secondary)
                        
                        ForEach($store.launches.filter { $0.status != .launched }) { $launch in
                            LaunchCard(launch: $launch)
                        }
                    }
                }
                
                // All Launches
                if store.launches.isEmpty {
                    ContentUnavailableView("No Launches", systemImage: "rocket", description: Text("Plan your next launch"))
                } else {
                    LazyVStack(spacing: 12) {
                        ForEach($store.launches) { $launch in
                            LaunchCard(launch: $launch)
                        }
                    }
                }
            }
            .padding(32)
        }
    }
}

struct LaunchStat: View {
    let title: String
    let count: Int
    let color: Color
    var body: some View {
        VStack(spacing: 4) {
            Text("\(count)").font(.title2.bold()).foregroundStyle(color)
            Text(title).font(.caption).foregroundStyle(.secondary)
        }
        .padding(12).frame(maxWidth: .infinity).background(color.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct LaunchCard: View {
    @Binding var launch: Launch
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                TextField("Name", text: $launch.name).font(.headline)
                Text(launch.targetDate.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
            Picker("Status", selection: $launch.status) {
                ForEach(LaunchStatus.allCases, id: \.self) { s in Text(s.rawValue).tag(s) }
            }.frame(width: 100)
            Picker("Category", selection: $launch.category) {
                ForEach(LaunchCategory.allCases, id: \.self) { c in Text(c.rawValue).tag(c) }
            }.frame(width: 110)
        }
        .padding(16).background(Color.gray.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Assets View
struct AssetsView: View {
    @ObservedObject var store: AppStore
    @State private var filterType: AssetType? = nil
    
    var filteredAssets: [Asset] {
        if let filter = filterType {
            return store.assets.filter { $0.type == filter }
        }
        return store.assets
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                HStack {
                    Text("📦 Assets")
                        .font(.system(size: 32, weight: .bold))
                    Spacer()
                    Picker("Type", selection: $filterType) {
                        Text("All").tag(AssetType?.none)
                        ForEach(AssetType.allCases, id: \.self) { t in Text(t.rawValue).tag(AssetType?.some(t)) }
                    }.frame(width: 120)
                    Button {
                        store.assets.append(Asset(name: "New Asset", type: .other))
                    } label: {
                        Label("Add", systemImage: "plus")
                    }.buttonStyle(.borderedProminent)
                }
                
                if filteredAssets.isEmpty {
                    ContentUnavailableView("No Assets", systemImage: "archivebox", description: Text("Store images, videos, docs"))
                } else {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        ForEach($store.assets) { $asset in
                            AssetCard(asset: $asset)
                        }
                    }
                }
            }
            .padding(32)
        }
    }
}

struct AssetCard: View {
    @Binding var asset: Asset
    var icon: String {
        switch asset.type {
        case .image: return "photo"
        case .video: return "video"
        case .document: return "doc"
        case .code: return "chevron.left.forwardslash.chevron.right"
        case .other: return "archivebox"
        }
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon).font(.title2).foregroundStyle(.blue)
                Spacer()
                Text(asset.type.rawValue).font(.caption2).foregroundStyle(.secondary)
            }
            TextField("Name", text: $asset.name).font(.headline)
            TextField("URL", text: $asset.url).font(.caption)
            if !asset.tags.isEmpty {
                Text(asset.tags.joined(separator: ", ")).font(.caption2).foregroundStyle(.secondary)
            }
        }
        .padding(12).background(Color.gray.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

// MARK: - Team View
struct TeamView: View {
    @ObservedObject var store: AppStore
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                HStack {
                    Text("👥 Team")
                        .font(.system(size: 32, weight: .bold))
                    Spacer()
                    Button {
                        store.team.append(TeamMember(name: "New Member", role: "Developer"))
                    } label: {
                        Label("Add Member", systemImage: "person.badge.plus")
                    }.buttonStyle(.borderedProminent)
                }
                
                if store.team.isEmpty {
                    ContentUnavailableView("No Team Members", systemImage: "person.3", description: Text("Add team members to track"))
                } else {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach($store.team) { $member in
                            TeamCard(member: $member)
                        }
                    }
                }
            }
            .padding(32)
        }
    }
}

struct TeamCard: View {
    @Binding var member: TeamMember
    var statusColor: Color {
        switch member.status {
        case .active: return .green
        case .away: return .orange
        case .offline: return .gray
        }
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Circle().fill(statusColor).frame(width: 12, height: 12)
                TextField("Name", text: $member.name).font(.headline)
            }
            TextField("Role", text: $member.role).font(.subheadline).foregroundStyle(.secondary)
            TextField("Email", text: $member.email).font(.caption)
            Picker("Status", selection: $member.status) {
                ForEach(TeamStatus.allCases, id: \.self) { s in Text(s.rawValue).tag(s) }
            }.pickerStyle(.segmented)
        }
        .padding(16).background(Color.gray.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Settings View
struct SettingsView: View {
    @ObservedObject var store: AppStore
    @StateObject private var themeManager = ThemeManager.shared
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("⚙️ Settings")
                    .font(.system(size: 32, weight: .bold))
                
                // Appearance
                VStack(alignment: .leading, spacing: 16) {
                    Text("Appearance").font(.headline)
                    Picker("Theme", selection: $themeManager.theme) {
                        Text("System").tag("system")
                        Text("Light").tag("light")
                        Text("Dark").tag("dark")
                    }.pickerStyle(.segmented)
                    .frame(width: 300)
                    
                    HStack {
                        Text("Sidebar Width")
                        Slider(value: $themeManager.sidebarWidth, in: 180...350).frame(width: 200)
                        Text("\(Int(themeManager.sidebarWidth))").frame(width: 40)
                    }
                }
                .padding(20).background(Color.gray.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 16))
                
                // Data
                VStack(alignment: .leading, spacing: 16) {
                    Text("Data").font(.headline)
                    Toggle("Auto Save", isOn: $store.settings.autoSave)
                    if store.settings.autoSave {
                        Picker("Auto Save Interval", selection: $store.settings.autoSaveInterval) {
                            Text("15 sec").tag(15)
                            Text("30 sec").tag(30)
                            Text("60 sec").tag(60)
                        }.frame(width: 150)
                    }
                }
                .padding(20).background(Color.gray.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 16))
                
                // Actions
                VStack(alignment: .leading, spacing: 16) {
                    Text("Actions").font(.headline)
                    HStack {
                        Button("Export All Data") {
                            store.exportData()
                        }.buttonStyle(.bordered)
                        Button("Import Data") {
                            store.importData()
                        }.buttonStyle(.bordered)
                        Button("Reset Data") {
                            store.resetData()
                        }.buttonStyle(.bordered).tint(.red)
                    }
                }
                .padding(20).background(Color.gray.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 16))
                
                // About
                VStack(alignment: .leading, spacing: 8) {
                    Text("About").font(.headline)
                    Text("Mission Control v1.0").foregroundStyle(.secondary)
                    Text("Built with SwiftUI").foregroundStyle(.secondary)
                }
                .padding(20).background(Color.gray.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 16))
                
                Spacer()
            }
            .padding(32)
        }
    }
}

// MARK: - Shortcuts View
struct ShortcutsView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("⌨️ Keyboard Shortcuts")
                    .font(.system(size: 32, weight: .bold))
                
                ShortcutSection(title: "Global", shortcuts: [
                    ("⌘K", "Command Palette"),
                    ("⌘N", "New Project"),
                    ("⌘S", "Save"),
                    ("⌘1-9", "Switch Panels")
                ])
                
                ShortcutSection(title: "Navigation", shortcuts: [
                    ("⌘1", "Focus"),
                    ("⌘2", "Planning"),
                    ("⌘3", "Researching"),
                    ("⌘4", "Tech Spec"),
                    ("⌘5", "Design"),
                    ("⌘6", "Wireframes")
                ])
                
                ShortcutSection(title: "Editing", shortcuts: [
                    ("⌘C", "Copy"),
                    ("⌘V", "Paste"),
                    ("⌘Z", "Undo"),
                    ("⌘⇧Z", "Redo")
                ])
                
                ShortcutSection(title: "Mission Control", shortcuts: [
                    ("⌘,", "Settings"),
                    ("⌘R", "Refresh"),
                    ("⌘W", "Close")
                ])
            }
            .padding(32)
        }
    }
}

struct ShortcutSection: View {
    let title: String
    let shortcuts: [(String, String)]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title).font(.headline)
            ForEach(shortcuts, id: \.0) { shortcut, description in
                HStack {
                    Text(shortcut)
                        .font(.system(.body, design: .monospaced))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.gray.opacity(0.15))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                    Text(description)
                        .foregroundStyle(.secondary)
                    Spacer()
                }
            }
        }
        .padding(16).background(Color.gray.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Calendar View
struct CalendarView: View {
    @ObservedObject var store: AppStore
    @State private var selectedDate = Date()
    @State private var showingAddEvent = false
    
    var eventsForSelectedDate: [CalendarEvent] {
        let calendar = Calendar.current
        return store.calendarEvents.filter { calendar.isDate($0.startDate, inSameDayAs: selectedDate) }
    }
    
    var upcomingEvents: [CalendarEvent] {
        store.calendarEvents.filter { $0.startDate > Date() }.sorted { $0.startDate < $1.startDate }.prefix(5).map { $0 }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                HStack {
                    Text("📅 Calendar")
                        .font(.system(size: 32, weight: .bold))
                    Spacer()
                    Button {
                        store.calendarEvents.append(CalendarEvent(title: "New Event", startDate: selectedDate))
                    } label: {
                        Label("Add Event", systemImage: "plus")
                    }.buttonStyle(.borderedProminent)
                }
                
                // Date Picker
                DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .padding(16)
                    .background(Color.gray.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                
                // Events for selected date
                if !eventsForSelectedDate.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Events on \(selectedDate.formatted(date: .abbreviated, time: .omitted))")
                            .font(.headline)
                        ForEach($store.calendarEvents.filter { Calendar.current.isDate($0.startDate.wrappedValue, inSameDayAs: selectedDate) }) { $event in
                            EventRow(event: $event)
                        }
                    }
                }
                
                // Upcoming Events
                if !upcomingEvents.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Upcoming").font(.headline)
                        ForEach(upcomingEvents) { event in
                            HStack {
                                Circle().fill(Color(hex: event.color) ?? .blue).frame(width: 8, height: 8)
                                Text(event.title)
                                Spacer()
                                Text(event.startDate.formatted(date: .abbreviated, time: .omitted))
                                    .font(.caption).foregroundStyle(.secondary)
                            }
                            .padding(8).background(Color.gray.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 6))
                        }
                    }
                }
                
                if store.calendarEvents.isEmpty {
                    ContentUnavailableView("No Events", systemImage: "calendar.badge.plus", description: Text("Add calendar events"))
                }
            }
            .padding(32)
        }
    }
}

struct EventRow: View {
    @Binding var event: CalendarEvent
    var body: some View {
        HStack {
            TextField("Event", text: $event.title).font(.headline)
            Spacer()
            DatePicker("", selection: $event.startDate, displayedComponents: .hourAndMinute)
                .labelsHidden()
        }
        .padding(12).background(Color(hex: event.color)?.opacity(0.1) ?? Color.gray.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

// MARK: - Todos View
struct TodosView: View {
    @ObservedObject var store: AppStore
    @State private var newTodoTitle = ""
    @State private var filterPriority: Int? = nil
    
    var filteredTodos: [Todo] {
        var todos = store.todos.sorted { !$0.isCompleted && $1.isCompleted }
        if let priority = filterPriority {
            todos = todos.filter { $0.priority == priority }
        }
        return todos
    }
    
    var incompleteTodos: [Todo] { store.todos.filter { !$0.isCompleted } }
    var completedTodos: [Todo] { store.todos.filter { $0.isCompleted } }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                HStack {
                    Text("✅ Todos")
                        .font(.system(size: 32, weight: .bold))
                    Spacer()
                    Text("\(incompleteTodos.count) remaining")
                        .foregroundStyle(.secondary)
                }
                
                // Add new todo
                HStack {
                    TextField("Add a todo...", text: $newTodoTitle)
                        .textFieldStyle(.roundedBorder)
                        .onSubmit {
                            if !newTodoTitle.isEmpty {
                                store.todos.append(Todo(title: newTodoTitle, priority: 3))
                                newTodoTitle = ""
                            }
                        }
                    Button {
                        if !newTodoTitle.isEmpty {
                            store.todos.append(Todo(title: newTodoTitle, priority: 3))
                            newTodoTitle = ""
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }.disabled(newTodoTitle.isEmpty)
                }
                
                // Filter
                HStack {
                    Button("All") { filterPriority = nil }
                        .buttonStyle(.bordered).tint(filterPriority == nil ? .blue : .gray)
                    Button("High") { filterPriority = 1 }
                        .buttonStyle(.bordered).tint(filterPriority == 1 ? .red : .gray)
                    Button("Medium") { filterPriority = 2 }
                        .buttonStyle(.bordered).tint(filterPriority == 2 ? .orange : .gray)
                    Button("Low") { filterPriority = 3 }
                        .buttonStyle(.bordered).tint(filterPriority == 3 ? .green : .gray)
                }
                
                // Todo List
                if filteredTodos.isEmpty {
                    ContentUnavailableView("No Todos", systemImage: "checklist", description: Text("Add todos to stay organized"))
                } else {
                    LazyVStack(spacing: 8) {
                        ForEach($store.todos) { $todo in
                            if filterPriority == nil || todo.priority == filterPriority {
                                TodoRow(todo: $todo)
                            }
                        }
                    }
                }
                
                // Completed
                if !completedTodos.isEmpty && filterPriority == nil {
                    Divider()
                    Text("Completed (\(completedTodos.count))")
                        .font(.headline).foregroundStyle(.secondary)
                    ForEach($store.todos.filter { $0.isCompleted }) { $todo in
                        TodoRow(todo: $todo)
                    }
                }
            }
            .padding(32)
        }
    }
}

struct TodoRow: View {
    @Binding var todo: Todo
    var priorityColor: Color {
        switch todo.priority {
        case 1: return .red
        case 2: return .orange
        default: return .green
        }
    }
    var body: some View {
        HStack {
            Button {
                todo.isCompleted.toggle()
            } label: {
                Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(todo.isCompleted ? .green : .secondary)
            }.buttonStyle(.plain)
            
            Text(todo.title)
                .strikethrough(todo.isCompleted)
                .foregroundStyle(todo.isCompleted ? .secondary : .primary)
            
            Spacer()
            
            Picker("Priority", selection: $todo.priority) {
                Text("High").tag(1)
                Text("Medium").tag(2)
                Text("Low").tag(3)
            }
            .pickerStyle(.segmented)
            .frame(width: 150)
            
            if let dueDate = todo.dueDate {
                Text(dueDate.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Button {
                if let index = getIndex(todo: todo) {
                    store.todos.remove(at: index)
                }
            } label: {
                Image(systemName: "trash").foregroundStyle(.red)
            }.buttonStyle(.plain)
        }
        .padding(12)
        .background(todo.isCompleted ? Color.gray.opacity(0.05) : priorityColor.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    func getIndex(todo: Todo) -> Int? {
        store.todos.firstIndex { $0.id == todo.id }
    }
}

// MARK: - Notes View
struct NotesView: View {
    @ObservedObject var store: AppStore
    @State private var selectedNote: Note?
    @State private var searchText = ""
    
    var filteredNotes: [Note] {
        if searchText.isEmpty { return store.notes }
        return store.notes.filter { $0.title.localizedCaseInsensitiveContains(searchText) || $0.content.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                HStack {
                    Text("📝 Notes")
                        .font(.system(size: 32, weight: .bold))
                    Spacer()
                    Button {
                        let newNote = Note(title: "New Note", content: "")
                        store.notes.append(newNote)
                        selectedNote = newNote
                    } label: {
                        Label("New Note", systemImage: "plus")
                    }.buttonStyle(.borderedProminent)
                }
                
                // Search
                HStack {
                    Image(systemName: "magnifyingglass").foregroundStyle(.secondary)
                    TextField("Search notes...", text: $searchText)
                }
                .padding(10).background(Color.gray.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8))
                
                if store.notes.isEmpty {
                    ContentUnavailableView("No Notes", systemImage: "note.text", description: Text("Create notes to capture ideas"))
                } else {
                    LazyVStack(spacing: 12) {
                        ForEach($store.notes) { $note in
                            NoteCard(note: $note, isSelected: selectedNote?.id == note.id)
                                .onTapGesture { selectedNote = note }
                        }
                    }
                }
                
                // Note Editor
                if let note = selectedNote {
                    Divider()
                    VStack(alignment: .leading, spacing: 12) {
                        TextField("Title", text: Binding(
                            get: { store.notes.first { $0.id == note.id }?.title ?? "" },
                            set: { newValue in
                                if let index = store.notes.firstIndex(where: { $0.id == note.id }) {
                                    store.notes[index].title = newValue
                                    store.notes[index].updatedAt = Date()
                                }
                            }
                        ))
                        .font(.title2.bold())
                        
                        TextEditor(text: Binding(
                            get: { store.notes.first { $0.id == note.id }?.content ?? "" },
                            set: { newValue in
                                if let index = store.notes.firstIndex(where: { $0.id == note.id }) {
                                    store.notes[index].content = newValue
                                    store.notes[index].updatedAt = Date()
                                }
                            }
                        ))
                        .frame(minHeight: 200)
                        .padding(8)
                        .background(Color.gray.opacity(0.05))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        
                        HStack {
                            Text("Last updated: \(note.updatedAt.formatted(date: .abbreviated, time: .shortened))")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Spacer()
                            Button(role: .destructive) {
                                if let index = store.notes.firstIndex(where: { $0.id == note.id }) {
                                    store.notes.remove(at: index)
                                    selectedNote = nil
                                }
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
            }
            .padding(32)
        }
    }
}

struct NoteCard: View {
    @Binding var note: Note
    let isSelected: Bool
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(note.title.isEmpty ? "Untitled" : note.title)
                .font(.headline)
            Text(note.content.isEmpty ? "No content" : String(note.content.prefix(100)))
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(2)
            HStack {
                Text(note.updatedAt.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
                if !note.tags.isEmpty {
                    Spacer()
                    ForEach(note.tags.prefix(3), id: \.self) { tag in
                        Text(tag).font(.caption2).padding(.horizontal, 6).padding(.vertical, 2).background(Color.blue.opacity(0.1)).clipShape(Capsule())
                    }
                }
            }
        }
        .padding(12)
        .background(isSelected ? Color.blue.opacity(0.1) : Color.gray.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2))
    }
}

// MARK: - History View
struct HistoryView: View {
    @ObservedObject var store: AppStore
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                HStack {
                    Text("📜 History")
                        .font(.system(size: 32, weight: .bold))
                    Spacer()
                    Text("\(store.history.count) entries")
                        .foregroundStyle(.secondary)
                }
                
                if store.history.isEmpty {
                    ContentUnavailableView("No History", systemImage: "clock.arrow.circlepath", description: Text("Activity will appear here"))
                } else {
                    // Group by date
                    let grouped = Dictionary(grouping: store.history) { entry in
                        Calendar.current.startOfDay(for: entry.timestamp)
                    }
                    
                    ForEach(grouped.keys.sorted(by: >), id: \.self) { date in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(date.formatted(date: .abbreviated, time: .omitted))
                                .font(.headline)
                                .foregroundStyle(.secondary)
                            
                            ForEach(grouped[date] ?? []) { entry in
                                HistoryEntryRow(entry: entry)
                            }
                        }
                    }
                }
                
                if !store.history.isEmpty {
                    Button("Clear History") {
                        store.history.removeAll()
                        store.save()
                    }.buttonStyle(.bordered).tint(.red)
                }
            }
            .padding(32)
        }
    }
}

struct HistoryEntryRow: View {
    let entry: HistoryEntry
    var categoryIcon: String {
        switch entry.category {
        case "project": return "📁"
        case "domain": return "🌐"
        case "patent": return "🔬"
        case "idea": return "💡"
        case "launch": return "🚀"
        default: return "📌"
        }
    }
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text(categoryIcon)
            VStack(alignment: .leading, spacing: 2) {
                Text(entry.action).font(.subheadline.bold())
                if !entry.details.isEmpty {
                    Text(entry.details).font(.caption).foregroundStyle(.secondary)
                }
            }
            Spacer()
            Text(entry.timestamp.formatted(date: .omitted, time: .shortened))
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding(12).background(Color.gray.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

// MARK: - Search View
struct SearchView: View {
    @ObservedObject var store: AppStore
    @State private var searchText = ""
    @State private var results: [SearchResult] = []
    
    struct SearchResult: Identifiable {
        let id = UUID()
        var title: String
        var type: String
        var icon: String
        var details: String
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("🔎 Search")
                    .font(.system(size: 32, weight: .bold))
                
                // Search Input
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("Search everything...", text: $searchText)
                        .textFieldStyle(.plain)
                        .onChange(of: searchText) { _, newValue in
                            performSearch(query: newValue)
                        }
                    if !searchText.isEmpty {
                        Button {
                            searchText = ""
                            results = []
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                        }.buttonStyle(.plain)
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                if results.isEmpty && !searchText.isEmpty {
                    Text("No results found")
                        .foregroundStyle(.secondary)
                }
                
                // Results
                LazyVStack(spacing: 12) {
                    ForEach(results) { result in
                        HStack {
                            Text(result.icon).font(.title2)
                            VStack(alignment: .leading) {
                                Text(result.title).font(.headline)
                                Text(result.type).font(.caption).foregroundStyle(.secondary)
                                if !result.details.isEmpty {
                                    Text(result.details).font(.caption).foregroundStyle(.tertiary)
                                }
                            }
                            Spacer()
                        }
                        .padding(12)
                        .background(Color.gray.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
                
                // Quick Stats
                if searchText.isEmpty {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Quick Stats").font(.headline)
                        HStack {
                            StatPill(title: "Projects", value: "\(store.projects.count)", icon: "📁")
                            StatPill(title: "Domains", value: "\(store.domains.count)", icon: "🌐")
                            StatPill(title: "Patents", value: "\(store.patents.count)", icon: "🔬")
                            StatPill(title: "Ideas", value: "\(store.ideas.count)", icon: "💡")
                        }
                    }
                }
            }
            .padding(32)
        }
    }
    
    func performSearch(query: String) {
        guard !query.isEmpty else {
            results = []
            return
        }
        
        var searchResults: [SearchResult] = []
        
        // Search projects
        for project in store.projects where project.name.localizedCaseInsensitiveContains(query) {
            searchResults.append(SearchResult(title: project.name, type: "Project", icon: "📁", details: project.status.rawValue))
        }
        
        // Search domains
        for domain in store.domains where domain.name.localizedCaseInsensitiveContains(query) {
            searchResults.append(SearchResult(title: domain.name, type: "Domain", icon: "🌐", details: domain.registrar))
        }
        
        // Search patents
        for patent in store.patents where patent.title.localizedCaseInsensitiveContains(query) {
            searchResults.append(SearchResult(title: patent.title, type: "Patent", icon: "🔬", details: patent.type.rawValue))
        }
        
        // Search ideas
        for idea in store.ideas where idea.title.localizedCaseInsensitiveContains(query) || idea.description.localizedCaseInsensitiveContains(query) {
            searchResults.append(SearchResult(title: idea.title, type: "Idea", icon: "💡", details: idea.status.rawValue))
        }
        
        // Search todos
        for todo in store.todos where todo.title.localizedCaseInsensitiveContains(query) {
            searchResults.append(SearchResult(title: todo.title, type: "Todo", icon: "✅", details: todo.isCompleted ? "Completed" : "Pending"))
        }
        
        // Search notes
        for note in store.notes where note.title.localizedCaseInsensitiveContains(query) || note.content.localizedCaseInsensitiveContains(query) {
            searchResults.append(SearchResult(title: note.title, type: "Note", icon: "📝", details: String(note.content.prefix(50))))
        }
        
        results = searchResults
    }
}

struct StatPill: View {
    let title: String
    let value: String
    let icon: String
    var body: some View {
        VStack(spacing: 4) {
            Text(icon)
            Text(value).font(.headline)
            Text(title).font(.caption).foregroundStyle(.secondary)
        }
        .padding(12)
        .background(Color.gray.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

// MARK: - Reports View
struct ReportsView: View {
    @ObservedObject var store: AppStore
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                HStack {
                    Text("📈 Reports")
                        .font(.system(size: 32, weight: .bold))
                    Spacer()
                    Button {
                        // Generate report
                    } label: {
                        Label("Generate", systemImage: "doc.badge.plus")
                    }.buttonStyle(.borderedProminent)
                }
                
                // Portfolio Overview
                VStack(alignment: .leading, spacing: 16) {
                    Text("Portfolio Overview").font(.headline)
                    
                    ReportCard(title: "Projects", value: "\(store.projects.count)", subtitle: "\(store.projects.filter { $0.status == .active }.count) active")
                    ReportCard(title: "Domains", value: "\(store.domains.count)", subtitle: "\(store.expiringDomains.count) expiring soon")
                    ReportCard(title: "Patents", value: "\(store.patents.count)", subtitle: "\(store.patents.filter { $0.status == .granted }.count) granted")
                    ReportCard(title: "Ideas", value: "\(store.ideas.count)", subtitle: "\(store.ideas.filter { $0.status == .building }.count) in progress")
                }
                .padding(20).background(Color.gray.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 16))
                
                // Financial Summary
                VStack(alignment: .leading, spacing: 16) {
                    Text("Financial Summary").font(.headline)
                    
                    HStack {
                        ReportMetric(title: "Total Revenue", value: "$\(Int(store.financials.totalRevenue))", color: .green)
                        ReportMetric(title: "Monthly Burn", value: "$\(Int(store.financials.monthlyBurn))", color: .red)
                        ReportMetric(title: "Runway", value: "\(Int(store.financials.runwayMonths)) mo", color: .orange)
                    }
                }
                .padding(20).background(Color.gray.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 16))
                
                // Quick Actions
                VStack(alignment: .leading, spacing: 12) {
                    Text("Export Reports").font(.headline)
                    HStack {
                        Button("Export Projects CSV") { exportProjectsCSV() }.buttonStyle(.bordered)
                        Button("Export Patents CSV") { exportPatentsCSV() }.buttonStyle(.bordered)
                        Button("Export All JSON") { store.exportData() }.buttonStyle(.bordered)
                    }
                }
            }
            .padding(32)
        }
    }
    
    func exportProjectsCSV() {
        var csv = "Name,Status,Priority,Stage,Due Date\n"
        for p in store.projects {
            csv += "\(p.name),\(p.status.rawValue),\(p.priority),\(p.stage.rawValue),\(p.dueDate.formatted(date: .iso8601, time: .omitted))\n"
        }
        saveCSV(csv, filename: "projects-export.csv")
    }
    
    func exportPatentsCSV() {
        var csv = "Title,Type,Status,Filing Date,Total Cost\n"
        for p in store.patents {
            csv += "\(p.title),\(p.type.rawValue),\(p.status.rawValue),\(p.filingDate.formatted(date: .iso8601, time: .omitted)),$\(Int(p.totalCost))\n"
        }
        saveCSV(csv, filename: "patents-export.csv")
    }
    
    func saveCSV(_ content: String, filename: String) {
        let home = FileManager.default.homeDirectoryForCurrentUser.path
        let path = "\(home)/Desktop/\(filename)"
        try? content.write(toFile: path, atomically: true, encoding: .utf8)
        addActivity("Exported \(filename)")
    }
}

struct ReportCard: View {
    let title: String
    let value: String
    let subtitle: String
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title).font(.subheadline).foregroundStyle(.secondary)
                Text(value).font(.title2.bold())
                Text(subtitle).font(.caption).foregroundStyle(.tertiary)
            }
            Spacer()
        }
        .padding(12).background(Color.gray.opacity(0.05)).clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct ReportMetric: View {
    let title: String
    let value: String
    let color: Color
    var body: some View {
        VStack(spacing: 4) {
            Text(value).font(.title3.bold()).foregroundStyle(color)
            Text(title).font(.caption).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(12).background(color.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

// MARK: - Integrations View
struct IntegrationsView: View {
    @ObservedObject var store: AppStore
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("🔗 Integrations")
                    .font(.system(size: 32, weight: .bold))
                
                // Available Integrations
                VStack(alignment: .leading, spacing: 16) {
                    Text("Connected Services").font(.headline)
                    
                    IntegrationCard(name: "Zimaboard", status: store.zimaboard.online ? "Online" : "Offline", icon: "🖥️", description: "Automation server at 192.168.4.65")
                    IntegrationCard(name: "N8N", status: store.zimaboard.n8nReady ? "Ready" : "Not Deployed", icon: "🔄", description: "Workflow automation")
                    IntegrationCard(name: "Convex", status: "Ready", icon: "☁️", description: "Database sync (not connected)")
                    IntegrationCard(name: "Obsidian", status: "Ready", icon: "💎", description: "Notes sync (not connected)")
                }
                .padding(20).background(Color.gray.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 16))
                
                // Quick Connect
                VStack(alignment: .leading, spacing: 12) {
                    Text("Quick Connect").font(.headline)
                    HStack {
                        Button("Check Zimaboard") {
                            store.checkZimaboardStatus()
                        }.buttonStyle(.bordered)
                        Button("Open Portainer") {
                            store.openURL("http://192.168.4.65:9000")
                        }.buttonStyle(.bordered)
                        Button("Open N8N") {
                            store.openURL("http://192.168.4.65:5678")
                        }.buttonStyle(.bordered)
                    }
                }
                .padding(20).background(Color.gray.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 16))
                
                // API Keys (placeholder)
                VStack(alignment: .leading, spacing: 12) {
                    Text("API Keys").font(.headline)
                    HStack {
                        Text("Brave Search").font(.subheadline)
                        Spacer()
                        Text("Configured").foregroundStyle(.green).font(.caption)
                    }
                    HStack {
                        Text("GitHub").font(.subheadline)
                        Spacer()
                        Text("Configured").foregroundStyle(.green).font(.caption)
                    }
                }
                .padding(20).background(Color.gray.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(32)
        }
    }
}

struct IntegrationCard: View {
    let name: String
    let status: String
    let icon: String
    let description: String
    
    var statusColor: Color {
        status == "Online" || status == "Ready" ? .green : .orange
    }
    
    var body: some View {
        HStack {
            Text(icon).font(.title2)
            VStack(alignment: .leading) {
                Text(name).font(.headline)
                Text(description).font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
            HStack(spacing: 4) {
                Circle().fill(statusColor).frame(width: 6, height: 6)
                Text(status).font(.caption).foregroundStyle(statusColor)
            }
        }
        .padding(12).background(Color.gray.opacity(0.05)).clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

// MARK: - Automation View
struct AutomationView: View {
    @ObservedObject var store: AppStore
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                HStack {
                    Text("⚙️ Automation")
                        .font(.system(size: 32, weight: .bold))
                    Spacer()
                    Button {
                        store.checkZimaboardStatus()
                    } label: {
                        Label("Refresh", systemImage: "arrow.clockwise")
                    }.buttonStyle(.bordered)
                }
                
                // Zimaboard Status
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Zimaboard").font(.headline)
                        Spacer()
                        HStack(spacing: 4) {
                            Circle().fill(store.zimaboard.online ? .green : .red).frame(width: 8, height: 8)
                            Text(store.zimaboard.online ? "Online" : "Offline").font(.caption).foregroundStyle(store.zimaboard.online ? .green : .red)
                        }
                    }
                    
                    if store.zimaboard.online {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("IP: 192.168.4.65").font(.subheadline)
                                Text("RAM: 16GB").font(.caption).foregroundStyle(.secondary)
                            }
                            Spacer()
                            Button("Open Portainer") {
                                store.openURL("http://192.168.4.65:9000")
                            }.buttonStyle(.bordered)
                            Button("Open N8N") {
                                store.openURL("http://192.168.4.65:5678")
                            }.buttonStyle(.borderedProminent)
                        }
                    }
                }
                .padding(20).background(Color.gray.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 16))
                
                // Quick Automations
                VStack(alignment: .leading, spacing: 16) {
                    Text("Quick Automations").font(.headline)
                    
                    AutomationRow(title: "Deploy N8N", description: "Deploy workflow automation to Zimaboard", status: store.zimaboard.n8nReady ? "Ready" : "Not Deployed", icon: "🔄")
                    AutomationRow(title: "Affiliate Stack", description: "N8N + Redis + Postgres + Minio", status: "Not Deployed", icon: "📦")
                    AutomationRow(title: "OpenArt Bulk", description: "Generate 500 images in batch", status: "Ready", icon: "🎨")
                    AutomationRow(title: "111 Method Scaler", description: "Auto-kill losers, scale winners", status: "Ready", icon: "📈")
                }
                .padding(20).background(Color.gray.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 16))
                
                // Workflow Templates
                VStack(alignment: .leading, spacing: 12) {
                    Text("Workflow Templates").font(.headline)
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        WorkflowCard(name: "Content Gen", icon: "✍️", count: 3)
                        WorkflowCard(name: "Email", icon: "📧", count: 2)
                        WorkflowCard(name: "Social", icon: "📱", count: 5)
                        WorkflowCard(name: "Analytics", icon: "📊", count: 4)
                    }
                }
                .padding(20).background(Color.gray.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(32)
        }
    }
}

struct AutomationRow: View {
    let title: String
    let description: String
    let status: String
    let icon: String
    
    var statusColor: Color {
        status == "Ready" ? .green : .orange
    }
    
    var body: some View {
        HStack {
            Text(icon).font(.title2)
            VStack(alignment: .leading) {
                Text(title).font(.headline)
                Text(description).font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
            Text(status).font(.caption).foregroundStyle(statusColor)
        }
        .padding(12).background(Color.gray.opacity(0.05)).clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct WorkflowCard: View {
    let name: String
    let icon: String
    let count: Int
    var body: some View {
        VStack(spacing: 8) {
            Text(icon).font(.title)
            Text(name).font(.subheadline)
            Text("\(count) workflows").font(.caption).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(16).background(Color.gray.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Monitoring View
struct MonitoringView: View {
    @ObservedObject var store: AppStore
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("📊 Monitoring")
                    .font(.system(size: 32, weight: .bold))
                
                // System Health
                VStack(alignment: .leading, spacing: 16) {
                    Text("System Health").font(.headline)
                    HStack {
                        MonitorPill(title: "Zimaboard", value: store.zimaboard.online ? "Online" : "Offline", color: store.zimaboard.online ? .green : .red)
                        MonitorPill(title: "N8N", value: store.zimaboard.n8nReady ? "Ready" : "Pending", color: store.zimaboard.n8nReady ? .green : .orange)
                        MonitorPill(title: "Portainer", value: "Online", color: .green)
                    }
                }
                .padding(20).background(Color.gray.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 16))
                
                // Activity Feed
                VStack(alignment: .leading, spacing: 12) {
                    Text("Recent Activity").font(.headline)
                    if store.recentActivity.isEmpty {
                        Text("No recent activity").foregroundStyle(.secondary)
                    } else {
                        ForEach(store.recentActivity.prefix(10), id: \.self) { activity in
                            Text(activity).font(.caption).foregroundStyle(.secondary)
                        }
                    }
                }
                .padding(20).background(Color.gray.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 16))
                
                // Quick Stats
                VStack(alignment: .leading, spacing: 16) {
                    Text("Quick Stats").font(.headline)
                    HStack {
                        StatBox(title: "Projects", value: "\(store.projects.count)", icon: "📁")
                        StatBox(title: "Ideas", value: "\(store.ideas.count)", icon: "💡")
                        StatBox(title: "Patents", value: "\(store.patents.count)", icon: "🔬")
                        StatBox(title: "Domains", value: "\(store.domains.count)", icon: "🌐")
                    }
                }
                .padding(20).background(Color.gray.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(32)
        }
    }
}

struct MonitorPill: View {
    let title: String
    let value: String
    let color: Color
    var body: some View {
        VStack(spacing: 4) {
            Text(value).font(.headline).foregroundStyle(color)
            Text(title).font(.caption).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(12).background(color.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct StatBox: View {
    let title: String
    let value: String
    let icon: String
    var body: some View {
        VStack(spacing: 4) {
            Text(icon)
            Text(value).font(.title3.bold())
            Text(title).font(.caption).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(12).background(Color.gray.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

// MARK: - Knowledge Base View
struct KnowledgeBaseView: View {
    @ObservedObject var store: AppStore
    @State private var searchText = ""
    @State private var selectedCategory = "All"
    
    let categories = ["All", "Projects", "Patents", "Domains", "Ideas", "Technical"]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                HStack {
                    Text("📚 Knowledge Base")
                        .font(.system(size: 32, weight: .bold))
                    Spacer()
                    Button {
                        // Add article
                    } label: {
                        Label("Add Article", systemImage: "plus")
                    }.buttonStyle(.borderedProminent)
                }
                
                // Search & Filter
                HStack {
                    Image(systemName: "magnifyingglass").foregroundStyle(.secondary)
                    TextField("Search articles...", text: $searchText)
                }
                .padding(10).background(Color.gray.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8))
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(categories, id: \.self) { cat in
                            Button(cat) { selectedCategory = cat }
                                .buttonStyle(.bordered)
                                .tint(selectedCategory == cat ? .blue : .gray)
                        }
                    }
                }
                
                // Quick Reference Cards
                VStack(alignment: .leading, spacing: 16) {
                    Text("Quick Reference").font(.headline)
                    
                    KBCard(title: "USPTO Fees 2026", icon: "💰", category: "Patents", content: "Micro: $65 filing, Small: $250, Large: $750")
                    KBCard(title: "Zimaboard Access", icon: "🖥️", category: "Technical", content: "IP: 192.168.4.65 | Portainer: 9000 | N8N: 5678")
                    KBCard(title: "Git Commands", icon: "📝", category: "Technical", content: "git add . && git commit -m \"...\" && git push")
                    KBCard(title: "Keyboard Shortcuts", icon: "⌨️", category: "All", content: "⌘K Command Palette | ⌘N New | ⌘S Save")
                }
                
                // Recent Articles
                VStack(alignment: .leading, spacing: 12) {
                    Text("Recent").font(.headline)
                    Text("No articles yet - add your first!").foregroundStyle(.secondary).italic()
                }
            }
            .padding(32)
        }
    }
}

struct KBCard: View {
    let title: String
    let icon: String
    let category: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(icon)
                Text(title).font(.headline)
                Spacer()
                Text(category).font(.caption).padding(.horizontal, 8).padding(.vertical, 2).background(Color.blue.opacity(0.1)).clipShape(Capsule())
            }
            Text(content).font(.subheadline).foregroundStyle(.secondary)
        }
        .padding(16).background(Color.gray.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Command Palette
struct CommandPaletteView: View {
    @ObservedObject var store: AppStore
    @State private var searchText: String = ""
    @Environment(\.dismiss) private var dismiss
    
    var filteredPanels: [Panel] {
        Panel.allCases.filter { $0.rawValue.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Search
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                TextField("Search panels...", text: $searchText)
                    .textFieldStyle(.plain)
                if !searchText.isEmpty {
                    Button {
                        searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            
            // Results
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(filteredPanels) { panel in
                        Button {
                            store.selectedPanel = panel
                            dismiss()
                        } label: {
                            HStack {
                                Text(panel.icon)
                                Text(panel.rawValue)
                                    .foregroundStyle(.primary)
                                Spacer()
                                Text(panel.category)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        
                        Divider()
                    }
                }
            }
        }
        .frame(width: 500, height: 400)
    }
}

// MARK: - App Store (Persistence)
class AppStore: ObservableObject {
    @Published var selectedPanel: Panel = .focus
    @Published var searchText: String = ""
    @Published var editingFlagship: Bool = false
    
    // Core
    @Published var flagship: String = "AI Agent Platform"
    @Published var priorities: [String] = ["Build IP portfolio", "Scale automation"]
    @Published var recentActivity: [String] = []
    
    // Data
    @Published var projects: [Project] = []
    @Published var domains: [Domain] = []
    @Published var patents: [PatentModel] = []
    
    // Research
    @Published var competitors: [String] = []
    @Published var technologies: [String] = ["SwiftUI", "Node.js", "PostgreSQL"]
    @Published var marketTrends: [String] = []
    @Published var userInsights: [String] = []
    
    // Tech Spec
    @Published var techSpec = TechSpecModel()
    @Published var designSystem = DesignSystemModel()
    
    // Development
    @Published var wireframes: [Wireframe] = []
    @Published var frontend = FrontendStack()
    @Published var backend = BackendStack()
    @Published var databases: [DatabaseModel] = []
    @Published var apis: [APIModel] = []
    
    // DevOps
    @Published var cicd = CICDModel()
    @Published var workflows: [Workflow] = []
    
    // Infrastructure
    @Published var zimaboard = ZimaboardModel()
    @Published var installedSkills: [InstalledSkill] = []
    
    // New Features
    @Published var ideas: [Idea] = []
    @Published var metrics = MetricsModel()
    @Published var financials = FinancialsModel()
    @Published var launches: [Launch] = []
    @Published var assets: [Asset] = []
    @Published var team: [TeamMember] = []
    @Published var settings = AppSettings()
    @Published var todos: [Todo] = []
    @Published var calendarEvents: [CalendarEvent] = []
    @Published var notes: [Note] = []
    @Published var history: [HistoryEntry] = []
    
    private let dataPath: String
    
    init() {
        let home = FileManager.default.homeDirectoryForCurrentUser.path
        dataPath = "\(home)/.openclaw/workspace/mission-control-macos/data"
        load()
        loadSkills()
    }
    
    // MARK: - Persistence
    func load() {
        let fileManager = FileManager.default
        let path = dataPath
        
        // Ensure directory exists
        if !fileManager.fileExists(atPath: path) {
            try? fileManager.createDirectory(atPath: path, withIntermediateDirectories: true)
        }
        
        flagship = loadValue("flagship", default: "AI Agent Platform")
        priorities = loadValue("priorities", default: ["Build IP portfolio"])
        
        projects = loadValue("projects", default: [Project]())
        domains = loadValue("domains", default: [Domain]())
        patents = loadValue("patents", default: [PatentModel]())
        
        competitors = loadValue("competitors", default: [])
        technologies = loadValue("technologies", default: ["SwiftUI"])
        marketTrends = loadValue("marketTrends", default: [])
        userInsights = loadValue("userInsights", default: [])
        
        techSpec = loadValue("techSpec", default: TechSpecModel())
        designSystem = loadValue("designSystem", default: DesignSystemModel())
        
        wireframes = loadValue("wireframes", default: [])
        frontend = loadValue("frontend", default: FrontendStack())
        backend = loadValue("backend", default: BackendStack())
        databases = loadValue("databases", default: [])
        apis = loadValue("apis", default: [])
        
        cicd = loadValue("cicd", default: CICDModel())
        workflows = loadValue("workflows", default: [])
        
        zimaboard = loadValue("zimaboard", default: ZimaboardModel())
        
        // New Features
        ideas = loadValue("ideas", default: [])
        metrics = loadValue("metrics", default: MetricsModel())
        financials = loadValue("financials", default: FinancialsModel())
        launches = loadValue("launches", default: [])
        assets = loadValue("assets", default: [])
        team = loadValue("team", default: [])
        settings = loadValue("settings", default: AppSettings())
        todos = loadValue("todos", default: [])
        calendarEvents = loadValue("calendarEvents", default: [])
        notes = loadValue("notes", default: [])
        history = loadValue("history", default: [])
    }
    
    func save() {
        saveValue(flagship, key: "flagship")
        saveValue(priorities, key: "priorities")
        
        saveValue(projects, key: "projects")
        saveValue(domains, key: "domains")
        saveValue(patents, key: "patents")
        
        saveValue(competitors, key: "competitors")
        saveValue(technologies, key: "technologies")
        saveValue(marketTrends, key: "marketTrends")
        saveValue(userInsights, key: "userInsights")
        
        saveValue(techSpec, key: "techSpec")
        saveValue(designSystem, key: "designSystem")
        
        saveValue(wireframes, key: "wireframes")
        saveValue(frontend, key: "frontend")
        saveValue(backend, key: "backend")
        saveValue(databases, key: "databases")
        saveValue(apis, key: "apis")
        
        saveValue(cicd, key: "cicd")
        saveValue(workflows, key: "workflows")
        
        saveValue(zimaboard, key: "zimaboard")
        
        // New Features
        saveValue(ideas, key: "ideas")
        saveValue(metrics, key: "metrics")
        saveValue(financials, key: "financials")
        saveValue(launches, key: "launches")
        saveValue(assets, key: "assets")
        saveValue(team, key: "team")
        saveValue(settings, key: "settings")
        saveValue(todos, key: "todos")
        saveValue(calendarEvents, key: "calendarEvents")
        saveValue(notes, key: "notes")
        saveValue(history, key: "history")
        
        addActivity("Data saved")
    }
    
    private func loadValue<T: Codable>(_ key: String, default defaultValue: T) -> T {
        let file = "\(dataPath)/\(key).json"
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: file)),
              let value = try? JSONDecoder().decode(T.self, from: data) else {
            return defaultValue
        }
        return value
    }
    
    private func saveValue<T: Codable>(_ value: T, key: String) {
        let file = "\(dataPath)/\(key).json"
        guard let data = try? JSONEncoder().encode(value) else { return }
        try? data.write(to: URL(fileURLWithPath: file))
    }
    
    // MARK: - Skills
    func loadSkills() {
        let skillsPath = "/opt/homebrew/lib/node_modules/openclaw/skills"
        let fileManager = FileManager.default
        var skills: [InstalledSkill] = []
        
        if let contents = try? fileManager.contentsOfDirectory(atPath: skillsPath) {
            for item in contents {
                let itemPath = "\(skillsPath)/\(item)/SKILL.md"
                if fileManager.fileExists(atPath: itemPath),
                   let content = try? String(contentsOfFile: itemPath, encoding: .utf8) {
                    let skill = parseSkill(name: item, content: content)
                    skills.append(skill)
                }
            }
        }
        
        installedSkills = skills.sorted { $0.name < $1.name }
        addActivity("Loaded \(installedSkills.count) skills")
    }
    
    func parseSkill(name: String, content: String) -> InstalledSkill {
        var description = ""
        var category = "Development"
        
        let lines = content.components(separatedBy: "\n")
        for line in lines {
            let trimmed = line.trimmingCharacters(in: .whitespaces)
            if trimmed.hasPrefix("# ") { continue }
            if trimmed.hasPrefix("---") { continue }
            if !trimmed.isEmpty {
                description = String(trimmed.prefix(100))
                break
            }
        }
        
        let devOps = ["docker", "n8n", "cicd", "github", "git", "tmux", "workflow"]
        let ai = ["openai", "gemini", "whisper", "llm", "ai"]
        let design = ["figma", "design", "shadcn", "ui"]
        let productivity = ["notes", "tasks", "calendar", "reminders", "todo"]
        
        let lowerName = name.lowercased()
        if devOps.contains(where: { lowerName.contains($0) }) { category = "DevOps" }
        else if ai.contains(where: { lowerName.contains($0) }) { category = "AI/ML" }
        else if design.contains(where: { lowerName.contains($0) }) { category = "Design" }
        else if productivity.contains(where: { lowerName.contains($0) }) { category = "Productivity" }
        
        return InstalledSkill(
            name: name.replacingOccurrences(of: "-", with: " ").capitalized,
            category: category,
            description: description,
            icon: iconFor(name),
            path: "/opt/homebrew/lib/node_modules/openclaw/skills/\(name)"
        )
    }
    
    func iconFor(_ name: String) -> String {
        let lower = name.lowercased()
        if lower.contains("github") { return "🐙" }
        if lower.contains("docker") { return "🐳" }
        if lower.contains("n8n") { return "🔄" }
        if lower.contains("openai") { return "🤖" }
        if lower.contains("gemini") { return "✨" }
        if lower.contains("obsidian") { return "💎" }
        if lower.contains("notes") { return "📝" }
        if lower.contains("calendar") { return "📅" }
        if lower.contains("weather") { return "🌤️" }
        if lower.contains("spotify") || lower.contains("music") { return "🎵" }
        if lower.contains("video") { return "🎬" }
        if lower.contains("twitter") || lower.contains("social") { return "🐦" }
        return "🧩"
    }
    
    // MARK: - Computed Properties
    var expiringDomains: [Domain] {
        domains.filter { $0.daysUntilExpiry < 30 && $0.status == "Active" }
    }
    
    var totalPatentCosts: Double {
        patents.reduce(0) { $0 + $1.totalCost }
    }
    
    var patentDeadlines: [PatentDeadline] {
        patents.compactMap { patent -> PatentDeadline? in
            let deadline = patent.continuationDeadline
            guard deadline > Date() else { return nil }
            return PatentDeadline(patentId: patent.id, title: "\(patent.title) - Continuation Due", date: deadline)
        }
    }
    
    // MARK: - Actions
    func addProject(_ project: Project) {
        projects.append(project)
        addActivity("Added project: \(project.name)")
        save()
    }
    
    func deleteProject(_ project: Project) {
        projects.removeAll { $0.id == project.id }
        addActivity("Deleted project: \(project.name)")
        save()
    }
    
    func deleteDomain(_ domain: Domain) {
        domains.removeAll { $0.id == domain.id }
        save()
    }
    
    func deletePatent(_ patent: PatentModel) {
        patents.removeAll { $0.id == patent.id }
        save()
    }
    
    func deleteDatabase(_ db: DatabaseModel) {
        databases.removeAll { $0.id == db.id }
        save()
    }
    
    func deleteAPI(_ api: APIModel) {
        apis.removeAll { $0.id == api.id }
        save()
    }
    
    func deleteWorkflow(_ workflow: Workflow) {
        workflows.removeAll { $0.id == workflow.id }
        save()
    }
    
    func addActivity(_ activity: String) {
        let timestamp = Date().formatted(date: .omitted, time: .shortened)
        recentActivity.insert("[\(timestamp)] \(activity)", at: 0)
        if recentActivity.count > 20 {
            recentActivity = Array(recentActivity.prefix(20))
        }
        
        // Also add to history
        history.insert(HistoryEntry(action: activity, timestamp: Date()), at: 0)
        if history.count > 100 {
            history = Array(history.prefix(100))
        }
    }
    
    func checkZimaboardStatus() {
        // In a real app, this would ping the server
        addActivity("Checked Zimaboard status")
    }
    
    func openURL(_ url: String) {
        NSWorkspace.shared.open(URL(string: url)!)
    }
    
    func exportData() {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        
        var exportData: [String: Any] = [:]
        
        // Export all data
        if let data = try? encoder.encode(flagship) { exportData["flagship"] = String(data: data, encoding: .utf8) }
        if let data = try? encoder.encode(priorities) { exportData["priorities"] = String(data: data, encoding: .utf8) }
        if let data = try? encoder.encode(projects) { exportData["projects"] = String(data: data, encoding: .utf8) }
        if let data = try? encoder.encode(domains) { exportData["domains"] = String(data: data, encoding: .utf8) }
        if let data = try? encoder.encode(patents) { exportData["patents"] = String(data: data, encoding: .utf8) }
        if let data = try? encoder.encode(ideas) { exportData["ideas"] = String(data: data, encoding: .utf8) }
        if let data = try? encoder.encode(launches) { exportData["launches"] = String(data: data, encoding: .utf8) }
        if let data = try? encoder.encode(assets) { exportData["assets"] = String(data: data, encoding: .utf8) }
        if let data = try? encoder.encode(team) { exportData["team"] = String(data: data, encoding: .utf8) }
        if let data = try? encoder.encode(metrics) { exportData["metrics"] = String(data: data, encoding: .utf8) }
        if let data = try? encoder.encode(financials) { exportData["financials"] = String(data: data, encoding: .utf8) }
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: exportData, options: .prettyPrinted),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            // Save to file
            let home = FileManager.default.homeDirectoryForCurrentUser.path
            let exportPath = "\(home)/Desktop/mission-control-export-\(Date().timeIntervalSince1970).json"
            try? jsonString.write(toFile: exportPath, atomically: true, encoding: .utf8)
            addActivity("Data exported to Desktop")
        }
    }
    
    func importData() {
        let home = FileManager.default.homeDirectoryForCurrentUser.path
        let importPath = "\(home)/Desktop/mission-control-export.json"
        
        guard let jsonString = try? String(contentsOfFile: importPath, encoding: .utf8),
              let jsonData = jsonString.data(using: .utf8),
              let json = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any] else {
            addActivity("Import failed - file not found")
            return
        }
        
        let decoder = JSONDecoder()
        
        if let data = (json["projects"] as? String)?.data(using: .utf8),
           let value = try? decoder.decode([Project].self, from: data) { projects = value }
        if let data = (json["domains"] as? String)?.data(using: .utf8),
           let value = try? decoder.decode([Domain].self, from: data) { domains = value }
        if let data = (json["patents"] as? String)?.data(using: .utf8),
           let value = try? decoder.decode([PatentModel].self, from: data) { patents = value }
        if let data = (json["ideas"] as? String)?.data(using: .utf8),
           let value = try? decoder.decode([Idea].self, from: data) { ideas = value }
        if let data = (json["launches"] as? String)?.data(using: .utf8),
           let value = try? decoder.decode([Launch].self, from: data) { launches = value }
        if let data = (json["assets"] as? String)?.data(using: .utf8),
           let value = try? decoder.decode([Asset].self, from: data) { assets = value }
        if let data = (json["team"] as? String)?.data(using: .utf8),
           let value = try? decoder.decode([TeamMember].self, from: data) { team = value }
        
        save()
        addActivity("Data imported from Desktop")
    }
    
    func resetData() {
        projects = []
        domains = []
        patents = []
        ideas = []
        launches = []
        assets = []
        team = []
        todos = []
        calendarEvents = []
        competitors = []
        technologies = []
        marketTrends = []
        userInsights = []
        wireframes = []
        databases = []
        apis = []
        workflows = []
        financials = FinancialsModel()
        metrics = MetricsModel()
        
        save()
        addActivity("All data reset")
    }
}

// MARK: - Models
struct InstalledSkill: Identifiable {
    let id = UUID()
    var name: String
    var category: String
    var description: String
    var icon: String
    var path: String
}

struct TechSpecModel: Codable {
    var architecture: [String] = []
    var techStack: [String] = []
    var security: [String] = []
    var performance: [String] = []
    var infrastructure: [String] = []
}

struct DesignSystemModel: Codable {
    var colors: [String] = ["#007AFF", "#34C759", "#FF9500", "#FF3B30"]
    var fonts: [String] = ["SF Pro Display", "SF Pro Text"]
    var components: [String] = []
}

struct FrontendStack: Codable {
    var frameworks: [String] = ["SwiftUI", "React"]
    var styling: [String] = ["CSS", "Tailwind"]
    var state: [String] = ["Redux", "Context"]
    var testing: [String] = ["Vitest", "Playwright"]
    var buildTools: [String] = ["Vite", "Webpack"]
    var components: [String] = []
}

struct BackendStack: Codable {
    var languages: [String] = ["Node.js", "Python", "Swift"]
    var frameworks: [String] = ["Express", "FastAPI"]
    var services: [String] = ["AWS Lambda"]
    var auth: [String] = ["JWT", "OAuth"]
}

struct CICDModel: Codable {
    var pipelines: Int = 3
    var tests: Int = 0
    var deployments: Int = 0
    var passes: Bool = true
    var pipelineNames: [String] = ["Build", "Test", "Deploy"]
}

struct ZimaboardModel: Codable {
    var online: Bool = true
    var n8nReady: Bool = false
    var n8nWorkflows: [String] = ["Not deployed"]
}

// MARK: - Ideas Model
struct Idea: Identifiable, Codable {
    var id: UUID = UUID()
    var title: String = ""
    var description: String = ""
    var score: Int = 5 // 1-10
    var tags: [String] = []
    var status: IdeaStatus = .concept
    var createdAt: Date = Date()
    var updatedAt: Date = Date()
}

enum IdeaStatus: String, Codable, CaseIterable {
    case concept = "Concept"
    case validating = "Validating"
    case building = "Building"
    case launched = "Launched"
    case archived = "Archived"
}

// MARK: - Metrics Model
struct MetricsModel: Codable {
    var activeProjects: Int = 0
    var completedProjects: Int = 0
    var totalRevenue: Double = 0
    var monthlyRecurringRevenue: Double = 0
    var activeUsers: Int = 0
    var trialUsers: Int = 0
    var churnRate: Double = 0
    var nps: Int = 0
    var uptime: Double = 99.9
    var apiCalls: Int = 0
    var errorRate: Double = 0
    var avgResponseTime: Double = 0
    var lastUpdated: Date = Date()
}

// MARK: - Financials Model
struct FinancialsModel: Codable {
    var cash: Double = 0
    var receivables: Double = 0
    var payables: Double = 0
    var monthlyBurn: Double = 0
    var runwayMonths: Double = 0
    var revenue: [MonthlyRevenue] = []
    var expenses: [MonthlyExpense] = []
    var investments: Double = 0
    var lastUpdated: Date = Date()
}

struct MonthlyRevenue: Identifiable, Codable {
    var id: UUID = UUID()
    var month: String = ""
    var amount: Double = 0
    var source: String = ""
}

struct MonthlyExpense: Identifiable, Codable {
    var id: UUID = UUID()
    var month: String = ""
    var category: String = ""
    var amount: Double = 0
}

// MARK: - Launch Model
struct Launch: Identifiable, Codable {
    var id: UUID = UUID()
    var name: String = ""
    var description: String = ""
    var targetDate: Date = Date()
    var status: LaunchStatus = .planning
    var category: LaunchCategory = .feature
    var createdAt: Date = Date()
}

enum LaunchStatus: String, Codable, CaseIterable {
    case planning = "Planning"
    case ready = "Ready"
    case launched = "Launched"
    case delayed = "Delayed"
}

enum LaunchCategory: String, Codable, CaseIterable {
    case feature = "Feature"
    case product = "Product"
    case marketing = "Marketing"
    case partnership = "Partnership"
    case event = "Event"
}

// MARK: - Asset Model
struct Asset: Identifiable, Codable {
    var id: UUID = UUID()
    var name: String = ""
    var type: AssetType = .other
    var url: String = ""
    var description: String = ""
    var tags: [String] = []
    var createdAt: Date = Date()
}

enum AssetType: String, Codable, CaseIterable {
    case image = "Image"
    case video = "Video"
    case document = "Document"
    case code = "Code"
    case other = "Other"
}

// MARK: - Team Model
struct TeamMember: Identifiable, Codable {
    var id: UUID = UUID()
    var name: String = ""
    var role: String = ""
    var email: String = ""
    var avatar: String = ""
    var status: TeamStatus = .active
    var skills: [String] = []
}

enum TeamStatus: String, Codable, CaseIterable {
    case active = "Active"
    case away = "Away"
    case offline = "Offline"
}

// MARK: - App Settings Model
struct AppSettings: Codable {
    var showShortcuts: Bool = true
    var autoSave: Bool = true
    var autoSaveInterval: Int = 30
    var defaultView: String = "Focus"
    var compactMode: Bool = false
}

// MARK: - Todo Model
struct Todo: Identifiable, Codable {
    var id: UUID = UUID()
    var title: String = ""
    var isCompleted: Bool = false
    var priority: Int = 3 // 1=high, 2=medium, 3=low
    var dueDate: Date?
    var createdAt: Date = Date()
    var tags: [String] = []
}

// MARK: - Calendar Event Model
struct CalendarEvent: Identifiable, Codable {
    var id: UUID = UUID()
    var title: String = ""
    var startDate: Date = Date()
    var endDate: Date = Date()
    var isAllDay: Bool = true
    var location: String = ""
    var notes: String = ""
    var color: String = "#007AFF"
    var recurrence: String = "" // daily, weekly, monthly, yearly
}

// MARK: - Note Model
struct Note: Identifiable, Codable {
    var id: UUID = UUID()
    var title: String = ""
    var content: String = ""
    var tags: [String] = []
    var createdAt: Date = Date()
    var updatedAt: Date = Date()
}

// MARK: - History Entry Model
struct HistoryEntry: Identifiable, Codable {
    var id: UUID = UUID()
    var action: String = ""
    var details: String = ""
    var timestamp: Date = Date()
    var category: String = "" // project, domain, patent, idea, launch
}

// MARK: - Color Extension
extension Color {
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }
        
        self.init(
            red: Double((rgb & 0xFF0000) >> 16) / 255.0,
            green: Double((rgb & 0x00FF00) >> 8) / 255.0,
            blue: Double(rgb & 0x0000FF) / 255.0
        )
    }
}

#Preview {
    ContentView(store: AppStore())
}
