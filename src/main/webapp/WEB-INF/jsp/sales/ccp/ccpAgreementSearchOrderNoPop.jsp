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
	
	 
	 //Grid Cell Double Click Func
	 AUIGrid.bind(orderGridID, "cellDoubleClick", function(event) {
	        
	         $("#_closeOrdPop").click();
             $("#_salesOrderNo").val(event.item.ordNo);
             $("#_confirm").click();
             
             //add by hghm callbackFun 
             try{
            	 fn_callbackOrdSearchFunciton(event.item);
             }catch(e){}
             
	  });
	 
	 doGetComboOrder('/common/selectCodeList.do', '10', 'CODE_ID',   '', 'listAppType',     'M', 'fn_multiCombo'); //Common Code
	
});

 function createAUIGrid(){
	 
	 var orderColumnLayout = [
	                               {dataField : "ordNo",headerText : "Order No", width : '10%'},
	                               {dataField : "ordDt", headerText : "Order Date", width : '10%'},
	                               {dataField : "appTypeCode", headerText : "App Type", width : '10%'},
	                               {dataField : "ordStusCode", headerText : "Status", width : '20%'},
	                               {dataField : "stockDesc", headerText : "Product", width : '10%'},  
	                               {dataField : "custName", headerText : "Customer Name",width : '30%'},
	                               {dataField : "custNric", headerText : "NRIC/Company No", width : '10%'}
	                               /* {
	                                   dataField : "undefined", 
	                                   headerText : " ", 
	                                   width : '10%',
	                                   renderer : {
	                                            type : "ButtonRenderer", 
	                                            labelText : "Select", 
	                                            onclick : function(rowIndex, columnIndex, value, item) {
	                                                //pupupWin
	                                                //alert("집어 넣기!" + item.ordNo);
	                                                $("#_closeOrdPop").click();
	                                                $("#_salesOrderNo").val(item.ordNo);
	                                                $("#_confirm").click();
	                                          }
	                                   }
	                               } */];
	 
	 var gridPros = {
             
             usePaging           : true,         //페이징 사용
             pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)            
             editable            : false,            
             fixedColumnCount    : 1,            
             showStateColumn     : true,             
             displayTreeOpen     : false,            
             selectionMode       : "singleRow",  //"multipleCells",            
             headerHeight        : 30,       
             useGroupingPanel    : false,        //그룹핑 패널 사용
             skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
             wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
             showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력    
             noDataMessage       : "No order found.",
             groupingMessage     : "Here groupping"
         };
	 
	 orderGridID = GridCommon.createAUIGrid("#order_grid_wrap", orderColumnLayout,'',gridPros);//Order Search List
 }

 //search Ajax
 function fn_getSearchResultJsonListAjax(){
	 
	 Common.ajax("GET", "/sales/ccp/selectsearchOrderNo",$("#_searchOrdForm").serialize(), function(result) {
         AUIGrid.setGridData(orderGridID, result);
     });
 }
 
 function fn_multiCombo(){
     $('#listAppType').change(function() {
         //console.log($(this).val());
     }).multipleSelect({
         selectAll: true, // 전체선택 
         width: '100%'
     });
     $('#listAppType').multipleSelect("checkAll");
 }
 
 $.fn.clearForm = function() {
	    return this.each(function() {
	        var type = this.type, tag = this.tagName.toLowerCase();
	        if (tag === 'form'){
	            return $(':input',this).clearForm();
	        }
	        if (type === 'text' || type === 'password' || type === 'hidden' || tag === 'textarea'){
	            this.value = '';
	        }else if (type === 'checkbox' || type === 'radio'){
	            this.checked = false;
	        }else if (tag === 'select'){
	            this.selectedIndex = -1;
	        }
	    });
	};
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>ORDER SEARCH</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="_closeOrdPop">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<ul class="right_btns mb10">
    <li><p class="btn_blue"><span class="search"></span><a href="#" id="_orderSearchBtn">Search</a></p></li>
    <li><p class="btn_blue"><span class="clear" ></span><a href="#" onclick="javascript:$('#_searchOrdForm').clearForm();">Clear</a></p></li>
</ul>
<form id="_searchOrdForm" method="get">
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:100px" />
    <col style="width:*" />
    <col style="width:140px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Order No</th>
    <td><input type="text" title="" placeholder="Order No" class="w100p" name="searchOrdNo" /></td>
    <th scope="row">App Type</th><!-- ASIS Source Not Exist -->
    <td>
    <select class="w100p" id="listAppType" name="searchOrdAppType"></select>
    </td>
    <th scope="row">Order Date</th>
    <td><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p"  name="searchOrdDate"/></td>
</tr>
<tr>
    <th scope="row">Customer Name</th>
    <td colspan="3"><input type="text" title="" placeholder="Customer Name" class="w100p"  name="searchOrdCustName"/></td>
    <th scope="row">NRIC/Comp No</th>
    <td><input type="text" title="" placeholder="NRIC/Company No" class="w100p"  name="searchOrdCustNric"/></td>
</tr>
</tbody>
</table><!-- table end -->
</form>
<section class="search_result"><!-- search_result start -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="order_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
