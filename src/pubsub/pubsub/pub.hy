(import rclpy)
(import rclpy.node [Node])
(import std_msgs.msg [String])

(defclass MinimalPublisher [Node]
  (defn __init__ [self]
    (.__init__ (super) "minimal_publisher")
    (setv
      self.cnt_ 0
      self.publisher_ (self.create_publisher String "topic" 10)
      self.timer_ (self.create_timer
                   0.5
                   (fn []
                     (let [msg (String)]
                       (setv msg.data f"Hello World: {self.cnt_}")
                       (self.publisher_.publish msg)
                       (.info (self.get_logger) f"Publishing: {msg.data}")
                       (setv self.cnt_ (+ self.cnt_ 1))))))))

(defn main [[args None]]
  (rclpy.init :args args)
  (let [node (MinimalPublisher)]
    (try
      (rclpy.spin node)
      (except [KeyboardInterrupt]
        (print "kbd interrputed"))
      (finally
        (node.destroy_node)
        (rclpy.try_shutdown)))))
