<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
$(document).ready(function() {
	doGetComboSepa("/common/selectBranchCodeList.do",1 , '-',''   , 'dscCode' , 'S', '');

	//grid 생성
	createInstallationListAUIGrid();
	
	 // 셀 더블클릭 이벤트 바인딩
    AUIGrid.bind(myGridID, "cellDoubleClick", function(event) {
          alert(event.rowIndex+ " - double clicked!! : " + event.value + " - rowValue : " + AUIGrid.getCellValue(myGridID, event.rowIndex, "installEntryId"));
          Common.popupDiv("/services/installationResultDetailPop.do?isPop=true&installEntryId=" + AUIGrid.getCellValue(myGridID, event.rowIndex, "installEntryId")+"&codeId=" + AUIGrid.getCellValue(myGridID, event.rowIndex, "codeid1"));
      });

    AUIGrid.bind(myGridID, "cellClick", function(event) {
      //alert(event.rowIndex+ " -cellClick : " + event.value + " - rowValue : " + AUIGrid.getCellValue(myGridID, event.rowIndex, "memberid"));
      memberid =  AUIGrid.getCellValue(myGridID, event.rowIndex, "memberid");
      memberType = AUIGrid.getCellValue(myGridID, event.rowIndex, "membertype");
      //Common.popupDiv("/organization/requestTerminateResign.do?isPop=true&MemberID=" + AUIGrid.getCellValue(myGridID, event.rowIndex, "memberid")+"&MemberType=" + AUIGrid.getCellValue(myGridID, event.rowIndex, "membertype"), "");
  }); 
   
});

function fn_installationListSearch(){
	Common.ajax("GET", "/services/installationListSearch.do", $("#searchForm").serialize(), function(result) {
        console.log("성공.");
        console.log("data : " + result);
        AUIGrid.setGridData(myGridID, result);
    });
}

var myGridID;
function createInstallationListAUIGrid() {
    //AUIGrid 칼럼 설정
    var columnLayout = [ {
        dataField : "code",
        headerText : "Type",
        editable : false,
        width : 130
    }, {
        dataField : "installEntryNo",
        headerText : "Install No",
        editable : false,
        width : 180
    }, {
        dataField : "salesOrdNo",
        headerText : "Order No",
        editable : false,
        width : 180
    }, {
        dataField : "c3",
        headerText : "App Date",
        editable : false,
        width : 250
    }, {
        dataField : "stkDesc",
        headerText : "Product",
        editable : false,
        style : "my-column",
        width : 180
    }, {
        dataField : "name",
        headerText : "Customer",
        editable : false,
        width : 250
    }, {
        dataField : "codeName",
        headerText : "App Type",
        editable : false,
        width : 150
        
    }, {
        dataField : "code1",
        headerText : "Status",
        width : 130
    }, {
        dataField : "installEntryId",
        headerText : "",
        width : 0
    }, {
        dataField : "codeid1",
        headerText : "",
        width : 0
    }];
     // 그리드 속성 설정
    var gridPros = {
        
        // 페이징 사용       
        usePaging : true,
        
        // 한 화면에 출력되는 행 개수 20(기본값:20)
        pageRowCount : 20,
        
        editable : true,
        
        showStateColumn : true, 
        
        displayTreeOpen : true,
        
        
        headerHeight : 30,
        
        // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
        skipReadonlyColumns : true,
        
        // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
        wrapSelectionMove : true,
        
        // 줄번호 칼럼 렌더러 출력
        showRowNumColumn : true,

    };
    
    //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
    myGridID = AUIGrid.create("#grid_wrap", columnLayout, gridPros);
}

var gridPros = {
    
    // 페이징 사용       
    usePaging : true,
    
    // 한 화면에 출력되는 행 개수 20(기본값:20)
    pageRowCount : 20,
    
    editable : true,
    
    fixedColumnCount : 1,
    
    showStateColumn : true, 
    
    displayTreeOpen : true,
    
    selectionMode : "singleRow",
    
    headerHeight : 30,
    
    // 그룹핑 패널 사용
    useGroupingPanel : true,
    
    // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
    skipReadonlyColumns : true,
    
    // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
    wrapSelectionMove : true,
    
    // 줄번호 칼럼 렌더러 출력
    showRowNumColumn : false,
    
};
</script>
<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Sales</li>
    <li>Order list</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Installation Result List</h2>
<ul class="right_btns">
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_installationListSearch()"><span class="search"></span>Search</a></p></li>
    <li><p class="btn_blue"><a href="#"><span class="clear"></span>Clear</a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="searchForm">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:170px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:230px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Type</th>
    <td>
    <select class="multy_select w100p" multiple="multiple" id="type" name="type">
        <option value="257">New Installation Order</option>
        <option value="258">Product Exchange</option>
    </select>
    </td>
    <th scope="row">Install No</th>
    <td><input type="text" class="w100p" title="" placeholder="" id="installNo" name="installNo" /></td>
    <th scope="row">Appointment Date</th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="startDate" name="startDate"/></p>
    <span>To</span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="endDate" name="endDate"/></p>
    </div><!-- date_set end -->
    </td>
</tr>
<tr>
    <th scope="row">Install Date</th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="instalStrlDate" name="instalStrlDate"/></p>
    <span>To</span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="installEndDate" name="installEndDate"/></p>
    </div><!-- date_set end -->
    </td>
    <th scope="row">Order No</th>
    <td><input type="text" class="w100p" title="" placeholder="" id="orderNo" name="orderNo"/></td>
    <th scope="row">Order Ref No</th>
    <td><input type="text" class="w100p" title="" placeholder="" id="orderRefNo" name="orderRefNo"/></td>
</tr>
<tr>
    <th scope="row">PO No</th>
    <td><input type="text" class="w100p" title="" placeholder="" id="poNo" name="poNo"/></td>
    <th scope="row">Order Date</th>
    <td><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" id="orderDate" name="orderDate"/></td>
    <th scope="row">Application Type</th>
    <td>
    <select class="multy_select w100p" multiple="multiple" id="appType" name="appType">
        <c:forEach var="list" items="${appTypeList }" varStatus="status">
           <option value="${list.codeId}">${list.codeName}</option>
        </c:forEach>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Installation Status</th>
    <td>
    <select class="multy_select w100p" multiple="multiple" id="installStatus" name="installStatus">
        <c:forEach var="list" items="${installStatus }" varStatus="status">
           <option value="${list.codeId}">${list.codeName}</option>
        </c:forEach>
    </select>
    </td>
    <th scope="row">CT Code</th>
    <td><input type="text" class="w100p" title="" placeholder="" id="ctCode" name="ctCode"/></td>
    <th scope="row">DSC Code</th>
    <td>
    <select class="w100p" id="dscCode" name="dscCode">
        <option value="">11</option>
        <option value="">22</option>
        <option value="">33</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Customer ID</th>
    <td><input type="text" class="w100p" title="" placeholder="" id="customerId" name="customerId"/></td>
    <th scope="row">Customer Name</th>
    <td><input type="text" class="w100p" title="" placeholder="" id="customerName" name="customerName"/></td>
    <th scope="row">Customer IC/Company No.</th>
    <td><input type="text" class="w100p" title="" placeholder="" id="customerIc" name="customerIc"/></td>
</tr>
<tr>
    <th scope="row">SIRIM No.</th>
    <td><input type="text" class="w100p" title="" placeholder="" id="sirimNo" name="sirimNo"/></td>
    <th scope="row">Serial No.</th>
    <td colspan="3"><input type="text" class="w100p" title="" placeholder="" id="serialNo" name="serialNo"/></td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
<dl class="link_list">
    <dt>Link</dt>
    <dd>
    <ul class="btns">
        <li><p class="link_btn"><a href="#">menu1</a></p></li>
        <li><p class="link_btn"><a href="#">menu2</a></p></li>
        <li><p class="link_btn"><a href="#">menu3</a></p></li>
        <li><p class="link_btn"><a href="#">menu4</a></p></li>
        <li><p class="link_btn"><a href="#">Search Payment</a></p></li>
        <li><p class="link_btn"><a href="#">menu6</a></p></li>
        <li><p class="link_btn"><a href="#">menu7</a></p></li>
        <li><p class="link_btn"><a href="#">menu8</a></p></li>
    </ul>
    <ul class="btns">
        <li><p class="link_btn type2"><a href="#">menu1</a></p></li>
        <li><p class="link_btn type2"><a href="#">Search Payment</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu3</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu4</a></p></li>
        <li><p class="link_btn type2"><a href="#">Search Payment</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu6</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu7</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu8</a></p></li>
    </ul>
    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
    </dd>
</dl>
</aside><!-- link_btns_wrap end -->

<ul class="right_btns">
    <li><p class="btn_grid"><a href="#">EDIT</a></p></li>
    <li><p class="btn_grid"><a href="#">NEW</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
    <li><p class="btn_grid"><a href="#">DEL</a></p></li>
    <li><p class="btn_grid"><a href="#">INS</a></p></li>
    <li><p class="btn_grid"><a href="#">ADD</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_wrap" style="width: 100%; height: 500px; margin: 0 auto;"></div>
</article><!-- grid_wrap end -->

</form>
</section><!-- search_table end -->

</section><!-- content end -->
