import SwiftUI
import WidgetKit

struct StudyBoardEntry: TimelineEntry {
    let date: Date
    let progress: ProgressSnapshot
    let plan: StudyPlan
}

struct StudyBoardProvider: TimelineProvider {
    func placeholder(in context: Context) -> StudyBoardEntry {
        entry(
            progress: ProgressSnapshot(
                completedIDs: AssignmentCatalog.initialCompletedIDs,
                planFrom: PlannerConfiguration.jul2026.start
            )
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (StudyBoardEntry) -> Void) {
        completion(entry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<StudyBoardEntry>) -> Void) {
        let current = entry()
        let refresh = Calendar.current.date(byAdding: .minute, value: 15, to: Date())!
        completion(Timeline(entries: [current], policy: .after(refresh)))
    }

    private func entry(progress: ProgressSnapshot = ProgressRepository().load()) -> StudyBoardEntry {
        StudyBoardEntry(
            date: Date(),
            progress: progress,
            plan: StudyPlanner.makePlan(assignments: AssignmentCatalog.assignments, progress: progress)
        )
    }
}

struct AdaptiveStudyWidgetView: View {
    @Environment(\.widgetFamily) private var family
    let entry: StudyBoardEntry

    var body: some View {
        Group {
            if family == .systemSmall { smallWidget }
            else { mediumWidget }
        }
        .containerBackground(Color.widgetPaper, for: .widget)
        .widgetURL(URL(string: "adaptivestudy://board"))
    }

    private var smallWidget: some View {
        VStack(alignment: .leading, spacing: 9) {
            widgetHeader
            Spacer(minLength: 0)
            if let next = entry.plan.nextBlocks.first {
                Text(course(for: next).code)
                    .font(.system(size: 10, weight: .bold, design: .rounded))
                    .tracking(1)
                    .foregroundStyle(Color(hex: course(for: next).colorHex))
                Text(next.assignment.title)
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .lineLimit(3)
                HStack {
                    Text(dateLabel(next.scheduledDate))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Spacer()
                    completeButton(next)
                }
            } else {
                Label("All done", systemImage: "checkmark.circle.fill")
                    .font(.headline)
                    .foregroundStyle(Color.widgetGreen)
            }
        }
        .padding(2)
    }

    private var mediumWidget: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .firstTextBaseline) {
                widgetHeader
                Spacer()
                Text("\(entry.progress.completedIDs.count)/\(AssignmentCatalog.assignments.count)")
                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                    .foregroundStyle(.secondary)
            }
            ProgressView(value: completionFraction)
                .tint(.widgetGreen)

            if entry.plan.nextBlocks.isEmpty {
                Spacer()
                Label("Everything is complete", systemImage: "checkmark.circle.fill")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.widgetGreen)
                Spacer()
            } else {
                VStack(spacing: 7) {
                    ForEach(entry.plan.nextBlocks) { block in
                        HStack(spacing: 9) {
                            completeButton(block)
                            VStack(alignment: .leading, spacing: 2) {
                                HStack(spacing: 6) {
                                    Text(course(for: block).code)
                                        .font(.system(size: 9, weight: .bold, design: .rounded))
                                        .tracking(0.8)
                                        .foregroundStyle(Color(hex: course(for: block).colorHex))
                                    Text(dateLabel(block.scheduledDate))
                                        .font(.caption2)
                                        .foregroundStyle(.secondary)
                                }
                                Text(block.assignment.title)
                                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                                    .lineLimit(1)
                            }
                            Spacer(minLength: 0)
                        }
                        .padding(.vertical, 2)
                    }
                }
            }

            HStack {
                Label(planHealth, systemImage: planHasProblems ? "exclamationmark.triangle.fill" : "checkmark.seal.fill")
                    .font(.caption2.bold())
                    .foregroundStyle(planHasProblems ? Color.orange : Color.widgetGreen)
                Spacer()
                if let finish = entry.plan.projectedFinish {
                    Text("Finish \(shortDate(finish))")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(2)
    }

    private var widgetHeader: some View {
        Label("STUDY BOARD", systemImage: "circle.fill")
            .font(.system(size: 10, weight: .bold, design: .rounded))
            .tracking(1)
            .foregroundStyle(Color.widgetInk)
    }

    private func completeButton(_ block: PlannedBlock) -> some View {
        Button(intent: CompleteAssignmentIntent(assignmentID: block.assignment.id)) {
            Image(systemName: "circle")
                .font(.system(size: 18))
                .foregroundStyle(Color(hex: course(for: block).colorHex))
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Complete \(block.assignment.title)")
    }

    private var completionFraction: Double {
        Double(entry.progress.completedIDs.count) / Double(AssignmentCatalog.assignments.count)
    }

    private var planHasProblems: Bool { !entry.plan.late.isEmpty || !entry.plan.unscheduled.isEmpty }
    private var planHealth: String { planHasProblems ? "Needs attention" : "On track" }
    private func course(for block: PlannedBlock) -> CourseInfo { AssignmentCatalog.course(block.assignment.course) }

    private func dateLabel(_ iso: String) -> String {
        "\(weekday(iso)) · \(shortDate(iso))"
    }

    private func weekday(_ iso: String) -> String { format(iso, "EEE") }
    private func shortDate(_ iso: String) -> String { format(iso, "MMM d") }

    private func format(_ iso: String, _ pattern: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = pattern
        return formatter.string(from: StudyDate.parse(iso))
    }
}

struct AdaptiveStudyWidget: Widget {
    let kind = "AdaptiveStudyWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: StudyBoardProvider()) { entry in
            AdaptiveStudyWidgetView(entry: entry)
        }
        .configurationDisplayName("Adaptive Study Board")
        .description("Your next assignments, progress, and live plan health.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

private extension Color {
    static let widgetPaper = Color(hex: "F4F1E9")
    static let widgetInk = Color(hex: "172019")
    static let widgetGreen = Color(hex: "1F6A49")

    init(hex: String) {
        let value = UInt64(hex, radix: 16) ?? 0
        self.init(
            .sRGB,
            red: Double((value >> 16) & 0xff) / 255,
            green: Double((value >> 8) & 0xff) / 255,
            blue: Double(value & 0xff) / 255,
            opacity: 1
        )
    }
}
