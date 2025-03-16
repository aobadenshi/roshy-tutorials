(import rclpy)
(import rclpy.node [Node])
(import example_interfaces.srv [AddTwoInts])

(defclass MinimalService [Node]
  (defn __init__ [self]
    (.__init__ (super) "minimal_service")
    (setv
      self.srv (self.create_service
                AddTwoInts
                "add_two_ints"
                (fn [request response]
                  (setv response.sum (+ request.a request.b))
                  (.info (self.get_logger) f"Incoming request: a={request.a}, b={request.b}")
                  response)))))

(defn main [[args None]]
  (rclpy.init :args args)
  (let [node (MinimalService)]
    (try
      (rclpy.spin node)
      (except [KeyboardInterrupt]
              (print "kbd interrputed"))
      (finally
        (node.destroy_node)
        (rclpy.try_shutdown)))))
