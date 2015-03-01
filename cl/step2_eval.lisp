;; step2_eval.lisp

(load "reader.lisp")
(load "printer.lisp")

(defparameter repl-env
  '((+ +)
    (- -)
    (* *)
    (/ /)))

(defun mal-read (x)
  (read-str x))

(defun mal-eval (ast)
  (if (listp ast)
      (let ((tmp (eval-ast ast repl-env)))
        (apply (cadr (assoc (first tmp) repl-env)) (rest tmp)))
      (eval-ast ast repl-env)))

(defun mal-print (x)
  (pr-str x))

(defun mal-rep (x)
  (mal-print (mal-eval (mal-read x))))

(defun eval-ast (ast env)
  (cond
    ((symbolp ast)
     (cadr (or (assoc ast env)
               (error (format nil "symbol ~S not found~%" ast)))))
    ((listp ast)
     (mapcar #'mal-eval ast))
    (t
     ast)))

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
