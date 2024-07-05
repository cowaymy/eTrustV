<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript">
//AUIGrid 그리드 객체
var myGridID;

//Grid에서 선택된 RowID
var selectedGridValue;

// AUIGrid 칼럼 설정
var columnLayout = [
{
  dataField : "batchId",
  headerText : "<spring:message code='pay.head.batchId'/>",
  width : 120,
  editable : false
},
{
  dataField : "sts",
  headerText : "<spring:message code='pay.head.status'/>",
  width : 100,
  editable : false
},
{
  dataField : "invPeriodMonth",
  headerText : "Invoice Period",
  width : 100,
  editable : false
},
{
  dataField : "invTypeName",
  headerText : "<spring:message code='pay.head.type'/>",
  width : 120,
  editable : false
},
{
  dataField : "totalRecords",
  headerText : "<spring:message code='pay.head.totalItem'/>",
  width : 180,
  editable : false
},
{
  dataField : "totalAmt",
  headerText : "<spring:message code='pay.head.Amount'/>",
  width : 180,
  editable : false,
  dataType : "numeric",
  formatString : "#,##0.00"
},
{
  dataField : "crtDt",
  headerText : "<spring:message code='pay.head.createDate'/>",
  width : 120,
  editable : false
},
{
  dataField : "crtUserName",
  headerText : "<spring:message code='pay.head.creator'/>",
  width : 150,
  editable : false
},
/* {
  dataField : "ctrlFailSmsIsPump",
  headerText : "<spring:message code='pay.head.sms'/>",
  width : 100,
  editable : false,
  labelFunction : function(rowIndex, columnIndex, value,
      headerText, item, dataField) {
    var myString = "";

    if (value == 1) {
      myString = "Yes";
    } else {
      myString = "No";
    }
    return myString;
  }
},
{
  dataField : "ctrlWaitSync",
  headerText : "<spring:message code='pay.head.waitSync'/>",
  width : 100,
  editable : false,
  renderer : {
    type : "CheckBoxEditRenderer",
    checkValue : "1",
    unCheckValue : "0"
  }
}, */
];

//Grid Properties 설정
var gridPros = {
  editable : false, // 편집 가능 여부 (기본값 : false)
  showStateColumn : false, // 상태 칼럼 사용
  softRemoveRowMode : false
};

// 화면 초기화 함수 (jQuery 의 $(document).ready(function() {}); 과 같은 역할을 합니다.
$(document).ready(function() {
	// STATUS
    doGetComboCodeId('/payment/einv/selectEInvStat.do', '', '','status', 'S', '');

    // E-INVOICE TYPE
    doGetComboData('/payment/einv/selectEInvCommonCode.do', {ind : 'E-Invoice Type'}, '', 'invType', 'S', '');

    myGridID = GridCommon.createAUIGrid("grid_wrap",columnLayout, null, gridPros);
});

// 리스트 조회.
function fn_getEInvListAjax() {
	Common.ajax("GET", "/payment/einv/selectEInvoiceList.do", $("#searchForm").serialize(), function(result) {
		    AUIGrid.setGridData(myGridID, result);
	});
}

//New Claim Pop-UP
function fn_openDivPop(val) {
    Common.popupDiv("/payment/einv/govEInvoiceNewPop.do", null, null, true, "newEInvPop");
}

//View Claim Pop-UP
function fn_openViewPop(val) {
	var selectedItem = AUIGrid.getSelectedItems(myGridID);
	console.log('selectedItem ' + selectedItem);
	var data = {
			param : selectedItem[0].item
	};
	if(selectedItem == null || selectedItem.length <= 0 ){
		   Common.alert("<spring:message code='pay.alert.noClaim'/>");
	}else{
		   Common.popupDiv("/payment/einv/govEInvoiceViewPop.do", selectedItem[0].item, null, true, "viewEInvPop");
	}
}

function fn_clear() {
  $("#searchForm")[0].reset();
}
</script>
<!-- content start -->
<section id="content">
 <ul class="path">
  <li><img
   src="${pageContext.request.contextPath}/resources/images/common/path_home.gif"
   alt="Home" /></li>
 </ul>
 <!-- title_line start -->
 <aside class="title_line">
  <p class="fav">
   <a href="#" class="click_add_on"><spring:message
     code='pay.text.myMenu' /></a>
  </p>
  <h2>E-invoice List</h2>
  <ul class="right_btns">
    <li><p class="btn_blue">
      <a href="javascript:fn_getEInvListAjax();"><span
       class="search"></span> <spring:message code='sys.btn.search' /></a>
     </p></li>
   <li><p class="btn_blue">
     <a href="javascript:fn_clear();"><span class="clear"></span> <spring:message
       code='sys.btn.clear' /></a>
    </p></li>
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
     <col style="width: 140px" />
     <col style="width: *" />
     <col style="width: 130px" />
     <col style="width: *" />
     <col style="width: 170px" />
     <col style="width: *" />
    </colgroup>
    <tbody>
     <tr>
      <th scope="row"><spring:message code='pay.text.bchID' /></th>
      <td><input id="batchId" name="batchId" type="text"
       title="BatchID" placeholder="Batch ID" class="w100p" /></td>
      <th scope="row"><spring:message code='pay.text.creator' /></th>
      <td><input id="creator" name="creator" type="text"
       title="Creator" placeholder="Creator (Username)" class="w100p" />
      </td>
      <th scope="row">Create Month<%-- <spring:message code='pay.text.crtDt' /> --%></th>
      <td>
       <!-- date_set start -->
       <div class="date_set w100p">
        <p>
         <input id="createDt1" name="createDt1" type="text"
          title="Create Date From" placeholder="MM/YYYY"
          class="j_date2" readonly />
        </p>
        <!-- <span>~</span>
        <p>
         <input id="createDt2" name="createDt2" type="text"
          title="Create Date To" placeholder="DD/MM/YYYY" class="j_date"
          readonly />
        </p> -->
       </div> <!-- date_set end -->
      </td>
     </tr>
     <tr>
      <th scope="row">Invoice Type</th>
      <td><select id="invType" name="invType" class="w100p"></select>
      </td>
      <th scope="row"><spring:message code='pay.text.stat' /></th>
      <td><select id="status" name="status" class="w100p"></select>
      </td>
      <th scope="row">Invoice Period<%-- <spring:message code='pay.text.crtDt' /> --%></th>
      <td>
       <!-- date_set start -->
       <div class="date_set w100p">
        <p>
         <input id="invoicePeriod" name="invoicePeriod" type="text"
          title="Create Date From" placeholder="MM/YYYY"
          class="j_date2" readonly />
        </p>
        <!-- <span>~</span>
        <p>
         <input id="createDt2" name="createDt2" type="text"
          title="Create Date To" placeholder="DD/MM/YYYY" class="j_date"
          readonly />
        </p> -->
       </div> <!-- date_set end -->
      </td>
     </tr>
    </tbody>
   </table>
   <!-- table end -->
   <!-- link_btns_wrap start -->
   <aside class="link_btns_wrap">
     <p class="show_btn">
      <a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a>
     </p>
     <dl class="link_list">
      <dt>Link</dt>
      <dd>
      <c:if test="${PAGE_AUTH.funcView == 'Y'}">
       <ul class="btns">
        <li><p class="link_btn">
          <a href="javascript:fn_openViewPop();">View E-invoice</a>
         </p></li>
       </ul>
       </c:if>
       <ul class="btns">
       <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
        <li><p class="link_btn type2">
          <a href="javascript:fn_openDivPop('NEW');">New E-invoice</a>
         </p></li>
         <!-- <li><p class="link_btn type2">
          <a href="javascript:fn_openDivPop('CONSOLIDATED');">New Consolidated</a>
         </p></li> -->
         </c:if>
       </ul>
       <p class="hide_btn">
        <a href="#"><img
         src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif"
         alt="hide" /></a>
       </p>
      </dd>
     </dl>
   </aside>
   <!-- link_btns_wrap end -->
  </form>
 </section>
 <!-- search_table end -->
 <!-- search_result start -->
 <section class="search_result">
  <article id="grid_wrap" class="grid_wrap"></article>
 </section>
 <!-- search_result end -->
</section>
<!-- content end -->
