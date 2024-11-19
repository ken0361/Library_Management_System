// Presentation logic
ListBox l;
Chart overview;

//DropdownList processing_orders, in_transit_orders, delivered_orders;


//int has_button = 0;


void refreshDashboardData() {
    // We just rebuild the view rather than updating existing
    for (String status: Status.LIST) {
        cp5.remove(status + " total ");
        cp5.remove(status);
    }
    for (String area: Area.LIST) {
        cp5.remove(area + " area total ");
    }
    cp5.remove("Area_Chart");
    cp5.remove("Area_Chart1");
    cp5.remove("Status_Chart");
    cp5.get("tatal_amount").remove();
    cp5.get("available_amount").remove();
    
    view.resetSpacing();
    updateDashboardData();
}

void updateDashboardData() {
    refreshData();
    surface.setTitle("Library Management System");
    for (String area: Area.LIST) {
        view.build_metric(area + " area total ", (float) api.getOrdersByArea(area).length);
    }
    for (String status: Status.LIST) {
        view.build_metric(status + " total ", (float) api.getOrdersByStatus(status).length);
        view.build_list(status, api.getOrdersByStatus(status));
    }
    //println("flag:"+flag);
    
    view.build_Chart("Area_Chart", api.getOrdersByArea(Area.A).length, api.getOrdersByArea(Area.B).length, api.getOrdersByArea(Area.C).length, api.getOrdersByArea(Area.D).length);
    view.build_Chart("Area_Chart1", api.getOrdersByAreaAndStatus(Area.A).length, api.getOrdersByAreaAndStatus(Area.B).length, api.getOrdersByAreaAndStatus(Area.C).length, api.getOrdersByAreaAndStatus(Area.D).length);
    view.build_Chart("Status_Chart", api.getOrdersByStatus(Status.AVAILABLE).length, api.getOrdersByStatus(Status.BORROWED).length, api.getOrdersByStatus(Status.EXCEPTIONAL).length, api.getOrdersByStatus(Status.RESERVED).length);
    
    view.build_button();
}
public class Dashboard_view {

    int is_expanded = 0;
    int metric_vert_margin_spacing = 130;
    int metric_horiz_margin_spacing = 105;
    int list_vert_margin_spacing = 120;
    int list_horiz_margin_spacing = 400;
    int chart_vert_margin_spacing = 380;
    int chart_horiz_margin_spacing = 180;
    int box_vert_margin_spacing = 230;
    int box_horiz_margin_spacing = 500;
    int button_vert_margin_spacing = 270;
    int button_horiz_margin_spacing = 400;
    
    int metric_x_size = 80;
    int metric_spacing = 0;
    int metric_y_size = 20;
    int list_spacing = 0;
    int list_x_size = 100;
    int list_y_size = 200;
    int chart_spacing = 0;
    int chart_size = 180;
    int count = 0;
    int count1 = 0;
    
    //int has_button = 0;
  
    
    //metric left-top  Numberbox
    void build_metric(String name, Float value) {
        cp5.addNumberbox(name)
            .setValue(value)
            .setPosition(metric_horiz_margin_spacing, metric_vert_margin_spacing + metric_spacing)
            .setSize(metric_x_size, metric_y_size);
        metric_spacing = metric_spacing + (2 * metric_y_size);
        count++;
        if (count % 8 == 4) { 
          metric_horiz_margin_spacing = metric_horiz_margin_spacing*2 + 10;
          metric_spacing = 0;
        } 
        if (count % 8 == 0) {
          metric_horiz_margin_spacing = (metric_horiz_margin_spacing-10)/2;
          metric_spacing = 0;
        } 
          
    }


//list top-Middle
    void build_list(String list_name, JSONObject[] orders) {

        ScrollableList list = cp5.addScrollableList(list_name)
            .setPosition(list_horiz_margin_spacing + list_spacing, list_vert_margin_spacing)
            .setSize(list_x_size, list_y_size);
        list.setBackgroundColor(#24DEB7);
        list.setItemHeight(20);
        list.setBarHeight(30);
        list.setColorBackground(#8EA3BF);
        list.setColorActive(#CBC42D);
        list_spacing = list_spacing + list_x_size + 10;
        list.clear();
        list.open();
        for (JSONObject order: orders) {
            int i = 0;
            if (order != null) {
                list.addItem(order.getString("book_id"), i);
                i = i + 1;
            }
        }
        
    }
//chart bottom
    void build_Chart(String chart_name, int val, int val1, int val2, int val3) {
         count1++;
         if (count1 % 3 == 2) {
           chart_spacing = 0;
         }
         Chart chart = cp5.addChart(chart_name)
            .setPosition(chart_horiz_margin_spacing + chart_spacing, chart_vert_margin_spacing)
            .setSize(chart_size, chart_size)
            .setRange(0, 10)
            //.setView(Chart.PIE) // see http://www.sojamo.com/libraries/controlP5/reference/controlP5/Chart.html
            .setColorCaptionLabel(color(100));
            if (chart_name == "Status_Chart") {
              chart.setView(Chart.PIE);
            } else {
              chart.setView(Chart.BAR_CENTERED);
            }
        chart.getColor().setBackground(color(255, 100));
        chart.addDataSet(chart_name);
        chart.setColors(chart_name, color(255), color(40, 131, 247));
        chart.updateData(chart_name, val, val1, val2, val3);
        chart_spacing = chart_spacing + chart_size + 160;
       
      
      if (flag == 0 && count1 % 3 == 1) {
      chart.setVisible(true);
      } 
      if (flag == 0 && count1 % 3== 2) {
      chart.setVisible(false);
      }
      if (flag == 1 && count1 % 3 == 1) {
      chart.setVisible(false);
      } 
      if (flag == 1 && count1 % 3 == 2) {
      chart.setVisible(true);
      }
    }
    
    void build_button(){
      button_state2 = 0;
      
     cp5.addButton("tatal_amount")
     .setValue(0)
     .setPosition(30,450)
     .setSize(100,19)
     .setColorBackground(#574AED)
     ;
  
  // and add another 2 buttons
     cp5.addButton("available_amount")
     .setValue(100)
     .setPosition(30,500)
     .setSize(100,19)
     .setColorBackground(#574AED)
     ;
     
    
    }

    
//middle
    void build_book_details(String bookid) {
        if (is_expanded == 1) {
            cp5.get("book details").remove();
            cp5.get("toAvailable").remove();
            cp5.get("toBorrowed").remove();
            cp5.get("toExceptional").remove();
            cp5.get("toReserved").remove();
            is_expanded = 0;
            button_state1 = 0;
        }

//Expanded order
        ListBox order = cp5.addListBox("book details")
            .setPosition(box_horiz_margin_spacing, box_vert_margin_spacing)
            .setSize(250, 105)
            .setItemHeight(15)
            .setBarHeight(15)
            .setColorBackground(color(255, 128))
            .setColorActive(color(0))
            .setColorForeground(color(255, 100, 0));
            
      
        order.addItem(api.getOrderByID(bookid).getString("book_id"), 0);
        order.addItem(api.getOrderByID(bookid).getString("book_name"), 1);
        order.addItem(api.getOrderByID(bookid).getString("author_name"), 2);
        order.addItem(api.getOrderByID(bookid).getString("book_status"), 3);
        order.addItem(api.getOrderByID(bookid).getString("booked"), 4);
        order.addItem(api.getOrderByID(bookid).getString("area"), 5);
        order.addItem(api.getOrderByID(bookid).getString("position"), 6);


        // create the buttons
        cp5.addButton("toAvailable")
            .setValue(0)
            .setPosition(button_horiz_margin_spacing, button_vert_margin_spacing + 75)
            .setSize(100, 19);

        cp5.addButton("toBorrowed")
            .setValue(0)
            .setPosition((button_horiz_margin_spacing + 110), button_vert_margin_spacing + 75)
            .setSize(100, 19);

        cp5.addButton("toExceptional")
            .setValue(0)
            .setPosition((button_horiz_margin_spacing + 220), button_vert_margin_spacing + 75)
            .setSize(100, 19);
            
        cp5.addButton("toReserved")
            .setValue(0)
            .setPosition((button_horiz_margin_spacing + 330), button_vert_margin_spacing + 75)
            .setSize(100, 19);

        is_expanded = 1;
    }

    void resetSpacing() {
        chart_spacing = 0;
        list_spacing = 0;
        metric_spacing = 0;
    }
}
