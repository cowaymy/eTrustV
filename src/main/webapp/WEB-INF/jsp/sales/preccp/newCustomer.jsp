<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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

	.my-yellow-style {
	    background:#fff2ca;
	    font-weight:bold;
	    color:#22741C;
	}

	.my-pink-style {
	    background:#ffc5c5;
	    font-weight:bold;
	    color:#22741C;
	}

	.my-green-style {
	    background:#e2f0d9;
	    font-weight:bold;
	    color:#22741C;
	}

	.borderIndicator{
	    display: flex;
	    align-items: center;
	    justify-content: center;
	    height: 30px;
	    flex: 1;
	    border-radius: 10px;
	    margin: 0 5px;
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
			<li><p class="btn_blue registerCustomer"><a id="registerCustomer">Register</a></p></li>
			<li><p class="btn_blue sendSms"><a id="sendSms">Send Consent</a></p></li>
			<li><p class="btn_blue preCcpResult"><a id="preCcpResult">Pre-CCP Result</a></p></li>
			<li><p class="btn_blue viewHistory"><a id="viewHistory">View History</a></p></li>
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
						<td><input type="text" class="w100p regCust" name="customerNric" id="customerNric" maxlength=12></td>
					</tr>
					<tr>
						<th>Customer Name</th>
						<td><input type="text" class="w100p regCust lockBeforeIc" name="customerName" id="customerName"></td>
					</tr>
					<tr>
						<th>Customer Mobile No</th>
						<td><input type="text" class="w100p regCust lockBeforeIc" name="customerMobileNo" id="customerMobileNo" maxlength=11></td>
					</tr>
					<tr>
						<th>Customer Email Address</th>
						<td><input type="text" class="w100p regCust lockBeforeIc" name="customerEmailAddr" id="customerEmailAddr"></td>
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

    <!-- Pre-CCP Result-->
    <div id="div3">
		    <form id="preCcpResultForm">
		        <table class="type1">
		            <colgroup>
		                <col style="width: 150px;"/>
		                <col style="width: *;"/>
		                <col style="width: 150px;"/>
		                <col style="width: *;"/>
		                <col style="width: 150px;"/>
                        <col style="width: *;"/>
		            </colgroup>
		            <tbody>
		                <tr>
		                    <th>Member Type</th>
		                    <td><input class="w100p" type="text" name="memberType" id="memberType"/></td>

                            <th>Customer Nric</th>
                            <td><input class="w100p" type="text" name="customerNric"/></td>

		                    <th>Pre-CCP Date</th>
		                    <td colspan="3">
		                        <div class="date_set w100p">
		                            <p><input name="start" id="start" type="text" value="" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
		                            <span>To</span>
		                            <p><input name="end" id="end" type="text" value="" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
		                        </div>
		                    </td>
		                </tr>

		                <tr>
		                    <th>Member Code</th>
		                    <td><input class="w100p" type="text" name="memberCode" id="memberCode"></td>

                            <th>Org Code</th>
                            <td><input class="w100p" type="text" name="orgCode" id="orgCode"></td>

                            <th>Grp Code</th>
                            <td><input class="w100p" type="text" name="grpCode" id="grpCode"></td>

                            <th>Dept Code</th>
                            <td><input class="w100p" type="text" name="deptCode" id="deptCode"></td>
		                </tr>
		            </tbody>
		        </table>
		    </form>
	        <ul class="right_btns">
	            <li><p class="btn_blue"><a id="searchPreCcpResult">Search</a></p></li>
	            <li><p class="btn_blue"><a id="clearPreCcpResult">Clear</a></p></li>
	        </ul>
	        <p>&nbsp;&nbsp;Pre-CCP Result Indicator</p>
	        <div style="display:flex;">
	           <div class="my-green-style borderIndicator">Allowed more than 2 units</div>
	           <div class="my-yellow-style borderIndicator">Limit to 1 unit only</div>
	           <div class="my-pink-style borderIndicator">Require Minimum 1 year Advance Payment</div>
	        </div>
		    <article class="grid_wrap">
                    <div id="preCcpResultGrid" style="width: 100%; height: 500px; margin: 0 auto;"></div>
            </article>
    </div>


    <!-- View History -->
    <div id="div4">
            <form id="viewHistoryForm">
                <table class="type1">
                    <colgroup>
                        <col style="width: 150px;"/>
                        <col style="width: *;"/>
                        <col style="width: 150px;"/>
                        <col style="width: *;"/>
                        <col style="width: 150px;"/>
                        <col style="width: *;"/>
                    </colgroup>
                    <tbody>
                        <tr>
                            <th>Org Code</th>
                            <td><input class="w100p checkViewHistory" type="text" name="orgCode" id="orgCode2"></td>

                            <th>Grp Code</th>
                            <td><input class="w100p checkViewHistory" type="text" name="grpCode" id="grpCode2"></td>

                            <th>Dept Code</th>
                            <td><input class="w100p checkViewHistory" type="text" name="deptCode" id="deptCode2"></td>
                        </tr>
                        <tr>
                            <th>Year</th>
                            <td><select class="w100p checkViewHistory" name="year" id="year"></select></td>

                            <th>Month</th>
                            <td><select class="w100p checkViewHistory" name="month" id="month"></select></td>
                            <th></th>
                            <td></td>
                        </tr>
                    </tbody>
                </table>
            </form>
            <ul class="right_btns">
                <li><p class="btn_blue"><a id="searchViewHistory">Search</a></p></li>
                <li><p class="btn_blue"><a id="clearViewHistory">Clear</a></p></li>
            </ul>
            <article class="grid_wrap">
                    <div id="viewHistoryGrid" style="width: 100%; height: 500px; margin: 0 auto;"></div>
            </article>

    </div>
</section>


<script>
     let div1Open = true, div2Open = false, div3Open =false, div4Open =false;

     const reload = () => {
         location.reload();
     }

     const refreshDisplay = () => {
         document.getElementById("div1").style.display = div1Open ? "": "none";
         document.getElementById("div2").style.display = div2Open ? "": "none";
         document.getElementById("div3").style.display = div3Open ? "": "none";
         document.getElementById("div4").style.display = div4Open ? "": "none";

         document.querySelector(".registerCustomer a").style.backgroundColor = !div1Open ? "#9ea9b4" : "rgb(37, 82, 124)";
         document.querySelector(".sendSms a").style.backgroundColor = !div2Open ? "#9ea9b4" : "rgb(37, 82, 124)";
         document.querySelector(".preCcpResult a").style.backgroundColor = !div3Open ? "#9ea9b4" : "rgb(37, 82, 124)";
         document.querySelector(".viewHistory a").style.backgroundColor = !div4Open ? "#9ea9b4" : "rgb(37, 82, 124)";
     }

     <!-- div1 - Register -->
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
         customerMobileNo = !FormUtil.isEmpty($("#customerMobileNo").val()) &&  $("#customerMobileNo").val().length >=10 ? true : false;
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
         div3Open = false;
         div4Open = false;
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


     <!-- div2 - Send Consent -->
     let smsGrid ;

     const sendSms = (id,seq) => {
    	 document.getElementById(id).disabled = true;
    	 Common.showLoader();
    	 fetch("/sales/ccp/sendWhatsApp.do?preccpSeq=" + seq)
    	 .then(r=> r.json())
    	 .then(data=>{
    		 Common.removeLoader();
             if(data.code == "99") {
                 document.getElementById(id).checked = false;
                 document.getElementById(id).disabled = false;
             }
    		 Common.alert(data.message, data.code =="99"? ()=>{location.reload()} : "");
    	 })
     }

     $("#sendSms").click(()=>{
    	  div1Open = false;
          div2Open = true;
          div3Open = false;
          div4Open = false;
          AUIGrid.resize(smsGrid, 1300, 500);
          refreshDisplay();
     });

     smsGrid =  GridCommon.createAUIGrid("smsGrid",
     [
          {headerText: 'Pre-CCP ID', dataField: 'preccpId' ,width:150},
          {headerText: 'Customer Name', dataField: 'custName', editable: false, width:250},
          {headerText: 'Send WhatsApp', width:120,
              renderer: {
                type: "TemplateRenderer",
             },
             labelFunction :  function (rowIndex, columnIndex, value, headerText, item){

                 let inputReturn = '<div style="display:flex;justify-content: center;height:100%;">';

                 for(let i=0; i < 3 ;i++){

                     inputReturn += `<input id="smsConsent_` + item.preccpSeq +   `_`+ i +`"`;
                     inputReturn += `type="checkbox" class="smsConsent" onclick="sendSms(`;
                     inputReturn += `'smsConsent_` + item.preccpSeq +   `_`+ i +`',`;
                     inputReturn += item.preccpSeq;
                     inputReturn += `)"`;

                     if(item.smsConsent == "Yes"){
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
          {headerText: 'Customer Respond', dataField: 'smsConsent' ,width:150},
          {headerText: 'Respond Time', dataField: 'updDt' ,width:150},
          {headerText: 'Pre-CCP Created Date' , dataField: 'crtDt', editable: false, width:150},
          {headerText: 'Member Code', dataField: 'memCode', editable: false, width:150},
          {headerText: 'Dept. Code', dataField: 'deptCode', editable: false, width:100},
          {headerText: 'Group Code', dataField: 'grpCode', editable: false, width:100},
          {headerText: 'Org. Code', dataField: 'orgCode', editable: false, width:100},
          {headerText: 'Tac Number', dataField: 'tacNo', editable: false, width:100, visible: false},
     ] , '',
     {
    	 usePaging : true,
         pageRowCount : 20,
         editable : false,
         wordWrap: false,
     });

     fetch("/sales/ccp/selectSmsConsentHistory.do")
     .then(resp => resp.json())
     .then(data => {
         data = data.map(i=>{
             return {...i}
         });
         AUIGrid.setGridData(smsGrid, data);
     });

     <!--div3 Pre-CCP Result-->
     const setOrganizationInfo = () => {
         if("${orgCode}") $("#orgCode").val("${orgCode}".trim());
         if("${grpCode}") $("#grpCode").val("${grpCode}".trim());
         if("${deptCode}") $("#deptCode").val("${deptCode}".trim());

         if("${orgCode}") $("#orgCode2").val("${orgCode}".trim());
         if("${grpCode}") $("#grpCode2").val("${grpCode}".trim());
         if("${deptCode}") $("#deptCode2").val("${deptCode}".trim());

         if("${memberType}") $("#memberType").val("${memberType}".trim());
         $("#memberType").attr("class", "w100p readonly");
         $("#memberType").attr("readonly", "readonly");

         switch("${SESSION_INFO.memberLevel}") {
         case "4":
             $("#orgCode").attr("class", "w100p readonly");
             $("#orgCode").attr("readonly", "readonly");
             $("#grpCode").attr("class", "w100p readonly");
             $("#grpCode").attr("readonly", "readonly");
             $("#deptCode").attr("class", "w100p readonly");
             $("#deptCode").attr("readonly", "readonly");

             $("#orgCode2").attr("class", "w100p readonly checkViewHistory");
             $("#orgCode2").attr("readonly", "readonly");
             $("#grpCode2").attr("class", "w100p readonly checkViewHistory");
             $("#grpCode2").attr("readonly", "readonly");
             $("#deptCode2").attr("class", "w100p readonly checkViewHistory");
             $("#deptCode2").attr("readonly", "readonly");

             if("${memCode}") $("#memberCode").val("${memCode}".trim());
             $("#memberCode").attr("class", "w100p readonly");
             $("#memberCode").attr("readonly", "readonly");
             break;
         case "3":
             $("#orgCode").attr("class", "w100p readonly");
             $("#orgCode").attr("readonly", "readonly");
             $("#grpCode").attr("class", "w100p readonly");
             $("#grpCode").attr("readonly", "readonly");
             $("#deptCode").attr("class", "w100p readonly");
             $("#deptCode").attr("readonly", "readonly");

             $("#orgCode2").attr("class", "w100p readonly checkViewHistory");
             $("#orgCode2").attr("readonly", "readonly");
             $("#grpCode2").attr("class", "w100p readonly checkViewHistory");
             $("#grpCode2").attr("readonly", "readonly");
             $("#deptCode2").attr("class", "w100p readonly checkViewHistory");
             $("#deptCode2").attr("readonly", "readonly");

             break;
         case "2":
             $("#orgCode").attr("class", "w100p readonly");
             $("#orgCode").attr("readonly", "readonly");
             $("#grpCode").attr("class", "w100p readonly");
             $("#grpCode").attr("readonly", "readonly");

             $("#orgCode2").attr("class", "w100p readonly checkViewHistory");
             $("#orgCode2").attr("readonly", "readonly");
             $("#grpCode2").attr("class", "w100p readonly checkViewHistory");
             $("#grpCode2").attr("readonly", "readonly");

             break;
         case "1":
             $("#orgCode").attr("class", "w100p readonly checkViewHistory");
             $("#orgCode").attr("readonly", "readonly");

             $("#orgCode2").attr("class", "w100p readonly checkViewHistory");
             $("#orgCode2").attr("readonly", "readonly");

             break;
         default:
             break;
           }
     }

     const preCcpResultGrid =   GridCommon.createAUIGrid('preCcpResultGrid',[
		{
		       dataField : 'custName', headerText : 'Customer Name'
		},
		{
		       dataField : 'searchBy', headerText : 'Search By', width: '20%'
		},
		{
		       dataField : 'deptCode', headerText : 'Dept. Code'
		},
		{
		       dataField : 'grpCode', headerText : 'Group Code',
		},
		{
		       dataField : 'orgCode', headerText : 'Org. Code'
		},
		{
		       dataField : 'preccpDate', headerText : 'Pre-CCP Date'
		},
		{
		       dataField : 'preccpResult', headerText : 'Pre-CCP Result'
		},
		{
		       dataField : 'salesKeyinDate', headerText : 'Sales Key-In Date'
		},
		{
		       dataField : 'ownSales', headerText : 'Own Sales'
		}],'',
		{
		       usePaging: true,
		       pageRowCount: 50,
		       editable: false,
		       showRowNumColumn: true,
		       wordWrap: true,
		       showStateColumn: false,
		       rowStyleFunction: (i, item) => {
		    	   switch(item.preccpResult) {
		    	       case "YELLOW":
		    	    	   return "my-yellow-style";
		    	    	   break;

	                    case "RED":
	                           return "my-pink-style";
	                           break;

                        case "GREEN":
                            return "my-green-style";
                            break;

                        default:
                        	break;
		    	   }
		       }
     });

     $("#preCcpResult").click(()=>{
         div1Open = false;
         div2Open = false;
         div3Open = true;
         div4Open = false;
         refreshDisplay();
         AUIGrid.resize(preCcpResultGrid, 1300, 500);
         setOrganizationInfo();
    });

     const validationPreccpResult = () => {
    	 if(FormUtil.isEmpty($("#start").val())){
    		 Common.alert("Please select Pre-CCP Start Date");
    		 return;
    	 }

         if(FormUtil.isEmpty($("#end").val())){
             Common.alert("Please select Pre-CCP End Date");
             return;
         }
         return true;
     }

     const generatePreCcpResult = () => {
         Common.showLoader();
         fetch("/sales/ccp/selectPreCcpResult.do?" + $("#preCcpResultForm").serialize())
         .then(resp => resp.json())
         .then(data => {
             Common.removeLoader();
             data = data.map(i=>{
                 return {...i}
             });
             AUIGrid.setGridData(preCcpResultGrid, data);
         });
     }

     $("#searchPreCcpResult").click((e)=>{
    	 e.preventDefault();
         if(validationPreccpResult()){
        	 generatePreCcpResult();
         }
     });

     $("#clearPreCcpResult").click((e)=>{
         e.preventDefault();
         document.getElementById("preCcpResultForm").reset();
         AUIGrid.clearGridData(preCcpResultGrid);
         setOrganizationInfo();
     });

     <!--div4 View History-->
     const viewHistoryGrid =   GridCommon.createAUIGrid('viewHistoryGrid',[
        {
               dataField : 'deptCode', headerText : 'Dept. Code'
        },
        {
               dataField : 'grpCode', headerText : 'Group Code',
        },
        {
               dataField : 'orgCode', headerText : 'Org. Code'
        },
        {
               dataField : 'noOfSearch', headerText : 'No. of Search'
        },
        {
               dataField : 'noOfSaleskeyin', headerText : 'No. of Sales Key-In'
        },
        {
               dataField : 'balance', headerText : 'Quota Balance'
        }],'',
        {
               usePaging: true,
               pageRowCount: 50,
               editable: false,
               showRowNumColumn: true,
               wordWrap: true,
               showStateColumn: false
     });

     const month = document.getElementById("month"), year = document.getElementById("year");

     const getYear = () =>{
         year.innerHTML = "";
         year.innerHTML += "<option value=''>Choose One</option>";
         fetch("/sales/ccp/selectYearList.do")
         .then(r=>r.json())
         .then(data=>{
             for(let i = 0; i < data.length; i++) {
                 const {codeName, codeId} = data[i]
                 year.innerHTML += "<option value='" + codeId + "'>" + codeName + "</option>"
             }
         })
     }

     const getMonth = () =>{
         month.innerHTML = "";
         month.innerHTML += "<option value=''>Choose One</option>";
         fetch("/sales/ccp/selectMonthList.do")
         .then(r=>r.json())
         .then(data=>{
             for(let i = 0; i < data.length; i++) {
                 const {codeName, codeId} = data[i]
                 month.innerHTML += "<option value='" + codeId + "'>" + codeName + "</option>"
             }
         })
     }

     const generateViewHistory = () => {
         Common.showLoader();
         fetch("/sales/ccp/selectViewHistory.do?" + $("#viewHistoryForm").serialize())
         .then(resp => resp.json())
         .then(data => {
             Common.removeLoader();
             AUIGrid.setGridData(viewHistoryGrid, data);
         });
     }

     $("#viewHistory").click(()=>{
         div1Open = false;
         div2Open = false;
         div3Open = false;
         div4Open = true;
         refreshDisplay();
         AUIGrid.resize(viewHistoryGrid, 1300, 500);
         setOrganizationInfo();
         getYear();
         getMonth();
    });

     $("#searchViewHistory").click((e)=>{
         e.preventDefault();

         let check = [...document.querySelectorAll(".checkViewHistory")].some(r=> {
             if(r.value.trim().length){
                 return true
              }
         });

         if(check){
        	 generateViewHistory();
         }else{
             Common.alert("Please fill in one of searching criteria.")
         }
     });

     $("#clearViewHistory").click((e)=>{
         e.preventDefault();
         document.getElementById("viewHistoryForm").reset();
         AUIGrid.clearGridData(viewHistoryGrid);
         setOrganizationInfo();
     });
 </script>