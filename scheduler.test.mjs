import test from "node:test";
import assert from "node:assert/strict";
import { buildWorkDays, scheduleAssignments } from "./scheduler.mjs";

test("workdays use the real calendar and honor capacity exceptions", () => {
  assert.deepEqual(
    buildWorkDays({
      start: "2026-04-13",
      end: "2026-04-19",
      capacityByDate: { "2026-04-17": 1 },
    }),
    [
      { date: "2026-04-13", capacity: 2 },
      { date: "2026-04-14", capacity: 2 },
      { date: "2026-04-15", capacity: 2 },
      { date: "2026-04-16", capacity: 2 },
      { date: "2026-04-17", capacity: 1 },
    ],
  );
});

test("July plan includes Saturday buffers and keeps Sunday off", () => {
  assert.deepEqual(
    buildWorkDays({
      start: "2026-07-07",
      end: "2026-07-12",
      workingWeekdays: [1, 2, 3, 4, 5, 6],
      capacityByDate: { "2026-07-11": 1 },
    }),
    [
      { date: "2026-07-07", capacity: 2 },
      { date: "2026-07-08", capacity: 2 },
      { date: "2026-07-09", capacity: 2 },
      { date: "2026-07-10", capacity: 2 },
      { date: "2026-07-11", capacity: 1 },
    ],
  );
});

test("multi-block writing work is spread across days", () => {
  const result = scheduleAssignments({
    assignments: [
      { id: "paper", course: "BAOS", title: "Paper", earliest: "2026-08-03", due: "2026-08-10", blocks: 3 },
    ],
    completedIds: [],
    planFrom: "2026-08-03",
    termEnd: "2026-08-10",
  });
  assert.deepEqual(result.scheduled.map(({ date }) => date), ["2026-08-03", "2026-08-04", "2026-08-05"]);
});

test("only one heavy assignment block lands on a day", () => {
  const result = scheduleAssignments({
    assignments: [
      { id: "paper-a", course: "A", title: "Paper A", earliest: "2026-08-03", due: "2026-08-10", blocks: 2 },
      { id: "paper-b", course: "B", title: "Paper B", earliest: "2026-08-03", due: "2026-08-10", blocks: 2 },
      { id: "quiz", course: "C", title: "Quiz", earliest: "2026-08-03", due: "2026-08-10" },
    ],
    completedIds: [],
    planFrom: "2026-08-03",
    termEnd: "2026-08-10",
  });

  assert.deepEqual(result.scheduled[0].items.map(({ id }) => id), ["paper-a", "quiz"]);
  assert.equal(result.scheduled.every(({ items }) => items.filter(({ blocks }) => blocks > 1).length <= 1), true);
});

test("completed assignments disappear and remaining work moves forward", () => {
  const assignments = [
    { id: "a", course: "ONE", title: "First", earliest: "2026-04-13", due: "2026-04-20" },
    { id: "b", course: "ONE", title: "Second", earliest: "2026-04-13", due: "2026-04-20" },
    { id: "c", course: "ONE", title: "Third", earliest: "2026-04-13", due: "2026-04-20" },
  ];
  const result = scheduleAssignments({
    assignments,
    completedIds: ["a"],
    planFrom: "2026-04-13",
    termEnd: "2026-04-20",
  });

  assert.deepEqual(result.scheduled[0].items.map((item) => item.id), ["b", "c"]);
  assert.equal(result.unscheduled.length, 0);
});

test("planning date, exclusions, conflicts, and deadlines are enforced", () => {
  const result = scheduleAssignments({
    assignments: [
      { id: "a", course: "A", title: "A task", earliest: "2026-04-13", due: "2026-04-14" },
      { id: "b", course: "B", title: "B task", earliest: "2026-04-13", due: "2026-04-14" },
    ],
    completedIds: [],
    planFrom: "2026-04-14",
    termEnd: "2026-04-16",
    excludedDates: ["2026-04-15"],
    capacityByDate: { "2026-04-14": 2 },
    incompatibleCourses: { A: ["B"], B: ["A"] },
  });

  assert.equal(result.scheduled[0].date, "2026-04-14");
  assert.equal(result.scheduled[1].date, "2026-04-16");
  assert.equal(result.late[0].id, "b");
});
