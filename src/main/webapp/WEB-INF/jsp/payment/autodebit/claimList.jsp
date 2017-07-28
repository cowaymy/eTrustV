<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
    
<script type="text/javaScript">

//AUIGrid 그리드 객체
var myGridID;

//Grid에서 선택된 RowID
var selectedGridValue;

//Default Combo Data
var claimTypeData = [{"codeId": "131","codeName": "Credit Card"},{"codeId": "132","codeName": "Direct Debit"},{"codeId": "134","codeName": "FPX"}];

//Status Combo Data
var statusData = [{"codeId": "1","codeName": "Active"},{"codeId": "4","codeName": "Completed"},{"codeId": "8","codeName": "Inactive"}];

//Issue Bank Combo Data
var bankData = [{"codeId": "2","codeName": "Alliance Bank"},
                {"codeId": "3","codeName": "CIMB Bank"},
                {"codeId": "5","codeName": "Hong Leong Bank"},
                {"codeId": "21","codeName": "Maybank"},
                {"codeId": "6","codeName": "Public Bank"},
                {"codeId": "7","codeName": "RHB Bank"},
                {"codeId": "9","codeName": "BSN Bank"}
                ];
                
//SMS Combo Data
var smsData = [{"codeId": "0","codeName": "No"}, {"codeId": "1","codeName": "Yes"}];                

//Claim Day  Data
var claimDayData = [{"codeId": "5","codeName": "5"},{"codeId": "10","codeName": "10"}];

// 화면 초기화 함수 (jQuery 의 $(document).ready(function() {}); 과 같은 역할을 합니다.
$(document).ready(function(){
	
	//메인 페이지
    doDefCombo(claimTypeData, '' ,'claimType', 'S', '');        //Claim Type 생성
    doDefCombo(statusData, '' ,'status', 'S', '');                 //Status 생성
    doDefCombo(bankData, '' ,'issueBank', 'S', '');               //Issue Bank 생성
    doDefCombo(smsData, '' ,'smsSend', 'S', '');                 //SMS Send 생성
    
    //New Result 팝업 페이지
    doDefCombo(claimTypeData, '' ,'new_claimType', 'S', '');        //Claim Type 생성
    doDefCombo(claimDayData, '' ,'new_claimDay', 'S', '');           //Claim Day 생성
    doDefCombo(bankData, '' ,'new_issueBank', 'S', '');               //Issue Bank 생성
    
   
    //Claim Type Combo 변경시 Issue Bank Combo 변경
    $('#claimType').change(function (){    	
    	if($(this).val() == 132){
    		$('#issueBank').val('');
    		$('#issueBank').attr("disabled",false);	
    	}else{
    		$('#issueBank').val('');
    		$('#issueBank').attr("disabled",true);
    	}
    });
    
    //Pop-Up Claim Type Combo 변경시 Claim Day, Issue Bank Combo 변경
    $('#new_claimType').change(function (){
    	
    	$('#new_claimDay').val('');
        $('#new_issueBank').val('');      
    	$('#new_claimDay').attr("disabled",true);
    	$('#new_issueBank').attr("disabled",true);    	
    	$('#new_debitDate').attr("placeholder","Debit Date");
    	
    	//NEW CLAIM 팝업에서 필수항목 표시 DEFAULT
        $("#claimDayMust").hide();
        $("#issueBankMust").hide();
    	
    	if($(this).val() == 131 || $(this).val() == 134){
    		$('#new_claimDay').attr("disabled",false);
    		$("#claimDayMust").show();
    		
    		if($(this).val() == 131 ){    			
    			$('#new_debitDate').attr("placeholder","Debit Date (Same Day)");
    		}    		
    	}else{
    		$('#new_issueBank').attr("disabled",false);
    		$("#issueBankMust").show();
    	}
        
    });
    
    //Pop-Up Issue Combo 변경시 
    $('#new_issueBank').change(function (){    	
    	$('#new_debitDate').attr("placeholder","Debit Date");
    	
    	switch($(this).val()){        
    	   case "2":
    		   $('#new_debitDate').attr("placeholder","Debit Date (+1 Day Send Same Day)");
    		   break;
    	   case "3":
    	   case "6":
               $('#new_debitDate').attr("placeholder","Debit Date (Same Day)");
               break;
    	   case "7":
    	   case "9" :
    	   case "21" :
               $('#new_debitDate').attr("placeholder","Debit Date (+1 Days)");
               break;    	   
           default :
        	   break;
    	}
    });
    
    //Grid Properties 설정 
    var gridPros = {            
            editable : false,                 // 편집 가능 여부 (기본값 : false)
            showStateColumn : false     // 상태 칼럼 사용
    };
    
    // Order 정보 (Master Grid) 그리드 생성
    myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,null,gridPros);
    
    // Master Grid 셀 클릭시 이벤트
    AUIGrid.bind(myGridID, "cellClick", function( event ){ 
        selectedGridValue = event.rowIndex;
    });
    
});

// AUIGrid 칼럼 설정
var columnLayout = [
    { dataField:"ctrlStusId" ,headerText:"Status ID",width: 120 ,visible : false, editable : false },
    { dataField:"stusName" ,headerText:"Status Name",width: 120 ,visible : false, editable : false },
    { dataField:"crtUserName" ,headerText:"Creator Name",width: 120 ,visible : false, editable : false },
    { dataField:"bankName" ,headerText:"Bank Name",width: 120 ,visible : false, editable : false },
    { dataField:"updDt" ,headerText:"Update Date",width: 120 ,visible : false, editable : false },
    { dataField:"ctrlTotSucces" ,headerText:"Success",width: 120 ,visible : false, editable : false },
    { dataField:"ctrlTotFail" ,headerText:"Fail",width: 120 ,visible : false, editable : false },
    
    { dataField:"ctrlId" ,headerText:"Batch Id",width: 120 ,editable : false },
    { dataField:"stusCode" ,headerText:"Status",width: 100 ,editable : false },
    { dataField:"ctrlIsCrc" ,headerText:"Type",width: 100 ,editable : false },
    { dataField:"bankCode" ,headerText:"Issue Bank",width: 100 ,editable : false },
    { dataField:"ctrlBatchDt" ,headerText:"Debit Date",width: 120 ,editable : false , dataType : "date", formatString : "dd-mm-yyyy"},
    { dataField:"ctrlTotItm" ,headerText:"Total Item",width: 120 ,editable : false },
    { dataField:"ctrlBillAmt" ,headerText:"Target Amt",width: 120 ,editable : false , dataType : "numeric", formatString : "#,##0.00"},
    { dataField:"ctrlBillPayAmt" ,headerText:"Receive Amt",width: 120 ,editable : false , dataType : "numeric", formatString : "#,##0.00"},
    { dataField:"crtDt" ,headerText:"Create Date",width: 200 ,editable : false },
    { dataField:"crtUserName" ,headerText:"Creator",width: 150 ,editable : false },
    { dataField:"ctrlFailSmsIsPump" ,headerText:"SMS ?",width: 100 ,editable : false ,
    	  labelFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
    		    var myString = "";
    		    
    		    if(value == 1){
    		    	myString = "Yes";    		    			    	
    		    }else{
    		    	myString = "No";                                    
    		    }
    		    return myString;
    	} 
    },
    { dataField:"ctrlWaitSync" ,headerText:"Wait Sync",width: 100 ,editable : false,
    	renderer : {
            type : "CheckBoxEditRenderer",            
            checkValue : "1",
            unCheckValue : "0"
        }    
    }
    ];
    
    
// 리스트 조회.
function fn_getClaimListAjax() {        
    Common.ajax("GET", "/payment/selectClaimList", $("#searchForm").serialize(), function(result) {
        AUIGrid.setGridData(myGridID, result);
    });
}

//View Claim Pop-UP
function fn_openDivPop(val){
	
	if(val == "VIEW" || val == "RESULT" || val == "RESULTNEXT" || val == "FILE"){
		
		var selectedItem = AUIGrid.getSelectedIndex(myGridID);
	    var ctrlId = AUIGrid.getCellValue(myGridID, selectedGridValue, "ctrlId");
	    var ctrlStusId = AUIGrid.getCellValue(myGridID, selectedGridValue, "ctrlStusId");
	    var stusName = AUIGrid.getCellValue(myGridID, selectedGridValue, "stusName");   
	    
		if (selectedItem[0] > -1){
			
			if((val == "RESULT" || val == "RESULTNEXT") && ctrlStusId != 1){
                Common.alert("<b>Batch [" + ctrlId + "] is under status [" + stusName + "].<br />" +
                        "Only [Active] batch is allowed to update claim result.</b>");   
			}else if(val == "FILE" && ctrlStusId != 1){
				Common.alert("<b>Batch [" + ctrlId + "] is under status [" + stusName + "].<br />" +
					    "Only [Active] batch is allowed to re-generate claim file.</b>");
			}else{
			
	            $("#view_wrap").show();
	            $("#new_wrap").hide();
	            
	            $("#view_batchId").text(AUIGrid.getCellValue(myGridID, selectedGridValue, "ctrlId"));
	            $("#view_status").text(AUIGrid.getCellValue(myGridID, selectedGridValue, "stusName"));
	            $("#view_type").text(AUIGrid.getCellValue(myGridID, selectedGridValue, "ctrlIsCrc"));
	            $("#view_creator").text(AUIGrid.getCellValue(myGridID, selectedGridValue, "crtUserName"));
	            $("#view_issueBank").text(AUIGrid.getCellValue(myGridID, selectedGridValue, "bankCode") + ' - ' + AUIGrid.getCellValue(myGridID, selectedGridValue, "bankName"));
	            $("#view_createDt").text(AUIGrid.getCellValue(myGridID, selectedGridValue, "crtDt"));
	            $("#view_totalItem").text(AUIGrid.getCellValue(myGridID, selectedGridValue, "ctrlTotItm"));
	            $("#view_debitDate").text(AUIGrid.getCellValue(myGridID, selectedGridValue, "ctrlBatchDt"));
	            $("#view_targetAmount").text(AUIGrid.getCellValue(myGridID, selectedGridValue, "ctrlBillAmt"));
	            $("#view_updator").text(AUIGrid.getCellValue(myGridID, selectedGridValue, "crtUserName"));
	            $("#view_receiveAmount").text(AUIGrid.getCellValue(myGridID, selectedGridValue, "ctrlBillPayAmt"));
	            $("#view_updateDate").text(AUIGrid.getCellValue(myGridID, selectedGridValue, "updDt"));
	            $("#view_totalSuccess").text(AUIGrid.getCellValue(myGridID, selectedGridValue, "ctrlTotSucces"));
	            $("#view_totalFail").text(AUIGrid.getCellValue(myGridID, selectedGridValue, "ctrlTotFail"));
			}
			
			//팝업 헤더 TEXT 및 버튼 설정
			if(val == "VIEW"){
			    $('#pop_header h1').text('VIEW CLAIM');			
			    $('#center_btns1').hide();
			    $('#center_btns2').hide();			
			    $('#center_btns3').hide();
			
			}else if(val == "RESULT"){
				$('#pop_header h1').text('CLAIM RESULT');				
				$('#center_btns1').show();
                $('#center_btns2').hide();
                $('#center_btns3').hide();
                
			}else if(val == "RESULTNEXT"){
                $('#pop_header h1').text('CLAIM RESULT(NEXT DAY)');
                $('#center_btns1').hide();
                $('#center_btns2').show();
                $('#center_btns3').hide();
                
            }else if (val == "FILE"){
                $('#pop_header h1').text('CLAIM FILE GENERATOR');                
                $('#center_btns1').hide();
                $('#center_btns2').hide();
                $('#center_btns3').show();
            }
			
        }else{
             Common.alert('No claim record selected.');
        }
	}else{
		$("#view_wrap").hide();
		$("#new_wrap").show();	
		
		//NEW CLAIM 팝업에서 필수항목 표시 DEFAULT
		$("#claimDayMust").hide();
		$("#issueBankMust").hide();
		
	}
}

//Layer close
hideViewPopup=function(val){
    $(val).hide();    
}

// Pop-UP 에서 Deactivate 처리
function fn_deactivate(){
	Common.confirm('<b>Are you sure want to deactivate this claim batch ?</b>',function (){
	    var ctrlId = AUIGrid.getCellValue(myGridID, selectedGridValue, "ctrlId");
	    
	    //param data array
	    var data = {};
	    data.form = [{"ctrlId":ctrlId}];
	    
	    Common.ajax("POST", "/payment/updateDeactivate.do", data, function(result) {
	    	Common.alert("<b>This claim batch has been deactivated.</b>");  
	        
	        $("#view_batchId").text(result[0].ctrId);
	        $("#view_status").text(result[0].stusName);
	        $("#view_type").text(result[0].ctrlIsCrc);
	        $("#view_creator").text(result[0].crtUserName);
	        $("#view_issueBank").text(result[0].bankCode + ' - ' + result[0].bankName);
	        $("#view_createDt").text(result[0].crtDt);
	        $("#view_totalItem").text(result[0].ctrlTotItm);
	        $("#view_debitDate").text(result[0].ctrlBatchDt);
	        $("#view_targetAmount").text(result[0].ctrlBillAmt);
	        $("#view_updator").text(result[0].crtUserName);
	        $("#view_receiveAmount").text(result[0].ctrlBillPayAmt);
	        $("#view_updateDate").text(result[0].updDt);
	        $("#view_totalSuccess").text(result[0].ctrlTotSucces);
	        $("#view_totalFail").text(result[0].ctrlTotFail);
	        
	        $('#pop_header h1').text('VIEW CLAIM');
	        $('#center_btns').hide();
	    },function(result) {
	        Common.alert("<b>Failed to deactivate this claim batch.<br />Please try again later.</b>");   
	    });		
	});
}


//NEW CLAIM Pop-UP 에서 Generate Claim 처리
function fn_genClaim(){
	
	if($("#new_claimType option:selected").val() == ''){
		Common.alert("* Please select the claim type.<br />");
		return;
	}else{
		
		 if ($("#new_claimType option:selected").val() == "131" || $("#new_claimType option:selected").val() == "134") {             
			 if ($("#new_claimDay option:selected").val() == '' ) {
				 Common.alert("* Please select the claim day.<br />");
                 return;                 
             }
         } else if ($("#new_claimType option:selected").val() == "132") {
             if ($("#new_issueBank option:selected").val() == '') {
            	 Common.alert("* Please select the issue bank.<br />");
                 return;                 
             }
         }		
	}
	
	if($("#new_debitDate").val() == ''){
		Common.alert("* Please insert the debit date.<br />");
        return;
	}
	
	//저장 처리
	var data = {};
    var formList = $("#newForm").serializeArray();       //폼 데이터
    
    if(formList.length > 0) data.form = formList;
    else data.form = [];
    
	
	Common.ajax("POST", "/payment/generateNewClaim.do", data, 
			function(result) {
		         Common.alert("<b>This claim batch has been deactivated.</b>");
		   
	       },
	       function(result) {
                 Common.alert("<b>Failed to deactivate this claim batch.<br />Please try again later.</b>");   
           }
	);
}

//NEW CLAIM Pop-UP 에서 Generate Claim 처리
function fn_createFile(){
	
	var ctrlId = AUIGrid.getCellValue(myGridID, selectedGridValue, "ctrlId");
	
	//param data array
    var data = {};
    data.form = [{"ctrlId":ctrlId}];
    
    Common.ajax("POST", "/payment/createClaimFile.do", data,  
            function(result) {
                 Common.alert("<b>Claim file has successfully created.</b>");
           
           },
           function(result) {
                 Common.alert("<b>Failed to generate claim file. Please try again later.</b>");   
           }
    );
	
}


</script>

<!-- content start -->
<section id="content">
    <ul class="path">
        <li><img src="/resources/images/common/path_home.gif" alt="Home" /></li>
        <li>Payment</li>
        <li>Auto Debit</li>
        <li>Claim</li>
    </ul>

    <!-- title_line start -->
    <aside class="title_line">
        <p class="fav"><a href="#" class="click_add_on">My menu</a></p>
        <h2>Claim List</h2>
        <ul class="right_btns">
            <li><p class="btn_blue"><a href="javascript:fn_getClaimListAjax();"><span class="search"></span>Search</a></p></li>
        </ul>
    </aside>
    <!-- title_line end -->

    <!-- search_table start -->
    <section class="search_table">
        <form name="searchForm" id="searchForm"  method="post">

            <table class="type1"><!-- table start -->
                <caption>table</caption>
                <colgroup>
                    <col style="width:140px" />
                    <col style="width:*" />
                    <col style="width:130px" />
                    <col style="width:*" />
                    <col style="width:170px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">Batch ID</th>
                        <td>
                            <input id="batchId" name="batchId" type="text" title="BatchID" placeholder="Batch ID" class="w100p" />
                        </td>
                        <th scope="row">Creator</th>
                        <td>
                           <input id="creator" name="creator" type="text" title="Creator" placeholder="Creator (Username)" class="w100p" />
                        </td>
                        <th scope="row">Create Date</th>
                        <td>
                            <!-- date_set start -->
                            <div class="date_set w100p">
                                <p><input id="createDt1" name="createDt1" type="text" title="Create Date From" placeholder="dd/MM/yyyy" class="j_date" readonly /></p>
                                <span>~</span>
                                <p><input id="createDt2" name="createDt2" type="text" title="Create Date To" placeholder="dd/MM/yyyy" class="j_date" readonly /></p>
                            </div>
                            <!-- date_set end -->
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Claim Type</th>
                        <td>
                            <select id="claimType" name="claimType" class="w100p"></select>                           
                        </td>
                       <th scope="row">Status</th>
                        <td>
                           <select id="status" name="status" class="w100p"></select>
                        </td>
                        <th scope="row">Debit Date</th>
                        <td>
                           <!-- date_set start -->
                            <div class="date_set w100p">
                                <p><input id="debitDt1" name="debitDt1" type="text" title="Debit Date From" placeholder="dd/MM/yyyy" class="j_date" readonly /></p>
                                <span>~</span>
                                <p><input id="debitDt2" name="debitDt2" type="text" title="Debit Date To" placeholder="dd/MM/yyyy" class="j_date" readonly /></p>
                            </div>
                            <!-- date_set end -->
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Issue Bank</th>
                        <td>
                           <select id="issueBank" name="issueBank" class="w100p"></select>
                        </td>
                        <th scope="row">SMS Send</th>
                        <td>
                            <select id="smsSend" name="smsSend" class="w100p"></select>
                        </td>
                        <th scope="row">Wait For Sync</th>
                        <td>
                            <input type="checkbox" />
                        </td>
                    </tr>
                </tbody>
            </table>
            <!-- table end -->

            <!-- link_btns_wrap start -->
            <aside class="link_btns_wrap">
                <p class="show_btn"><a href="#"><img src="/resources/images/common/btn_link.gif" alt="link show" /></a></p>
                <dl class="link_list">
                    <dt>Link</dt>
                    <dd>
                    <ul class="btns">
                        <li><p class="link_btn"><a href="javascript:fn_openDivPop('VIEW');">View Claim</a></p></li>
                        <li><p class="link_btn"><a href="javascript:fn_openDivPop('NEW');">New Claim</a></p></li>
                        <li><p class="link_btn"><a href="javascript:fn_openDivPop('RESULT');">Claim Result(Live)</a></p></li>
                        <li><p class="link_btn"><a href="javascript:fn_openDivPop('RESULTNEXT');">Claim Result(Next Day)</a></p></li>
                        <li><p class="link_btn"><a href="javascript:fn_openDivPop('FILE');">Re-Generate Claim File</a></p></li>
                        <li><p class="link_btn"><a href="#">Schedule Setting</a></p></li>
                        <li><p class="link_btn"><a href="#">Schedule Claim Batch</a></p></li>
                        <li><p class="link_btn"><a href="#">Fail Deduction SMS</a></p></li>
                        <li><p class="link_btn"><a href="#">Enrollment List</a></p></li>                                               
                    </ul>
                    <ul class="btns">                       
                    </ul>
                    <p class="hide_btn"><a href="#"><img src="/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
                    </dd>
                </dl>
            </aside>
            <!-- link_btns_wrap end -->
        </form>
    </section>
    <!-- search_table end -->

    <!-- search_result start -->
    <section class="search_result">     

        <!-- grid_wrap start -->
        <article id="grid_wrap" class="grid_wrap"></article>
        <!-- grid_wrap end -->

    </section>
    <!-- search_result end -->

</section>
<!-- content end --> 


<!------------------------------------------------------------------------------------- 
    POP-UP (VIEW CLAIM / RESULT (Live) / RESULT (NEXT DAY) / FILE GENERATOR  
-------------------------------------------------------------------------------------->
<!-- popup_wrap start -->
<div class="popup_wrap" id="view_wrap" style="display:none;">
    <!-- pop_header start -->
    <header class="pop_header" id="pop_header">
        <h1></h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" onclick="hideViewPopup('#view_wrap')">CLOSE</a></p></li>
        </ul>
    </header>
    <!-- pop_header end -->
    
    <!-- pop_body start -->
    <section class="pop_body">
        <!-- search_table start -->
        <section class="search_table">
            <!-- table start -->
            <table class="type1">
                <caption>table</caption>
                 <colgroup>
	                <col style="width:165px" />
	                <col style="width:*" />
	                <col style="width:165px" />
	                <col style="width:*" />
                </colgroup>
                <tbody>
	                <tr>
	                    <th scope="row">Batch ID</th>
	                    <td id="view_batchId"></td>
	                    <th scope="row">Status</th>
	                    <td id="view_status"></td>
	                </tr>
	                 <tr>
	                    <th scope="row">Type</th>
	                    <td id="view_type"></td>
	                    <th scope="row">Creator</th>
	                    <td id="view_creator"></td>
	                </tr>
	                 <tr>
	                    <th scope="row">Issue Bank</th>
	                    <td id="view_issueBank"></td>
	                    <th scope="row">Create Date</th>
	                    <td id="view_createDt"></td>
	                </tr>
	                <tr>
	                    <th scope="row">Total Item</th>
	                    <td id="view_totalItem"></td>
	                    <th scope="row">Debit Date</th>
	                    <td id="view_debitDate"></td>
	                </tr>
	                <tr>
	                    <th scope="row">Target Amount</th>
	                    <td id="view_targetAmount"></td>
	                    <th scope="row">Updator</th>
	                    <td id="view_updator"></td>
	                </tr>
	                <tr>
	                    <th scope="row">Receive Amount</th>
	                    <td id="view_receiveAmount"></td>
	                    <th scope="row">Update Date</th>
	                    <td id="view_updateDate"></td>
	                </tr>
	                <tr>
	                    <th scope="row">Total Success</th>
	                    <td id="view_totalSuccess"></td>
	                    <th scope="row">Total Fail</th>
	                    <td id="view_totalFail"></td>
	                </tr> 
                </tbody>
            </table>
        </section>
        <!-- search_table end -->

        <ul class="center_btns" id="center_btns1">
            <li><p class="btn_blue2"><a href="javascript:fn_deactivate();">Deactivate</a></p></li>
            <li><p class="btn_blue2"><a href="#">Update Result</a></p></li>
        </ul>
        
        <ul class="center_btns" id="center_btns2">
            <li><p class="btn_blue2"><a href="javascript:fn_deactivate();">Deactivate</a></p></li>
            <li><p class="btn_blue2"><a href="#">Update Result</a></p></li>
        </ul>
        
         <ul class="center_btns" id="center_btns3">
            <li><p class="btn_blue2"><a href="javascript:fn_createFile();">Generate File</a></p></li>
        </ul>
    </section>
    <!-- pop_body end -->
</div>
<!-- popup_wrap end -->


<!--------------------------------------------------------------- 
    POP-UP (NEW CLAIM)
---------------------------------------------------------------->
<!-- popup_wrap start -->
<div class="popup_wrap" id="new_wrap" style="display:none;">
    <!-- pop_header start -->
    <header class="pop_header" id="new_pop_header">
        <h1>NEW CLAIM</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" onclick="hideViewPopup('#new_wrap')">CLOSE</a></p></li>
        </ul>
    </header>
    <!-- pop_header end -->
    
    <!-- pop_body start -->
    <form name="newForm" id="newForm"  method="post">
    <section class="pop_body">
        <!-- search_table start -->
        <section class="search_table">
            <!-- table start -->
            <table class="type1">
                <caption>table</caption>
                 <colgroup>
                    <col style="width:165px" />
                    <col style="width:*" />
                    <col style="width:165px" />
                    <col style="width:*" />
                </colgroup>
                
                <tbody>
                    <tr>
                        <th scope="row">Claim Type <span class="must">*</span></th>
                        <td>
                            <select id="new_claimType" name="new_claimType" class="w100p"></select>
                        </td>
                        <th scope="row">Claim Day <span class="must" id="claimDayMust">*</span></th>
                        <td>
                            <select id="new_claimDay" name="new_claimDay" class="w100p" disabled></select>
                        </td>
                    </tr>
                     <tr>
                        <th scope="row">Issue Bank <span class="must" id="issueBankMust">*</span></th>                            
                        <td>
                            <select id="new_issueBank" name="new_issueBank" class="w100p" disabled></select>
                        </td>
                        <th scope="row">Debit Date <span class="must">*</span></th>
                        <td>
                            <input type="text" id="new_debitDate" name="new_debitDate" title="Debit Date" placeholder="Debit Date" class="j_date w100p" />                            
                        </td>
                    </tr>
                   </tbody>  
            </table>
        </section>
        <!-- search_table end -->
        
        <ul class="center_btns">
            <li><p class="btn_blue2"><a href="javascript:fn_genClaim();">Generate Claim</a></p></li>
        </ul>
    </section>
    </form>       
    <!-- pop_body end -->
</div>
<!-- popup_wrap end -->