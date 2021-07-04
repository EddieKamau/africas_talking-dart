String encodeUrl(String url, Map<String, dynamic> map){
  var _newMap = map.map((key, value) => MapEntry(key, Uri.encodeFull(value.toString())));
  String _encodedData = '';
  _newMap.forEach((key, value) {
    if(_encodedData.isEmpty){
      _encodedData+='$key=$value';
    }else{
      _encodedData+='&$key=$value';
    }
    
  });
  return '$url?$_encodedData';
}