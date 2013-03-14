import sys
from distutils.core import setup
from distutils.extension import Extension

ext_modules=[
    Extension('dogfood',
        ["dogfood.c"]
        )
    ]

jsonlib = "jsonlib"
if sys.version[0] == '3':
    jsonlib = "jsonlib-python3 (>=1.6)"

requirements=[
    jsonlib,
]

setup(
    name="dogfood",
    description="Serialize custom classes with JSON",
    version="0.0.2",
    ext_modules = ext_modules,
    author="Derek Arnold",
    author_email="derek@brainindustries.com",
    url="http://github.com/lysol/dogfood",
    license='BSD',
    classifiers=[
        "Development Status :: 3 - Alpha",
        "Intended Audience :: Developers",
        "License :: OSI Approved :: BSD License",
        "Operating System :: MacOS :: MacOS X",
        "Operating System :: Unix",
    ],
    download_url="https://github.com/lysol/dogfood/tarball/master",
    requires=requirements,
    install_requires=requirements,
    )
