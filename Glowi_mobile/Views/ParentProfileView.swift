import SwiftUI

struct ParentProfileView: View {
    @EnvironmentObject var dashboardVM: DashboardViewModel
    @EnvironmentObject var auth: AuthViewModel

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
        }
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            dashboardVM.markNotificationsAsRead()
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
                .stroke(Theme.stroke, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    func notificationColor(_ type: String) -> Color {
        switch type {
        case "payment":
            return Theme.yellowDark
        case "event":
            return Theme.pinkDark
        case "session":
            return Theme.blueDark
        default:
            return Theme.textSecondary
        }
    }

    func notificationIcon(_ type: String) -> String {
        switch type {
        case "payment":
            return "creditcard.fill"
        case "event":
            return "calendar.badge.plus"
        case "session":
            return "figure.gymnastics"
        default:
            return "bell.fill"
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

// MARK: - Child
private extension ParentProfileView {
    var childCard: some View {
        ProfileCard {
            VStack(alignment: .leading, spacing: 14) {
                sectionTitle("Linked Child")

                HStack(spacing: 14) {
                    childAvatar

                    VStack(alignment: .leading, spacing: 5) {
                        Text(currentChildName)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Theme.textPrimary)

                        Text("\(currentChildAge) y.o. • \(currentChildLevel)")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(Theme.textSecondary)

                        Text(nextTrainingText)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(Theme.textSecondary)
                            .lineLimit(2)
                    }

                    Spacer()
                }

                PremiumPrimaryButton(title: "Open Child Profile", icon: "arrow.right") {
                }
            }
        }
    }

    var childAvatar: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.white.opacity(0.72))
                .frame(width: 82, height: 82)

            if let image = dashboardVM.childPhoto {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 82, height: 82)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            } else {
                Image(systemName: "figure.gymnastics")
                    .font(.system(size: 30, weight: .medium))
                    .foregroundColor(Theme.pinkDark)
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Theme.stroke, lineWidth: 1)
        )
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
                    .stroke(Theme.stroke, lineWidth: 1)
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

// MARK: - Reusable Pieces
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
                .stroke(Theme.stroke, lineWidth: 1)
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

    var currentChildName: String {
        dashboardVM.child.name.isEmpty ? "Kiriia" : dashboardVM.child.name
    }

    var currentChildAge: Int {
        dashboardVM.child.age == 0 ? 11 : dashboardVM.child.age
    }

    var currentChildLevel: String {
        dashboardVM.child.level.isEmpty ? "Novice" : dashboardVM.child.level
    }

    var nextTrainingText: String {
        if !dashboardVM.child.nextTraining.isEmpty {
            return "Next: \(dashboardVM.child.nextTraining)"
        }

        if let first = dashboardVM.sessions.first {
            return "Next: \(first.date) • \(first.time)"
        }

        return "Next training not scheduled"
    }
}

#Preview {
    NavigationStack {
        ParentProfileView()
            .environmentObject(DashboardViewModel())
            .environmentObject(AuthViewModel())
    }
}
