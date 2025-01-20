;; Multidimensional Exhibition Contract

(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-invalid-parameters (err u101))

(define-data-var exhibition-counter uint u0)

(define-map exhibitions uint {
    curator: principal,
    title: (string-ascii 100),
    description: (string-utf8 1000),
    artworks: (list 100 uint),
    dimensions: uint,
    start-date: uint,
    end-date: uint,
    status: (string-ascii 20)
})

(define-public (create-exhibition (title (string-ascii 100)) (description (string-utf8 1000)) (artworks (list 100 uint)) (dimensions uint) (start-date uint) (end-date uint))
    (let
        ((exhibition-id (+ (var-get exhibition-counter) u1)))
        (asserts! (> (len title) u0) err-invalid-parameters)
        (asserts! (> (len description) u0) err-invalid-parameters)
        (asserts! (> (len artworks) u0) err-invalid-parameters)
        (asserts! (> dimensions u0) err-invalid-parameters)
        (asserts! (< start-date end-date) err-invalid-parameters)
        (asserts! (>= start-date block-height) err-invalid-parameters)

        (map-set exhibitions exhibition-id {
            curator: tx-sender,
            title: title,
            description: description,
            artworks: artworks,
            dimensions: dimensions,
            start-date: start-date,
            end-date: end-date,
            status: "upcoming"
        })
        (var-set exhibition-counter exhibition-id)
        (ok exhibition-id)
    )
)

(define-public (update-exhibition-status (exhibition-id uint) (new-status (string-ascii 20)))
    (let
        ((exhibition (unwrap! (map-get? exhibitions exhibition-id) err-invalid-parameters)))
        (asserts! (is-eq tx-sender (get curator exhibition)) err-owner-only)
        (asserts! (or (is-eq new-status "upcoming") (is-eq new-status "active") (is-eq new-status "completed") (is-eq new-status "cancelled")) err-invalid-parameters)

        (ok (map-set exhibitions exhibition-id
            (merge exhibition { status: new-status })))
    )
)

(define-read-only (get-exhibition (exhibition-id uint))
    (map-get? exhibitions exhibition-id)
)

(define-read-only (get-exhibition-count)
    (var-get exhibition-counter)
)
