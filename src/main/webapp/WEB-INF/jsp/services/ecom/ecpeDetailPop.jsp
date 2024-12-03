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

        $("#historyInfo").click(function() {
            var cpeReqId = $("#_cpeReqId").val();

            Common.ajax("GET", "/services/ecom/selectEcpeHistoryList.do?cpeReqId=" + cpeReqId + "", '',
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

    fn_checkMailingStatus();

    $("#isMailing").on('click', function(event) {
        event.preventDefault(); // Prevent the default action (checking/unchecking)
    });
    });

    function fn_loadCpeDetailList(){
    	 var cpeReqId = $("#_cpeReqId").val();

         Common.ajax("GET", "/services/ecom/selectEcpeHistoryList.do?cpeReqId=" + cpeReqId + "", '',
                 function(result) {
                   AUIGrid.setGridData(gridID1, result);
                   AUIGrid.resize(gridID1, 900, 300);
                 });
    }


    function cpeRespondGrid() {

        var columnLayout1 = [{
          dataField : "ecpeReqId",
          visible : false
        },{
            dataField : "createdBy",
            headerText : "Requestor Name",
            width : '20%'
         },{
          dataField : "orgCode",
          headerText : "Org Code",
          width : '12%'
        },{
            dataField : "crtDt",
            headerText : "Request Date",
            dataType : "date",
            width : '12%'
         },{
          dataField : "approvedBy",
          headerText : "Approval By",
          width : '12%'
        },{
            dataField : "oldDscBranch",
            headerText : "From Dsc Branch",
            width : '12%'
          },{
          dataField : "dscBranch",
          headerText : "To Dsc Branch",
          width : '12%'
        }, {
            dataField : "status",
            headerText : "Status",
            width : '10%'
        },{
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

                            Common.ajax("GET", "/eAccounting/webInvoice/getAttachmentInfo.do", data, function(result) {
                                console.log(result);
                                var fileSubPath = result.fileSubPath;
                                fileSubPath = fileSubPath.replace('\', '/'');
                                console.log("asdasdasd3");
                                console.log("/file/fileDownWeb.do?subPath=" + fileSubPath
                                        + "&fileName=" + result.physiclFileName + "&orignlFileNm=" + result.atchFileName);
                                window.open("/file/fileDownWeb.do?subPath=" + fileSubPath
                                    + "&fileName=" + result.physiclFileName + "&orignlFileNm=" + result.atchFileName);
                            });

                	} else {
                		//do nothing
                	}
                }
            }
        }
        ,{
            dataField : "lastUpdateBy",
            headerText : "Update By",
            width : '12%'
          }
//         ,{
//               dataField : "lastUpdateDate",
//               headerText : "Last Update Date",
//               dataType : "date",
//               width : '12%'
//             }
          ,{
        	dataField : "approvalDate",
            headerText : "Approval Date",
            dataType : "date",
            width : '15%'
          },{
              dataField : "approvalRemark",
              headerText : "remark",
              width : '25%'
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

        gridID1 = GridCommon.createAUIGrid("history_grid_wrap", columnLayout1, "", gridPros1);

      }

    function fn_pageBack() {
    	$("#view_wrap").remove();
    }

    function fn_checkMailingStatus() {
        if ("${requestInfo.isMailling}" === "1") {
            $("#isMailing").prop("checked", true);  // Replace #mailCheckbox with the actual checkbox ID
        } else {
            $("#isMailing").prop("checked", false); // Replace #mailCheckbox with the actual checkbox ID
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

<aside class="title_line"><!-- title_line start -->
<h3><spring:message code="cpe.title.helpdeskRequest" /></h3>
</aside><!-- title_line end -->
<form id="form_updReqst">
<input type="hidden" name="cpeReqId" id="_cpeReqId" value="${requestInfo.ecpeReqId}" />

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
    <th scope="row"><spring:message code="sal.text.requestDate" /></th>
    <td>${requestInfo.crtDt}</td>
    <th scope="row">Main Department</th>
    <td colspan="3">${requestInfo.mainDept}</td>
</tr>
<tr>
    <th scope="row">Reason</th>
    <td>${requestInfo.reason}</td>
    <th scope="row">DSC Branch</th>
    <td colspan="3">${requestInfo.dscBranch}</td>
</tr>
<tr>
    <th scope="row">Attachment</th>
    <td>
    <a href="javascript:void(0);"
       class="attachment-link"
       data-atchFileGrpId="${requestInfo.atchFileGrpId}"
       data-atchFileId="${requestInfo.atchFileId}"
       data-fileExtsn="${requestInfo.fileExtsn}"
       onclick="fn_AttachmentClick(this)">
        ${requestInfo.atchFileName}
    </a>
    </td>
    <th scope="row">Requestor ID</th>
    <td colspan="3">${requestInfo.crtUserId}</td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h3>Change Address</h3>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:25px" />
    <col style="width:140px" />
</colgroup>
<tbody>
<tr>
    <th scope="row">New Address</th>
    <td>${requestInfo.address}</td>
</tr>
<tr>
    <th scope="row">Mailing Address ?</th>
    <td><input id="isMailing" name="isMailing" type="checkbox" readonly /></td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h3>Change Contact No.</h3>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:260px" />
    <col style="width:160px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">New Tel (Mobile)</th>
    <td>${requestInfo.telM1}</td>
    <th scope="row">New Tel (Residence)</th>
     <td>${requestInfo.teloR}</td>
</tr>
<tr>
    <th scope="row">New Tel (Office)</th>
    <td>${requestInfo.telO}</td>
    <th scope="row">New Tel (Fax)</th>
     <td>${requestInfo.teloF}</td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h3>Change Email</h3>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:25px" />
    <col style="width:140px" />
</colgroup>
<tbody>
<tr>
    <th scope="row">New Email</th>
    <td>${requestInfo.email}</td>
</tr>

</tbody>
</table><!-- table end -->

</form>

</section><!-- search_result end -->

<section class="tap_wrap"><!-- tap_wrap start -->
<ul class="tap_type1">
    <li><a href="#" class="on" id="historyInfo">CPE View Hisotry</a></li>
</ul>
   <!-- Respond Info Start -->
   <article class="tap_area">
    <!-- tap_area start -->

    <!-- title_line end -->
    <article class="grid_wrap">
     <!-- grid_wrap start -->
     <div id="history_grid_wrap"
      style="width: 100%; height: 300px; margin: 0"></div>
    </article>
    <!-- grid_wrap end -->
   </article>
  </section><!-- tap_wrap end -->

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