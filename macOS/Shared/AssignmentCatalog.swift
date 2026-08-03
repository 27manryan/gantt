import Foundation

public enum AssignmentCatalog {
    public static let courses: [CourseInfo] = [
        CourseInfo(id: .bama, code: "BAMA 300X", name: "Applied Business Statistics", colorHex: "14745A"),
        CourseInfo(id: .mus, code: "MUS 273X", name: "Jazz History", colorHex: "B46A16"),
        CourseInfo(id: .baef201, code: "BAEF 201X", name: "Financial Accounting", colorHex: "B73870"),
        CourseInfo(id: .baef302, code: "BAEF 302X", name: "Finance", colorHex: "7057C9"),
        CourseInfo(id: .pmgt, code: "PMGT 315X", name: "Project Management", colorHex: "7454A6"),
        CourseInfo(id: .bams, code: "BAMS 301X", name: "Marketing", colorHex: "1D70A2"),
        CourseInfo(id: .baba, code: "BABA 301X", name: "Data Visualization", colorHex: "3C7D33"),
        CourseInfo(id: .balm, code: "BALM 310X", name: "Organizational Behavior", colorHex: "A44C2C"),
    ]

    public static let assignments: [StudyAssignment] = [
        a("bama-normal", .bama, "Normal distribution, sampling & confidence intervals", "2026-04-13", "2026-04-24", note: "Pre-assessment, then assessment"),
        a("mus-m3", .mus, "Module 3 · Early Jazz assessment", "2026-04-13", "2026-04-24"),
        a("bama-quiz-1", .bama, "Quiz · Probability, distributions & confidence intervals", "2026-04-14", "2026-04-24", note: "75 minutes · 8 problems"),
        a("mus-m4", .mus, "Module 4 · Swing and Bebop assessment", "2026-04-14", "2026-04-24"),
        a("bama-hypothesis", .bama, "Hypothesis testing for population means", "2026-04-15", "2026-04-24", note: "Pre-assessment, then assessment"),
        a("mus-m6", .mus, "Module 6 · Cool Jazz and Free Jazz assessment", "2026-04-15", "2026-04-24"),
        a("bama-chi-pre", .bama, "Chi-square tests · pre-assessment", "2026-04-17", "2026-04-24", note: "Limited-availability day"),
        a("bama-chi", .bama, "Chi-square tests · assessment", "2026-04-20", "2026-04-24"),
        a("bama-quiz-2", .bama, "Quiz · Hypothesis testing and chi-square", "2026-04-20", "2026-04-24", note: "75 minutes · 6 problems"),
        a("bama-project-setup", .bama, "Stock markets project · stocks, workbook & data", "2026-04-20", "2026-05-01"),
        a("mus-m7", .mus, "Module 7 · Fusion and present assessment", "2026-04-20", "2026-05-08"),
        a("bama-project-analysis", .bama, "Stock markets project · calculations and tests", "2026-04-21", "2026-05-01"),
        a("mus-m8", .mus, "Module 8 · Compare and contrast discussion", "2026-04-21", "2026-05-08"),
        a("bama-project-report", .bama, "Stock markets project · write report", "2026-04-22", "2026-05-01"),
        a("baef201-ethics", .baef201, "Ethical considerations in accounting", "2026-04-22", "2026-05-08"),
        a("bama-project-submit", .bama, "Stock markets project · finalize and submit", "2026-04-23", "2026-05-01"),
        a("baef201-bank", .baef201, "Bank reconciliation and internal controls", "2026-04-23", "2026-05-08"),
        a("baef302-jj", .baef302, "J&J performance evaluation and financial calculators paper", "2026-04-24", "2026-05-08"),
        a("mus-video-pick", .mus, "Choose and save a jazz concert video", "2026-04-24", "2026-04-28", note: "YouTube or PBS · about 15 minutes"),
        a("baef201-project", .baef201, "Fraud triangle case study project", "2026-04-27", "2026-05-08"),
        a("baef302-personal", .baef302, "Personal finances and business valuation approaches", "2026-04-27", "2026-05-08"),
        a("baef302-valuation", .baef302, "Valuation of a firm project", "2026-04-28", "2026-05-08"),
        a("pmgt-assessments", .pmgt, "Read course content and complete assessments", "2026-04-28", "2026-05-08", blocks: 2),
        a("mus-concert-watch", .mus, "Watch jazz performance and take notes", "2026-04-29", "2026-05-08", blocks: 2, note: "Approximately 90 minutes total"),
        a("mus-concert-essay", .mus, "Concert essay · write and submit", "2026-04-29", "2026-05-08", note: "2 pages · double-spaced"),
        a("mus-paper-sources", .mus, "Research paper · outline and gather sources", "2026-04-30", "2026-06-19", note: "3+ written sources; no textbook or Wikipedia"),
        a("mus-paper-draft", .mus, "Research paper · draft", "2026-04-30", "2026-06-19", blocks: 2),
        a("mus-paper-submit", .mus, "Research paper · revise and submit", "2026-05-01", "2026-06-19", note: "5 pages · jazz history and Black ethnic struggle"),
        a("bama-confirm", .bama, "Confirm final grade or resubmit", "2026-05-04", "2026-05-08"),
        a("bama-advisor", .bama, "Contact advisor and request July SP enrollment", "2026-05-08", "2026-05-08", note: "BABA 300X, BABA 302X and BABA 304X"),
        a("bams-content", .bams, "Course content modules", "2026-05-04", "2026-05-15", blocks: 4),
        a("bams-plan-draft", .bams, "Marketing plan · draft", "2026-05-07", "2026-05-15"),
        a("bams-plan-submit", .bams, "Marketing plan · finalize and submit", "2026-05-08", "2026-05-15"),
        a("bams-presentation", .bams, "Record and submit presentation", "2026-05-11", "2026-05-15", blocks: 2),
        a("bams-confirm", .bams, "Confirm grade or resubmit", "2026-05-13", "2026-05-15"),
        a("baba-m1", .baba, "Module 1 · Install Tableau and preliminary graphs", "2026-05-11", "2026-06-05"),
        a("baba-m2", .baba, "Module 2 · Basic visualizations", "2026-05-11", "2026-06-05", blocks: 2),
        a("baba-m3", .baba, "Module 3 · Beyond basic visualizations", "2026-05-12", "2026-06-05", blocks: 2),
        a("baba-m4", .baba, "Module 4 · Calculations and parameters", "2026-05-13", "2026-06-05", blocks: 2),
        a("baba-m5", .baba, "Module 5 · Level of detail calculations", "2026-05-14", "2026-06-05", blocks: 2),
        a("baba-m6", .baba, "Module 6 · Table calculations", "2026-05-14", "2026-06-05", blocks: 2),
        a("baba-m7", .baba, "Module 7 · Data story with dashboards", "2026-05-15", "2026-06-05", blocks: 2),
        a("baba-m8", .baba, "Module 8 · Creating dashboards", "2026-05-18", "2026-06-05", blocks: 2),
        a("baba-m9", .baba, "Module 9 · Forecasting with Tableau", "2026-05-19", "2026-06-05", blocks: 2),
        a("baba-m10", .baba, "Module 10 · Dynamic dashboards", "2026-05-20", "2026-06-05", blocks: 2),
        a("baba-m11", .baba, "Module 11 · Creating maps", "2026-05-21", "2026-06-05", blocks: 2),
        a("baba-m12", .baba, "Module 12 · Joins, blends and messy data", "2026-05-26", "2026-06-05", blocks: 2),
        a("baba-final", .baba, "Final assessment · Messy data and visualization", "2026-05-27", "2026-06-05", blocks: 2),
        a("balm-individual-content", .balm, "Understanding the individual · course content", "2026-05-26", "2026-06-12", blocks: 2),
        a("balm-individual-assessment", .balm, "Apply theories of the individual · assessment", "2026-06-01", "2026-06-12", blocks: 2),
        a("balm-team-content", .balm, "Group and team dynamics · course content", "2026-06-02", "2026-06-12", blocks: 2),
        a("balm-team-assessment", .balm, "Diagnose and improve team dynamics · assessment", "2026-06-08", "2026-06-12", blocks: 2),
        a("balm-project-outline", .balm, "Project 3 into 1 · outline", "2026-06-15", "2026-06-23"),
        a("balm-project-draft", .balm, "Project 3 into 1 · draft", "2026-06-16", "2026-06-23"),
        a("balm-project-submit", .balm, "Project 3 into 1 · revise and submit", "2026-06-17", "2026-06-23"),
    ]

    public static func course(_ id: CourseID) -> CourseInfo {
        courses.first { $0.id == id }!
    }

    public static func defaultPlanFrom(now: Date = Date()) -> String {
        let today = StudyDate.iso(now)
        return (PlannerConfiguration.apr2026.start...PlannerConfiguration.apr2026.end).contains(today)
            ? today
            : PlannerConfiguration.apr2026.start
    }

    private static func a(
        _ id: String,
        _ course: CourseID,
        _ title: String,
        _ earliest: String,
        _ due: String,
        blocks: Int = 1,
        note: String? = nil
    ) -> StudyAssignment {
        StudyAssignment(
            id: id,
            course: course,
            title: title,
            earliest: earliest,
            due: due,
            blocks: blocks,
            note: note
        )
    }
}
