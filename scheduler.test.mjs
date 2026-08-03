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
