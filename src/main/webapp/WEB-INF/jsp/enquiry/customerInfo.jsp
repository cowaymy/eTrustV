<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<script src="//cdnjs.cloudflare.com/ajax/libs/modernizr/2.8.3/modernizr.min.js"></script>
<link rel="stylesheet" href="http://netdna.bootstrapcdn.com/bootstrap/3.3.4/css/bootstrap.min.css">
<script src="//netdna.bootstrapcdn.com/bootstrap/3.3.4/js/bootstrap.min.js"></script>
<link rel="stylesheet" href="https://cdn.datatables.net/1.10.2/css/jquery.dataTables.min.css">
<script type="text/javascript" src="https://cdn.datatables.net/1.10.2/js/jquery.dataTables.min.js"></script>
<style>
.navbar {
  margin-bottom: 0;
  border-radius: 0;
}

.navbar, .navbar-toggle {background: #25527c !important; color: white;}

.text-white{color:white !important;}


</style>

<script>

    $(function() {
         let x = document.querySelector('.bottom_msg_box');
         x.style.display = "none";

         initialize();
        });


    function initialize(){
        Common.ajax("GET","/enquiry/getCustomerInfo.do", {custId : '${SESSION_INFO.custId}'} , function (result){

            if(result.code =="00"){
                let details = document.getElementById('details');
                let totalCnt = document.getElementById('totalCnt');
                totalCnt.innerHTML += result.data.length;

                for (var i = 0; i < result.data.length ; i++)
                {
                	details.innerHTML +=
                		'<tr>'
                	+ '<td>' + result.data[i].salesOrdNo + '</td>'
                    + '<td>' + result.data[i].stkDesc + '</td>'
                    + '<td>'
                    + result.data[i].addrDtl
                    + result.data[i].street
                    + result.data[i].mailArea
                    + result.data[i].mailPostCode
                    + result.data[i].mailCity
                    + result.data[i].mailState
                    + result.data[i].mailCnty
                    +'</td>'
                    +'<td><a href="../enquiry/updateInstallationAddressInDetails.do?orderNo='+result.data[i].salesOrdNo+'"><i class="material-icons">mode_edit</i></a></td>'
                    + '</tr>';
                }
            }
            customizeDatatable();
        });
    }

    function customizeDatatable(){
         $('#example').DataTable({iDisplayLength: 3});
         $('#example_length').hide();
    }

    function goDetailsPage(){
        $("#mainPage").attr("target", "");
        $("#mainPage").attr({
            action: getContextPath() + "/enquiry/updateInstallationAddressInDetails.do",
            method: "POST"
        }).submit();
    }

</script>
<nav class="navbar navbar-inverse">
  <div class="container-fluid">
    <div class="navbar-header">
      <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#myNavbar">
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
      </button>
      <a class="navbar-brand" href="#"><span><img src="${pageContext.request.contextPath}/resources/images/common/logo_coway2.png" alt="Coway" /></span></a>

    </div>
    <div class="collapse navbar-collapse" id="myNavbar">
      <ul class="nav navbar-nav" class="text-white">
        <li><a class="text-white">Home</a></li>
        <li><a class="text-white">Customer Info</a></li>
      </ul>
      <ul class="nav navbar-nav navbar-right">
           <li><a class="text-white">Welcome , ${SESSION_INFO.custName}</a></li>
           <li><a href="${pageContext.request.contextPath}/enquiry/updateInstallationAddress.do" class="text-white">Log Out</a></li>
      </ul>
    </div>
  </div>
</nav>

<div id="mainPage">
<div class="jumbotron" style="width:100%">
  <div class="container text-center">
    <h3>Product in  Total:</h3>
    <h1 id="totalCnt"></h1>
  </div>
</div>

  <table id="example" class="table table-striped table-bordered" style="width:100%">
        <thead>
            <tr>
                <th style="width:15%; vertical-align: middle; text-align:center;">Order No</th>
                <th style="width:25%; vertical-align: middle; text-align:center;">Products</th>
                <th style="width:40%; vertical-align: middle; text-align:center;">Current Installation Address</th>
                <th style="width:15%; vertical-align: middle; text-align:center;">Action</th>
            </tr>
        </thead>
        <tbody id ="details">
        </tbody>
  </table>



</div>
