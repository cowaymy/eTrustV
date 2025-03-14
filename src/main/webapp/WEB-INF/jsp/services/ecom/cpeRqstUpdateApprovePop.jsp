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

    	if(funcChange == 'Y'){
    		$("#updateButt").show();
    		$("#updateTable").show();
    		$("#updateTitle").show();
    	}
        fn_setAutoFile2();
		//Set Default Main Department
		$("#_inputMainDeptSelect").val('MD20');
        doGetCombo('/services/ecom/selectSubDept.do',  $("#_inputMainDeptSelect").val(), 'SD299','_inputSubDeptSelect', 'S' ,  '');
        //Populate Sub Department in-charge
        $("#_inputMainDeptSelect").change(function(){
            doGetCombo('/services/ecom/selectSubDept.do',  $("#_inputMainDeptSelect").val(), '','_inputSubDeptSelect', 'S' ,  '');
        });

        cpeRespondGrid();

        $("#respondInfo").click(function() {
            var cpeReqId = $("#_cpeReqId").val();

            Common.ajax("GET", "/services/ecom/selectCpeDetailList.do?cpeReqId=" + cpeReqId + "", '',
                    function(result) {
                      AUIGrid.setGridData(gridID1, result);
                      AUIGrid.resize(gridID1, 900, 300);
                    });
         });

        $("#saveBtn").click(function() {
            if (fn_checkEmptyFields()) {
                fn_updateCpeStatus();
            }
        });

        $("#saveBtn1").click(function() {

        	fn_openDivPop("VIEW");

        });

        //file Delete
        $("#btnfileDel").click(function() {
            $("#reqAttchFile").val('');
            $(".input_text").val('');
            console.log("fileDel complete.");
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

    cpeHistoryDetailsId = GridCommon.createAUIGrid("#cpeHistoryDetails_grid_wrap", cpeHistoryDetailsColumnLayout,null,gridProse);
    AUIGrid.resize(cpeHistoryDetailsId,945, $(".grid_wrap").innerHeight());
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

    function cpeRespondGrid() {

        var columnLayout1 = [{
          dataField : "cpeReqId",
          visible : false
        }, {
          dataField : "reqDtlId",
          visible : false
        }, {
          dataField : "mainDept",
          headerText : "Main Department",
          width : '10%'
        }, {
          dataField : "subDept",
          headerText : "Sub Department",
          width : '10%'
        },{
          dataField : "remark",
          headerText : "Remark",
          width : '40%'
        }, {
          dataField : "createdBy",
          headerText : "Created By",
          width : '20%'
        }, {
          dataField : "status",
          headerText : "Status",
          width : '10%'
        }, {
          dataField : "crtDt",
          headerText : "Date",
          dataType : "date",
          width : '10%'
        }, {
          dataField : "atchFileGrpId",
          visible : false // Color 칼럼은 숨긴채 출력시킴
        }, {
          dataField : "atchFileId",
          visible : false // Color 칼럼은 숨긴채 출력시킴
        }, {
          dataField : "atchFileName",
          headerText : '<spring:message code="newWebInvoice.attachment" />',
          width : 200,
          labelFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
                var myString = value;
                // 로직 처리
                // 여기서 value 를 원하는 형태로 재가공 또는 포매팅하여 반환하십시오.
                if(FormUtil.isEmpty(myString)) {
                    myString = '<spring:message code="invoiceApprove.noAtch.msg" />';
                }
                return myString;
             },
            renderer : {
                type : "ButtonRenderer",
                onclick : function(rowIndex, columnIndex, value, item) {
                	console.log("value :" + value);
                	if (!(value == undefined || value == "" || value == null)) {
                    console.log("view_btn click atchFileGrpId : " + item.atchFileGrpId + " atchFileId : " + item.atchFileId);
                            var data = {
                                    atchFileGrpId : item.atchFileGrpId,
                                    atchFileId : item.atchFileId
                            };
                            if(item.fileExtsn == "jpg" || item.fileExtsn == "png" || item.fileExtsn == "gif") {
                                // TODO View
                                console.log(data);
                                Common.ajax("GET", "/eAccounting/webInvoice/getAttachmentInfo.do", data, function(result) {
                                    console.log(result);
                                    var fileSubPath = result.fileSubPath;
                                    fileSubPath = fileSubPath.replace('\', '/'');
                                    console.log(DEFAULT_RESOURCE_FILE + fileSubPath + '/' + result.physiclFileName);
                                    window.open(DEFAULT_RESOURCE_FILE + fileSubPath + '/' + result.physiclFileName);
                                });
                            } else {
                                Common.ajax("GET", "/eAccounting/webInvoice/getAttachmentInfo.do", data, function(result) {
                                    console.log(result);
                                    var fileSubPath = result.fileSubPath;
                                    fileSubPath = fileSubPath.replace('\', '/'');
                                    console.log("/file/fileDownWeb.do?subPath=" + fileSubPath
                                            + "&fileName=" + result.physiclFileName + "&orignlFileNm=" + result.atchFileName);
                                    window.open("/file/fileDownWeb.do?subPath=" + fileSubPath
                                        + "&fileName=" + result.physiclFileName + "&orignlFileNm=" + result.atchFileName);
                                });
                            }
                	} else {
                		//do nothing
                	}
                }
            }
        }];

        var gridPros1 = {
          pageRowCount : 20,
          showStateColumn : false,
          displayTreeOpen : false,
          //selectionMode : "singleRow",
          skipReadonlyColumns : true,
          wrapSelectionMove : true,
          showRowNumColumn : true,
          editable : false,
          wordWrap : true
        };

        gridID1 = GridCommon.createAUIGrid("respond_grid_wrap", columnLayout1, "", gridPros1);

      }

    function fn_updateCpeStatus() {

        var formData = Common.getFormData("form_updReqst");
        var obj = $("#form_updReqst").serializeJSON();

        $.each(obj, function(key, value) {
          formData.append(key, value);
        });

        Common.ajaxFile("/services/ecom/updateCpeStatus.do", formData, function(result) {
            console.log(result);
            Common.alert('<spring:message code="cpe.update.msg" />', fn_closePopRefreshSearch);
        });
    }

    function fn_closePopRefreshSearch() {
    	$("#cpeRqstUpdateApprovePop").remove();
    	fn_search();
    }

  //View Claim Pop-UP
    function fn_openDivPop(val){
        if(val == "VIEW"){

        	 var formData = Common.getFormData("form_updReqst");
             var obj = $("#form_updReqst").serializeJSON();

                    Common.ajax("GET","/services/ecom/selectCpeHistoryDetailPop.do", obj, function(result){
                        AUIGrid.setGridData(cpeHistoryDetailsId, result);
                        AUIGrid.resize(cpeHistoryDetailsId,945, $(".grid_wrap").innerHeight());
                    });
                    $("#view_wrap").show();


        }else{ $("#view_wrap").hide();}
    }


    function fn_pageBack() {
    $("#view_wrap").remove();
    }

</script>

<div id="popup_wrap1" class="popup_wrap"><!-- popup_wrap start -->
<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="cpe.update.title.text" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a id="_cpeResultPopCloseBtn"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->
<section class="pop_body"><!-- pop_body start -->

<section class="search_result" id="_searchResultSection" ><!-- search_result start -->

<section class="tap_wrap"><!-- tap_wrap start -->
<ul class="tap_type1">
    <li><a href="#" class="on"><spring:message code="sal.tap.title.ordInfo" /></a></li>
    <li><a href="#" id="respondInfo"><spring:message code='service.title.respInfo'/></a></li>
</ul>

<article class="tap_area"><!-- tap_area start --><!--###################################  -->

<section class="tap_wrap mt0"><!-- tap_wrap start -->
<ul class="tap_type1 num4">
    <li><a href="#" class="on"><spring:message code="sal.tap.title.basicInfo" /></a></li>
    <li><a href="#"><spring:message code="sal.title.text.hpCody" /></a></li>
    <li><a id="aTabCI" href="#" onClick="javascript:chgGridTab('custInfo');"><spring:message code="sal.title.text.custInfo" /></a></li>
    <li><a href="#"><spring:message code="sal.title.text.installInfo" /></a></li>
    <li><a id="aTabMA" href="#"><spring:message code="sal.title.text.maillingInfo" /></a></li>
<c:if test="${orderDetail.basicInfo.appTypeCode == 'REN'}">
    <li><a href="#"><spring:message code="sal.title.text.paymentChnnl" /></a></li>
</c:if>
    <li><a id="aTabMI" href="#" onClick="javascript:chgGridTab('memInfo');"><spring:message code="sal.title.text.memshipInfo" /></a></li>
    <li><a href="#" onClick="javascript:chgGridTab('docInfo');"><spring:message code="sal.title.text.docuSubmission" /></a></li>
    <li><a href="#" onClick="javascript:chgGridTab('callLogInfo');"><spring:message code="sal.title.text.callLog" /></a></li>
<c:if test="${orderDetail.basicInfo.appTypeCode == 'REN' && orderDetail.basicInfo.rentChkId == '122'}">
    <li><a href="#"><spring:message code="sal.title.text.quaranteeInfo" /></a></li>
</c:if>
    <li><a href="#" onClick="javascript:chgGridTab('payInfo');"><spring:message code="sal.title.text.paymentListing" /></a></li>
    <li><a href="#" onClick="javascript:chgGridTab('transInfo');"><spring:message code="sal.title.text.lastSixMonthTrnsaction" /></a></li>
    <li><a href="#"><spring:message code="sal.title.text.ordConfiguration" /></a></li>
    <li><a href="#" onClick="javascript:chgGridTab('autoDebitInfo');"><spring:message code="sal.title.text.autoDebitResult" /></a></li>
    <li><a href="#"><spring:message code="sal.title.text.reliefCertificate" /></a></li>
    <li><a href="#" onClick="javascript:chgGridTab('discountInfo');"><spring:message code="sal.title.text.discount" /></a></li>
</ul>

<!------------------------------------------------------------------------------
    Basic Info
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/basicInfo.jsp" %>
<!------------------------------------------------------------------------------
    HP / Cody
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/hpCody.jsp" %>
<!------------------------------------------------------------------------------
    Customer Info
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/custInfo.jsp" %>
<!------------------------------------------------------------------------------
    Installation Info
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/installInfo.jsp" %>
<!------------------------------------------------------------------------------
    Mailling Info
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/mailInfo.jsp" %>
<!------------------------------------------------------------------------------
    Payment Channel
------------------------------------------------------------------------------->
<c:if test="${orderDetail.basicInfo.appTypeCode == 'REN'}">
<%@ include file="/WEB-INF/jsp/sales/order/include/payChannel.jsp" %>
</c:if>
<!------------------------------------------------------------------------------
    Membership Info
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/membershipInfo.jsp" %>
<!------------------------------------------------------------------------------
    Document Submission
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/docSubmission.jsp" %>
<!------------------------------------------------------------------------------
    Call Log
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/callLog.jsp" %>
<!------------------------------------------------------------------------------
    Quarantee Info
------------------------------------------------------------------------------->
<c:if test="${orderDetail.basicInfo.appTypeCode == 'REN' && orderDetail.basicInfo.rentChkId == '122'}">
<%@ include file="/WEB-INF/jsp/sales/order/include/qrntInfo.jsp" %>
</c:if>
<!------------------------------------------------------------------------------
    Payment Listing
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/payList.jsp" %>
<!------------------------------------------------------------------------------
    Last 6 Months Transaction
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/last6Month.jsp" %>
<!------------------------------------------------------------------------------
    Order Configuration
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/orderConfig.jsp" %>
<!------------------------------------------------------------------------------
    Auto Debit Result
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/autoDebit.jsp" %>
<!------------------------------------------------------------------------------
    Relief Certificate
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/rliefCrtfcat.jsp" %>
<!------------------------------------------------------------------------------
    Discount
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/discountList.jsp" %>

</section><!-- tap_wrap end -->

</article><!-- tap_area end --><!--###################################  -->

   <!-- Respond Info Start -->
   <article class="tap_area">
    <!-- tap_area start -->
    <aside class="title_line">
     <!-- title_line start -->
     <h3><spring:message code='service.title.respInfo'/></h3>
    </aside>
    <!-- title_line end -->
    <article class="grid_wrap">
     <!-- grid_wrap start -->
     <div id="respond_grid_wrap"
      style="width: 100%; height: 300px; margin: 0"></div>
    </article>
    <!-- grid_wrap end -->
   </article>
  </section><!-- tap_wrap end -->


<aside class="title_line"><!-- title_line start -->
<h3><spring:message code="cpe.title.helpdeskRequest" /></h3>
</aside><!-- title_line end -->
<form id="form_updReqst">
<input type="hidden" name="salesOrdId" id="_salesOrdId" value="${orderDetail.basicInfo.ordId}" />
<input type="hidden" name="ordStusId" id="_ordStusId" value="${orderDetail.basicInfo.ordStusId}" />
<input type="hidden" name="salesOrdNo" id="_salesOrdNo" value="${orderDetail.basicInfo.ordNo}" />
<input type="hidden" name="custId" id="_custId" value="${orderDetail.basicInfo.custId}" />
<input type="hidden" name="cpeReqId" id="_cpeReqId" value="${requestInfo.cpeReqId}" />
<input type="hidden" name="approvalRequired" id="_approvalRequired" value="${requestInfo.appvReqrd}" />
<input type="hidden" name="requestorEmail" id="_requestorEmail" value="${requestInfo.requestorEmail}" />
<input type="hidden" name="cpeType" id="_cpeType" value="${requestInfo.cpeType}" />

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:260px" />
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:140px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Request ID</th>
    <td>${requestInfo.cpeReqId}</td>
    <th scope="row">Approver List</th>
    <td colspan="3">${approverList}</td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.requestDate" /></th>
    <td>${requestInfo.crtDt}</td>
    <th scope="row">Requestor</th>
    <td colspan="3">${requestInfo.createdBy}</td>
</tr>
<tr>
    <th scope="row"><spring:message code="log.label.rqstTyp" /></th>
    <td>${requestInfo.cpeType}</td>
    <th scope="row">Request Sub Type</th>
    <td colspan="3">${requestInfo.cpeSubtype}</td>
</tr>
<tr>
    <th scope="row">Remark</th>
    <td colspan="5">${requestInfo.remark}</td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line" style="display:none" id="updateTitle"><!-- title_line start -->
<h3>Add Response</h3>
</aside><!-- title_line end -->
<table class="type1" style="display:none" id="updateTable"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:260px" />
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:140px" />
    <col style="width:*" />
</colgroup>
<tbody>
      <tr>
       <th scope="row"><spring:message code="service.grid.mainDept" /><span class='must'>*</span></th>
       <td>
        <select class="w100p" name="mainDept" id="_inputMainDeptSelect">
            <option value="">Choose One</option>
            <c:forEach var="list" items="${mainDeptList}" varStatus="status">
                <option value="${list.codeId}">${list.codeName} </option>
            </c:forEach>
        </select></td>
       <th scope="row"><spring:message code="service.grid.subDept" /><span class="must">*</span></th>
       <td colspan="4"><select class="w100p" name="subDept" id="_inputSubDeptSelect"></select></td>
       </tr>
    <tr>
    <th scope="row">Status<span class='must'>*</span></th>
    <td><select class="w100p" id="status" name="status">
         <option value="" selected><spring:message code='sal.combo.text.chooseOne'/></option>
         <c:forEach var="list" items="${cpeStat}" varStatus="status">
           <option value="${list.code}">${list.codeName}</option>
          </c:forEach>

         <!-- <option value="1">Active</option>
         <option value="5">Approved</option>
         <option value="6">Rejected</option>
         <option value="44">Pending</option>
         <option value="34">Solve</option>
         <option value="35">Not yet to solve</option>
         <option value="36">Close</option>
         <option value="10">Cancel</option> -->

    </select></td>
    <th scope="row"></th>
    <td colspan="4"></td>
</tr>
<tr>
    <th scope="row"><spring:message code='cpe.attachment' /></th>
        <td>
            <div class="auto_file2">
            <!-- auto_file2 start -->
                <input id="reqAttchFile" name="reqAttchFile" type="file" title="file add" />
             </div><!-- auto_file2 end -->
         </td>
</tr>
<tr>
    <th scope="row">Remark</th>
    <td colspan="6"><textarea cols="20" rows="5" name="inputRemark" id="_inputRemark"></textarea></td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="javascript:fn_openDivPop('VIEW');">View History</a></p></li>
    <li id="updateButt" style="display:none"><p class="btn_blue2 big"><a href="#" id="saveBtn">Save</a></p></li>
</ul>

</form>

</section><!-- search_result end -->


</section><!-- content end -->

</div>
<!-- popup_wrap start -->
<div class="popup_wrap" id="view_wrap" style="display: none;">
    <!-- pop_header start -->
    <header class="pop_header" id="pop_header">
        <h1>Details</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2">
                    <a href="#" onclick="javascript:fn_pageBack();">CLOSE</a>
                </p></li>
                  <!-- search_result start -->

                <!-- grid_wrap start -->
        </ul>
    </header>
<section class="pop_body"><!-- pop_body start -->
    <article class="grid_wrap"><!-- grid_wrap start -->
    <div id="cpeHistoryDetails_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->


     </section><!-- pop_body end -->
    <!-- pop_header end -->
</div>
<!-- popup_wrap end -->