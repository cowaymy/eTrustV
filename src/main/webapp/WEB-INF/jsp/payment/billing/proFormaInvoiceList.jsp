<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript">
   console.log("payment/billing/proFormaInvoice");

   var  gridID;

   $(document).ready(function(){
	   createAUIGrid();
       doGetComboSepa('/common/selectBranchCodeList.do',  '1', ' - ', '', 'listBrnchCode', 'M', 'fn_multiCombo'); //Branch Code

   });

   function fn_multiCombo(){
       $('#listBrnchCode').change(function() {
       }).multipleSelect({
           selectAll: true,
           width: '100%'
       });
   }

   function createAUIGrid() {
       var columnLayout = [
                 {dataField :"salesOrdId",  headerText : "SalesOrdId",      width: 140 ,editable : false, visible : false},
                 {dataField :"custName",  headerText : "<spring:message code="pay.head.customerName" />",      width: 140 ,editable : false },
                 {dataField :"refNo",  headerText : "<spring:message code="pay.head.referenceNo" />",    width: 100, editable : false },
                 {dataField :"salesOrdNo", headerText : "<spring:message code="pay.head.orderNO" />",   width: 100, editable : false },
                 {dataField :"brnchName", headerText : "<spring:message code="pay.title.branchCode" />",  width: 150, editable : false },
                 {dataField :"deptCode", headerText : "<spring:message code="sal.title.text.deptCode" />",  width: 150, editable : false },
                 {dataField :"crtDt", headerText : "<spring:message code="service.grid.registerDt" />",width: 120, dataType : "date", formatString : "dd-mm-yyyy"  ,editable : false },
                 {dataField :"packType", headerText : "<spring:message code="sal.text.typeOfPack" />", width: 130, editable : false },
                 {dataField :"stusId", headerText : "<spring:message code="pay.head.Status" />",width: 100, editable : false , visible : false},
                 {dataField :"status", headerText : "<spring:message code="pay.head.Status" />",width: 100, editable : false },
                 {dataField :"crtUser", headerText : "<spring:message code="sal.title.creator" />" , width: 120, editable : false },
                 {dataField :"advPayKey", headerText : "<spring:message code="pay.title.advPayment" />" , width: 100, editable : false ,
                     renderer : {
                         type : "CheckBoxEditRenderer",
                         editable : false, // 체크박스 편집 활성화 여부(기본값 : false)
                         checkValue : "1"
                     }
                 }
      ];

       //그리드 속성 설정
     var gridPros = {
    		   usePaging : true,
    		   pageRowCount: 20,
    		   editable: false,
    		   fixedColumnCount : 1,
    		   headerHeight     : 30,
    		   showRowNumColumn : true};

       gridID = GridCommon.createAUIGrid("list_grid_wrap", columnLayout, "" ,gridPros);
   }

   function  fn_goNew(){
       Common.popupDiv("/payment/newProFormaPop.do" ,$("#listSForm").serialize(), null , true , 'newProFormaPopupId');
   }

   function fn_selectListAjax() {

	   Common.ajax("GET", "/payment/searchProFormaInvoiceList.do", $("#listSForm").serialize(), function(result) {
		      AUIGrid.setGridData(gridID, result);
	   });
   }

   function  fn_goEditView(type){
	   //View = 1
	   //Edit = 2
	   var selectedItems = AUIGrid.getSelectedItems(gridID);
       if(selectedItems.length <= 0) {
           Common.alert("<spring:message code='expense.msg.NoData'/> ");
           return;
       }

       var proFormaId = selectedItems[0].item.proFormaId;
       var refNo = selectedItems[0].item.refNo;
       var Stus = selectedItems[0].item.status;
       var stusId = selectedItems[0].item.stusId;
       var salesOrdNo = selectedItems[0].item.salesOrdNo;
       var salesOrdId = selectedItems[0].item.salesOrdId;

       /* if(stusId != '1') { //Active
           Common.alert("Pro Forma edit only allowed for Active status");
           return;
       } */

       var param = "?salesOrdId=" + salesOrdId + "&salesOrdNo=" + salesOrdNo + "&refNo=" + refNo + "&proFormaId=" + proFormaId + "&stus=" + Stus+ "&stusId=" + stusId;;

       if (type == 1 ){
    	  param += "&viewType=1";
       }
       else{
    	   param += "&viewType=2";
       }

       Common.popupDiv("/payment/ProFormaEditViewPop.do"+ param, null, null,  true, 'editViewProFormaPopupId');

   }

   function fn_clear(){
       $("#listSForm")[0].reset();
       fn_multiCombo();
   }

   function fn_excelDown() {
	    // type : "xlsx", "csv", "txt", "xml", "json", "pdf", "object"
	    GridCommon
	        .exportTo("list_grid_wrap", "xlsx",
	            "<spring:message code='service.title.InstallationResultLogSearch'/>");
	  }
</script>

<form id="reportInvoiceForm" method="post">
    <input type="hidden" id="reportFileName" name="reportFileName" value="/membership/MembershipQuotation_20150401.rpt" />
    <input type="hidden" id="viewType" name="viewType" value="PDF" />
    <input type="hidden" id="V_QUOTID" name="V_QUOTID"  value=""/>
</form>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Sales</li>
    <li>Pro-Forma Invoice</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Pro-Forma Invoice Requisition</h2>

<ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_goNew()"><spring:message code="sales.btn.new" /></a></p></li>
    </c:if>
    <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_goEditView(1)"><spring:message code="pay.btn.view" /></a></p></li>
    </c:if>
    <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_goEditView(2)"><spring:message code="sys.btn.edit" /></a></p></li>
    </c:if>
    <c:if test="${PAGE_AUTH.funcView == 'Y'}">
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_selectListAjax()"><span class="search"></span><spring:message code="sal.btn.search" /></a></p></li>
    </c:if>
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_clear()"><span class="clear"></span><spring:message code="sal.btn.clear" /></a></p></li>
</ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id='listSForm' name='listSForm'>
<input type="hidden" id="hiddenPackType" name="hiddenPackType"  value=""/>

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:120px" />
    <col style="width:*" />
    <col style="width:120px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code='pay.head.referenceNo'/></th>
    <td>
    <input type="text" title="" placeholder="Reference No" class="w100p"  id="refNo"  name="refNo"  />
    </td>
    <th scope="row"><spring:message code='pay.title.branchCode'/></th>
    <td>
    <select id="listBrnchCode" name="brnchCode" class="multy_select w100p" multiple="multiple"></select>
    </td>
    <th scope="row"><spring:message code='pay.title.advPayment'/></th>
    <td>
        <select id="listAdvPay" name="advPayId" class="w100p">
               <option value="">Select One</option>
		       <option value="Y">Yes</option>
               <option value="N">No</option>
        </select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code='pay.head.customerName'/></th>
    <td>
    <input type="text" title="" placeholder="Customer Name" class="w100p"  id="custName"  name="custName"  />
    </td>
    <th scope="row"><spring:message code='sal.text.departmentCode'/></th>
    <td>
    <input type="text" title="" placeholder="Department Code" class="w100p"  id="deptCode"  name="deptCode"  />
    </td>
    <th scope="row"><spring:message code='pay.text.creator'/></th>
    <td>
    <input type="text" title="" placeholder="Creator" class="w100p"  id="creator"  name="creator"  />
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.ordNo" /> <span class="must">*</span> </th>
    <td>
    <input type="text" title="" placeholder="Order Number" class="w100p"   id="ordNo"  name="ordNo"/>
    </td>
    <th scope="row"><spring:message code="sal.title.text.registrationDate" /></th>
    <td>
        <div class="date_set w100p"><!-- date_set start -->
        <p><input type="text"  placeholder="DD/MM/YYYY" class="j_date"  id="startDt"  name="startDt" /></p>
        <span><spring:message code="sal.text.to" /></span>
        <p><input type="text"  placeholder="DD/MM/YYYY" class="j_date"   id="endDt"  name="endDt"/></p>
        </div><!-- date_set end -->
    </td>
    <th scope="row"><spring:message code='pay.head.Status'/></th>
    <td>
        <select id="listStusId" name="status" class="multy_select w100p" multiple="multiple">
	           <option value="1">Active</option><!--ProForma request submitted-->
               <option value="44">Pending</option><!--pending payment-->
               <option value="36">Closed</option><!--ProForma without payment-->
               <option value="81">Converted</option><!--ProForma convert to bill-->
               <option value="10">Cancelled</option><!--invoice been generate-->
        </select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code='sal.text.typeOfPack'/></th>
    <td>
        <select id="listPackageType" name="packageType" class="w100p" >
               <option value="">Select One</option>
               <option value="12">1 Year</option>
               <option value="24">2 Year</option>
        </select>
    </td>
    <th scope="row"></th><td></td>
    <th scope="row"></th><td></td>
</tr>

</tbody>
</table><!-- table end -->

<%-- <aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
<dl class="link_list">
    <dt>Link</dt>
    <dd>
    <ul class="btns">

    </ul>
    <ul class="btns">
        <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
        <li><p class="link_btn"><a href="#" onclick="javascript:fn_doPrint()"><spring:message code="sal.btn.link.quotationDown" /></a></p></li>
        </c:if>
        <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
        <li><p class="link_btn"><a href="#"  onclick="javascript:fn_doViewQuotation()"><spring:message code="sal.btn.link.viewQuotation" /></a></p></li>
        </c:if>
        <c:if test="${PAGE_AUTH.funcUserDefine3 == 'Y'}">
         <li><p class="link_btn"><a href="#" onclick="javascript:fn_goQuotationRawData()">Quotation Raw Data</a></p></li>
        </c:if>
    </ul>
    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
    </dd>
</dl>
</aside><!-- link_btns_wrap end -->
 --%>
</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
     <li><p class="btn_grid">
       <a href="#" onClick="fn_excelDown()"><spring:message
         code='service.btn.Generate' /></a>
      </p></li>
    </c:if>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="list_grid_wrap" style="width:100%; height:360px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->
