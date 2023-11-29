import os
import logging
from argparse import ArgumentParser
from configparser import ConfigParser, RawConfigParser
from pathlib import Path
import sys
from typing import Dict

# Configure logging
logging.basicConfig(
    level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s"
)


class MaintainCaseConfigParser(RawConfigParser):
    def optionxform(self, optionstr):
        return optionstr


def process_env_vars() -> Dict[str, Dict[str, Dict[str, str]]]:
    config_files: Dict[str, Dict[str, Dict[str, str]]] = {}
    for key, value in os.environ.items():
        if not key.startswith("CONFIG_"):
            continue

        tokens = key.split("_")

        if len(tokens) < 4:
            logging.warning(f"Invalid config environment variable: {key}")
            continue

        file_name = tokens[1]
        var_name = tokens[-1]
        section_name = "_".join(tokens[2:-1]).replace("SLASH", "/").replace("DOT", ".")
        section_name = (
            section_name.replace("_/_", "/").replace("/_", "/").replace("_._", ".")
        )

        if file_name not in config_files:
            config_files[file_name] = {}
        if section_name not in config_files[file_name]:
            config_files[file_name][section_name] = {}

        config_files[file_name][section_name][var_name] = value

    return config_files


def update_ini_files(
    config_data: Dict[str, Dict[str, Dict[str, str]]], path: str
) -> None:
    for file_name, sections in config_data.items():
        config_parser = MaintainCaseConfigParser()
        file_path = os.path.join(path, f"{file_name}.ini")

        try:
            if not Path(file_path).exists():
                logging.warning(
                    f"File not found: {file_path}. A new file will be created."
                )
            config_parser.read(file_path)

            for section, vars in sections.items():
                if not config_parser.has_section(section):
                    config_parser.add_section(section)
                for var, value in vars.items():
                    config_parser.set(section, var, value)

            with open(file_path, "w") as config_file:
                config_parser.write(config_file, space_around_delimiters=False)

        except Exception as e:
            logging.error(f"Error updating file {file_name}.ini: {e}")
            continue


def main():
    parser = ArgumentParser(
        description="Update ini configuration files based on environment variables."
    )
    parser.add_argument(
        "--path",
        dest="config_directory",
        type=str,
        help="Path to store created ini files.",
        default="/ark-server/server/ShooterGame/Saved/Config/WindowsServer",
    )
    args = parser.parse_args()

    if not os.path.isdir(args.config_directory):
        logging.error(
            f"The specified directory does not exist: {args.config_directory}"
        )
        sys.exit(1)

    config_data = process_env_vars()
    update_ini_files(config_data, args.config_directory)


if __name__ == "__main__":
    main()
