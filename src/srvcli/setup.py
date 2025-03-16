from setuptools import find_packages, setup

package_name = 'srvcli'

setup(
    name=package_name,
    version='0.0.0',
    packages=find_packages(exclude=['test']),
    data_files=[
        ('share/ament_index/resource_index/packages',
            ['resource/' + package_name]),
        ('share/' + package_name, ['package.xml']),
    ],
    install_requires=['setuptools'],
    zip_safe=True,
    maintainer='sgr',
    maintainer_email='shigeru.fujiwara@aoba-denshi.com',
    description='A simple service and client (Hy)',
    license='Apache-2.0',
    tests_require=['pytest'],
    entry_points={
        'console_scripts': [
            'srv = srvcli.srv:main',
            'cli = srvcli.cli:main',
        ],
    },
)
