#!/usr/bin/env roseus

;; $ rtmlaunch hrpsys_ros_bridge_tutorials samplerobot.launch
;; $ roseus samplerobot-stabilizer.l "(demo)"

(load "package://hrpsys_ros_bridge_tutorials/euslisp/samplerobot-interface.l")

(defun init ()
  (samplerobot-init)
  )

(defun demo ()
  (init)
  (send *sr* :reset-pose)
  (send *ri* :angle-vector (send *sr* :angle-vector) 1000)
  (send *ri* :wait-interpolation)

  ;; 1. getParameter
  (pprint (send (send *ri* :get-st-param) :slots))
  (print "getParameter() => OK")
  ;; 2. setParameter
  (let ((k-tpcc-p (float-vector 0.2 0.2))
        (k-tpcc-x (float-vector 4.0 4.0))
        (k-brot-p (float-vector 0.0 0.0)))
    (send *ri* :set-st-param
          :k-tpcc-p k-tpcc-p
          :k-tpcc-x k-tpcc-x
          :k-brot-p k-brot-p)
    (if (and (eps-v= (send (send *ri* :get-st-param) :k_tpcc_p) k-tpcc-p)
             (eps-v= (send (send *ri* :get-st-param) :k_tpcc_x) k-tpcc-x)
             (eps-v= (send (send *ri* :get-st-param) :k_brot_p) k-brot-p))
        (print "setParameter() => OK")))
  ;; 3. start and stop st
  (send *ri* :start-st)
  (send *ri* :go-pos 0.5 0.1 10)
  (send *ri* :stop-st)
  (print "Start and Stop Stabilizer => OK")
  )

;;(demo)