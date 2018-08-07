#!/usr/bin/env python
# -*- coding: utf-8 -*-
import logging
import os
import shutil
import subprocess

external_config_dir = "/mnt/postfix-config"
config_dir = "/etc/postfix"
backup_dir = "/etc/postfix.orig"


def main():
    """Initialize Postfix configuration."""
    logging.basicConfig(level=logging.INFO)
    logger = logging.getLogger(__name__)
    if os.path.exists(backup_dir):
        shutil.rmtree(config_dir)
    else:
        shutil.move(config_dir, backup_dir)
    shutil.copytree(backup_dir, config_dir)
    shell_scripts = []
    for entry in os.listdir(external_config_dir):
        abs_entry = os.path.join(external_config_dir, entry)
        extension = os.path.splitext(entry)[1]
        if extension == ".sh":
            shell_scripts.append(abs_entry)
        else:
            logger.info("Copying %s to Postfix configuration.", entry)
            shutil.copy(abs_entry, config_dir)
            if extension == '':
                logger.info("Running 'postmap %s'.", entry)
                subprocess.call(["/usr/sbin/postmap", os.path.join(config_dir, entry)])
    for shell_script in shell_scripts:
        logger.info("Running %s.", shell_script)
        subprocess.call(["/bin/sh", shell_script])


if __name__ == "__main__":
    main()
