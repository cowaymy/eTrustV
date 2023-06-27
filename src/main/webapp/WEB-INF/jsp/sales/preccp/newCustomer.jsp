<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<style>
.circle {
	display: inline-block;
	width: 20px;
	height: 20px;
	border-radius: 50%;
	background-color: red;
	text-align: center;
	color: white;
	font-weight: bold;
	font-size: 16px;
	line-height: 20px;
	vertical-align: middle;
}
</style>
<section id="content">

	<ul class="path"></ul>

	<aside class="title_line">
		<p class="fav">
			<a></a>
		<h2>New Customer</h2>
		</p>
		<ul class="right_btns">
			<li><p class="btn_blue">
					<a id="registerCustomer">Register</a>
				</p></li>
			<li><p class="btn_blue">
					<a id="sendSms">Send Consent</a>
				</p></li>
			<li><p class="btn_blue">
					<a>Pre-CCP Result</a>
				</p></li>
			<li><p class="btn_blue">
					<a>View History</a>
				</p></li>
		</ul>
	</aside>

	<div id="div1">

		<form id="form1">

			<div style="display: none; align-items: center;" id="displayAlertMsg">
				<div class="circle">!</div>
				<div>
					&nbsp;<span id="alertMsgContent" style="color: red"></span>
				</div>
			</div>

			<br />

			<table class="type1">
				<tbody>
					<tr>
						<th>Customer NRIC</th>
						<td><input type="text" class="w100p regCust"
							name="customerNric" id="customerNric" maxlength=12></td>
					</tr>
					<tr>
						<th>Customer Name</th>
						<td><input type="text" class="w100p regCust lockBeforeIc"
							name="customerName" id="customerName"></td>
					</tr>
					<tr>
						<th>Customer Mobile No</th>
						<td><input type="text" class="w100p regCust lockBeforeIc"
							name="customerMobileNo" id="customerMobileNo" maxlength=11></td>
					</tr>
					<tr>
						<th>Customer Email Address</th>
						<td><input type="text" class="w100p regCust lockBeforeIc"
							name="customerEmailAddr" id="customerEmailAddr"></td>
					</tr>

					<tr>
						<td colspan="2">
							<div
								style="display: flex; flex-direction: column; margin-top: 5px;">
								<div style="margin-left: 20px; font-weight: bold;">
									<u style="font-size: 13px;">Agent Declaration</u>
								</div>
								<div
									style="display: flex; align-items: center; margin-top: 5px;">
									<input type="checkbox" id="chkDeclaration" />
									<p>I confirm that I have reviewed the customer's personal
										information for the purpose of conducting a credit pre-check.</p>
								</div>
							</div>
						</td>
					</tr>
				</tbody>
			</table>
		</form>
		<aside class="title_line">
			<ul class="center_btns">
				<li><p class="btn_blue">
						<a id="btnSave">Save</a>
					</p></li>
				<li><p class="btn_blue">
						<a id="btnClear">Clear</a>
					</p></li>
			</ul>
		</aside>
	</div>

	<!-- Send Consent -->
	<div id="div2">
		<div id="smsGrid" style="width: 100%; height: 500px; margin: 0 auto;"></div>
	</div>


</section>


<script>
     let div1Open = false, div2Open = true;

     const reload = () => {
         location.reload();
     }

     const refreshDisplay = () => {
         document.getElementById("div1").style.display = div1Open ? "": "none";
         document.getElementById("div2").style.display = div2Open ? "": "none";
     }


     <!-- DIV 1 - Register -->

     let customerNric = false, customerName = false, customerMobileNo = false, customerEmailAddr = false;

     const clearForm = (formId) => {
    	 document.getElementById(formId).reset();
     }

     const checkEmail = (email) => {
         let regexp = /\S+@\S+\.\S+/;
         return regexp.test(email);
     }

     const closePop = () => {
         $(".btn_blue2").unbind().bind("click", function(e) {
        	 e.preventDefault();
             document.querySelectorAll(".popup_wrap.msg_box").forEach((e1) => e1.remove())
          });
     }

     const checkAge = (age) => {
         if (age.length < 2) return;
         let dob = age.substring(0, 2);
         let dobYear = (dob >= 50 ? '19' : '20') + dob ;
         let ageValid =  (new Date()).getFullYear() - dobYear;

         if(ageValid < 18 || ageValid > 70){
             Common.alert("This customer is not allowed to check Pre-CCP.");
             if($(".popup_wrap").length){
            	 closePop();
             }
             return;
         }
         return true;
     }

     const refreshDisplayInput = () => {

    	 let arrayRegCust = [];
    	 let regCust = document.querySelectorAll(".regCust");
    	 regCust.forEach((e) => arrayRegCust.push(e.value.length));

         if(arrayRegCust.every((r) =>  r==0)){
        	 regCust.forEach((e)=> e.style.borderColor ="#d2d2d2");
             return;
         }

  	     customerName = !FormUtil.isEmpty($("#customerName").val()) ? true : false;
         customerMobileNo = !FormUtil.isEmpty($("#customerMobileNo").val()) ? true : false;
         customerEmailAddr = !FormUtil.isEmpty($("#customerEmailAddr"))?checkEmail($("#customerEmailAddr").val()) : false;

         document.getElementById("customerNric").style.borderColor  = customerNric ? "green": "red";

         let lockBeforeIc = document.querySelectorAll(".lockBeforeIc");
         lockBeforeIc.forEach((e) => {
	     	   e.style.borderColor  ="#d2d2d2";
	     	   e.disabled  = customerNric ? false : true;
         });

          if(customerNric){
              document.getElementById("customerName").style.borderColor  = customerName ? "green": "red";
              document.getElementById("customerMobileNo").style.borderColor  = customerMobileNo ? "green": "red";
              document.getElementById("customerEmailAddr").style.borderColor  = customerEmailAddr ? "green": "red";
          }
     }


     const checkNric = () => {
    	  let customerNricArray =
	         [
	              FormUtil.isNotEmpty($("#customerNric").val())
	             , document.querySelector("#customerNric").value.length == 12
	             , checkAge($("#customerNric").val())
	         ];

          customerNric = !customerNricArray.some((r)=> !r);

          document.querySelector("#displayAlertMsg").style.display ="none";
          document.querySelector("#alertMsgContent").innerHTML = "";

          if(customerNric){
               fetch("/sales/ccp/chkExistCust.do?customerNric="+ $("#customerNric").val())
               .then(r=>r.json())
               .then(data=>{
                     customerNric = data.code =="99" ? true: false;
                     refreshDisplayInput();
                     if(!customerNric){
                         document.querySelector("#displayAlertMsg").style.display ="flex";
                         document.querySelector("#alertMsgContent").innerHTML = data.message;
                     }
               });
          }
          refreshDisplayInput();
     }

     const checkFormat = () => {

    	 $("#customerNric").unbind().bind("change keyup", function(e) {
    		 $(this).val($(this).val().replace(/[\D]/g,"").trim());
    		 checkNric();
    	 });

         $("#customerName").unbind().bind("change keyup", function(e){
        	 $(this).val($(this).val().replace(/[^A-Za-z\s]+/g, '').toUpperCase());
             refreshDisplayInput();
          });

         $("#customerMobileNo").unbind().bind("change keyup", function(e) {
             $(this).val($(this).val().replace(/[\D]/g,"").trim());
             refreshDisplayInput();
         });

         $("#customerEmailAddr").unbind().bind("change keyup", function(e) {
        	 $(this).val($(this).val().replace(/[^A-Za-z\s@_\d.]+/g, '').trim());
        	 $(this).val($(this).val().replace('/[^\u4E00-\u9FFF]+/u', '').trim());
        	 refreshDisplayInput();
         });
     }

     refreshDisplay();
     checkFormat();


     $("#registerCustomer").click((e)=>{
    	 e.preventDefault();
         div1Open = true;
         div2Open = false;
         refreshDisplay();
    });

     const submitPreccp = () => {
    	 Common.showLoader();
         fetch("/sales/ccp/submitPreCcpSubmission.do",
         {
             method: "POST",
             headers: {
                 "Content-Type" : "application/json",
             },
             body: JSON.stringify($("#form1").serializeJSON()),
         })
         .then(r=>{
             return r.json();
         }).
         then(data => {
            Common.removeLoader();
            Common.alert(data.message,reload);
            return;

        });
     }

     $("#btnSave").click((event)=>{
    	 event.preventDefault();
         document.querySelector("#displayAlertMsg").style.display ="none";
         document.querySelector("#alertMsgContent").innerHTML = "";
    	 let checkArray = [customerNric, customerName, customerMobileNo, customerEmailAddr];
    	 if(checkArray.every((r) =>  r==true)){

    		 if(!document.getElementById("chkDeclaration").checked){
    			 Common.alert("Please tick agent declaration note.");
    			 return;
    		 }

    		 fetch("/sales/ccp/chkDuplicated.do?customerMobileNo="+$("#customerMobileNo").val()+"&customerEmailAddr="+$("#customerEmailAddr").val())
    		 .then(r=>r.json())
    		 .then(data => {
    			 if(data.data.chkDuplicated == 0){
    				  submitPreccp();
    			 }else{
    				  document.querySelector("#displayAlertMsg").style.display ="flex";
                      document.querySelector("#alertMsgContent").innerHTML = "Customer Mobile No / Customer Email Address has been registered. Kindly please use another to proceed.";
    			 }
    		 });
    	 }else{
    		 Common.alert("Unable to submit Pre-CCP request. Kindly please fill in data completely.", checkNric);
    		 return;
    	 }
     });

     const resetFlag = () =>{
    	  customerNric = false;
    	  customerName = false;
    	  customerMobileNo = false;
    	  customerEmailAddr = false;
     }

     $("#btnClear").click(()=> {clearForm("form1"); resetFlag(); refreshDisplayInput()});


     <!-- DIV 2 - Send Consent -->
     let smsGrid ;

     const sendSms = (id,seq) => {
    	 document.getElementById(id).disabled = true;
    	 Common.showLoader();
    	 fetch("/sales/ccp/sendSms.do?preccpSeq=" + seq)
    	 .then(r=> r.json())
    	 .then(data=>{
    		 Common.removeLoader();
             if(data.code == "99") {
                 document.getElementById(id).checked = false;
                 document.getElementById(id).disabled = false;
             }
    		 Common.alert(data.message);
    	 })
     }

     $("#sendSms").click(()=>{
    	  div1Open = false;
          div2Open = true;
          AUIGrid.resize(smsGrid, 1200, 500);
          refreshDisplay();
     });

     smsGrid =  AUIGrid.create("smsGrid",
     [
          {headerText: 'Customer Name', dataField: 'custName', editable: false, width:250},
          {headerText: 'Pre-CCP Created Date' , dataField: 'crtDt', editable: false, width:200},
          {headerText: 'Member Code', dataField: 'memCode', editable: false, width:150},
          {headerText: 'Dept. Code', dataField: 'deptCode', editable: false, width:100},
          {headerText: 'Group Code', dataField: 'grpCode', editable: false, width:100},
          {headerText: 'Org. Code', dataField: 'orgCode', editable: false, width:100},
          {headerText: 'Send SMS', width:200,
        	renderer: {
              type: "TemplateRenderer",
           },
           labelFunction :  function (rowIndex, columnIndex, value, headerText, item){

        	   console.log(item.smsConsent);
        	   let inputReturn = '<div style="display:flex;justify-content: center;height:100%;">';

        	   for(let i=0; i < 3 ;i++){

        		   inputReturn += `<input id="smsConsent_` + item.preccpSeq +   `_`+ i +`"`;
        		   inputReturn += `type="checkbox" class="smsConsent" onclick="sendSms(`;
        		   inputReturn += `'smsConsent_` + item.preccpSeq +   `_`+ i +`',`;
        		   inputReturn += item.preccpSeq;
        		   inputReturn += `)"`;

        		   if(item.smsConsent ==1){
        			   if(item.smsCount > i){
                           inputReturn +=  ` checked `;
                       }
        			   inputReturn +=  ` disabled `;
                   }else{
                       if(item.smsCount > i){
                           inputReturn +=  ` checked disabled `;
                       }
                   }
        		   inputReturn +=`/>`;
        	   }

        	   inputReturn +='  </div>';
        	   return inputReturn;
           }},

          {headerText: 'Customer Respond', dataField: '' ,width:200}
     ] , '',
     {
         usePaging: true,
         pageRowCount: 50,
         editable: false,
         showRowNumColumn: true,
         wordWrap: true,
         showStateColumn: false
     });

     fetch("/sales/ccp/selectSmsConsentHistory.do")
     .then(resp => resp.json())
     .then(data => {
         data = data.map(i=>{
        	 return {...i}
         });
         AUIGrid.setGridData(smsGrid, data);
     })











 </script>