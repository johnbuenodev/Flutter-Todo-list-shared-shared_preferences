
class Item{

 String title;
 bool done;
 //já possui um iniciador
 Item({this.title, this.done});

 //dois metodos
 Item.fromJson(Map<String, dynamic> json){
  title = json['title'];
  done = json['done'];
 }

 Map<String, dynamic> toJson(){

  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['title'] = this.title;
  data['done'] = this.done;
  return data;

 }


}

//var item = new Item(title: "john", done: false);