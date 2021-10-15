package main

import (
   "net/http"
   "fmt"
   "time"
   "html"
   "log"
   "os"
   "math/rand"
)

var body = `
<html>
<head><title>Hello, world!</title></head>

<body style="background-color:%s;">
<h1>Hello, World from %s</h1>

<p>
   The time is <b>%s</b>.
</p>

<div style="position: fixed;left: 0;bottom: 10;text-align: center;width: 100%%;background-color: white">
Release %s, build date: %s
</div>

</body>
</html>`

var BuildDate string;  // https://stackoverflow.com/a/11355611
var Release string;  // https://stackoverflow.com/a/11355611


//Go application entrypoint
func main() {

   rand.Seed(time.Now().UnixNano());


   color := fmt.Sprintf("hsl(%d, 75%%, 85%%)", rand.Intn( 360 ))

   http.HandleFunc("/hello", func(w http.ResponseWriter, r *http.Request) {
      w.Header().Set( "Connection", "Close" )
      w.Header().Set( "Refresh", "2; url=http://" + r.Host + r.RequestURI )

      fmt.Fprintf(w, body, 
         color, 
         html.EscapeString( os.Getenv( "HOSTNAME") ), 
         html.EscapeString( time.Now().Format(time.Stamp) ), 
         Release, 
         BuildDate )

   })

   fmt.Println("Listening on :8080");
   log.Fatal( fmt.Println(http.ListenAndServe(":8080", nil)) );
}