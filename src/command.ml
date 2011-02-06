(*
 * Paypal-ocaml 
 *
 * 05/02/2011 - william.le-ferrand@polytechnique.edu
 *
 *)

open Lwt
open Connection

let set_express_checkout ?(layout=[]) return_url cancel_url amount desc unitary_price qty ?(email=None) connection = 
   let request = 
     ( "METHOD", "SetExpressCheckout" ) :: 
       ( "USER", connection.username ) ::
       ( "PWD", connection.password ) ::
       ( "SIGNATURE", connection.signature ) ::
       ( "VERSION", "56.0") :: 
       ( "RETURNURL", return_url ) :: 
       ( "CANCELURL", cancel_url ) :: 
       ( "NOSHIPPING", "1" ) :: 
       ( "LOCALECODE", "US") ::
       ( "PAYMENTACTION", "Sale") ::
       ( "AMT", (string_of_float (float_of_int qty *. unitary_price ))) ::
       ( "CURRENCYCODE", "USD" ) :: 
       ( "DESC", desc) ::
       ( "L_NAME0", "Credits") ::
       ( "L_DESC0", desc) ::  
       ( "L_AMT0", (string_of_float unitary_price)) :: 
       ( "L_QTY0", (string_of_int qty)) :: 
       (*	  ( "HDRIMG", "http://www.corefarm.org/images/header_cow_paypal.png") ::
		  ( "PAYFLOWCOLOR", "e0dbc5") ::
		  ( "HDRBACKCOLOR", "e0dbc5") :: *)
       ( "LANDINGPAGE", "Billing") ::
       (match email with None -> layout | Some e -> ("EMAIL", e) :: layout) in
   Effector.send connection request 
   >>= fun s -> return (Netencoding.Url.dest_url_encoded_parameters s)

let do_express_checkout connection token id ipn_url amount = 
  let request = 
    	( "METHOD", "DoExpressCheckoutPayment" ) :: 
	  ( "USER", connection.username ) ::
	  ( "PWD", connection.password ) ::
	  ( "SIGNATURE", connection.signature ) ::
	  ( "VERSION", "56.0") :: 
	  ( "NOSHIPPING", "1" ) :: 
	  ( "LOCALECODE", "US") ::

	  ( "PAYMENTACTION", "Sale") ::
	  
	  ( "TOKEN", token ) ::
	  ( "PAYERID", id ) :: 

	  ( "AMT", amount ) ::
	  ( "CURRENCYCODE", "USD" ) :: 
	  ( "DESC", "Credits on the corefarm (www.corefarm.com)") ::
	  
(*
	  ( "L_NAME0", "Credits") ::
	  ( "L_DESC0", (Printf.sprintf "%d ghz hours of CPU power on the Corefarm" ghz)) ::  
	  ( "L_AMT0", (string_of_float unitary)) :: 
	  ( "L_QTY0", (string_of_int ghz)) :: 
*)	 
	  ( "NOTIFYURL", ipn_url) ::
(*
	  ("HDRIMG", "http://www.corefarm.org/images/header_cow_paypal.png") ::
	  ("PAYFLOWCOLOR", "e0dbc5") ::
	  ("HDRBACKCOLOR", "e0dbc5") ::
	  ("LANDINGPAGE", "Billing") ::
	  (match email with None -> layout | Some e -> ("EMAIL", e) :: layout) *) 

	  [] in
  Effector.send connection request 
  >>= fun s -> return (Netencoding.Url.dest_url_encoded_parameters s)
    
