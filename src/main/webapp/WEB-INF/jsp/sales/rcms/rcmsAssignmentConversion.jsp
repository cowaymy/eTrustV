<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
var assignGrid;
var conversionBatchGrid;
var assignConvertItemId;

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

});

function createGrid(){

        var assignColLayout = [
              {dataField : "rcBatchId", headerText : "", width : 90  , visible:false   },
              {dataField : "rcBatchNo", headerText : '<spring:message code="sal.title.text.batchNo"/>', width : "7%"  , editable : false   },
              {dataField : "rcStus", headerText : '<spring:message code="sal.title.text.batchStus" />', width : "10%" , editable : false     },
              {dataField : "rcType", headerText : '<spring:message code="sales.title.text.uploadType" />', width : "13%" , editable       : false       },
              {dataField : "totalItem", headerText : '<spring:message code="sal.title.text.totItem" />', width : "10%" , editable       : false       },
              {dataField : "validItem", headerText : '<spring:message code="sal.text.totalValidItem" />', width : "15%" , editable       : false       },
              {dataField : "invalidItem", headerText : '<spring:message code="sal.text.totalInvalidItem" />', width : "15%" , editable       : false       },
              {dataField : "rcCrtUserName", headerText : '<spring:message code="sales.CreateBy" />', width : "10%" , editable       : false       },
              {dataField : "rcCrtDt", headerText : '<spring:message code="sales.CreateAt" />', width : "20%" , editable       : false        }
              ];

        var assignConvertItemColumnLayout= [
                                         {dataField : "salesOrdNo", headerText : "Order No.", width : "10%", editable : false},
                                         {dataField : "rcItmStus", headerText : "Status", width : '10%'},
                                         {dataField : "rcItmField", headerText : "Item", width : '10%'},
                                         {dataField : "rcItmRem", headerText : "Remark", width : '10%'},
                                         {dataField : "rcItmCnvrStus", headerText : "Conversion Status", width : '10%'},
                                         {dataField : "rcItmCnvrRem", headerText : "Conversion Remark", width : '10%'}
                                         ];


        var assignOptions = {
                   showStateColumn:false,
                   showRowNumColumn    : true,
                   usePaging : true,
                   editable : true,
                   headerHeight : 30
             };

        assignGrid = GridCommon.createAUIGrid("#assignGrid", assignColLayout, "", assignOptions);
        assignConvertItemId = GridCommon.createAUIGrid("#assignConvertItem_grid_wrap", assignConvertItemColumnLayout,"",assignOptions);

         // 셀 더블클릭 이벤트 바인딩
         AUIGrid.bind(assignGrid, "cellDoubleClick", function(event){
        	 var rcBatchId = AUIGrid.getCellValue(assignGrid, event.rowIndex, "rcBatchId");

        	 Common.ajax("GET", "/sales/rcms/selectAssignConversionItemList.", {"batchId":rcBatchId}, function(result) {
        		 AUIGrid.setGridData(assignConvertItemId, result);
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
    <li><p class="btn_blue"><a href="#"  id="btnUpload" onclick="javascript:fn_uploadPop();"></span><spring:message code="sal.title.text.uploadAssign" /></a></p></li>
    <li><p class="btn_blue"><a href="#" id="btnSave" onclick="javascript:fn_selectListAjax();"><span class="search"></span><spring:message code="sal.btn.search" /></a></p></li>
    <li><p class="btn_blue"><a href="#" id="btnClear" onclick="javascript:fn_clear();"><span class="clear"></span><spring:message code="sal.btn.clear" /></a></p></li>
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

    <%-- <aside class="link_btns_wrap"><!-- link_btns_wrap start -->
    <p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
    <dl class="link_list">
        <dt><spring:message code="sal.title.text.link" /></dt>
        <dd>
        <ul class="btns">
            <li><p class="link_btn"><a href="#" id="_custVALetterBtn"><spring:message code="sal.title.text.badaccRaw" /></a></p></li>
        </ul>
        <ul class="btns">
        </ul>
        <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
        </dd>
    </dl>
    </aside><!-- link_btns_wrap end --> --%>

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
<div class="popup_wrap" id="view_wrap" style="display: none;">
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
                    <aside class="title_line"><!-- title_line start -->
                    <header class="pop_header" id="pop_header">
                    <h3></h3>
                        <ul class="right_btns">
                            <li><p class="btn_blue2"><a href="javascript:fn_getItmStatus('')">All Items</a></p></li>
                            <li><p class="btn_blue2"><a href="javascript:fn_getItmStatus(4)">Valid Items</a></p></li>
                            <li><p class="btn_blue2"><a href="javascript:fn_getItmStatus(6)">Invalid Items</a></p></li>
                        </ul>
                     </header>

			<section class="search_result"><!-- search_result start -->
			<article class="grid_wrap" ><!-- grid_wrap start -->
			    <div id="assignConvertItem_grid_wrap" style="width: 100%; height: 360px; margin: 0px auto;"></div>
			</article><!-- grid_wrap end -->
			</section><!-- search_result end -->


    </section>
    <!-- pop_body end -->
</div>
<!-- popup_wrap end -->
