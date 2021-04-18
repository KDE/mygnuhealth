#!/usr/bin/env python3
# This file if part of the MyGNUHealth, the GNU Health PHR
# www.gnuhealth.org

from setuptools import setup, find_packages

long_desc = open('README.rst').read()

# Initialize about
about = {}
with open("mygnuhealth/about.py") as fp:
    exec(fp.read(), about)

setup(
    name=about['__appname__'],
    version=about['__version__'],
    description=about['__description__'],
    url=about['__homepage__'],
    license=about['__license__'],
    author=about['__author__'],
    author_email=about['__email__'],
    download_url=about['__download_url__'],
    long_description=long_desc,
    keywords='eHealth PHIMS PHR mHealth GNUHealth',
    classifiers=[
        'Development Status :: 4 - Beta',
        'Environment :: X11 Applications :: KDE',
        'Environment :: X11 Applications :: Qt',
        'Topic :: Desktop Environment :: K Desktop Environment (KDE)',
        'Intended Audience :: Developers',
        'Intended Audience :: End Users/Desktop',
        'Intended Audience :: Healthcare Industry',
        'Intended Audience :: Science/Research',
        'License :: OSI Approved :: GNU General Public License (GPL)',
        'Operating System :: POSIX',
        'Programming Language :: Python :: 3',
        'Topic :: Scientific/Engineering :: Bio-Informatics',
        'Topic :: Scientific/Engineering :: Medical Science Apps.',
        'Natural Language :: English'
        ],
    platforms='any',
    scripts=['bin/mygnuhealth'],
    python_requires='>=3.6,<4',
    install_requires=[
        'matplotlib',
        'requests',
        'tinydb',
        'bcrypt'
        ],
    packages=find_packages(),
    include_package_data=True,
    zip_safe=False,
    data_files=[
        ('share/applications', ['org.kde.mygnuhealth.desktop']),
        ('share/metainfo', ['org.kde.mygnuhealth.metainfo.xml']),
        ('share/icons/hicolor/scalable/apps/',
         ['mygnuhealth/images/mygnuhealth.svg']),
        ]
      )
