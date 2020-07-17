<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript">

//AUIGrid 그리드 객체
var myGridID,fileItemID;
var fileId;
var selectedGridValue;

$(document).ready(function(){
    var gridPros = {
            editable : false,
            showStateColumn : false,
            softRemoveRowMode:false
    };

    myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,null,gridPros);
    fileItemID = GridCommon.createAUIGrid("fileItem_grid_wrap", detailsColumnLayout,null,gridPros);
    AUIGrid.resize(fileItemID,945, $(".grid_wrap").innerHeight());

    AUIGrid.bind(myGridID, "cellClick", function( event ){
        selectedGridValue = event.rowIndex;
        fileId = event.item.fileId;
    });

    $('#excelDown').click(function() {
        GridCommon.exportTo("fileItem_grid_wrap", 'xlsx', "JomPAY_" + fileId);
     });
});

var columnLayout = [
    { dataField:"fileId" ,headerText:"File ID",width: '10%'},
    { dataField:"fileName" ,headerText:"File Name",width: '20%' },
    { dataField:"totalRecord" ,headerText:"Total Record",width: '15%'},
    { dataField:"totSucces" ,headerText:"Total Success",width: '15%'},
    { dataField:"totFail" ,headerText:"Total Fail",width: '15%'},
    { dataField:"stus" ,headerText:'Status',width: '10%'},
    { dataField:"crtDt" ,headerText:"Created Date",width: '15%'}
    ];

var detailsColumnLayout= [
    {dataField : "fileId", headerText : "File Id", width : '10%', visible : false},
    {dataField : "custBillRef1", headerText : "JomPAY Ref-1", width : '15%'},
    {dataField : "custBillRef2", headerText : "JomPAY Ref-2", width : '15%'},
    {dataField : "amount", headerText : "Amount", width : '15%'},
    {dataField : "transDt", headerText : "Transaction Date", width : '15%'},
    {dataField : "slipNo", headerText : "Slip No", width : '10%'},
    {dataField : "status", headerText : "Status", width : '10%'},
    {dataField : "rem", headerText : "Remark", width : '50%'},
    ];

function fn_getJompayRTNListAjax() {
    Common.ajax("GET", "/payment/selectJompayRtnList.do", $("#searchForm").serialize(), function(result) {
        AUIGrid.setGridData(myGridID, result);
    });
}

function fn_getJompayRTNDetailsList(){
		var selectedItem = AUIGrid.getSelectedIndex(myGridID);

	    if (selectedItem[0] > -1){
	    	$("#view_wrap").show();
	    	var fileId = AUIGrid.getCellValue(myGridID, selectedGridValue, "fileId");
	        var stusName = AUIGrid.getCellValue(myGridID, selectedGridValue, "status");

	        Common.ajax("GET", "/payment/selectJompayRtnDetailsList.do", {fileId : fileId}, function(result) {
                    AUIGrid.setGridData(fileItemID, result);
                });

        }else{
             Common.alert('No record selected.');
        }
}

hideViewPopup=function(val){
    $(val).hide();
}

function fn_clear(){
    $("#searchForm")[0].reset();
}

function fn_getItmStatus(val){
	var fileId = AUIGrid.getCellValue(myGridID, selectedGridValue, "fileId");

	if(val == "4"){$('#pop_header h3').text('Completed Transactions');}
	else if(val == "6"){$('#pop_header h3').text('Failed Transactions');}
	else{$('#pop_header h3').text('All Transaction');}

	Common.ajax("GET", "/payment/selectJompayRtnDetailsList.do", {"fileId":fileId,"status":val}, function(result) {
        AUIGrid.setGridData(fileItemID, result);
    });
}
</script>
<!-- content start -->
<section id="content">
  <ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Payment</li>
    <li>Payment</li>
    <li>Jompay RTN</li>
  </ul>
  <!-- title_line start -->
  <aside class="title_line">
    <p class="fav">
      <a href="#" class="click_add_on">My menu</a>
    </p>
    <h2>JOMPAY RTN</h2>
    <ul class="right_btns">
      <c:if test="${PAGE_AUTH.funcView == 'Y'}">
      <li><p class="btn_blue">
          <a href="javascript:fn_getJompayRTNListAjax();"><span class="search"></span>Search</a>
        </p></li>
      <li><p class="btn_blue">
          <a href="javascript:fn_clear();"><span class="clear"></span>Clear</a>
        </p></li>
      </c:if>
    </ul>
  </aside>
  <!-- title_line end -->
  <!-- search_table start -->
  <section class="search_table">
    <form name="searchForm" id="searchForm" method="post">
      <table class="type1">
        <!-- table start -->
        <caption>table</caption>
        <colgroup>
          <col style="width: 200px" />
          <col style="width: *" />
          <col style="width: 200px" />
          <col style="width: *" />
          <col style="width: 200px" />
          <col style="width: *" />
        </colgroup>
        <tbody>
          <tr>
            <th scope="row">File ID</th>
            <td><input id="fileId" name="fileId" type="text" title="fileId" placeholder="File ID" /></td>
            <th scope="row">Create Date</th>
            <td>
              <!-- date_set start -->
              <div class="date_set w100p">
                <p>
                  <input id="createDt1" name="createDt1" type="text" title="Create Date From" placeholder="DD/MM/YYYY" class="j_date" readonly />
                </p>
                <span>~</span>
                <p>
                  <input id="createDt2" name="createDt2" type="text" title="Create Date To" placeholder="DD/MM/YYYY" class="j_date" readonly />
                </p>
              </div> <!-- date_set end -->
            </td>
            <th scope="row"></th>
            <td></td>
        </tbody>
      </table>
      <!-- table end -->

      <aside class="link_btns_wrap">
                <p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
                <dl class="link_list">
                    <dt>Link</dt>
                    <dd>
                    <ul class="btns">
                        <li><p class="link_btn"><a href="javascript:fn_getJompayRTNDetailsList();">View Details</a></p></li>
                    </ul>
                    <ul class="btns">
                    </ul>
                    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
                    </dd>
                </dl>
            </aside>

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

<!-- popup_wrap start -->
<div class="popup_wrap" id="view_wrap" style="display: none;">
  <!-- pop_header start -->
  <header class="pop_header" id="pop_header">
    <h1>JOMPAY transaction details</h1>
    <ul class="right_opt">
      <li><p class="btn_blue2"><a href="#" id="excelDown"><spring:message code="pay.btn.download" /></a></p></li>
      <li><p class="btn_blue2"><a href="#" onclick="hideViewPopup('#view_wrap')">CLOSE</a></p></li>

    </ul>
  </header>
  <!-- pop_header end -->
  <!-- pop_body start -->
  <section class="pop_body">
    <!-- tap_wrap start -->
        <!-- table start -->
        <!-- grid_wrap start -->
        <aside class="title_line">
          <!-- title_line start -->
          <header class="pop_header" id="pop_header">
            <h3>All Transaction</h3>
            <ul class="right_btns">
              <li><p class="btn_blue2">
                  <a href="javascript:fn_getItmStatus('')">All Transactions</a>
                </p></li>
              <li><p class="btn_blue2">
                  <a href="javascript:fn_getItmStatus(4)">Completed Transactions</a>
                </p></li>
              <li><p class="btn_blue2">
                  <a href="javascript:fn_getItmStatus(6)">Failed Transactions</a>
                </p></li>
            </ul>
          </header>
        </aside>
        <!-- title_line end -->
        <table class="type1">
          <caption>table</caption>
          <tbody>
            <tr>
              <td colspan='5'>
                <div id="fileItem_grid_wrap" style="width: 100%;height: 480px;margin: 0 auto;"></div>
              </td>
            </tr>
          </tbody>
        </table>
        <!-- table end -->
  </section>
  <!-- pop_body end -->
</div>
<!-- popup_wrap end -->
