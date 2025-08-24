
;; title: ArtistChoice
;; version: 1.0.0
;; summary: A decentralized voting system for artist and performer selection
;; description: This smart contract allows users to vote for their favorite artists
;; and performers in various categories. It includes features for artist registration,
;; voting periods, and transparent result tracking.

;; traits
;;

;; token definitions
;;

;; constants
(define-constant ERR-OWNER-ONLY (err u100))
(define-constant ERR-NOT-FOUND (err u101))
(define-constant ERR-ALREADY-EXISTS (err u102))
(define-constant ERR-VOTING-NOT-ACTIVE (err u103))
(define-constant ERR-ALREADY-VOTED (err u104))
(define-constant ERR-INVALID-ARTIST (err u105))
(define-constant ERR-UNAUTHORIZED (err u106))

;; data vars
(define-data-var contract-owner principal tx-sender)
(define-data-var voting-active bool false)
(define-data-var voting-end-block uint u0)
(define-data-var artist-counter uint u0)

;; data maps
;; Store artist information
(define-map artists 
  { artist-id: uint }
  { 
    name: (string-ascii 50),
    description: (string-ascii 200),
    category: (string-ascii 30),
    registered-by: principal,
    vote-count: uint
  }
)

;; Track user votes to prevent double voting
(define-map user-votes 
  { voter: principal }
  { artist-id: uint, block-height: uint }
)

;; Store voting periods for historical tracking
(define-map voting-periods
  { period-id: uint }
  {
    start-block: uint,
    end-block: uint,
    total-votes: uint,
    winner-artist-id: uint
  }
)

;; public functions

;; Initialize or start a new voting period
(define-public (start-voting (duration uint))
  (begin
    (asserts! (is-eq tx-sender (var-get contract-owner)) ERR-OWNER-ONLY)
    (var-set voting-active true)
    (var-set voting-end-block (+ block-height duration))
    (ok true)
  )
)

;; End the current voting period
(define-public (end-voting)
  (begin
    (asserts! (is-eq tx-sender (var-get contract-owner)) ERR-OWNER-ONLY)
    (var-set voting-active false)
    (ok true)
  )
)

;; Register a new artist for voting
(define-public (register-artist (name (string-ascii 50)) (description (string-ascii 200)) (category (string-ascii 30)))
  (let 
    (
      (artist-id (+ (var-get artist-counter) u1))
    )
    (map-set artists
      { artist-id: artist-id }
      {
        name: name,
        description: description,
        category: category,
        registered-by: tx-sender,
        vote-count: u0
      }
    )
    (var-set artist-counter artist-id)
    (ok artist-id)
  )
)

;; Cast a vote for an artist
(define-public (vote-for-artist (artist-id uint))
  (let
    (
      (artist (unwrap! (map-get? artists { artist-id: artist-id }) ERR-INVALID-ARTIST))
      (existing-vote (map-get? user-votes { voter: tx-sender }))
      (current-votes (get vote-count artist))
    )
    ;; Check if voting is active
    (asserts! (var-get voting-active) ERR-VOTING-NOT-ACTIVE)
    (asserts! (< block-height (var-get voting-end-block)) ERR-VOTING-NOT-ACTIVE)
    
    ;; Check if user hasn't voted already
    (asserts! (is-none existing-vote) ERR-ALREADY-VOTED)
    
    ;; Record the vote
    (map-set user-votes
      { voter: tx-sender }
      { artist-id: artist-id, block-height: block-height }
    )
    
    ;; Update artist vote count
    (map-set artists
      { artist-id: artist-id }
      (merge artist { vote-count: (+ current-votes u1) })
    )
    
    (ok true)
  )
)

;; Update artist information (only by the artist who registered or contract owner)
(define-public (update-artist (artist-id uint) (name (string-ascii 50)) (description (string-ascii 200)) (category (string-ascii 30)))
  (let
    (
      (artist (unwrap! (map-get? artists { artist-id: artist-id }) ERR-NOT-FOUND))
    )
    (asserts! 
      (or 
        (is-eq tx-sender (get registered-by artist))
        (is-eq tx-sender (var-get contract-owner))
      ) 
      ERR-UNAUTHORIZED
    )
    
    (map-set artists
      { artist-id: artist-id }
      (merge artist {
        name: name,
        description: description,
        category: category
      })
    )
    (ok true)
  )
)

;; Transfer contract ownership
(define-public (transfer-ownership (new-owner principal))
  (begin
    (asserts! (is-eq tx-sender (var-get contract-owner)) ERR-OWNER-ONLY)
    (var-set contract-owner new-owner)
    (ok true)
  )
)

;; read only functions

;; Get artist information
(define-read-only (get-artist (artist-id uint))
  (map-get? artists { artist-id: artist-id })
)

;; Get current vote count for an artist
(define-read-only (get-artist-votes (artist-id uint))
  (match (map-get? artists { artist-id: artist-id })
    artist (some (get vote-count artist))
    none
  )
)

;; Check if a user has voted
(define-read-only (has-user-voted (user principal))
  (is-some (map-get? user-votes { voter: user }))
)

;; Get user's vote
(define-read-only (get-user-vote (user principal))
  (map-get? user-votes { voter: user })
)

;; Check if voting is currently active
(define-read-only (is-voting-active)
  (and 
    (var-get voting-active)
    (< block-height (var-get voting-end-block))
  )
)

;; Get voting end block
(define-read-only (get-voting-end-block)
  (var-get voting-end-block)
)

;; Get contract owner
(define-read-only (get-contract-owner)
  (var-get contract-owner)
)

;; Get total number of registered artists
(define-read-only (get-artist-count)
  (var-get artist-counter)
)

;; Get current block height for reference
(define-read-only (get-current-block)
  block-height
)

;; private functions
;;

