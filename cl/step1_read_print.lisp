;; step1_read_print.lisp

(load "reader.lisp")
(load "printer.lisp")

(defun mal-read (x)
  (read-str x))

(defun mal-eval (x) x)

(defun mal-print (x)
  (pr-str x))

(defun mal-rep (x)
  (mal-print (mal-eval (mal-read x))))

(defun main ()
  (format t "mal-user> ")
  (finish-output nil)
  (let ((line (read-line *standard-input* nil nil)))
    (when line
      (handler-case (format t "~A~%" (mal-rep line))
        (error (e)
          (format t "~A~%" e)))
      (main))))

(main)
