;; step0_repl.lisp

(defun mal-read (x) x)

(defun mal-eval (x) x)

(defun mal-print (x) x)

(defun mal-rep (x)
  (mal-print (mal-eval (mal-read x))))

(defun main ()
  (loop for line = (read-line *standard-input* nil nil)
        while line
        do (format t "~A~%" (mal-rep line))))

(main)
