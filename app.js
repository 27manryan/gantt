import { compareDates, parseDate, scheduleAssignments } from "./scheduler.mjs";

const TERM = {
  start: "2026-04-13",
  end: "2026-06-26",
  excludedDates: ["2026-05-25"],
  capacityByDate: { "2026-04-17": 1 },
};

const COURSES = {
  bama: { code: "BAMA 300X", name: "Applied Business Statistics", color: "#14745a" },
  mus: { code: "MUS 273X", name: "Jazz History", color: "#b46a16" },
  baef201: { code: "BAEF 201X", name: "Financial Accounting", color: "#b73870" },
  baef302: { code: "BAEF 302X", name: "Finance", color: "#7057c9" },
  pmgt: { code: "PMGT 315X", name: "Project Management", color: "#7454a6" },
  bams: { code: "BAMS 301X", name: "Marketing", color: "#1d70a2" },
  baba: { code: "BABA 301X", name: "Data Visualization", color: "#3c7d33" },
  balm: { code: "BALM 310X", name: "Organizational Behavior", color: "#a44c2c" },
};

const task = (id, course, title, earliest, due, extra = {}) => ({ id, course, title, earliest, due, blocks: 1, ...extra });

const ASSIGNMENTS = [
  task("bama-normal", "bama", "Normal distribution, sampling & confidence intervals", "2026-04-13", "2026-04-24", { note: "Pre-assessment, then assessment" }),
  task("mus-m3", "mus", "Module 3 · Early Jazz assessment", "2026-04-13", "2026-04-24"),
  task("bama-quiz-1", "bama", "Quiz · Probability, distributions & confidence intervals", "2026-04-14", "2026-04-24", { note: "75 minutes · 8 problems" }),
  task("mus-m4", "mus", "Module 4 · Swing and Bebop assessment", "2026-04-14", "2026-04-24"),
  task("bama-hypothesis", "bama", "Hypothesis testing for population means", "2026-04-15", "2026-04-24", { note: "Pre-assessment, then assessment" }),
  task("mus-m6", "mus", "Module 6 · Cool Jazz and Free Jazz assessment", "2026-04-15", "2026-04-24"),
  task("bama-chi-pre", "bama", "Chi-square tests · pre-assessment", "2026-04-17", "2026-04-24", { note: "Limited-availability day" }),
  task("bama-chi", "bama", "Chi-square tests · assessment", "2026-04-20", "2026-04-24"),
  task("bama-quiz-2", "bama", "Quiz · Hypothesis testing and chi-square", "2026-04-20", "2026-04-24", { note: "75 minutes · 6 problems" }),
  task("bama-project-setup", "bama", "Stock markets project · stocks, workbook & data", "2026-04-20", "2026-05-01"),
  task("mus-m7", "mus", "Module 7 · Fusion and present assessment", "2026-04-20", "2026-05-08"),
  task("bama-project-analysis", "bama", "Stock markets project · calculations and tests", "2026-04-21", "2026-05-01"),
  task("mus-m8", "mus", "Module 8 · Compare and contrast discussion", "2026-04-21", "2026-05-08"),
  task("bama-project-report", "bama", "Stock markets project · write report", "2026-04-22", "2026-05-01"),
  task("baef201-ethics", "baef201", "Ethical considerations in accounting", "2026-04-22", "2026-05-08"),
  task("bama-project-submit", "bama", "Stock markets project · finalize and submit", "2026-04-23", "2026-05-01"),
  task("baef201-bank", "baef201", "Bank reconciliation and internal controls", "2026-04-23", "2026-05-08"),
  task("baef302-jj", "baef302", "J&J performance evaluation and financial calculators paper", "2026-04-24", "2026-05-08"),
  task("mus-video-pick", "mus", "Choose and save a jazz concert video", "2026-04-24", "2026-04-28", { note: "YouTube or PBS · about 15 minutes" }),
  task("baef201-project", "baef201", "Fraud triangle case study project", "2026-04-27", "2026-05-08"),
  task("baef302-personal", "baef302", "Personal finances and business valuation approaches", "2026-04-27", "2026-05-08"),
  task("baef302-valuation", "baef302", "Valuation of a firm project", "2026-04-28", "2026-05-08"),
  task("pmgt-assessments", "pmgt", "Read course content and complete assessments", "2026-04-28", "2026-05-08", { blocks: 2 }),
  task("mus-concert-watch", "mus", "Watch jazz performance and take notes", "2026-04-29", "2026-05-08", { blocks: 2, note: "Approximately 90 minutes total" }),
  task("mus-concert-essay", "mus", "Concert essay · write and submit", "2026-04-29", "2026-05-08", { note: "2 pages · double-spaced" }),
  task("mus-paper-sources", "mus", "Research paper · outline and gather sources", "2026-04-30", "2026-06-19", { note: "3+ written sources; no textbook or Wikipedia" }),
  task("mus-paper-draft", "mus", "Research paper · draft", "2026-04-30", "2026-06-19", { blocks: 2 }),
  task("mus-paper-submit", "mus", "Research paper · revise and submit", "2026-05-01", "2026-06-19", { note: "5 pages · jazz history and Black ethnic struggle" }),
  task("bama-confirm", "bama", "Confirm final grade or resubmit", "2026-05-04", "2026-05-08"),
  task("bama-advisor", "bama", "Contact advisor and request July SP enrollment", "2026-05-08", "2026-05-08", { note: "BABA 300X, BABA 302X and BABA 304X" }),
  task("bams-content", "bams", "Course content modules", "2026-05-04", "2026-05-15", { blocks: 4 }),
  task("bams-plan-draft", "bams", "Marketing plan · draft", "2026-05-07", "2026-05-15"),
  task("bams-plan-submit", "bams", "Marketing plan · finalize and submit", "2026-05-08", "2026-05-15"),
  task("bams-presentation", "bams", "Record and submit presentation", "2026-05-11", "2026-05-15", { blocks: 2 }),
  task("bams-confirm", "bams", "Confirm grade or resubmit", "2026-05-13", "2026-05-15"),
  task("baba-m1", "baba", "Module 1 · Install Tableau and preliminary graphs", "2026-05-11", "2026-06-05"),
  task("baba-m2", "baba", "Module 2 · Basic visualizations", "2026-05-11", "2026-06-05", { blocks: 2 }),
  task("baba-m3", "baba", "Module 3 · Beyond basic visualizations", "2026-05-12", "2026-06-05", { blocks: 2 }),
  task("baba-m4", "baba", "Module 4 · Calculations and parameters", "2026-05-13", "2026-06-05", { blocks: 2 }),
  task("baba-m5", "baba", "Module 5 · Level of detail calculations", "2026-05-14", "2026-06-05", { blocks: 2 }),
  task("baba-m6", "baba", "Module 6 · Table calculations", "2026-05-14", "2026-06-05", { blocks: 2 }),
  task("baba-m7", "baba", "Module 7 · Data story with dashboards", "2026-05-15", "2026-06-05", { blocks: 2 }),
  task("baba-m8", "baba", "Module 8 · Creating dashboards", "2026-05-18", "2026-06-05", { blocks: 2 }),
  task("baba-m9", "baba", "Module 9 · Forecasting with Tableau", "2026-05-19", "2026-06-05", { blocks: 2 }),
  task("baba-m10", "baba", "Module 10 · Dynamic dashboards", "2026-05-20", "2026-06-05", { blocks: 2 }),
  task("baba-m11", "baba", "Module 11 · Creating maps", "2026-05-21", "2026-06-05", { blocks: 2 }),
  task("baba-m12", "baba", "Module 12 · Joins, blends and messy data", "2026-05-26", "2026-06-05", { blocks: 2 }),
  task("baba-final", "baba", "Final assessment · Messy data and visualization", "2026-05-27", "2026-06-05", { blocks: 2 }),
  task("balm-individual-content", "balm", "Understanding the individual · course content", "2026-05-26", "2026-06-12", { blocks: 2 }),
  task("balm-individual-assessment", "balm", "Apply theories of the individual · assessment", "2026-06-01", "2026-06-12", { blocks: 2 }),
  task("balm-team-content", "balm", "Group and team dynamics · course content", "2026-06-02", "2026-06-12", { blocks: 2 }),
  task("balm-team-assessment", "balm", "Diagnose and improve team dynamics · assessment", "2026-06-08", "2026-06-12", { blocks: 2 }),
  task("balm-project-outline", "balm", "Project 3 into 1 · outline", "2026-06-15", "2026-06-23"),
  task("balm-project-draft", "balm", "Project 3 into 1 · draft", "2026-06-16", "2026-06-23"),
  task("balm-project-submit", "balm", "Project 3 into 1 · revise and submit", "2026-06-17", "2026-06-23"),
];

const STORAGE_KEY = "apr-sp-adaptive-board-v2";
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
    const completed = Array.isArray(stored?.completed) ? stored.completed.filter((id) => validIds.has(id)) : [];
    const planFrom = stored?.planFrom && compareDates(stored.planFrom, TERM.start) >= 0 && compareDates(stored.planFrom, TERM.end) <= 0
      ? stored.planFrom
      : defaultPlanFrom();
    return { completed: new Set(completed), planFrom };
  } catch {
    return { completed: new Set(), planFrom: defaultPlanFrom() };
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
    incompatibleCourses: { baba: ["balm"], balm: ["baba"] },
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
    ? `${lateAssignments.size} late · ${plan.unscheduled.length} cannot fit`
    : "All work fits before its deadline";

  if (problemCount) {
    elements.alert.hidden = false;
    elements.alert.textContent = `${problemCount} planning conflict${problemCount === 1 ? "" : "s"}. Move the planning date earlier, finish more work, or treat the affected deadline as a manual exception.`;
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
  if (!window.confirm("Clear every completed assignment and restore the original planning date?")) return;
  state = { completed: new Set(), planFrom: TERM.start };
  elements.planFrom.value = state.planFrom;
  saveState("Progress reset");
  render();
});

render();
