#! /usr/bin/env python3

import os
import shutil
import subprocess

# Flush stdout on every message so that ordering of our output and subprocess
# output is preserved
def msg(message):
    print(message, flush=True)

REPO_LIST = [
    'bitbake',
    'openembedded-core',
    'meta-arago',
    'meta-browser',
    'meta-linaro',
    'meta-mender',
    'meta-openembedded',
    'meta-qt5',
    'meta-rtlwifi',
    'meta-rust',
    'meta-sancloud',
    'meta-ti',
    ]
PATCHES_ROOT = os.path.dirname(os.path.realpath(__file__))
SRC_ROOT = 'sources'

for repo in REPO_LIST:
    patchdir_path = os.path.join(PATCHES_ROOT, repo)
    repo_path = os.path.join(SRC_ROOT, repo)

    if os.path.exists(patchdir_path):
        msg(f'Patching {repo}')

        # Check for a failed patch application
        cmd = ['git', '-C', repo_path, 'rev-parse', '--git-dir']
        proc = subprocess.run(cmd, check=True, stdout=subprocess.PIPE)
        gitdir = proc.stdout.decode('utf-8').strip()
        rebase_path = os.path.join(gitdir, 'rebase-apply')
        if os.path.exists(rebase_path):
            msg('    Aborting previous patch application')
            shutil.rmtree(rebase_path)

        # Apply patches
        patch_list = os.listdir(patchdir_path)
        patch_list.sort()

        for patch in patch_list:
            msg(f'    Applying {patch}')
            patch_path = os.path.join(patchdir_path, patch)
            cmd = ['git', '-C', repo_path, 'am', '-q', patch_path]
            subprocess.run(cmd, check=True)
