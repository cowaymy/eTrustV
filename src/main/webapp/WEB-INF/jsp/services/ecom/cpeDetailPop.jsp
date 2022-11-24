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

        cpeRespondGrid();

        $("#respondInfo").click(function() {
            var cpeReqId = $("#_cpeReqId").val();

            Common.ajax("GET", "/services/ecom/selectCpeDetailList.do?cpeReqId=" + cpeReqId + "", '',
                    function(result) {
                      AUIGrid.setGridData(gridID1, result);
                      AUIGrid.resize(gridID1, 900, 300);
                    });
         });

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

    fn_loadCpeDetailList();
    });

    function fn_loadCpeDetailList(){
    	 var cpeReqId = $("#_cpeReqId").val();

         Common.ajax("GET", "/services/ecom/selectCpeDetailList.do?cpeReqId=" + cpeReqId + "", '',
                 function(result) {
                   AUIGrid.setGridData(gridID1, result);
                   AUIGrid.resize(gridID1, 900, 300);
                 });
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





    function fn_pageBack() {
    	$("#view_wrap").remove();
    }

</script>

<div id="popup_wrap1" class="popup_wrap"><!-- popup_wrap start -->
<header class="pop_header"><!-- pop_header start -->
<h1>Cpe View Detail</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a id="_cpeResultPopCloseBtn"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->
<section class="pop_body"><!-- pop_body start -->

<section class="search_result" id="_searchResultSection" ><!-- search_result start -->

<section class="tap_wrap"><!-- tap_wrap start -->
<ul class="tap_type1">
    <li><a href="#" class="on" id="respondInfo"><spring:message code='service.title.respInfo'/></a></li>
</ul>
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