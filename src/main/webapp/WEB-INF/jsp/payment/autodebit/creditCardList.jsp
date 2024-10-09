<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
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
                {"codeId": "9","codeName": "BSN Bank"},
                {"codeId": "46","codeName": "My Clear"},
                {"codeId": "17","codeName": "HSBC Bank"},
                {"codeId": "23","codeName": "AmBank"}
                ];

//Issue Bank Combo Data for CRC
var bankDataCRC = [
                {"codeId": "3","codeName": "CIMB Bank"},
                {"codeId": "19","codeName": "Standard Chartered Bank"},
                {"codeId": "17","codeName": "HSBC Bank"},
                {"codeId": "23","codeName": "AmBank"}
                /* {"codeId": "21","codeName": "Maybank"} */

                ];
//SMS Combo Data
var smsData = [{"codeId": "0","codeName": "No"}, {"codeId": "1","codeName": "Yes"}];

//Claim Day  Data
var claimDayData = [{"codeId": "5","codeName": "5"},{"codeId": "10","codeName": "10"}];

var subPath = "/resources/WebShare/CRT";

var orderListId;

// 화면 초기화 함수 (jQuery 의 $(document).ready(function() {}); 과 같은 역할을 합니다.
$(document).ready(function(){

	//메인 페이지
    doDefCombo(claimTypeData, '131' ,'claimType', 'S', '');        //Claim Type 생성
    doDefCombo(statusData, '' ,'status', 'S', '');                 //Status 생성
    doDefCombo(bankData, '' ,'issueBank', 'S', '');               //Issue Bank 생성
    doDefCombo(smsData, '' ,'smsSend', 'S', '');                 //SMS Send 생성
    CommonCombo.make('new_issueBank', '/sales/order/getBankCodeList', '' , '', {type: 'M', isCheckAll: false});
    //New Result 팝업 페이지

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

       var gridProse = {
            usePaging           : true,             //페이징 사용
            pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)
            editable                : false,
            fixedColumnCount    : 1,
            displayTreeOpen     : false,
            selectionMode       : "multipleCells",  //"singleRow",
            headerHeight        : 30,
            showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력
            showStateColumn : false,
            noDataMessage       :  gridMsg["sys.info.grid.noDataMessage"],
            groupingMessage     : gridMsg["sys.info.grid.groupingMessage"]
        };

       orderListId = GridCommon.createAUIGrid("orderListId_grid_wrap", orderListColumnLayout,null,gridProse);
       AUIGrid.resize(orderListId,945, $("orderListId_grid_wrap").innerHeight());

       orderListIdDetails = GridCommon.createAUIGrid("orderListIdDetails_grid_wrap", orderListDetailsColumnLayout,null,gridProse);
       AUIGrid.resize(orderListId,945, $("orderListIdDetails_grid_wrap").innerHeight());
});

var orderListColumnLayout= [
                               {dataField : "ctrlId", headerText : "CTRL ID", width : '15%'},
                               {dataField : "crtDt", headerText : "Date", width : '15%'},
                               {dataField : "monthType", headerText : "Category", width : '15%'},
                               {dataField : "ctrlTotItm", headerText : "Total Item", width : '15%' ,dataType : "numeric", formatString : "#,###"},
                               {dataField : "targetAmt", headerText : "Target Amt", width : '15%', dataType : "numeric", formatString : "#,##0.00"},
                               {dataField : "totalSuccess", headerText : "Total Success", width : '15%', dataType : "numeric", formatString : "#,###"},
                               {dataField : "receivedAmt", headerText : "Receive Amt", width : '15%', dataType : "numeric", formatString : "#,##0.00"},
                               {dataField : "status", headerText : "Status", width : '15%'}
                               ];

var orderListDetailsColumnLayout= [
                            {dataField : "bankDtlCtrlId", headerText : "CTRL ID", width : '15%'},
                            {dataField : "bankDtlCtrlId", headerText : "Date", width : '15%'},
                            {dataField : "bankDtlCtrlId", headerText : "Category", width : '15%'},
                            {dataField : "bankDtlCtrlId", headerText : "TotalOrders", width : '15%'}
                            ];


// AUIGrid 칼럼 설정
var columnLayout = [
    { dataField:"ctrlId" ,headerText:"<spring:message code='pay.head.batchId'/>",width: 120 ,editable : false },
    { dataField:"stusCode" ,headerText:"<spring:message code='pay.head.status'/>",width: 100 ,editable : false },
    { dataField:"ctrlIsCrcName" ,headerText:"<spring:message code='pay.head.type'/>",width: 100 ,editable : false },
    { dataField:"bankCode" ,headerText:"<spring:message code='pay.head.issueBank'/>",width: 100 ,editable : false },
    { dataField:"ctrlBatchDt" ,headerText:"<spring:message code='pay.head.debitDate'/>",width: 120 ,editable : false},
    { dataField:"ctrlTotItm" ,headerText:"<spring:message code='pay.head.totalItem'/>",width: 120 ,editable : false },
    { dataField:"ctrlBillAmt" ,headerText:"<spring:message code='pay.head.targetAmt'/>",width: 120 ,editable : false , dataType : "numeric", formatString : "#,##0.00"},
    { dataField:"ctrlBillPayAmt" ,headerText:"<spring:message code='pay.head.receiveAmt'/>",width: 120 ,editable : false , dataType : "numeric", formatString : "#,##0.00"},
    { dataField:"crtDt" ,headerText:"<spring:message code='pay.head.createDate'/>",width: 200 ,editable : false },
    { dataField:"crtUserName" ,headerText:"<spring:message code='pay.head.creator'/>",width: 150 ,editable : false },
    { dataField:"ctrlFailSmsIsPump" ,headerText:"<spring:message code='pay.head.sms'/>",width: 100 ,editable : false ,
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
    { dataField:"ctrlWaitSync" ,headerText:"<spring:message code='pay.head.waitSync'/>",width: 100 ,editable : false,
    	renderer : {
            type : "CheckBoxEditRenderer",
            checkValue : "1",
            unCheckValue : "0"
        }
    },
    { dataField:"ctrlStusId" ,headerText:"<spring:message code='pay.head.statusId'/>",width: 120 ,visible : false, editable : false },
    { dataField:"stusName" ,headerText:"<spring:message code='pay.head.statusName'/>",width: 120 ,visible : false, editable : false },
    { dataField:"crtUserName" ,headerText:"<spring:message code='pay.head.creatorName'/>",width: 120 ,visible : false, editable : false },
    { dataField:"bankName" ,headerText:"<spring:message code='pay.head.bankName'/>",width: 120 ,visible : false, editable : false },
    { dataField:"updDt" ,headerText:"<spring:message code='pay.head.updateDate'/>",width: 120 ,visible : false, editable : false },
    { dataField:"ctrlTotSucces" ,headerText:"<spring:message code='pay.head.success'/>",width: 120 ,visible : false, editable : false },
    { dataField:"ctrlTotFail" ,headerText:"<spring:message code='pay.head.fail'/>",width: 120 ,visible : false, editable : false },
    { dataField:"ctrlIsCrc" ,headerText:"<spring:message code='pay.head.ctrlIsCrc'/>",width: 120 ,visible : false, editable : false },
    { dataField:"bankId" ,headerText:"<spring:message code='pay.head.bankId'/>",width: 120 ,visible : false, editable : false },
    ];

var updResultColLayout = [
                    {
                        dataField : "0",
                        headerText : "<spring:message code='pay.head.refNo'/>",
                        editable : true
                    },{
                        dataField : "1",
                        headerText : "<spring:message code='pay.head.refCode'/>",
                        editable : true
                    },{
                        dataField : "2",
                        headerText : "<spring:message code='pay.head.itemId'/>",
                        editable : true
                    }];

var smsColLayout = [
                    { dataField:"bankDtlApprCode" ,headerText:"<spring:message code='pay.head.approvalCode'/>",width: 150 ,editable : false },
                    { dataField:"salesOrdNo" ,headerText:"<spring:message code='pay.head.orderNo'/>",width: 150 ,editable : false },
                    { dataField:"bankDtlDrAccNo" ,headerText:"<spring:message code='pay.head.accountNo'/>",width: 150 ,editable : false },
                    { dataField:"bankDtlDrName" ,headerText:"<spring:message code='pay.head.name'/>",width: 150 ,editable : false },
                    { dataField:"bankDtlDrNric" ,headerText:"<spring:message code='pay.head.nric'/>",width: 150 ,editable : false },
                    { dataField:"bankDtlAmt" ,headerText:"<spring:message code='pay.head.claimAmt'/>",width: 150 ,editable : false },
                    { dataField:"bankDtlRenAmt" ,headerText:"<spring:message code='pay.head.rentAmt'/>",width: 150 ,editable : false },
                    { dataField:"bankDtlRptAmt" ,headerText:"<spring:message code='pay.head.penaltyAmt'/>",width: 150 ,editable : false }
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
	        var bankCode = AUIGrid.getCellValue(myGridID, selectedGridValue, "bankCode");

	        if((val == "RESULT" || val == "RESULTNEXT") && ctrlStusId != 1){
                Common.alert("<spring:message code='pay.alert.claimResult' arguments='"+ctrlId+" ; "+stusName+"' htmlEscape='false' argumentSeparator=';' />");
			}else if(val == "FILE" && ctrlStusId != 1){
				Common.alert("<spring:message code='pay.alert.claimFile' arguments='"+ctrlId+" ; "+stusName+"' htmlEscape='false' argumentSeparator=';' />");
			}else if(val == "SMS" && ctrlStusId != 4){
                Common.alert("<spring:message code='pay.alert.failSms' arguments='"+ctrlId+" ; "+stusName+"' htmlEscape='false' argumentSeparator=';' />");
            }else if(val == "SMS" && smsSend == 1){
                Common.alert("<spring:message code='pay.alert.failSmsProcess' arguments='"+ctrlId+"' htmlEscape='false'/>");
            }else{

            	$('#sms_grid_wrap').hide();


            	Common.ajax("GET", "/payment/selectClaimMasterById.do", {"batchId":ctrlId,"IS_GRP":1}, function(result) {
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
			    $('#center_btns5').show();

			}else if(val == "RESULT"){
				$('#pop_header h1').text('CREDIT CARD CLAIM RESULT');
				$('#center_btns1').show();
                $('#center_btns2').hide();
                $('#center_btns3').hide();
                $('#center_btns4').hide();
                $('#center_btns5').hide();

			}else if(val == "RESULTNEXT"){
                $('#pop_header h1').text('CREDIT CARD CLAIM RESULT(NEXT DAY)');
                $('#center_btns1').hide();
                $('#center_btns2').show();
                $('#center_btns3').hide();
                $('#center_btns4').hide();
                $('#center_btns5').hide();

            }else if (val == "FILE"){
                $('#pop_header h1').text('CREDIT CARD CLAIM GENERATOR');
                $('#center_btns1').hide();
                $('#center_btns2').hide();
                $('#center_btns3').show();
                $('#center_btns4').hide();
                $('#center_btns5').hide();

            } else if (val == "SMS"){
                $('#pop_header h1').text('FAILED DEDUCTION SMS');
                $('#center_btns1').hide();
                $('#center_btns2').hide();
                $('#center_btns3').hide();
                $('#center_btns4').show();
                $('#center_btns5').hide();
            }


        }else{
             Common.alert("<spring:message code='pay.alert.noClaim'/>");
        }
	}else{
		$("#view_wrap").hide();
		$("#new_wrap").show();

		//NEW CLAIM 팝업에서 필수항목 표시 DEFAULT
		$("#newForm")[0].reset();
		$("#claimDayMust").hide();
		$("#issueBankMust").hide();
		$("#cardTypeMust").hide();
		doDefCombo(bankDataCRC, '' ,'new_merchantBank', 'S', '');
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
	Common.confirm("<spring:message code='pay.alert.deactivateBatch'/>",function (){
	    var ctrlId = AUIGrid.getCellValue(myGridID, selectedGridValue, "ctrlId");

	    Common.ajax("GET", "/payment/updateDeactivate.do", {"ctrlId":ctrlId}, function(result) {
	    	Common.alert("<spring:message code='pay.alert.deactivateSuccess'/>","fn_openDivPop('VIEW')");

	    },function(result) {
	        Common.alert("<spring:message code='pay.alert.deactivateFail'/>");
	    });
	});
}

//Pop-UP 에서 Fail Deduction SMS 처리
function fn_sendFailDeduction(){
	   var ctrlId = AUIGrid.getCellValue(myGridID, selectedGridValue, "ctrlId");

	   Common.ajax("GET", "/payment/sendFaileDeduction.do", {"ctrlId":ctrlId}, function(result) {
            Common.alert("<spring:message code='pay.alert.claimSmsSuccess'/>",function () {fn_openDivPop('VIEW'); });

        },function(result) {
            Common.alert("<spring:message code='pay.alert.claimSmsFail'/>");
        });

}



var updateResultItemKind = "";      //claim result update시 구분 (LIVE :current / NEXT : batch)

//Pop-UP 에서 Update Result 버튼 클릭시 팝업창 생성
function fn_updateResult(val){
	updateResultItemKind = val;
	$("#updResult_wrap").show();
}


function fn_uploadFile(){

	var ctrlId = AUIGrid.getCellValue(myGridID, selectedGridValue, "ctrlId");
	var ctrlIsCrc = AUIGrid.getCellValue(myGridID, selectedGridValue, "ctrlIsCrc");
	var bankId = AUIGrid.getCellValue(myGridID, selectedGridValue, "bankId");
	var bankCode = AUIGrid.getCellValue(myGridID, selectedGridValue, "bankCode");

    var formData = new FormData();

    formData.append("csvFile", $("input[name=uploadfile]")[0].files[0]);
	formData.append("ctrlId", ctrlId);
	formData.append("ctrlIsCrc", ctrlIsCrc);
	formData.append("bankId", bankId);
	formData.append("bankCode", bankCode);

	Common.ajaxFile("/payment/updateClaimResultItemBulk.do", formData,
		function(result){
			resetUpdatedItems(); // 초기화

			var message = "";
			message += "<spring:message code='pay.alert.updateClaimResultItem' arguments='"+result.data.ctrlId+" ; "+
            result.data.totalItem+" ; "+
            result.data.totalSuccess+" ; "+
            result.data.totalFail+"' htmlEscape='false' argumentSeparator=';' />";

			Common.confirm(message,
				function (){
					var ctrlId = AUIGrid.getCellValue(myGridID, selectedGridValue, "ctrlId");

					//param data array
					var data = {};
					data.form = [{"ctrlId":ctrlId, "ctrlIsCrc" : ctrlIsCrc , "bankId" : bankId}];

					//CALIM RESULT UPDATE
					if(updateResultItemKind == 'LIVE'){
						Common.ajax("POST", "/payment/updateCreditCardResultLive.do", data,
							function(result) {
								Common.alert("<spring:message code='pay.alert.claimUpdateSuccess'/>");
							},
							function(result) {
								Common.alert("<spring:message code='pay.alert.claimUpdateFail'/>");
							}
						);
					}

					//CALIM RESULT UPDATE NEXT DAY
					if(updateResultItemKind == 'NEXT'){
						Common.ajax("POST", "/payment/updateClaimResultNextDay.do", data,
							function(result) {
								var resultMsg = "";
								resultMsg += "<spring:message code='pay.alert.claimResultNextDay'/>";

								Common.alert(resultMsg);
							},
							function(result) {
								Common.alert("<spring:message code='pay.alert.claimResultNextDayFail'/>");
							}
						);
					}
				}
			);
		},
		function(jqXHR, textStatus, errorThrown) {
			try {
				console.log("status : " + jqXHR.status);
				console.log("code : " + jqXHR.responseJSON.code);
				console.log("message : " + jqXHR.responseJSON.message);
				console.log("detailMessage : " + jqXHR.responseJSON.detailMessage);
			} catch (e) {
				console.log(e);
			}
			Common.alert("Fail : " + jqXHR.responseJSON.message);
		}
	);

}


function fn_uploadFile3(){

	var ctrlId = AUIGrid.getCellValue(myGridID, selectedGridValue, "ctrlId");
	var ctrlIsCrc = AUIGrid.getCellValue(myGridID, selectedGridValue, "ctrlIsCrc");
	var bankId = AUIGrid.getCellValue(myGridID, selectedGridValue, "bankId");

    var formData = new FormData();

    formData.append("csvFile", $("input[name=uploadfile]")[0].files[0]);
	formData.append("ctrlId", ctrlId);
	formData.append("ctrlIsCrc", ctrlIsCrc);
	formData.append("bankId", bankId);

	Common.ajaxFile("/payment/updateClaimResultItemBulk3.do", formData,
		function(result){
			resetUpdatedItems(); // 초기화

			var message = "";
			message += "<spring:message code='pay.alert.updateClaimResultItem' arguments='"+result.data.ctrlId+" ; "+
            result.data.totalItem+" ; "+
            result.data.totalSuccess+" ; "+
            result.data.totalFail+"' htmlEscape='false' argumentSeparator=';' />";

			Common.confirm(message,
				function (){
					var ctrlId = AUIGrid.getCellValue(myGridID, selectedGridValue, "ctrlId");

					//param data array
					var data = {};
					data.form = [{"ctrlId":ctrlId, "ctrlIsCrc" : ctrlIsCrc , "bankId" : bankId}];

					//CALIM RESULT UPDATE
					if(updateResultItemKind == 'LIVE'){
						Common.ajax("POST", "/payment/updateCreditCardResultLive.do", data,
							function(result) {
								Common.alert("<spring:message code='pay.alert.claimUpdateSuccess'/>");
							},
							function(result) {
								Common.alert("<spring:message code='pay.alert.claimUpdateFail'/>");
							}
						);
					}

					//CALIM RESULT UPDATE NEXT DAY
					if(updateResultItemKind == 'NEXT'){
						Common.ajax("POST", "/payment/updateClaimResultNextDay.do", data,
							function(result) {
								var resultMsg = "";
								resultMsg += "<spring:message code='pay.alert.claimResultNextDay'/>";

								Common.alert(resultMsg);
							},
							function(result) {
								Common.alert("<spring:message code='pay.alert.claimResultNextDayFail'/>");
							}
						);
					}
				}
			);
		},
		function(jqXHR, textStatus, errorThrown) {
			try {
				console.log("status : " + jqXHR.status);
				console.log("code : " + jqXHR.responseJSON.code);
				console.log("message : " + jqXHR.responseJSON.message);
				console.log("detailMessage : " + jqXHR.responseJSON.detailMessage);
			} catch (e) {
				console.log(e);
			}
			Common.alert("Fail : " + jqXHR.responseJSON.message);
		}
	);

}



function fn_uploadFile4(){

	var ctrlId = AUIGrid.getCellValue(myGridID, selectedGridValue, "ctrlId");
	var ctrlIsCrc = AUIGrid.getCellValue(myGridID, selectedGridValue, "ctrlIsCrc");
	var bankId = AUIGrid.getCellValue(myGridID, selectedGridValue, "bankId");
	var bankCode = AUIGrid.getCellValue(myGridID, selectedGridValue, "bankCode");

    var formData = new FormData();

    formData.append("csvFile", $("input[name=uploadfile]")[0].files[0]);
	formData.append("ctrlId", ctrlId);
	formData.append("ctrlIsCrc", ctrlIsCrc);
	formData.append("bankId", bankId);
	formData.append("bankCode", bankCode);

	Common.ajaxFile("/payment/updateClaimResultItemBulk4.do", formData,
		function(result){
			resetUpdatedItems(); // 초기화

			var message = "";
			message += "<spring:message code='pay.alert.updateClaimResultItem' arguments='"+result.data.ctrlId+" ; "+
            result.data.totalItem+" ; "+
            result.data.totalSuccess+" ; "+
            result.data.totalFail+"' htmlEscape='false' argumentSeparator=';' />";

			Common.confirm(message,
				function (){
					var ctrlId = AUIGrid.getCellValue(myGridID, selectedGridValue, "ctrlId");

					//param data array
					var data = {};
					data.form = [{"ctrlId":ctrlId, "ctrlIsCrc" : ctrlIsCrc , "bankId" : bankId}];

					//CALIM RESULT UPDATE
					if(updateResultItemKind == 'LIVE'){
						Common.ajax("POST", "/payment/updateCreditCardResultLive.do", data,
							function(result) {
								Common.alert("<spring:message code='pay.alert.claimUpdateSuccess'/>");
							},
							function(result) {
								Common.alert("<spring:message code='pay.alert.claimUpdateFail'/>");
							}
						);
					}

					//CALIM RESULT UPDATE NEXT DAY
					if(updateResultItemKind == 'NEXT'){
						Common.ajax("POST", "/payment/updateClaimResultNextDay.do", data,
							function(result) {
								var resultMsg = "";
								resultMsg += "<spring:message code='pay.alert.claimResultNextDay'/>";

								Common.alert(resultMsg);
							},
							function(result) {
								Common.alert("<spring:message code='pay.alert.claimResultNextDayFail'/>");
							}
						);
					}
				}
			);
		},
		function(jqXHR, textStatus, errorThrown) {
			try {
				console.log("status : " + jqXHR.status);
				console.log("code : " + jqXHR.responseJSON.code);
				console.log("message : " + jqXHR.responseJSON.message);
				console.log("detailMessage : " + jqXHR.responseJSON.detailMessage);
			} catch (e) {
				console.log(e);
			}
			Common.alert("Fail : " + jqXHR.responseJSON.message);
		}
	);

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
    	Common.alert("<spring:message code='pay.alert.claimSelectCsvFile'/>");
        return;
        //data.all = [];
    }

    //form객체 담기
    data.form = [{"ctrlId":ctrlId,"ctrlIsCrc":ctrlIsCrc,"bankId":bankId}];

    //Ajax 호출
    Common.ajax("POST", "/payment/updateClaimResultItem.do", data, function(result) {
    	resetUpdatedItems(); // 초기화

        var message = "";
    	message += "<spring:message code='pay.alert.updateClaimResultItem' arguments='"+result.data.ctrlId+" ; "+
	    	result.data.totalItem+" ; "+
	    	result.data.totalSuccess+" ; "+
	    	result.data.totalFail+"' htmlEscape='false' argumentSeparator=';' />";

        Common.confirm(message,
        		function (){
        	         var ctrlId = AUIGrid.getCellValue(myGridID, selectedGridValue, "ctrlId");

        	         //param data array
        	         var data = {};
        	         data.form = [{"ctrlId":ctrlId, "ctrlIsCrc" : ctrlIsCrc , "bankId" : bankId}];

        	         //CALIM RESULT UPDATE
        	         if(updateResultItemKind == 'LIVE'){
	        	         Common.ajax("POST", "/payment/updateCreditCardResultLive.do", data,
	        	        		 function(result) {
	        	        	          Common.alert("<spring:message code='pay.alert.claimUpdateSuccess'/>");
	        	        	     },
	        	        	     function(result) {
	        	        	    	  Common.alert("<spring:message code='pay.alert.claimUpdateFail'/>");
	        	        	    });
        	         }
        	       //CALIM RESULT UPDATE NEXT DAY
        	       if(updateResultItemKind == 'NEXT'){
	                   Common.ajax("POST", "/payment/updateClaimResultNextDay.do", data,
	                           function(result) {
	                	            var resultMsg = "";
	                	            resultMsg += "<spring:message code='pay.alert.claimResultNextDay'/>";

	                                Common.alert(resultMsg);
	                           },
	                           function(result) {
	                                Common.alert("<spring:message code='pay.alert.claimResultNextDayFail'/>");
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

    if ($("#new_issueBank option:selected").val() == null) {
        Common.alert(" * Please select issue bank ");
        return;
   }
    if ($("#new_cardType option:selected").val() == '' ) {
        Common.alert(" * Please select card type.");
        return;
   }
    if ($("#new_merchantBank option:selected").val() == '') {
        Common.alert(" * Please select a merchant bank ");
        return;
   }
    if ($("#_mayBank option:selected").val() == '') {
        Common.alert(" * Please select Maybank checking ");
        return;
   }
    if ($("#_month option:selected").val() == null) {
        Common.alert(" * Please select a install month");
        return;
   }

    var runNo1 = 0;
    var issueBank = "";

    if($('#new_issueBank :selected').length > 0){
        $('#new_issueBank :selected').each(function(i, mul){
            if($(mul).val() != "0"){
                if(runNo1 > 0){
                    issueBank += ", "+$(mul).val()+" ";
                }else{
                    issueBank += " "+$(mul).val()+" ";
                }
                runNo1 += 1;
            }
        });
    }
    $("#hiddenIssueBank").val(issueBank);

    var runNo2 = 0;
    var month = "";

    if($('#_month :selected').length > 0){
        $('#_month :selected').each(function(i, mul){
            if($(mul).val() != "0"){
                if(runNo2 > 0){
                	month += ","+$(mul).val()+"";
                }else{
                	month += ""+$(mul).val()+"";
                }
                runNo2 += 1;
            }
        });
    }
    $("#hiddenMonth").val(month);

    //저장 처리
    var data = {};
    var formList = $("#newForm").serializeArray();       //폼 데이터

    if(formList.length > 0) data.form = formList;
    else data.form = [];

    console.log(data);

    Common.ajax("POST", "/payment/generateNewCreditCardClaim.do", data,
            function(result) {
                 var message = "";

/*                  if(result.code == "IS_BATCH"){
                     message += "<spring:message code='pay.alert.claimIsBatch' arguments='"+result.data.ctrlId+" ; "+
                     result.data.crtUserName+" ; "+result.data.crtDt+"' htmlEscape='false' argumentSeparator=';' />";

                 }else  */
                if(result.code == "FILE_OK"){
                     message += "<spring:message code='pay.alert.claimFileOk' arguments='"+result.data.ctrlId+" ; "+result.data.ctrlBillAmt+" ; "+result.data.ctrlTotItm+" ; "+
                     result.data.crtUserId+" ; "+result.data.crtDt+"' htmlEscape='false' argumentSeparator=';' />";

                 }else if(result.code == "FILE_FAIL"){
                     message += "<spring:message code='pay.alert.claimFileFail' arguments='"+result.data.ctrlId+" ; "+result.data.ctrlBillAmt+" ; "+result.data.ctrlTotItm+" ; "+
                     result.data.crtUserId+" ; "+result.data.crtDt+"' htmlEscape='false' argumentSeparator=';' />";

                 }else{
                     message += "<spring:message code='pay.alert.generateFailClaimBatch'/>";
                 }

                 Common.alert("<b>" + message + "</b>");
           },
           function(result) {
                 Common.alert("<spring:message code='pay.alert.generateFailClaimBatch'/>");
           }
    );
}


//NEW CLAIM Pop-UP 에서 Generate Claim 처리
function fn_createFile(){

	var ctrlId = AUIGrid.getCellValue(myGridID, selectedGridValue, "ctrlId");
    var isCrc = 'crc';
	//param data array
    var data = {};
    data.form = [{"ctrlId":ctrlId, "isCrc":isCrc}] ;

    Common.ajax("POST", "/payment/createClaimFile.do", data,
            function(result) {
                 Common.alert("<spring:message code='pay.alert.claimSucessCreate'/>",function(){
                     window.open("${pageContext.request.contextPath}" + subPath + result.data);
                 });

           },
           function(result) {
                 Common.alert("<spring:message code='pay.alert.claimFailGenFile'/>");
           }
    );

}

function fn_clear(){
    $("#searchForm")[0].reset();
}

//**************************************************
//**************************************************
// Schedule Claim Batch 관련 Script
//**************************************************
//**************************************************
// Schedule Claim Batch 팝업
function fn_openDivScheduleBatchPop() {
	Common.popupWin("searchForm", "/payment/initScheduleClaimBatchPop.do", {width : "1200px", height : "550", resizable: "no", scrollbars: "no"});
}


// Schedule Claim Batch Setting 팝업
function fn_openDivScheduleSettingPop() {
	Common.popupWin("searchForm", "/payment/initScheduleClaimSettingPop.do", {width : "1200px", height : "550", resizable: "no", scrollbars: "no"});
}


//Generation File Download 팝업
function fn_openDivPopDown(){

	var selectedItem = AUIGrid.getSelectedIndex(myGridID);

	if (selectedItem[0] > -1){

		var ctrlId = AUIGrid.getCellValue(myGridID, selectedGridValue, "ctrlId");
		var ctrlStusId = AUIGrid.getCellValue(myGridID, selectedGridValue, "ctrlStusId");
		var stusName = AUIGrid.getCellValue(myGridID, selectedGridValue, "stusName");

		if(ctrlStusId != 1){
			Common.alert("<spring:message code='pay.alert.claimFile' arguments='"+ctrlId+" ; "+stusName+"' htmlEscape='false' argumentSeparator=';' />");
		}else{
			Common.popupDiv('/payment/initClaimFileDownPop.do', {"ctrlId" : ctrlId}, null , true ,'_claimFileDownPop');
		}
	}else{
		Common.alert("<spring:message code='pay.alert.noClaim'/>");
	}
}

function fn_report(){

	var ctrlId = AUIGrid.getCellValue(myGridID, selectedGridValue, "ctrlId");
    $("#dloadCtrlId").val(ctrlId);
    $("#fileType").val("Details");
    $("#dloadPathAndName").val('C:/works/workspace/etrust/src/main/webapp/resources/WebShare/CRT/CRC/CIMB_GROUP/CRC__2023-12-08.zip');
    $("#downloadFileForm").submit();

	/* var ctrlId = AUIGrid.getCellValue(myGridID, selectedGridValue, "ctrlId");
    var date = new Date().getDate();
    if(date.toString().length == 1){
        date = "0" + date;
    }

    $("#excelForm #reportDownFileName").val("AutoDebitDetails_" + ctrlId + "_"+date+(new Date().getMonth()+1)+new Date().getFullYear());
    $("#excelForm #v_BANK_DTL_CTRL_ID").val(ctrlId);

    var option = {
            isProcedure : true
    };

    Common.report("excelForm", option); */

}

function fn_uploadM2Pop(){

	$("#view_wrap").hide();
    $("#uploadMonth2_wrap").show();

}

function fn_uploadFileM2(){

    var formData = new FormData();

    formData.append("csvFile", $("input[name=uploadfileM2]")[0].files[0]);
    formData.append("lockOpeningFlag", $("#lockOpeningFlag").val());

    Common.ajaxFile("/payment/creditCardClaimMonth2Uploads.do", formData, function(result){
        Common.alert(result.message);
    });
}

function fn_excelDown() {
    GridCommon.exportTo("orderListId_grid_wrap", "xlsx","M1M2OrderRecord");
  }

function fn_ordersListPop(){

    Common.ajaxFile("/payment/orderListMonthViewPop.do", '', function(result){
    	AUIGrid.setGridData(orderListId, result);
    });

    $("#orderList_wrap").show();

    /* fn_setAUIEvent() */
}
/* function fn_setAUIEvent(){
	console.log('AUIGrid Binded');
	AUIGrid.bind(orderListId, "cellDoubleClick", function(event) {
		  console.log('AUIGrid double click');
		fn_setDetail(orderListId, event.rowIndex);
	});
}; */

/* function fn_setDetail(gridID, rowIdx){

    $("#reportFileName").val("");
    $("#reportDownFileName").val("");

		 var date = new Date().getDate();
		    if(date.toString().length == 1){
		        date = "0" + date;
		    }
            $("#excelForm #v_CTRL_ID").val(AUIGrid.getCellValue(gridID, rowIdx, "ctrlId"));
    	    $("#excelForm #reportDownFileName").val("M1_M2_OrderDetails.rpt"+date+(new Date().getMonth()+1)+new Date().getFullYear());
    	    $("#excelForm #reportFileName").val("/payment/M1_M2_OrderDetails.rpt");

    	    // 프로시져로 구성된 경우 꼭 아래 option을 넘겨야 함.
    	    var option = {
    	        isProcedure : true // procedure 로 구성된 리포트 인경우 필수.
    	    };

    	    Common.report("excelForm", option);
} */

function fn_downloadClaimFile(resultData) {
	var ctrlId = AUIGrid.getCellValue(myGridID, selectedGridValue, "ctrlId");
	$("#dloadCtrlId").val(ctrlId);
	$("#fileType").val("ClaimFile");
    $("#dloadPathAndName").val('C:/works/workspace/etrust/src/main/webapp/resources/WebShare/CRT/CRC/CIMB_GROUP/CRC__2023-12-08.zip');
    $("#downloadFileForm").submit();
}
</script>

<!-- content start -->
<section id="content">
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    </ul>

    <!-- title_line start -->
    <aside class="title_line">
        <p class="fav"><a href="#" class="click_add_on"><spring:message code='pay.text.myMenu'/></a></p>
        <h2>Credit Card Claim List</h2>
        <ul class="right_btns">
        <c:if test="${PAGE_AUTH.funcView == 'Y'}">
            <li><p class="btn_blue"><a href="javascript:fn_getClaimListAjax();"><span class="search"></span><spring:message code='sys.btn.search'/></a></p></li>
        </c:if>
            <li><p class="btn_blue"><a href="javascript:fn_clear();"><span class="clear"></span><spring:message code='sys.btn.clear'/></a></p></li>
        </ul>
    </aside>
    <!-- title_line end -->

    <!-- search_table start -->
    <section class="search_table">
        <form name="searchForm" id="searchForm"  method="post">
                <input type="hidden" name="IS_GRP"  id="IS_GRP" value = "1"/>
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
                            <select id="claimType" name="claimType" class="w100p disabled" disabled></select>
                            <input type="hidden" id="claimType" name="claimType" value="131" />
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
               <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
                <p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
                <dl class="link_list">
                    <dt>Link</dt>
                    <dd>
                    <ul class="btns">
                        <li><p class="link_btn"><a href="javascript:fn_openDivPop('VIEW');"><spring:message code='pay.btn.viewClaim'/></a></p></li>
                        <li><p class="link_btn"><a href="javascript:fn_openDivPop('RESULT');"><spring:message code='pay.btn.claimResultLive'/></a></p></li>
                        <li><p class="link_btn"><a href="javascript:fn_openDivPop('RESULTNEXT');"><spring:message code='pay.btn.claimResultNextDay'/></a></p></li>
                        <li><p class="link_btn"><a href="javascript:fn_openDivPop('FILE');"><spring:message code='pay.btn.reGenerateClaimFile'/></a></p></li>
                        <!--<li><p class="link_btn"><a href="javascript:fn_openDivPopDown('FILEDN');">Generation File Down</a></p></li>-->
                        <li><p class="link_btn"><a href="javascript:fn_openDivPop('SMS');"><spring:message code='pay.btn.failDeductionSMS'/></a></p></li>
                    </ul>
                    <ul class="btns">
                        <li><p class="link_btn type2"><a href="javascript:fn_openDivPop();"><spring:message code='pay.btn.newClaim'/></a></p></li>
                        <li><p class="link_btn type2"><a href="javascript:fn_uploadM2Pop();"><spring:message code='pay.btn.uploadMonth2'/></a></p></li>
                        <li><p class="link_btn type2"><a href="javascript:fn_ordersListPop();"><spring:message code='pay.btn.listOrderMonth'/></a></p></li>
                        <li><p class="link_btn type2"><a href="javascript:fn_downloadClaimFile();">Download File</a></p></li>
<%-- 						<li><p class="link_btn type2"><a href="javascript:fn_openDivScheduleSettingPop();"><spring:message code='pay.btn.scheduleSetting'/></a></p></li>
                        <li><p class="link_btn type2"><a href="javascript:fn_openDivScheduleBatchPop();"><spring:message code='pay.btn.scheduleClaimBatch'/></a></p></li> --%>
                    </ul>
                    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
                    </dd>
                </dl>
                </c:if>
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
            <li><p class="btn_blue2"><a href="#" onclick="hideViewPopup('#view_wrap')"><spring:message code='sys.btn.close'/></a></p></li>
        </ul>
    </header>
    <!-- pop_header end -->
<form action="#" method="post" id="excelForm" name="excelForm">

<input type="hidden" id="reportFileName" name="reportFileName" value="/payment/AutoDebitCreditCardDetails.rpt" />
<input type="hidden" id="viewType" name="viewType" value="EXCEL" />
<input type="hidden" id="reportDownFileName" name="reportDownFileName" value="" />
<input type="hidden" id="v_CTRL_ID" name="v_CTRL_ID"/>
<input type="hidden" id="v_BANK_DTL_CTRL_ID" name="v_BANK_DTL_CTRL_ID" value='$("#view_batchId").text()' />


</form>
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
            <li><p class="btn_blue2"><a href="javascript:fn_deactivate();"><spring:message code='pay.btn.deactivate'/></a></p></li>
            <li><p class="btn_blue2"><a href="javascript:fn_updateResult('LIVE');"><spring:message code='pay.btn.updateResult'/></a></p></li>
        </ul>

        <ul class="center_btns" id="center_btns2">
            <li><p class="btn_blue2"><a href="javascript:fn_deactivate();"><spring:message code='pay.btn.deactivate'/></a></p></li>
            <li><p class="btn_blue2"><a href="javascript:fn_updateResult('NEXT');"><spring:message code='pay.btn.updateResult'/></a></p></li>
        </ul>

         <ul class="center_btns" id="center_btns3">
            <li><p class="btn_blue2"><a href="javascript:fn_createFile();"><spring:message code='pay.btn.generateFile'/></a></p></li>
        </ul>
         <ul class="center_btns" id="center_btns4">
            <li><p class="btn_blue2"><a href="javascript:fn_sendFailDeduction();"><spring:message code='pay.btn.sendFailDecductionSMS'/></a></p></li>
        </ul>
         <ul class="center_btns" id="center_btns5">
            <li><p class="btn_blue2"><a href="javascript:fn_report();"><spring:message code='pay.btn.generateToExcel'/></a></p></li>
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
            <li><p class="btn_blue2"><a href="#" onclick="hideViewPopup('#new_wrap')"><spring:message code='sys.btn.close'/></a></p></li>
        </ul>
    </header>
    <!-- pop_header end -->

    <!-- pop_body start -->
    <form name="newForm" id="newForm"  method="post">
    <input type="hidden"  id="IS_GRP" name="IS_GRP" value="1" />
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
                            <select id="new_claimType" name="new_claimType" class="w100p disabled" disabled="">
                                <option value='131' selected >Credit Card</option>
                            </select>
                            <input type="hidden"  id="new_claimType" name="new_claimType" value="131" />
                        </td>
                        <th scope="row">Debit Date</th>
                        <td>
                            <input type="text" id="new_debitDate" name="new_debitDate" title="Debit Date" placeholder="Debit Date" class="j_date w100p" />
                        </td>
                    </tr>
                     <tr>
                     <th scope="row">Merchant Bank <span class="must">*</span></th>
                        <td>
                            <select id="new_merchantBank" name="new_merchantBank" class="w100p"></select>
                        <th scope="row">Card Type<span class="must" id="cardTypeMust">*</span></th>
                        <td>
                            <select id="new_cardType" name="new_cardType" class="w100p">
                                <option value="">Choose One</option>
                                <option value="0">All</option>
                                <option value="112">Visa Card</option>
                                <option value="111">Master Card</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                    <th scope="row">Issue Bank <span class="must">*</span></th>
                        <td>
                            <select class="multy_select w100p" multiple="multiple" id="new_issueBank" data-placeholder="Bank Name"></select>
                            <input type="hidden"  id="hiddenIssueBank" name="hiddenIssueBank"/>
                        </td>
                    <th scope="row">Maybank (463225, 428332)<span class="must">*</span></th>
                        <td>
                            <select id="_mayBank" name="_mayBank" class="w100p">
                                <option value="">Choose One</option>
                                <option value="0">No</option>
                                <option value="1">Yes</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">M1 & M2 Type<span class="must">*</span></th>
                        <td>
                            <select id="monthType" name="monthType" class="w100p">
                                <option value="M1/M2">All</option>
                                <option value="M1">M1</option>
                                <option value="M2">M2</option>
                            </select>
                        </td>
                        <th scope="row">Customer Type<span class="must">*</span></th>
                        <td>
                            <select id="custType" name="custType" class="w100p">
                                <option value="0">All</option>
                                <option value="1">Odd</option>
                                <option value="2">Even</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                    <th scope="row">Install Month<span class="must">*</span></th>
                    <td>
                        <select id="_month" name="_month" class="multy_select w100p" multiple="multiple">
                            <option value="01">JANUARY</option>
                            <option value="02">FEBUARY</option>
                            <option value="03">MARCH</option>
                            <option value="04">APRIL</option>
                            <option value="05">MAY</option>
                            <option value="06">JUNE</option>
                            <option value="07">JULY</option>
                            <option value="08">AUGUST</option>
                            <option value="09">SEPTEMBER</option>
                            <option value="10">OCTOBER</option>
                            <option value="11">NOVEMBER</option>
                            <option value="12">DECEMBER</option>
                        </select>
                        <input type="hidden"  id="hiddenMonth" name="hiddenMonth"/>
                    </td>
                    </tr>
                   </tbody>
            </table>
        </section>
        <!-- search_table end -->

        <ul class="center_btns">
            <li><p class="btn_blue2"><a href="javascript:fn_genClaim();"><spring:message code='pay.btn.generateClaim'/></a></p></li>
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
            <li><p class="btn_blue2"><a href="#" onclick="hideViewPopup('#updResult_wrap')"><spring:message code='sys.btn.close'/></a></p></li>
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
							<!--
                           <div class="auto_file">
                               <input type="file" id="fileSelector" title="file add" accept=".csv" />
                           </div>
						   -->
                           <!-- auto_file end -->
						   <div class="auto_file"><!-- auto_file start -->
							<input type="file" title="file add" id="uploadfile" name="uploadfile" accept=".csv"/>
							</div><!-- auto_file end -->
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
            <li><p class="btn_blue2"><a href="javascript:fn_uploadFile4();"><spring:message code='pay.btn.upload'/></a></p></li>
            <!--<li><p class="btn_blue2"><a href="javascript:fn_resultFileUp();"><spring:message code='pay.btn.upload'/></a></p></li>-->
            <li><p class="btn_blue2"><a href="${pageContext.request.contextPath}/resources/download/payment/ClaimResultUpdate_Format.csv"><spring:message code='pay.btn.downloadCsvFormat'/></a></p></li>
        </ul>
    </section>
    </form>
    <!-- pop_body end -->
</div>
<!-- popup_wrap end -->



<!---------------------------------------------------------------
    POP-UP (UPLOAD MONTH 2 ORDERS)
---------------------------------------------------------------->
<!-- popup_wrap start -->
<div class="popup_wrap" id="uploadMonth2_wrap" style="display:none;">
    <!-- pop_header start -->
    <header class="pop_header" id="new_pop_header">
        <h1>Upload M2</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" onclick="hideViewPopup('#uploadMonth2_wrap')"><spring:message code='sys.btn.close'/></a></p></li>
        </ul>
    </header>
    <!-- pop_header end -->

    <section class="pop_body"><!-- pop_body start -->
        <form action="#" method="post">
            <table class="type1"><!-- table start -->
                <caption>table</caption>
                <colgroup>
                    <col style="width:130px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                    <tr>
                      <th scope="row">File</th>
                      <td>
                      <div class="auto_file"><!-- auto_file start -->
                          <input type="file" title="file add" id="uploadfileM2" name="uploadfileM2" />
                      </div><!-- auto_file end -->
                      </td>
                      <td></td>
                    </tr>
                    <tr>
                        <th scope="row">Lock Opening M2<span class="must" id="lockOpeningM2">*</span></th>
                        <td>
                            <select id="lockOpeningFlag" name="lockOpeningFlag" class="w100p">
                                <option value="N">No</option>
                                <option value="Y">Yes</option>
                            </select>
                        </td>
                    <td colspan="1"></td>
                    </tr>
                </tbody>
            </table><!-- table end -->
        </form>
        <ul class="center_btns mt20">
            <li><p class="btn_blue2 big"><a href="javascript:fn_uploadFileM2();"><spring:message code='pay.btn.uploadFile'/></a></p></li>
        </ul>
    </section>
    <!-- pop_body end -->
</div>
<!-- popup_wrap end -->
<!-- popup_wrap start -->
<div class="popup_wrap" id="orderList_wrap" style="display: none;">
    <!-- pop_header start -->
    <header class="pop_header" id="pop_header">
        <h1>M1/M2 Order</h1>
        <ul class="right_opt">
        <li><p class="btn_blue2"><a href="#" onClick="fn_excelDown()">Export To Excel</a></p></li>
        <li><p class="btn_blue2"><a href="#" >CLOSE</a></p></li>
 <!-- search_result start -->
 <!-- grid_wrap start -->
        </ul>
    </header>
<section class="pop_body"><!-- pop_body start -->
    <article class="orderList_wrap"><!-- grid_wrap start -->
    <div id="orderListId_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->


     </section><!-- pop_body end -->
    <!-- pop_header end -->
    <form name="downloadFileForm" id="downloadFileForm" method="post" action="/payment/downloadCreditCardClaimFile.do">
    <input id="dloadPathAndName" name="dloadPathAndName" type="hidden" >
    <input id="dloadCtrlId" name="dloadCtrlId" type="hidden" >
    <input id="fileType" name="fileType" type="hidden" >
 </form>
</div>
<!-- popup_wrap end -->

