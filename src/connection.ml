(*
 * Paypal-ocaml 
 *
 * 05/02/2011 - william.le-ferrand@polytechnique.edu
 *
 *)

type t = 
    { 
      http_host : string ; 
      http_uri : string ; 
      username : string ;
      password : string ; 
      signature : string ; 
    }
      
let create username password signature = 
  {
    http_host = "api-3t.paypal.com" ;
    http_uri = "/nvp" ; 
    username = username ; 
    password = password ; 
    signature = signature ; 
  }

