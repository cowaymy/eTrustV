<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>

<script type="text/javaScript">

//AUIGrid 그리드 객체
var myGridID,updResultGridID,batchDeductionItemId;

//Grid에서 선택된 RowID
var selectedGridValue;

//Default Combo Data
var claimTypeData = [{"codeId": "131","codeName": "Credit Card"}];

//Status Combo Data
var statusData = [{"codeId": "1","codeName": "Active"},{"codeId": "4","codeName": "Completed"},{"codeId": "8","codeName": "Inactive"},{"codeId": "21","codeName": "Failed"}];

var bankData = [ /* {"codeId": "21","codeName": "Maybank"},
                             */
                             {"codeId": "3","codeName": "CIMB Bank"},
                             {"codeId": "19","codeName": "Standard Chartered Bank"},
                             {"codeId": "17","codeName": "HSBC Bank"},
                             {"codeId": "23","codeName": "AmBank"}
                           ];

var subPath = "/resources/WebShare/CRT";

// 화면 초기화 함수 (jQuery 의 $(document).ready(function() {}); 과 같은 역할을 합니다.
$(document).ready(function(){
	//메인 페이지
    doDefCombo(statusData, '' ,'status', 'S', '');                 //Status 생성
    doDefCombo(bankData, '' ,'issueBank', 'S', '');               //Issue Bank 생성

    //New Result 팝업 페이지
    doDefCombo(claimTypeData, '131','claimType', 'S', '');        //Claim Type 생성
    doDefCombo(bankData, '' ,'new_merchantBank', 'S', '');               //Issue Bank 생성
    CommonCombo.make('new_issueBank', '/sales/order/getBankCodeList', '' , '', {type: 'M', isCheckAll: false});

    //Grid Properties 설정
    var gridPros = {
            editable : false,                 // 편집 가능 여부 (기본값 : false)
            showStateColumn : false,     // 상태 칼럼 사용
            softRemoveRowMode:false
    };

    // Order 정보 (Master Grid) 그리드 생성
    myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,null,gridPros);
    updResultGridID = GridCommon.createAUIGrid("updResult_grid_wrap", updResultColLayout,null,gridPros);
    batchDeductionItemId = GridCommon.createAUIGrid("#batchDeductionItem_grid_wrap", batchDeductionColumnLayout,null,gridPros);
    AUIGrid.resize(batchDeductionItemId,945, $(".grid_wrap").innerHeight());

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
    { dataField:"fileBatchId" ,headerText:"Batch Id",width: 70 ,editable : false },
    { dataField:"fileBatchName" ,headerText:"File Batch Name",width: 180 ,editable : false },
    { dataField:"stusCode" ,headerText:"Status",width: 60 ,editable : false },
    { dataField:"bankName" ,headerText:"Issue Bank",width: 120 ,editable : false },
    { dataField:"fileBatchAppvDt" ,headerText:"Approved Date",width: 200 ,editable : false},
    { dataField:"fileBatchTotRcord" ,headerText:"Total Item(s)",width: 80 ,editable : false },
    { dataField:"fileBatchTotAmt" ,headerText:"Total Amount",width: 120 ,editable : false , dataType : "numeric", formatString : "#,##0.00"},
    { dataField:"fileBatchRejctRcord" ,headerText:"Total Rejected Item(s)",width: 70 ,editable : false },
    { dataField:"fileBatchAppvRcord" ,headerText:"Total Approved Item(s)",width: 70 ,editable : false },
    { dataField:"fileBatchCrtDt" ,headerText:"Create Date",width: 200 ,editable : false },
    { dataField:"fileBatchCrtUserName" ,headerText:"Creator",width: 120 , editable : false },
    { dataField:"fileBatchAppvAmt" ,headerText:"Total Approved Amount",width: 120 , visible : false, editable : false },
    { dataField:"fileBatchUpdUserName" ,headerText:"Updator",width: 120 , visible : false, editable : false },
    { dataField:"fileBatchUpdDt" ,headerText:"Updated Date",width: 120 , visible : false, editable : false },
    { dataField:"fileBatchBankId" ,headerText:"File Batch Bank Id",width: 120 , visible : false, editable : false },
    { dataField:"bankCode" ,headerText:"Bank Code" , visible : false, editable : false },
    ];

var updResultColLayout = [
                    {dataField : "6",headerText : "itmId", editable : true},
                    {dataField : "7",headerText : "respnsCode",editable : true},
                    {dataField : "8",headerText : "appvCode",editable : true}
                    ];

var batchDeductionColumnLayout= [
    {dataField : "fileItmStusName", headerText : "Status", width : '10%'},
    {dataField : "codeName", headerText : "Type", width : '10%'},
    {dataField : "salesOrdNo", headerText : "Order No", width : '10%'},
    {dataField : "fileItmOrNo", headerText : "OR No", width : '10%'},
    {dataField : "fileItmAmt", headerText : "Amount", width : '10%'},
    {dataField : "fileItmApprDt", headerText : "Approval Date", width : '10%'},
    {dataField : "crtUser", headerText : "Creator", width : '10%'},
    {dataField : "fileItmCrt", headerText : "Creatord", width : '10%'},
    {dataField : "updUser", headerText : "Updator", width : '10%'},
    {dataField : "fileItmUpd", headerText : "Updated", width : '10%'},
    ];

// 리스트 조회.
function fn_getECashListAjax() {
    Common.ajax("GET", "/payment/selectECashDeductList", $("#searchForm").serialize(), function(result) {
        AUIGrid.setGridData(myGridID, result);
    });
}

//View Claim Pop-UP
function fn_openDivPop(val){
	if(val == "VIEW" || val == "RESULT" || val == "FILE"){

		var selectedItem = AUIGrid.getSelectedIndex(myGridID);

	    if (selectedItem[0] > -1){

	    	var fileBatchId = AUIGrid.getCellValue(myGridID, selectedGridValue, "fileBatchId");
	        var fileBatchStusId = AUIGrid.getCellValue(myGridID, selectedGridValue, "fileBatchStusId");
	        var stusName = AUIGrid.getCellValue(myGridID, selectedGridValue, "stusName");
	        var smsSend = AUIGrid.getCellValue(myGridID, selectedGridValue, "ctrlFailSmsIsPump");

	        if((val == "RESULT") && fileBatchStusId != 1){
                Common.alert("<b>Batch [" + fileBatchId + "] is under status [" + stusName + "].<br />" +
                        "Only [Active] batch is allowed to update claim result.</b>");
			}else{
			    Common.ajax("GET", "/payment/selectECashSubDeductionById.do", {"batchId":fileBatchId}, function(result) {
                    AUIGrid.setGridData(batchDeductionItemId, result);
                });

            	Common.ajax("GET", "/payment/selectECashDeductionById.do", {"batchId":fileBatchId}, function(result) {
            		$("#view_wrap").show();
                    $("#new_wrap").hide();

                    $("#view_batchId").text(result.fileBatchId);
                    $("#view_status").text(result.stusName);
                    $("#view_deductDt").text(result.fileBatchAppvDt);
                    $("#view_totalItem").text(result.fileBatchTotRcord);
                    $("#view_issueBank").text(result.bankCode + ' - ' + result.bankName);
                    $("#view_totalApproved").text(result.fileBatchAppvRcord);
                    $("#view_totalRejected").text(result.fileBatchRejctRcord);
                    $("#view_totalAmount").text(result.fileBatchTotAmt.toFixed(2));
                    $("#view_AppvAmt").text(result.fileBatchAppvAmt.toFixed(2));
                    $("#view_creator").text(result.fileBatchCrtUserName);
                    $("#view_createDate").text(result.fileBatchCrtDt);
                    $("#view_updator").text(result.fileBatchUpdUserName);
                    $("#view_updateDate").text(result.fileBatchUpdDt);

            	});
			}

			//팝업 헤더 TEXT 및 버튼 설정
			if(val == "VIEW"){
			    $('#pop_header h1').text('VIEW E-DEDUCTION');
			    $('#pop_header h3').text('ALL TRANSACTION');
			    $('#center_btns1').hide();
			    $('#center_btns2').hide();
			    $('#center_btns3').hide();
			    $('#center_btns4').show();

			}else if(val == "RESULT"){
				$('#pop_header h1').text('E-DEDUCTION BATCH DETAILS');
				$('#pop_header h3').text('ALL TRANSACTION');
				$('#center_btns1').show();
                $('#center_btns2').hide();
                $('#center_btns3').hide();
                $('#center_btns4').hide();

			}else if (val == "FILE"){
                $('#pop_header h1').text('E-DEDUCTION FILE GENERATOR');
                $('#pop_header h3').text('ALL TRANSACTION');
                $('#center_btns1').hide();
                $('#center_btns2').hide();
                $('#center_btns3').show();
                $('#center_btns4').hide();

            }

        }else{
             Common.alert('No claim record selected.');
        }
	}else{
		$("#claimType").attr({"disabled" : "disabled"  , "class" : "w100p disabled"});
		$("#view_wrap").hide();
		$("#new_wrap").show();
		//NEW CLAIM 팝업에서 필수항목 표시 DEFAULT
		$("#newForm")[0].reset();

		$("input:radio[name='newDeductSales']:radio[value='0']").prop("checked", true);
	}
}

//Layer close
hideViewPopup=function(val){
    $(val).hide();
}

// Pop-UP 에서 Deactivate 처리
function fn_deactivate(){
	Common.confirm('<b>Are you sure want to deactivate this batch ?</b>',function (){
	    var fileBatchId = AUIGrid.getCellValue(myGridID, selectedGridValue, "fileBatchId");

	    Common.ajax("GET", "/payment/eCashDeactivate.do", {"fileBatchId":fileBatchId}, function(result) {
	    	Common.alert("<b>This batch has been deactivated.</b>","fn_openDivPop('VIEW')");

	    },function(result) {
	        Common.alert("<b>Failed to deactivate this batch.<br />Please try again later.</b>");
	    });
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
	var fileBatchId = AUIGrid.getCellValue(myGridID, selectedGridValue, "fileBatchId");
	var fileBatchBankId = AUIGrid.getCellValue(myGridID, selectedGridValue, "fileBatchBankId");
	var bankCode = AUIGrid.getCellValue(myGridID, selectedGridValue, "bankCode");

    //param data array
/*     var data = {};
    var gridList = AUIGrid.getGridData(updResultGridID);       //그리드 데이터

    //array에 담기
    if(gridList.length > 0) {
        data.all = gridList;
    }  else {
        alert('Select the CSV file on the local PC');
        return;
        //data.all = [];
    } */

    //form객체 담기
    //data.form = [{"fileBatchId":fileBatchId,"fileBatchBankId":fileBatchBankId}];

    var formData = new FormData();

    formData.append("csvFile", $("input[name=uploadfile]")[0].files[0]);
    formData.append("fileBatchId", fileBatchId);
    formData.append("fileBatchBankId", fileBatchBankId);
    formData.append("bankCode", bankCode);

    //Ajax 호출
    Common.ajaxFile("/payment/updateECashDeductionResultItemBulk.do", formData, function(result) {
    	resetUpdatedItems(); // 초기화

        var message = "";
        message += "Batch ID : " + result.data.fileBatchId + "<br />";
        message += "Total Result Item : " + result.data.totalItem + "<br />";
        message += "Total Approved : " + result.data.totalApproved + "<br />";
        message += "Total Rejected : " + result.data.totalRejected + "<br />";
        message += "<br />Are you sure want to confirm this result ?<br />";

        Common.confirm(message,
        function (){
            var fileBatchId = AUIGrid.getCellValue(myGridID, selectedGridValue, "fileBatchId");
            var settleDate = result.data.settleDate;
            var fileName = $('input[type=file]').val().replace(/C:\\fakepath\\/i, '');
            var data = {};
            data.form = [{"fileBatchId":fileBatchId,"fileBatchBankId":fileBatchBankId,"settleDate":settleDate,"fileName":fileName}];
console.log(data.form);
            Common.ajax("POST", "/payment/updateECashGrpDeductionResult.do", data,
            	function(result) {
                Common.alert("<b>Deduction results successfully updated.</b>");
                },
                function(result) {
                    Common.alert("<b>Failed to update result.<br />Please try again later.</b>");
                    });
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
	if($("#new_merchantBank option:selected").val() == ''){
        Common.alert("* Please select Issue Bank.<br />");
        return;
    }
    if($("#new_cardType option:selected").val() == ''){
        Common.alert("* Please select Card Type.<br />");
        return;
	}
    if ($("#new_issueBank option:selected").val() == null) {
        Common.alert(" * Please select issue bank ");
        return;
	}
    if($('input[name=newDeductSales]:checked', '#newForm').val() == null){
        Common.alert(" * Please select New Deduction Sales. <br/>");
        return
    }
    if ($("#newProdCat option:selected").val() == null) {
        Common.alert(" * Please select Product ");
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

    if($("#newProdCat").val() != null){
    	if($("#newProdCat").val() == 'HA'){
    		$("#v_isHA").val("1");
    	}
    	else if($("#newProdCat").val() == 'HC'){
    		$("#v_isHA").val("0");
    	}
    	else if($("#newProdCat :selected").length == 2){
    		$("#v_isHA").val("2");
    	}
    }

	//저장 처리
	var data = {};
    var formList = $("#newForm").serializeArray();       //폼 데이터

    if(formList.length > 0) data.form = formList;
    else data.form = [];

	Common.ajax("POST", "/payment/generateNewECashGrpDeduction.do", data,
			function(result) {
		         var message = "";

		         if(result.code == "IS_BATCH"){
		        	 message += "There is one active batch exist.<br />";
		        	 message += "Batch ID : " + result.data.fileBatchId + "<br />";
		        	 message += "Creator : " + result.data.fileBatchCrtUserName + "<br />";
		        	 message += "Create Date : " + result.data.fileBatchCrtDt  + "<br />";
		        	 message += "<br />You must deactive or complete the batch before create a new batch.<br />";

		         }else if(result.code == "FILE_OK"){
                     message += "New claim batch successfully generated.<br /><br />";
                     message += "Batch ID : " + result.data.fileBatchId + "<br />";
                     message += "Issuing Bank : " + result.data.name + "<br />";
                     message += "Total Claim Amount : " + result.data.fileBatchTotAmt + "<br />";
                     message += "Total Accounts : " + result.data.fileBatchTotRcord + "<br />";
                     message += "Creator : " + result.data.crtUserId + "<br />";
                     message += "Create Date : " + result.data.crtDt + "<br />";
		         }else{
		        	 message += "Failed to generate new eCash Auto Debit Deduction Batch. Please try again later.";
		         }

		         Common.alert("<b>" + message + "</b>");
	       },
	       function(result) {
                 Common.alert("<b>Failed to generate new eCash Auto Debit Deduction Batch. Please try again later.</b>");
           }
	);
}

//NEW CLAIM Pop-UP 에서 Generate Claim 처리
function fn_createFile(){

	var fileBatchId = AUIGrid.getCellValue(myGridID, selectedGridValue, "fileBatchId");

	//param data array
    var data = {};
    data.form = [{"batchId":fileBatchId,"v_isGrp":1}];

    Common.ajax("POST", "/payment/createECashDeductionFile.do", data,
            function(result) {
                 Common.alert("<b>Claim file has successfully created.</b>",function(){
                     window.open("${pageContext.request.contextPath}" + subPath + result.data);
                 });

           },
           function(result) {
                 Common.alert("<b>Failed to generate claim file. Please try again later.</b>");
           }
    );
}

function fn_clear(){
    $("#searchForm")[0].reset();
}

function fn_getItmStatus(val){
	var fileBatchId = AUIGrid.getCellValue(myGridID, selectedGridValue, "fileBatchId");

	if(val == "4"){$('#pop_header h3').text('APPROVED TRANSACTION');}
	else if(val == "6"){$('#pop_header h3').text('FAILED TRANSACTIONS');}
	else{$('#pop_header h3').text('ALL TRANSACTIONS');}

	Common.ajax("GET", "/payment/selectECashSubDeductionById.do", {"batchId":fileBatchId,"status":val}, function(result) {
        AUIGrid.setGridData(batchDeductionItemId, result);
    });
}

function fn_openFailedeCash() {
    Common.popupDiv("/payment/failedDeductionListPop.do", null, null, true);
}

function fn_report(){

    var batchId = AUIGrid.getCellValue(myGridID, selectedGridValue, "fileBatchId");
    var date = new Date().getDate();
    if(date.toString().length == 1){
        date = "0" + date;
    }

    $("#excelForm #reportDownFileName").val("ECashGroupingDeduction_" + batchId + "_"+date+(new Date().getMonth()+1)+new Date().getFullYear());
    $("#excelForm #v_FILE_BATCH_ID").val(batchId);

    var option = {
            isProcedure : true
    };

    Common.report("excelForm", option);

}

</script>

<!-- content start -->
<section id="content">
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
        <li>Payment</li>
        <li>Payment</li>
        <li>eCash</li>
    </ul>

    <!-- title_line start -->
    <aside class="title_line">
        <p class="fav"><a href="#" class="click_add_on">My menu</a></p>
        <h2>eCash Grouping Deduction</h2>
        <ul class="right_btns">
            <c:if test="${PAGE_AUTH.funcView == 'Y'}">
            <li><p class="btn_blue"><a href="javascript:fn_getECashListAjax();"><span class="search"></span>Search</a></p></li>
            <li><p class="btn_blue"><a href="javascript:fn_clear();"><span class="clear"></span>Clear</a></p></li>
            </c:if>
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
                            <input id="batchId" name="batchId" type="text" title="batchId" placeholder="Batch ID" class="w100p" />
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
                       <th scope="row">Status</th>
                        <td>
                           <select id="status" name="status" class="w100p"></select>
                        </td>
                          <th scope="row">Merchant Bank</th>
                        <td>
                           <select id="issueBank" name="issueBank" class="w100p"></select>
                        </td>
                        <th scope="row">Deduction Date</th>
                        <td>
                           <!-- date_set start -->
                            <div class="date_set w100p">
                                <p><input id="deductDt1" name="deductDt1" type="text" title="Deduct Date From" placeholder="DD/MM/YYYY" class="j_date" readonly /></p>
                                <span>~</span>
                                <p><input id="deductDt2" name="deductDt2" type="text" title="Deduct Date To" placeholder="DD/MM/YYYY" class="j_date" readonly /></p>
                            </div>
                            <!-- date_set end -->
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Batch Name</th>
                        <td>
                            <input id="batchName" name="batchName" type="text" title="BatchName" placeholder="Batch Name" class="w100p" />
                        </td>
                        <td colspan="4"></td>
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
                        <c:if test="${PAGE_AUTH.funcView == 'Y'}">
                        <li><p class="link_btn"><a href="javascript:fn_openDivPop('VIEW');">View eDeduction</a></p></li>
                        </c:if>

                        <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
                        <li><p class="link_btn"><a href="javascript:fn_openDivPop('NEW');">New eDeduction</a></p></li>
                        </c:if>

                        <c:if test="${PAGE_AUTH.funcUserDefine3 == 'Y'}">
                        <li><p class="link_btn"><a href="javascript:fn_openDivPop('RESULT');">eDeduction Result</a></p></li>
                        </c:if>

                        <c:if test="${PAGE_AUTH.funcUserDefine4 == 'Y'}">
                        <li><p class="link_btn"><a href="javascript:fn_openDivPop('FILE');">Re-Generate Claim File</a></p></li>
                        </c:if>

                        <c:if test="${PAGE_AUTH.funcUserDefine5 == 'Y'}">
                        <li><p class="link_btn"><a href="javascript:fn_openFailedeCash('VIEW');">Failed eCash Listing</a></p></li>
                        </c:if>
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
<div class="popup_wrap" id="view_wrap" style="display: none;">
	<!-- pop_header start -->
	<header class="pop_header" id="pop_header">
		<h1></h1>
		<ul class="right_opt">
			<li><p class="btn_blue2">
					<a href="#" onclick="hideViewPopup('#view_wrap')">CLOSE</a>
				</p></li>
		</ul>
	</header>
	<!-- pop_header end -->
	<form action="#" method="post" id="excelForm" name="excelForm">
        <input type="hidden" id="reportFileName" name="reportFileName" value="/payment/EcashGroupDeductDetails.rpt" />
        <input type="hidden" id="viewType" name="viewType" value="EXCEL" />
        <input type="hidden" id="reportDownFileName" name="reportDownFileName" value="" />
        <input type="hidden" id="v_FILE_BATCH_ID" name="v_FILE_BATCH_ID" value='$("#view_batchId").text()' />
    </form>


	<!-- pop_body start -->
	<section class="pop_body">
		<!-- tap_wrap start -->
		<section class="tap_wrap mt0">
			<ul class="tap_type1">
				<li><a href="#" class="on">Batch Deduction Info</a></li>
				<li><a href="#">Batch Deduction Item</a></li>
			</ul>

    <!-- <section class="search_table"> search_table start -->
            <!-- #########Batch Deduction Info######### -->
            <article class="tap_area"><!-- tap_area start -->
				<!-- table start -->
				<table class="type1">
					<caption>table</caption>
					<colgroup>
						<col style="width: 165px" />
						<col style="width: *" />
						<col style="width: 165px" />
						<col style="width: *" />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">Batch ID</th>
							<td id="view_batchId"></td>
							<th scope="row">Status</th>
							<td id="view_status"></td>
						</tr>
						<tr>
							<th scope="row">Deduction Date</th>
							<td id="view_deductDt"></td>
							<th scope="row">Total Records</th>
							<td id="view_totalItem"></td>
						</tr>
						<tr>
							<th scope="row">Issue Bank</th>
							<td colspan="3" id="view_issueBank"></td>

						</tr>
						<tr>
							<th scope="row">Total Amount</th>
							<td id="view_totalAmount"></td>
							<th scope="row">Total Approved Amount</th>
							<td id="view_AppvAmt"></td>
						</tr>
						<tr>
							<th scope="row">Total Approved</th>
							<td id="view_totalApproved"></td>
							<th scope="row">Total Rejected</th>
							<td id="view_totalRejected"></td>
						</tr>
						<tr>
							<th scope="row">Created Date</th>
							<td id="view_createDate"></td>
							<th scope="row">Creator</th>
							<td id="view_creator"></td>
						</tr>
						<tr>
							<th scope="row">Updated Date</th>
							<td id="view_updateDate"></td>
							<th scope="row">Updator</th>
							<td id="view_updator"></td>
						</tr>
					</tbody>
				</table>

				<ul class="center_btns" id="center_btns1">
				    <li><p class="btn_blue2"><a href="javascript:fn_deactivate();">Deactivate</a></p></li>
					<li><p class="btn_blue2"><a href="javascript:fn_updateResult('LIVE');">Update Result</a></p></li>
				</ul>
				<ul class="center_btns" id="center_btns3">
					<li><p class="btn_blue2"><a href="javascript:fn_createFile();">Generate File</a></p></li>
				</ul>
                <ul class="center_btns" id="center_btns4">
                    <li><p class="btn_blue2"><a href="javascript:fn_report();">Generate To Excel</a></p></li>
                </ul>
			</article>
			<!-- #########Batch Deduction Item######### -->
			<article class="tap_area">
				<!-- tap_area start -->
				<!-- table start -->
					<!-- grid_wrap start -->
					<aside class="title_line"><!-- title_line start -->
					<header class="pop_header" id="pop_header">
                    <h3></h3>
                        <ul class="right_btns">
                            <li><p class="btn_blue2"><a href="javascript:fn_getItmStatus('')">All Transactions</a></p></li>
                            <li><p class="btn_blue2"><a href="javascript:fn_getItmStatus(4)">Approved Transactions</a></p></li>
                            <li><p class="btn_blue2"><a href="javascript:fn_getItmStatus(6)">Rejected Transactions</a></p></li>
                        </ul>
                     </header>
                    </aside><!-- title_line end -->

					<table class="type1">
						<caption>table</caption>
						<tbody>
							<tr>
								<td colspan='5'>
									<div id="batchDeductionItem_grid_wrap" style="width: 100%; height: 480px; margin: 0 auto;"></div>
								</td>
							</tr>
						</tbody>
					</table>
					<!-- table end -->
				</article>
				<!-- grid_wrap end -->
			<!-- tap_area end -->
			<!-- </section> search_table end -->
		</section>
		<!-- tap_wrap end-->
	</section>
	<!-- pop_body end -->
</div>
<!-- popup_wrap end -->

<!---------------------------------------------------------------
    POP-UP (NEW ECASH AUTO DEBIT DEDUCTION)
---------------------------------------------------------------->
<!-- popup_wrap start -->
<div class="popup_wrap" id="new_wrap" style="display:none;">
    <!-- pop_header start -->
    <header class="pop_header" id="new_pop_header">
        <h1>NEW ECASH AUTO DEBIT DEDUCTION</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" onclick="hideViewPopup('#new_wrap')">CLOSE</a></p></li>
        </ul>
    </header>
    <!-- pop_header end -->

    <!-- pop_body start -->
    <form name="newForm" id="newForm"  method="post">
    <input type="hidden" name="v_isGrp"  id="v_isGrp" value = "1"/>
    <input type="hidden" name="v_isHA"  id="v_isHA" value = "1"/>
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
                            <select id="claimType" name="claimType" class="w100p" disabled></select>
                        </td>
                        <th scope="row">Merchant Bank<span class="must">*</span></th>
                        <td>
                            <select id="new_merchantBank" name="new_merchantBank" class="w100p"></select>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Issue Bank<span class="must">*</span></th>
                        <td>
                            <select class="multy_select w100p" multiple="multiple" id="new_issueBank" data-placeholder="Bank Name"></select>
                            <input type="hidden"  id="hiddenIssueBank" name="hiddenIssueBank"/>
                        </td>
                          <th scope="row">Card Type<span class="must" id="cardTypeMust">*</span></th>
                        <td>
                            <select id="new_cardType" name="new_cardType" class="w100p">
                                <option value="">Choose One</option>
                                <option value="All">All</option>
                                <option value="Visa Card">Visa Card</option>
                                <option value="Master Card">Master Card</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">New Deduction Sales<span class="must">*</span></th>
                        <td>
                            <label><input type="radio" name="newDeductSales" id="newDeductSales" value="1" /><span>Yes</span></label>
                            <label><input type="radio" name="newDeductSales" id="newDeductSales" value="0"/><span>No</span></label>
                        </td>
                        <th scope="row">Product<span class="must">*</span></th>
                        <td>
                            <select class="multy_select w100p" multiple="multiple" id="newProdCat" name="newProdCat" data-placeholder="Product">
									        <option value="HA">HA</option>
									        <option value="HC">HC</option>
                            </select>
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
                           <!-- <div class="auto_file">
                               <input type="file" id="fileSelector" title="file add" accept=".csv" />
                           </div> -->
                            <div class="auto_file"><!-- auto_file start -->
                            <input type="file" title="file add" id="uploadfile" name="uploadfile" accept=".csv"/>
                            </div><!-- auto_file end -->
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
            <li><p class="btn_blue2"><a href="${pageContext.request.contextPath}/resources/download/payment/eCashResultUpdate_Format.csv">Download CSV Format</a></p></li>
        </ul>
    </section>
    </form>
    <!-- pop_body end -->
</div>
<!-- popup_wrap end -->
