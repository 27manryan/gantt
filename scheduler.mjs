const DAY_MS = 24 * 60 * 60 * 1000;

export function parseDate(dateString) {
  const [year, month, day] = dateString.split("-").map(Number);
  return new Date(Date.UTC(year, month - 1, day));
}

export function toISODate(date) {
  return date.toISOString().slice(0, 10);
}

export function addDays(dateString, amount) {
  return toISODate(new Date(parseDate(dateString).getTime() + amount * DAY_MS));
}

export function compareDates(left, right) {
  return left.localeCompare(right);
}

export function buildWorkDays({ start, end, excludedDates = [], capacityByDate = {} }) {
  const excluded = new Set(excludedDates);
  const days = [];

  for (let cursor = start; compareDates(cursor, end) <= 0; cursor = addDays(cursor, 1)) {
    const weekday = parseDate(cursor).getUTCDay();
    if (weekday === 0 || weekday === 6 || excluded.has(cursor)) continue;

    const capacity = Math.max(0, capacityByDate[cursor] ?? 2);
    if (capacity > 0) days.push({ date: cursor, capacity });
  }

  return days;
}

function nextAvailableSlot(days, slots, task, incompatibleCourses) {
  return days.findIndex((day) => {
    if (compareDates(day.date, task.earliest) < 0) return false;
    if ((slots.get(day.date)?.length ?? 0) >= day.capacity) return false;

    const coursesOnDay = new Set((slots.get(day.date) ?? []).map((item) => item.course));
    const blocked = incompatibleCourses[task.course] ?? [];
    return blocked.every((course) => !coursesOnDay.has(course));
  });
}

/**
 * Places each unfinished assignment into the earliest legal study block.
 * Assignments retain their declared order, earliest date, and course conflicts.
 */
export function scheduleAssignments({
  assignments,
  completedIds,
  planFrom,
  termEnd,
  excludedDates = [],
  capacityByDate = {},
  incompatibleCourses = {},
}) {
  const completed = new Set(completedIds);
  const days = buildWorkDays({
    start: planFrom,
    end: termEnd,
    excludedDates,
    capacityByDate,
  });
  const slots = new Map(days.map((day) => [day.date, []]));
  const unscheduled = [];

  for (const assignment of assignments) {
    if (completed.has(assignment.id)) continue;

    const blockCount = Math.max(1, assignment.blocks ?? 1);
    for (let block = 1; block <= blockCount; block += 1) {
      const task = {
        ...assignment,
        earliest: compareDates(assignment.earliest, planFrom) < 0 ? planFrom : assignment.earliest,
        block,
        blockCount,
      };
      const dayIndex = nextAvailableSlot(days, slots, task, incompatibleCourses);
      if (dayIndex === -1) {
        unscheduled.push(task);
        continue;
      }

      const scheduledDate = days[dayIndex].date;
      slots.get(scheduledDate).push({ ...task, scheduledDate });
    }
  }

  const scheduled = [...slots.entries()]
    .filter(([, items]) => items.length)
    .map(([date, items]) => ({ date, items }));

  const late = scheduled.flatMap(({ items }) =>
    items.filter((item) => item.due && compareDates(item.scheduledDate, item.due) > 0),
  );

  return { scheduled, unscheduled, late };
}
