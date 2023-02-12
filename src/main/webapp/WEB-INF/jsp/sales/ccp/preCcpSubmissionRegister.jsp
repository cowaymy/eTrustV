<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">

   $(function(){

	       $("#customerName").unbind().bind("change keyup", function(){
	          $(this).val($(this).val().toUpperCase());
	       });

	       $("#customerNric").unbind().bind("change keyup ", function(e) {
	    	   $(this).val($(this).val().replace(/[\D]/g,"").trim());
	       });

	       $("#customerMobileNo").unbind().bind("change keyup ", function(e) {
               $(this).val($(this).val().replace(/[\D]/g,"").trim());
           });

          $('#btnSave').click(function (e){
              if (validateUpdForm()){
                   Common.ajax("POST", "/sales/ccp/submitPreCcpSubmission.do", $("#preCcpRegisterForm").serializeJSON() , function(result) {
                       if(result.code =="00"){
                    	   console.log(result);
                    	   Common.popupDiv("/sales/ccp/preCcpSubmissionRegisterResult.do", result.data, null, true, '');
                    	   $("#btnPopClose").click();
                       }
                       else{
                    	   Common.alert(result.message);
                       }
                   }, function(jqXHR, textStatus, errorThrown) {
                       try {
                           console.log("status : " + jqXHR.status);
                           console.log("code : " + jqXHR.responseJSON.code);
                           console.log("message : " + jqXHR.responseJSON.message);
                           console.log("detailMessage : "+ jqXHR.responseJSON.detailMessage);
                           Common.alert("Fail: " + jqXHR.responseJSON.message);
                       } catch (e) {
                           console.log(e);
                           Common.alert("Fail: " + e);
                       }
                   });
              }
          });
   });


   function validateUpdForm() {

	       if (FormUtil.isEmpty($("#customerName").val())) {
	           Common.alert("Please key in Customer Name.");
	           return false;
	       }
	       else{
	    	   if(onlyLettersAndSpaces($("#customerName").val())==false){
                   Common.alert("Name is not valid. Please key in again.");
                   return false;
               }
	       }

	       if (FormUtil.isEmpty($("#customerNric").val())) {
	           Common.alert("Please choose Customer NRIC.");
	           return false;
	       }
	       else{
	    	   if(!checkAge()){
	    	         Common.alert("This customer is not allowed to check Pre-CCP.");
	    	         return false;
	    	   }
	       }

	       if (FormUtil.isEmpty($("#customerMobileNo").val())) {
	           Common.alert("Please key in Mobile No.");
	           return false;
	       }

	       if (FormUtil.isEmpty($("#customerEmailAddr").val())) {
	           Common.alert("Please key in Email Address.");
	           return false;
	       }
	       else{
	           if(validateEmail($("#customerEmailAddr").val())==false){
	               Common.alert("Email is not valid. Please key in again.");
	               return false;
	           }
	       }

		  return true;
   }

   function onlyLettersAndSpaces(str) {
	   return /^[A-Za-z\s]*$/.test(str);
   }

   function validateEmail(email) {
       let regexp = /\S+@\S+\.\S+/;
       return regexp.test(email);
   }

   function fn_reload(){
       location.reload();
   }

   function checkAge() {
	   let dob = $("#customerNric").val().substring(0, 2);
	   let dobYear = (dob >=50 ? '19' : '20') + dob ;
	   let ageValid =  (new Date()).getFullYear() - dobYear;

	   if(ageValid < 18 || ageValid > 70){
		   return false;
	   }

	   return true;
  }

</script>

<div id="popup_wrap" class="popup_wrap">
  <header class="pop_header">
        <h1>Pre-CCP Register</h1>
         <ul class="right_opt">
                <li><p class="btn_blue2"><a id="btnPopClose" href="javascript:void(0);"><spring:message code="sal.btn.close" /></a></p></li>
        </ul>
  </header>


<section class="pop_body">
    <form action="#" method="post" name="preCcpRegisterForm" id="preCcpRegisterForm">
	      <table class="type1">
		        <caption>table</caption>
		        <colgroup>
			          <col style="width:160px" />
			          <col style="width:*" />
		        </colgroup>

	            <tbody>
				        <tr>
				           <th scope="row">Name</th>
				           <td><input type="text" class="w100p" id="customerName" name="customerName"/></td>
				        </tr>

				         <tr>
				           <th scope="row">NRIC</th>
				           <td><input type="text" class="w100p" id="customerNric" name="customerNric" maxlength=12/></td>
				         </tr>

				         <tr>
				           <th scope="row">Mobile No.</th>
				           <td><input type="text" class="w100p" id="customerMobileNo" name="customerMobileNo" maxlength=11/></td>
				         </tr>

				         <tr>
				           <th scope="row">Email Address</th>
				           <td><input type="text"  class="w100p" id="customerEmailAddr" name="customerEmailAddr" /></td>
				         </tr>
	           </tbody>
	      </table>

	      <ul class="center_btns">
	        <li><p class="btn_blue2 big"><a href="javascript:void(0);" id="btnSave">Save</a></p></li>
	        <li><p class="btn_blue2 big"><a href="javascript:void(0);" id="btnCancel">Cancel</a></p></li>
	      </ul>
    </form>
</section>
</div>