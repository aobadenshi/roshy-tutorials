(import time [sleep])

(import rclpy)
(import rclpy.action [ActionServer])
(import rclpy.node [Node])
(import custom_action_interfaces.action [Fibonacci])

(defclass FibonacciActionServer [Node]
  (defn __init__ [self]
    (.__init__ (super) "fibonacci_action_server")
    (setv
      self.srv (ActionServer
                self
                Fibonacci
                "fibonacci"
                (fn [goal_handle]
                  (.info (self.get_logger) "Executing goal...")
                  (let [feedback_msg (Fibonacci.Feedback)
                        result (Fibonacci.Result)]
                    (setv feedback_msg.partial_sequence [0 1])
                    (for [i (range 1 goal_handle.request.order)]
                      (.append feedback_msg.partial_sequence
                               (+ (get feedback_msg.partial_sequence i)
                                  (get feedback_msg.partial_sequence (- i 1))))
                      (.info (self.get_logger) f"Feedback: {feedback_msg.partial_sequence}")
                      (goal_handle.publish_feedback feedback_msg)
                      (sleep 1.0))
                    (goal_handle.succeed)
                    (setv result.sequence feedback_msg.partial_sequence)
                    result))))))

(defn main [[args None]]
  (rclpy.init :args args)
  (let [node (FibonacciActionServer)]
    (try
      (rclpy.spin node)
      (except [KeyboardInterrupt]
              (print "kbd interrputed"))
      (finally
        (node.destroy_node)
        (rclpy.try_shutdown)))))
