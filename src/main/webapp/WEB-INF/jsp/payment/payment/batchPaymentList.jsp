<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<style type="text/css">
.my-custom-up div{
    color:#FF0000;
}
/* 커스텀 행 스타일 */
.my-row-style {
    background:#FFB6C1;
    font-weight:bold;
    color:#22741C;
}
</style>
<script type="text/javaScript">

//AUIGrid 그리드 객체
var myGridID;
var batchInfoGridID;
var batchConfGridID;
var myUploadGridID;

//Grid에서 선택된 RowID
var selectedGridValue;

var gridPros = {
        // 편집 가능 여부 (기본값 : false)
        editable : false,

        // 상태 칼럼 사용
        showStateColumn : false,
        selectionMode       : "singleRow"
};

var gridPros2 = {
        // 편집 가능 여부 (기본값 : false)
        editable : false,

        // 상태 칼럼 사용
        showStateColumn : false,

        // row Styling 함수
        rowStyleFunction : function(rowIndex, item) {
            if(item.validStusId == "21") {
                return "my-row-style";
            }
            return "";
        }
};

var gridPros3 = {

        // 편집 가능 여부 (기본값 : false)
  //editable : false,
  // 상태 칼럼 사용
  showStateColumn : false,
  // 기본 헤더 높이 지정
  headerHeight : 35,

  softRemoveRowMode:false

}

$(document).ready(function(){


	myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,null,gridPros);
	myUploadGridID = GridCommon.createAUIGrid("grid_upload_wrap", uploadGridLayout,null,gridPros3);

	// Master Grid 셀 클릭시 이벤트
    AUIGrid.bind(myGridID, "cellClick", function( event ){
        selectedGridValue = event.rowIndex;
    });

	$("#payMode").multipleSelect("checkAll");
	$("#confirmStatus").multipleSelect("setSelects", [44]);
	$("#batchStatus").multipleSelect("setSelects", [1]);

	$('#uploadfile').on('change', function(evt) {
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
                    AUIGrid.setCsvGridData(myUploadGridID, event.target.result, false);

                    //csv 파일이 header가 있는 파일이면 첫번째 행(header)은 삭제한다.
                    AUIGrid.removeRow(myUploadGridID,0);
                } else {
                    Common.alert("<spring:message code='pay.alert.noData'/>");
                }
            };

            reader.onerror = function() {
                Common.alert("<spring:message code='pay.alert.unableToRead' arguments='"+file.fileName+"' htmlEscape='false'/>");
            };
        }

    });

	$('#advance').change(function(){
		if(this.checked){
			$('#eMandateDisplay').show();
		}
		else{
			$('#eMandateDisplay').hide();
			$('#eMandate').attr('checked',false);
		}
	});

});

// AUIGrid 칼럼 설정
var columnLayout = [
    {
        dataField : "batchId",
        headerText : "<spring:message code='pay.head.batchId'/>",
        editable : false
    }, {
        dataField : "codeName",
        headerText : "<spring:message code='pay.head.paymode'/>",
        editable : false
    }, {
        dataField : "name",
        headerText : "<spring:message code='pay.head.batchStatus'/>",
        editable : false
    }, {
        dataField : "name1",
        headerText : "<spring:message code='pay.head.confirmStatus'/>",
        editable : false
    }, {
        dataField : "updDt",
        headerText : "<spring:message code='pay.head.uploadDate'/>",
        editable : false
    }, {
        dataField : "userName",
        headerText : "<spring:message code='pay.head.uploadBy'/>",
        editable : false
    }, {
        dataField : "cnfmDt",
        headerText : "<spring:message code='pay.head.confirmDate'/>/Deactivate Date",
        editable : false
    }, {
        dataField : "c1",
        headerText : "<spring:message code='pay.head.confirmBy'/>/Deactivated By",
        editable : false
    }, {
        dataField : "cnvrDt",
        headerText : "<spring:message code='pay.head.convertDate'/>",
        editable : false
    },{
        dataField : "c2",
        headerText : "<spring:message code='pay.head.convertBy'/>",
        editable : false
    },{
        dataField : "batchStusId",
        headerText : "",
        editable : false,
        visible : false
    },{
        dataField : "cnfmStusId",
        headerText : "",
        editable : false,
        visible : false
    },{
        dataField : "batchIsAdv",
        headerText : "<spring:message code='pay.head.advanceBatch'/>",
        editable : false
    }];

var uploadGridLayout = [
                        {dataField : "0", headerText : "<spring:message code='pay.head.orderNo'/>", editable : true},
                        {dataField : "1", headerText : "<spring:message code='pay.head.TRNo'/>", editable : true},
                        {dataField : "2", headerText : "<spring:message code='pay.head.refNo'/>", editable : true},
                        {dataField : "3", headerText : "<spring:message code='pay.head.Amount'/>", editable : true, dataType:"numeric", formatString:"#,##0.00"},
                        {dataField : "4", headerText : "<spring:message code='pay.head.bankAcc'/>", editable : true},
                        {dataField : "5", headerText : "<spring:message code='pay.head.chqNo'/>", editable : true},
                        {dataField : "6", headerText : "<spring:message code='pay.head.issueBank'/>", editable : true},
                        {dataField : "7", headerText : "<spring:message code='pay.head.runningNo'/>", editable : true},
                        {dataField : "8", headerText : "<spring:message code='pay.head.eftNo'/>", editable : true},
                        {dataField : "9", headerText : "<spring:message code='pay.head.refDateMonth'/>", editable : true},
                        {dataField : "10", headerText : "<spring:message code='pay.head.refDateDay'/>", editable : true},
                        {dataField : "11", headerText : "<spring:message code='pay.head.refDateYear'/>", editable : true},
                        {dataField : "12", headerText : "<spring:message code='pay.head.bankChargeAmt'/>", editable : true},
                        {dataField : "13", headerText : "<spring:message code='pay.head.bankChargeAcc'/>", editable : true},
                        {dataField : "14", headerText : "<spring:message code='pay.head.trDate'/>", editable : true},
                        {dataField : "15", headerText : "<spring:message code='sal.text.collectorCode'/>", editable : true},
                        {dataField : "16", headerText : "<spring:message code='pay.head.payType'/>", editable : true},
                        {dataField : "17", headerText : "<spring:message code='pay.head.advanceMonth'/>", editable : true},
                        {dataField : "18", headerText : "<spring:message code='pay.head.remark'/>", editable : true},
                        {dataField : "19", headerText : "<spring:message code='pay.head.crc.cardNo'/>", editable : true},
                        {dataField : "20", headerText : "<spring:message code='pay.head.approvalCode'/>", editable : true},
                        {dataField : "21", headerText : "<spring:message code='pay.head.cardMode'/>", editable : true},
                        {dataField : "22", headerText : "<spring:message code='sal.title.text.paymentChnnl'/>", editable : true}
                        ];


//AUIGrid 칼럼 설정
var batchInfoLayout = [
    {
        dataField : "code",
        headerText : "<spring:message code='pay.head.validStatus'/>",
        editable : false
    }, {
        dataField : "validRem",
        headerText : "<spring:message code='pay.head.validRemark'/>",
        editable : false
    }, {
        dataField : "userOrdNo",
        headerText : "<spring:message code='pay.head.orderNo'/>",
        editable : false
    }, {
        dataField : "userTrNo",
        headerText : "<spring:message code='pay.head.trNo'/>",
        editable : false
    }, {
        dataField : "userRefNo",
        headerText : "<spring:message code='pay.head.refNo'/>",
        editable : false
    }, {
        dataField : "userAmt",
        headerText : "<spring:message code='pay.head.amount'/>",
        editable : false
    }, {
        dataField : "userBankAcc",
        headerText : "<spring:message code='pay.head.bankAcc'/>",
        editable : false
    }, {
        dataField : "userChqNo",
        headerText : "<spring:message code='pay.head.chqNo'/>",
        editable : false
    }, {
        dataField : "userIssBank",
        headerText : "<spring:message code='pay.head.issueBank'/>",
        editable : false
    }, {
        dataField : "userRunNo",
        headerText : "<spring:message code='pay.head.runningNo'/>",
        editable : false
    },{
        dataField : "userEftNo",
        headerText : "<spring:message code='pay.head.eftNo'/>",
        editable : false
    },{
        dataField : "userRefDtMonth",
        headerText : "<spring:message code='pay.head.refDateMonth'/>",
        editable : false
    },{
        dataField : "userRefDtDay",
        headerText : "<spring:message code='pay.head.refDateDay'/>",
        editable : false
    },{
        dataField : "userRefDtYear",
        headerText : "<spring:message code='pay.head.refDateYear'/>",
        editable : false
    },{
        dataField : "userBcAmt",
        headerText : "<spring:message code='pay.head.bankChargeAmt'/>",
        editable : false
    },{
        dataField : "userBcAcc",
        headerText : "<spring:message code='pay.head.bankChargeAcc'/>",
        editable : false
    },{
        dataField : "payChannel",
        headerText : "<spring:message code='sal.title.text.paymentChnnl'/>",
        editable : false
    }];

    //AUIGrid 칼럼 설정
    var batchListLayout = [
        { dataField:"history" ,
           width: 30,
           headerText:" ",
           renderer :
           {
              type : "IconRenderer",
              iconTableRef :  {
                  "default" : "${pageContext.request.contextPath}/resources/images/common/icon_gabage_s.png"// default
              },
              iconWidth : 16,
              iconHeight : 16,
              onclick : function(rowIndex, columnIndex, value, item) {
            	  if(item.validStusId == "4" || item.validStusId == "21"){
                      fn_removeItem(item.detId);
                  }
              }
           }
        },{
            dataField : "code",
            headerText : "<spring:message code='pay.head.validStatus'/>",
            editable : false,
            width : 100
        }, {
            dataField : "validRem",
            headerText : "<spring:message code='pay.head.validRemark'/>",
            editable : false,
            width : 100
        }, {
            dataField : "userOrdNo",
            headerText : "<spring:message code='pay.head.orderNo'/>",
            editable : false
        }, {
            dataField : "userTrNo",
            headerText : "<spring:message code='pay.head.trNo'/>",
            editable : false
        }, {
            dataField : "userRefNo",
            headerText : "<spring:message code='pay.head.refNo'/>",
            editable : false
        }, {
            dataField : "userAmt",
            headerText : "<spring:message code='pay.head.amount'/>",
            editable : false
        }, {
            dataField : "userBankAcc",
            headerText : "<spring:message code='pay.head.bankAcc'/>",
            editable : false
        }, {
            dataField : "userChqNo",
            headerText : "<spring:message code='pay.head.chqNo'/>",
            editable : false
        }, {
            dataField : "userIssBank",
            headerText : "<spring:message code='pay.head.issueBank'/>",
            editable : false
        }, {
            dataField : "userRunNo",
            headerText : "<spring:message code='pay.head.runningNo'/>",
            editable : false,
            width : 120
        },{
            dataField : "userEftNo",
            headerText : "<spring:message code='pay.head.eftNo'/>",
            editable : false
        },{
            dataField : "userRefDtMonth",
            headerText : "<spring:message code='pay.head.refDateMonth'/>",
            editable : false,
            width : 100
        },{
            dataField : "userRefDtDay",
            headerText : "<spring:message code='pay.head.refDateDay'/>",
            editable : false,
            width : 120
        },{
            dataField : "userRefDtYear",
            headerText : "<spring:message code='pay.head.refDateYear'/>",
            editable : false,
            width : 130
        },{
            dataField : "userBcAmt",
            headerText : "<spring:message code='pay.head.bankChargeAmt'/>",
            editable : false
        },{
            dataField : "userBcAcc",
            headerText : "<spring:message code='pay.head.bankChargeAcc'/>",
            editable : false
        },{
            dataField : "cardNo",
            headerText : "Credit Card No",
            editable : false,
            width : 150
        },{
            dataField : "approvalCode",
            headerText : "Approval Code",
            editable : false,
            width : 120
        },{
            dataField : "payChannel",
            headerText : "<spring:message code='sal.title.text.paymentChnnl'/>",
            editable : false,
            width : 120
        }];


    // ajax list 조회.
    function searchList(){
    	Common.ajax("GET","/payment/selectBatchPaymentList.do",$("#searchForm").serialize(), function(result){
    		console.log(result);
    		AUIGrid.setGridData(myGridID, result);
    	});
    }

    function fn_viewBatchPopup(){

    	var selectedItem = AUIGrid.getSelectedIndex(myGridID);

        if (selectedItem[0] > -1){

        	var batchId = AUIGrid.getCellValue(myGridID, selectedGridValue, "batchId");

        	Common.ajax("GET","/payment/selectBatchInfo.do",{"batchId":batchId}, function(result){
        		$('#view_popup_wrap').show();
                console.log(result);

                var confAt = result.batchPaymentView.cnfmDt;
                var confAtArray = confAt.split('-');
                var cnvrAt = result.batchPaymentView.cnvrDt;
                var cnvrAtArray = cnvrAt.split('-');

                $('#txtBatchId').text(result.batchPaymentView.batchId);
                $('#txtBatchStatus').text(result.batchPaymentView.name);
                $('#txtConfirmStatus').text(result.batchPaymentView.name1);
                $('#txtPayMode').text(result.batchPaymentView.codeName);
                $('#txtUploadBy').text(result.batchPaymentView.userName);
                $('#txtUploadAt').text(result.batchPaymentView.crtDt);
                $('#txtConfirmBy').text(result.batchPaymentView.c1);
                $('#txtBatchIsAdv').text(result.batchPaymentView.batchIsAdv);

                if(confAtArray[2].substr(0,4) > 1900){
                	$('#txtConfirmAt').text(result.batchPaymentView.cnfmDt);
                }else{
                	$('#txtConfirmAt').text("");
                }

                if(cnvrAtArray[2].substr(0,4) > 1900){
                	$('#txtConvertAt').text(result.batchPaymentView.cnvrDt);
                }else{
                	$('#txtConvertAt').text("");
                }


                //TOTAL
                $('#totalAmount').text(result.totalValidAmt.sysAmt);
                $('#totalItem').text(result.totalItem);
                $('#totalValid').text(result.totalValidAmt.c1);
                $('#totalInvalid').text((result.totalItem) - (result.totalValidAmt.c1));

                AUIGrid.destroy(batchInfoGridID);
                batchInfoGridID = GridCommon.createAUIGrid("view_grid_wrap", batchInfoLayout,null,gridPros2);
                AUIGrid.setGridData(batchInfoGridID, result.batchPaymentDetList);
                AUIGrid.resize(batchInfoGridID,942, 280);
            });

        }else{
            Common.alert('No batch selected. ');
        }
    }

    function fn_batchPayItemList(validStatusId, gubun){
    	var batchId = AUIGrid.getCellValue(myGridID, selectedGridValue, "batchId");

    	Common.ajax("GET","/payment/selectBatchPayItemList.do",{"batchId":batchId, "validStatusId" : validStatusId}, function(result){

    	    if(gubun == "V"){//VIEW

    	    	if(validStatusId == "4"){
                    $('#itemGubun').text("Valid Items");
                }else if(validStatusId == "21"){
                    $('#itemGubun').text("Invalid Items");
                }else{
                    $('#itemGubun').text("All Items");
                }

                AUIGrid.destroy(batchInfoGridID);
                batchInfoGridID = GridCommon.createAUIGrid("view_grid_wrap", batchInfoLayout,null,gridPros2);
                AUIGrid.setGridData(batchInfoGridID, result.batchPaymentDetList);
                AUIGrid.resize(batchInfoGridID,942, 280);

            }else if(gubun == "C"){//CONFIRM

            	if(validStatusId == "4"){
                    $('#itemGubun_conf').text("Valid Items");
                }else if(validStatusId == "21"){
                    $('#itemGubun_conf').text("Invalid Items");
                }else{
                    $('#itemGubun_conf').text("All Items");
                }

                AUIGrid.destroy(batchConfGridID);
                batchConfGridID = GridCommon.createAUIGrid("conf_grid_wrap", batchListLayout,null,gridPros2);
                AUIGrid.setGridData(batchConfGridID, result.batchPaymentDetList);
                AUIGrid.resize(batchConfGridID,980, 280);
            }
    	});
    }

    function fn_confirmBatchPopup(){

        var selectedItem = AUIGrid.getSelectedIndex(myGridID);

        if (selectedItem[0] > -1){
            var batchId = AUIGrid.getCellValue(myGridID, selectedGridValue, "batchId");
            var cnfmStusId = AUIGrid.getCellValue(myGridID, selectedGridValue, "cnfmStusId");
            var batchStusId = AUIGrid.getCellValue(myGridID, selectedGridValue, "batchStusId");

            if(batchStusId == "1"){

            	if(cnfmStusId == "77"){
            		$('#btnConf').hide();
            	}else{
            		$('#btnConf').show();
            	}

                Common.ajax("GET","/payment/selectBatchInfo.do",{"batchId":batchId}, function(result){
                	$('#conf_popup_wrap').show();

                    var confAt = result.batchPaymentView.cnfmDt;
                    var confAtArray = confAt.split('-');
                    var cnvrAt = result.batchPaymentView.cnvrDt;
                    var cnvrAtArray = cnvrAt.split('-');

                    $('#txtBatchId_conf').text(result.batchPaymentView.batchId);
                    $('#txtBatchStatus_conf').text(result.batchPaymentView.name);
                    $('#txtConfirmStatus_conf').text(result.batchPaymentView.name1);
                    $('#txtPayMode_conf').text(result.batchPaymentView.codeName);
                    $('#txtUploadBy_conf').text(result.batchPaymentView.userName);
                    $('#txtUploadAt_conf').text(result.batchPaymentView.crtDt);
                    $('#txtConfirmBy_conf').text(result.batchPaymentView.c1);
                    $('#txtConvertBy_conf').text(result.batchPaymentView.c2);
                    $('#txtBatchIsAdv_conf').text(result.batchPaymentView.batchIsAdv);


                    if(confAtArray[2].substr(0,4) > 1900){
                    	$('#txtConfirmAt_conf').text(result.batchPaymentView.cnfmDt);
                    }else{
                    	$('#txtConfirmAt_conf').text("");
                    }

                    if(cnvrAtArray[2].substr(0,4) > 1900){
                    	$('#txtConvertAt_conf').text(result.batchPaymentView.cnvrDt);
                    }else{
                    	$('#txtConvertAt_conf').text("");
                    }

                    //TOTAL
                    $('#totalAmount_conf').text(result.totalValidAmt.sysAmt);
                    $('#totalItem_conf').text(result.totalItem);
                    $('#totalValid_conf').text(result.totalValidAmt.c1);
                    $('#totalInvalid_conf').text((result.totalItem) - (result.totalValidAmt.c1));

                    AUIGrid.destroy(batchConfGridID);
                    batchConfGridID = GridCommon.createAUIGrid("conf_grid_wrap", batchListLayout,null,gridPros2);
                    AUIGrid.setGridData(batchConfGridID, result.batchPaymentDetList);
                    AUIGrid.resize(batchConfGridID,942, 280);
                });

            }else{
            	Common.alert("<spring:message code='pay.alert.isNotBatch' arguments='"+batchId+"' htmlEscape='false'/>");
            }

        }else{
            Common.alert("<spring:message code='pay.alert.noBatchSelected'/>");
        }
    }

    function fn_removeItem(detId){
    	Common.ajax("GET","/payment/updRemoveItem.do",{"detId":detId}, function(result){
    		fn_confirmBatchPopup();
    		Common.alert(result.message);
    	});
    }

    function fn_confirmBatch(){

    	Common.confirm("<spring:message code='pay.alert.confPayBatch'/>",function (){
    		var totalInvalid = $('#totalInvalid_conf').text();
    		var totalValid = $('#totalValid_conf').text();
    		var batchId = AUIGrid.getCellValue(myGridID, selectedGridValue, "batchId");

    		if(totalInvalid > 0){
    			Common.alert("<spring:message code='pay.alert.invalidItemExist'/>");
    			return;
    		}else{
    			if(totalValid > 0){

    				Common.ajax("GET","/payment/saveConfirmBatch.do", {"batchId" : batchId}, function(result){
    	                console.log(result);
    	                fn_confirmBatchPopup();
    	                $('#btnConf').hide();
    	                $('#btnDeactivate').hide();
    	                Common.alert(result.message);
    	            });

    			}else{
    				Common.alert("<spring:message code='pay.alert.noValidItemFound'/>");
                    return;
    			}
    		}
        });
    }

    function fn_deactivateBatch(){
        Common.confirm("<spring:message code='pay.alert.deactivatePayBatch'/>",function (){
        	var batchId = AUIGrid.getCellValue(myGridID, selectedGridValue, "batchId");
            Common.ajax("GET","/payment/saveDeactivateBatch.do", {"batchId" : batchId}, function(result){
                console.log(result);
                $('#btnConf').hide();
                $('#btnDeactivate').hide();
                Common.alert(result.message);
            });
        });
    }

    function fn_uploadPopup(){
    	$('#upload_popup_wrap').show();
    	AUIGrid.resize(myUploadGridID);
    }

    function fn_uploadFile(){

        var formData = new FormData();
        var payModeId = $("#paymentMode option:selected").val();
        var confirmMsg;

        if(FormUtil.checkReqValue($("#paymentMode")) ){
            Common.alert("<spring:message code='pay.alert.selectPayMode'/>");
            return;
        }
        if(fn_validation()){  // Ticket - 23026832 Wawa 15/08/2023 open validation for all type of payment
        	if($("#eMandate").is(":checked") && !$("#advance").is(":checked")){
                Common.alert("Please check 'Advance' before checking 'eMandate'");
                return;
        	}

            if($("#advance").is(":checked")) {
        		formData.append("advance","1");

        		if($("#eMandate").is(":checked")){
            		formData.append("eMandate","1");
        		}
        		else{
            		formData.append("eMandate","0");
        		}

        		confirmMsg = "<spring:message code='pay.alert.uploadAdvBatachPayment'/>";
	        }
	        else {

	        	formData.append("advance","0");
	        	formData.append("eMandate","0");
	        	confirmMsg = "<spring:message code='pay.alert.uploadBatachPayment'/>";
        	}
        }

        formData.append("csvFile", $("input[name=uploadfile]")[0].files[0]);
        formData.append("payModeId", payModeId);

        if($("#jomPay").is(":checked")) formData.append("jomPay","1");
        else  formData.append("jomPay","");

        Common.confirm(confirmMsg,function (){
        	  Common.ajaxFile("/payment/csvFileUpload.do", formData, function(result){
                  $('#paymentMode option[value=""]').attr('selected', 'selected');

                  //Common.alert(result.message);
                  Common.alert(result.message, function (){
                      hideViewPopup('#upload_wrap');
                  });
              });
           /*  Common.ajax("POST", "/payment/csvAdvanceFileUpload.do", data,
                    function(result) {
                        var returnMsg = "<spring:message code='pay.alert.AdvBatchPaySuccess'/>";
                        returnMsg +=  "<br><b> Batch ID : " + result.fBankJrnlId + "</b>";

                        Common.alert(returnMsg, function (){
                            hideViewPopup('#upload_wrap');
                        });

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
                    }); */
        });
    }

    function fn_validation(){

    	var data = GridCommon.getGridData(myUploadGridID);
        //data.form = $("#uploadForm").serializeJSON();

        var length = data.all.length;

        if (length < 1) {
            Common.alert("<spring:message code='pay.alert.claimSelectCsvFile'/>");
            return false;
        }

        if (length > 0) {
            for (var i = 0; i < length - 1; i++) {
                console.log("AUIGrid.getCellValue(myUploadGridID, i, 0 "+fn_checkMandatory((AUIGrid.getCellValue(myUploadGridID, i, "0"))));
                 if (fn_checkMandatory((AUIGrid.getCellValue(myUploadGridID, i, "0")))) {
                    var text = '<spring:message code="pay.head.orderNo"/>';
                    Common.alert(text+ " is mandatory.");
                    return false;
                }
                 if($("#advance").is(":checked")) {
	                 if (fn_checkMandatory((AUIGrid.getCellValue(myUploadGridID, i, "2")))) {
	                     var text = '<spring:message code="pay.head.refNo"/>';
	                     Common.alert(text+ " is mandatory.");
	                     return false;
	                 }
                 }
                 if (fn_checkMandatory((AUIGrid.getCellValue(myUploadGridID, i, "3")))) {
                     var text = '<spring:message code="pay.head.Amount"/>';
                     Common.alert(text+ " is mandatory.");
                     return false;
                 }
                 if (fn_checkMandatory((AUIGrid.getCellValue(myUploadGridID, i, "4")))) {
                     var text = '<spring:message code="pay.head.bankAcc"/>';
                     Common.alert(text+ " is mandatory.");
                     return false;
                 }
                 if (fn_checkMandatory((AUIGrid.getCellValue(myUploadGridID, i, "9")))) {
                     var text = '<spring:message code="pay.head.refDateMonth"/>';
                     Common.alert(text+ " is mandatory.");
                     return false;
                 }
                 if (fn_checkMandatory((AUIGrid.getCellValue(myUploadGridID, i, "10")))) {
                     var text = '<spring:message code="pay.head.refDateDay"/>';
                     Common.alert(text+ " is mandatory.");
                     return false;
                 }
                 if (fn_checkMandatory((AUIGrid.getCellValue(myUploadGridID, i, "11")))) {
                     var text = '<spring:message code="pay.head.refDateYear"/>';
                     Common.alert(text+ " is mandatory.");
                     return false;
                 }
                 if (fn_checkMandatory((AUIGrid.getCellValue(myUploadGridID, i, "16")))) {
                     var text = '<spring:message code="pay.head.payType"/>';
                     Common.alert(text+ " is mandatory.");
                     return false;
                 }
//                  if (fn_checkMandatory((AUIGrid.getCellValue(myUploadGridID, i, "18")))) {
//                      var text = '<spring:message code="pay.head.remark"/>';
//                      Common.alert(text+ " is mandatory.");
//                      return false;
//                  }
                 if($("#advance").is(":checked")) {
                     if (fn_checkMandatory((AUIGrid.getCellValue(myUploadGridID, i, "22")))) {
                         var text = '<spring:message code="sal.title.text.paymentChnnl"/>';
                         Common.alert(text+ " is mandatory.");
                         return false;
                     }
                 }
            }
        }
        return true;
    }

    function fn_checkMandatory(objValue){

        if (objValue == null || objValue == "" || objValue == "undefined") {
            return true;
        }
    }

    function onlyNumber(obj) {
        $(obj).keyup(function(){
             $(this).val($(this).val().replace(/[^0-9]/g,""));
        });
    }

    function fn_hideViewPop(val){
    	$(val).hide();

    	if("#conf_popup_wrap" == val){

    		$('#txtBatchId_conf').text("");
            $('#txtBatchStatus_conf').text("");
            $('#txtConfirmStatus_conf').text("");
            $('#txtPayMode_conf').text("");
            $('#txtUploadBy_conf').text("");
            $('#txtUploadAt_conf').text("");
            $('#txtConfirmBy_conf').text("");
            $('#txtConfirmAt_conf').text("");
            $('#txtConvertBy_conf').text("");
            $('#txtConvertAt_conf').text("");
            $('#totalAmount_conf').text("");
            $('#totalItem_conf').text("");
            $('#totalValid_conf').text("");
            $('#totalInvalid_conf').text("");
            $('#txtBatchIsAdv_conf').text("");

            $("#paymentInfo_conf").trigger("click");

    	}else if("#view_popup_wrap" == val){

    		$('#txtBatchId').text("");
            $('#txtBatchStatus').text("");
            $('#txtConfirmStatus').text("");
            $('#txtPayMode').text("");
            $('#txtUploadBy').text("");
            $('#txtUploadAt').text("");
            $('#txtConfirmBy').text("");
            $('#txtConfirmAt').text("");
            $('#txtConvertBy').text("");
            $('#txtConvertAt').text("");
            $('#totalAmount').text("");
            $('#totalItem').text("");
            $('#totalValid').text("");
            $('#totalInvalid').text("");
            $('#txtBatchIsAdv').text("");

            $("#panymentInfo").trigger("click");
    	}

    	searchList();
    }
    function fn_clear(){
    	$("#searchForm")[0].reset();
    	$("#payMode").multipleSelect("checkAll");
        $("#confirmStatus").multipleSelect("setSelects", [44]);
        $("#batchStatus").multipleSelect("setSelects", [1]);
    }

  //HTML5 브라우저인지 체크 즉, FileReader 를 사용할 수 있는지 여부
    function checkHTML5Brower() {
        var isCompatible = false;
        if (window.File && window.FileReader && window.FileList && window.Blob) {
            isCompatible = true;
        }

        return isCompatible;
    };

    //HTML5 브라우저 즉, FileReader 를 사용 못할 경우 Ajax 로 서버에 보냄
    //서버에서 파일 내용 읽어 반환 한 것을 통해 그리드에 삽입
    //즉, 이것은 IE 10 이상에서는 불필요 (IE8, 9 에서만 해당됨)
    function commitFormSubmit() {

        AUIGrid.showAjaxLoader(myUploadGridID);

        // Submit 을 AJax 로 보내고 받음.
        // ajaxSubmit 을 사용하려면 jQuery Plug-in 인 jquery.form.js 필요함
        // 링크 : http://malsup.com/jquery/form/

        $('#uploadForm').ajaxSubmit({
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
                    AUIGrid.setCsvGridData(myUploadGridID, csvText);
                    AUIGrid.removeAjaxLoader(myUploadGridID);

                    //csv 파일이 header가 있는 파일이면 첫번째 행(header)은 삭제한다.
                    AUIGrid.removeRow(myUploadGridID,0);
                }
            },
            error : function(e) {
                Common.alert("ajaxSubmit Error : " + e);
            }
        });

    }

    function uploadClear(){
        //화면내 모든 form 객체 초기화
        $("#uploadForm")[0].reset();

        //그리드 초기화
        AUIGrid.clearGridData(myUploadGridID);
    }

    hideViewPopup=function(val){
        $(val).hide();

        //업로드창이 닫히면 upload 화면도 reset한다.
        if(val == '#upload_wrap'){
            fn_uploadClear();
        }
    }

    function fn_uploadClear(){
        //화면내 모든 form 객체 초기화
        $("#uploadForm")[0].reset();

        //그리드 초기화
        AUIGrid.clearGridData(myUploadGridID);
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
		<h2>Batch Payment</h2>
		<ul class="right_btns">
		   <c:if test="${PAGE_AUTH.funcView == 'Y'}">
		    <li><p class="btn_blue"><a href="#" onclick="searchList();"><span class="search"></span><spring:message code='sys.btn.search'/></a></p></li>
		   </c:if>
		    <li><p class="btn_blue"><a href="#" onclick="fn_clear();"><span class="clear"></span><spring:message code='sys.btn.clear'/></a></p></li>
		</ul>
	</aside><!-- title_line end -->
    <!-- search_table start -->
    <section class="search_table"><!-- search_table start -->
		<form id="searchForm" action="#" method="post">
			<input type="hidden" id="validStatusId" name="validStatusId">
			<input type="hidden" id="payType" name="payType" value="97">
			<input type="hidden" id="payCustType" name="payCustType" value="1368">
			<table class="type1"><!-- table start -->
				<caption>table</caption>
				<colgroup>
				    <col style="width:170px" />
				    <col style="width:*" />
				    <col style="width:170px" />
				    <col style="width:*" />
				    <col style="width:170px" />
				    <col style="width:*" />
				</colgroup>
				<tbody>
					<tr>
					    <th scope="row">Batch ID</th>
					    <td><input type="text" id="batchId" name="batchId" title="" placeholder="Batch ID (Number Only)" class="w100p" onkeydown="onlyNumber(this)" /></td>
					    <th scope="row">Paymode</th>
					    <td>
						    <select id="payMode" name="payMode" class="multy_select w100p" multiple="multiple">
						        <option value="105">Cash (CSH)</option>
						        <option value="106">Cheque (CHQ)</option>
						        <option value="108">Online Payment(ONL)</option>
						        <option value="107">Credit Card (CRC)</option>
						    </select>
					    </td>
					    <th scope="row">Create Date</th>
					    <td>
						    <div class="date_set w100p"><!-- date_set start -->
							    <p><input type="text" id="createDateFr" name="createDateFr" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
							    <span>To</span>
							    <p><input type="text" id="createDateTo" name="createDateTo" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
						    </div><!-- date_set end -->
					    </td>
					</tr>
					<tr>
					    <th scope="row">Confirm Status</th>
					    <td>
						    <select id="confirmStatus" name="confirmStatus" class="multy_select w100p" multiple="multiple">
						        <option value="44">Pending</option>
						        <option value="77">Confirm</option>
                                <option value="8">Inactive</option>
						    </select>
					    </td>
					    <th scope="row">Batch Status</th>
					    <td>
						    <select id="batchStatus" name="batchStatus" class="multy_select w100p" multiple="multiple">
						        <option value="1">Active</option>
						        <option value="4">Completed</option>
						        <option value="8">Inactive</option>
						    </select>
					    </td>
					    <th scope="row">Creator</th>
					    <td><input type="text" id="creator" name="creator" title="" placeholder="Create User Name" class="w100p" /></td>
					</tr>
                  <tr>
                  <th scope="row">Advance</th>
                    <td colspan="5"><input type='checkbox' id='advanceSearch' name='advanceSearch' value='1'></td>
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
				        <li><p class="link_btn"><a href="javascript:fn_uploadPopup();"><spring:message code='pay.btn.link.uploadBatchPayment'/></a></p></li>
				        <li><p class="link_btn"><a href="javascript:fn_viewBatchPopup();"><spring:message code='pay.btn.link.viewBatchPayment'/></a></p></li>
				        <li><p class="link_btn"><a href="javascript:fn_confirmBatchPopup();"><spring:message code='pay.btn.link.confirmBatchPayment'/></a></p></li>
				    </ul>
				    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
				    </dd>
				</dl>
			</c:if>
			</aside><!-- link_btns_wrap end -->
		</form>
	</section><!-- search_table end -->
    <!-- search_result start -->
    <section class="search_result">
        <!-- grid_wrap start -->
        <article id="grid_wrap" class="grid_wrap"></article>
        <!-- grid_wrap end -->
    </section>
    <!-- search_result end -->
</section>
<!-- content end -->
<div id="view_popup_wrap" class="popup_wrap size_big" style="display:none;"><!-- popup_wrap start -->
	<header class="pop_header"><!-- pop_header start -->
		<h1>Batch Payment View</h1>
		<ul class="right_opt">
		    <li><p class="btn_blue2"><a href="#" onclick="fn_hideViewPop('#view_popup_wrap');"><spring:message code='sys.btn.close'/></a></p></li>
		</ul>
	</header><!-- pop_header end -->
	<section class="pop_body"><!-- pop_body start -->
		<section class="tap_wrap"><!-- tap_wrap start -->
			<ul class="tap_type1">
			    <li><a href="#" class="on" id="panymentInfo">Batch Payment Info</a></li>
			    <li><a href="#">Batch Payment Item</a></li>
			</ul>
			<article class="tap_area"><!-- tap_area start -->
				<table class="type1"><!-- table start -->
					<caption>table</caption>
					<colgroup>
					    <col style="width:130px" />
					    <col style="width:*" />
					    <col style="width:130px" />
					    <col style="width:*" />
					    <col style="width:130px" />
					    <col style="width:*" />
					</colgroup>
					<tbody>
						<tr>
						    <th scope="row">Batch ID</th>
						    <td>
						        <span id="txtBatchId"></span>
						    </td>
						    <th scope="row">Batch Status</th>
						    <td id="txtBatchStatus">
						    </td>
						    <th scope="row">Confirm Status</th>
						    <td>
						        <span id="txtConfirmStatus"></span>
						    </td>
						</tr>
						<tr>
						    <th scope="row">Paymode</th>
						    <td>
						        <span id="txtPayMode"></span>
						    </td>
						    <th scope="row">Upload By</th>
						    <td>
						        <span id="txtUploadBy"></span>
						    </td>
						    <th scope="row">Upload At</th>
						    <td>
						        <span id="txtUploadAt"></span>
						    </td>
						</tr>
						<tr>
                            <th scope="row">Advance Batch</th>
                            <td>
                                <span id="txtBatchIsAdv"></span>
                            </td>
						    <th scope="row">Confirm By</th>
						    <td>
						        <span id="txtConfirmBy"></span>
						    </td>
						    <th scope="row">Confirm At</th>
						    <td >
						        <span id="txtConfirmAt"></span>
						    </td>
						</tr>
						<tr>
						    <th scope="row">Convert By</th>
						    <td>
						        <span id="txtConvertBy"></span>
						    </td>
						    <th scope="row">Convert At</th>
						    <td>
						        <span id="txtConvertAt"></span>
						    </td>
						    <th scope="row">Total Amount (Valid)</th>
						    <td>
						        <span id="totalAmount"></span>
						    </td>
						</tr>
						<tr>
						    <th scope="row">Total Item</th>
						    <td>
						        <span id="totalItem"></span>
						    </td>
						    <th scope="row">Total Valid</th>
						    <td>
						        <span id="totalValid"></span>
						    </td>
						    <th scope="row">Total Invalid</th>
						    <td>
						        <span id="totalInvalid"></span>
						    </td>
						</tr>
					</tbody>
				</table><!-- table end -->
			</article><!-- tap_area end -->
			<!-- tap_area start -->
			<article class="tap_area">
				<!-- title_line start -->
				<aside class="title_line">
					<h2 id="itemGubun">All Items</h2>
					<ul class="right_btns">
					    <li><p class="btn_grid"><a href="javascript:fn_batchPayItemList('' , 'V');"><spring:message code='pay.btn.allItems'/></a></p></li>
					    <li><p class="btn_grid"><a href="javascript:fn_batchPayItemList('4' , 'V');"><spring:message code='pay.btn.validItems'/></a></p></li>
					    <li><p class="btn_grid"><a href="javascript:fn_batchPayItemList('21' , 'V');"><spring:message code='pay.btn.invalidItems'/></a></p></li>
					</ul>
				</aside>
				<!-- title_line end -->
				<!-- grid_wrap start -->
				<article id="view_grid_wrap" class="grid_wrap"></article>
				<!-- grid_wrap end -->
			</article>
			<!-- tap_area end -->
		</section>
		<!-- tap_wrap end -->
	</section>
	<!-- pop_body end -->
</div>
<!-- popup_wrap end -->
<!-- popup_wrap start -->
<div id="conf_popup_wrap" class="popup_wrap size_big" style="display:none;">
	<header class="pop_header"><!-- pop_header start -->
		<h1>Batch Payment Confirmation</h1>
		<ul class="right_opt">
		    <li><p class="btn_blue2"><a href="#" onclick="fn_hideViewPop('#conf_popup_wrap');"><spring:message code='sys.btn.close'/></a></p></li>
		</ul>
	</header>
	<!-- pop_header end -->
	<section class="pop_body"><!-- pop_body start -->
	    <section class="tap_wrap"><!-- tap_wrap start -->
	    <ul class="tap_type1">
	        <li><a href="#" class="on" id="paymentInfo_conf">Batch Payment Info</a></li>
	        <li><a href="#">Batch Payment Item</a></li>
	    </ul>
	    <article class="tap_area"><!-- tap_area start -->
		    <table class="type1"><!-- table start -->
			    <caption>table</caption>
			    <colgroup>
			        <col style="width:130px" />
			        <col style="width:*" />
			        <col style="width:130px" />
			        <col style="width:*" />
			        <col style="width:130px" />
			        <col style="width:*" />
			    </colgroup>
			    <tbody>
				    <tr>
				        <th scope="row">Batch ID</th>
				        <td>
				            <span id="txtBatchId_conf"></span>
				        </td>
				        <th scope="row">Batch Status</th>
				        <td id="txtBatchStatus_conf">
				        </td>
				        <th scope="row">Confirm Status</th>
				        <td>
				            <span id="txtConfirmStatus_conf"></span>
				        </td>
				    </tr>
				    <tr>
				        <th scope="row">Paymode</th>
				        <td>
				            <span id="txtPayMode_conf"></span>
				        </td>
				        <th scope="row">Upload By</th>
				        <td>
				            <span id="txtUploadBy_conf"></span>
				        </td>
				        <th scope="row">Upload At</th>
				        <td>
				            <span id="txtUploadAt_conf"></span>
				        </td>
				    </tr>
				    <tr>
				        <th scope="row">Advance Batch</th>
                           <td>
                               <span id="txtBatchIsAdv_conf"></span>
                           </td>
                        <th scope="row">Confirm By</th>
				        <td>
				            <span id="txtConfirmBy_conf"></span>
				        </td>
				        <th scope="row">Confirm At</th>
				        <td >
				            <span id="txtConfirmAt_conf"></span>
				        </td>
				    </tr>
				    <tr>
				        <th scope="row">Convert By</th>
				        <td>
				            <span id="txtConvertBy_conf"></span>
				        </td>
				        <th scope="row">Convert At</th>
				        <td>
				            <span id="txtConvertAt_conf"></span>
				        </td>
				        <th scope="row">Total Amount (Valid)</th>
				        <td>
				            <span id="totalAmount_conf"></span>
				        </td>
				    </tr>
				    <tr>
				        <th scope="row">Total Item</th>
				        <td>
				            <span id="totalItem_conf"></span>
				        </td>
				        <th scope="row">Total Valid</th>
				        <td>
				            <span id="totalValid_conf"></span>
				        </td>
				        <th scope="row">Total Invalid</th>
				        <td>
				            <span id="totalInvalid_conf"></span>
				        </td>
				    </tr>
			    </tbody>
		    </table><!-- table end -->
	    </article><!-- tap_area end -->
	    <!-- tap_area start -->
	    <article class="tap_area">
		    <!-- title_line start -->
		    <aside class="title_line">
		    <h2 id="itemGubun_conf">All Items</h2>
		    <ul class="right_btns">
		        <li><p class="btn_grid"><a href="javascript:fn_batchPayItemList('','C');"><spring:message code='pay.btn.allItems'/></a></p></li>
		        <li><p class="btn_grid"><a href="javascript:fn_batchPayItemList('4' , 'C');"><spring:message code='pay.btn.validItems'/></a></p></li>
		        <li><p class="btn_grid"><a href="javascript:fn_batchPayItemList('21' , 'C');"><spring:message code='pay.btn.invalidItems'/></a></p></li>
		    </ul>
		    </aside>
		    <!-- title_line end -->
		    <!-- grid_wrap start -->
		    <article id="conf_grid_wrap" class="grid_wrap">
		    </article>
		    <!-- grid_wrap end -->
	    </article><!-- tap_area end -->
		    <ul class="center_btns">
			    <li><p class="btn_blue2 big"><a href="javascript:fn_confirmBatch();" id="btnConf"><spring:message code='pay.btn.confirm'/></a></p></li>
			    <li><p class="btn_blue2 big"><a href="javascript:fn_deactivateBatch();" id="btnDeactivate"><spring:message code='pay.btn.deactivate'/></a></p></li>
		    </ul>
	    </section><!-- tap_wrap end -->
	</section><!-- pop_body end -->
</div><!-- popup_wrap end -->
<div id="upload_popup_wrap" class="popup_wrap" style="display:none;"><!-- popup_wrap start -->
	<header class="pop_header"><!-- pop_header start -->
		<h1>Batch Payment Upload</h1>
		<ul class="right_opt">
		    <li><p class="btn_blue2"><a href="#" onclick="fn_hideViewPop('#upload_popup_wrap')"><spring:message code='sys.btn.close'/></a></p></li>
		</ul>
	</header><!-- pop_header end -->
	<section class="pop_body"><!-- pop_body start -->
		<form action="#" method="post" id="uploadForm">
			<table class="type1"><!-- table start -->
				<caption>table</caption>
				<colgroup>
				    <col style="width:150px" />
				    <col style="width:*" />
				    <col style="width:150px" />
                    <col style="width:*" />
				</colgroup>
				<tbody>
					<tr>
					    <th scope="row">Payment Mode</th>
					    <td >
					    <select class="" id="paymentMode" name="paymentMode">
					        <option value=""></option>
					        <option value="105">Cash (CSH)</option>
					        <option value="106">Cheque (CHQ)</option>
					        <option value="108">Online Payment (ONL)</option>
					        <option value="107">Credit Card (CRC)</option>
					    </select>
					    </td>

					       <th scope="row">JomPay</th>
	                       <td >
	                            <input type='checkbox' id ='jomPay' name='jomPay' value='1'>
	                       </td>

                    </tr>
					<tr>
					    <th scope="row">File</th>
					    <td >
					    <div class="auto_file"><!-- auto_file start -->
					        <input type="file" title="file add" id="uploadfile" name="uploadfile" />
					    </div><!-- auto_file end -->
					    </td>
            <th scope="row">Advance</th>
            <td><input type='checkbox' id='advance' name='advance' value='1'></td>
          </tr>
          <tr id="eMandateDisplay" style="display:none;">
          	<th></th>
          	<td></td>
          	<th scope="row">eMandate</th>
          	<td><input type='checkbox' id='eMandate' name='eMandate' value='1'></td>
          </tr>
				</tbody>
			</table><!-- table end -->
		</form>
		<ul class="center_btns mt20">
            <li><p class="btn_blue2"><a href="javascript:uploadClear();"><spring:message code='sys.btn.clear'/></a></p></li>
		    <li><p class="btn_blue2 big"><a href="javascript:fn_uploadFile();"><spring:message code='pay.btn.uploadFile'/></a></p></li>
            <li><p class="btn_blue2 big"><a href="${pageContext.request.contextPath}/resources/download/payment/BatchPaymentFormat.csv"><spring:message code='pay.btn.downloadCsvFormat'/></a></p></li>
		</ul>

     <!-- search_result start -->
        <section class="search_result">
            <!-- grid_wrap start -->
            <article id="grid_upload_wrap" class="grid_wrap"></article>
            <!-- grid_wrap end -->
        </section>
        <!-- search_result end -->

	</section>
	<!-- pop_body end -->
</div>
<!-- popup_wrap end -->