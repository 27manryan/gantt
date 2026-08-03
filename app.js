import { compareDates, parseDate, scheduleAssignments } from "./scheduler.mjs";

const TERM = {
  start: "2026-07-07",
  target: "2026-08-27",
  end: "2026-09-25",
  excludedDates: [],
  workingWeekdays: [1, 2, 3, 4, 5, 6],
  capacityByDate: {
    "2026-07-11": 1,
    "2026-07-18": 1,
    "2026-07-25": 1,
    "2026-08-01": 1,
    "2026-08-08": 1,
    "2026-08-15": 1,
    "2026-08-22": 1,
    "2026-08-29": 1,
    "2026-09-05": 1,
    "2026-09-12": 1,
    "2026-09-19": 1,
  },
};

const COURSES = {
  baos310: { code: "BAOS 310", name: "Reshoring Product Manufacturing", color: "#14745a" },
  baef210: { code: "BAEF 210", name: "Cost Accounting Fundamentals", color: "#b73870" },
  baos302: { code: "BAOS 302", name: "Building Competitive Advantage Using IS", color: "#7057c9" },
  baba: { code: "BABA 302", name: "R Fundamentals for Business Analytics", color: "#1d70a2" },
  geo: { code: "GEO 125", name: "Physical Geography", color: "#3c7d33" },
  ant: { code: "ANT 107", name: "Introduction to Biological Anthropology", color: "#b46a16" },
};

const task = (id, course, title, earliest, due, extra = {}) => ({ id, course, title, earliest, due, blocks: 1, ...extra });

const ASSIGNMENTS = [
  task("baos310-part1", "baos310", "Project Part I · Strategic reasons for doing business globally", "2026-07-07", "2026-07-18", { blocks: 2, note: "10-page executive analysis · TCO output, recommendation, formatting and submission" }),
  task("baos310-part2", "baos310", "Project Part II · Benefits and challenges in global business", "2026-07-18", "2026-07-22", { blocks: 4, note: "Country risk, sourcing, sustainability, revision and submission" }),
  task("baos310-part3", "baos310", "Project Part III · Current trends in global business", "2026-07-22", "2026-07-25", { blocks: 4, note: "ERP flows, economic integration, business model and final recommendation" }),
  task("geo-m1", "geo", "Module 1 · Four spheres tools and introductory labs", "2026-07-15", "2026-07-24", { blocks: 2 }),
  task("ant-m1-quizzes", "ant", "Module 1 · Quizzes", "2026-07-11", "2026-07-25"),
  task("ant-m1-presentation", "ant", "Module 1 · Presentation", "2026-07-23", "2026-07-27", { blocks: 2 }),
  task("ant-m1-lab", "ant", "Module 1 · Lab", "2026-07-25", "2026-07-29"),
  task("geo-m2", "geo", "Module 2 · Earth layers, plate boundaries and lithosphere activity", "2026-07-28", "2026-08-01", { blocks: 3 }),
  task("baba-w4", "baba", "Week 4 · Linear and multiple regression", "2026-07-31", "2026-08-03", { blocks: 2 }),
  task("baba-w5", "baba", "Week 5 · Multiple regression assessments in Excel and R", "2026-08-04", "2026-08-04"),
  task("ant-m2-quizzes", "ant", "Module 2 · Quizzes", "2026-07-31", "2026-08-03"),
  task("ant-m2-presentation", "ant", "Module 2 · Presentation", "2026-08-03", "2026-08-04", { blocks: 2 }),
  task("baba-w6", "baba", "Week 6 · T-test examples in Excel and R", "2026-08-05", "2026-08-05"),
  task("geo-m3", "geo", "Module 3 · Atmosphere, climate and applied activity", "2026-08-05", "2026-08-07", { blocks: 3 }),
  task("baba-w7", "baba", "Week 7 · Paired t-test examples in Excel and R", "2026-08-06", "2026-08-06"),
  task("ant-m2-lab", "ant", "Module 2 · Lab", "2026-08-04", "2026-08-07"),
  task("baba-w8", "baba", "Week 8 · T-test and paired t-test assessments", "2026-08-08", "2026-08-10", { blocks: 2 }),
  task("ant-m3-quizzes", "ant", "Module 3 · Quizzes", "2026-08-10", "2026-08-10"),
  task("baba-w9", "baba", "Week 9 · ANOVA examples, parts 1 and 2", "2026-08-11", "2026-08-11"),
  task("geo-m4", "geo", "Module 4 · Ecosystems, populations and biosphere activity", "2026-08-11", "2026-08-15", { blocks: 3 }),
  task("baba-w10", "baba", "Week 10 · ANOVA database examples, parts 3 and 4", "2026-08-12", "2026-08-12"),
  task("ant-m3-presentation", "ant", "Module 3 · Presentation", "2026-08-12", "2026-08-13", { blocks: 2 }),
  task("baba-w11", "baba", "Week 11 · Healthcare ANOVA examples, parts 5 and 6", "2026-08-13", "2026-08-13"),
  task("baba-w12", "baba", "Week 12 · Finish incomplete work and course cleanup", "2026-08-14", "2026-08-15", { blocks: 2 }),
  task("ant-m3-lab", "ant", "Module 3 · Lab", "2026-08-14", "2026-08-17"),
  task("geo-m5", "geo", "Module 5 · Hydrosphere labs and applied activity", "2026-08-17", "2026-08-20", { blocks: 4 }),
  task("ant-m4-quizzes", "ant", "Module 4 · Quizzes", "2026-08-18", "2026-08-18"),
  task("ant-m4-presentation", "ant", "Module 4 · Presentation", "2026-08-19", "2026-08-21", { blocks: 3 }),
  task("ant-m4-lab", "ant", "Module 4 · Lab", "2026-08-22", "2026-08-25", { blocks: 2 }),
  task("geo-m6", "geo", "Module 6 · Geography Unveiled capstone", "2026-08-21", "2026-08-26", { blocks: 3, note: "Board risk: scheduled after the Aug 21 first-submission line" }),
  task("baef-basics", "baef210", "The Basics quiz", "2026-07-10", "2026-07-10"),
  task("baef-part1", "baef210", "Project Part 1 · Job order costing", "2026-07-10", "2026-07-13"),
  task("baef-part2", "baef210", "Project Part 2 · Process costing", "2026-07-14", "2026-07-14"),
  task("baef-part3", "baef210", "Project Part 3 · Absorption vs. variable costing", "2026-07-15", "2026-07-15"),
  task("baef-part4", "baef210", "Project Part 4 · Activity-based costing", "2026-07-16", "2026-07-16"),
  task("baef-close", "baef210", "Costing Methods quiz", "2026-07-17", "2026-07-17"),
  task("baos302-diagram", "baos302", "Activity diagram and cross-functional flowchart", "2026-07-07", "2026-07-15"),
  task("baos302-cases", "baos302", "Use cases", "2026-07-07", "2026-07-15"),
  task("baos302-security", "baos302", "Enterprise systems and security", "2026-07-07", "2026-07-15"),
  task("baos302-cloud", "baos302", "Cloud computing LinkedIn Learning certificate", "2026-07-07", "2026-07-15"),
  task("baba-w1", "baba", "Week 1 · Getting started, visualization and programming constructs", "2026-07-27", "2026-07-27"),
  task("baba-w2", "baba", "Week 2 · Loops, ggplot and R Markdown", "2026-07-28", "2026-07-29", { blocks: 2 }),
  task("baba-w3", "baba", "Week 3 · R Markdown and linear regression examples", "2026-07-30", "2026-07-30", { blocks: 2 }),
  task("ant-fci", "ant", "First-course interaction check-in", "2026-07-07", "2026-07-11"),
];

const INITIAL_COMPLETED_IDS = new Set([
  "baef-basics", "baef-part1", "baef-part2", "baef-part3", "baef-part4", "baef-close",
  "baos302-diagram", "baos302-cases", "baos302-security", "baos302-cloud",
  "baba-w1", "baba-w2", "baba-w3", "ant-fci",
]);

const STORAGE_KEY = "jul-sep-adaptive-board-v3";
const dateFormat = new Intl.DateTimeFormat("en-US", { month: "short", day: "numeric", timeZone: "UTC" });
const weekdayFormat = new Intl.DateTimeFormat("en-US", { weekday: "short", timeZone: "UTC" });
const longDateFormat = new Intl.DateTimeFormat("en-US", { month: "long", day: "numeric", timeZone: "UTC" });

const elements = {
  planFrom: document.querySelector("#plan-from"),
  recalculate: document.querySelector("#recalculate"),
  reset: document.querySelector("#reset-progress"),
  saveStatus: document.querySelector("#save-status"),
  complete: document.querySelector("#metric-complete"),
  blocks: document.querySelector("#metric-blocks"),
  finish: document.querySelector("#metric-finish"),
  finishDetail: document.querySelector("#metric-finish-detail"),
  health: document.querySelector("#metric-health"),
  healthDetail: document.querySelector("#metric-health-detail"),
  healthMetric: document.querySelector("#health-metric"),
  progressFill: document.querySelector("#progress-fill"),
  alert: document.querySelector("#plan-alert"),
  scheduleRange: document.querySelector("#schedule-range"),
  scheduleList: document.querySelector("#schedule-list"),
  courseList: document.querySelector("#course-list"),
  taskTemplate: document.querySelector("#task-template"),
};

function defaultPlanFrom() {
  const today = new Date();
  const localToday = `${today.getFullYear()}-${String(today.getMonth() + 1).padStart(2, "0")}-${String(today.getDate()).padStart(2, "0")}`;
  return compareDates(localToday, TERM.start) >= 0 && compareDates(localToday, TERM.end) <= 0 ? localToday : TERM.start;
}

function loadState() {
  try {
    const stored = JSON.parse(localStorage.getItem(STORAGE_KEY));
    const validIds = new Set(ASSIGNMENTS.map(({ id }) => id));
    const completed = Array.isArray(stored?.completed)
      ? stored.completed.filter((id) => validIds.has(id))
      : [...INITIAL_COMPLETED_IDS];
    const planFrom = stored?.planFrom && compareDates(stored.planFrom, TERM.start) >= 0 && compareDates(stored.planFrom, TERM.end) <= 0
      ? stored.planFrom
      : defaultPlanFrom();
    return { completed: new Set(completed), planFrom };
  } catch {
    return { completed: new Set(INITIAL_COMPLETED_IDS), planFrom: defaultPlanFrom() };
  }
}

let state = loadState();

function saveState(message = "Saved") {
  localStorage.setItem(STORAGE_KEY, JSON.stringify({ completed: [...state.completed], planFrom: state.planFrom }));
  elements.saveStatus.textContent = `${message} · ${new Date().toLocaleTimeString([], { hour: "numeric", minute: "2-digit" })}`;
}

function formatDate(dateString, formatter = dateFormat) {
  return formatter.format(parseDate(dateString));
}

function weekKey(dateString) {
  const date = parseDate(dateString);
  const weekday = date.getUTCDay();
  const mondayOffset = weekday === 0 ? -6 : 1 - weekday;
  date.setUTCDate(date.getUTCDate() + mondayOffset);
  return date.toISOString().slice(0, 10);
}

function makeTaskCard(assignment, { complete = false, showBlock = false } = {}) {
  const fragment = elements.taskTemplate.content.cloneNode(true);
  const label = fragment.querySelector(".task-card");
  const checkbox = fragment.querySelector(".task-check");
  const course = COURSES[assignment.course];

  label.style.setProperty("--course", course.color);
  label.dataset.complete = String(complete);
  checkbox.checked = complete;
  checkbox.value = assignment.id;
  checkbox.setAttribute("aria-label", `Mark ${course.code}: ${assignment.title} complete`);
  fragment.querySelector(".course-code").textContent = course.code;
  fragment.querySelector(".task-title").textContent = assignment.title;

  const blockLabel = fragment.querySelector(".block-count");
  if (showBlock && assignment.blockCount > 1) blockLabel.textContent = `Block ${assignment.block} of ${assignment.blockCount}`;
  else if ((assignment.blocks ?? 1) > 1) blockLabel.textContent = `${assignment.blocks} blocks`;

  const note = fragment.querySelector(".task-note");
  if (assignment.note) note.textContent = assignment.note;
  else note.remove();

  checkbox.addEventListener("change", () => {
    if (checkbox.checked) state.completed.add(assignment.id);
    else state.completed.delete(assignment.id);
    saveState(checkbox.checked ? "Completed — plan recalculated" : "Reopened — plan recalculated");
    render();
  });

  return fragment;
}

function getPlan() {
  return scheduleAssignments({
    assignments: ASSIGNMENTS,
    completedIds: state.completed,
    planFrom: state.planFrom,
    termEnd: TERM.end,
    excludedDates: TERM.excludedDates,
    capacityByDate: TERM.capacityByDate,
    workingWeekdays: TERM.workingWeekdays,
    incompatibleCourses: { baba: ["baos310"], baos310: ["baba"] },
  });
}

function renderMetrics(plan) {
  const completedCount = state.completed.size;
  const remaining = ASSIGNMENTS.filter(({ id }) => !state.completed.has(id));
  const remainingBlocks = remaining.reduce((sum, assignment) => sum + (assignment.blocks ?? 1), 0);
  const lastDay = plan.scheduled.at(-1)?.date;
  const lateAssignments = new Set(plan.late.map(({ id }) => id));

  elements.complete.textContent = `${completedCount} / ${ASSIGNMENTS.length}`;
  elements.blocks.textContent = String(remainingBlocks);
  elements.progressFill.style.width = `${Math.round((completedCount / ASSIGNMENTS.length) * 100)}%`;
  elements.finish.textContent = lastDay ? formatDate(lastDay) : "Done";
  elements.finishDetail.textContent = remaining.length ? "If you follow the recalculated blocks" : "Every assignment is checked off";

  const problemCount = lateAssignments.size + plan.unscheduled.length;
  elements.healthMetric.classList.toggle("metric--danger", problemCount > 0);
  elements.health.textContent = problemCount ? "Needs attention" : "On track";
  elements.healthDetail.textContent = problemCount
    ? `${lateAssignments.size} past plan · ${plan.unscheduled.length} cannot fit`
    : "All work fits before its planned finish";

  if (problemCount) {
    elements.alert.hidden = false;
    elements.alert.textContent = `${problemCount} planning conflict${problemCount === 1 ? "" : "s"}. Finish more work, move the planning date earlier, or revise the affected target in the vault board.`;
  } else {
    elements.alert.hidden = true;
    elements.alert.textContent = "";
  }
}

function renderSchedule(plan) {
  elements.scheduleList.replaceChildren();
  const allItems = plan.scheduled.flatMap(({ items }) => items);

  if (!allItems.length) {
    const empty = document.createElement("div");
    empty.className = "empty-state";
    empty.innerHTML = '<span class="empty-state__icon" aria-hidden="true">✓</span><h3>Nothing left to schedule</h3><p>Your completed work is still available in the course checklist.</p>';
    elements.scheduleList.append(empty);
    elements.scheduleRange.textContent = "Plan complete";
    return;
  }

  const firstDate = plan.scheduled[0].date;
  const lastDate = plan.scheduled.at(-1).date;
  elements.scheduleRange.textContent = `${formatDate(firstDate)} – ${formatDate(lastDate)}`;

  const weeks = new Map();
  for (const day of plan.scheduled) {
    const key = weekKey(day.date);
    if (!weeks.has(key)) weeks.set(key, []);
    weeks.get(key).push(day);
  }

  for (const [monday, days] of weeks) {
    const group = document.createElement("section");
    group.className = "week-group";
    const heading = document.createElement("h3");
    heading.className = "week-label";
    heading.textContent = `Week of ${formatDate(monday, longDateFormat)}`;
    group.append(heading);

    for (const day of days) {
      const dayCard = document.createElement("article");
      dayCard.className = "day-card";
      dayCard.innerHTML = `<div class="day-card__date"><strong>${weekdayFormat.format(parseDate(day.date)).toUpperCase()}</strong><span>${formatDate(day.date)}</span></div><div class="day-card__tasks"></div>`;
      const taskList = dayCard.querySelector(".day-card__tasks");
      day.items.forEach((assignment) => taskList.append(makeTaskCard(assignment, { showBlock: true })));
      group.append(dayCard);
    }
    elements.scheduleList.append(group);
  }
}

function renderCourses() {
  const openCourses = new Set(
    [...elements.courseList.querySelectorAll("details[open]")].map((details) => details.dataset.course),
  );
  elements.courseList.replaceChildren();

  Object.entries(COURSES).forEach(([courseId, course], index) => {
    const assignments = ASSIGNMENTS.filter(({ course: id }) => id === courseId);
    const completeCount = assignments.filter(({ id }) => state.completed.has(id)).length;
    const percent = Math.round((completeCount / assignments.length) * 100);
    const details = document.createElement("details");
    details.className = "course-card";
    details.dataset.course = courseId;
    details.style.setProperty("--course", course.color);
    details.open = openCourses.has(courseId) || (openCourses.size === 0 && index === 0 && completeCount < assignments.length);
    details.innerHTML = `
      <summary>
        <span class="course-summary">
          <span class="course-swatch" aria-hidden="true"></span>
          <span class="course-name"><strong>${course.code}</strong><span>${completeCount} of ${assignments.length} assignments · ${course.name}</span></span>
          <span class="course-percent">${percent}%</span>
          <span class="course-progress" aria-hidden="true"><span style="width:${percent}%"></span></span>
        </span>
      </summary>
      <div class="course-tasks"></div>`;
    const list = details.querySelector(".course-tasks");
    assignments.forEach((assignment) => list.append(makeTaskCard(assignment, { complete: state.completed.has(assignment.id) })));
    elements.courseList.append(details);
  });
}

function render() {
  state.planFrom = elements.planFrom.value || state.planFrom;
  const plan = getPlan();
  renderMetrics(plan);
  renderSchedule(plan);
  renderCourses();
}

elements.planFrom.value = state.planFrom;
elements.planFrom.addEventListener("change", () => {
  state.planFrom = elements.planFrom.value;
  saveState("Planning date saved");
  render();
});

elements.recalculate.addEventListener("click", () => {
  state.planFrom = elements.planFrom.value;
  saveState("Plan recalculated");
  render();
});

elements.reset.addEventListener("click", () => {
  if (!window.confirm("Restore the completion state recorded in the vault board and reset the planning date?")) return;
  state = { completed: new Set(INITIAL_COMPLETED_IDS), planFrom: defaultPlanFrom() };
  elements.planFrom.value = state.planFrom;
  saveState("Progress reset");
  render();
});

render();
