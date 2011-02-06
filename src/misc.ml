(*
 * Paypal-ocaml 
 *
 * 05/02/2011 - william.le-ferrand@polytechnique.edu
 *
 *)

open Lwt 

let encode str = 
  let strlist = ref [] in 
  
  for i = 0 to String.length str - 1 do 
    let c = Char.code (str.[i]) in 
    if (65 <= c && c <= 90) || (48 <= c && c <= 57 ) || (97 <= c && c <= 122) || (c = 126) || (c = 95) || (c = 46) || (c = 45) then  
      strlist := Printf.sprintf "%c" str.[i] :: !strlist 
    else 
      strlist := Printf.sprintf "%%%X" c :: !strlist 
  done ;
  String.concat "" (List.rev !strlist)
