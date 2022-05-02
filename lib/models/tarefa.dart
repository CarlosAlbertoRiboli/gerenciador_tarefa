class ListaTarefa{
  late String id;
  late String email;
  late String tarefa;
  late String data;

  ListaTarefa(this.id,this.email, this.tarefa, this.data);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'email': email,
      'tarefa': tarefa,
      'data': data,
    };
    return map;
  }

  ListaTarefa.fromMap(Map<String, dynamic> map) {
    email = map['email'];
    tarefa = map['tarefa'];
    data = map["data"];
  }
}