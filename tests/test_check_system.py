"""Pruebas del diagnóstico sin instalar paquetes ni acceder a Internet."""
import os
from pathlib import Path
import subprocess
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]
SCRIPT = ROOT / 'check_system.sh'


class DiagnosticTests(unittest.TestCase):
    def run_check(self, tools=(), args=(), responses=None):
        with tempfile.TemporaryDirectory() as directory:
            folder = Path(directory)
            scripts = {'uname': 'printf "x86_64\\n"', **(responses or {})}
            for name in tools:
                scripts.setdefault(name, 'exit 0')
            for name, body in scripts.items():
                file = folder / name
                file.write_text('#!/bin/bash\n' + body + '\n')
                file.chmod(0o755)
            return subprocess.run(
                ['/bin/bash', str(SCRIPT), *args],
                env={**os.environ, 'PATH': directory},
                text=True, capture_output=True, check=False,
            )

    def test_missing_clone_tools(self):
        result = self.run_check(args=['--bootstrap'])
        self.assertEqual(result.returncode, 1)
        self.assertIn('[FALTA] git:', result.stdout)
        self.assertIn('[FALTA] curl:', result.stdout)
        self.assertIn('sudo apt install', result.stdout)

    def test_ready_to_clone(self):
        result = self.run_check(['git', 'curl', 'sudo', 'apt-get'], ['--bootstrap'])
        self.assertEqual(result.returncode, 0, result.stdout)
        self.assertNotIn('sudo apt install', result.stdout)

    def test_optional_neovim_does_not_block(self):
        tools = ['git', 'curl', 'sudo', 'apt-get', 'tar', 'gzip', 'unzip',
                 'cc', 'make', 'rg', 'fzf', 'python3', 'node', 'npm']
        result = self.run_check(tools)
        self.assertEqual(result.returncode, 0, result.stdout)
        self.assertIn('Neovim no está instalado', result.stdout)

    def test_package_list_is_deduplicated(self):
        result = self.run_check()
        command = next(line for line in result.stdout.splitlines()
                       if line.startswith('sudo apt install'))
        self.assertEqual(command.split().count('build-essential'), 1)

    def test_missing_python_modules(self):
        result = self.run_check(['python3'], responses={'python3': 'exit 1'})
        self.assertEqual(result.returncode, 1)
        self.assertIn('python3-pip', result.stdout)
        self.assertIn('python3-venv', result.stdout)

    def test_unsupported_architecture(self):
        result = self.run_check(['git', 'curl', 'sudo', 'apt-get'], ['--bootstrap'],
                                {'uname': 'printf "riscv64\\n"'})
        self.assertEqual(result.returncode, 1)
        self.assertIn('Arquitectura no admitida', result.stdout)

    def test_bad_argument(self):
        self.assertEqual(self.run_check(args=['--install']).returncode, 2)


if __name__ == '__main__':
    unittest.main()
