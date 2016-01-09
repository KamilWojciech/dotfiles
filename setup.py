#!/usr/bin/env python
# -*- coding: utf-8 -*-

import re


class GitConfigParser:
    def __init__(self, filename):
        self._fp = open(filename, 'r+w')
        self._items = {}
        self._sections = []

        self._parse()

    def _parse(self):
        current_section = ''
        for line in self._fp.readlines():
            line = line.strip('\n')
            section_matches = re.search('^\[([^\]]+)]$', line)
            item_matches = re.search('^\s*([^\s]+)\s*=\s*(.*)$', line)

            if section_matches:
                section_name = section_matches.group(1)
                current_section = section_name
                self._items[section_name] = {}
                self._sections.append(section_name)
            elif item_matches:
                if current_section == '':
                    raise Exception('You have to set section first!')
                key = item_matches.group(1)
                value = item_matches.group(2)
                self._items[current_section][key] = value
            else:
                if not re.search('^\s*#', line):
                    raise Exception('Cannot parse file!')

    def _to_string(self):
        string = ''
        for section in self._sections:
            string += '[' + section + ']\n'
            for item in self._items[section]:
                string += '    ' + item + ' = ' + self._items[section][item] + '\n'

        return string

    def sections(self):
        return self._sections

    def dist_sections(self):
        sections = {}
        for section in self._sections:
            matches = re.search('^dist:(.*)', section)
            if matches:
                sections[section] = matches.group(1)

        return sections

    def exists(self, section, key):
        if section not in self._items or key not in self._items[section]:
            return False

        return True

    def get(self, section, key):
        if section not in self._items:
            raise Exception('Section \'' + section + '\' does not exist!')
        elif key not in self._items[section]:
            raise Exception('Item \'' + key + '\' under section \'' + section + '\' does not exist!')
        else:
            return self._items[section][key]

    def set(self, section, key, value):
        if section not in self._items:
            self.add_section(section)

        self._items[section][key] = value

        return self

    def items(self, section):
        if section not in self._items:
            raise Exception('Section \'' + section + '\' does not exist!')

        return self._items[section]

    def add_section(self, section):
        if section in self._items:
            raise Exception('Section \'' + section + '\' already exist!')

        self._items[section] = {}
        self._sections.append(section)

        return self

    def remove_section(self, section):
        if section not in self._items:
            raise Exception('Section \'' + section + '\' does not exist!')

        self._items.pop(section)
        self._sections.remove(section)

        return self

    def remove_item(self, section, key):
        if section not in self._items:
            raise Exception('Section \'' + section + '\' does not exist!')
        elif key not in self._items[section]:
            raise Exception('Item \'' + key + '\' under section \'' + section + '\' does not exist!')
        self._items.pop(section)

        return self

    def save(self, filename=None):
        fp = self._fp
        if filename is not None:
            fp = open(filename, 'w+')

        string = self._to_string()

        fp.seek(0)
        fp.truncate()

        fp.write(string)
        fp.close()


class Output:

    def __init__(self):
        pass

    PINK = '\033[95m'
    BLUE = '\033[94m'
    GREEN = '\033[0;32m'
    LIGHT_GREEN = '\033[92m'
    YELLOW = '\033[93m'
    RED = '\033[0;31m'
    LIGHT_RED = '\033[91m'
    CYAN = '\033[36m'
    WHITE = '\033[1m'
    ENDC = '\033[0m'
    UNDERLINE = '\033[4m'
    BG_BLACK = '\033[40m'
    BG_RED = '\033[41m'
    BG_GREEN = '\033[42m'
    BG_YELLOW = '\033[43m'
    BG_BLUE = '\033[44m'
    BG_PURPLE = '\033[45m'
    BG_CYAN = '\033[46m'
    BG_WHITE = '\033[47m'

    @staticmethod
    def write(message, color=None):
        output = ''
        if color is not None:
            output += color

        output += message + Output.ENDC

        print output

    @staticmethod
    def bg(message, bg_color, text_color=None):
        output = bg_color + message
        Output.write(output, text_color)

    @staticmethod
    def header(message):
        message = ' ' + message + ' '
        Output.bg(message, Output.BG_BLUE, Output.WHITE)

    @staticmethod
    def error(message):
        message = Output.RED + '✗ ' + Output.LIGHT_RED + message
        Output.write(message)

    @staticmethod
    def success(message):
        message = Output.GREEN + '✓ ' + Output.LIGHT_GREEN + message
        Output.write(message)

    @staticmethod
    def warning(message):
        Output.write(message, Output.YELLOW)


def setup():
    print "Setup dotfiles"
    print "It is not implemented yet!\n"


def git_config():
    Output.header("Setting up git configuration")
    config_file = 'git/config'
    try:
        config = GitConfigParser(config_file)
    except IOError:
        Output.error('File ' + config_file + 'does not exist! Skipped!')
        return
    dist_sections = config.dist_sections()
    for dist in dist_sections:
        section_name = dist_sections[dist]
        for item in config.items(dist):
            if not config.exists(section_name, item):
                value = raw_input('  Enter ' + section_name + '.' + item + ': ')
                config.set(section_name, item, value)

        config.remove_section(dist)

    config.save('git/.config')
    Output.success('Git configuration succeed!')


setup()
git_config()
