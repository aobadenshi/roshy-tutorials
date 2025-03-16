(import rclpy)
(import rclpy.action [ActionClient])
(import rclpy.node [Node])
(import custom_action_interfaces.action [Fibonacci])

(defclass FibonacciActionClient [Node]
  (defn __init__ [self]
    (.__init__ (super) "fibonacci_action_client")
    (setv
      self.cli (ActionClient self Fibonacci "fibonacci")))
  (defn send_goal [self order]
    (let [goal_msg (Fibonacci.Goal)]
      (setv goal_msg.order order)
      (self.cli.wait_for_server)
      (let [goal_ftr (self.cli.send_goal_async
                      goal_msg
                      (fn [feedback_msg]
                        (.info (self.get_logger) f"Received feedback: {feedback_msg.feedback.partial_sequence}")))]
        (goal_ftr.add_done_callback
         (fn [ftr]
           (let [goal_handle (ftr.result)]
             (if goal_handle.accepted
               (do
                 (.info (self.get_logger) "Goal accepted :)")
                 (let [result_ftr (goal_handle.get_result_async)]
                   (result_ftr.add_done_callback
                    (fn [ftr]
                      (let [result (. (ftr.result) result)]
                        (.info (self.get_logger) f"Result: {result.sequence}"))))))
               (.info (self.get_logger) "Goal rejected :(")))))))))

(defn main [[args None]]
  (rclpy.init :args args)
  (let [node (FibonacciActionClient)]
    (try
      (node.send_goal 10)
      (rclpy.spin node)
      (except [KeyboardInterrupt]
              (print "kbd interrputed"))
      (finally
        (node.destroy_node)
        (rclpy.try_shutdown)))))
