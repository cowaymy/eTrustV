<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
    
<script type="text/javaScript">

//AUIGrid 그리드 객체
var myGridID,updResultGridID,smsGridID;

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
            showStateColumn : false,     // 상태 칼럼 사용
            softRemoveRowMode:false
    };
    
    // Order 정보 (Master Grid) 그리드 생성
    myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,null,gridPros);
    updResultGridID = GridCommon.createAUIGrid("updResult_grid_wrap", updResultColLayout,null,gridPros);
    smsGridID = GridCommon.createAUIGrid("sms_grid_wrap", smsColLayout,null,gridPros);
    
    // Master Grid 셀 클릭시 이벤트
    AUIGrid.bind(myGridID, "cellClick", function( event ){ 
        selectedGridValue = event.rowIndex;
    });
    
    // HTML5 브라우저인지 체크 즉, FileReader 를 사용할 수 있는지 여부
    function checkHTML5Brower() {
        var isCompatible = false;
        if (window.File && window.FileReader && window.FileList && window.Blob) {
            isCompatible = true;
        }
        return isCompatible;
    };
    
    // 파일 선택하기
    $('#fileSelector').on('change', function(evt) {
        if (!checkHTML5Brower()) {
            // 브라우저가 FileReader 를 지원하지 않으므로 Ajax 로 서버로 보내서
            // 파일 내용 읽어 반환시켜 그리드에 적용.
            commitFormSubmit();
            
            //alert("브라우저가 HTML5 를 지원하지 않습니다.");
        } else {
            var data = null;
            var file = evt.target.files[0];
            if (typeof file == "undefined") {
                return;
            }
            var reader = new FileReader();
            //reader.readAsText(file); // 파일 내용 읽기
            reader.readAsText(file, "EUC-KR"); // 한글 엑셀은 기본적으로 CSV 포맷인 EUC-KR 임. 한글 깨지지 않게 EUC-KR 로 읽음
            reader.onload = function(event) {
                if (typeof event.target.result != "undefined") {
                    // 그리드 CSV 데이터 적용시킴
                    AUIGrid.setCsvGridData(updResultGridID, event.target.result, false);
                    
                    //csv 파일이 header가 있는 파일이면 첫번째 행(header)은 삭제한다.
                    AUIGrid.removeRow(updResultGridID,0);
                } else {
                    alert('No data to import!');
                }
            };
            reader.onerror = function() {
                alert('Unable to read ' + file.fileName);
            };
        }
    
        });
    

  //HTML5 브라우저 즉, FileReader 를 사용 못할 경우 Ajax 로 서버에 보냄
  //서버에서 파일 내용 읽어 반환 한 것을 통해 그리드에 삽입
  //즉, 이것은 IE 10 이상에서는 불필요 (IE8, 9 에서만 해당됨)
  function commitFormSubmit() {
   
   AUIGrid.showAjaxLoader(updResultGridID);
   
   // Submit 을 AJax 로 보내고 받음.
   // ajaxSubmit 을 사용하려면 jQuery Plug-in 인 jquery.form.js 필요함
   // 링크 : http://malsup.com/jquery/form/
   
   $('#updResultForm').ajaxSubmit({
       type : "json",
       success : function(responseText, statusText) {
           if(responseText != "error") {
               
               var csvText = responseText;
               
               // 기본 개행은 \r\n 으로 구분합니다.
               // Linux 계열 서버에서 \n 으로 구분하는 경우가 발생함.
               // 따라서 \n 을 \r\n 으로 바꿔서 그리드에 삽입
               // 만약 서버 사이드에서 \r\n 으로 바꿨다면 해당 코드는 불필요함. 
               csvText = csvText.replace(/\r?\n/g, "\r\n")
               
               // 그리드 CSV 데이터 적용시킴
               AUIGrid.setCsvGridData(updResultGridID, csvText);
               
               AUIGrid.removeAjaxLoader(updResultGridID);
               
             //csv 파일이 header가 있는 파일이면 첫번째 행(header)은 삭제한다.
               AUIGrid.removeRow(updResultGridID,0);
           }
       },
       error : function(e) {
           alert("ajaxSubmit Error : " + e);
       }
   });
   
   }
});


// AUIGrid 칼럼 설정
var columnLayout = [
    { dataField:"ctrlId" ,headerText:"Batch Id",width: 120 ,editable : false },
    { dataField:"stusCode" ,headerText:"Status",width: 100 ,editable : false },
    { dataField:"ctrlIsCrcName" ,headerText:"Type",width: 100 ,editable : false },
    { dataField:"bankCode" ,headerText:"Issue Bank",width: 100 ,editable : false },
    { dataField:"ctrlBatchDt" ,headerText:"Debit Date",width: 120 ,editable : false},
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
    },
    { dataField:"ctrlStusId" ,headerText:"Status ID",width: 120 ,visible : false, editable : false },
    { dataField:"stusName" ,headerText:"Status Name",width: 120 ,visible : false, editable : false },
    { dataField:"crtUserName" ,headerText:"Creator Name",width: 120 ,visible : false, editable : false },
    { dataField:"bankName" ,headerText:"Bank Name",width: 120 ,visible : false, editable : false },
    { dataField:"updDt" ,headerText:"Update Date",width: 120 ,visible : false, editable : false },
    { dataField:"ctrlTotSucces" ,headerText:"Success",width: 120 ,visible : false, editable : false },
    { dataField:"ctrlTotFail" ,headerText:"Fail",width: 120 ,visible : false, editable : false },
    { dataField:"ctrlIsCrc" ,headerText:"ctrlIsCrc",width: 120 ,visible : false, editable : false },
    { dataField:"bankId" ,headerText:"bankId",width: 120 ,visible : false, editable : false },
    ];
    
var updResultColLayout = [ 
                    {         
                        dataField : "0",
                        headerText : "RefNo",
                        editable : true
                    },{
                        dataField : "1",
                        headerText : "RefCode",
                        editable : true
                    },{
                        dataField : "2",
                        headerText : "ItemID.",
                        editable : true
                    }];  

var smsColLayout = [ 
                    { dataField:"bankDtlApprCode" ,headerText:"Approval Code",width: 150 ,editable : false },
                    { dataField:"salesOrdNo" ,headerText:"Order No",width: 150 ,editable : false },
                    { dataField:"bankDtlDrAccNo" ,headerText:"Account No",width: 150 ,editable : false },
                    { dataField:"bankDtlDrName" ,headerText:"Name",width: 150 ,editable : false },
                    { dataField:"bankDtlDrNric" ,headerText:"NRIC",width: 150 ,editable : false },
                    { dataField:"bankDtlAmt" ,headerText:"Claim Amt",width: 150 ,editable : false },
                    { dataField:"bankDtlRenAmt" ,headerText:"Rent Amt",width: 150 ,editable : false },
                    { dataField:"bankDtlRptAmt" ,headerText:"Penalty Amt",width: 150 ,editable : false }      
                          ];   
                          
// 리스트 조회.
function fn_getClaimListAjax() {        
    Common.ajax("GET", "/payment/selectClaimList", $("#searchForm").serialize(), function(result) {
        AUIGrid.setGridData(myGridID, result);
    });
}

//View Claim Pop-UP
function fn_openDivPop(val){
	
	if(val == "VIEW" || val == "RESULT" || val == "RESULTNEXT" || val == "FILE" || val == "SMS"){
		
		var selectedItem = AUIGrid.getSelectedIndex(myGridID);
	    
	    if (selectedItem[0] > -1){
		
	    	var ctrlId = AUIGrid.getCellValue(myGridID, selectedGridValue, "ctrlId");
	        var ctrlStusId = AUIGrid.getCellValue(myGridID, selectedGridValue, "ctrlStusId");
	        var stusName = AUIGrid.getCellValue(myGridID, selectedGridValue, "stusName");
	        var smsSend = AUIGrid.getCellValue(myGridID, selectedGridValue, "ctrlFailSmsIsPump");
	        
	        if((val == "RESULT" || val == "RESULTNEXT") && ctrlStusId != 1){
                Common.alert("<b>Batch [" + ctrlId + "] is under status [" + stusName + "].<br />" +
                        "Only [Active] batch is allowed to update claim result.</b>");   
			}else if(val == "FILE" && ctrlStusId != 1){
				Common.alert("<b>Batch [" + ctrlId + "] is under status [" + stusName + "].<br />" +
					    "Only [Active] batch is allowed to re-generate claim file.</b>");
			}else if(val == "SMS" && ctrlStusId != 4){
                Common.alert("<b>Batch [" + ctrlId + "] is under status [" + stusName + "].<br />" +
                "Only [Completed] batch is allowed to send failed deduction SMS.</b>");
            }else if(val == "SMS" && smsSend == 1){
                Common.alert("<b>Failed deduction SMS process for batch [" + ctrlId + "] was completed.</b>");
            }else{
            	
            	$('#sms_grid_wrap').hide();
            	
            	
            	Common.ajax("GET", "/payment/selectClaimMasterById.do", {"batchId":ctrlId}, function(result) {
            		$("#view_wrap").show();
                    $("#new_wrap").hide();                    
                
                    $("#view_batchId").text(result.ctrlId);
                    $("#view_status").text(result.stusName);
                    $("#view_type").text(result.ctrlIsCrcName);
                    $("#view_creator").text(result.crtUserName);
                    $("#view_issueBank").text(result.bankCode + ' - ' + result.bankName);
                    $("#view_createDt").text(result.crtDt);
                    $("#view_totalItem").text(result.ctrlTotItm);
                    $("#view_debitDate").text(result.ctrlBatchDt);
                    $("#view_targetAmount").text(result.ctrlBillAmt);
                    $("#view_updator").text(result.crtUserName);
                    $("#view_receiveAmount").text(result.ctrlBillPayAmt);
                    $("#view_updateDate").text(result.updDt);
                    $("#view_totalSuccess").text(result.ctrlTotSucces);
                    $("#view_totalFail").text(result.ctrlTotFail);
            	});  
            	
            	
            	if(val == "SMS"){
            		$('#sms_grid_wrap').show();
            		
            		  Common.ajax("GET", "/payment/selectFailClaimDetailList.do", {"batchId":ctrlId}, function(result) {
            			  AUIGrid.setGridData(smsGridID, result);
            			  AUIGrid.resize(smsGridID);
                      });  
            	}    
            		
            			
            			     
            
			}
			
			//팝업 헤더 TEXT 및 버튼 설정
			if(val == "VIEW"){
			    $('#pop_header h1').text('VIEW CLAIM');			
			    $('#center_btns1').hide();
			    $('#center_btns2').hide();			
			    $('#center_btns3').hide();
			    $('#center_btns4').hide();
			
			}else if(val == "RESULT"){
				$('#pop_header h1').text('CLAIM RESULT');				
				$('#center_btns1').show();
                $('#center_btns2').hide();
                $('#center_btns3').hide();
                $('#center_btns4').hide();
                
			}else if(val == "RESULTNEXT"){
                $('#pop_header h1').text('CLAIM RESULT(NEXT DAY)');
                $('#center_btns1').hide();
                $('#center_btns2').show();
                $('#center_btns3').hide();
                $('#center_btns4').hide();
                
            }else if (val == "FILE"){
                $('#pop_header h1').text('CLAIM FILE GENERATOR');                
                $('#center_btns1').hide();
                $('#center_btns2').hide();
                $('#center_btns3').show();
                $('#center_btns4').hide();
            
            } else if (val == "SMS"){
                $('#pop_header h1').text('FAILED DEDUCTION SMS');                
                $('#center_btns1').hide();
                $('#center_btns2').hide();
                $('#center_btns3').hide();
                $('#center_btns4').show();
            }
			
        }else{
             Common.alert('No claim record selected.');
        }
	}else{
		$("#view_wrap").hide();
		$("#new_wrap").show();	
				
		//NEW CLAIM 팝업에서 필수항목 표시 DEFAULT
		$("#newForm")[0].reset();
		$("#claimDayMust").hide();
		$("#issueBankMust").hide();		
	}
}

//Layer close
hideViewPopup=function(val){
	//AUIGrid.destroy(updResultGridID);
	//AUIGrid.destroy(smsGridID); 	
	$('#sms_grid_wrap').hide();	
    $(val).hide();
}

// Pop-UP 에서 Deactivate 처리
function fn_deactivate(){
	Common.confirm('<b>Are you sure want to deactivate this claim batch ?</b>',function (){
	    var ctrlId = AUIGrid.getCellValue(myGridID, selectedGridValue, "ctrlId");
	    
	    Common.ajax("GET", "/payment/updateDeactivate.do", {"ctrlId":ctrlId}, function(result) {
	    	Common.alert("<b>This claim batch has been deactivated.</b>","fn_openDivPop('VIEW')");
	    	
	    },function(result) {
	        Common.alert("<b>Failed to deactivate this claim batch.<br />Please try again later.</b>");   
	    });
	});
}

//Pop-UP 에서 Fail Deduction SMS 처리
function fn_sendFailDeduction(){
	   var ctrlId = AUIGrid.getCellValue(myGridID, selectedGridValue, "ctrlId");
	   
	   Common.ajax("GET", "/payment/sendFaileDeduction.do", {"ctrlId":ctrlId}, function(result) {
            Common.alert("<b>SMS successfully added into sending list.</b>",function () {fn_openDivPop('VIEW'); });
            
        },function(result) {
            Common.alert("<b>Failed to send SMS. Please try again later.</b>");   
        });
    
}



var updateResultItemKind = "";      //claim result update시 구분 (LIVE :current / NEXT : batch)

//Pop-UP 에서 Update Result 버튼 클릭시 팝업창 생성
function fn_updateResult(val){
	updateResultItemKind = val;
	$("#updResult_wrap").show();  
}

//Result Update Pop-UP 에서 Upload 버튼 클릭시 처리
function fn_resultFileUp(){
	
	var ctrlId = AUIGrid.getCellValue(myGridID, selectedGridValue, "ctrlId");
	var ctrlIsCrc = AUIGrid.getCellValue(myGridID, selectedGridValue, "ctrlIsCrc");
	var bankId = AUIGrid.getCellValue(myGridID, selectedGridValue, "bankId");
    
    //param data array
    var data = {};
    var gridList = AUIGrid.getGridData(updResultGridID);       //그리드 데이터
    
    //array에 담기        
    if(gridList.length > 0) {
        data.all = gridList;
    }  else {
        alert('Select the CSV file on the loca PC');
        return;
        //data.all = [];
    }
    
    //form객체 담기
    data.form = [{"ctrlId":ctrlId,"ctrlIsCrc":ctrlIsCrc,"bankId":bankId}];
    
    //Ajax 호출
    Common.ajax("POST", "/payment/updateClaimResultItem.do", data, function(result) {
    	resetUpdatedItems(); // 초기화
    	
        var message = "";        
        message += "Batch ID : " + result.data.ctrlId + "<br />";
        message += "Total Result Item : " + result.data.totalItem + "<br />";
        message += "Total Success : " + result.data.totalSuccess + "<br />";
        message += "Total Failed : " + result.data.totalFail + "<br />";
        message += "<br />Are you sure want to confirm this result ?<br />";
        
        Common.confirm(message,
        		function (){
        	         var ctrlId = AUIGrid.getCellValue(myGridID, selectedGridValue, "ctrlId");
        	         
        	         //param data array
        	         var data = {};
        	         data.form = [{"ctrlId":ctrlId, "ctrlIsCrc" : ctrlIsCrc , "bankId" : bankId}];
        	         
        	         //CALIM RESULT UPDATE
        	         if(updateResultItemKind == 'LIVE'){
	        	         Common.ajax("POST", "/payment/updateClaimResultLive.do", data, 
	        	        		 function(result) {
	        	        	          Common.alert("<b>Claim result successfully updated.</b>");
	        	        	     },
	        	        	     function(result) {
	        	        	    	  Common.alert("<b>Failed to update claim result.<br />Please try again later.</b>");
	        	        	    });     
        	         }
        	       //CALIM RESULT UPDATE NEXT DAY
        	       if(updateResultItemKind == 'NEXT'){
	                   Common.ajax("POST", "/payment/updateClaimResultNextDay.do", data, 
	                           function(result) {
	                	            var resultMsg = "";
	                	            resultMsg += "<b>The result item have stored in our system.<br />";
	                	            resultMsg += "Syncrhonization process will run on schedule plan.<br />";
	                	            resultMsg += "Kindly check your claim result on next day.<br />Thank you.</b>";	                	   
	                	   
	                                Common.alert(resultMsg);
	                           },
	                           function(result) {
	                                Common.alert("<b>Failed to update claim result.<br />Please try again later.</b>");
	                          });
        	       }
       });
    },  function(jqXHR, textStatus, errorThrown) {
        try {
            console.log("status : " + jqXHR.status);
            console.log("code : " + jqXHR.responseJSON.code);
            console.log("message : " + jqXHR.responseJSON.message);
            console.log("detailMessage : "
                    + jqXHR.responseJSON.detailMessage);
        } catch (e) {
            console.log(e);
        }
        alert("Fail : " + jqXHR.responseJSON.message);        
    });
}

//그리드 초기화.
function resetUpdatedItems() {
     AUIGrid.resetUpdatedItems(updResultGridID, "a");
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
		         var message = "";
		         
		         if(result.code == "IS_BATCH"){		        	 
		        	 message += "There is one active batch exist.<br />";
		        	 message += "Batch ID : " + result.data.ctrlId + "<br />";
		        	 message += "Creator : " + result.data.crtUserName + "<br />";
		        	 message += "Create Date : " + result.data.crtDt  + "<br />";
		        	 message += "<br />You must deactive or complete the batch before create a new batch.<br />";
		        	 
		         }else if(result.code == "FILE_OK"){
                     message += "New claim batch successfully generated.<br /><br />";
                     message += "Batch ID : " + result.data.ctrlId + "<br />";
                     message += "Total Claim Amount : " + result.data.ctrlBillAmt + "<br />";
                     message += "Total Account : " + result.data.ctrlTotItm + "<br />";
                     message += "Creator : " + result.data.crtUserName + "<br />";
                     message += "Create Date : " + result.data.crtDt + "<br />";
                     
		         }else if(result.code == "FILE_FAIL"){
		        	 message += "New claim batch successfully generated, but failed to create claim file.<br /><br />";
                     message += "Batch ID : " + result.data.ctrlId + "<br />";
                     message += "Total Claim Amount : " + result.data.ctrlBillAmt + "<br />";
                     message += "Total Account : " + result.data.ctrlTotItm + "<br />";
                     message += "Creator : " + result.data.crtUserName + "<br />";
                     message += "Create Date : " + result.data.crtDt + "<br />";
                     
		         }else{
		        	 message += "Failed to generate new claim batch. Please try again later.";
		         }
		         
		         Common.alert("<b>" + message + "</b>");
	       },
	       function(result) {
                 Common.alert("<b>Failed to generate new claim batch. Please try again later.</b>");   
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
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
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
                                <p><input id="createDt1" name="createDt1" type="text" title="Create Date From" placeholder="DD/MM/YYYY" class="j_date" readonly /></p>
                                <span>~</span>
                                <p><input id="createDt2" name="createDt2" type="text" title="Create Date To" placeholder="DD/MM/YYYY" class="j_date" readonly /></p>
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
                                <p><input id="debitDt1" name="debitDt1" type="text" title="Debit Date From" placeholder="DD/MM/YYYY" class="j_date" readonly /></p>
                                <span>~</span>
                                <p><input id="debitDt2" name="debitDt2" type="text" title="Debit Date To" placeholder="DD/MM/YYYY" class="j_date" readonly /></p>
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
                <p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
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
                        <li><p class="link_btn"><a href="javascript:fn_openDivPop('SMS');">Fail Deduction SMS</a></p></li>                                                                       
                    </ul>
                    <ul class="btns">                       
                    </ul>
                    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
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
        
        <section class="search_result"><!-- search_result start -->
            <article class="grid_wrap"  id="sms_grid_wrap"></article>               
            <!-- grid_wrap end -->
        </section><!-- search_result end -->

        <ul class="center_btns" id="center_btns1">
            <li><p class="btn_blue2"><a href="javascript:fn_deactivate();">Deactivate</a></p></li>
            <li><p class="btn_blue2"><a href="javascript:fn_updateResult('LIVE');">Update Result</a></p></li>
        </ul>
        
        <ul class="center_btns" id="center_btns2">
            <li><p class="btn_blue2"><a href="javascript:fn_deactivate();">Deactivate</a></p></li>
            <li><p class="btn_blue2"><a href="javascript:fn_updateResult('NEXT');">Update Result</a></p></li>
        </ul>
        
         <ul class="center_btns" id="center_btns3">
            <li><p class="btn_blue2"><a href="javascript:fn_createFile();">Generate File</a></p></li>
        </ul>
         <ul class="center_btns" id="center_btns4">
            <li><p class="btn_blue2"><a href="javascript:fn_sendFailDeduction();">Send Fail Deduction SMS</a></p></li>
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




<!--------------------------------------------------------------- 
    POP-UP (NEW CLAIM)
---------------------------------------------------------------->
<!-- popup_wrap start -->
<div class="popup_wrap" id="updResult_wrap" style="display:none;">
    <!-- pop_header start -->
    <header class="pop_header" id="updResult_pop_header">
        <h1>CLAIM RESULT UPDATE</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" onclick="hideViewPopup('#updResult_wrap')">CLOSE</a></p></li>
        </ul>
    </header>
    <!-- pop_header end -->
    
    <!-- pop_body start -->
    <form name="updResultForm" id="updResultForm"  method="post">
    <section class="pop_body">
        <!-- search_table start -->
        <section class="search_table">
            <!-- table start -->
            <table class="type1">
                <caption>table</caption>
                 <colgroup>
                    <col style="width:165px" />
                    <col style="width:*" />                
                </colgroup>
                
                <tbody>
                    <tr>
                        <th scope="row">Result File</th>
                        <td>
                            <!-- auto_file start -->
                           <div class="auto_file">
                               <input type="file" id="fileSelector" title="file add" accept=".csv" />
                           </div>
                           <!-- auto_file end -->
                        </td>
                    </tr>
                   </tbody>  
            </table>
        </section>
        
        <section class="search_result"><!-- search_result start -->
            <article class="grid_wrap"  id="updResult_grid_wrap" style="display:none;"></article>             
            <!-- grid_wrap end -->
        </section><!-- search_result end -->
        <!-- search_table end -->
        
        <ul class="center_btns" >
            <li><p class="btn_blue2"><a href="javascript:fn_resultFileUp();">Upload</a></p></li>
            <li><p class="btn_blue2"><a href="${pageContext.request.contextPath}/resources/download/payment/ClaimResultUpdate_Format.csv">Download CSV Format</a></p></li>
        </ul>
    </section>
    </form>       
    <!-- pop_body end -->
</div>
<!-- popup_wrap end -->