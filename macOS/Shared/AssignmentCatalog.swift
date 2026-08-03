import Foundation

public enum AssignmentCatalog {
    public static let courses: [CourseInfo] = [
        CourseInfo(id: .baos310, code: "BAOS 310", name: "Reshoring Product Manufacturing", colorHex: "14745A"),
        CourseInfo(id: .baef210, code: "BAEF 210", name: "Cost Accounting Fundamentals", colorHex: "B73870"),
        CourseInfo(id: .baos302, code: "BAOS 302", name: "Building Competitive Advantage Using IS", colorHex: "7057C9"),
        CourseInfo(id: .baba, code: "BABA 302", name: "R Fundamentals for Business Analytics", colorHex: "1D70A2"),
        CourseInfo(id: .geo, code: "GEO 125", name: "Physical Geography", colorHex: "3C7D33"),
        CourseInfo(id: .ant, code: "ANT 107", name: "Introduction to Biological Anthropology", colorHex: "B46A16"),
    ]

    public static let assignments: [StudyAssignment] = [
        a("baos310-part1", .baos310, "Project Part I · Strategic reasons for doing business globally", "2026-07-07", "2026-07-18", blocks: 2, note: "10-page executive analysis · TCO output, recommendation, formatting and submission"),
        a("baos310-part2", .baos310, "Project Part II · Benefits and challenges in global business", "2026-07-18", "2026-07-22", blocks: 4, note: "Country risk, sourcing, sustainability, revision and submission"),
        a("baos310-part3", .baos310, "Project Part III · Current trends in global business", "2026-07-22", "2026-07-25", blocks: 4, note: "ERP flows, economic integration, business model and final recommendation"),
        a("geo-m1", .geo, "Module 1 · Four spheres tools and introductory labs", "2026-07-15", "2026-07-24", blocks: 2),
        a("ant-m1-quizzes", .ant, "Module 1 · Quizzes", "2026-07-11", "2026-07-25"),
        a("ant-m1-presentation", .ant, "Module 1 · Presentation", "2026-07-23", "2026-07-27", blocks: 2),
        a("ant-m1-lab", .ant, "Module 1 · Lab", "2026-07-25", "2026-07-29"),
        a("geo-m2", .geo, "Module 2 · Earth layers, plate boundaries and lithosphere activity", "2026-07-28", "2026-08-01", blocks: 3),
        a("baba-w4", .baba, "Week 4 · Linear and multiple regression", "2026-07-31", "2026-08-03", blocks: 2),
        a("baba-w5", .baba, "Week 5 · Multiple regression assessments in Excel and R", "2026-08-04", "2026-08-04"),
        a("ant-m2-quizzes", .ant, "Module 2 · Quizzes", "2026-07-31", "2026-08-03"),
        a("ant-m2-presentation", .ant, "Module 2 · Presentation", "2026-08-03", "2026-08-04", blocks: 2),
        a("baba-w6", .baba, "Week 6 · T-test examples in Excel and R", "2026-08-05", "2026-08-05"),
        a("geo-m3", .geo, "Module 3 · Atmosphere, climate and applied activity", "2026-08-05", "2026-08-07", blocks: 3),
        a("baba-w7", .baba, "Week 7 · Paired t-test examples in Excel and R", "2026-08-06", "2026-08-06"),
        a("ant-m2-lab", .ant, "Module 2 · Lab", "2026-08-04", "2026-08-07"),
        a("baba-w8", .baba, "Week 8 · T-test and paired t-test assessments", "2026-08-08", "2026-08-10", blocks: 2),
        a("ant-m3-quizzes", .ant, "Module 3 · Quizzes", "2026-08-10", "2026-08-10"),
        a("baba-w9", .baba, "Week 9 · ANOVA examples, parts 1 and 2", "2026-08-11", "2026-08-11"),
        a("geo-m4", .geo, "Module 4 · Ecosystems, populations and biosphere activity", "2026-08-11", "2026-08-15", blocks: 3),
        a("baba-w10", .baba, "Week 10 · ANOVA database examples, parts 3 and 4", "2026-08-12", "2026-08-12"),
        a("ant-m3-presentation", .ant, "Module 3 · Presentation", "2026-08-12", "2026-08-13", blocks: 2),
        a("baba-w11", .baba, "Week 11 · Healthcare ANOVA examples, parts 5 and 6", "2026-08-13", "2026-08-13"),
        a("baba-w12", .baba, "Week 12 · Finish incomplete work and course cleanup", "2026-08-14", "2026-08-15", blocks: 2),
        a("ant-m3-lab", .ant, "Module 3 · Lab", "2026-08-14", "2026-08-17"),
        a("geo-m5", .geo, "Module 5 · Hydrosphere labs and applied activity", "2026-08-17", "2026-08-20", blocks: 4),
        a("ant-m4-quizzes", .ant, "Module 4 · Quizzes", "2026-08-18", "2026-08-18"),
        a("ant-m4-presentation", .ant, "Module 4 · Presentation", "2026-08-19", "2026-08-21", blocks: 3),
        a("ant-m4-lab", .ant, "Module 4 · Lab", "2026-08-22", "2026-08-25", blocks: 2),
        a("geo-m6", .geo, "Module 6 · Geography Unveiled capstone", "2026-08-21", "2026-08-26", blocks: 3, note: "Board risk: scheduled after the Aug 21 first-submission line"),
        a("baef-basics", .baef210, "The Basics quiz", "2026-07-10", "2026-07-10"),
        a("baef-part1", .baef210, "Project Part 1 · Job order costing", "2026-07-10", "2026-07-13"),
        a("baef-part2", .baef210, "Project Part 2 · Process costing", "2026-07-14", "2026-07-14"),
        a("baef-part3", .baef210, "Project Part 3 · Absorption vs. variable costing", "2026-07-15", "2026-07-15"),
        a("baef-part4", .baef210, "Project Part 4 · Activity-based costing", "2026-07-16", "2026-07-16"),
        a("baef-close", .baef210, "Costing Methods quiz", "2026-07-17", "2026-07-17"),
        a("baos302-diagram", .baos302, "Activity diagram and cross-functional flowchart", "2026-07-07", "2026-07-15"),
        a("baos302-cases", .baos302, "Use cases", "2026-07-07", "2026-07-15"),
        a("baos302-security", .baos302, "Enterprise systems and security", "2026-07-07", "2026-07-15"),
        a("baos302-cloud", .baos302, "Cloud computing LinkedIn Learning certificate", "2026-07-07", "2026-07-15"),
        a("baba-w1", .baba, "Week 1 · Getting started, visualization and programming constructs", "2026-07-27", "2026-07-27"),
        a("baba-w2", .baba, "Week 2 · Loops, ggplot and R Markdown", "2026-07-28", "2026-07-29", blocks: 2),
        a("baba-w3", .baba, "Week 3 · R Markdown and linear regression examples", "2026-07-30", "2026-07-30", blocks: 2),
        a("ant-fci", .ant, "First-course interaction check-in", "2026-07-07", "2026-07-11"),
    ]

    public static let initialCompletedIDs: Set<String> = [
        "baef-basics", "baef-part1", "baef-part2", "baef-part3", "baef-part4", "baef-close",
        "baos302-diagram", "baos302-cases", "baos302-security", "baos302-cloud",
        "baba-w1", "baba-w2", "baba-w3", "ant-fci",
    ]

    public static func course(_ id: CourseID) -> CourseInfo {
        courses.first { $0.id == id }!
    }

    public static func defaultPlanFrom(now: Date = Date()) -> String {
        let today = StudyDate.iso(now)
        return (PlannerConfiguration.jul2026.start...PlannerConfiguration.jul2026.end).contains(today)
            ? today
            : PlannerConfiguration.jul2026.start
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
        StudyAssignment(id: id, course: course, title: title, earliest: earliest, due: due, blocks: blocks, note: note)
    }
}
