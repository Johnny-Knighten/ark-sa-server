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

    def test_process_env_vars_simple(self):
        with patch.dict(
            "os.environ",
            {
                "CONFIG_GameUserSettings_ServerSettings_DifficultyOffset": "0.25",
            },
        ):
            result = process_env_vars()
            self.assertIn("GameUserSettings", result)
            self.assertIn("ServerSettings", result["GameUserSettings"])
            self.assertEqual(
                result["GameUserSettings"]["ServerSettings"]["DifficultyOffset"], "0.25"
            )

    def test_process_env_vars_with_two_files(self):
        with patch.dict(
            "os.environ",
            {
                "CONFIG_GameUserSettings_ServerSettings_DifficultyOffset": "0.25",
                "CONFIG_AppearanceSettings_ServerSettings_DifficultyOffset": "0.75",
            },
        ):
            result = process_env_vars()
            self.assertIn("GameUserSettings", result)
            self.assertIn("ServerSettings", result["GameUserSettings"])
            self.assertEqual(
                result["GameUserSettings"]["ServerSettings"]["DifficultyOffset"],
                "0.25",
            )
            self.assertIn("AppearanceSettings", result)
            self.assertIn("ServerSettings", result["AppearanceSettings"])
            self.assertEqual(
                result["AppearanceSettings"]["ServerSettings"]["DifficultyOffset"],
                "0.75",
            )

    def test_process_env_vars_with_two_sections(self):
        with patch.dict(
            "os.environ",
            {
                "CONFIG_GameUserSettings_ServerSettings_DifficultyOffset": "0.25",
                "CONFIG_GameUserSettings_PlayerSettings_DifficultyOffset": "0.75",
            },
        ):
            result = process_env_vars()
            self.assertIn("GameUserSettings", result)
            self.assertIn("ServerSettings", result["GameUserSettings"])
            self.assertIn("PlayerSettings", result["GameUserSettings"])
            self.assertEqual(
                result["GameUserSettings"]["ServerSettings"]["DifficultyOffset"],
                "0.25",
            )
            self.assertEqual(
                result["GameUserSettings"]["PlayerSettings"]["DifficultyOffset"],
                "0.75",
            )

    def test_process_env_vars_with_two_vars(self):
        with patch.dict(
            "os.environ",
            {
                "CONFIG_GameUserSettings_ServerSettings_DifficultyOffset": "0.25",
                "CONFIG_GameUserSettings_ServerSettings_XPOffset": "0.75",
            },
        ):
            result = process_env_vars()
            self.assertIn("GameUserSettings", result)
            self.assertIn("ServerSettings", result["GameUserSettings"])
            self.assertEqual(
                result["GameUserSettings"]["ServerSettings"]["DifficultyOffset"],
                "0.25",
            )
            self.assertEqual(
                result["GameUserSettings"]["ServerSettings"]["XPOffset"],
                "0.75",
            )

    def test_process_env_vars_with_dot_in_section(self):
        with patch.dict(
            "os.environ",
            {
                "CONFIG_GameUserSettings_Server_DOT_Settings_DifficultyOffset": "0.25",
            },
        ):
            result = process_env_vars()
            self.assertIn("GameUserSettings", result)
            self.assertIn("Server.Settings", result["GameUserSettings"])
            self.assertEqual(
                result["GameUserSettings"]["Server.Settings"]["DifficultyOffset"],
                "0.25",
            )

    def test_process_env_vars_with_slash_in_section(self):
        with patch.dict(
            "os.environ",
            {
                "CONFIG_GameUserSettings_Server_SLASH_Settings_DifficultyOffset": "0.25",
            },
        ):
            result = process_env_vars()
            self.assertIn("GameUserSettings", result)
            self.assertIn("Server/Settings", result["GameUserSettings"])
            self.assertEqual(
                result["GameUserSettings"]["Server/Settings"]["DifficultyOffset"],
                "0.25",
            )

    def test_process_env_vars_with_missing_variable_template_section(self):
        with patch.dict(
            "os.environ",
            {
                "CONFIG_GameUserSettings_DifficultyOffset": "0.25",
            },
        ):
            result = process_env_vars()
            self.assertEqual(result, {})

    def test_update_ini_files_single_file(self):
        mock_config_data = {
            "GameUserSettings": {
                "ServerSettings": {
                    "DifficultyOffset": "0.25",
                }
            }
        }

        m = mock_open()
        with patch("builtins.open", m), patch(
            "config_from_env_vars.main.ConfigParser"
        ) as mock_config:
            update_ini_files(mock_config_data, "/fake/path")

            m.assert_called_once_with("/fake/path/GameUserSettings.ini", "w")

            mock_config.return_value.set.add_section("ServerSettings")
            mock_config.return_value.set.assert_any_call(
                "ServerSettings", "DifficultyOffset", "0.25"
            )
            mock_config.return_value.write.assert_called_once()

    def test_update_ini_files_multiple_file(self):
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

        m = mock_open()
        with patch("builtins.open", m), patch(
            "config_from_env_vars.main.ConfigParser"
        ) as mock_config:
            update_ini_files(mock_config_data, "/fake/path")

            m.assert_any_call("/fake/path/GameUserSettings.ini", "w")
            m.assert_any_call("/fake/path/GameAppearance.ini", "w")

            mock_config.return_value.set.assert_any_call(
                "ServerSettings", "DifficultyOffset", "0.25"
            )
            mock_config.return_value.set.assert_any_call(
                "Logo", "Path", "/path/to/logo.png"
            )

            self.assertEqual(mock_config.return_value.write.call_count, 2)

    def test_update_ini_files_no_data_to_write(self):
        mock_config_data = {}

        m = mock_open()
        with patch("builtins.open", m), patch(
            "config_from_env_vars.main.ConfigParser"
        ) as mock_config:
            update_ini_files(mock_config_data, "/fake/path")

            m.assert_not_called()

            mock_config.return_value.set.not_called()
            mock_config.return_value.write.not_called()


if __name__ == "__main__":
    unittest.main()
