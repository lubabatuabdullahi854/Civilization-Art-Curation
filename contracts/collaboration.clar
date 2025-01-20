;; Inter-species Collaboration Contract

(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-invalid-parameters (err u101))
(define-constant err-not-collaborator (err u102))

(define-data-var collaboration-counter uint u0)

(define-map collaborations uint {
    title: (string-ascii 100),
    description: (string-utf8 1000),
    collaborators: (list 10 principal),
    status: (string-ascii 20),
    creation-date: uint
})

(define-public (create-collaboration (title (string-ascii 100)) (description (string-utf8 1000)) (collaborators (list 10 principal)))
    (let
        ((collaboration-id (+ (var-get collaboration-counter) u1)))
        (asserts! (> (len title) u0) err-invalid-parameters)
        (asserts! (> (len description) u0) err-invalid-parameters)
        (asserts! (> (len collaborators) u1) err-invalid-parameters)

        (map-set collaborations collaboration-id {
            title: title,
            description: description,
            collaborators: collaborators,
            status: "active",
            creation-date: block-height
        })
        (var-set collaboration-counter collaboration-id)
        (ok collaboration-id)
    )
)

(define-public (update-collaboration-status (collaboration-id uint) (new-status (string-ascii 20)))
    (let
        ((collaboration (unwrap! (map-get? collaborations collaboration-id) err-invalid-parameters)))
        (asserts! (is-some (index-of (get collaborators collaboration) tx-sender)) err-not-collaborator)
        (asserts! (or (is-eq new-status "active") (is-eq new-status "completed") (is-eq new-status "cancelled")) err-invalid-parameters)

        (ok (map-set collaborations collaboration-id
            (merge collaboration { status: new-status })))
    )
)

(define-read-only (get-collaboration (collaboration-id uint))
    (map-get? collaborations collaboration-id)
)

(define-read-only (get-collaboration-count)
    (var-get collaboration-counter)
)
