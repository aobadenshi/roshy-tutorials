(import random [randint])
(import sys)
(import time [sleep])

(import rclpy)
(import rclpy.node [Node])
(import example_interfaces.srv [AddTwoInts])

(defclass MinimalClientAsync [Node]
  (defn __init__ [self]
    (.__init__ (super) "minimal_client_async")
    (setv
      self.cli (self.create_client AddTwoInts "add_two_ints")
      self.req (AddTwoInts.Request))
    (while (not (self.cli.wait_for_service :timeout_sec 1.0))
      (.info (self.get_logger) "service not available, waiting again...")))
  (defn send_request [self a b]
    (setv
      self.req.a a
      self.req.b b)
    (self.cli.call_async self.req)))

(defn main [[args None]]
  (rclpy.init :args args)
  (let [node (MinimalClientAsync)]
    (try
      (while True
        (let [a (randint 1 10000)
              b (randint 1 10000)
              future (node.send_request a b)
              res (do
                    (rclpy.spin_until_future_complete node future)
                    (future.result))]
          (.info (node.get_logger) f"Result of add_two_ints: for {a} + {b} = {res.sum}")
          (sleep 1.0)))
      (except [KeyboardInterrupt]
              (print "kbd interrputed"))
      (finally
        (node.destroy_node)
        (rclpy.try_shutdown)))))
