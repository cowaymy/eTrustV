<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">
// 생성 후 반환 아이디
var orderGridID;

$(document).ready(function() {
    
    createAUIGrid();
    
    //_search Order
     $("#_orderSearchBtn").click(function() {
        
         fn_getSearchResultJsonListAjax();
         
     });
    
    //jdate Load Lib
    //j_date
    var pickerOpts={
            changeMonth:true,
            changeYear:true,
            dateFormat: "dd/mm/yy"
    };
    
    $(".j_date").datepicker(pickerOpts);

    var monthOptions = {
         pattern: 'mm/yyyy',
         selectedYear: 2017,
         startYear: 2007,
         finalYear: 2027
    };
    
    $(".j_date2").monthpicker(monthOptions);
    
    //ComboBox
    doGetProductCombo('/common/selectProductCodeList.do', '', '', 'listProductId', 'S'); //Product Code
    
    //Search
    $("#_editOrderSearchBtn").click(function() {
    	
    	//Set Condition
    	if( ($("#_custId").val() == '' || $("#_custId").val() == null) &&  
    		($("#_custName").val() == ""|| $("#_custName").val() == null) &&
    		($("#_custIc").val() == "" || $("#_custIc").val() == null)  && 
    		($("#listProductId").val() == "" || $("listProductId").val() == null) &&
    		($("#_salesmanCode").val() == "" || $("#_salesmanCode").val() == null ) && 
    		($("#listRentStus").val() == null || $("#listRentStus").val().length > 6) ){
    		
    		Common.alert(" *  Please key in at least one condition ");
    		return;
    	}
    	
    	 Common.ajax("GET", "/sales/order/selectOrderJsonList", $("#listSearchForm").serialize(), function(result) {
             AUIGrid.setGridData(orderGridID, result);
         });
	});
    
    //Add
    $("#_addRowOrderGrid").click(function() {
		
    	//Json Obj
    	var list = AUIGrid.getCheckedRowItems(orderGridID);
    	
    	if(list.length <= 0){
    		Common.alert(" * No Order Cheked.");
    		return;
    	}
    	
    	var tempVal;
    	for (var idx = 0; idx < list.length; idx++) {
			//alert(list[idx].item.ordId);
			
			tempVal = {addOrdId : list[idx].item.ordId};
			
			Common.ajax("GET", "/sales/ccp/selectOrderAddJsonList", tempVal , function(result){
	             AUIGrid.addRow(orderListGirdID, result, "last");
	        }); 
			
		}
    	
    	//Close
    	$("#_addCloseBtn").click();
    	
	});
});// Document Ready Func End

function createAUIGrid() {
    
    //AUIGrid 칼럼 설정
    var columnLayout = [
        {
            dataField   : "ordNo",          headerText  : "Order No",
            width       : 80,               editable    : false,
            style       : 'left_style'
        }, {
            dataField   : "ordStusCode",    headerText  : "Status",
            width       : 80,               editable    : false,
            style           : 'left_style'
        }, {
            dataField   : "appTypeCode",    headerText  : "App Type",
            width       : 80,               editable        : false,
            style       : 'left_style'
        }, {
            dataField   : "ordDt",          headerText  : "Order Date",
            width       : 100,              editable    : false,
            style       : 'left_style'
        }, {
            dataField   : "refNo",          headerText  : "Ref No",
            width       : 60,               editable    : false,
            style       : 'left_style'
        }, {
            dataField   : "productName",    headerText  : "Product",
            width       : 150,              editable    : false,
            style       : 'left_style'
        }, {
            dataField   : "custId",         headerText  : "Cust ID",
            width       : 70,               editable    : false,
            style       : 'left_style'
        }, {
            dataField   : "custName",       headerText  : "Customer Name",
            width       : 100,              editable    : false,
            style       : 'left_style'
        }, {
            dataField   : "custIc",         headerText  : "NRIC/Company No",
            width       : 100,              editable    : false,
            style       : 'left_style'
        }, {
            dataField   : "crtUserId",      headerText  : "Creator",
            width       : 100,              editable    : false,
            style       : 'left_style'
        }, {
            dataField   : "pvYear",         headerText  : "PV Year",
            width       : 60,               editable    : false,
            style       : 'left_style'
        }, {
            dataField   : "pvMonth",        headerText  : "PV Mth",
            width       : 60,               editable    : false,
            style       : 'left_style'
        }, {
            dataField   : "ordId",          visible     : false //salesOrderId
        }];

    //그리드 속성 설정
    var gridPros = {
        usePaging           : true,         //페이징 사용
        pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)            
        editable            : false,            
        fixedColumnCount    : 1,            
        showStateColumn     : false,             
        displayTreeOpen     : false,            
  //      selectionMode       : "singleRow",  //"multipleCells",            
        headerHeight        : 30,       
        useGroupingPanel    : false,        //그룹핑 패널 사용
        skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
        wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
        showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력    
        showRowCheckColumn : true, //checkBox
        noDataMessage       : "No order found.",
        groupingMessage     : "Here groupping"
    };
    
    orderGridID = GridCommon.createAUIGrid("order_grid_wrap", columnLayout, "", gridPros);
}

 //search Ajax
 function fn_getSearchResultJsonListAjax(){
     
	 Common.ajax("GET", "/sales/order/selectOrderJsonList", $("#listSearchForm").serialize(), function(result) {
         AUIGrid.setGridData(orderGridID, result);
     });
 }
 
 
 //Multy Select
  $('.multy_select').change(function() {
    //console.log($(this).val());
	    })
	    .multipleSelect({
	    width: '100%'
	});
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Order Search</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a id="_addCloseBtn">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<ul class="right_btns">
    <li><p class="btn_blue2"><a id="_editOrderSearchBtn">Search</a></p></li>
    <li><p class="btn_blue2"><a id="_addRowOrderGrid">Add</a></p></li>
</ul>
<form id="listSearchForm">
<table class="type1 mt10"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Customer ID</th>
    <td><input type="text" title="" placeholder="" class="w100p"  name="custId" id="_custId"/></td>
    <th scope="row">Customer Name</th>
    <td><input type="text" title="" placeholder="" class="w100p" name="custName" id="_custName"/></td>
    <th scope="row">NRIC/Company No</th>
    <td><input type="text" title="" placeholder="" class="w100p" name="custIc"  id="_custIc"/></td>
</tr>
<tr>
    <th scope="row">Product</th>
    <td>
    <select id="listProductId" name="productId" class="w100p"></select>
    </td>
    <th scope="row">Salesman</th>
    <td><input type="text" title="" placeholder="" class="w100p" name="salesmanCode" id="_salesmanCode"/></td>
    <th scope="row">Rental Status</th>
    <td>
    <select id="listRentStus" name="rentStus"  class="multy_select w100p"  multiple="multiple">
        <option value="REG" selected="selected">Regular</option>
        <option value="INV">Investigate</option>
        <option value="SUS">Suspend</option>
        <option value="RET">Returned</option>
        <option value="CAN">Cancelled</option>
        <option value="TER">Terminated</option>
        <option value="WOF">Write Off</option>
    </select>
    </td>
</tr>
</tbody>
</table><!-- table end -->
</form>
<article class="grid_wrap"><!-- grid_wrap start -->
<div id="order_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
