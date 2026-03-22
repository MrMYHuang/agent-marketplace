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

## Script execution

SQLcl accepts a startup script as:

```text
<start> is: @<URL>|<filename>[.<ext>] [<parameter> ...]
```

For this skill, prefer local `.sql` files and absolute paths.

## Relevant help excerpt

Verified from `sql -help` on this machine:

- `sql  [<option>] [{ <logon> | /nolog}] [<start>]`
- `-name <named-connection>    Connect to a saved connection. see connmgr for details.`
- `<start> is: @<URL>|<filename>[.<ext>] [<parameter> ...]`

Use these forms directly rather than inventing alternate wrappers.
