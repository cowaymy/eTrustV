<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">

   $(function(){

	       $("#customerName").unbind().bind("change keyup", function(){
	          $(this).val($(this).val().toUpperCase());
	       });

	       $("#customerNricReg").unbind().bind("change keyup ", function(e) {
	    	   $(this).val($(this).val().replace(/[\D]/g,"").trim());
	       });

	       $("#customerMobileNo").unbind().bind("change keyup ", function(e) {
               $(this).val($(this).val().replace(/[\D]/g,"").trim());
           });

	       $('#btnCancel').click(function (e){
	    	   $("#btnPopClose").click();
	       });

	        document.getElementById('btnSave').onclick = (event) => {
	        	if (validateUpdForm2()){
	                event.preventDefault()
	                Common.showLoader()
		            fetch("/sales/ccp/submitPreCcpSubmission.do" ,
		            {
		            	 method: "POST",
		            	 headers: {
		            		    "Content-Type": "application/json",
		            	  },
		            	 body: JSON.stringify($("#preCcpRegisterForm").serializeJSON()),
		            })
	                .then(r => {
	                	   return r.json()
	                }).then(
		                data => {
		                	Common.removeLoader()
		                	if(data.code == "99"){
		                		Common.alert(data.message,fn_reload);
		                	}else{
	                          if(data.data !=null){
                                   Common.popupDiv("/sales/ccp/preCcpSubmissionRegisterResult.do", data.data, null, true);
		                      }
		                      else{
		                    	   Common.alert("Fail check in Pre-CCP register. Kindly contact system administrator or respective department.",reload)
		                      }
		                	}
		                }
	                )
	        	}
	        }

   });


   function validateUpdForm2() {

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

	       if (FormUtil.isEmpty($("#customerNricReg").val())) {
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
	   let dob = $("#customerNricReg").val().substring(0, 2);
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
				           <td><input type="text" class="w100p" id="customerNricReg" name="customerNric" maxlength=12/></td>
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