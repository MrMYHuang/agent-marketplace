# SQLcl Usage Notes

These are the locally verified SQLcl help patterns this skill depends on.

## Named connection

Use a saved connection with:

```bash
sql -name "<named-connection>"
```

Run a script against that connection with:

```bash
sql -name "<named-connection>" @/path/to/script.sql
```

This is the preferred execution form for the skill. Do not wrap it in a helper script.

## Script execution

SQLcl accepts a startup script as:

```text
<start> is: @<URL>|<filename>[.<ext>] [<parameter> ...]
```

For this skill, prefer local `.sql` files and absolute paths.

## Dumping data to a SQL file

When the user asks for a data dump, use a generator script that spools executable SQL into another file.

Core SQLcl commands:

```sql
spool /path/to/export.sql
...
spool off
```

Recommended SQL*Plus-compatible settings for machine-readable exports:

```sql
set echo off
set feedback off
set heading off
set pagesize 0
set trimspool on
set linesize 32767
```

Prefer generating `insert` statements for row-data dumps. Use `dbms_metadata.get_ddl` only for schema/object DDL requests.

## Relevant help excerpt

Verified from `sql -help` on this machine:

- `sql  [<option>] [{ <logon> | /nolog}] [<start>]`
- `-name <named-connection>    Connect to a saved connection. see connmgr for details.`
- `<start> is: @<URL>|<filename>[.<ext>] [<parameter> ...]`

Use these forms directly rather than inventing alternate wrappers.
