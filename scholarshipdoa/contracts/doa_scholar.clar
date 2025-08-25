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

;; public functions

;; Deposit funds to the scholarship pool
(define-public (deposit-funds (amount uint))
    (begin
        (asserts! (> amount u0) ERR-INVALID-AMOUNT)
        (try! (stx-transfer? amount tx-sender (as-contract tx-sender)))
        (var-set total-funds (+ (var-get total-funds) amount))
        (ok amount)
    )
)

;; Add a new DAO member
(define-public (add-dao-member
        (member principal)
        (voting-power uint)
    )
    (begin
        (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
        (asserts! (> voting-power u0) ERR-INVALID-AMOUNT)
        (map-set dao-members member {
            active: true,
            voting-power: voting-power,
            joined-at: stacks-block-height,
        })
        (var-set dao-member-count (+ (var-get dao-member-count) u1))
        (ok true)
    )
)

;; Remove a DAO member
(define-public (remove-dao-member (member principal))
    (begin
        (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
        (match (map-get? dao-members member)
            member-data (begin
                (map-set dao-members member (merge member-data { active: false }))
                (var-set dao-member-count (- (var-get dao-member-count) u1))
                (ok true)
            )
            ERR-NOT-DAO-MEMBER
        )
    )
)

;; Submit scholarship application
(define-public (submit-application
        (amount-requested uint)
        (description (string-utf8 500))
        (institution (string-utf8 100))
        (program (string-utf8 100))
    )
    (let (
            (application-id (var-get next-application-id))
            (voting-deadline (+ stacks-block-height VOTING-DURATION))
        )
        (asserts! (> amount-requested u0) ERR-INVALID-AMOUNT)
        (asserts! (<= amount-requested (var-get total-funds))
            ERR-INSUFFICIENT-FUNDS
        )
        (asserts! (> (len description) u0) ERR-INVALID-APPLICANT)
        (asserts! (> (len institution) u0) ERR-INVALID-APPLICANT)
        (asserts! (> (len program) u0) ERR-INVALID-APPLICANT)

        (map-set scholarship-applications application-id {
            applicant: tx-sender,
            amount-requested: amount-requested,
            description: description,
            institution: institution,
            program: program,
            submitted-at: stacks-block-height,
            voting-deadline: voting-deadline,
            status: STATUS-PENDING,
            total-votes-for: u0,
            total-votes-against: u0,
            voters: (list),
        })

        (var-set next-application-id (+ application-id u1))
        (ok application-id)
    )
)

;; Emergency withdraw (owner only)
(define-public (emergency-withdraw (amount uint))
    (begin
        (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
        (asserts! (> amount u0) ERR-INVALID-AMOUNT)
        (asserts! (>= (var-get total-funds) amount) ERR-INSUFFICIENT-FUNDS)

        (try! (as-contract (stx-transfer? amount tx-sender CONTRACT-OWNER)))
        (var-set total-funds (- (var-get total-funds) amount))
        (ok amount)
    )
)
