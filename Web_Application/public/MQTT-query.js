var user = "stu1968555";
var bookObj = new Object();
// Create a client instance, we create a random id so the broker will allow multiple sessions
client_query = new Paho.MQTT.Client("broker.mqttdashboard.com", 8000, "clientId" + makeid(3) );
var queryTopic = "WEB_query";
var bookingTopic = "response_to_WEB";

// set callback handlers
client_query.onConnectionLost = onConnectionLost;
client_query.onMessageArrived = onMessageArrived;

// connect the client
client_query.connect({onSuccess:onConnect});

// called when the client connects
function onConnect() {
    // Once a connection has been made report.
    console.log("Connected");
    client_query.subscribe(bookingTopic, {qos:2});
}

// called when the client loses its connection
function onConnectionLost(responseObject) {
    if (responseObject.errorCode !== 0) {
        console.log("onConnectionLost:"+responseObject.errorMessage);
    }
}

// called when a message arrives
function onMessageArrived(message) {
    console.log("onMessageArrived:"+message.payloadString);
}

function queryOrder() {
    var x = document.getElementById("queryForm");
    var text = "";

    var newOrder = {
        query_id: "Q" + makeQueryid(7),
        user_id:  user,
        book_name:    x.elements[0].value,
        author_name:  x.elements[1].value,
        book_status:  "null"
    };

    onSubmit(JSON.stringify(newOrder));
  }

function bookingOrder() {
    var x = document.getElementById("queryForm");
    var newOrder = {
        query_id: "B" + makeQueryid(7),
        user_id:  user,
        book_name:    bookObj.book_name,
        author_name:  bookObj.author_name,
        book_status:  "booking"
    };
    onSubmit(JSON.stringify(newOrder));
}
// called when the client connects
function onSubmit(payload) {
    // Once a connection has been made, make a subscription and send a message.
    console.log("onSubmit");
    client_query.subscribe(bookingTopic);
    message = new Paho.MQTT.Message(payload);
    message.destinationName = queryTopic;
    client_query.send(message);
  }

  
// called to generate the Client IDs
function makeid(length) {
    var result           = '';
    var characters       = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    var charactersLength = characters.length;
    for ( var i = 0; i < length; i++ ) {
        result += characters.charAt(Math.floor(Math.random() * charactersLength));
    }
    return result;
}

// called to generate the IDs
function makeQueryid(length) {
    var result           = '';
    var characters       = '0123456789';
    var charactersLength = characters.length;
    for ( var i = 0; i < length; i++ ) {
        result += characters.charAt(Math.floor(Math.random() * charactersLength));
    }
    return result;
}

//Parse the recieved message from bookingTopic
client_query.onMessageArrived = function (message) {
$('#messages').append(message.payloadString);
    var data = JSON.parse(message.payloadString);
    // Book information
    bookObj.book_id = data.book_id;
    bookObj.book_name = data.book_name;
    bookObj.author_name = data.author_name;
    bookObj.area = data.area;
    bookObj.position = data.position;
    bookObj.book_status = data.book_status;

    bookObj.last_return_time = data.last_return_time;
    bookObj.booked = data.booked;
    bookObj.last_borrowed_time = data.last_borrowed_time;
    bookObj.last_warehouse_in_time = data.last_warehouse_in_time;
    
    // Insert book information in the book card
    var imgSrc = "img/" + bookObj.book_name + ".jpg";
    document.getElementById("bookImg").src = imgSrc;
    document.getElementById("bookId").innerHTML = "Book Id: " + bookObj.book_id;
    document.getElementById("book_Name").innerHTML = "Book Name: " + bookObj.book_name;
    document.getElementById("authorName").innerHTML = "Author Name: " + bookObj.author_name
    document.getElementById("area").innerHTML =  "Area: " + bookObj.area;
    document.getElementById("position").innerHTML =  "Position: " + bookObj.position;
    document.getElementById("bookStatus").innerHTML =  "Book Status: " + bookObj.book_status;
};
      
