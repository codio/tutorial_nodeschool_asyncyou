@annotation:tour waterfall 
#1. Waterfall
##Challenge
In Node.js and browsers there is three ways to do **asynchronous** JavaScript.

The first way leads to what we call {italic}Callback Hell{/italic}. Callback Hell can be minimized by following the tips at [http://callbackhell.com](http://callbackhell.com).

Another method is to use a Promise package. Using promises will simplify your code but it also adds another layer of abstraction.

The last method is by using the [async package by Caolan McMahon](https://www.npmjs.org/package/async).  With **async** we are still writing callbacks but without falling into the callback hell or adding another layer of abstraction with promises.

More often than not you will need to do multiple asynchronous calls one after the other with each call dependant on the result of previous asynchronous call. We can do this with the help of async.waterfall.

For example the following code will do a GET request to http://localhost:3131 in the first waterfall function. The response body is pased as an argument to the next waterfall function via the callback. The second function in the waterfall accepts the body as a parameter and JSON.parse's it to get to the port property then it does another GET request.

    var http = require('http')
      , async = require('async');

    async.waterfall([
      function(cb){
        var body = '';

        // response is JSON encoded object like the following {port: 3132}
        http.get("http://localhost:3131", function(res){

          res.on('data', function(chunk){
            body += chunk.toString();
          });

          res.on('end', function(){
            cb(null, body);
          });
        }).on('error'), function(e) {
          cb(err);
        });
      },

      function(body, cb){
        var port = JSON.parse(body).port;

        var body = '';

        http.get("http://localhost:" + port, function(res){
          res.on('data', function(chunk){
            body += chunk.toString();
          });

          res.on('end', function(){
            cb(null, body);
          });

        }).on('error'), function(e) {
          cb(err);
        });
      }
    ], function(err, result){
      if (err) return console.error(err);
      console.log(result);
    });



In this problem you will need to write a program that first reads the contents of a file. The path will be provided as the first command-line argument to your program. The file will contain a single URL. Using `http.get` create GET request to to this url and `console.log` the response body.



@annotation:tour series_object
#2. Series Object
##Challenge
In this problem we will hopefully learn to use [async.series](https://www.npmjs.org/package/async#series).

The main difference between the waterfall and series functions is that the result from a task function in async.series wont pass it along to the next function once it completes. series will collects all results as an array and pass it to the optional callback that runs once all of the task functions have completed. For example;

    async.series([
      function(callback){
        setTimeout(function() {
          callback(null, 'one');
        }, 200);
      },
      function(callback){
        setTimeout(function() {
          callback(null, 'two');
        }, 100);
      }
    ],
    // optional callback
    function(err, results){
      // results is now equal to ['one', 'two']
    });

Instead of using an array as the result container async.series can use an object running each property and creating a result object with the same properties. The above example can be writting like so;

    async.series({
      one: function(done){
        done(null, '1');
      },

      two: function(done){
        done(null, '2');
      }
    }, function(err, result){
      console.log(results);
      // results will be {one: 1, two: 2}
    });


Write a program that will receive two URLs as the first and second command-line arguments.
Using `http.get` create a GET request to to these urls and pass the response body to the callback.

Pass in an object of task functions using the property names `requestOne` and `requestTwo`
to [async.series](https://www.npmjs.org/package/async#series).

`console.log` the results in the callback for series when all the task functions have completed.



@annotation:tour each
#3. Each
##Challenge
Occasionally you will need to run a series of asynchronous calls without caring about the return data but check if any throw errors (sometimes not even that). For example the following will do three

    var http = require('http')
      , async = require('async');

    async.each(['cat', 'meerkat', 'penguin'], function(item, done){
      var opts = {
        hostname: 'http://httpbin.org',
        path: '/post',
        method: 'POST'
      };
      var req = http.request(opts, function(res){
        res.on('data', function(chunk){
        });

        res.on('end', function(){
         return done();
        });
      });

      req.write(item);
      req.end();
    },
    function(err){
      if (err) console.log(err);
    });

Create a program that will receive two URLs as the first and second command-line arguments. Then using [`http.get`](http://nodejs.org/api/http.html#http_http_get_options_callback) create two GET requests to these URL's console.log any errors.



@annotation:tour map
#4. Map
##Challenge
With [async.each](https://www.npmjs.org/package/async#each) results of the asynchronous function is
lost.

This is were [async.map](https://www.npmjs.org/package/async#map) comes in. It does the same thing as [async.each](https://www.npmjs.org/package/async#each) by calling an asynchronous iterator function on an array but collects the results of the asynchronous iterator function and passes it to the results callback. The results is an array that is in the same order as the original array.

For example the example in the EACH problem can be written as;

    var http = require('http')
      , async = require('async');

    async.map(['cat', 'meerkat', 'penguin'], function(item, done){
      var opts = {
        hostname: 'http://httpbin.org',
        path: '/post',
        method: 'POST'
      };
      var body = '';
      var req = http.request(opts, function(res){
        res.on('data', function(chunk){
          body += chunk.toString();
        });

        res.on('end', function(){
         return done(null, body);
        });
      });

      req.write(item);
      req.end();
    },
    function(err, results){
      if (err) return console.log(err);
      // results is an array of the response bodies in the same order
    });

Write a program that will receive two command-line arguments to two URLs. Using [`http.get`](http://nodejs.org/api/http.html#http_http_get_options_callback) create two GET requests to these URLs. You will need to use [async.map](https://www.npmjs.org/package/async#map) and `console.log` the result array.


@annotation:tour times
#5. Times
##Challenge
Write a program that will receive two command line arguments containing the hostname and port. Using `http.request` send a POST request to

    url + '/users/create'

with the body containing a JSON.stringify'ed object;

    {user_id : 1}

Do this five times with each the `user_id` property being incremented starting at 1.

Once these requests are done send a GET request to 

    url + '/users'

and `console.log` the response body.


##Hint
Use [async.times](https://www.npmjs.org/package/async#times) and [http.request](http://nodejs.org/api/http.html#http_http_request_options_callback)



@annotation:tour reduce
#6. Reduce
##Challenge
Write a program that will receive an URL as the first command line argument. To this URL send a GET request using [`http.get`](http://nodejs.org/api/http.html#http_http_get_options_callback) with a query parameter named **number** which should be set consecutively to one of the values in the following array

    ['one', 'two', 'three']

Convert the response body to a Number and add it to the previous value. `console.log` the reduced value.

##Hint
Use [async.reduce](https://www.npmjs.org/package/async#reduce)



@annotation:tour whilst
#7. Whilst
##Challenge
Write a program that will receive a single command line argument to a URL. Using [async.whilst](https://www.npmjs.org/package/async#whilst) and [`http.get`](http://nodejs.org/api/http.html#http_http_get_options_callback) send GET requests to this url until the response body contains the string **meerkat**.

`console.log` the amount of GET requests needed to retrieve the meerkat string.

##Hint
String.prototype.trim() is your friend.












