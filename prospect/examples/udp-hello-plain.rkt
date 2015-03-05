#lang prospect

(require "../drivers/udp.rkt")

(spawn-udp-driver)

(spawn (lambda (e s)
         (match e
           [(message (udp-packet src dst #"quit\n"))
            (log-info "Got quit request")
            (transition s (list (message (udp-packet dst src #"Goodbye!\n")) (quit)))]
           [(message (udp-packet src dst body))
            (log-info "Got packet from ~v: ~v" src body)
            (define reply (string->bytes/utf-8 (format "You said: ~a" body)))
            (transition s (message (udp-packet dst src reply)))]
           [_ #f]))
       (void)
       (sub (udp-packet ? (udp-listener 5999) ?)))