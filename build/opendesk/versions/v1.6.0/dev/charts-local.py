#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2024 Zentrum für Digitale Souveränität der Öffentlichen Verwaltung (ZenDiS) GmbH
# SPDX-License-Identifier: Apache-2.0

import os.path
import logging
import yaml
import sys
import shutil
import subprocess
import configargparse

from pathlib import Path
from git import Repo

p = configargparse.ArgParser()
p.add('--branch', env_var='CHART_DEV_BRANCH', help='The branch you want to work with. Will be created by the script if it does not exist yet.')
p.add('--git_hostname', env_var='GIT_HOSTNAME', default='git@gitlab.opencode.de', help='Set the hostname for the chart git checkouts.')
p.add('--revert', default=False, action='store_true', help='Set this parameter if you want to revert the referencing of the local helm chart checkout paths in the helmfiles.')
p.add('--match', default='', help="Clone/pull only charts that contain the given string in their name.")
p.add('--loglevel', env_var='LOGLEVEL', default='DEBUG', help='Set the loglevel: DEBUG, INFO, WARNING, ERROR, CRITICAL-')
options = p.parse_args()

script_path = os.path.dirname(os.path.realpath(__file__))
# some static definitions
log_path = script_path+'/../logs'
charts_yaml = script_path+'/../helmfile/environments/default/charts.yaml.gotmpl'
base_repo_path = script_path+'/..'
base_helmfile = base_repo_path+'/helmfile_generic.yaml.gotmpl'
helmfile_backup_extension = '.bak'

Path(log_path).mkdir(parents=True, exist_ok=True)

logFormatter = logging.Formatter("%(asctime)s %(levelname)-5.5s %(message)s")
rootLogger = logging.getLogger()
rootLogger.setLevel(options.loglevel)

fileHandler = logging.FileHandler("{0}/{1}.log".format(log_path, os.path.basename(__file__)))
fileHandler.setFormatter(logFormatter)
rootLogger.addHandler(fileHandler)

consoleHandler = logging.StreamHandler()
consoleHandler.setFormatter(logFormatter)
rootLogger.addHandler(consoleHandler)

logging.debug(f"Working with relative paths from script location: {script_path}")
logging.debug(f"Log directory:      {log_path}")
logging.debug(f"charts.yaml.gotmpl: {charts_yaml}")


def create_or_switch_branch_base_repo():
    base_repo = Repo(path=base_repo_path)
    current_branch = base_repo.active_branch.name
    if not options.branch:
        branch = current_branch
        logging.debug(f"No branch specified on commandline, working with current branch: {current_branch}")
    else:
        branch = options.branch
        if branch in base_repo.branches:
            if branch != current_branch:
                logging.debug(f"Selected {branch} already exists, switching.")
                # ToDo: Graceful handle: "Please commit your changes or stash them before you switch branches."
                base_repo.git.switch(branch)
            else:
                logging.debug(f"Already on selected brach {branch}")
        else:
            logging.debug(f"Creating branch {branch} and switching")
            base_repo.git.branch(branch)
            base_repo.git.switch(branch)
    return branch

def create_path_if_not_exists(path):
    if os.path.isdir(path):
        logging.warning(f"Path {path} already exists.")
    else:
        logging.debug(f"creating directory {path}.")
        Path(path).mkdir(parents=True, exist_ok=True)

def clone_charts_locally(branch, charts):
    charts_path = script_path+'/../../charts-'+branch.replace('/', '_')
    charts_dict = {}
    doublette_dict = {}
    create_path_if_not_exists(charts_path)

    for chart in charts['charts']:
        tag = charts['charts'][chart]['version']
        repository = charts['charts'][chart]['repository']
        registry = charts['charts'][chart]['registry']
        name = charts['charts'][chart]['name']
        logging.debug(f"Working on {chart} / tag {tag} / repo {repository}")
        chart_local_path = charts_path+'/'+name
        if not options.match in name:
            logging.info(f"Chart name {name} does not match {options.match} - skipping...")
            continue
        elif registry == '':
            logging.info("Empty registry definition - skipping...")
            continue
        if os.path.isdir(chart_local_path):
            logging.debug(f"Found pre-existing {chart_local_path} skipping clone/pull, but will still reference chart in Helmfile...")
            charts_dict[chart] = chart_local_path
            git_url = options.git_hostname+':'+repository
            doublette_dict[git_url] = chart_local_path
            continue
        elif 'opendesk/components/platform-development/charts' in repository:
            logging.info("Cloning the charts repo")
            git_url = options.git_hostname+':'+repository
            if git_url in doublette_dict:
                logging.debug(f"{chart} located at {git_url} is already checked out to {doublette_dict[git_url]}")
                charts_dict[chart] = doublette_dict[git_url]
            else:
                logging.debug(f"Cloning into {chart_local_path}")
                Repo.clone_from(git_url, chart_local_path)
                chart_repo = Repo(path=chart_local_path)
                chart_repo.git.checkout('v'+charts['charts'][chart]['version'])
                doublette_dict[git_url] = chart_local_path
                charts_dict[chart] = chart_local_path
        else:
            logging.info("Pulling the chart")
            helm_command = f"helm pull oci://{registry}/{repository}/{name} --version {tag} --untar --destination {charts_path}"
            logging.debug(f"CLI command: {helm_command}")
            try:
                subprocess.check_output(helm_command, shell = True)
            except subprocess.CalledProcessError:
                sys.exit(f"! CLI command '{helm_command}' failed")
            charts_dict[chart] = chart_local_path
    return charts_dict

def grep_yaml(file):
    with open(file, 'r') as file:
        content = ''
        for line in file.readlines():
            if not ': {{' in line and not '- {{' in line:
                content += line
    return yaml.safe_load(content)


def get_child_helmfiles():
    child_helmfiles = []
    root_helmfile = grep_yaml(base_helmfile)
    for entry in root_helmfile['helmfiles']:
        child_helmfiles.append(base_repo_path+'/'+entry['path'])
    return child_helmfiles


def process_the_helmfiles(charts_dict, charts):
    chart_def_prefix = '    chart: "'
    child_helmfiles = get_child_helmfiles()
    for child_helmfile in child_helmfiles:
        child_helmfile_updated = False
        output = []
        with open(child_helmfile, 'r') as file:
            for line in file:
                if chart_def_prefix in line:
                    for chart_ident in charts_dict:
                        if '.Values.charts.'+chart_ident+'.name' in line:
                            logging.debug(f"found match with {chart_ident} in {line.strip()}")
                            line = charts_dict[chart_ident]
                            if os.path.isdir(line+'/charts/'+charts['charts'][chart_ident]['name']):
                                line += '/charts/'+charts['charts'][chart_ident]['name']
                            elif not os.path.isdir(line):
                                sys.exit(f"! Did not find directory to reference in Helmfile: '{line}'")
                            line = chart_def_prefix+line+'" # replaced by local-dev script'+"\n"
                            child_helmfile_updated = True
                            break
                output.append(line)
        if child_helmfile_updated:
            child_helmfile_backup = child_helmfile+helmfile_backup_extension
            if os.path.isfile(child_helmfile_backup):
                logging.debug("backup {child_helmfile_backup} already exists, will not create a new one.")
            else:
                logging.debug(f"creating backup {child_helmfile_backup}.")
                shutil.copy2(child_helmfile, child_helmfile_backup)
            logging.debug(f"Updating {child_helmfile}")
            with open(child_helmfile, 'w') as file:
                file.writelines(output)


def revert_the_helmfiles():
    child_helmfiles = get_child_helmfiles()
    for child_helmfile in child_helmfiles:
        child_helmfile_backup = child_helmfile+helmfile_backup_extension
        if os.path.isfile(child_helmfile_backup):
            logging.debug(f"Reverting {child_helmfile} from backup {child_helmfile_backup}")
            os.rename(child_helmfile_backup, child_helmfile)
        else:
            logging.debug(f"Did not found the backup file {child_helmfile_backup}")

##
## Main program
##
if options.revert:
    revert_the_helmfiles()
else:
    branch = create_or_switch_branch_base_repo()
    with open(charts_yaml, 'r') as file:
        charts = yaml.safe_load(file)
    charts_dict = clone_charts_locally(branch, charts)
    process_the_helmfiles(charts_dict, charts)
