(import rclpy)
(import rclpy.node [Node])
(import std_msgs.msg [String])

(defclass MinimalSubscriber [Node]
  (defn __init__ [self]
    (.__init__ (super) "minimal_subscriber")
    (setv
      self.subscription_ (self.create_subscription
                          String
                          "topic"
                          (fn [msg]
                            (.info (self.get_logger) f"I heard: {msg.data}"))
                          10))))

(defn main [[args None]]
  (rclpy.init :args args)
  (let [node (MinimalSubscriber)]
    (try
      (rclpy.spin node)
      (except [KeyboardInterrupt]
        (print "kbd interrputed"))
      (finally
        (node.destroy_node)
        (rclpy.try_shutdown)))))

