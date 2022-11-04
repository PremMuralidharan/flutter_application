function flutterFunction(){
    let names = document.getElementById("name").value 
    let password = document.getElementById("passwrds").value 
    let rollno = document.getElementById("rollno").value 
    let mobileno = document.getElementById("mobno").value 
    let gender = ""
    if (document.getElementById('Male').checked) {
        gender = document.getElementById('Male').value; 
    }
    if (document.getElementById('Female').checked) {
        gender = document.getElementById('Female').value;
    }
    window.flutter_inappwebview
            .callHandler('handlerFooWithArgs', names,mobileno,gender,password,rollno);
}