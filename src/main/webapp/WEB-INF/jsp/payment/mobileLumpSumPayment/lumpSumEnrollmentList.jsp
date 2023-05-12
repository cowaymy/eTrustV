<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>
<style>
</style>
<script type="text/javaScript">
var myGridID;
var option = {
	width: "1200px", // 창 가로 크기
	height: "500px" // 창 세로 크기
};
var basicAuth = false;
$(document).ready(function() {
	var selectedRecord;
	var memLevel = "${memLevel}";

    if (memLevel == 4) {
      $("#searchForm #memberCode").val("${memCode}");
      $("#searchForm #memberCode").prop("readonly", true);
    } else {
      $("#searchForm #memberCode").val("");
      $("#searchForm #memberCode").prop("readonly", false);
    }

    createAUIGrid();

    $('#_listSearchBtn').click(function(){
		selectList();
    })
});

function selectList(){
    Common.ajax("GET","/payment/mobileLumpSumPayment/getlumpSumEnrollmentList.do",$("#searchForm").serialize(), function(result){
        AUIGrid.setGridData(myGridID, result);
    });
}

function createAUIGrid() {
	var columnLayout = [{
        dataField : "checkId",
        headerText : '<input type="checkbox" id="allCheckbox" style="width:15px;height:15px;">',
        cellMerge : true ,
        mergeRef : "mobPayGroupNo", // 이전 칼럼(대분류) 셀머지의 값을 비교해서 실행함. (mergePolicy : "restrict" 설정 필수)
        mergePolicy : "restrict",
        width : 50,
        renderer : {
        	type : "CheckBoxEditRenderer",
            showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
            editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
            checkValue : "Y", // true, false 인 경우가 기본
            unCheckValue : "N",
            disabledFunction : function(rowIndex, columnIndex, value, isChecked, item, dataField) {
            	if(item.payStusId == 1){
                    return false;
            	}
            	return true;
            }
      }
    },{
		dataField: "mobPayGroupNo",
		headerText: '<spring:message code="pay.title.ticketNo" />',
		width: 100,
		cellMerge: true
	}, {
		dataField: "crtDt",
		headerText: '<spring:message code="pay.grid.requestDate" />',
		width: 140,
		cellMerge: true,
		mergeRef: "mobPayGroupNo",
		mergePolicy: "restrict"
	}, {
		dataField: "payStusName",
		width: 100,
		headerText: '<spring:message code="pay.grid.status" />',
		cellMerge: true,
		mergeRef: "mobPayGroupNo",
		mergePolicy: "restrict"
	}, {
		dataField: "crtUserName",
		headerText: '<spring:message code="pay.head.memberCode" />',
		width: 160,
		cellMerge: true,
		mergeRef: "mobPayGroupNo",
		mergePolicy: "restrict"
	}, {
		dataField: "payModeName",
		width: 160,
		headerText: '<spring:message code="sal.text.payMode" />',
		cellMerge: true,
		mergeRef: "mobPayGroupNo",
		mergePolicy: "restrict"
	}, {
		dataField: "salesOrdNo",
		headerText: '<spring:message code="pay.title.orderNo" />',
		width: 120,
		editable: false
	}, {
		dataField: "payType",
		headerText: 'Pay Type',
		width: 130,
		editable: false
	}, {
		dataField: "oriOutAmt",
		headerText: '<spring:message code="pay.head.outstandingAmount" />',
		width: 130,
		editable: false
	}, {
		dataField: "payAmt",
		headerText: '<spring:message code="pay.head.paymentAmount" />',
		width: 130,
		editable: false
	}, {
		dataField: "custName",
		headerText: '<spring:message code="pay.head.customerName" />',
		width: 200,
		editable: false,
		style: "aui-grid-user-custom-left",
		cellMerge: true,
		mergeRef: "mobPayGroupNo",
		mergePolicy: "restrict"
	}, {
		dataField: "totOriOutAmt",
		headerText: 'Total Outstanding Amt',
		width: 100,
		editable: false,
		cellMerge: true,
		mergeRef: "mobPayGroupNo",
		mergePolicy: "restrict"
	}, {
		dataField: "totPayAmt",
		headerText: 'Total Payment Amt',
		width: 100,
		dataType: "numeric",
		cellMerge: true,
		mergeRef: "mobPayGroupNo",
		mergePolicy: "restrict"
	}, {
		dataField: "slipNo",
		headerText: 'Slip No',
		width: 100,
		cellMerge: true,
		mergeRef: "mobPayGroupNo",
		mergePolicy: "restrict"
	},
	{
		dataField: "chequeNo",
		headerText: 'Cheque No',
		width: 100,
		cellMerge: true,
		mergeRef: "mobPayGroupNo",
		mergePolicy: "restrict"
	},{
		dataField: "chequeDate",
		headerText: 'Cheque Date',
		width: 100,
		cellMerge: true,
		mergeRef: "mobPayGroupNo",
		mergePolicy: "restrict"
	},{
		dataField: "issueBankName",
		headerText: 'Issue Bank',
		width: 100,
		cellMerge: true,
		mergeRef: "mobPayGroupNo",
		mergePolicy: "restrict"
	},{
		dataField: "chequeNo",
		headerText: 'Cheque no',
		width: 100,
		cellMerge: true,
		mergeRef: "mobPayGroupNo",
		mergePolicy: "restrict"
	},{
		dataField: "chequeDate",
		headerText: 'Cheque Date',
		width: 100,
		cellMerge: true,
		mergeRef: "mobPayGroupNo",
		mergePolicy: "restrict"
	},{
		dataField: "cardNo",
		headerText: 'Card No',
		width: 100,
		cellMerge: true,
		mergeRef: "mobPayGroupNo",
		mergePolicy: "restrict"
	},{
		dataField: "expiryDate",
		headerText: 'Expiry Date',
		width: 100,
		cellMerge: true,
		mergeRef: "mobPayGroupNo",
		mergePolicy: "restrict"
	},{
		dataField: "approvalNo",
		headerText: 'Approval No',
		width: 100,
		cellMerge: true,
		mergeRef: "mobPayGroupNo",
		mergePolicy: "restrict"
	},{
		dataField: "crcName",
		headerText: 'CRC Name',
		width: 100,
		cellMerge: true,
		mergeRef: "mobPayGroupNo",
		mergePolicy: "restrict"
	},{
		dataField: "transactionDate",
		headerText: 'TRX Date',
		width: 100,
		cellMerge: true,
		mergeRef: "mobPayGroupNo",
		mergePolicy: "restrict"
	},{
		dataField: "cardModeDesc",
		headerText: 'Card Mode',
		width: 100,
		cellMerge: true,
		mergeRef: "mobPayGroupNo",
		mergePolicy: "restrict"
	},{
		dataField: "merchantBankDesc",
		headerText: 'Merchant Bank',
		width: 100,
		cellMerge: true,
		mergeRef: "mobPayGroupNo",
		mergePolicy: "restrict"
	},{
		dataField: "cardBrandDesc",
		headerText: 'Card Brand',
		width: 100,
		cellMerge: true,
		mergeRef: "mobPayGroupNo",
		mergePolicy: "restrict"
	},{
		dataField: "attchImgUrl1",
		headerText: 'Transaction Slip',
		width: 100,
		cellMerge: true,
		mergeRef: "mobPayGroupNo",
		mergePolicy: "restrict",
		 renderer : {
	            type : "ImageRenderer",
	            width : 20,
	            height : 20,
	            imgTableRef : {
	              "DOWN" : "${pageContext.request.contextPath}/resources/AUIGrid/images/arrow-down-black-icon.png"
	            }
	          }
	},{
		dataField: "attchImgUrl2",
		headerText: 'Submission Checklist',
		width: 100,
		cellMerge: true,
		mergeRef: "mobPayGroupNo",
		mergePolicy: "restrict",
		 renderer : {
	            type : "ImageRenderer",
	            width : 20,
	            height : 20,
	            imgTableRef : {
	              "DOWN" : "${pageContext.request.contextPath}/resources/AUIGrid/images/arrow-down-black-icon.png"
	            }
	          }
	},{
		dataField: "attchImgUrl3",
		headerText: 'Other/Cheque Image',
		width: 100,
		cellMerge: true,
		mergeRef: "mobPayGroupNo",
		mergePolicy: "restrict",
		 renderer : {
	            type : "ImageRenderer",
	            width : 20,
	            height : 20,
	            imgTableRef : {
	              "DOWN" : "${pageContext.request.contextPath}/resources/AUIGrid/images/arrow-down-black-icon.png"
	            }
	          }
	},{
		dataField: "attchImgUrl4",
		headerText: 'Other 2',
		width: 100,
		cellMerge: true,
		mergeRef: "mobPayGroupNo",
		mergePolicy: "restrict",
		 renderer : {
	            type : "ImageRenderer",
	            width : 20,
	            height : 20,
	            imgTableRef : {
	              "DOWN" : "${pageContext.request.contextPath}/resources/AUIGrid/images/arrow-down-black-icon.png"
	            }
	          }
	},{
		dataField: "issueBank",
		visible: false
	},{
		dataField: "cardMode",
		visible: false
	}, {
		dataField: "merchantBank",
		visible: false
	},{
		dataField: "cardBrand",
		visible: false
	},{
		dataField: "payStusId",
		visible: false
	}, {
		dataField: "mobPayDetailId",
		visible: false
	}, {
		dataField: "ordId",
		visible: false
	}, {
		dataField: "payMode",
		visible: false
	}];
	var gridPros = {
		enableCellMerge : true,
		cellMergePolicy: "withNull",
        usePaging : false,
        editable :false,
   		headerHeight: 30,
		wordWrap:true
	};
	myGridID = AUIGrid.create("#grid_wrap", columnLayout, gridPros);
    AUIGrid.bind(myGridID, "headerClick", headerClickHandler);

    AUIGrid.bind(myGridID, "cellClick", function(event) {
        if (event.dataField == "attchImgUrl1") {
          if (FormUtil.isEmpty(event.value) == false) {
            var rowVal = AUIGrid.getItemByRowIndex(myGridID, event.rowIndex);
            if (FormUtil.isEmpty(rowVal.atchFileName1) == false && FormUtil.isEmpty(rowVal.physiclFileName1) == false) {
              window.open("/file/fileDownWasMobile.do?subPath=" + rowVal.fileSubPath1 + "&fileName=" + rowVal.physiclFileName1 + "&orignlFileNm=" + rowVal.atchFileName1);
            }
          }
        } else if (event.dataField == "attchImgUrl2") {
          if (FormUtil.isEmpty(event.value) == false) {
            var rowVal = AUIGrid.getItemByRowIndex(myGridID, event.rowIndex);
            if (FormUtil.isEmpty(rowVal.atchFileName2) == false && FormUtil.isEmpty(rowVal.physiclFileName2) == false) {
              window.open("/file/fileDownWasMobile.do?subPath=" + rowVal.fileSubPath2 + "&fileName=" + rowVal.physiclFileName2 + "&orignlFileNm=" + rowVal.atchFileName2);
            }
          }
        } else if (event.dataField == "attchImgUrl3") {
          if (FormUtil.isEmpty(event.value) == false) {
            var rowVal = AUIGrid.getItemByRowIndex(myGridID, event.rowIndex);
            if (FormUtil.isEmpty(rowVal.atchFileName3) == false && FormUtil.isEmpty(rowVal.physiclFileName3) == false) {
              window.open("/file/fileDownWasMobile.do?subPath=" + rowVal.fileSubPath3 + "&fileName=" + rowVal.physiclFileName3 + "&orignlFileNm=" + rowVal.atchFileName3);
            }
          }
        } else if (event.dataField == "attchImgUrl4") {
         if (FormUtil.isEmpty(event.value) == false) {
             var rowVal = AUIGrid.getItemByRowIndex(myGridID, event.rowIndex);
             if (FormUtil.isEmpty(rowVal.atchFileName4) == false && FormUtil.isEmpty(rowVal.physiclFileName4) == false) {
               window.open("/file/fileDownWasMobile.do?subPath=" + rowVal.fileSubPath4 + "&fileName=" + rowVal.physiclFileName4 + "&orignlFileNm=" + rowVal.atchFileName4);
             }
           }
         }

        if(event.dataField == "checkId"){
    		var isChecked = AUIGrid.getCellValue(myGridID, event.rowIndex, "checkId");
    		var mobPayGroupNo = AUIGrid.getCellValue(myGridID, event.rowIndex, "mobPayGroupNo");
    		var rows = AUIGrid.getRowsByValue(myGridID, "mobPayGroupNo", mobPayGroupNo);
    		var items = [];
    		for(var i = 0 ; i < rows.length; i++){
        		var rowIndex = AUIGrid.getRowIndexesByValue(myGridID, "mobPayDetailId", rows[i].mobPayDetailId);
    			AUIGrid.setCellValue(myGridID, rowIndex, "checkId",isChecked);
    		}
		}
      });
}

function loadComboBox() {
	doGetCombo('/common/selectCodeList.do', '439', '', 'payMode', 'L', ''); // Pay Mode
	doGetCombo('/common/selectCodeList.do', '49', '', 'cmbRegion', 'L', 'f_multiCombo'); //region
}

function f_multiCombo() {
	$(function() {
		$('#cmbRegion').change(function() {}).multipleSelect({
			selectAll: true,
			width: '80%'
		});
		$('#ticketStatus').change(function() {}).multipleSelect({
			selectAll: true,
			width: '80%'
		});
	});
}

function fn_clear() {
	$('#grpTicketNo').val('');
	$('#requestStartDate').val('');
	$('#requestEndDate').val('');
	$('#orderNo').val('');
	$('#ticketStatus').val('');
	$('#branchCode').val('');
	$('#cmbRegion').val('');
	$('#payMode').val('');
	$('#serialNo').val('');
	$('#memberCode').val('');
	$('#cardNoA').val('');
	$('#cardNoB').val('');
	$('#orgCode').val('');
	$('#grpCode').val('');
	$('#deptCode').val('');
}

//그리드 헤더 클릭 핸들러
function headerClickHandler(event) {
    // isActive 칼럼 클릭 한 경우
    if(event.dataField == "checkId") {
        if(event.orgEvent.target.id == "allCheckbox") { // 정확히 체크박스 클릭 한 경우만 적용 시킴.
            var  isChecked = document.getElementById("allCheckbox").checked;

            checkAll(isChecked);
        }
        return false;
    }
}

//전체 체크 설정, 전체 체크 해제 하기
function checkAll(isChecked) {
	 var idx = AUIGrid.getRowCount(myGridID);

    if(isChecked) {
    	for(var i = 0; i < idx; i++){
            if(AUIGrid.getCellValue(myGridID, i, "payStusName") == 'Active'){
                AUIGrid.setCellValue(myGridID, i, "checkId", "Y")
            }
        }
    } else {
        AUIGrid.updateAllToValue(myGridID, "checkId", "N");
    }

    // 헤더 체크 박스 일치시킴.
    document.getElementById("allCheckbox").checked = isChecked;
}

function fn_approveRecord(){
	selectedRecord = null;

    var selectedItems = AUIGrid.getItemsByValue(myGridID, "checkId", "Y");
    selectedItems = selectedItems.reduce(function (acc, cur) {
        return acc.filter(function (obj) {
            return obj.mobPayGroupNo !== cur.mobPayGroupNo
        }).concat([cur])
    }, []);

    if (selectedItems.length == 0) {
      Common.alert("<spring:message code='service.msg.NoRcd' />");
      return false;
    }
    if (selectedItems.length > 1) {
        Common.alert("Only 1 Record is allowed per approval.");
        return false;
    }
    fn_clearPopDetails();
    //card
    if(selectedItems[0].payMode == '5696'){
    	selectedRecord = selectedItems[0];
    	var totPayAmt = 0;

        var approvalNo = "";
        var crcName = "";

        var expiryDate = "";
        var expiryDateRaw = "";
        var transactionDate = "";
        var transactionDateRaw = "";

        var cardNo = "";
        var cardNoRaw = "";

        var cardMode = "";
        var cardModeRaw = "";
        var cardBrand = "";
        var cardBrandRaw = "";
        var issuBankId = "";
        var bankNm = "";
        var merchantBank = "";
        var merchantBankRaw = "";

        totPayAmt = selectedRecord.totPayAmt;
        approvalNo = selectedRecord.approvalNo;
        crcName = selectedRecord.crcName;
        cardNoRaw = selectedRecord.cardNo;

        expiryDateRaw = selectedRecord.expiryDate;
        transactionDate = selectedRecord.transactionDate;

        cardModeRaw = selectedRecord.cardMode;
        cardBrandRaw = selectedRecord.cardBrand;
        issuBankId = selectedRecord.issueBank;
        merchantBankRaw = selectedRecord.merchantBank;

        var cardNo1st1Val = cardNoRaw.substr(0, 1);
        var cardNo1st2Val = cardNoRaw.substr(0, 2);
        var cardNo1st4Val = cardNoRaw.substr(0, 4);

        if (cardNo1st1Val == 4) {
            if (cardBrandRaw != 112) {
              Common.alert("Card No. is not compatible with Card Type. System Recommend to Reject.");
              return;
            }
          }

          if ((cardNo1st2Val >= 51 && cardNo1st2Val <= 55) || (cardNo1st4Val >= 2221 && cardNo1st4Val <= 2720)) {
            if (cardBrandRaw != 111) {
            	Common.alert("Card No. is not compatible with Card Type. System Recommend to Reject.");
              return;
            }
          }

         if (totPayAmt == null || totPayAmt <= 0) {
              Common.alert("Pay amount is not fulfill requirement. System Recommend to Reject.");
              return;
         }

          if (totPayAmt > 200000) {
              Common.alert("Pay amount is not fulfill requirement. System Recommend to Reject.");
              return;
        }

        $("#keyInApprovalNo").val(approvalNo)
        $("#keyInHolderNm").val(crcName)
        $("#keyInCardNo1").val(cardNoRaw.substr(0, 4))
        $("#keyInCardNo2").val(cardNoRaw.substr(4, 4))
        $("#keyInCardNo3").val(cardNoRaw.substr(8, 4))
        $("#keyInCardNo4").val(cardNoRaw.substr(12, 4))

        $("#keyInCardMode").val(cardModeRaw)
        $("#keyInCrcType").val(cardBrandRaw)
        $("#keyInIssueBank").val(issuBankId)
        $("#keyInMerchantBank").val(merchantBankRaw)

        $("#keyInTrDate").val(transactionDate)
        $("#keyInExpiryMonth").val(expiryDateRaw.substr(0, 2))
        $("#keyInExpiryYear").val(expiryDateRaw.substr(2, 2))

        $("#keyInAmount").val(totPayAmt)
    	$("#PopUp2_wrap").show();
    	$("#PopUp1_wrap").hide();
    }
    else{
    	selectedRecord = selectedItems[0];
    	$("#PopUp1_wrap").show();
    	$("#PopUp2_wrap").hide();
    }
}

function fn_clearPopDetails() {
    $("#keyCrcCardType").val("");
    $("#keyInCrcType").val("");
    $("#keyInCardNo1").val("");
    $("#keyInCardNo2").val("");
    $("#keyInCardNo3").val("");
    $("#keyInCardNo4").val("");
    $("#keyInHolderNm").val("");
    $("#keyInExpiryMonth").val("");
    $("#keyInExpiryYear").val("");

    $('#transactionId').val("");
    $('#trRefNo').val("");
    $('#trIssDt').val("");
  }

//cash,cheque,bank-in slip
function saveNormalPayment() {
	 var data = {};
	 var msg = "";
	 if ($("#transactionId").val() == "") {
	      msg += "* <spring:message code='sys.msg.necessary' arguments='Transaction ID' htmlEscape='false'/><br/>";
	    }

	    if ($("#trRefNo").val() != "") {
	      if ($("#trIssDt").val() == "") {
	        msg += "* <spring:message code='sys.msg.necessary' arguments='TR Issued Date' htmlEscape='false'/><br/>";
	      }
	    }

	    if ($("#trIssDt").val() != "") {
	      if ($("#trRefNo").val() == "") {
	        msg += "* <spring:message code='sys.msg.necessary' arguments='TR Ref No.' htmlEscape='false'/><br/>";
	      }
	    }

	    if (msg != "") {
	      Common.alert(msg);
	      return false;
	    }

	    var payMode = selectedRecord.payMode;
	    var status = selectedRecord.payStusId;

	    if (status != "1") {
	       return false;
    	} else {
    		var transactionId = $("#transactionId").val();
    		var allowance = $("#allowance").val();
    		var trRefNo = $("#trRefNo").val();
    		var trIssDt = $("#trIssDt").val();
    		selectedRecord.transactionId = transactionId;
    		selectedRecord.allowance = allowance;
    		selectedRecord.trRefNo = trRefNo;
    		selectedRecord.trIssDt = trIssDt;
    		debugger;

    		Common.ajax("POST", "/payment/mobileLumpSumPayment/saveNormalPayment.do", selectedRecord, function(result) {
				console.log(result);

				fn_clearPopDetails();

				if (result.p1 == 99) {
			        Common.alert("<spring:message code='pay.alert.bankstmt.mapped'/>", function() {
						selectList();
			        });
			      }else if (result.appType == "CARE_SRVC") {
			          Common.ajax("GET", "/payment/common/selectProcessCSPaymentResult.do", {
			              seq : result.seq
			            }, function(resultInfo) {
			              var message = "<spring:message code='pay.alert.successProc'/>";

			              if (resultInfo != null && resultInfo.length > 0) {
			                for (i = 0; i < resultInfo.length; i++) {
			                  message += "<font color='red'>" + resultInfo[i].orNo + " (Order No: " + resultInfo[i].salesOrdNo + ")</font><br>";
			                }
			              }

			              Common.alert(message, function() {
								selectList();
			              });
			            });
			       }
			      else{
			    	  Common.ajax("GET", "/payment/common/selectProcessPaymentResult.do", {
			              seq : result.seq
			            }, function(resultInfo) {
			              var message = "<spring:message code='pay.alert.successProc'/>";

			              if (resultInfo != null && resultInfo.length > 0) {
			                for (i = 0; i < resultInfo.length; i++) {
			                  message += "<font color='red'>" + resultInfo[i].orNo + " (Order No: " + resultInfo[i].salesOrdNo + ")</font><br>";
			                }
			              }

			              Common.alert(message, function() {
								selectList();
						    	$("#PopUp1_wrap").hide();
						    	$("#PopUp2_wrap").hide();
			              });
			           });
		          }
    		});
    	}
}

//credit card
function saveCreditCardPayment(){
	var keyCrcCardType = $("#keyCrcCardType").val();
		if(keyCrcCardType == null || keyCrcCardType == ""){
	        Common.alert("Please choose a card type");
	        return;
		}

		if ($("#trRefNo2").val() != "") {
	    	if ($("#trIssDt2").val() == "") {
	        Common.alert("<spring:message code='sys.msg.necessary' arguments='TR Issued Date' htmlEscape='false'/>");
	        return;
	      	}
	    }

	    if ($("#trIssDt2").val() != "") {
	      if ($("#trRefNo2").val() == "") {
	        Common.alert("<spring:message code='sys.msg.necessary' arguments='TR Ref No.' htmlEscape='false'/>");
	        return;
	      }
	    }

	    var data = selectedRecord;

	    var payMode = selectedRecord.payMode;
	    var status = selectedRecord.payStusId;

	    var formList = $("#paymentForm").serializeArray();
	    if (formList.length > 0)
	        data.form = formList;
	    else
	        data.form = [];

	    if (status != "1") {
	       return false;
    	} else {
    		Common.ajaxSync("GET", "/payment/common/checkBatchPaymentExist.do", data.form, function(result) {
                 if(result != null){
                     Common.alert("Payment has been uploaded.");
                     return;
                 }else{
                    Common.ajax("POST", "/payment/mobileLumpSumPayment/saveCardPayment.do", data, function(result) {
                    	if(result.code == 00){
                    		var message = "<spring:message code='pay.alert.successProc'/>";

                            if (result != null && result.length > 0) {
                              for (i = 0; i < result.length; i++) {
                                message += "<font color='red'>" + result[i].orNo + " (Order No: " + result[i].salesOrdNo + ")</font><br>";
                              }
                            }
        					fn_clearPopDetails();

                            Common.alert(message, function() {
            			    	$("#PopUp1_wrap").hide();
            			    	$("#PopUp2_wrap").hide();
            					selectList();
                             });
        				}
        				else{
        				}
                    });
                }
             });
    	}
}

function fn_rejectRemarkPop(){
	$('#rejctResn1').val('');
	$('#reject_pop').show();
}

function fn_rejectRecord(value){
	if(value == 'C'){
		$('#reject_pop').hide();
		return false;
	}

	selectedRecord = null;

    var selectedItems = AUIGrid.getItemsByValue(myGridID, "checkId", "Y");
    selectedItems = selectedItems.reduce(function (acc, cur) {
        return acc.filter(function (obj) {
            return obj.mobPayGroupNo !== cur.mobPayGroupNo
        }).concat([cur])
    }, []);

    if (selectedItems.length == 0) {
      Common.alert("<spring:message code='service.msg.NoRcd' />");
      return false;
    }

    var info = [];
    for(var i =0; i < selectedItems.length; i++){
    	info.push(selectedItems[i].mobPayGroupNo);
    }

    Common.ajax("POST", "/payment/mobileLumpSumPayment/rejectApproval.do", {data: info.join(","),remark:$('#rejctResn1').val()}, function(result) {
    	if(result.code == 00){
    		var message = "Payment Reject Success.";

            if (result.data != null && result.data.length > 0) {
              for (i = 0; i < result.data.length; i++) {
                message += "<font color='red'>" + " (Ticket No: " + result.data[i].mobPayGroupNo + ")</font><br>";
              }
            }
            Common.alert(message, function() {
				selectList();
            });
		}
    	else{
    		Common.alert("Error on rejecting ticket", function() {
				selectList();
            });
    	}
		$('#reject_pop').hide();
    });
}

function fn_clear() {
    $("#searchForm")[0].reset();
}
</script>
<!-- html content -->
<section id="content">
	<ul class="path">
		<li><img
			src="${pageContext.request.contextPath}/resources/images/common/path_home.gif"
			alt="Home" /></li>
	</ul>
	<!-- title_line start -->
	<aside class="title_line">
		<p class="fav">
			<a href="#" class="click_add_on"> <spring:message
					code='pay.text.myMenu' />
			</a>
		</p>
		<h2>Lump Sum Payment Enroll List</h2>
		<ul class="right_btns">
			<c:if test="${PAGE_AUTH.funcView == 'Y'}">
				<li>
					<p class="btn_blue">
						<a id="_listSearchBtn" href="#"><span class="search"></span> <spring:message
								code='sys.btn.search' /> </a>
					</p>
				</li>
			</c:if>
			<li>
				<p class="btn_blue">
					<a href="#" onclick="fn_clear();"><span class="clear"></span> <spring:message
							code='sys.btn.clear' /> </a>
				</p>
			</li>
		</ul>
	</aside>
	<!-- title_line end -->
	<!-- search_table start -->
	<section class="search_table">
		<form id="searchForm" action="#" method="post">
			<table class="type1">
				<caption>table</caption>
				<colgroup>
					<col style="width: 140px" />
					<col style="width: *" />
					<col style="width: 130px" />
					<col style="width: *" />
					<col style="width: 170px" />
					<col style="width: *" />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row"><span>Group Ticket No.</span></th>
						<td><input type="text" title="Group Ticket No"
							id="grpTicketNo" name="grpTicketNo" placeholder="Group Ticket No"
							class="w100p" /></td>
						<th scope="row"><spring:message code="pay.grid.requestDate" />
						</th>
						<td>
							<div class="date_set w100p">
								<!-- date_set start -->
								<p>
									<input id="requestStartDate" name="requestStartDate"
										type="text" title="Create start Date" placeholder="DD/MM/YYYY"
										class="j_date" value="" />
								</p>
								<span>To</span>
								<p>
									<input id="requestEndDate" name="requestEndDate" type="text"
										title="Create end Date" placeholder="DD/MM/YYYY"
										class="j_date" value="" />
								</p>
							</div> <!-- date_set end -->
						</td>
						<th scope="row"><spring:message code="pay.title.orderNo" />
						</th>
						<td><input type="text" title="Order No" id="orderNo"
							name="orderNo" placeholder="Order No" class="w100p" /></td>
					</tr>
					<tr>
						<th scope="row"><spring:message code="pay.title.ticketStatus" /></th>
						<td><select id="ticketStatus" name="ticketStatus"
							class="multy_select w100p" multiple="multiple">
								<option value="1">Active</option>
								<option value="104">Processing</option>
								<option value="5">Approved</option>
								<option value="6">Rejected</option>
								<option value="21">Failed</option>
								<option value="10">Cancelled</option>
						</select></td>
						<th scope="row"><spring:message code="pay.title.branchCode" /></th>
						<td><select class="multy_select w100p" id="branchCode"
							name="branchCode" multiple="multiple">
								<c:forEach var="list" items="${userBranch}" varStatus="status">
									<option value="${list.branchid}">${list.c1}</option>
								</c:forEach>
						</select></td>
						<th scope="row">Region</th>
						<td><select id="cmbRegion" name="cmbRegion"
							class="multy_select w100p" multiple="multiple">
						</select></td>
					</tr>
					<tr>
						<th scope="row"><spring:message code="sal.text.payMode" /></th>
						<td><select id="payMode" name="payMode" class="w100p"></select>
						</td>
						<th scope="row"><spring:message code="pay.head.slipNo" /> /
							<spring:message code="pay.title.chequeNo" /></th>
						<td><input type="text" title="Slip No / Cheque No"
							id=serialNo name="serialNo" class="w100p" /></td>
						<th scope="row"><spring:message code="pay.title.memberCode" /></th>
						<td><input type="text"
							title="<spring:message code="pay.title.memberCode" />"
							id="memberCode" name="memberCode" class="w100p" value="" /></td>
					</tr>
					<tr>
						<th scope="row"><spring:message code="sal.title.text.apprvNo" /></th>
						<td><input type="text" title="Apprv No" id="apprvNo"
							name="apprvNo" class="w100p" /></td>
						<th scope="row"><spring:message code="pay.head.crc.cardNo" /></th>
						<td>
							<p class="short">
								<input type="text" title="First 6 Card No." id="cardNoA"
									name="cardNoA" size="10" maxlength="6" class="wAuto"
									placeholder="First 6 no." />
							</p> <span>**-****-</span>
							<p class="short">
								<input type="text" title="Last 4 Card No." id="cardNoB"
									name="cardNoB" size="10" maxlength="4" class="wAuto"
									placeholder="Last 4 no." />
							</p>

						</td>
						<th></th>
						<td></td>
					</tr>

					<tr>
						<th scope="row"><spring:message code="sal.text.orgCode" /></th>
						<td><input type="text"
							title="<spring:message code="sal.text.orgCode" />" id="orgCode"
							name="orgCode" class="w100p" disabled value="${memDetail.orgcde}" />
							<input type="hidden" title="" id="hidOrgCode" name="hidOrgCode"
							class="w100p" value="${memDetail.orgcde}" /></td>
						<th scope="row"><spring:message code="sal.text.grpCode" /></th>
						<td><input type="text"
							title="<spring:message code="sal.text.orgCode" />" id="grpCode"
							name="grpCode" class="w100p" disabled value="${memDetail.grpcde}" />
							<input type="hidden" title="" id="hidGrpCode" name="hidGrpCode"
							class="w100p" value="${memDetail.grpcde}" /></td>
						<th scope="row"><spring:message code="sal.text.detpCode" /></th>
						<td><input type="text"
							title="<spring:message code="sal.text.detpCode" />" id="deptCode"
							name="deptCode" class="w100p" disabled
							value="${memDetail.deptcde}" /> <input type="hidden" title=""
							id="hidDeptCode" name="hidDeptCode" class="w100p"
							value="${memDetail.deptcde}" /></td>
					</tr>
				</tbody>
			</table>
		</form>
	</section>
	<ul class="right_btns">
		<c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
			<li><p class="btn_grid">
					<a href="#" onClick="fn_viewLdg()"><spring:message
							code="sal.btn.ledger" /> </a>
				</p></li>
		</c:if>
		<c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
			<li><p class="btn_grid">
					<a href="#" onClick="fn_approveRecord()"><spring:message
							code="pay.btn.approve" /> </a>
				</p></li>
		</c:if>
		<c:if test="${PAGE_AUTH.funcUserDefine3 == 'Y'}">
			<li><p class="btn_grid">
					<a href="#" onClick="fn_rejectRemarkPop()"><spring:message
							code="pay.btn.failreject" /> </a>
				</p></li>
		</c:if>
		<c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
			<li><p class="btn_grid">
					<a href="#" onClick="fn_excelDown()"><spring:message
							code="pay.btn.exceldw" /></a>
				</p></li>
		</c:if>
	</ul>

	<!-- search_result start -->
	<section class="search_result">
		<article class="grid_wrap">
			<!-- grid_wrap start -->
			<div id="grid_wrap" style="width: 100%; margin: 0 auto;"
				class="autoGridHeight"></div>
			<!-- grid_wrap end -->
		</article>
	</section>
	<!-- search_result end -->

	<!--  Pop Up 1 -->
	 <div id="PopUp1_wrap" class="popup_wrap" style="display: none;">
        <!-- popup_wrap start -->
        <header class="pop_header">
          <!-- pop_header start -->
          <h1>Update [ Cash, Cheque, Bank-In Slip ] Key-in</h1>
          <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#"><spring:message code='sys.btn.close' /></a></p></li>
          </ul>
        </header>
        <section style="max-height: 500px; padding: 10px; background: #fff; overflow-y: scroll;">
          <!-- pop_body start -->
          <form id="paymentForm1" name="paymentForm1">
            <input type="hidden" id="payType" name="payType" /> <input type="hidden" name="keyInPayRoute" id="keyInPayRoute" value="WEB" /> <input type="hidden" name="keyInScrn" id="keyInScrn" value="NOR" />
            <table class="type1">
              <!-- table start -->
              <caption>table</caption>
              <colgroup>
                <col style="width: 160px" />
                <col style="width: *" />
                <col style="width: 160px" />
                <col style="width: *" />
              </colgroup>
              <tbody>
                <tr>
                  <th scope="row">Transaction ID <span class="must">*</span></th>
                  <td colspan="3">
                    <div>
                      <!-- auto_file start -->
                      <input type="text" id="transactionId" name="transactionId" placeholder="Transaction ID" value="" /> <input id="allowance" type="checkbox" name="allowance" value="1" checked><label for="allowance"> Allow commission for this payment</label>
                    </div>
                    <!-- auto_file end -->
                  </td>
                </tr>
                <tr>
                  <th scope="row">TR Ref No.</th>
                  <td>
                    <input type="text" id="trRefNo" name="trRefNo" value="" placeholder="TR Ref.No." />
                  </td>
                  <th scope="row">TR Issued Date</th>
                  <td>
                    <input type="text" title="" placeholder="DD/MM/YYYY" class="j_date" id="trIssDt" name="trIssDt" />
                  </td>
                </tr>
              </tbody>
            </table>
            <!-- table end -->
          </form>
          <ul class="center_btns">
            <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
              <li><p class="btn_blue2 big"><a id="savePayment1" href="javascript:saveNormalPayment();"><spring:message code='sys.btn.save' /></a></p></li>
            </c:if>
          </ul>
          </div>
	<!--  Pop Up 1 -->

	<!--  Pop Up 2 -->
        <div id="PopUp2_wrap" class="popup_wrap win_popup" style="display: none;">
        <!-- popup_wrap start -->
        <header class="pop_header">
          <!-- pop_header start -->
          <h1>Update [ Card ] Key-in</h1>
          <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#"><spring:message code='sys.btn.close' /></a></p></li>
          </ul>
        </header>
        <!-- search_table start -->
        <section style="max-height: 500px; padding: 10px; background: #fff; overflow-y: scroll;">
          <!-- search_table start -->
          <form id="paymentForm" action="#" method="post">
            <input type="hidden" name="keyInPayRoute" id="keyInPayRoute" value="WEB" />
            <input type="hidden" name="keyInScrn" id="keyInScrn" value="CRC" />
            <input type="hidden" name="keyInPayType" id="keyInPayType" value="107" />
            <table class="type1">
              <caption>table</caption>
              <colgroup>
                <col style="width: 180px" />
                <col style="width: *" />
                <col style="width: 180px" />
                <col style="width: *" />
              </colgroup>
              <tbody>

                 <!-- <input  type="hidden"  id="keyCrcCardType" name="keyCrcCardType" class="w100p" readonly="readonly" /> -->
                <input  type="hidden"  id="keyInAmount" name="keyInAmount" class="w100p" readonly="readonly" />
                <input  type="hidden"  id="keyInCardMode" name="keyInCardMode" class="w100p" readonly="readonly" />
                <input  type="hidden"  id="keyInCrcType" name="keyInCrcType" class="w100p" readonly="readonly" />

                <input  type="hidden"  id="keyInCardNo1" name="keyInCardNo1" class="w100p" readonly="readonly" />
                <input  type="hidden"  id="keyInCardNo2" name="keyInCardNo2" class="w100p" readonly="readonly" />
                <input  type="hidden"  id="keyInCardNo3" name="keyInCardNo3" class="w100p" readonly="readonly" />
                <input  type="hidden"  id="keyInCardNo4" name="keyInCardNo4" class="w100p" readonly="readonly" />

                <input  type="hidden"  id="keyInApprovalNo" name="keyInApprovalNo" class="w100p" readonly="readonly" />
                <input  type="hidden"  id="keyInHolderNm" name="keyInHolderNm" class="w100p" readonly="readonly" />

                 <input  type="hidden"  id="keyInIssueBank" name="keyInIssueBank" class="w100p" readonly="readonly" />
                 <input  type="hidden"  id="keyInMerchantBank" name="keyInMerchantBank" class="w100p" readonly="readonly" />

                 <input  type="hidden"  id="keyInExpiryMonth" name="keyInExpiryMonth" class="w100p" readonly="readonly" />
                 <input  type="hidden"  id="keyInExpiryYear" name="keyInExpiryYear" class="w100p" readonly="readonly" />

                 <input  type="hidden" id="keyInTrDate" name="keyInTrDate" />


                <tr>
                  <th scope="row">Card Type<span class="must">*</span></th>
                  <td>
                     <select id="keyCrcCardType" name="keyCrcCardType" class="w100p" readonly="readonly">
                      <option value="1241">Credit Card</option>
                      <option value="1240">Debit Card</option>
                    </select>

                  </td>
                   <td>
                   </td>
                </tr>
                <tr>
                  <th scope="row">TR Ref No.</th>
                  <td>
                    <input type="text" id="trRefNo2" name="trRefNo2" value="" />
                  </td>
                  <th scope="row">TR Issued Date</th>
                  <td>
                    <input type="text" title="" placeholder="DD/MM/YYYY" class="j_date" id="trIssDt2" name="trIssDt2" />
                  </td>
                </tr>

                <tr>
                  <td colspan="4">
                    <div>
                      <input id="allowance2" type="checkbox" name="allowance" value="1" checked><label for="allowance2"> Allow commission for this payment</label>
                    </div>
                  </td>
                </tr>

              </tbody>
            </table>
            <!-- table end -->
          </form>
          <ul class="center_btns">
            <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
              <li><p class="btn_blue2 big"><a id="cardSave" href="javascript:saveCreditCardPayment();"><spring:message code='sys.btn.save' /></a></p></li>
            </c:if>
          </ul>
        <form id="frmLedger" name="frmLedger" action="#" method="post">
          <input id="ordId" name="ordId" type="hidden" value="" />
        </form>
        <!-- search_table end -->
      </div>
      <!-- popup_wrap end -->

<!-- popup_wrap start -->
<div class="popup_wrap size_small" id="updFail_wrap" style="display:none;">
    <!-- pop_header start -->
    <header class="pop_header" id="updFail_pop_header">
        <h1>Update Status</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" onclick="fn_close()">CLOSE</a></p></li>
        </ul>
    </header>
    <!-- pop_header end -->

    <!-- pop_body start -->
    <form name="updFailForm" id="updFailForm"  method="post">
    <section class="pop_body">
        <!-- search_table start -->
        <section class="search_table">
            <!-- table start -->
            <table class="type1">
                <caption>table</caption>
                 <colgroup>
                    <col style="width:175px" />
                    <col style="width:*" />
                </colgroup>

                <tbody>
                <tr>
                     <th scope="row">Action<span class="must">*</span></th>
                     <td><select id="_action" name="_action"></select></td>
                 </tr>

                 <tr id="fail_reason" style="display: none;">
                     <th scope="row">Fail reason code<span class="must">*</span></th>
                        <td><select id="failReason" name="failReason" class="w50p"></select></td>
                 </tr>
                 <tr id="reject_reason" style="display: none;">
                     <th scope="row">Reject reason code<span class="must">*</span></th>
                        <td><select id="rejectReason" name="rejectReason" class="w50p"></select></td>
                 </tr>
                 <tr id="rem">
                     <th scope="row"><spring:message code="pay.head.remark" /></th>
                         <td>
                             <textarea cols="20" rows="2" id="etc" name="etc" placeholder="Remark"></textarea>
                         </td>
                 </tr>
                </tbody>
            </table>
        </section>

        <ul class="center_btns" >
            <li><p class="btn_blue2"><a href="#" onClick="fn_updateFailStatus()">Save</a></p></li>
        </ul>
    </section>
    </form>
    <!-- pop_body end -->
</div>

<!-- popup_wrap start -->
<div class="popup_wrap size_mid" id="errSum_wrap" style="display:none;">
    <!-- pop_header start -->
    <header class="pop_header" id="updFail_pop_header">
        <h1>Cody Keyin Error Summary</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" onclick="fn_close()">CLOSE</a></p></li>
        </ul>
    </header>
    <!-- pop_header end -->

    <!-- pop_body start -->
    <form name="errorSummaryReport" id="errorSummaryReport"  method="post">
	<input type="hidden" id="reportFileName" name="reportFileName" value="" />
	<input type="hidden" id="viewType" name="viewType" />
	<input type="hidden" id="reportDownFileName" name="reportDownFileName"  />
    <input type="hidden" id="V_WHERESQL" name="V_WHERESQL" />

    <section class="pop_body">
        <!-- search_table start -->
        <section class="search_table">
            <!-- table start -->
            <table class="type1">
                <caption>table</caption>
                 <colgroup>
                    <col style="width:175px" />
                    <col style="width:*" />
                </colgroup>

                <tbody>
                <tr>
                    <th scope="row"><spring:message code='pay.head.requestDate'/></th>
                    <td>
					    <div class="date_set w100p">
					    <p><input id="startDt" name="startDt" type="text" value="" title="Request start date" placeholder="DD/MM/YYYY" class="j_date" /></p>
					    <span>To</span>
					    <p><input id="endDt" name="endDt" type="text" value="" title="Request end date" placeholder="DD/MM/YYYY" class="j_date" /></p>
					    </div>
				    </td>
				 </tr>
                 <tr>
                     <th scope="row"><spring:message code='sal.title.text.region'/></th>
                        <td><select id="_region" name="_region" class="w100p"></select></td>
                 </tr>
                 <tr>
                     <th scope="row"><spring:message code='pay.head.branch'/></th>
                        <td>
                        <select class="multy_select w100p" id="_branch" name="_branch" multiple="multiple" disabled>
				                <c:forEach var="list" items="${userBranch}" varStatus="status">
				                  <option value="${list.branchid}">${list.c1}</option>
				                </c:forEach>
				              </select>
                        </td>
                 </tr>
                </tbody>
            </table>
        </section>

        <ul class="center_btns" >
            <li><p class="btn_blue2"><a href="#" onClick="fn_generate()">Save</a></p></li>
        </ul>
    </section>
    </form>
    <!-- pop_body end -->
</div>
</section>
	<!--  Pop Up 2 -->

	<div id="reject_pop" class="popup_wrap msg_box"  style="display:none;">
    <header class="pop_header">
        <h1>Reject Reason</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#"><spring:message code="expense.CLOSE" /></a></p></li>
        </ul>
    </header>

    <section class="pop_body">
        <p class="msg_txt">
            <spring:message code="rejectionWebInvoiceMsg.registMsg" />
            <textarea cols="20" rows="5" id="rejctResn1" placeholder="Reject reason max 400 characters"></textarea>
        </p>

        <ul class="center_btns">
            <li><p class="btn_blue"><a href="#" onclick="javascript:fn_rejectRecord('P');">Proceed</a></p></li>
            <li><p class="btn_blue"><a href="#" onclick="javascript:fn_rejectRecord('C')">Cancel</a></p></li>
        </ul>
    </section>
</div>
</section>
<!-- html content -->