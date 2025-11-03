# config_from_env_vars

```
usage: main.py [-h] [--path CONFIG_DIRECTORY]

Update ini configuration files based on environment variables.

options:
  -h, --help            show this help message and exit
  --path CONFIG_DIRECTORY
                        Path to store created ini files.
```

## Environment Variable Format

```bash
CONFIG_<config_file>_<section>_<variable>=<value>.
```
* `CONFIG_`
  * All variables used by the script must have the `CONFIG_` prefix. 
* `<config_file>`
  * The name of the config file to create. Do not include the extension, all files will be `.ini` files.
  * Must be contained within the first pairs of underscores `_`.
  * If the config file already exists, it will be updated.
* `<section>`
  * The section of the config file to create the variables in. 
  * If the section contains special characters like `/` or `.` replace them with `_SLASH_` and `_DOT_` respectively.
* `<variable>`
  * The name of the variable to create in the config file.
  * Must be after the last underscores `_`.
  * May end with a number to produce a variable like <variable>[number]
* `<value>`
  * The value to set the variable to.

## File Backups

When a `CONFIG_` variable is changed between executions, the script will create a backup copy of the current config file then generate a new one. The backup will be stored in the same directory as the config file with the same name and the `.backup#` extension. The `#` will be incremented for each backup created, and the highest number reflects the newest backup.

If you introduce `CONFIG_` vars and eventually remove all of them, the current configs will have a backup made, but no new config will be generated. 

## Example Execution

### Example 1

```bash
export CONFIG_Test_Test_Section_Var=Value
python3 main.py --path $(pwd)
```

Creates

```ini
#Test.ini
[Test_Section]
Var = Value
```

### Example 2

```bash
export CONFIG_Test_Test_DOT_Section_Var=Test
python3 main.py --path $(pwd)
```

Creates
  
```ini
#Test.ini
[Test.Section]
Var = Test
```

### Example 3

```bash
export CONFIG_Test_Test_DOT_Section_Var5=Test
python3 main.py --path $(pwd)
```

Creates
  
```ini
#Test.ini
[Test.Section]
Var[5] = Test
```

## Test Execution

To execute the unit tests associated with this script, run the following command from the project's root directory:

```bash
python3 -m unittest tests/config_from_env_vars/test_main.py
```