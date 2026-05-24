import SwiftUI

struct ParentProfileView: View {
    @EnvironmentObject var dashboardVM: DashboardViewModel
    @EnvironmentObject var auth: AuthViewModel

    @State private var showResetAlert = false
    @State private var showResetToast = false

    @State private var showAddChildSheet = false
    @State private var newChildName = ""
    @State private var newChildAge = ""
    @State private var newChildLevel = ""

    var body: some View {
        ZStack {
            Theme.backgroundGradient
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    headerSection
                    parentCard
                    childCard
                    notificationsSection
                    actionsSection
                    logoutButton
                }
                .padding(.horizontal, Theme.screenPadding)
                .padding(.top, 10)
                .padding(.bottom, 120)
            }

            if showResetToast {
                resetToast
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            dashboardVM.markNotificationsAsRead()
        }
        .alert("Reset demo data?", isPresented: $showResetAlert) {
            Button("Cancel", role: .cancel) { }

            Button("Reset", role: .destructive) {
                dashboardVM.resetDemoData()

                withAnimation {
                    showResetToast = true
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        showResetToast = false
                    }
                }
            }
        } message: {
            Text("This will restore original payments, events, notifications, and demo data.")
        }
        .sheet(isPresented: $showAddChildSheet) {
            addChildSheet
        }
    }
}

// MARK: - Header
private extension ParentProfileView {
    var headerSection: some View {
        GlowiScreenHeader(
            title: "Account",
            subtitle: "Parent profile and linked gymnast"
        )
    }
}

// MARK: - Notifications
private extension ParentProfileView {
    var notificationsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionTitle("Notifications")

            if dashboardVM.notifications.isEmpty {
                GlowiEmptyState(
                    icon: "bell",
                    title: "No notifications",
                    message: "Payment and schedule updates will appear here."
                )
            } else {
                VStack(spacing: 10) {
                    ForEach(dashboardVM.notifications.prefix(3)) { notification in
                        notificationRow(notification)
                    }
                }
            }
        }
    }

    func notificationRow(_ notification: GlowiNotification) -> some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(notificationColor(notification.type).opacity(0.16))
                    .frame(width: 46, height: 46)

                Image(systemName: notificationIcon(notification.type))
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(notificationColor(notification.type))
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(notification.title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(Theme.textPrimary)

                Text(notification.message)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(Theme.textSecondary)
                    .lineLimit(2)

                Text(notification.date)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(Theme.textMuted)
            }

            Spacer()
        }
        .padding(14)
        .background(Theme.elevatedSurface)
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.white.opacity(0.7), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    func notificationColor(_ type: String) -> Color {
        switch type {
        case "payment": return Theme.yellowDark
        case "event": return Theme.pinkDark
        case "session": return Theme.blueDark
        case "account": return Theme.greenDark
        default: return Theme.textSecondary
        }
    }

    func notificationIcon(_ type: String) -> String {
        switch type {
        case "payment": return "creditcard.fill"
        case "event": return "calendar.badge.plus"
        case "session": return "figure.gymnastics"
        case "account": return "person.crop.circle.badge.plus"
        default: return "bell.fill"
        }
    }
}

// MARK: - Parent
private extension ParentProfileView {
    var parentCard: some View {
        ProfileCard {
            HStack(spacing: 14) {
                profileIcon(systemName: "person.fill", accent: Theme.pinkDark)

                VStack(alignment: .leading, spacing: 5) {
                    Text(parentDisplayName)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Theme.textPrimary)

                    Text(parentEmail)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(Theme.textSecondary)

                    statusBadge("Active account", accent: Theme.greenDark, bg: Theme.green.opacity(0.22))
                }

                Spacer()
            }
        }
    }
}

// MARK: - Children
private extension ParentProfileView {
    var childCard: some View {
        ProfileCard {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    sectionTitle("Linked Children")

                    Spacer()

                    Text("\(dashboardVM.children.count)")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 5)
                        .background(Theme.primaryButtonGradient)
                        .clipShape(Capsule())
                }

                if dashboardVM.children.isEmpty {
                    GlowiEmptyState(
                        icon: "person.crop.circle.badge.plus",
                        title: "No children linked",
                        message: "Add a child profile to personalize the app."
                    )
                } else {
                    VStack(spacing: 10) {
                        ForEach(dashboardVM.children) { child in
                            childRow(child)
                        }
                    }
                }

                Button {
                    showAddChildSheet = true
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "plus.circle.fill")
                        Text("Add Child")
                    }
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Theme.pinkDark)
                    .frame(maxWidth: .infinity)
                    .padding(12)
                    .background(Theme.pink.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
                .buttonStyle(.plain)
            }
        }
    }

    func childRow(_ child: Child) -> some View {
        let isSelected = child.id == dashboardVM.selectedChildId

        return Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.85)) {
                dashboardVM.selectChild(child.id)
            }
        } label: {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(isSelected ? Theme.pink.opacity(0.18) : Theme.pink.opacity(0.1))
                        .frame(width: 44, height: 44)

                    Image(systemName: "figure.gymnastics")
                        .font(.system(size: 19, weight: .semibold))
                        .foregroundColor(Theme.pinkDark)
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text(child.name)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(Theme.textPrimary)

                    Text("\(child.age) y.o. • \(child.level)")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Theme.textSecondary)

                    if !child.nextTraining.isEmpty {
                        Text("Next: \(child.nextTraining)")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(Theme.textMuted)
                            .lineLimit(1)
                    }
                }

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(Theme.greenDark)
                }
            }
            .padding(12)
            .background(isSelected ? Theme.green.opacity(0.14) : Theme.elevatedSurface)
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(isSelected ? Theme.greenDark.opacity(0.32) : Theme.stroke, lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Add Child Sheet
private extension ParentProfileView {
    var addChildSheet: some View {
        NavigationStack {
            ZStack {
                Theme.backgroundGradient
                    .ignoresSafeArea()

                VStack(spacing: 18) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Child Details")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Theme.textPrimary)

                        textField("Name", text: $newChildName)
                        textField("Age", text: $newChildAge, keyboard: .numberPad)
                        
                    }
                    .padding(18)
                    .background(Theme.elevatedSurface)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .stroke(Color.white.opacity(0.7), lineWidth: 1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))

                    Button {
                        guard let age = Int(newChildAge.trimmingCharacters(in: .whitespaces)),
                              !newChildName.trimmingCharacters(in: .whitespaces).isEmpty,
                              !newChildLevel.trimmingCharacters(in: .whitespaces).isEmpty else {
                            return
                        }

                        dashboardVM.addChild(
                            name: newChildName.trimmingCharacters(in: .whitespaces),
                            age: age,
                            level: "Pending"
                        )
                        

                        newChildName = ""
                        newChildAge = ""
                        newChildLevel = ""
                        showAddChildSheet = false
                    } label: {
                        Text("Add Child")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 54)
                            .background(Theme.primaryButtonGradient)
                            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    }
                    .buttonStyle(.plain)

                    Spacer()
                }
                .padding(24)
            }
            .navigationTitle("New Child")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        showAddChildSheet = false
                    }
                }
            }
        }
        .presentationDetents([.medium, .large])
    }

    func textField(
        _ placeholder: String,
        text: Binding<String>,
        keyboard: UIKeyboardType = .default
    ) -> some View {
        TextField(placeholder, text: text)
            .keyboardType(keyboard)
            .font(.system(size: 15, weight: .medium))
            .foregroundColor(Theme.textPrimary)
            .padding(14)
            .background(Color.white.opacity(0.72))
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(Color.white.opacity(0.7), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

// MARK: - Actions
private extension ParentProfileView {
    var actionsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionTitle("Settings")

            VStack(spacing: 10) {
                actionRow(title: "Payments", assetName: "icon_payments", accent: Theme.yellowDark)
                actionRow(title: "Schedule", assetName: "icon_schedule", accent: Theme.blueDark)
                actionRow(title: "Events", assetName: "icon_events", accent: Theme.pinkDark)
                actionRow(title: "Account Settings", assetName: "icon_account", accent: Theme.lavender)
                resetDemoButton
            }
        }
    }

    func actionRow(title: String, assetName: String, accent: Color) -> some View {
        Button { } label: {
            HStack(spacing: 12) {
                iconBox(assetName: assetName, accent: accent)

                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(Theme.textPrimary)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(Theme.textMuted)
            }
            .padding(14)
            .background(Theme.elevatedSurface)
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Color.white.opacity(0.7), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .buttonStyle(.plain)
    }

    var resetDemoButton: some View {
        Button {
            showResetAlert = true
        } label: {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(Theme.error.opacity(0.16))
                        .frame(width: 42, height: 42)

                    Image(systemName: "arrow.counterclockwise")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Theme.error)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text("Reset Demo Data")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(Theme.textPrimary)

                    Text("Restore original app state")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Theme.textSecondary)
                }

                Spacer()
            }
            .padding(14)
            .background(Theme.elevatedSurface)
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Color.white.opacity(0.7), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Logout
private extension ParentProfileView {
    var logoutButton: some View {
        Button {
            auth.logout()
        } label: {
            Text("Logout")
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(Theme.pinkDark)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(Theme.pink.opacity(0.16))
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(Theme.pink.opacity(0.28), lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        }
        .buttonStyle(.plain)
        .padding(.top, 4)
    }
}

// MARK: - Toast
private extension ParentProfileView {
    var resetToast: some View {
        VStack {
            Spacer()

            HStack(spacing: 10) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(Theme.greenDark)

                Text("Demo data restored")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(Theme.textPrimary)

                Spacer()
            }
            .padding(12)
            .background(Theme.card)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .padding(.horizontal, 24)
            .padding(.bottom, 110)
            .transition(.move(edge: .bottom).combined(with: .opacity))
        }
    }
}

// MARK: - Reusable
private extension ParentProfileView {
    func sectionTitle(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 18, weight: .bold))
            .foregroundColor(Theme.textPrimary)
    }

    func profileIcon(systemName: String, accent: Color) -> some View {
        ZStack {
            Circle()
                .fill(accent.opacity(0.16))
                .frame(width: 58, height: 58)

            Image(systemName: systemName)
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(accent)
        }
    }

    func iconBox(assetName: String, accent: Color) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(accent.opacity(0.15))
                .frame(width: 42, height: 42)

            Image(assetName)
                .resizable()
                .renderingMode(.original)
                .scaledToFit()
                .frame(width: 22, height: 22)
        }
    }

    func statusBadge(_ text: String, accent: Color, bg: Color) -> some View {
        Text(text)
            .font(.system(size: 12, weight: .semibold))
            .foregroundColor(accent)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(bg)
            .clipShape(Capsule())
    }
}

private struct ProfileCard<Content: View>: View {
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            content
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.elevatedSurface)
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color.white.opacity(0.7), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

// MARK: - Helpers
private extension ParentProfileView {
    var parentDisplayName: String {
        auth.email.isEmpty ? "Parent Account" : auth.email.components(separatedBy: "@").first?.capitalized ?? "Parent"
    }

    var parentEmail: String {
        auth.email.isEmpty ? "parent@glowi.app" : auth.email
    }
}

#Preview {
    NavigationStack {
        ParentProfileView()
            .environmentObject(DashboardViewModel())
            .environmentObject(AuthViewModel())
    }
}
