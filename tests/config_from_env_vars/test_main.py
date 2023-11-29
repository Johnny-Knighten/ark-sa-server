# test_main.py

import logging
import unittest
from unittest.mock import patch, mock_open
from config_from_env_vars.main import process_env_vars, update_ini_files

logging.disable(logging.CRITICAL)


class TestConfigFromEnvVars(unittest.TestCase):
    def setUp(self):
        self.env_patcher = patch.dict("os.environ", clear=True)
        self.env_patcher.start()

    def tearDown(self):
        self.env_patcher.stop()

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


if __name__ == "__main__":
    unittest.main()
