// Data focused on reading, writing and preparing data
static abstract class Status {
  static final String[] LIST = {
    Status.AVAILABLE, 
    Status.BORROWED, 
    Status.EXCEPTIONAL, 
    Status.RESERVED,
  };
  static final String AVAILABLE = "available";
  static final String BORROWED = "borrowed";
  static final String EXCEPTIONAL = "exceptional";
  static final String RESERVED = "reserved";
}

static abstract class Area {
  static final String[] LIST = {
    Area.A, 
    Area.B, 
    Area.C, 
    Area.D, 
    
  };
  static final String A = "A";
  static final String B = "B";
  static final String C = "C";
  static final String D = "D";
}


// Example use of public class for metric as we use multiple (modular design)
public class Metric {
  public String name;
  public float value;
  // The Constructor
  Metric(String _name, float _value) {
    name = _name;
    value = _value;
  }
}
// Simulate SoC b/w API and Database
private class Database {
  int max_orders = 100; //max order number is 100;
  JSONObject[] orders = new JSONObject[max_orders];
  Database() {
  }
  int max_orders() {
    return max_orders;
  }
}

// copy all JSON objects on disk into working memory
void refreshData() {
  File dir;
  File[] files;
  dir = new File(dataPath(""));
  files = dir.listFiles();
  JSONObject json;
  if (files != null) {
    for (int i = 0; i <= files.length - 1; i++) {
      String path = files[i].getAbsolutePath();
      if (path.toLowerCase().endsWith(".json")) {
        json = loadJSONObject(path);
        if (json != null) {
          db.orders[i] = json;
        }
      }
    }
  }
}
// this is our API class to ensure separation of concerns. User -> API -> DB
public class OrderData {
  
  //get Orders By Status
  JSONObject[] getOrdersByStatus(String status) {
    JSONObject[] ret = new JSONObject[0];
    for (JSONObject order : db.orders) {
      if (order != null) {
        if (status.contains(order.getString("book_status"))) {
          ret = (JSONObject[]) append(ret, order);
        }
      }
    }
    return ret;
  }
  
  //get Orders By Area
  JSONObject[] getOrdersByArea(String area) {
    JSONObject[] ret = new JSONObject[0];
    for (JSONObject order : db.orders) {
      if (order != null) {
        if (area.contains(order.getString("area"))) {
          ret = (JSONObject[]) append(ret, order);
        }
      }
    }
    return ret;
  }
  //get Orders By Area and status = available
  JSONObject[] getOrdersByAreaAndStatus(String area) {
    JSONObject[] ret = new JSONObject[0];
    for (JSONObject order : db.orders) {
      if (order != null) {
        if (area.contains(order.getString("area"))) {
          //println("1111"+order.getString("book_status"));
          if (order.getString("book_status").equals("available")) {
          ret = (JSONObject[]) append(ret, order);
          }
        }
      }
    }
    return ret;
  }
  
  // get Order By book ID
  JSONObject getOrderByID(String id) {
    JSONObject ret = new JSONObject();
    for (JSONObject order : db.orders) {
      if (order != null) {
        if (id.contains(order.getString("book_id"))) {
          ret = order;
        }
      }
    }
    return ret;
  }
  
  // get Order By book name
  JSONObject getOrderByBookName(String bookName) {
    JSONObject ret = new JSONObject();
    for (JSONObject order : db.orders) {
      if (order != null) {
        if (bookName.contains(order.getString("book_name"))) {
          ret = order;
        }
      }
    }
    return ret;
  }
  
  // get Order By author name
  JSONObject getOrderByAuthorName(String authorName) {
    JSONObject ret = new JSONObject();
    for (JSONObject order : db.orders) {
      if (order != null) {
        if (authorName.contains(order.getString("author_name"))) {
          ret = order;
        }
      }
    }
    return ret;
  }
  
  // save order to database
  void saveBooktoDB(JSONObject order) {
    if (order == null) {
      return;
    } else {
      saveJSONObject(order, "data/" + order.getString("book_id") + ".json");
    }
  }
  
  void returnBookInfo2Web(String queryId, String userId, String bookName, String authorName)
  {
    if (!bookName.equals("null") && authorName.equals("null")) {
      JSONObject target = getOrderByBookName(bookName);
      if (target.size() != 0) {
        JSONObject returnInfo = returnInfo(target, queryId, userId);
        client.publish(response_to_WEB, returnInfo.toString());
      } else {
        JSONObject returnInfo1 = new JSONObject();
        returnInfo1.setString("book_name","null");
        client.publish(response_to_WEB, returnInfo1.toString());
      }
    }
    else if (bookName.equals("null") && !authorName.equals("null")) {
      JSONObject target = getOrderByAuthorName(authorName);
      if (target.size() != 0) {
        JSONObject returnInfo = returnInfo(target, queryId, userId);
        client.publish(response_to_WEB, returnInfo.toString());
      } else {
        JSONObject returnInfo = new JSONObject();
        returnInfo.setString("book_name","null");
        client.publish(response_to_WEB, returnInfo.toString());
      }
    }
    else if (!bookName.equals("null") && !authorName.equals("null")) {
      JSONObject target1 = getOrderByBookName(bookName);
      JSONObject target2 = getOrderByAuthorName(authorName);
      println("target1: "+target1.toString() + target1.size());
      println("target2: "+target2.toString() + target2.size());
      if (target1.equals(target2) && target1.size() != 0) {
        JSONObject returnInfo = returnInfo(target1, queryId, userId);
        client.publish(response_to_WEB, returnInfo.toString());
      } else {
        JSONObject returnInfo = new JSONObject();
        returnInfo.setString("book_name","null");
        client.publish(response_to_WEB, returnInfo.toString());
      }
    }
  }
  
  JSONObject returnInfo(JSONObject target, String queryId, String userId) {
    JSONObject newFile = new JSONObject();
    
    newFile.setString("query_id", queryId);
    newFile.setString("user_id", userId);
    newFile.setString("book_name",target.getString("book_name"));
    newFile.setString("book_id",target.getString("book_id"));
    newFile.setString("author_name",target.getString("author_name"));
    newFile.setString("book_status",target.getString("book_status"));
    newFile.setString("booked",target.getString("booked"));
    newFile.setString("last_borrowed_time",target.getString("last_borrowed_time"));
    newFile.setString("last_return_time",target.getString("last_return_time"));
    newFile.setString("last_warehouse-in_time",target.getString("last_warehouse-in_time"));
    newFile.setString("area",target.getString("area"));
    newFile.setString("position",target.getString("position"));
    return newFile;
  }
  
  // update Order Status
  void updateBookStatus2Booked(String bookName, String userId, String queryId) {
    JSONObject target = getOrderByBookName(bookName);
    JSONObject newFile = new JSONObject();
    if (target.getString("book_status").equals("booked")) {
      newFile.setString("book_status", "null");
      client.publish(response_to_WEB, newFile.toString());
      return;
    }

    newFile.setString("book_id",target.getString("book_id"));
    newFile.setString("book_name",target.getString("book_name"));
    newFile.setString("author_name",target.getString("author_name"));
    newFile.setString("book_status", "booked");
    newFile.setString("booked",userId);
    newFile.setString("last_borrowed_time",target.getString("last_borrowed_time"));
    newFile.setString("last_return_time",target.getString("last_return_time"));
    newFile.setString("last_warehouse-in_time",target.getString("last_warehouse-in_time"));
    newFile.setString("area",target.getString("area"));
    newFile.setString("position",target.getString("position"));
 
    saveBooktoDB(newFile);
    newFile.setString("query_id", queryId);
    newFile.setString("user_id", userId);
    
    // key, value
    client.publish(response_to_WEB, newFile.toString());
  }
  
  // update Order Status
  void updateBookStatus(String id, String newstatus) {
    JSONObject target = getOrderByID(id);
    JSONObject newFile = new JSONObject();
    if (target.size() == 0) {
      newFile.setString("book_id","null");
      client.publish(response_to_M5, newFile.toString());
      return;
    }
    int y = year(),m = month(),d = day();  
    String sy = str(y),sm = str(m),sd = str(d);
    if(m<10){sm="0"+sm;}if(d<10){sd="0"+sd;}
    String sysTime = sy+"-"+sm+"-"+sd;
    println("time: "+sysTime);
    if (newstatus.equals("borrowed")) {
      newFile.setString("last_borrowed_time",sysTime);
    } else {
      newFile.setString("last_borrowed_time",target.getString("last_borrowed_time"));
    }
    if (newstatus.equals("available")) {
      newFile.setString("last_warehouse-in_time",sysTime);
    } else {
      newFile.setString("last_warehouse-in_time",target.getString("last_warehouse-in_time"));
    }
    if (newstatus.equals("exceptional")) {
      newFile.setString("last_return_time",sysTime);
    } else {
      newFile.setString("last_return_time",target.getString("last_return_time"));
    }
    
    newFile.setString("book_id",id);
    newFile.setString("book_status",newstatus);
    newFile.setString("book_name",target.getString("book_name"));
    newFile.setString("author_name",target.getString("author_name"));
    newFile.setString("booked",target.getString("booked"));
    newFile.setString("area",target.getString("area"));
    newFile.setString("position",target.getString("position"));
 
    saveBooktoDB(newFile);
    // key, value
    client.publish(response_to_M5, newFile.toString());
  }
}
