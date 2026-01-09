# DayFlow REST API

Base URL: `https://ay-low-ackend-mohamedalaminsaad7753-nw351cb9.leapcell.dev`

## Auth
- Send `Authorization: Bearer <Firebase ID token>` on every request.
- Backend verifies the token with Firebase Admin and injects `{ uid, email }` into `req.user`.

## Data Shapes (aligned with Flutter `toFirestore()` models)
- **Task**: `title` (string), `description` (string|null), `isCompleted` (bool, default false), `createdAt` (ISO string), `dueDate` (ISO string|null), `priority` (`none|low|medium|high`), `tags` (string[]), `subtasks` (`{id,title,isCompleted}[]`), `attachments` (`{id,taskId,name,url,type,createdAt}[]`), `recurrence` (object), `parentTaskId` (string|null).
- **Habit**: `name`, `description`, `icon`, `frequency` (`daily|weekly|custom`), `goalCount` (int), `linkedTaskTags` (string[]), `completionHistory` (map of `yyyy-MM-dd` -> bool), `createdAt` (ISO string), `colorValue` (int ARGB).
- **Note**: `title`, `content`, `createdAt` (ISO string), `updatedAt` (ISO string|null), `colorValue` (int|null), `tags` (string[]), `isPinned` (bool), `type` (`text|checklist|richText`), `attachments` (`{id,noteId?,name,url,type,createdAt}[]`), `checklistItems` (`{id,title,isChecked}[]`), `isLocked` (bool), `lockPin` (string|null), `useBiometric` (bool), `category` (enum name).
- **Notification**: `title`, `body`, `timestamp` (ISO string), `isRead` (bool), `payload` (string|null).

## Endpoints

| Method | Path | Purpose | Body | Success |
| --- | --- | --- | --- | --- |
| GET | /user/me | Current identity | — | `{ uid, email }` |
| GET | /tasks | List tasks | — | `{ tasks: Task[] }` |
| POST | /tasks | Create task | Task fields (optional `id`, `createdAt`) | `Task with id` |
| PUT | /tasks/:id | Update task | Partial Task | `Task with id` |
| DELETE | /tasks/:id | Delete task | — | 204 No Content |
| POST | /tasks/:id/toggle-complete | Toggle completion | — | `Task with updated isCompleted` |
| POST | /tasks/:taskId/subtasks/:subtaskId/toggle | Toggle subtask | — | `{ id, ...task, toggledSubtask }` |
| GET | /habits | List habits | — | `{ habits: Habit[] }` |
| POST | /habits | Create habit | Habit fields (optional `id`, `createdAt`) | `Habit with id` |
| PUT | /habits/:id | Update habit | Partial Habit | `Habit with id` |
| DELETE | /habits/:id | Delete habit | — | 204 No Content |
| POST | /habits/:id/toggle-completion | Toggle completion for date | `{ dateKey: "yyyy-MM-dd" }` | `Habit with updated completionHistory` |
| GET | /notes | List notes (filters) | Query: `?tag=&category=` | `{ notes: Note[] }` |
| POST | /notes | Create note | Note fields (optional `id`, `createdAt`) | `Note with id` |
| PUT | /notes/:id | Update note | Partial Note | `Note with id` |
| DELETE | /notes/:id | Delete note | — | 204 No Content |
| POST | /notes/:id/toggle-pin | Toggle pin | — | `Note with updated isPinned` |
| POST | /notes/:id/lock | Lock note | `{ lockPin?, useBiometric? }` | `Note with lock fields` |
| POST | /notes/:id/unlock | Unlock note | — | `Note with isLocked=false` |
| GET | /notifications?limit=&cursor= | List notifications | limit default 20, cursor = ISO timestamp | `{ notifications, nextCursor }` |
| GET | /notifications/unread-count | Get unread count | — | `{ unreadCount: number }` |
| POST | /notifications | Create notification | Notification fields (optional `id`, `timestamp`) | `Notification with id` |
| POST | /notifications/read-all | Mark all as read | — | `{ success: true, updatedCount: number }` |
| POST | /notifications/:id/read | Mark read | — | `Notification with isRead=true` |
| DELETE | /notifications/:id | Delete notification | — | 204 No Content |

## Error Codes
- 400: bad input (e.g., missing `dateKey`, lock payload, title/body).
- 401: missing/invalid token.
- 404: resource not found.
- 500: unexpected server error.

## Sample cURL (replace `$TOKEN` with Firebase ID token)

```sh
# Identity
curl -H "Authorization: Bearer $TOKEN" https://ay-low-ackend-mohamedalaminsaad7753-nw351cb9.leapcell.dev/api/user/me

# Create task
curl -X POST https://ay-low-ackend-mohamedalaminsaad7753-nw351cb9.leapcell.dev/api/tasks \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Read API spec",
    "createdAt": "$(date -Iseconds)",
    "priority": "medium",
    "tags": ["school"],
    "subtasks": [{"id":"sub-1","title":"skim doc","isCompleted":false}]
  }'

# Toggle task completion
curl -X POST -H "Authorization: Bearer $TOKEN" \
  https://ay-low-ackend-mohamedalaminsaad7753-nw351cb9.leapcell.dev/<taskId>/toggle-complete

# Toggle subtask
curl -X POST -H "Authorization: Bearer $TOKEN" \
  https://ay-low-ackend-mohamedalaminsaad7753-nw351cb9.leapcell.dev/<taskId>/subtasks/<subtaskId>/toggle

# Create habit
curl -X POST https://ay-low-ackend-mohamedalaminsaad7753-nw351cb9.leapcell.dev/api/habits \
  -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" \
  -d '{"name":"Drink water","icon":"💧","frequency":"daily","goalCount":7,"linkedTaskTags":[],"createdAt":"$(date -Iseconds)","colorValue":4281472029}'

# Toggle habit completion for today
curl -X POST https://ay-low-ackend-mohamedalaminsaad7753-nw351cb9.leapcell.dev/<habitId>/toggle-completion \
  -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" \
  -d '{"dateKey":"$(date +%F)"}'

# Create note
curl -X POST https://ay-low-ackend-mohamedalaminsaad7753-nw351cb9.leapcell.dev/api/notes \
  -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" \
  -d '{"title":"Ideas","content":"<p>Ship auth</p>","createdAt":"$(date -Iseconds)","type":"richText","tags":["ideas"],"isPinned":false}
'

# List notifications
curl -H "Authorization: Bearer $TOKEN" "https://ay-low-ackend-mohamedalaminsaad7753-nw351cb9.leapcell.dev/api/notifications?limit=20"

# Mark notification read
curl -X POST -H "Authorization: Bearer $TOKEN" https://ay-low-ackend-mohamedalaminsaad7753-nw351cb9.leapcell.dev/api/notifications/<notificationId>/read
```

## Manual Test Checklist
1. Obtain a Firebase ID token (mobile app).
2. Hit `/api/user/me` with the token to confirm middleware works.
3. Create + fetch a task; toggle completion and a subtask.
4. Create + fetch a habit; toggle completion with today’s `dateKey`.
5. Create + fetch a note; toggle pin; lock then unlock.
6. Create a notification; list with `limit` and `cursor`; mark as read.
