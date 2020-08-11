<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">
//AUIGrid 그리드 객체
var myPopGridID;


//AUIGrid 칼럼 설정
var myPopLayout = [
    { dataField:"memoAdjId" ,headerText:"<spring:message code='pay.head.adjustmentId'/>",width: 200 , editable : false, visible : false},
    { dataField:"memoAdjInvcTypeId" ,headerText:"<spring:message code='pay.head.invoiceTypeId'/>",width: 200 , editable : false, visible : false},
    { dataField:"memoAdjTypeId" ,headerText:"<spring:message code='pay.head.adjustmentTypeId'/>",width: 200 , editable : false, visible : false},
    { dataField:"batchId" ,headerText:"<spring:message code='pay.head.batchId'/>",width: 100 , editable : false, visible : false},
    { dataField:"memoAdjRefNo" ,headerText:"<spring:message code='pay.head.adjustmentNo'/>",width: 120 , editable : false},
    { dataField:"memoAdjInvcNo" ,headerText:"<spring:message code='pay.head.invoiceNumber'/>", editable : false, width : 120},
    { dataField:"billItmRefNo" ,headerText:"<spring:message code='pay.head.orderNo'/>", editable : false ,width : 120},
    { dataField:"custId" ,headerText:"<spring:message code='pay.head.customerId'/>", editable : false, width : 120},
    { dataField:"custName" ,headerText:"<spring:message code='pay.head.customerName'/>", editable : false, width : 200},
    { dataField:"memoAdjTotAmt" ,headerText:"<spring:message code='pay.head.adjustmentAmount'/>", editable : false, dataType : "numeric",formatString : "#,##0.00" ,width : 120}
    ];

//화면 초기화 함수 (jQuery 의 $(document).ready(function() {}); 과 같은 역할을 합니다.
$(document).ready(function(){

    //Grid Properties 설정
    var gridPros = {
            editable : false,                 // 편집 가능 여부 (기본값 : false)
            showStateColumn : false,     // 상태 칼럼 사용
            height : 200,
            pageRowCount : 5
    };

    // Order 정보 (Master Grid) 그리드 생성
    myPopGridID = GridCommon.createAUIGrid("grid_Pop_wrap", myPopLayout,null,gridPros);

    //초기화면 로딩시 조회
    selectAdjustmentBatchApprovalPop("${batchId}");

});

//상세 팝업
function selectAdjustmentBatchApprovalPop(batchId){

    //데이터 조회 (초기화면시 로딩시 조회)
    Common.ajax("GET", "/payment/selectAdjustmentBatchApprovalPop.do", {"batchId":batchId}, function(result) {
        if(result != 'undefined'){
        	console.log(result);

            //Master데이터 출력
            $("#tRequestor").text(result.master.memoAdjCrtUserId);
            $("#tStatus").text(result.master.memoAdjStusNm);
            $("#tDept").text(result.master.deptName);
            $("#tCreateDt").text(result.master.memoAdjCrtDt);
            $("#tBatchId").text(result.master.batchId);
            $("#tReason").text(result.master.resnDesc);
            $("#tRemark").text(result.master.memoAdjRem);
            $("#tAmount").text(result.master.memoAdjTotAmt);
            $("#finalAppv").text(result.finalAppr);

            //Detail데이터 출력
            AUIGrid.setGridData(myPopGridID, result.detailList);

            //History 데이터 출력
            $("#history").children().remove();
            $.each( result.histlList, function(key, value) {
            	$("#history").append("<li>  "+value.memoAdjRefNo+" - " + value.adjStusName+ " on " + value.adjCrtDt+ "</li>");
            });

            attachList = result.attachList;
            if(attachList) {
                if(attachList.length > 0) {
                    $("#attachTd").html("");
                    for(var i = 0; i < attachList.length; i++) {
                        //$("#attachTd").append("<div class='auto_file2 auto_file3'><input type='text' class='input_text' readonly='readonly' value='" + attachList[i].atchFileName + "'/></div>");
                        var atchTdId = "atchId" + (i+1);
                        $("#attachTd").append("<div class='auto_file2 auto_file3'><input type='text' class='input_text' readonly='readonly' name='" + atchTdId + "'/></div>");
                        $(".input_text[name='" + atchTdId + "']").val(attachList[i].atchFileName);
                    }

                    // 파일 다운
                    $(".input_text").dblclick(function() {
                        var oriFileName = $(this).val();
                        var fileGrpId;
                        var fileId;
                        for(var i = 0; i < attachList.length; i++) {
                            if(attachList[i].atchFileName == oriFileName) {
                                fileGrpId = attachList[i].atchFileGrpId;
                                fileId = attachList[i].atchFileId;
                            }
                        }
                        fn_atchViewDown(fileGrpId, fileId);
                    });
                }
            }

            var appvPrcssStus;
            for(var i = 0; i < result.apprList.appvPrcssStus.length; i++) {
                if(appvPrcssStus == null) {
                    appvPrcssStus = result.apprList.appvPrcssStus[i];
                } else {
                    appvPrcssStus += "<br />" + result.apprList.appvPrcssStus[i];
                }
            }
            $("#viewAppvStus").html(appvPrcssStus);
        }
    });
}

function fn_atchViewDown(fileGrpId, fileId) {
    var data = {
            atchFileGrpId : fileGrpId,
            atchFileId : fileId
    };
    Common.ajax("GET", "/eAccounting/webInvoice/getAttachmentInfo.do", data, function(result) {
        console.log(result);
        if(result.fileExtsn == "jpg" || result.fileExtsn == "png" || result.fileExtsn == "gif") {
            // TODO View
            var fileSubPath = result.fileSubPath;
            fileSubPath = fileSubPath.replace('\', '/'');
            console.log(DEFAULT_RESOURCE_FILE + fileSubPath + '/' + result.physiclFileName);
            window.open(DEFAULT_RESOURCE_FILE + fileSubPath + '/' + result.physiclFileName);
        } else {
            var fileSubPath = result.fileSubPath;
            fileSubPath = fileSubPath.replace('\', '/'');
            console.log("/file/fileDownWeb.do?subPath=" + fileSubPath
                    + "&fileName=" + result.physiclFileName + "&orignlFileNm=" + result.atchFileName);
            window.open("/file/fileDownWeb.do?subPath=" + fileSubPath
                + "&fileName=" + result.physiclFileName + "&orignlFileNm=" + result.atchFileName);
        }
    });
}

function fn_approve(process){
	var param = {
			           "process" : process,
			           "appvRem" : $("#appvRem").val()
			           };

	  //param data array
    var data = GridCommon.getGridData(myPopGridID);
    data.form = param;

    //Ajax 호출
    Common.ajax("POST", "/payment/approvalBatchAdjustment.do", data, function(result) {
        Common.alert("<spring:message code='pay.alert.invoiceAdjSuccess'/>",function(){
        	fn_getAdjustmentListAjax();    //메인 페이지 조회
        	$('#_approvalBatchPop').remove();
        });

    });

}


</script>
<!-- popup_wrap start -->
<div id="popup_wrap" class="popup_wrap">
    <header class="pop_header">
        <h1>Credit Note / Debit Note</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#"><spring:message code='sys.btn.close'/></a></p></li>
        </ul>
    </header>

    <!-- pop_body start -->
    <section class="pop_body">
        <aside class="title_line mt0">
            <h2>Adjustment Information</h2>
        </aside>

        <!-- table start -->
        <table class="type1">
            <caption>table</caption>
            <colgroup>
                <col style="width:180px" />
                <col style="width:*" />
                <col style="width:180px" />
                <col style="width:*" />
            </colgroup>
            <tbody>
                <tr>
                    <th scope="row">Requestor ID</th>
                    <td id="tRequestor"></td>
                    <th scope="row">Adjustment Status</th>
                    <td id="tStatus"></td>
                </tr>
                <tr>
                    <th scope="row">Department</th>
                    <td id="tDept"></td>

                    <th scope="row">Creation Date</th>
                    <td id="tCreateDt"></td>
                </tr>
                <tr>
                    <th scope="row">Batch ID</th>
                    <td id="tBatchId" colspan="3"></td>
                </tr>
                <tr>
                    <th scope="row">Reason</th>
                    <td id="tReason" colspan="3"></td>
                </tr>
                <tr>
                    <th scope="row">Remark</th>
                    <td id="tRemark" colspan="3"></td>
                </tr>
                <tr>
                    <th scope="row">Total Adjustment Amount(RM)</th>
                    <td id="tAmount" colspan="3"></td>
                </tr>
                <tr>
                    <th scope="row">Approval Status</th>
                    <!-- <td colspan="3" style="height:60px" id="viewAppvStus"></td> -->
                    <td colspan="3">
                        <div class="w100p"><!-- tran_list start -->
                            <ul id="viewAppvStus">
                            </ul>
                        </div><!-- tran_list end -->
                    </td>
                </tr>
                <tr>
                    <th scope="row">Final Approver</th>
                    <td colspan="3"  id="finalAppv"></td>
                </tr>
                <tr>
                    <th scope="row"><spring:message code="newWebInvoice.attachment" /></th>
                    <td colspan="3" id="attachTd">
                        <div class="auto_file2 auto_file3"><!-- auto_file start -->
                            <input type="file" title="file add" />
                        </div><!-- auto_file end -->
                    </td>
                </tr>
                <tr>
                    <th scope="row">Approver Comment</th>
                    <td colspan="3"><textarea class="w100p" rows="2" style="height:auto" id="appvRem" name="appvRem"></textarea></td>
                </tr>
            </tbody>
        </table><!-- table end -->

        <aside class="title_line">
            <h2>Item(s) Information</h2>
        </aside>
        <article id="grid_Pop_wrap" class="grid_wrap"></article>

        <aside class="title_line">
            <h2>History Information</h2>
        </aside>

        <section class="history-info">
            <div class="tran_list fl_none w100p"><!-- tran_list start -->
                <ul id="history">
                </ul>
            </div><!-- tran_list end -->
        </section>

        <ul class="center_btns mt20" id="centerBtn">
            <li><p class="btn_blue2"><a href="javascript:fn_approve('APPROVE');"><spring:message code='pay.btn.approve'/></a></p></li>
            <li><p class="btn_blue2"><a href="javascript:fn_approve('REJECT');"><spring:message code='pay.btn.reject'/></a></p></li>
        </ul>
    </section><!-- pop_body end -->

</div><!-- popup_wrap end -->
