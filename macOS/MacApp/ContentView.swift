import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var store: BoardStore
    @State private var showingResetConfirmation = false

    var body: some View {
        VStack(spacing: 0) {
            header
            ScrollView {
                VStack(spacing: 18) {
                    controls
                    metrics
                    HStack(alignment: .top, spacing: 22) {
                        schedule
                            .frame(maxWidth: .infinity)
                        courses
                            .frame(width: 320)
                    }
                }
                .padding(24)
            }
            .background(Color.boardPaper)
        }
        .preferredColorScheme(.light)
        .confirmationDialog(
            "Reset all progress?",
            isPresented: $showingResetConfirmation,
            titleVisibility: .visible
        ) {
            Button("Reset progress", role: .destructive) { store.reset() }
        } message: {
            Text("Every completed assignment will be reopened and the planning date will return to April 13.")
        }
    }

    private var header: some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 8) {
                Label("UW–PARKSIDE FLEX · APR 2026", systemImage: "circle.fill")
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.greenSignal)
                Text("Adaptive study board")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .tracking(-1.2)
                Text("Finish the work in front of you. The rest of the plan moves with you.")
                    .font(.system(size: 14))
                    .foregroundStyle(.white.opacity(0.65))
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 5) {
                Text("APR 7  →  JUN 26")
                    .font(.system(size: 13, weight: .semibold, design: .monospaced))
                Text("8 courses · 16 credits")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.55))
            }
        }
        .foregroundStyle(.white)
        .padding(.horizontal, 28)
        .padding(.vertical, 24)
        .background(Color.boardInk)
    }

    private var controls: some View {
        HStack(spacing: 14) {
            VStack(alignment: .leading, spacing: 4) {
                Text("PLAN UNFINISHED WORK FROM")
                    .eyebrowStyle(color: .secondary)
                DatePicker("", selection: planFromBinding, in: dateRange, displayedComponents: .date)
                    .labelsHidden()
            }
            Divider().frame(height: 38)
            Label("The plan recalculates after every checkmark", systemImage: "arrow.triangle.2.circlepath")
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(.secondary)
            Spacer()
            Button("Reset progress", role: .destructive) { showingResetConfirmation = true }
                .buttonStyle(.bordered)
        }
        .padding(16)
        .background(.white, in: RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.boardLine))
    }

    private var metrics: some View {
        HStack(spacing: 12) {
            MetricCard(
                label: "COMPLETED",
                value: "\(store.completedCount) / \(AssignmentCatalog.assignments.count)",
                detail: "\(Int(store.completionFraction * 100))% of assignments",
                progress: store.completionFraction
            )
            MetricCard(label: "BLOCKS LEFT", value: "\(store.remainingBlocks)", detail: "Two on a normal weekday")
            MetricCard(
                label: "PROJECTED FINISH",
                value: store.plan.projectedFinish.map(DateText.short) ?? "Done",
                detail: "Based on unfinished work"
            )
            MetricCard(
                label: "PLAN HEALTH",
                value: planHasProblems ? "Needs attention" : "On track",
                detail: planHasProblems
                    ? "\(uniqueLateCount) late · \(store.plan.unscheduled.count) cannot fit"
                    : "Everything fits before deadline",
                danger: planHasProblems
            )
        }
    }

    private var schedule: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionTitle(kicker: "LIVE SCHEDULE", title: "Next up")
            if store.plan.days.isEmpty {
                ContentUnavailableView(
                    "Nothing left to schedule",
                    systemImage: "checkmark.circle.fill",
                    description: Text("Every assignment is checked off.")
                )
                .frame(maxWidth: .infinity, minHeight: 240)
                .background(Color.greenSoft, in: RoundedRectangle(cornerRadius: 16))
            } else {
                LazyVStack(spacing: 10) {
                    ForEach(store.plan.days) { day in
                        DayCard(day: day)
                    }
                }
            }
        }
    }

    private var courses: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionTitle(kicker: "MASTER CHECKLIST", title: "Courses")
            ForEach(AssignmentCatalog.courses) { course in
                CourseCard(course: course)
            }
        }
    }

    private func sectionTitle(kicker: String, title: String) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(kicker).eyebrowStyle(color: .boardGreen)
            Text(title).font(.system(size: 23, weight: .bold, design: .rounded))
        }
    }

    private var planHasProblems: Bool { !store.plan.late.isEmpty || !store.plan.unscheduled.isEmpty }
    private var uniqueLateCount: Int { Set(store.plan.late.map { $0.assignment.id }).count }

    private var planFromBinding: Binding<Date> {
        Binding(
            get: { DateText.localDate(store.progress.planFrom) },
            set: { store.setPlanFrom(DateText.isoFromLocal($0)) }
        )
    }

    private var dateRange: ClosedRange<Date> {
        DateText.localDate(PlannerConfiguration.apr2026.start)...DateText.localDate(PlannerConfiguration.apr2026.end)
    }
}

private struct MetricCard: View {
    let label: String
    let value: String
    let detail: String
    var progress: Double?
    var danger = false

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label).eyebrowStyle(color: .secondary)
            Text(value)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(danger ? Color.red : Color.boardInk)
                .lineLimit(1)
                .minimumScaleFactor(0.72)
            Text(detail)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(1)
            if let progress {
                ProgressView(value: progress)
                    .tint(.boardGreen)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(15)
        .background(danger ? Color.red.opacity(0.07) : .white, in: RoundedRectangle(cornerRadius: 13))
        .overlay(RoundedRectangle(cornerRadius: 13).stroke(danger ? Color.red.opacity(0.28) : Color.boardLine))
    }
}

private struct DayCard: View {
    @EnvironmentObject private var store: BoardStore
    let day: PlanDay

    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            VStack(alignment: .leading, spacing: 3) {
                Text(DateText.weekday(day.date).uppercased())
                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                Text(DateText.short(day.date))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(width: 82, alignment: .leading)
            .padding(14)
            Divider()
            VStack(spacing: 0) {
                ForEach(day.blocks) { block in
                    AssignmentRow(block: block)
                    if block.id != day.blocks.last?.id { Divider() }
                }
            }
        }
        .background(.white, in: RoundedRectangle(cornerRadius: 13))
        .clipShape(RoundedRectangle(cornerRadius: 13))
        .overlay(RoundedRectangle(cornerRadius: 13).stroke(Color.boardLine))
    }
}

private struct AssignmentRow: View {
    @EnvironmentObject private var store: BoardStore
    let block: PlannedBlock

    var body: some View {
        HStack(alignment: .top, spacing: 11) {
            Button {
                store.setComplete(block.assignment, complete: true)
            } label: {
                Image(systemName: "circle")
                    .font(.system(size: 18))
                    .foregroundStyle(Color(hex: course.colorHex))
            }
            .buttonStyle(.plain)
            .help("Mark complete")
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(course.code).eyebrowStyle(color: Color(hex: course.colorHex))
                    if block.blockCount > 1 {
                        Text("BLOCK \(block.block) OF \(block.blockCount)")
                            .eyebrowStyle(color: .secondary)
                    }
                }
                Text(block.assignment.title)
                    .font(.system(size: 14, weight: .semibold))
                if let note = block.assignment.note {
                    Text(note).font(.caption).foregroundStyle(.secondary)
                }
            }
            Spacer(minLength: 0)
        }
        .padding(13)
    }

    private var course: CourseInfo { AssignmentCatalog.course(block.assignment.course) }
}

private struct CourseCard: View {
    @EnvironmentObject private var store: BoardStore
    let course: CourseInfo

    var body: some View {
        DisclosureGroup {
            VStack(spacing: 0) {
                ForEach(assignments) { assignment in
                    Button {
                        store.setComplete(assignment, complete: !store.isComplete(assignment))
                    } label: {
                        HStack(alignment: .top, spacing: 9) {
                            Image(systemName: store.isComplete(assignment) ? "checkmark.square.fill" : "square")
                                .foregroundStyle(Color(hex: course.colorHex))
                            Text(assignment.title)
                                .font(.system(size: 12, weight: .medium))
                                .strikethrough(store.isComplete(assignment))
                                .foregroundStyle(store.isComplete(assignment) ? .secondary : .primary)
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                        .padding(.vertical, 6)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.top, 8)
        } label: {
            HStack(spacing: 10) {
                Capsule().fill(Color(hex: course.colorHex)).frame(width: 8, height: 34)
                VStack(alignment: .leading, spacing: 2) {
                    Text(course.code).font(.system(size: 13, weight: .bold))
                    Text("\(completedCount) of \(assignments.count) · \(course.name)")
                        .font(.caption2).foregroundStyle(.secondary)
                }
                Spacer()
                Text("\(percent)%").font(.caption.bold()).foregroundStyle(.secondary)
            }
        }
        .padding(13)
        .background(.white, in: RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.boardLine))
    }

    private var assignments: [StudyAssignment] {
        AssignmentCatalog.assignments.filter { $0.course == course.id }
    }

    private var completedCount: Int {
        assignments.filter(store.isComplete).count
    }

    private var percent: Int {
        Int((Double(completedCount) / Double(assignments.count)) * 100)
    }
}

private enum DateText {
    private static func formatter(_ format: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = format
        return formatter
    }

    static func short(_ iso: String) -> String { formatter("MMM d").string(from: StudyDate.parse(iso)) }
    static func weekday(_ iso: String) -> String { formatter("EEE").string(from: StudyDate.parse(iso)) }

    static func localDate(_ iso: String) -> Date {
        let components = StudyDate.calendar.dateComponents([.year, .month, .day], from: StudyDate.parse(iso))
        return Calendar.current.date(from: components)!
    }

    static func isoFromLocal(_ date: Date) -> String {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
        return String(format: "%04d-%02d-%02d", components.year!, components.month!, components.day!)
    }
}

private extension Text {
    func eyebrowStyle(color: Color) -> some View {
        self.font(.system(size: 10, weight: .bold, design: .rounded))
            .tracking(1.1)
            .foregroundStyle(color)
    }
}

extension Color {
    static let boardInk = Color(hex: "172019")
    static let boardPaper = Color(hex: "F4F1E9")
    static let boardLine = Color(hex: "D9DDD5")
    static let boardGreen = Color(hex: "1F6A49")
    static let greenSignal = Color(hex: "72D69C")
    static let greenSoft = Color(hex: "E4F1E9")

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
