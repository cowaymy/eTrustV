<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript">
   console.log("sales/rcms/corporateCareAccountMgmtList");
   var myGridID;

   $(document).ready(function() {

       createAUIGrid();

       doGetCombo('/sales/rcms/selectPortalNameList.do', '', '', 'cmbPortalName', 'M','f_multiCombo');
       doGetCombo('/sales/rcms/selectPortalStusList.do', '', '', 'cmbPortalStus', 'M','f_multiCombo'); //Category

        AUIGrid.bind(myGridID, "cellDoubleClick", function(event) {
            fn_editViewPortal(3);
       });
   });

   function f_multiCombo(){
       $(function() {
           $('#cmbPortalName').change(function() {
           }).multipleSelect({
               selectAll: true, // 전체선택
               width: '80%'
           });

           $('#cmbPortalStus').change(function() {
           }).multipleSelect({
               selectAll : true,
               width : '80%'
           });
       });
   }

   function createAUIGrid() {
       var columnLayout = [
        {dataField : "portalId", headerText : "codeCatId", width : "15%",visible: false},
        {dataField : "portalStusId", headerText : "Portal Status　ID", width : "15%", visible: false},
        {dataField : "portalStus", headerText : "Portal Status", width : "15%"},
        {dataField : "corpTypeId", headerText : "Corperate Type ID", width : "15%", visible: false},
        {dataField : "corpType", headerText : "Corperate Type ", width : "15%"},
        {dataField : "portalCode", headerText : "Code of Portal", width : "15%"},
        {dataField : "portalName", headerText : "Name of Portal", width : "15%"},
        {dataField : "portalUrl", headerText : "URL", width : "15%"},
        {dataField : "loginId", headerText : "Login ID", width : "15%"},
        {dataField : "portalPass", headerText : "Password", width : "15%",
            /* styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {
                var maskedPass = value.padStart(value.length, '*');
                value = maskedPass
                return value;
            } */
        },
        {dataField : "portalPic", headerText : "CCD Main PIC (Portal)", width : "15%"},
        {dataField : "totalCustId", headerText : "Total Cust ID", width : "15%"},
        {dataField : "totalOrder", headerText : "Total Order", width : "15%"},
        {dataField : "custNameCode", headerText : "Code of Customer Name", width : "15%"},
        {dataField : "custName", headerText : "Customer Name", width : "15%"},
        {dataField : "updator", headerText : "Last Update User", width : "15%"},
        {dataField : "updDt", headerText : "Last Update Date", width : "15%"}
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
       $("#custCode").val('');
       $("#custName").val('');
   }

   function fn_addEditPortal(viewType) {

       if(viewType == 1) //NEW
       {
           console.log("1111===")
           Common.popupDiv("/sales/rcms/addEditViewCorporatePortalPop.do?isPop=true" + "&viewType=" + viewType, "", null, "false", "portalPopupId");
       }
       else { // 2 OR 3 == edit OR VIEW
           fn_editViewPortal(viewType);
       }
   }

    function fn_editViewPortal(viewType){
       var selectedItems = AUIGrid.getSelectedItems(myGridID);

       if (selectedItems.length <= 0) {// NO DATA SELECTED.
           Common.alert("<spring:message code='service.msg.NoRcd'/> ");
           return;
       }

       var portalId = selectedItems[0].item.portalId;

       Common.popupDiv("/sales/rcms/addEditViewCorporatePortalPop.do?isPop=true&portalId=" + portalId + "&viewType=" + viewType, "", null,
               "false", "portalPopupId");

   }

   function fn_selectListAjax() {
       AUIGrid.refreshRows() ;
       Common.ajax("GET", "/sales/rcms/selectPortalList", $("#listSForm").serialize(), function(result) {
            AUIGrid.setGridData(myGridID, result);
       });
   }

   function fn_excelDown() {
        // type : "xlsx", "csv", "txt", "xml", "json", "pdf", "object"
        var today = new Date();
        var dd = String(today.getDate()).padStart(2, '0');
        var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
        var yyyy = today.getFullYear();

        GridCommon.exportTo("list_grid_wrap", "xlsx", "Corporate Care Account List" + yyyy + mm + dd);
   }

   function fn_UpdStatus(){
       var selectedItems = AUIGrid.getSelectedItems(myGridID);

       var portalId = selectedItems[0].item.portalId;
       var portalStusId = selectedItems[0].item.portalStusId;
       var portalName = selectedItems[0].item.portalName;

       Common.ajax("POST", "/sales/rcms/updatePortalStatus.do", { portalId : portalId, portalStusId: portalStusId, portalName : portalName},
               function(result) {
                 Common.alert(result.message);
                 fn_selectListAjax();
       });
   }

</script>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Sales</li>
    <li>RCMS</li>
    <li>Corporate Care Account Management</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Corporate Care Account Management</h2>

<ul class="right_btns">
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_addEditPortal(1)">Add Portals</a></p></li>
<!--<li><p class="btn_blue"><a href="#" onclick="javascript:fn_addOrders()">Add Order</a></p></li>-->
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_UpdStatus()">Activate/Deactivate Portal</a></p></li>
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_addEditPortal(2)">Edit Portal</a></p></li>
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_selectListAjax()"><span class="search"></span><spring:message code="sal.btn.search" /></a></p></li>
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
    <th scope="row">Portal Name</th>
    <td>
        <select multiple="multiple" id="cmbPortalName" name="portalName">
            <%-- <c:forEach var="list" items="${portalStus}" varStatus="status">
                <option value="${list.stusCodeId}">${list.name}</option>
            </c:forEach> --%>
        </select>
    </td>
    <th scope="row">Portal Status</th>
    <td>
        <select  multiple="multiple" id="cmbPortalStus" name="portalStus">
            <%-- <c:forEach var="list" items="${portalStus}" varStatus="status">
                <option value="${list.stusCodeId}">${list.name}</option>
            </c:forEach> --%>
        </select>
    </td>
    <th scope="row"></th><td></td>
</tr>
 <tr>
    <th scope="row">Code of Customer Name</th>
    <td>
        <input type=text name="custCode" id="custCode" class="w100p" value=""/>
    </td>
    <th scope="row">Customer Name</th>
    <td>
        <input type=text name="custName" id="custName" class="w100p" value=""/>
    </td>
    <th scope="row"></th><td></td>
</tr>

</tbody>
</table><!-- table end -->
</form>
</section><!-- search_table end -->

<ul class="right_btns">
    <li><p class="btn_grid">
    <a href="#" onClick="fn_excelDown()"><spring:message code='service.btn.Generate' /></a></p></li>
 </ul>

<section class="search_result"><!-- search_result start -->

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="list_grid_wrap" style="width:100%; height:360px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->
