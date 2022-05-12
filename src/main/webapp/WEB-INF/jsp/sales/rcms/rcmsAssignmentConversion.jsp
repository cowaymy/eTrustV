<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
var assignGrid;
var conversionBatchGrid;
var assignConvertItemId;
var excelGrid;

//Grid에서 선택된 RowID
var selectedGridValue;

//ROS Call 화면에서 사용...
var gridPros = {

        usePaging           : true,         //페이징 사용
        pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)
        fixedColumnCount    : 1,
        showStateColumn     : false,
        displayTreeOpen     : false,
        selectionMode       : "singleRow",  //"multipleCells",
        headerHeight        : 30,
        useGroupingPanel    : false,        //그룹핑 패널 사용
        skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
        wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
        showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력
        noDataMessage       : "No Batch found.",
        groupingMessage     : "Here groupping"
};


$(document).ready(function(){

    doGetCombo('/common/selectCodeList.do', '418', '2' ,'rcmsUploadType', 'S' , '');

    createGrid();

    //엑셀 다운
    $('#excelDown').click(function() {
       GridCommon.exportTo("#excelGrid", 'xlsx', "RCMS Assignment Conversion List");
    });

    $("#rawDownload").click(function() {
        	if($("#crtDt").val()!= "") {
        	var crtDt = $("#crtDt").val();
            var arrCrtDt = crtDt.split("/");
            crtDt = arrCrtDt[2] + "/" + arrCrtDt[1] + "/" + arrCrtDt[0];

        	var date = new Date().getDate();
            if(date.toString().length == 1){
                date = "0" + date;
            }

            $("#form #V_DATE").val(crtDt);
            $("#form #reportDownFileName").val("RCMS Conversion Failed Raw_"+date+(new Date().getMonth()+1)+new Date().getFullYear());

            var option = {
                    isProcedure : true
            };

            Common.report("form", option);
        }else{
            Common.alert("Please select a date.");
        }
    });
});

function createGrid(){

        var assignColLayout = [
              {dataField : "rcBatchId", headerText : "", width : 90  , visible:false   },
              {dataField : "rcBatchNo", headerText : '<spring:message code="sal.title.text.batchNo"/>', width : "7%"  , editable : false   },
              {dataField : "rcStus", headerText : '<spring:message code="sal.title.text.batchStus" />', width : "10%" , editable : false     },
              {dataField : "rcType", headerText : '<spring:message code="sales.title.text.uploadType" />', width : "10%" , editable       : false       },
              {dataField : "agentTypeUpl", headerText : '<spring:message code="sales.AssignUploadType" />', width : "10%" , editable       : false       },
              {dataField : "totalItem", headerText : '<spring:message code="sal.title.text.totItem" />', width : "10%" , editable       : false       },
              {dataField : "validItem", headerText : '<spring:message code="sal.title.text.totalSuccess" />', width : "10%" , editable       : false       },
              {dataField : "invalidItem", headerText : '<spring:message code="sal.title.text.totalFail" />', width : "10%" , editable       : false       },
              {dataField : "rcCrtUserName", headerText : '<spring:message code="sales.CreateBy" />', width : "7%" , editable       : false       },
              {dataField : "rcCrtDt", headerText : '<spring:message code="sales.CreateAt" />', width : "13%" , editable       : false        },
              {dataField : "rcUpdDt", headerText : '<spring:message code="sal.title.text.confirmDate" />', width : "13%" , editable       : false        }
              ];

        var assignConvertItemColumnLayout= [
                                         {dataField : "salesOrdNo", headerText : "Order No.", width : "10%", editable : false},
                                         {dataField : "rcItmStus", headerText : "Status", width : '10%'},
                                         {dataField : "rcItmField", headerText : "eTR / Sensitve", width : '10%'},
                                         {dataField : "rcItmRem", headerText : "Remark", width : '20%'},
                                         {dataField : "rcItmAgentId", headerText : "Agent ID", width : '10%'},
                                         {dataField : "rcItmAgentGrpId", headerText : "Group ID", width : '10%'},
                                         {dataField : "rcItmRenStus", headerText : "Rental<br/>Status", width : '10%'},
                                         {dataField : "stusName", headerText : "Conversion<br/>Status", width : '10%'},
                                         {dataField : "rcItmCnvrRem", headerText : "Conversion Remark", width : '20%'}
                                         ];

        var excelColLayout= [
                                            {dataField : "salesOrdNo", headerText : "Order No.", width : 200, editable : false},
                                            {dataField : "rcItmStus", headerText : "Status", width : 100},
                                            {dataField : "rcItmField", headerText : "eTR / Sensitve", width : 100},
                                            {dataField : "rcItmRem", headerText : "Remark", width : 400},
                                            {dataField : "rcItmAgentId", headerText : "Agent ID", width : 200},
                                            {dataField : "rcItmAgentGrpId", headerText : "Group ID", width :200},
                                            {dataField : "rcItmRenStus", headerText : "Rental Status", width : 100},
                                            {dataField : "stusName", headerText : "Conversion Status", width : 100},
                                            {dataField : "rcItmCnvrRem", headerText : "Conversion Remark", width : 400}
                                            ];


        var assignOptions = {
                   showStateColumn:false,
                   showRowNumColumn    : true,
                   usePaging : true,
                   editable : true,
                   headerHeight : 30
             };

        assignGrid = GridCommon.createAUIGrid("#assignGrid", assignColLayout, "", assignOptions);
        assignConvertItemId = GridCommon.createAUIGrid("#assignConvertItem_grid_wrap", assignConvertItemColumnLayout,"","");
        excelGrid = GridCommon.createAUIGrid("#excelGrid", excelColLayout, "", assignOptions);

        // Master Grid 셀 클릭시 이벤트
        AUIGrid.bind(assignGrid, "cellClick", function( event ){
            selectedGridValue = event.rowIndex;
        });

         // 셀 더블클릭 이벤트 바인딩
         AUIGrid.bind(assignGrid, "cellDoubleClick", function(event){
        	 var rcBatchId = AUIGrid.getCellValue(assignGrid, event.rowIndex, "rcBatchId");

        	 Common.ajax("GET", "/sales/rcms/selectAssignConversionItemList.", {"batchId":rcBatchId}, function(result) {
        		 AUIGrid.setGridData(assignConvertItemId, result);
        		 AUIGrid.setGridData(excelGrid, result);
        		 AUIGrid.resize(assignConvertItemId,945, $(".grid_wrap").innerHeight());
                 $("#view_wrap").show();
        	 });
         });

}


 //리스트 조회.
function fn_selectListAjax() {

    Common.ajax("GET", "/sales/rcms/selectAssignConversionList", $("#searchForm").serialize(), function(result) {
      AUIGrid.setGridData(assignGrid, result);
  });

}

function fn_clear(){
    $("#searchForm")[0].reset();
}

function fn_uploadPop(){
    Common.popupDiv("/sales/rcms/uploadAssignAgentPop.do",null, fn_selectListAjax, true, "uploadAssignAgentPop");
}

function fn_getItmStatus(val){
    var batchId = AUIGrid.getCellValue(assignGrid, selectedGridValue, "rcBatchId");

    if(val == "4"){$('#pop_header h3').text('APPROVED TRANSACTION');}
    else if(val == "21"){$('#pop_header h3').text('FAILED TRANSACTIONS');}
    else{$('#pop_header h3').text('ALL TRANSACTIONS');}

    Common.ajax("GET", "/sales/rcms/selectAssignConversionItemList", {"batchId":batchId,"stusId":val}, function(result) {
        AUIGrid.setGridData(assignConvertItemId, result);
        AUIGrid.setGridData(excelGrid, result);
    });
}

function fn_report(){
	$("#report_wrap").show();
}

//Layer close
hideViewPopup=function(val){
    $(val).hide();
}

</script>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Sales</li>
    <li>Customer</li>
    <li>Customer</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2><spring:message code="sal.title.text.rcmsAssignConvert" /></h2>

<ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
    <li><p class="btn_blue"><a href="#"  id="btnUpload" onclick="javascript:fn_uploadPop();"></span><spring:message code="sal.title.text.uploadAssign" /></a></p></li>
    </c:if>
    <c:if test="${PAGE_AUTH.funcView == 'Y'}">
    <li><p class="btn_blue"><a href="#" id="btnSave" onclick="javascript:fn_selectListAjax();"><span class="search"></span><spring:message code="sal.btn.search" /></a></p></li>
    <li><p class="btn_blue"><a href="#" id="btnClear" onclick="javascript:fn_clear();"><span class="clear"></span><spring:message code="sal.btn.clear" /></a></p></li>
    </c:if>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form id="editForm" name="editForm" action="#" method="post">
    <input type="hidden" id="orderNo" name="orderNo" />
    <input type="hidden" id="salesOrdId" name="salesOrdId" />
</form>
    <form id="searchForm" name="searchForm" action="#" method="post">
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
        <th scope="row"><spring:message code="sal.title.text.batchId" /></th>
           <td><input type="text" title="" placeholder="Conversion Batch Id" class="w100p" id="batchId" name="batchId" /></td>
	    <th scope="row"><spring:message code="sales.SelectRCMSUploadType" /><span class="must">*</span></th>
	       <td><select class="" name="rcmsUploadType" id="rcmsUploadType"></select></td>
	    <th scope="row"><spring:message code="sal.title.text.batchStus" /></th>
           <td>
                <select class="multy_select w100p" id="cmbBatchStatus" name="cmbBatchStatus" multiple="multiple">
                    <option value="1" selected><spring:message code="sal.combo.text.active" /></option>
                    <option value="4"><spring:message code="sal.combo.text.compl" /></option>
                    <option value="8"><spring:message code="sal.combo.text.inactive" /></option>
                </select>
           </td>
    </tr>
    <tr>
        <th scope="row"><spring:message code="sal.text.creator" /></th>
            <td>
                <input type="text" title="" id="crtUserName" name="crtUserName" placeholder="Conversion (Username)" class="w100p" />
            </td>
        <th scope="row"><spring:message code="sal.text.createDate" /></th>
           <td>
                <div class="date_set w100p"><!-- date_set start -->
                <p><input type="text" id="createStDate" name="createStDate" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
                <span>To</span>
                <p><input type="text" id="createEnDate" name="createEnDate" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
                </div><!-- date_set end -->
           </td>
         <td colspan = 2>
    </tr>
    </tbody>
    </table><!-- table end -->

    <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
    <aside class="link_btns_wrap"><!-- link_btns_wrap start -->
    <p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
    <dl class="link_list">
        <dt><spring:message code="sal.title.text.link" /></dt>
        <dd>
        <ul class="btns">
            <li><p class="link_btn"><a href="javascript:fn_report();" id="_custVALetterBtn"><spring:message code="sal.title.text.rcmsCnvrFailRaw" /></a></p></li>
        </ul>
        <ul class="btns">
        </ul>
        <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
        </dd>
    </dl>
    </aside><!-- link_btns_wrap end -->
    </c:if>

    </form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->
<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="assignGrid" style="width:100%; height:300px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->
</section><!-- search_result end -->
</section><!-- content end -->

<!-------------------------------------------------------------------------------------
    POP-UP (VIEW CONVERSION)
-------------------------------------------------------------------------------------->
<!-- popup_wrap start -->
<div class="popup_wrap" id="view_wrap" style="display:none">
    <!-- pop_header start -->
    <header class="pop_header" id="pop_header">
        <h1><spring:message code="sal.text.title.rcmsConvertItm"/></h1>
        <ul class="right_opt">
            <li><p class="btn_blue2">
                    <a href="#" onclick="hideViewPopup('#view_wrap')">CLOSE</a>
                </p></li>
        </ul>
    </header>
    <!-- pop_header end -->

    <!-- pop_body start -->
    <section class="pop_body">
    <h3></h3>
                    <header class="pop_header" id="pop_header">
                        <ul class="right_btns">
                            <li><p class="btn_blue2"><a href="javascript:fn_getItmStatus('')">All Items</a></p></li>
                            <li><p class="btn_blue2"><a href="javascript:fn_getItmStatus(4)">Valid Items</a></p></li>
                            <li><p class="btn_blue2"><a href="javascript:fn_getItmStatus(21)">Invalid Items</a></p></li>
                        </ul>
                     </header>

			<section class="search_result"><!-- search_result start -->
			<ul class="right_btns mt10">
			     <li><p class="btn_grid"><a href="#" id="excelDown"><spring:message code="sal.title.text.download" /></a></p></li>
			</ul>
			<article class="grid_wrap" ><!-- grid_wrap start -->
			    <div id="assignConvertItem_grid_wrap" style="width: 100%; height: 360px; margin: 0px auto;"></div>
			    <div id="excelGrid" style="width:100%; height:300px; margin:0 auto; display: none" ></div>
			</article><!-- grid_wrap end -->
			</section><!-- search_result end -->


    </section>
    <!-- pop_body end -->
</div>
<!-- popup_wrap end -->

<!-------------------------------------------------------------------------------------
    POP-UP (RAW DATA)
-------------------------------------------------------------------------------------->
<!-- popup_wrap start -->
<div class="popup_wrap size_small" id="report_wrap" style="display:none">
    <!-- pop_header start -->
    <header class="pop_header" id="pop_header">
        <h1><spring:message code="sal.title.text.rcmsCnvrFailRaw"/></h1>
        <ul class="right_opt">
            <li><p class="btn_blue2">
                    <a href="#" onclick="hideViewPopup('#report_wrap')">CLOSE</a>
                </p></li>
        </ul>
    </header>
    <!-- pop_header end -->

    <!-- pop_body start -->
    <form action="#" method="post" id="form" name="form">
    <section class="pop_body">
    <h3></h3>

                <input type="hidden" id="reportFileName" name="reportFileName" value="/sales/RCMS_ConvertFail.rpt" />
                <input type="hidden" id="viewType" name="viewType" value="EXCEL" />
                <input type="hidden" id="reportDownFileName" name="reportDownFileName" value="" />
                <input type="hidden" id="V_DATE" name="V_DATE" value="" />
    <table class="type1"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:180px" />
        <col style="width:*" />
    </colgroup>
    <tbody>
    <tr>
            <th scope="row">Convertion Create Date</th>
            <td>
            <div class="date_set w100p"><!-- date_set start -->
                <p><input id="crtDt" name="crtDt" type="text" value="" title="Start Date" placeholder="DD/MM/YYYY" class="j_date w100p" required/></p>
            </div><!-- date_set end -->
        </td>
    </tbody>
    </table>

            <section class="search_result"><!-- search_result start -->
            <ul class="center_btns">
                 <li><p class="btn_blue"><a href="#" id="rawDownload"><spring:message code="sal.title.text.download" /></a></p></li>
            </ul>
            </section><!-- search_result end -->
    </form>
    </section>
    <!-- pop_body end -->
</div>
<!-- popup_wrap end -->
