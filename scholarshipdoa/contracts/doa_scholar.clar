;; title: DAO Scholarship Smart Contract
;; version: 1.0.0
;; summary: A decentralized scholarship management system with DAO governance
;; description: This contract manages scholarship funds through DAO voting, ensuring transparency and fair distribution

;; Error codes
(define-constant ERR-NOT-AUTHORIZED (err u1000))
(define-constant ERR-INVALID-AMOUNT (err u1001))
(define-constant ERR-APPLICATION-NOT-FOUND (err u1002))
(define-constant ERR-VOTING-PERIOD-ENDED (err u1003))
(define-constant ERR-VOTING-PERIOD-ACTIVE (err u1004))
(define-constant ERR-ALREADY-VOTED (err u1005))
(define-constant ERR-NOT-DAO-MEMBER (err u1006))
(define-constant ERR-INSUFFICIENT-FUNDS (err u1007))
(define-constant ERR-ALREADY-PAID (err u1008))
(define-constant ERR-NOT-APPROVED (err u1009))
(define-constant ERR-INVALID-APPLICANT (err u1010))

;; Contract constants
(define-constant CONTRACT-OWNER tx-sender)
(define-constant VOTING-DURATION u144) ;; ~24 hours in blocks (assuming 10 min blocks)
(define-constant MIN-VOTE-THRESHOLD u3) ;; Minimum votes required for approval
(define-constant QUORUM-PERCENTAGE u51) ;; 51% quorum required

;; Application status constants
(define-constant STATUS-PENDING u0)
(define-constant STATUS-APPROVED u1)
(define-constant STATUS-REJECTED u2)
(define-constant STATUS-PAID u3)

;; data vars
(define-data-var total-funds uint u0)
(define-data-var next-application-id uint u1)
(define-data-var dao-member-count uint u0)

;; data maps
;; DAO member management
(define-map dao-members
    principal
    {
        active: bool,
        voting-power: uint,
        joined-at: uint,
    }
)

;; Scholarship applications
(define-map scholarship-applications
    uint
    {
        applicant: principal,
        amount-requested: uint,
        description: (string-utf8 500),
        institution: (string-utf8 100),
        program: (string-utf8 100),
        submitted-at: uint,
        voting-deadline: uint,
        status: uint,
        total-votes-for: uint,
        total-votes-against: uint,
        voters: (list 50 principal),
    }
)

;; Individual votes on applications
(define-map votes
    {
        application-id: uint,
        voter: principal,
    }
    {
        vote: bool,
        voting-power: uint,
        voted-at: uint,
    }
)

;; Track payment status
(define-map payment-records
    uint
    {
        recipient: principal,
        amount: uint,
        paid-at: uint,
    }
)
