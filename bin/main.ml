open Lwt.Syntax

let html_to_string html = 
  Format.asprintf "%a" (Tyxml.Html.pp ()) html

(*
type page =
  | Home
  | Ontology
  | Data
  | Taxonomy
  *)

let create_onto_term term_data = 
  match term_data with 
  | "" -> Dream_test.App.Ontology None
  | _ -> Dream_test.App.Ontology (Some term_data)

let () = 
  Dream.run 
  @@ Dream.logger 
  @@ Dream.router [

    Dream.get "/static/**" @@ Dream.static "static";

    Dream.get "/"
      (fun _ -> Dream.html "<h1 style='color:green;'> Good morning, world!<h1>" );

    Dream.get "/onto" (fun _ -> Dream.html (html_to_string (Dream_test.App.app (create_onto_term ""))));

    (*
    Dream.get "/onto/:onto" (fun request -> 
      Dream.html (html_to_string (Dream_test.App.app (create_onto_term ((Dream.param request "onto") ) )));
    );
    *)

    Dream.get "/onto/:onto/:word" 
      (fun request -> 
        let term = (Dream.param request "onto") ^ "/" ^ (Dream.param request "word") in 
        let* term_data = Dream_test.Database.send_describe term in


        Dream.log "Sending request: %s" (Dream.client request);
        Dream.html (html_to_string (Dream_test.App.app (create_onto_term term_data ))));
  ]
