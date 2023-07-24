<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<meta name="viewport" content="width=device-width, initial-scale=1">


<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/common.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/util.js"></script>
<script type="text/javaScript">

$(document).ready(function() {

	$("#name").val("${preName}");
	$("#nric").val("${preNric}");
	$("#orderNo").val('3137788');

	if($("#name").val() == "") {
		 $("#name").attr("readonly", false);
	}

	if($("#nric").val() == "") {
        $("#nric").attr("readonly", false);
   }

	// to get client ip address
     $.getJSON("https://jsonip.com", function(data) {
    	$("#clientIp").val(data.ip);
        console.log(data.ip);
    })

});

function getContextPath() {
    return "${pageContext.request.contextPath}";
 }

function fn_reset() {
	$("#orderNo").val('');
}

function fn_submit() {
	var valid = false;
	var orderno = $("#orderNo").val();
	var name = $("#name").val();
	var nric = $("#nric").val();

	if (orderno == "" || name == "" || nric == ""){
		alert("Please fill up all the fields.");
		return false;
	}

	Common.ajax("GET", "/payment/enroll/ddSubmit.do", $("#enrollmentForm").serialize(), function(result) {
		   console.log(result.data.url);
		   window.location.replace(result.data.url);

	});

}

</script>

<style>

@font-face {
  font-family: Avenir;
  src: url(/resources/font/Avenir.ttc);
}

#line{padding-left:20px; padding-right:20px;}
.enrolPage{font-family:Avenir;background-color:#9dbcd0;color:#FFFFFF; display: block ;text-align: center; padding-bottom:30px;height:-webkit-fill-available}
#info{height: -webkit-calc(90vh - 70px) overflow-y:auto;font-family:Avenir;background-color:#9dbcd0;color:#FFFFFF!important;
        overflow: hidden;}
#logo{display: block;  margin-left: auto;  margin-right: auto;margin-top:20px;font-size:20px; font-weight:bold; font-family:Avenir;color:#FFFFFF;}
.title1{font-size:14px;padding-bottom:15px; font-family:Avenir;color:#FFFFFF;}
.btn {
    color: #90a9b7;
    font-weight: bold;
    font-size: 15px;
    border: 0px solid #90a9b7;
    border-radius: 13px;
    text-align: center;
    min-width: 100px;
    max-width: 200px;
    min-height: 30px;
    line-height: 20px;
    padding: 10px;
    background-color: #FFFFFF;
    margin-left: 10;
    margin-right: 10;
}
table#enrolTable tbody tr td {font-size:small; text-align: left; color:#FFFFFF; min-width:100px;}
table#enrolTable tbody tr td input{font-size:small ; text-align: center; padding:8px;border:0px solid #90a9b7; border-radius:12px;background-color:#FFFFFF; height:38px; max-width:200px;overflow-y:auto}
table#enrolTable tbody tr td input:read-only {background: #d2d2d2}
table {width:100%;margin-left:auto; margin-right:auto; display:block;}
/* .container{
    margin: 0 0;
} */
#enrolTable{
    text-align:center;
    width: 390px;
    padding-bottom: 1%;
    padding-top: 1%;
}
#disclaimer{
    max-width: 450px;
    padding-bottom: 1%;
    padding-top: 1%;
    font-size: 1.5vh;
    font-family:Avenir;
    color:#FFFFFF;

}

</style>

<!-- --------------------------------------DESIGN------------------------------------------------ -->

<div id="enrollment" class="enrolPage">
    <!-- content start -->
    <form action="#" method="post" id="enrollmentForm" name="form">
       <input type="hidden" id="clientIp" name="clientIp" value=""/>
       <div style="padding-top: 10px;">
            <img id="logo" width="200px" src="${pageContext.request.contextPath}/resources/images/common/Coway Logo_white-01.png"/>
        </div>
		<div id="info"
			style="padding-top: 1%; padding-left: 5%; padding-right: 5%">

			<div class="logo">
				<h2>Direct Debit Registration</h2>
				<br />
				<p>CUSTOMER DETAILS</p>
			</div>
			<div class="container">
				<table id="enrolTable" style="border: none;">
					<tbody>
						<tr>
							<td id="label">NAME</td>
							<td><input type="text" title="Name" placeholder="" id="name"
								name="name" readonly /></td>
						</tr>
						<tr>
							<td id="label">IC NO.</td>
							<td><input type="text" title="IC Number" placeholder=""
								id="nric" name="nric" readonly /></td>

						</tr>
						<tr>
							<td id="label">ORDER NO.</td>
							<td><input type="text" title="Order Number" placeholder=""
								id="orderNo" name="orderNo" /></td>
						</tr>

					</tbody>
				</table>
			</div>

			<div id="line">
				<hr />
			</div>


			<div>
			<table id="disclaimer" style="border: none;">
			     <tbody>
			         <tr>
                         <td>Disclaimer:</td>
                     </tr>
                     <tr>
                         <td>
                         I have read
                    Coway's Privacy Notice at <u><a
                        href="https://www.coway.com.my/privacy-notice"
                        style="font-size: 10px;">https://www.coway.com.my/privacy-notice</a></u>
                    and consent to its collection and processing of my personal
                    information for the purposes which includes verifying my identity
                    and ensuring the accuracy of my personal information provided
                    during the eMandate registration and enrollment process in
                    accordance with Coway's Privacy Notice.
                         </td>
                     </tr>
			     </tbody>
			</table>
			</div>

			<div>
				<button type="button" class="btn" onclick="javascript:fn_reset();">RESET</button>
				<button type="button" class="btn" onclick="javascript:fn_submit();">SUBMIT</button>
			</div>
		</div>



	</form>
</div>