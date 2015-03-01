(require "asdf")
(asdf:load-system "cl-ppcre")

(defun tokenizer (str)
  (let (result)
    (cl-ppcre:do-register-groups (token)
        ("[\\s,]*(~@|[\\[\\]{}()'`~^@]|\"(?:\\\\.|[^\\\\\"])*\"|;.*|[^\\s\\[\\]{}('\"`,;)]*)"
         str)
      (push token result))
    (remove-if (lambda (token)
                 (or (string-equal token "")
                     (string-equal (subseq token 0 1) ";")))
               (nreverse result))))

(defun read-form (tokens)
  (cond
    ((null tokens)
     nil)
    ((string-equal (first tokens) "(")
     (read-list (rest tokens)))
    ((string-equal (first tokens) "'")
     (list 'quote (read-form (rest tokens))))
    ((string-equal (first tokens) "`")
     (list 'quasiquote (read-form (rest tokens))))
    ((string-equal (first tokens) "~")
     (list 'unquote (read-form (rest tokens))))
    ((string-equal (first tokens) "~@")
     (list 'splice-unquote (read-form (rest tokens))))
    ((string-equal (first tokens) "@")
     (list 'deref (read-form (rest tokens))))
    (t (values (read-atom (first tokens))
               (rest tokens)))))

(defun read-list (tokens &optional (acc nil))
  (cond
    ((null tokens)
     (error "expected ')' got EOF"))
    ((string-equal (first tokens) ")")
     (values (nreverse acc) (rest tokens)))
    (t
     (multiple-value-bind (form rst)
         (read-form tokens)
       (read-list rst (cons form acc))))))

(defun read-atom (token)
  (read-from-string token))


(defun read-str (str)
  (read-form (tokenizer str)))
