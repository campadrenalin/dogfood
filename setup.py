from distutils.core import setup
from distutils.extension import Extension
try:
    from Cython.Distutils import build_ext
except:
    # Buys us that first round we need to state a cython dependency
    build_ext = None

ext_modules=[
    Extension('dogfood',
        ["dogfood.pyx"]
        )
    ]

requirements=[
    'jsonlib',
    'Cython'
]

setup(
    name="dogfood",
    description="Serialize custom classes with JSON",
    version="0.0.2",
    cmdclass = {"build_ext": build_ext},
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
