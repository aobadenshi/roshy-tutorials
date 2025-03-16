from launch import LaunchDescription
from launch.actions import EmitEvent, RegisterEventHandler, LogInfo
from launch.events import matches_action, Shutdown
from launch_ros.actions import Node, LifecycleNode
from launch_ros.events.lifecycle import ChangeState
from launch_ros.event_handlers import OnStateTransition
from lifecycle_msgs.msg import Transition

import os
import socket
from ament_index_python.packages import get_package_share_directory

NS = 'roshy'

def generate_launch_description():
    ld = LaunchDescription()

    config = os.path.join(os.getcwd(), 'config', 'params.yaml')

    srv_node = Node(
        package='srvcli',
        executable='srv',
        name='server',
        namespace=NS,
        parameters=[config],
    )

    cli_node = Node(
        package='srvcli',
        executable='cli',
        name='client',
        namespace=NS,
        parameters=[config],
    )

    ld.add_action(srv_node)
    ld.add_action(cli_node)
    return ld
