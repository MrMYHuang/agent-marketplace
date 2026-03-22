---
name: sqlcl
description: Use SQLcl to connect to Oracle databases through a saved named connection and run generated `.sql` scripts. Use when the user wants to query or modify an Oracle database with the `sql` command, provides or can provide a SQLcl connection name, and expects Codex to translate a natural-language request into a `.sql` file and execute it.
---

# SQLcl

Translate the user's database request into a `.sql` script, save it to disk, and run it with SQLcl against a saved named connection.

## Workflow

### 1. Require a named connection

Do not guess the connection. Require the user to provide a SQLcl saved connection name.

Use SQLcl's named connection form:

```bash
sql -name "<connection-name>" @/path/to/script.sql
```

If the user has not supplied a connection name, stop and ask for it.

### 2. Convert the request into SQL

Write a concrete SQL or PL/SQL script from the user's request.

Default rules:

- Prefer read-only SQL unless the user explicitly asks to change data or schema.
- Keep the script self-contained.
- Include `set` commands when they improve readable output.
- End SQL and PL/SQL statements correctly with `;` and `/` where needed.
- For destructive operations (`delete`, `truncate`, `drop`, `alter`, bulk `update`, grants, revokes), require explicit user intent.

When the request is ambiguous, inspect the schema first with a read-only query rather than inventing table or column names.

### 3. Save the script

Save the generated script as a `.sql` file before execution.

Preferred locations:

- User-specified path if provided
- Workspace scratch file such as `./tmp/sqlcl/<task-name>.sql`
- `/tmp/sqlcl/<task-name>.sql` if the workspace should stay clean

Create the parent directory if needed.

### 4. Execute with the helper script

Use the bundled runner:

```bash
./scripts/run_sqlcl.sh --connection "<connection-name>" --sql-file /absolute/path/to/script.sql
```

Run it from the skill directory:

```bash
cd /Users/myh/Documents/agent-marketplace/myh-plugin/skills/sqlcl
./scripts/run_sqlcl.sh --connection "<connection-name>" --sql-file /absolute/path/to/script.sql
```

The runner executes:

```bash
sql -name "<connection-name>" @/absolute/path/to/script.sql
```

### 5. Review the result

After execution:

- Report the script path you created
- Summarize the important output or errors
- If the command failed, keep the `.sql` file and explain the failing statement or connection problem

## Output Conventions

For query scripts, prefer readable output:

```sql
set echo off
set feedback on
set sqlformat ansiconsole
set pagesize 100
```

For DML or DDL scripts, include `prompt` lines so the execution log is easy to scan.

Use `commit;` only when the user explicitly requested a persistent change and autocommit should not be assumed.

## Example Patterns

User request:
"Use connection `hr-dev` and show the 20 most recent employees by hire date."

Script:

```sql
set echo off
set feedback on
set sqlformat ansiconsole
set pagesize 100

select employee_id, first_name, last_name, hire_date
from employees
order by hire_date desc
fetch first 20 rows only;
```

Execution:

```bash
cd /Users/myh/Documents/agent-marketplace/myh-plugin/skills/sqlcl
./scripts/run_sqlcl.sh --connection "hr-dev" --sql-file /absolute/path/to/recent-employees.sql
```

## References

- Read [references/sqlcl-usage.md](references/sqlcl-usage.md) for the exact SQLcl help text relevant to named connections and `@script.sql` execution.
