// User interaction logic calling data (model) and views

String book_details; //ID of order in focus

String MQTT_topic_receive = "book_orders";
String MQTT_topic_send = "send_info";
//communicate with M5 stack
String M5_query = "M5_query";
String response_to_M5 = "response_to_M5";
//communicate with web
String WEB_query = "WEB_query";
String response_to_WEB = "response_to_WEB";

int button_state1 = 0;
int button_state2 = 0;
int button_state3 = 0;
int flag = 0;

void clientConnected() {
    println("client connected to broker");
    //subscribe to the topic
    client.subscribe(MQTT_topic_receive);
    client.subscribe(M5_query);
    client.subscribe(WEB_query);
}

void connectionLost() {
    println("connection lost");
}

void messageReceived(String topic, byte[] payload) {
  println("topic: "+topic);
  println("json: "+payload);
    JSONObject json = parseJSONObject(new String(payload));
    
    println("queryId: "+json.getString("query_id"));
    
    
    if (json == null) {
        println("Order could not be parsed");
    } else if (topic.equals(WEB_query)) {
      println("receive: "+json.toString());
      String queryId = json.getString("query_id");
      String userId = json.getString("user_id");
      String bookName = json.getString("book_name");
      String authorName = json.getString("author_name");
      if (json.getString("book_status").equals("null")) {
        api.returnBookInfo2Web(queryId,userId,bookName,authorName);
      } else if (json.getString("book_status").equals("booking")) {
        api.updateBookStatus2Booked(bookName, userId, queryId);
      }
    } else if (topic.equals(M5_query)) {
      println("receive: "+json.toString());
      String id = json.getString("book_id");
      api.updateBookStatus(id, "available");
    }
    
    refreshData();
    refreshDashboardData();
}

void controlEvent(ControlEvent theEvent) {
    // expand order if clicked via API call
    println("action: ");
    println(theEvent.getController().getValueLabel().getText());
    if (theEvent.getController().getValueLabel().getText().contains("Q") == true) {
        // call the api and get the JSON packet
        println("name: " + theEvent.getController().getName());
        println("[]: "+(int) theEvent.getController().getValue());
        book_details = api.getOrdersByStatus(theEvent.getController().getName())[(int) theEvent.getController().getValue()].getString("book_id");
        println("book_details: "+book_details);
        view.build_book_details(book_details);
       
    }
   
}

public void tatal_amount() {
  if (button_state2 > 2) {
  flag = 0;
  refreshDashboardData();
  println("flag1:"+flag);
  }
  button_state2 = button_state2 + 1;
  //
 //updateDashboardData();
  
}

public void available_amount() {
  if (button_state2 > 2) {
  flag = 1;
  refreshDashboardData();
  println("flag2:"+flag);
  }
  button_state2 = button_state2 + 1;
}

public void _exit_() {
  if (button_state3 > 0) {
   // exit();
   flagView = 1;
  }
  button_state3 = button_state3 + 1;
}


// call back on button click
public void toAvailable() {
    if (button_state1 > 3) {
        api.updateBookStatus(book_details, Status.AVAILABLE);
        refreshDashboardData();
    }
    button_state1 = button_state1 + 1;
}

// call back on button click
public void toBorrowed() {
    if (button_state1 > 3) {
        api.updateBookStatus(book_details, Status.BORROWED);
        refreshDashboardData();
    }
    button_state1 = button_state1 + 1;
}

// call back on button click
public void toExceptional() {
    if (button_state1 > 3) {
        api.updateBookStatus(book_details, Status.EXCEPTIONAL);
        refreshDashboardData();
    }
    button_state1 = button_state1 + 1;
}

// call back on button click
public void toReserved() {
  println("call reserved!!! ");
    if (button_state1 > 3) {
        api.updateBookStatus(book_details, Status.RESERVED);
        refreshDashboardData();
    }
    button_state1 = button_state1 + 1;
}
