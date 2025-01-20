;; Artwork Submission Contract

(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-invalid-parameters (err u101))

(define-data-var artwork-counter uint u0)

(define-map artworks uint {
    artist: principal,
    title: (string-ascii 100),
    description: (string-utf8 1000),
    civilization: (string-ascii 50),
    dimensions: (list 3 uint),
    media-type: (string-ascii 50),
    creation-date: uint,
    submission-date: uint
})

(define-public (submit-artwork (title (string-ascii 100)) (description (string-utf8 1000)) (civilization (string-ascii 50)) (dimensions (list 3 uint)) (media-type (string-ascii 50)) (creation-date uint))
    (let
        ((artwork-id (+ (var-get artwork-counter) u1)))
        (asserts! (> (len title) u0) err-invalid-parameters)
        (asserts! (> (len description) u0) err-invalid-parameters)
        (asserts! (> (len civilization) u0) err-invalid-parameters)
        (asserts! (is-eq (len dimensions) u3) err-invalid-parameters)
        (asserts! (> (len media-type) u0) err-invalid-parameters)
        (asserts! (<= creation-date block-height) err-invalid-parameters)

        (map-set artworks artwork-id {
            artist: tx-sender,
            title: title,
            description: description,
            civilization: civilization,
            dimensions: dimensions,
            media-type: media-type,
            creation-date: creation-date,
            submission-date: block-height
        })
        (var-set artwork-counter artwork-id)
        (ok artwork-id)
    )
)

(define-read-only (get-artwork (artwork-id uint))
    (map-get? artworks artwork-id)
)

(define-read-only (get-artwork-count)
    (var-get artwork-counter)
)
