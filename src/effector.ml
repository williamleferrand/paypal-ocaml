(*
 * Paypal-ocaml 
 *
 * 05/02/2011 - william.le-ferrand@polytechnique.edu
 *
 *)

open Lwt 
open Misc
open Connection

let send connection request = 
  let encoded_request = List.map (fun (k, v) -> encode k, encode v) request in
  let formatted_request = List.fold_left (fun acc (k,v) -> if acc = "" then Printf.sprintf "%s=%s" k v else Printf.sprintf "%s&%s=%s" acc k v) "" encoded_request in
  let uri = Printf.sprintf "%s?%s"  connection.http_uri formatted_request in
  (Ocsigen_http_client.get 
     ~https:true 
     ~host:connection.http_host
     ~uri:uri ()) >>= (fun frame -> 
       match frame.Ocsigen_http_frame.frame_content with
	   None -> return "" ; 
	 | Some stream -> Ocsigen_stream.string_of_stream (Ocsigen_stream.get stream)) 
    
      
