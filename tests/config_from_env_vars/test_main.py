# test_main.py

import logging
from pathlib import Path
import unittest
from unittest import mock
from unittest.mock import MagicMock, patch, mock_open
from config_from_env_vars.main import (
    process_env_vars,
    update_ini_files,
    backup_existing_ini_files,
    compare_and_cleanup_configs,
    get_latest_backup_file,
)

# logging.disable(logging.CRITICAL)


class TestConfigFromEnvVars(unittest.TestCase):
    def setUp(self):
        self.env_patcher = patch.dict("os.environ", clear=True)
        self.env_patcher.start()
        logging.disable(logging.NOTSET)

    def tearDown(self):
        self.env_patcher.stop()
        logging.disable(logging.ERROR)

    @patch.dict(
        "os.environ",
        {"CONFIG_GameUserSettings_ServerSettings_DifficultyOffset": "0.25"},
    )
    def test_process_env_vars_simple(self):
        result = process_env_vars()
        self.assertEqual(
            result,
            {"GameUserSettings": {"ServerSettings": {"DifficultyOffset": "0.25"}}},
        )

    @patch.dict(
        "os.environ",
        {
            "CONFIG_GameUserSettings_ServerSettings_DifficultyOffset": "0.25",
            "CONFIG_AppearanceSettings_ServerSettings_DifficultyOffset": "0.75",
        },
    )
    def test_process_env_vars_with_two_files(self):
        result = process_env_vars()
        expected = {
            "GameUserSettings": {"ServerSettings": {"DifficultyOffset": "0.25"}},
            "AppearanceSettings": {"ServerSettings": {"DifficultyOffset": "0.75"}},
        }
        self.assertEqual(result, expected)

    @patch.dict(
        "os.environ",
        {
            "CONFIG_GameUserSettings_ServerSettings_DifficultyOffset": "0.25",
            "CONFIG_GameUserSettings_PlayerSettings_DifficultyOffset": "0.75",
        },
    )
    def test_process_env_vars_with_two_sections(self):
        result = process_env_vars()
        expected = {
            "GameUserSettings": {
                "ServerSettings": {"DifficultyOffset": "0.25"},
                "PlayerSettings": {"DifficultyOffset": "0.75"},
            }
        }
        self.assertEqual(result, expected)

    @patch.dict(
        "os.environ",
        {
            "CONFIG_GameUserSettings_ServerSettings_DifficultyOffset": "0.25",
            "CONFIG_GameUserSettings_ServerSettings_XPOffset": "0.75",
        },
    )
    def test_process_env_vars_with_two_vars(self):
        result = process_env_vars()
        expected = {
            "GameUserSettings": {
                "ServerSettings": {"DifficultyOffset": "0.25", "XPOffset": "0.75"}
            }
        }
        self.assertEqual(result, expected)

    @patch.dict(
        "os.environ",
        {"CONFIG_GameUserSettings_Server_DOT_Settings_DifficultyOffset": "0.25"},
    )
    def test_process_env_vars_with_dot_in_section(self):
        result = process_env_vars()
        self.assertEqual(
            result,
            {"GameUserSettings": {"Server.Settings": {"DifficultyOffset": "0.25"}}},
        )

    @patch.dict(
        "os.environ",
        {"CONFIG_GameUserSettings_Server_SLASH_Settings_DifficultyOffset": "0.25"},
    )
    def test_process_env_vars_with_slash_in_section(self):
        result = process_env_vars()
        self.assertEqual(
            result,
            {"GameUserSettings": {"Server/Settings": {"DifficultyOffset": "0.25"}}},
        )

    @patch.dict("os.environ", {"CONFIG_GameUserSettings_DifficultyOffset": "0.25"})
    def test_process_env_vars_with_missing_variable_template_section(self):
        result = process_env_vars()
        self.assertEqual(result, {})

    @patch("builtins.open", new_callable=mock_open)
    @patch("config_from_env_vars.main.MaintainCaseConfigParser")
    def test_update_ini_files_single_file(self, mock_config, mock_file):
        mock_config_data = {
            "GameUserSettings": {
                "ServerSettings": {
                    "DifficultyOffset": "0.25",
                }
            }
        }
        update_ini_files(mock_config_data, "/fake/path")
        mock_file.assert_called_once_with("/fake/path/GameUserSettings.ini", "w")
        mock_config.return_value.set.assert_called_once_with(
            "ServerSettings", "DifficultyOffset", "0.25"
        )
        mock_config.return_value.write.assert_called_once()

    @patch("builtins.open", new_callable=mock_open)
    @patch("config_from_env_vars.main.MaintainCaseConfigParser")
    def test_update_ini_files_multiple_file(self, mock_config, mock_file):
        mock_config_data = {
            "GameUserSettings": {
                "ServerSettings": {
                    "DifficultyOffset": "0.25",
                }
            },
            "GameAppearance": {
                "Logo": {
                    "Path": "/path/to/logo.png",
                }
            },
        }
        update_ini_files(mock_config_data, "/fake/path")
        mock_file.assert_any_call("/fake/path/GameUserSettings.ini", "w")
        mock_file.assert_any_call("/fake/path/GameAppearance.ini", "w")
        self.assertEqual(mock_config.return_value.write.call_count, 2)

    @patch("builtins.open", new_callable=mock_open)
    @patch("config_from_env_vars.main.MaintainCaseConfigParser")
    def test_update_ini_files_no_data_to_write(self, mock_config, mock_file):
        mock_config_data = {}
        update_ini_files(mock_config_data, "/fake/path")
        mock_file.assert_not_called()
        mock_config.return_value.set.assert_not_called()
        mock_config.return_value.write.assert_not_called()

    @patch("config_from_env_vars.main.os.listdir")
    @patch("config_from_env_vars.main.os.path.join")
    @patch("config_from_env_vars.main.shutil.move")
    @patch("config_from_env_vars.main.Path")
    def test_backup_existing_ini_files(
        self, mock_path, mock_move, mock_join, mock_listdir
    ):
        mock_listdir.return_value = ["config.ini"]
        mock_join.side_effect = lambda a, b: f"{a}/{b}"
        mock_path_obj = mock.Mock()
        mock_path.return_value = mock_path_obj
        mock_path_obj.exists.side_effect = [
            True,
            False,
        ]

        backup_existing_ini_files("/fake/path")

        mock_move.assert_called_once_with(
            "/fake/path/config.ini", "/fake/path/config.ini.backup1"
        )

    @patch("config_from_env_vars.main.os.listdir")
    @patch("config_from_env_vars.main.shutil.move")
    def test_backup_existing_ini_files_empty_directory(
        self, mock_move, mock_listdir
    ):
        mock_listdir.return_value = []

        backup_existing_ini_files("/fake/path")

        mock_move.never_called()

    @patch("config_from_env_vars.main.os.listdir")
    @patch("config_from_env_vars.main.shutil.move")
    def test_backup_existing_ini_files_no_ini_files(self, mock_move, mock_listdir):
        mock_listdir.return_value = ["config.txt"]

        backup_existing_ini_files("/fake/path")

        mock_move.never_called()

    @patch("config_from_env_vars.main.shutil.move")
    @patch("config_from_env_vars.main.Path")
    @patch("config_from_env_vars.main.os.listdir")
    def test_backup_existing_ini_files_increment(
        self, mock_listdir, mock_path, mock_move
    ):
        mock_listdir.return_value = ["config.ini"]
        path_instance = MagicMock()
        mock_path.return_value = path_instance

        path_instance.exists.side_effect = [True, True, False]

        backup_existing_ini_files("/fake/path")

        mock_move.assert_called_once_with(
            "/fake/path/config.ini", "/fake/path/config.ini.backup2"
        )

    @patch("config_from_env_vars.main.shutil.move")
    @patch("config_from_env_vars.main.Path")
    @patch("config_from_env_vars.main.os.listdir")
    def test_backup_existing_ini_files_multiple_ini(
        self, mock_listdir, mock_path, mock_move
    ):
        mock_listdir.return_value = ["config.ini", "settings.ini"]
        path_instance = MagicMock()
        mock_path.return_value = path_instance

        path_instance.exists.side_effect = [False, False]

        backup_existing_ini_files("/fake/path")

        mock_move.assert_any_call(
            "/fake/path/config.ini", "/fake/path/config.ini.backup"
        )

        mock_move.assert_any_call(
            "/fake/path/settings.ini", "/fake/path/settings.ini.backup"
        )

    @patch("config_from_env_vars.main.Path")
    def test_get_latest_backup_file_with_multiple_backups(self, mock_path):
        directory = "/fake/path"
        base_file_name = "config.ini"
        mock_backup_files = [
            Path(f"{directory}/{base_file_name}.backup{i}") for i in range(1, 4)
        ]
        mock_path.return_value.glob.return_value = mock_backup_files

        latest_backup = get_latest_backup_file(f"{directory}/{base_file_name}")

        self.assertEqual(latest_backup, f"{directory}/{base_file_name}.backup3")

    @patch("config_from_env_vars.main.Path")
    def test_get_latest_backup_file_with_single_backup(self, mock_path):
        directory = "/fake/path"
        base_file_name = "config.ini"
        mock_backup_files = [Path(f"{directory}/{base_file_name}.backup")]
        mock_path.return_value.glob.return_value = mock_backup_files

        latest_backup = get_latest_backup_file(f"{directory}/{base_file_name}")

        self.assertEqual(latest_backup, f"{directory}/{base_file_name}.backup")

    @patch("config_from_env_vars.main.shutil.move")
    @patch("config_from_env_vars.main.Path")
    @patch("config_from_env_vars.main.os.listdir")
    def test_backup_existing_ini_files_error(
        self, mock_listdir, mock_path, mock_move
    ):
        mock_listdir.return_value = ["config.ini"]
        mock_path_obj = MagicMock()
        mock_path.return_value = mock_path_obj
        mock_path_obj.exists.return_value = False

        mock_move.side_effect = OSError("Mocked file access error")

        with self.assertLogs(level="ERROR") as log:
            backup_existing_ini_files("/fake/path")

        self.assertIn("Mocked file access error", log.output[0])

    @patch("config_from_env_vars.main.get_latest_backup_file")
    @patch("config_from_env_vars.main.filecmp.cmp")
    @patch("config_from_env_vars.main.os.remove")
    @patch("config_from_env_vars.main.Path")
    def test_compare_and_cleanup_configs_files_same(
        self, mock_path, mock_remove, mock_cmp, mock_get_latest_backup_file
    ):
        mock_cmp.return_value = True
        mock_path().glob.return_value = ["/fake/path/config.ini"]
        mock_get_latest_backup_file.return_value = "/fake/path/config.ini.backup"

        compare_and_cleanup_configs("/fake/path")

        mock_remove.assert_called_once_with("/fake/path/config.ini.backup")

    @patch("config_from_env_vars.main.get_latest_backup_file")
    @patch("config_from_env_vars.main.filecmp.cmp")
    @patch("config_from_env_vars.main.os.remove")
    @patch("config_from_env_vars.main.Path")
    def test_compare_and_cleanup_configs_files_different(
        self, mock_path, mock_remove, mock_cmp, mock_get_latest_backup_file
    ):
        mock_cmp.return_value = False
        mock_path().glob.return_value = ["/fake/path/config.ini"]
        mock_get_latest_backup_file.return_value = "/fake/path/config.ini.backup"

        compare_and_cleanup_configs("/fake/path")

        mock_remove.not_called()

    @patch("config_from_env_vars.main.filecmp.cmp")
    @patch("config_from_env_vars.main.os.remove")
    @patch("config_from_env_vars.main.Path")
    def test_compare_and_cleanup_configs_backup_file_does_not_exist(
        self, mock_path, mock_remove, mock_cmp
    ):
        mock_path().glob.return_value = []
        compare_and_cleanup_configs("/fake/path")
        mock_cmp.assert_not_called()
        mock_remove.assert_not_called()


if __name__ == "__main__":
    unittest.main()
