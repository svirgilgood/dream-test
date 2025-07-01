open Tyxml
(*open Lwt.Syntax*)

type page =
  | Home
  | Ontology of string option

let%html home_page () = 
  {|
    <h1>Welcome to Edubba Institute</h1>
  |}

(*
let%html greet who = {|
  <html>
    <head>
      <title>Home</title>
      <link rel="stylesheet" href="/static/index.css">
    </head>
    <body>
      <h1 class="centered">|}[Html.txt ("Hello indeed, " ^ who ^ "!")]{|</h1>
    </body>
  </html> |}
  *)


let%html term_header term_data = 

  (*let body = [%html {|<p>|}[Html.txt response]{|</p>|}] in*)
  (*let create_paragraphs x = [%html {|<p>|} [Html.txt x] {|</p> |} ] in*)
  let body = [%html {|<div class="prewrap"> |}[ Html.txt term_data ]  {|</div>|}] in
  (*let body = [%html {|<p>|} [Html.txt term_data] {|</p>|}] in *)
  (*let heading = [%html {|<h2> you entered term: |} [Html.txt term] {|</h2>|}] in*)
  let heading = [%html {|<h2> This is an ontology body </h2> |}] in
  [%html {|<div>|} [heading; body] {|</div> |} ]

let%html ontology_page odata=
  match odata with 
  | Some body -> term_header body
  | None ->[%html {|<div><h2> Welcome to the ontology </h2> </div>|}]

let%html app page_type = 
  let body = 
    match page_type with 
    | Home -> home_page () 
    | Ontology data -> ontology_page data 
  in

  [%html {| 
  <html>
    <head>
      <title>Edubba Ontology</title>
      <link rel="stylesheet" href="/static/index.css">
    </head>
    <header>
      <div class="centered">
        <h1>Edubba Ontology</h1>
        <p>An ontology for ancient near Eastern data</p>
      </div>
    </header>
    |}[body]{| 
  </html>|}]

