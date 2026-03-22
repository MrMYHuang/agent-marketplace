---
name: sqlcl
description: Use SQLcl to connect to Oracle databases through a saved named connection and run generated `.sql` scripts directly with `sql -S`. Use when the user wants to query or modify an Oracle database, includes or can provide a SQLcl saved connection name in the prompt, expects Codex to extract that connection name when explicit, translate a natural-language request into a `.sql` file and execute it, or asks to dump data into an executable SQL export file.
---

# SQLcl

Translate the user's database request into a `.sql` script, save it to disk, and run it with SQLcl against a saved named connection.

## Workflow

### 1. Identify the named connection

Do not guess the connection. Extract a SQLcl saved connection name from the user's prompt when it is explicit; otherwise ask for it.

Treat the connection as explicit when the prompt clearly names it, for example:

- `use connection hr-dev`
- `run this on fin_prod`
- `with saved connection "orders-qa"`
- `using \`analytics\``

Extraction rules:

- Reuse the exact connection token the user supplied, trimming only surrounding quotes or backticks.
- If the prompt contains exactly one plausible saved connection name tied to words such as `connection`, `saved connection`, `using`, `with`, `on`, or `against`, use it without asking a follow-up question.
- If there are multiple plausible connection names, stop and ask which one to use.
- If there is no explicit connection name, stop and ask for one.
- Never infer a connection from schema names, usernames, hosts, environments, or prior unrelated context.

Use SQLcl's named connection form:

```bash
sql -S -name "<connection-name>" @/path/to/script.sql
```

If the prompt does not contain a single explicit connection name, stop and ask for it.

### 2. Convert the request into SQL

Write a concrete SQL or PL/SQL script from the user's request.

Default rules:

- Prefer read-only SQL unless the user explicitly asks to change data or schema.
- Keep the script self-contained.
- Append `exit;` as the final statement in every generated `.sql` file so SQLcl terminates after execution.
- Include `set` commands when they improve readable output.
- End SQL and PL/SQL statements correctly with `;` and `/` where needed.
- For destructive operations (`delete`, `truncate`, `drop`, `alter`, bulk `update`, grants, revokes), require explicit user intent.

When the request is ambiguous, inspect the schema first with a read-only query rather than inventing table or column names.

### 3. Save the script

Save the generated script as a `.sql` file before execution.

Before saving, ensure the file ends with `exit;`.

Preferred locations:

- User-specified path if provided
- Workspace scratch file such as `./tmp/sqlcl/<task-name>.sql`
- `/tmp/sqlcl/<task-name>.sql` if the workspace should stay clean

Create the parent directory if needed.

### 4. Execute directly with `sql -S`

Run the saved file directly:

```bash
sql -S -name "<connection-name>" @/absolute/path/to/script.sql
```

### 5. Review the result

After execution:

- Report the script path you created
- Summarize the important output or errors
- If the command failed, keep the `.sql` file and explain the failing statement or connection problem

## Dump Data Workflow

If the user asks to "dump data", do not stop at console output. Generate a SQL export file.

Preferred behavior:

- Run a `.sql` script that uses `spool` to write another `.sql` file
- Emit executable SQL statements into that export file
- Append `exit;` to the end of the generator script and to the end of the exported `.sql` file
- Prefer `insert` statements for data dumps so the result can be replayed later
- Use DDL output only when the user explicitly asks for schema or object definitions

For data dumps, the generated export file is the primary artifact.

Typical shape:

```sql
set echo off
set feedback off
set heading off
set pagesize 0
set trimspool on
set linesize 32767

spool /absolute/path/to/export.sql
select 'insert into employees(employee_id, first_name) values ('
       || employee_id
       || ', '''
       || replace(first_name, '''', '''''')
       || ''');'
from employees;
prompt exit;
spool off
exit;
```

Then execute the generator script with:

```bash
sql -S -name "<connection-name>" @/absolute/path/to/generate-dump.sql
```

After execution:

- Report both the generator script path and the exported `.sql` file path
- Treat the exported `.sql` file as the result of the task
- If the user asked for schema DDL instead of row data, prefer `dbms_metadata.get_ddl(...)`

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
exit;
```

Execution:

```bash
sql -S -name "hr-dev" @/absolute/path/to/recent-employees.sql
```

User request:
"Run this on orders-qa: dump rows from order_headers into a replayable SQL file."

Interpretation:

- Extract `orders-qa` as the saved connection name from the prompt.
- Generate a spool-based dump script and execute it with `sql -S -name "orders-qa" ...`.

## References

- Read [references/sqlcl-usage.md](references/sqlcl-usage.md) for the exact SQLcl help text relevant to named connections, `@script.sql` execution, and spool-based SQL exports.
