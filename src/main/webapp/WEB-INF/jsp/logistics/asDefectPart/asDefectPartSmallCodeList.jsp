<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript">
   console.log("Logistics/asDefectPart/asDefectPartSmallCode");
   var myGridID;

   $(document).ready(function() {

       createAUIGrid();

	   doGetCombo('/sales/promotion/selectProductCategoryList.do', '', '', 'cmbProductCtgry', 'M','f_multiCombo'); //Category
	   doGetCombo('/common/selectCodeList.do', '15', '', 'cmbMatType', 'M','f_multiCombo');

	   AUIGrid.bind(myGridID, "cellDoubleClick", function(event) {
		   var selectedItems = AUIGrid.getSelectedItems(myGridID);

	       var defPartId = selectedItems[0].item.defPartId;
	       var viewType = 3; //View
	          Common.popupDiv("/logistics/asDefectPart/addEditViewDefectPartPop.do?isPop=true&defPartId=" + defPartId + "&viewType=" + viewType);
	        });
   });

   function f_multiCombo(){
       $(function() {

           $('#cmbProductCtgry').change(function() {

           }).multipleSelect({
               selectAll: true, // 전체선택
               width: '80%'
           });

           $('#cmbMatType').change(function() {

           }).multipleSelect({
               selectAll : true,
               width : '80%'
           });
       });
   }

   function createAUIGrid() {
       var columnLayout = [
                 {dataField :"prodCatId",  headerText : "Category",      width: 150 ,editable : false, visible : false},
                 {dataField :"prodCat",  headerText : "Category",      width: 150 ,editable : false},
                 {dataField :"prodTypeID",  headerText : "Category",      width: 150 ,editable : false, visible : false},
                 {dataField :"prodType",  headerText : "Type",      width: 150 ,editable : false },
                 {dataField :"matCode",  headerText : "Material Code",    width: 150, editable : false },
                 {dataField :"matName", headerText : "Material Name",   width: 150, editable : false },
                 {dataField :"defPartCode", headerText : "Defect Part Code",  width: 150, editable : false },
                 {dataField :"defPartName", headerText : "Defect Part Name",  width: 150, editable : false },
                 {dataField :"stus", headerText : "Status", width: 150, editable : false },
                 {dataField :"crtUser", headerText : "Creator", width: 150, editable : false },
                 {dataField :"crtDt", headerText : "Create Date",width: 150, dataType : "date", formatString : "dd-mm-yyyy"  ,editable : false }
      ];

       //그리드 속성 설정
     var gridPros = {
               usePaging : true,
               pageRowCount: 20,
               editable: false,
               fixedColumnCount : 1,
               headerHeight     : 30,
               showRowNumColumn : true};

     myGridID = GridCommon.createAUIGrid("list_grid_wrap", columnLayout, "" ,gridPros);
   }

   function fn_clear(){
       doGetCombo('/sales/promotion/selectProductCategoryList.do', '', '', 'cmbProductCtgry', 'M','f_multiCombo');
       doGetCombo('/common/selectCodeList.do', '15', '', 'cmbMatType', 'M','f_multiCombo');
       $("#stkCd").val('');
       $("#stkNm").val('');
   }

   function fn_addEditDefFilter(viewType) {

	   if(viewType == 1) //NEW
	   {
		   Common.popupDiv("/logistics/asDefectPart/addEditViewDefectPartPop.do?isPop=true&viewType=" + viewType, "", null,
                   "false", "addDefPartPopupId");
	   }
	   else { // 2 OR 3 == edit OR VIEW
		   fn_editDefPart(viewType);
	   }
   }

   function fn_editDefPart(viewType){
	   var selectedItems = AUIGrid.getSelectedItems(myGridID);

       if (selectedItems.length <= 0) {
            // NO DATA SELECTED.
           Common.alert("<spring:message code='service.msg.NoRcd'/> ");
           return;
       }

       var defPartId = selectedItems[0].item.defPartId;

       Common.popupDiv("/logistics/asDefectPart/addEditViewDefectPartPop.do?isPop=true&defPartId=" + defPartId + "&viewType=" + viewType, "", null,
               "false", "addDefPartPopupId");

   }

   function fn_selectListAjax() {

       AUIGrid.refreshRows() ;
       Common.ajax("GET", "/logistics/asDefectPart/searchAsDefPartList", $("#listSForm").serialize(), function(result) {
            AUIGrid.setGridData(myGridID, result);
       });
   }
</script>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Sales</li>
    <li>AS Defect Part Small Code</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>AS Defect Part Small Code</h2>

<ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcView == 'Y'}">
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_selectListAjax()"><span class="search"></span><spring:message code="sal.btn.search" /></a></p></li>
    </c:if>
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_clear()"><span class="clear"></span><spring:message code="sal.btn.clear" /></a></p></li>
</ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id='listSForm' name='listSForm'>

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
    <th scope="row"><spring:message code="sal.title.text.productCategory" /></th>
    <td>
    <select class="w100p" id="cmbProductCtgry" name="productCtgry" multiple="multiple">
    </select>
    </td>
    <th scope="row">Type</th>
    <td>
        <select class="w100p" id="cmbMatType" name="matType"></select>
    </td>
    <th scope="row"></th><td></td>
</tr>
 <tr>
    <th scope="row">Material Code</th>
    <td>
        <input type=text name="stkCd" id="stkCd" class="w100p" value=""/>
    </td>
    <th scope="row">Material Name</th>
    <td>
        <input type=text name="stkNm" id="stkNm" class="w100p" value=""/>
    </td>
    <th scope="row"></th><td></td>
</tr>

</tbody>
</table><!-- table end -->
</form>
</section><!-- search_table end -->

<aside class="link_btns_wrap">
    <!-- link_btns_wrap start -->
    <p class="show_btn">
     <a href="#"><img
      src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif"
      alt="link show" /></a>
    </p>
    <dl class="link_list">
     <dt>Link</dt>
     <dd>
      <ul class="btns">
        <li><p class="link_btn">
          <a href="javascript:fn_addEditDefFilter(1)" id="addDefFilter">Add Defect Part Code</a>
         </p></li>
        <li><p class="link_btn">
          <a href="javascript:fn_addEditDefFilter(2)" id="editDefFilter">Edit Defect Part Code</a>
         </p></li>
      </ul>
     </dd>
    </dl>
   </aside>
   <!-- link_btns_wrap end -->

<section class="search_result"><!-- search_result start -->

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="list_grid_wrap" style="width:100%; height:360px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->
