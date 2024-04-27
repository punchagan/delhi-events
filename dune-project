(lang dune 3.15)

(name delhi_events)

(generate_opam_files true)

(using melange 0.1)

(using directory-targets 0.1)

(source
 (github punchagan/delhi-events))

(authors "Puneeth Chaganti")

(maintainers "Puneeth Chaganti")

(license ISC)

(package
 (name delhi_events)
 (synopsis "A short synopsis")
 (description "A longer description")
 (depends
  (ocaml
   (>= 5.1.1))
  (dune
   (>= 3.8))
  yojson
  ppx_deriving_yojson
  tyxml
  icalendar
  (eio
   (>= 1.0))
  eio_main
  cohttp-eio
  tls-eio
  lambdasoup
  cmdliner
  mirage-crypto-rng-eio
  cmarkit
  rss
  ;; Reason and Melange deps
  (reason
   (>= 3.10.0))
  (melange
   (>= "3.0.0-51"))
  (reason-react
   (>= "0.14.0"))
  (reason-react-ppx
   (>= "0.14.0"))
  (opam-check-npm-deps :with-test) ;;TODO: use with-dev-setup once opam 2.2 is out
  ppx_deriving_json)
 (tags
  (topics events calendar html rss generator ssg)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/dune-files.html#dune-project
