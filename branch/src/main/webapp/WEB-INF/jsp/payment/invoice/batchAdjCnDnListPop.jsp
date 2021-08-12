<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<script type="text/javaScript">

var newBatchGridID, newBatchAdjGridID, approveLineGridID;
var selectRowIdx;

//Default Combo Data
var adjStatusData = [{"codeId": "1","codeName": "Active"},{"codeId": "4","codeName": "Completed"},{"codeId": "21","codeName": "Failed"}];

//Default Combo Data
var adjTypeData = [{"codeId": "1293","codeName": "Credit Note"},{"codeId": "1294","codeName": "Debit Note"}];

//Grid Properties 설정
var gridPros = {
        editable : false,                 // 편집 가능 여부 (기본값 : false)
        showStateColumn : false,     // 상태 칼럼 사용
        headerHeight : 35,
        softRemoveRowMode:false
};

var columnLayout=[
    { dataField:"batchId" ,headerText:"<spring:message code='pay.head.batchId'/>" ,editable : false},
    { dataField:"memoAdjRefNo" ,headerText:"<spring:message code='pay.head.cnDnNo'/>" ,editable : false },
    { dataField:"memoAdjInvcNo" ,headerText:"<spring:message code='pay.head.invoiceNo'/>" ,editable : false },
    { dataField:"invcItmOrdNo" ,headerText:"<spring:message code='pay.head.orderNo'/>" ,editable : false},
    { dataField:"memoItmAmt" ,headerText:"<spring:message code='pay.head.adjustmentAmount'/>" ,editable : false },
    { dataField:"resnDesc" ,headerText:"<spring:message code='pay.head.reason'/>" ,editable : false },
    { dataField:"userName" ,headerText:"<spring:message code='pay.head.requestor'/>" ,editable : false },
    { dataField:"deptName" ,headerText:"<spring:message code='pay.head.department'/>" ,editable : false },
    { dataField:"memoAdjCrtDt" ,headerText:"Request Create Date" ,editable : false },
    { dataField:"code1" ,headerText:"<spring:message code='pay.head.status'/>" ,editable : false },
    { dataField:"memoAdjRem" ,headerText:"<spring:message code='pay.head.remark'/>" ,editable : false }
    ];

var newBatchColLayout = [
    {dataField : "0", headerText : "<spring:message code='pay.head.invoiceNumber'/>", editable : true},
    {dataField : "1", headerText : "<spring:message code='pay.head.orderNumber'/>", editable : true},
    {dataField : "2", headerText : "<spring:message code='pay.head.itemId'/>", editable : true},
    {dataField : "3", headerText : "<spring:message code='pay.head.adjustmentAmount'/>", editable : true, dataType : "numeric", formatString : "#,##0.00"}
    ];

var approveLineColumnLayout = [
    {
        dataField : "approveNo",
        headerText : '<spring:message code="approveLine.approveNo" />',
        dataType: "numeric",
        expFunction : function( rowIndex, columnIndex, item, dataField ) {
            return rowIndex + 1;
        }
    }, {
        dataField : "memCode",
        headerText : '<spring:message code="approveLine.userId" />',
        colSpan : 2
    }, {
        dataField : "",
        headerText : '',
        width: 30,
        renderer : {
            type : "IconRenderer",
            iconTableRef :  {
                "default" : "${pageContext.request.contextPath}/resources/images/common/normal_search.png"
                    },
            iconWidth : 24,
            iconHeight : 24,
            onclick : function(rowIndex, columnIndex, value, item) {
                console.log("selectRowIdx : " + selectRowIdx);
                selectRowIdx = rowIndex;
                fn_searchUserIdPop();
            }
        },
        colSpan : -1
    },{
        dataField : "name",
        headerText : '<spring:message code="approveLine.name" />',
        style : "aui-grid-user-custom-left"
    }, {
        dataField : "",
        headerText : '<spring:message code="approveLine.addition" />',
        renderer : {
            type : "IconRenderer",
            iconTableRef :  {
                "default" : "${pageContext.request.contextPath}/resources/images/common/btn_plus.gif"// default
            },
            iconWidth : 12,
            iconHeight : 12,
            onclick : function(rowIndex, columnIndex, value, item) {
                var rowCount = AUIGrid.getRowCount(approveLineGridID);
                if (rowCount > 3) {
                    Common.alert('<spring:message code="approveLine.appvLine.msg" />');
                } else {
                    fn_appvLineGridAddRow();
                }
            }
        }
    }];

    // Approval line Grid Option
var approveLineGridPros = {
    usePaging : true,
    pageRowCount : 20,
    showStateColumn : true,
    enableRestore : true,
    showRowNumColumn : false,
    softRemovePolicy : "exceptNew",
    softRemoveRowMode : false,
    selectionMode : "multipleCells"
};

// 화면 초기화 함수 (jQuery 의 $(document).ready(function() {}); 과 같은 역할을 합니다.
$(document).ready(function(){

	 //Adjustment Type 생성
    doDefCombo(adjTypeData, '' ,'newAdjType', 'S', '');

    //Adjustment Status 생성
    doDefCombo(adjStatusData, '' ,'status', 'S', '');

    //Adjustment Type 변경시 Reason Combo 생성
    $('#newAdjType').change(function (){
        $("#newAdjReason option").remove();

        if($(this).val() != ""){
            var param = $(this).val() == "1293" ? "1584" : "1585";
            doGetCombo('/common/selectAdjReasontList.do', param , ''   , 'newAdjReason' , 'S', '');
        }
    });

    //Grid 생성
	newBatchGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,null,gridPros);
	newBatchAdjGridID = GridCommon.createAUIGrid("newBatchAdj_grid_wrap", newBatchColLayout,null,gridPros);
	approveLineGridID = GridCommon.createAUIGrid("approveLine_grid_wrap", approveLineColumnLayout, null, approveLineGridPros);


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
                    AUIGrid.setCsvGridData(newBatchAdjGridID, event.target.result, false);

                  //csv 파일이 header가 있는 파일이면 첫번째 행(header)은 삭제한다.
                    AUIGrid.removeRow(newBatchAdjGridID,0);
                } else {
                	Common.alert("<spring:message code='pay.alert.noData'/>");
                }
            };
            reader.onerror = function() {
            	Common.alert("<spring:message code='pay.alert.unableToRead' arguments='"+file.fileName+"' htmlEscape='false'/>");
            };
        }

        });

    AUIGrid.bind(approveLineGridID, "cellClick", function( event ) {
        console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");
        selectRowIdx = event.rowIndex;
    });

    fn_appvLineGridAddRow();

});

// HTML5 브라우저인지 체크 즉, FileReader 를 사용할 수 있는지 여부
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

	AUIGrid.showAjaxLoader(newBatchAdjGridID);

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
                AUIGrid.setCsvGridData(newBatchAdjGridID, csvText);
                AUIGrid.removeAjaxLoader(newBatchAdjGridID);

              //csv 파일이 header가 있는 파일이면 첫번째 행(header)은 삭제한다.
                AUIGrid.removeRow(newBatchAdjGridID,0);
            }
    		   },
    		   error : function(e) {
    			   Common.alert("ajaxSubmit Error : " + e);
    			   }
    		   });

 }

// 리스트 조회.
function fn_getAdjustmentListAjax() {
	if(FormUtil.checkReqValue($("#batchId"))){
		Common.alert("<spring:message code='pay.alert.selectBatchId'/>");
        return;
    }

    Common.ajax("GET", "/payment/selectAdjustmentList.do", $("#searchForm").serialize(), function(result) {
        AUIGrid.setGridData(newBatchGridID, result);
    });
}

//New Batch Adjustment Pop-UP
function fn_openDivPop(){
	$("#newBatchAdj_wrap").show();

}

//Layer close
hideViewPopup=function(val){
	if(val == "#newBatchAdj_wrap") {
		AUIGrid.destroy(newBatchAdjGridID);
	    newBatchAdjGridID = GridCommon.createAUIGrid("newBatchAdj_grid_wrap", newBatchColLayout,null,gridPros);
	    $("#newBatchAdjForm")[0].reset();
	} else if(val == "#appvLinePop") {
		AUIGrid.destroy(approveLineGridID);
        approveLineGridID = GridCommon.createAUIGrid("approveLine_grid_wrap", approveLineColumnLayout, null, approveLineGridPros);
        $("#appvLinePop")[0].reset();
	}
    $(val).hide();
}

//Save
function fn_batchAdjFileUp(){

	 //param data array
    var data = GridCommon.getGridData(newBatchAdjGridID);
    data.form = $("#newBatchAdjForm").serializeJSON();


    if(FormUtil.checkReqValue($("#newAdjType option:selected")) ){
    	Common.alert("<spring:message code='pay.alert.selectAdjType'/>");
        return;
    }

    if(FormUtil.checkReqValue($("#newAdjReason option:selected")) ){
    	Common.alert("<spring:message code='pay.alert.selectAdjReason'/>");
        return;
    }

    if(FormUtil.checkReqValue($("#newRemark")) ){
    	Common.alert("<spring:message code='pay.alert.selectAdjRemark'/>");
        return;
    }

    if(data.all.length < 1){
    	Common.alert("<spring:message code='pay.alert.selectCsvFile'/>");
        return;
    }

    if($("input[name=fileSelector2]")[0].files[0] == "" || $("input[name=fileSelector2]")[0].files[0] == null) {
        Common.alert("Please attach supporting document!")
        return false;
    }

    $("#fileSelector").val("");

    $("#appvLinePop").show();
    AUIGrid.resize(approveLineGridID, 565, $(".approveLine_grid_wrap").innerHeight());

    //Ajax 호출
    //Common.ajaxFile()

    /*
    Common.ajax("POST", "/payment/saveBatchNewAdjList.do", data, function(result) {
    	var returnMsg = "<spring:message code='pay.alert.saveBatchNewAdjList' arguments='"+result.data+"' htmlEscape='false'/>";

        Common.alert(returnMsg, function (){
        	hideViewPopup('#newBatchAdj_wrap');
        });

    },  function(jqXHR, textStatus, errorThrown) {
        try {
            console.log("status : " + jqXHR.status);
            console.log("code : " + jqXHR.responseJSON.code);
            console.log("message : " + jqXHR.responseJSON.message);
            console.log("detailMessage : " + jqXHR.responseJSON.detailMessage);
        } catch (e) {
            console.log(e);
        }
        Common.alert("Fail : " + jqXHR.responseJSON.message);
    });
*/
}

function fn_submit() {
    console.log("fn_submit");
    if($("input[name=fileSelector2]")[0].files[0] == "" || $("input[name=fileSelector2]")[0].files[0] == null) {
        Common.alert("Please attach supporting document!");
        return false;
    }

    var obj = $("#searchForm").serializeJSON();
    obj.apprGridList = AUIGrid.getOrgGridData(approveLineGridID);

    Common.ajax("POST", "/payment/checkFinAppr.do", obj, function(resultFinAppr) {
        console.log(resultFinAppr);

        if(resultFinAppr.code == "99") {
            Common.alert("Please select the relevant final approver.");
        } else {
            var formData = Common.getFormData("newBatchAdjForm");

            Common.ajaxFile("/payment/attachmentUpload.do", formData, function(uResult) {
                console.log(uResult);

                $("#atchFileGrpId").val(uResult.data.fileGroupKey);

                var data = GridCommon.getGridData(newBatchAdjGridID)
                data.form = $("#newBatchAdjForm").serializeJSON();
                data.apprGridList = AUIGrid.getOrgGridData(approveLineGridID);

                Common.ajax("POST", "/payment/saveBatchNewAdjList.do", data, function(result) {
                    var returnMsg = "<spring:message code='pay.alert.saveBatchNewAdjList' arguments='"+result.data+"' htmlEscape='false'/>";

                    Common.alert(returnMsg, function (){
                        hideViewPopup('#appvLinePop');
                        hideViewPopup('#newBatchAdj_wrap');
                    });

                },  function(jqXHR, textStatus, errorThrown) {
                    try {
                        console.log("status : " + jqXHR.status);
                        console.log("code : " + jqXHR.responseJSON.code);
                        console.log("message : " + jqXHR.responseJSON.message);
                        console.log("detailMessage : " + jqXHR.responseJSON.detailMessage);
                    } catch (e) {
                        console.log(e);
                    }
                    Common.alert("Fail : " + jqXHR.responseJSON.message);
                });
            });
        }
    });
}

/*******************
Approval Line Functions
*******************/
function fn_appvLineGridAddRow() {
   AUIGrid.addRow(approveLineGridID, {}, "first");
}

function fn_appvLineGridDeleteRow() {
   AUIGrid.removeRow(approveLineGridID, selectRowIdx);
}

function fn_searchUserIdPop() {
   Common.popupDiv("/common/memberPop.do", {callPrgm:"NRIC_VISIBLE"}, null, true);
}

function fn_newRegistMsgPop() {
   var length = AUIGrid.getGridData(approveLineGridID).length;
   var checkMemCode = true;
   console.log(length);
   // 1개의 default Line 존재
   if(length >= 1) {
       for(var i = 0; i < length; i++) {
           if(FormUtil.isEmpty(AUIGrid.getCellValue(approveLineGridID, i, "memCode"))) {
               Common.alert('<spring:message code="approveLine.userId.msg" />' + (i +1) + ".");
               checkMemCode = false;
           }
       }
   }
   console.log(checkMemCode);
   if(checkMemCode) {
       Common.popupDiv("/eAccounting/webInvoice/newRegistMsgPop.do", null, null, true, "registMsgPop");
   }
}

function fn_loadOrderSalesman(memId, memCode) {
   var result = true;
   var list = AUIGrid.getColumnValues(approveLineGridID, "memCode", true);

   if(list.length > 0) {
       for(var i = 0; i < list.length; i ++) {
           if(memCode == list[i]) {
               result = false;
           }
       }
   }

   if(result) {
       Common.ajax("GET", "/sales/order/selectMemberByMemberIDCode.do", {memId : memId, memCode : memCode}, function(memInfo) {

           if(memInfo == null) {
               Common.alert('<b>Member not found.</br>Your input member code : '+memCode+'</b>');
           }
           else {
               console.log(memInfo);
               AUIGrid.setCellValue(approveLineGridID, selectRowIdx, "memCode", memInfo.memCode);
               AUIGrid.setCellValue(approveLineGridID, selectRowIdx, "name", memInfo.name);
           }
       });
   } else {
       Common.alert('Not allowed to select same User ID in Approval Line');
   }
}


</script>
<div id="popup_wrap" class="popup_wrap pop_win"><!-- popup_wrap start -->
    <header class="pop_header"><!-- pop_header start -->
        <h1>Batch Invoice Adjustment (CN / DN)</h1>
        <ul class="right_opt">
            <li><p class="btn_blue"><a href="javascript:fn_getAdjustmentListAjax();"><span class="search"></span><spring:message code='sys.btn.search'/></a></p></li>
        </ul>
    </header><!-- pop_header end -->

    <section class="pop_body"><!-- pop_body start -->
        <form name="searchForm" id="searchForm"  method="post">
            <table class="type1"><!-- table start -->
                <caption>table</caption>
                <colgroup>
                    <col style="width:180px" />
                    <col style="width:*" />
                    <col style="width:180px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">Batch ID.</th>
                        <td>
                           <input id="batchId" name="batchId" type="text" placeholder="Batch Id." class="w100p" />
                        </td>
                        <th scope="row">Adjustment Status</th>
                        <td>
                            <select id="status" name="status" class="w100p"></select>
                        </td>
                    </tr>
                    <tr>
                       <th scope="row">Request Name</th>
                       <td>
                           <input id="creator" name="creator" type="text" placeholder="Request Name." class="w100p" />
                        </td>
                        <th scope="row">Department Name</th>
                        <td>
                           <input id="deptNm" name="deptNm" type="text" placeholder="Department Name" class="w100p" />
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
                         <li><p class="link_btn type2"><a href="javascript:fn_openDivPop();"><spring:message code='pay.btn.link.newBatch'/></a></p></li>
                    </ul>
                    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
                    </dd>
                </dl>
            </aside>
            <!-- link_btns_wrap end -->
        </form>

        <article id="grid_wrap" class="grid_wrap"></article>

    </section><!-- pop_body end -->
</div><!-- popup_wrap end -->

<!---------------------------------------------------------------
    POP-UP (NEW Batch ADJUSTMENT)
---------------------------------------------------------------->
<!-- popup_wrap start -->
<div class="popup_wrap" id="newBatchAdj_wrap" style="display:none;">
    <!-- pop_header start -->
    <header class="pop_header" id="newBatchAdj_header">
        <h1>NEW BATCH ADJUSTMENT</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" onclick="hideViewPopup('#newBatchAdj_wrap')"><spring:message code='sys.btn.close'/></a></p></li>
        </ul>
    </header>
    <!-- pop_header end -->

    <!-- pop_body start -->
    <form name="newBatchAdjForm" id="newBatchAdjForm"  method="post">
    <input type="hidden" id="atchFileGrpId" name="atchFileGrpId" />
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
                       <th scope="row">Adjustment Type</th>
                        <td>
                            <select id="newAdjType" name="newAdjType" ></select>
                        </td>
                        <th scope="row">Reason</th>
                        <td>
                            <select id="newAdjReason" name="newAdjReason"></select>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Remark</th>
                        <td colspan="3">
                            <textarea id="newRemark" name="newRemark"></textarea>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">File</th>
                        <td colspan="3">
                            <!-- auto_file start -->
                           <div class="auto_file">
                               <input type="file" id="fileSelector" title="file add" accept=".csv" />
                           </div>
                           <!-- auto_file end -->
                        </td>
                    </tr>
                    <tr>
                        <th scope="row"><spring:message code="newWebInvoice.attachment" /></th>
                        <td colspan="3" id="attachTd">
                            <div class="auto_file w100p"><!-- auto_file start -->
                                <input type="file" title="file add" style="width:300px" id="fileSelector2" name="fileSelector2" />
                            </div><!-- auto_file end -->
                        </td>
                    </tr>
                   </tbody>
            </table>
        </section>

        <section class="search_result"><!-- search_result start -->
            <article class="grid_wrap"  id="newBatchAdj_grid_wrap"  style="display:none;"></article>
            <!-- grid_wrap end -->
        </section><!-- search_result end -->
        <!-- search_table end -->

        <ul class="center_btns" >
            <li><p class="btn_blue2"><a href="javascript:fn_batchAdjFileUp();"><spring:message code='pay.btn.uploadFile'/></a></p></li>
            <li><p class="btn_blue2"><a href="${pageContext.request.contextPath}/resources/download/payment/InvoiceAdjustmentBatch_Format.csv"><spring:message code='pay.btn.downloadTemplate'/></a></p></li>
        </ul>
    </section>
    </form>
    <!-- pop_body end -->
</div>
<!-- popup_wrap end -->
<!-------------------------------------------------------------------------------------
    POP-UP (APPROVAL LINE)
-------------------------------------------------------------------------------------->
    <!-- popup_wrap start -->
    <div class="popup_wrap size_mid2" id="appvLinePop" style="display: none;">
        <header class="pop_header"><!-- pop_header start -->
            <h1><spring:message code="approveLine.title" /></h1>
            <ul class="right_opt">
                <li><p class="btn_blue2"><a href="#" onclick="hideViewPopup('#appvLinePop')"><spring:message code='sys.btn.close'/></a></p></li>
            </ul>
        </header><!-- pop_header end -->

        <section class="pop_body"><!-- pop_body start -->
            <section class="search_result"><!-- search_result start -->
                <ul class="right_btns">
                    <li><p class="btn_grid"><a href="javascript:fn_appvLineGridDeleteRow()" id="lineDel_btn"><spring:message code="newWebInvoice.btn.delete" /></a></p></li>
                </ul>

                <article class="grid_wrap" id="approveLine_grid_wrap"><!-- grid_wrap start -->
                </article><!-- grid_wrap end -->

                <ul class="center_btns">
                    <li><p class="btn_blue2"><a href="javascript:fn_submit()" id="submit"><spring:message code="newWebInvoice.btn.submit" /></a></p></li>
                </ul>

            </section><!-- search_result end -->
        </section><!-- pop_body end -->
    </div><!-- popup_wrap end -->
