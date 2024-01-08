class Result{
  late int code;
  late String message;
  late Object? data;


  Result.fail(this.message){
    code=500;
    data=[];
  }

  Result.success(this.data){
    code=200;
    message="success";
  }
}