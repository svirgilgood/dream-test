open Lwt.Syntax 
open Cohttp
open Cohttp_lwt_unix


let base_uri = Uri.of_string "http://localhost:3030/onto/sparql"

let make_request ~method_ ~uri ~message_body = 
  let header_add s1 s2 h = Header.add h s1 s2 in 
  let headers =
    Header.init ()
    |> header_add "Accept" "text/turtle"
    |> header_add "Content-Type" "application/sparql-query"
  in 
  let body = Cohttp_lwt.Body.of_string !message_body in

  let* resp, resp_body = 
    Client.call ~headers ~body method_ uri 
  in 
  let code = 
    resp |> Response.status |> Code.code_of_status 
  in 
  let+ body = Cohttp_lwt.Body.to_string resp_body in 
  code, body

let send_describe term = 
  let formatted_term = "https://www.edubbainstitute.org/onto/" ^ term in 
  let message = ref ("DESCRIBE <" ^ formatted_term ^ ">") in 
  print_endline ("DESCRIBE <" ^ formatted_term ^ ">") ;
  let+ post_response_code, post_response_body = 
      make_request 
        ~method_: `POST
        ~uri:base_uri
        ~message_body:message
  in 
  print_endline (Printf.sprintf "Response: %i\n" post_response_code) ;
  post_response_body
