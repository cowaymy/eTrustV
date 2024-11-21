<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<script type="text/javascript">

    var gridID1;
    var gridPros = {
            usePaging           : true,         //페이징 사용
            pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)
            editable            : false,
            fixedColumnCount    : 0,
            showStateColumn     : true,
            displayTreeOpen     : false,
   //         selectionMode       : "singleRow",  //"multipleCells",
            headerHeight        : 30,
            useGroupingPanel    : false,        //그룹핑 패널 사용
            skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력
            noDataMessage       : "No order found.",
            groupingMessage     : "Here groupping"
        };

    $(document).ready(function() {

    	fn_checkMailingStatus();

        $("#isMailingTrue").on('click', function(event) {
            event.preventDefault(); // Prevent the default action (checking/unchecking)
        });

        $("#dscBranch_search_btn").click(fn_popDscBranchSearchPop);

    	//if(funcChange == 'Y'){
    	//	$("#updateButt").show();
    	//	$("#updateTable").show();
    	//	$("#updateTitle").show();
    	//}
        fn_setAutoFile2();
		//Set Default Main Department
		$("#_inputMainDeptSelect").val('MD20');
        doGetCombo('/services/ecom/selectSubDept.do',  $("#_inputMainDeptSelect").val(), 'SD299','_inputSubDeptSelect', 'S' ,  '');
        //Populate Sub Department in-charge
        $("#_inputMainDeptSelect").change(function(){
            doGetCombo('/services/ecom/selectSubDept.do',  $("#_inputMainDeptSelect").val(), '','_inputSubDeptSelect', 'S' ,  '');
        });

        //file Delete
        $("#btnfileDel").click(function() {
            $("#reqAttchFile").val('');
            $(".input_text").val('');
            console.log("fileDel complete.");
        });

        $("#apprvResn").keyup(function(){
            $("#characterCount").text($(this).val().length + " of 900 max characters");
      });

        $("#rejctResn").keyup(function(){
            $("#characterCount").text($(this).val().length + " of 900 max characters");
      });

      $("#cancel_btn_approve").click(fn_closePop_approve);

      $("#cancel_btn_reject").click(fn_closePop_reject);

      $("#confirm_btn_approve").click(function () {
          var apprvResn = $("#apprvResn").val();
          fn_Approve("appv", apprvResn);
          $("#popup_wrap_approve").remove();
      });
      $("#confirm_btn_reject").click(function () {
          var apprvResn = $("#rejctResn").val();
          fn_Reject("rejt", apprvResn);
          $("#popup_wrap_reject").remove();
      });

    });//Doc Ready End


    var gridProse = {
            usePaging           : true,             //페이징 사용
            pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)
            editable                : false,
            fixedColumnCount    : 1,
            showStateColumn     : true,
            displayTreeOpen     : false,
            selectionMode       : "singleRow",  //"multipleCells",
            headerHeight        : 30,
            useGroupingPanel    : false,        //그룹핑 패널 사용
            skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력
            noDataMessage       :  gridMsg["sys.info.grid.noDataMessage"],
            groupingMessage     : gridMsg["sys.info.grid.groupingMessage"]
        };

    var cpeHistoryDetailsColumnLayout= [
                                   {dataField : "requestType", headerText : "Request Type", width : '20%'},
                                   {dataField : "subRequest", headerText : "Sub Request", width : '15%'},
                                   {dataField : "requestor", headerText : "Requestor", width : '15%'},
                                   {dataField : "requestDate", headerText : "Requestor Date", width : '10%'},
                                   {dataField : "approval", headerText : "Approval", width : '20%'},
                                   {dataField : "status", headerText : "Status", width : '20%'},
                                   {dataField : "approvedDate", headerText : "Approval Date", width : '15%'},
                                   ];

    //cpeHistoryDetailsId = GridCommon.createAUIGrid("#cpeHistoryDetails_grid_wrap", cpeHistoryDetailsColumnLayout,null,gridProse);
    //AUIGrid.resize(cpeHistoryDetailsId,945, $(".grid_wrap").innerHeight());
    ////////////////////////////////////////////////////////////////////////////////////

    function chgGridTab(tabNm) {
        switch(tabNm) {
            case 'custInfo' :
                AUIGrid.resize(custInfoGridID, 920, 300);
                break;
            case 'memInfo' :
                AUIGrid.resize(memInfoGridID, 920, 300);
                break;
            case 'docInfo' :
                AUIGrid.resize(docGridID, 920, 300);
                if(AUIGrid.getRowCount(docGridID) <= 0) {
                    fn_selectDocumentList();
                }
                break;
            case 'callLogInfo' :
                AUIGrid.resize(callLogGridID, 920, 300);
                if(AUIGrid.getRowCount(callLogGridID) <= 0) {
                    fn_selectCallLogList();
                }
                break;
            case 'payInfo' :
                AUIGrid.resize(payGridID, 920, 300);
                if(AUIGrid.getRowCount(payGridID) <= 0) {
                    fn_selectPaymentList();
                }
                break;
            case 'transInfo' :
                AUIGrid.resize(transGridID, 920, 300);
                if(AUIGrid.getRowCount(transGridID) <= 0) {
                    fn_selectTransList();
                }
                break;
            case 'autoDebitInfo' :
                AUIGrid.resize(autoDebitGridID, 920, 300);
                if(AUIGrid.getRowCount(autoDebitGridID) <= 0) {
                    fn_selectAutoDebitList();
                }
                break;
            case 'discountInfo' :
                AUIGrid.resize(discountGridID, 920, 300);
                if(AUIGrid.getRowCount(discountGridID) <= 0) {
                    fn_selectDiscountList();
                }
                break;
        };
    }

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    function fn_checkEmptyFields() {
        var checkResult = true;

        if (FormUtil.isEmpty($("#_inputMainDeptSelect").val())) {
            Common.alert('Main Department is required.');
            checkResult = false;
        }

        if (FormUtil.isEmpty($("#_inputSubDeptSelect").val())) {
            Common.alert('Sub Department is required.');
            checkResult = false;
        }

        if (FormUtil.isEmpty($("#status").val())) {
            Common.alert('Status is required.');
            checkResult = false;
        }

        return checkResult;
    }

    function fn_setAutoFile2() {
        $(".auto_file2").append("<label><input type='text' class='input_text' readonly='readonly' /><span class='label_text'><a href='#'>File</a></span></label><span class='label_text'><a id='btnfileDel'>Delete</a></span>");
    }

    function fn_closePopRefreshSearch() {
    	$("#ecpeRqstUpdateApprovePop").remove();
    	fn_search();
    }

    function fn_pageBack() {
    $("#view_wrap").remove();
    }

    function fn_checkMailingStatus() {
        if ("${requestInfo.isMailling}" === "1") {
            $("#isMailingTrue").prop("checked", true);  // Replace #mailCheckbox with the actual checkbox ID
        } else {
            $("#isMailingTrue").prop("checked", false); // Replace #mailCheckbox with the actual checkbox ID
        }
    }

    function fn_AttachmentClick(element) {
        // Retrieve data from the clicked element
        var atchFileGrpId = $(element).data('atchfilegrpid');
        var atchFileId = $(element).data('atchfileid');
        var fileExtsn = $(element).data('fileextsn');

        console.log("view_btn click atchFileGrpId : " + atchFileGrpId + " atchFileId : " + atchFileId);

        var data = {
            atchFileGrpId: atchFileGrpId,
            atchFileId: atchFileId
        };

        // For other file types, download
        Common.ajax("GET", "/eAccounting/webInvoice/getAttachmentInfo.do", data, function(result) {
            console.log(result);
            var fileSubPath = result.fileSubPath;
            fileSubPath = fileSubPath.replace('\', '/'');
            console.log("/file/fileDownWeb.do?subPath=" + fileSubPath +
                        "&fileName=" + result.physiclFileName + "&orignlFileNm=" + result.atchFileName);
            window.open("/file/fileDownWeb.do?subPath=" + fileSubPath +
                        "&fileName=" + result.physiclFileName + "&orignlFileNm=" + result.atchFileName);
        });

    }

    function fn_popDscBranchSearchPop() {
        Common.popupDiv("/services/ecom/ecpeDscBranchSearchPop.do", {pop:"pop"}, null, true, "dscBrnchSearchPop");
    }

    function fn_setPopDscBranch() {
        $("#dscBrnchId").val($("#search_dscBranchId").val());
        $("#dscBrnchCode").val($("#search_dscBranch").val());
        $("#dscBrnchName").val($("#search_dscBranchName").val());
    }

    function fn_setDscBranch() {
    	 $("#dscBrnchId").val($("#search_dscBranchId").val());
         $("#dscBrnchCode").val($("#search_dscBranch").val());
         $("#dscBrnchName").val($("#search_dscBranchName").val());
    }

    function fn_Transfer() {

      var formData = Common.getFormData("form_updReqst");
      var obj = $("#form_updReqst").serializeJSON();

      $.each(obj, function(key, value) {
        formData.append(key, value);
      });

      Common.ajaxFile("/services/ecom/ecpeTransfer.do", formData, function(result) {
          console.log(result);
          Common.alert('CPE Transfered.', fn_closePopRefreshSearch);
      });
 }


    function fn_Approve(appvResn) {

    	var formData = Common.getFormData("form_updReqst");
        var obj = $("#form_updReqst").serializeJSON();
        var reasonObj = $("#form_approveReason").serializeJSON();

        $.each(obj, function(key, value) {
          formData.append(key, value);
        });

        $.each(reasonObj, function(key, value) {
        	  formData.append(key, value);
        });

        Common.ajaxFile("/services/ecom/ecpeApprove.do", formData, function(result) {
            console.log(result);
            Common.alert('CPE Aprroved.', fn_closePopRefreshSearch);
        });
 }

    function fn_Reject(rejctResn) {

        var formData = Common.getFormData("form_updReqst");
        var obj = $("#form_updReqst").serializeJSON();
        var reasonObj = $("#form_rejectReason").serializeJSON();

        console.log("form_updReqst data:", obj);
        console.log("form_rejectReason data:", reasonObj);

        $.each(obj, function(key, value) {
          formData.append(key, value);
        });

        $.each(reasonObj, function(key, value) {
            formData.append(key, value);
      });

        Common.ajaxFile("/services/ecom/ecpeReject.do", formData, function(result) {
            console.log(result);
            Common.alert('CPE Rejected', fn_closePopRefreshSearch);
        });
 }

    function fn_Reason_Approve() {
    	 $("#popup_wrap_approve").show();
    }

    function fn_Reason_Reject() {
    	$("#popup_wrap_reject").show();
    }

    function fn_closePop_approve() {
        $("#popup_wrap_approve").remove();
    }

    function fn_closePop_reject() {
        $("#popup_wrap_reject").remove();
    }
</script>

<div id="popup_wrap1" class="popup_wrap size_big"><!-- popup_wrap start -->
<form id="form_updReqst">
<header class="pop_header"><!-- pop_header start -->
<h1>CPE Request</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="javascript:fn_Reason_Approve()">Approve</a></p></li>
    <li><p class="btn_blue2"><a href="javascript:fn_Reason_Reject()">Reject</a></p></li>
    <li><p class="btn_blue2"><a href="javascript:fn_Transfer()">Transfer</a></p></li>
    <li><p class="btn_blue2"><a id="_cpeResultPopCloseBtn"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->
<section class="pop_body"><!-- pop_body start -->
<section class="divine2"><!-- divine3 start -->

<article>
<h2>Current Information</h2>

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
</colgroup>
<tbody>
<br><br>
<h6>Current Address</h6>
<br>
<tr>
    <th scope="row"><spring:message code="sal.text.addressDetail" /></th>
    <td colspan="3">
    ${orderDetail.installationInfo.instAddrDtl}
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.street" /></th>
    <td colspan="3">
    ${orderDetail.installationInfo.instStreet}
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sales.Area" /></th>
    <td colspan="3">
    ${orderDetail.installationInfo.instArea}
     </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.postCode" /></th>
   <td>
    ${orderDetail.installationInfo.instPostcode}
     </td>
    <th scope="row"><spring:message code="sal.text.city" /></th>
    <td>
    ${orderDetail.installationInfo.instCity}
     </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.state" /></th>
    <td>
    ${orderDetail.installationInfo.instState}
    </td>
    <th scope="row"><spring:message code="sal.text.country" /></th>
    <td>
    ${orderDetail.installationInfo.instCountry}
    </td>
</tr>
</tbody>


</table><!-- table end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
</colgroup>
<tbody>
<br><br>
<h6>Current Contact No.</h6>
<br>
<tr>
    <th scope="row"><spring:message code="sal.text.telM" /></th>
    <td>
    ${orderDetail.installationInfo.instCntTelM}
    </td>
    <th scope="row"><spring:message code="sal.text.telO" /></th>
     <td>
     ${orderDetail.installationInfo.instCntTelO}
     </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.telR" /></th>
    <td>
    ${orderDetail.installationInfo.instCntTelR}
    </td>
    <th></th>
    <td></td>
</tr>
</tbody>


</table><!-- table end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
</colgroup>
<tbody>
<br><br>
<h6>Current Email</h6>
<br>
<tr>
    <th scope="row"><spring:message code="sal.text.email" /></th>
    <td>
    ${orderDetail.installationInfo.instCntEmail}
    </td>
</tr>
</tbody>

</table><!-- table end -->
</article>


<article>
<input type="hidden" name="salesOrdId" id="salesOrdId" value="${requestInfo.salesOrdId}" />
<input type="hidden" name="cpeReqId" id="_cpeReqId" value="${requestInfo.ecpeReqId}" />
<input type="hidden" name="dscBrnchId" id="dscBrnchId" value="${requestInfo.brnchId}" />
<input type="hidden" name="custId" id="custId" value="${requestInfo.custId}" />
<input type="hidden" name="areaId" id="areaId" value="${requestInfo.areaId}" />
<input type="hidden" name="addrDtl" id="addrDtl" value="${requestInfo.addrDtl}" />
<input type="hidden" name="street" id="street" value="${requestInfo.street}" />
<input type="hidden" name="custNric" id="custNric" value="${orderDetail.installationInfo.instCntNric}" />
<input type="hidden" name="custName" id="custName" value="${orderDetail.installationInfo.instCntName}" />
<input type="hidden" name="contactTelM1" id="contactTelM1" value="${requestInfo.telM1}" />
<input type="hidden" name="contactTelO" id="contactTelO" value="${requestInfo.telO}" />
<input type="hidden" name="contactTelR" id="contactTelR" value="${requestInfo.telR}" />
<input type="hidden" name="contactTelf" id="contactTelf" value="${requestInfo.telF}" />
<input type="hidden" name="contactEmail" id="contactEmail" value="${requestInfo.email}" />
<input type="hidden" name="isMailing" id="isMailing" value="${requestInfo.isMailling}" />
<h3>Request Information</h3>

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
</colgroup>
<tbody>
<br>
<h6>Request</h6>
<br>
<tr>
   <th scope="row"><spring:message code="sal.title.text.requestDate" /></th>
    <td>
    ${requestInfo.crtDt}
    </td>
    <th scope="row"><spring:message code="service.grid.mainDept" /></th>
    <td>
    ${requestInfo.mainDept}
    </td>
</tr>
<tr>
   <th scope="row"><spring:message code="sales.reason" /></th>
    <td>
    ${requestInfo.reason}
    </td>
    <th scope="row"><spring:message code="sales.dscBranch" /></th>
    <td><input type="text" title="" id="dscBrnchName" name="dscBrnchName" value="${requestInfo.dscBranch}" disabled style="width:100px;"/><a href="#" id="dscBranch_search_btn"  class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.attachment" /></th>
    <td>
    <a href="javascript:void(0);"
       class="attachment-link"
       data-atchFileGrpId="${requestInfo.atchFileGrpId}"
       data-atchFileId="${requestInfo.atchFileId}"
       data-fileExtsn="${requestInfo.fileExtsn}"
       onclick="fn_AttachmentClick(this)">
        ${requestInfo.atchFileName}
    </a>
    </a>
    </td>
    <th scope="row">Requestor ID</th>
    <td>
    ${requestInfo.crtUserId}
    </td>
</tr>
</tbody>
</table><!-- table end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
</colgroup>
<tbody>
<br>
<h6>Change Address</h6>
<br>
<tr>
   <th scope="row">New Address</th>
   <td colspan="3">
   ${requestInfo.address}
   </td>
</tr>
<tr>
   <th scope="row">Mailing Address ?</th>
   <td><input id="isMailingTrue" name="isMailingTrue" type="checkbox" readonly />
   </td>
   <th></th>
   <td></td>
</tr>
</tbody>
</table><!-- table end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
</colgroup>
<tbody>
<br><br>
<h6>Change Contact No.</h6>
<br>
<tr>
    <th scope="row"><spring:message code="sal.text.telM" /></th>
    <td>
    ${requestInfo.telM1}
    </td>
    <th scope="row"><spring:message code="sal.text.telO" /></th>
     <td>
     ${requestInfo.telO}
     </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.telR" /></th>
    <td>
    ${requestInfo.telR}
    </td>
    <th scope="row"><spring:message code="sal.text.telF" /></th>
    <td>
    ${requestInfo.telF}
    </td>
</tr>
</tbody>


</table><!-- table end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
</colgroup>
<tbody>
<br>
<h6>Change Email</h6>
<br>
<tr>
   <th scope="row">New Email</th>
   <td>
   ${requestInfo.email}
   </td>
</tr>
</tbody>
</table><!-- table end -->
</article>


</section><!-- divine2 start -->

</section><!-- content end -->
</form>
</div>

<div id="popup_wrap_approve" class="popup_wrap msg_box" style="display: none;"><!-- popup_wrap start -->
<form id="form_approveReason">
<header class="pop_header"><!-- pop_header start -->
<h1>Approval of CPE</h1>
<p class="pop_close"><a href="#"><spring:message code="newWebInvoice.btn.close" /></a></p>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<p class="msg_txt">Are you sure you want to approve this CPE?</p>
<textarea cols="20" rows="5" id="apprvResn" name="apprvResn" maxlength="900"></textarea><span id="characterCount">0 of 900 max characters</span></p>
<ul class="center_btns">
    <li><p class="btn_blue2"><a href="#" id="confirm_btn_approve"><spring:message code="invoiceApprove.title" /></a></p></li>
    <li><p class="btn_blue2"><a href="#" id="cancel_btn_approve"><spring:message code="approvalWebInvoMsg.cancel" /></a></p></li>
</ul>
</section><!-- pop_body end -->
</form>
</div><!-- popup_wrap end -->

<div id="popup_wrap_reject" class="popup_wrap msg_box" style="display: none;"><!-- popup_wrap start -->
<form id="form_rejectReason">
<header class="pop_header"><!-- pop_header start -->
<h1>Rejection of CPE</h1>
<p class="pop_close"><a href="#"><spring:message code="newWebInvoice.btn.close" /></a></p>
</header><!-- pop_header end -->

<section class="pop_body" ><!-- pop_body start -->
<p class="msg_txt">Please indicate the reason for rejection:</p>
<textarea cols="20" rows="5" id="rejctResn" name="rejctResn" maxlength="900"></textarea><span id="characterCount">0 of 900 max characters</span></p>
<ul class="center_btns">
    <li><p class="btn_blue2"><a href="#" id="confirm_btn_reject"><spring:message code="pay.btn.reject" /></a></p></li>
    <li><p class="btn_blue2"><a href="#" id="cancel_btn_reject"><spring:message code="approvalWebInvoMsg.cancel" /></a></p></li>
</ul>
</section><!-- pop_body end -->
</form>
</div><!-- popup_wrap end -->