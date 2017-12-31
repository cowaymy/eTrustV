<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">
//AUIGrid 생성 후 반환  ID
var calGrid;

//Window Option
var option = {
        width: "1000px", // 창 가로 크기
        height: "520px" // 창 세로 크기
         }
$(document).ready(function() {
	
	createCalGrid();   
	
	doGetCombo('/sales/ccp/getBranchCodeList', '', '','_keyInBranch', 'M' , 'f_multiCombo'); //Branch
	doGetCombo('/sales/ccp/selectDscCodeList', '', '','_keyInDscBranch', 'S' , 'f_multiCombo'); //Branch
	doGetProductCombo('/common/selectProductCodeList.do', '', '', 'listProductId', 'S'); //Product Code
	doGetCombo('/common/selectCodeList.do', '51', '',  '_calCcpType', 'S'); // CCP Type Id
	doGetCombo('/common/selectCodeList.do', '53', '',  '_calScheme', 'S'); // Scheme Type Id
	doGetCombo('/sales/ccp/selectReasonCodeFbList', '', '','_reasonCode', 'M' , 'f_multiCombo'); //Reason
	
	//Search
	$("#_calSearch").click(function() {
		
		Common.ajax("GET", "/sales/ccp/selectCalCcpListAjax", $("#_searchForm").serialize(), function(result) {
			   AUIGrid.setGridData(calGrid, result); 
		   });
	});
	
	
	//Edit
	 // 셀 더블클릭 이벤트 바인딩
    AUIGrid.bind(calGrid, "cellDoubleClick", function(event){
    	
    	if('${PAGE_AUTH.funcChange}' == 'Y'){
    		if(event.item.ccpStusId == 1){
                $("#_ccpId").val(event.item.ccpId);
                $("#_salesOrdId").val(event.item.salesOrdId);
                $("#_ccpTotScrePoint").val(event.item.ccpTotScrePoint);
                //Common.popupDiv("/sales/ccp/selectCalCcpViewEditPop.do", $("#_detailForm").serializeJSON(), null , true , '_viewEditDiv'); //Edit
               
                Common.popupWin('_detailForm', "/sales/ccp/selectCalCcpViewEditPop.do", option);
                
            }else{
                $("#_ccpId").val(event.item.ccpId);
                $("#_salesOrdId").val(event.item.salesOrdId);
                $("#_ccpTotScrePoint").val(event.item.ccpTotScrePoint);
                //Common.popupDiv("/sales/ccp/ccpCalCCpViewPop.do", $("#_detailForm").serializeJSON(), null , true , '_viewDiv'); //View
                
                Common.popupWin('_detailForm', "/sales/ccp/ccpCalCCpViewPop.do", option);
            }
    	}else{
    		Common.alert("access deny.");
    	}
    });
	
	//Update Pay Channel (_updPayBtn)############################### Pay
	$("#_updPayBtn").click(function() {
		//Validation 
		var selectedItem = AUIGrid.getSelectedItems(calGrid);
		if(selectedItem.length <= 0){
			Common.alert(" No result selected. ");
            return;
		}
		
		if(selectedItem[0].item.ccpStusId != 1){
			Common.alert("CCP Status not in active .");
			return;
		}
		
		//PopUp
		$("#_salesOrdId").val(selectedItem[0].item.salesOrdId);
        Common.popupDiv("/sales/order/orderRentPaySetLimitPop.do", $("#_detailForm").serializeJSON(), null , true , '_editDiv');
	});
	
	//Update Cust Limit Info  (_updCustBtn)  ######################## Cust
	$("#_updCustBtn").click(function() {
        //Validation 
        var selectedItem = AUIGrid.getSelectedItems(calGrid);
        if(selectedItem.length <= 0){
            Common.alert(" No result selected. ");
            return;
        }
        
        if(selectedItem[0].item.ccpStusId != 1){
            Common.alert("CCP Status not in active .");
            return;
        }
        
        //PopUp
        $("#_custId").val(selectedItem[0].item.custId);
        Common.popupDiv("/sales/customer/updateCustomerBasicInfoLimitPop.do", $("#_detailForm").serializeJSON(), null , true , '_editDiv6');
    });
	
});//Doc Ready Func End

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

function createCalGrid(){
	
	var  columnLayout = [
	                     {dataField : "salesOrdNo", headerText : "Order<br/>No", width : "7%" , editable : false},
	                     {dataField : "ccpIsHold", headerText : "Hold", width : "4%" , editable : false,
	                       renderer : {type : "CheckBoxEditRenderer", editable : false , checkValue : true , unCheckValue : false}
	                     },
	                     {dataField : "refNo", headerText : "Order<br/>Ref No", width : "7%" , editable : false},
	                     {dataField : "name1", headerText : "Branch", width : "7%" , editable : false},
	                     {dataField : "keyAt", headerText : "Key At<br/>(By)", width : "10%" , editable : false},
	                     {dataField : "name", headerText : "Customer<br/> Name", width : "9%" , editable : false},
	                     {dataField : "ccpTotScrePoint", headerText : "Total<br/> Point", width : "7%" , editable : false},
	                     {dataField : "ccpStatus", headerText : "CCP<br/>Status", width : "7%" , editable : false},
	                     {dataField : "name2", headerText : "CCP<br/> Reject<br/> Status", width : "7%" , editable : false},
	                     {dataField : "ccpRem", headerText : "CCP<br/> Remark", width : "15%" , editable : false},
	                     {dataField : "resnDesc", headerText : "Special <br/>Remark", width : "10%" , editable : false},
	                     {dataField : "updAt", headerText : "Last<br/> Update At <br/>(By)", width : "10%" , editable : false},
	                     {dataField : "ccpId", visible : false},
	                     {dataField : "salesOrdId", visible : false},
	                     {dataField : "ccpStusId", visible : false}, 
	                     {dataField : "ccpTotScrePoint", visible : false},
	                     {dataField : "custId", visible : false}
	                     
	]
	
	//그리드 속성 설정
    var gridPros = {
            usePaging           : true,         //페이징 사용
            pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)            
            editable            : false,            
            fixedColumnCount    : 1,            
            showStateColumn     : false,             
            displayTreeOpen     : false,            
//            selectionMode       : "singleRow",  //"multipleCells",            
            headerHeight        : 60,
            useGroupingPanel    : false,        //그룹핑 패널 사용
            skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력    
            noDataMessage       : "No order found.",
            groupingMessage     : "Here groupping",
            wordWrap :  true
        };
	
	calGrid = GridCommon.createAUIGrid("cal_grid_wrap", columnLayout,'', gridPros);
	
}

// 조회조건 combo box
function f_multiCombo(){
    $(function() {
        $('#_keyInBranch').change(function() {
        
        }).multipleSelect({
            selectAll: true, // 전체선택 
            width: '80%'
        });
        $('#_reasonCode').change(function() {
            
        }).multipleSelect({
            selectAll: true, // 전체선택 
            width: '80%'
        });
       
    });
}

//TODO 미개발
function fn_underDevelop(){
    Common.alert('The program is under development.');
}

function popup(location){
    if(location == "listing"){
        Common.popupDiv("/sales/ccp/ccpCalListingPop.do", $("#_searchForm").serializeJSON(), null, true); 
    }else if(location == 'rawData'){
    	Common.popupDiv("/sales/ccp/ccpCalRawDataPop.do", $("#_searchForm").serializeJSON(), null, true); 
    }else if(location == 'performance'){
    	Common.popupDiv("/sales/ccp/ccpCalPerformancePop.do", $("#_searchForm").serializeJSON(), null, true);
    }
    
}

</script>
<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Sales</li>
    <li>Order list</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Customer Credibility Point List</h2>
<ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
    <li><p class="btn_blue type2"><a id="_updPayBtn">Update Payment Channel</a></p></li>
    </c:if>
    <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}"> 
    <li><p class="btn_blue type2"><a id="_updCustBtn">Update Customer Info</a></p></li>
    </c:if>
    <c:if test="${PAGE_AUTH.funcView == 'Y'}">
    <li><p class="btn_blue type2"><a id="_calSearch"><span class="search"></span>Search</a></p></li>
    </c:if>
    <li><p class="btn_blue type2"><a href="#" onclick="javascript:$('#_searchForm').clearForm();"><span class="clear"></span>Clear</a></p></li>
</ul>
</aside><!-- title_line end -->
<form id="_detailForm">
    <input type="hidden" name="ccpId" id="_ccpId">
    <input type="hidden" name="salesOrdId" id="_salesOrdId">
    <input type="hidden" name="ccpTotScrePoint" id="_ccpTotScrePoint">
    <input type="hidden" name="custId" id="_custId">
    
    <input type="hidden" name="useDisable" value="1">
    
</form>

<section class="search_table"><!-- search_table start -->
<form id="_searchForm">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Order No.</th>
    <td><input type="text" title="" placeholder="" class="w100p"  name="calOrdNo"/></td>
    <th scope="row">Order Date</th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" name="calStartDate"/></p>
    <span>To</span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date"  name="calEndDate"/></p>
    </div><!-- date_set end -->
    </td>
    <th scope="row">CCP Status<span class="must">*</span></th>
    <td>
    <select class="multy_select w100p" multiple="multiple" name="calCcpStatus">
        <option value="1" selected="selected">Active</option>
        <option value="5">Approved</option>
        <option value="4">Rejected</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Branch</th>
    <td>
    <select class="multy_select w100p" multiple="multiple" name="calBranch" id="_keyInBranch"></select>
    </td>
    <th scope="row">DSC Branch</th>
    <td>
    <select class="w100p" name="calDscBranch" id="_keyInDscBranch"></select>
    </td>
    <th scope="row">Customer Name</th>
    <td><input type="text" title="" placeholder="" class="w100p"  name="calCustName"/></td>
</tr>
<tr>
    <th scope="row">NRIC/Company No</th>
    <td><input type="text" title="" placeholder="" class="w100p"  name="calNric"/></td>
    <th scope="row">Action Point</th>
    <td>
    <select class="w100p" name="calActPoint">
        <option value="">Choose One</option>
        <option value="1">No Action Point</option>
    </select>
    </td>
    <th scope="row">Product</th>
    <td>
    <select class="w100p" id="listProductId" name="calProductId"></select>
    </td>
</tr>
<tr>
    <th scope="row">CCP Type</th>
    <td>
    <select class="w100p" name="calCcpType" id="_calCcpType"></select>
    </td>
    <th scope="row">Scheme Type</th>
    <td>
    <select class="w100p" name="calScheme" id="_calScheme"></select>
    </td>
    <th scope="row">Order Ref No</th>
    <td><input type="text" title="" placeholder="" class="w100p"  name="calOrdRefNo"/></td>
</tr>
<tr>
    <th scope="row">Region</th>
    <td>
    <select class="w100p" name="calRegion" id="_calRegion">
        <option value="">Choose one</option>
        <option value="651">Central</option>
        <option value="652">Northern</option>
        <option value="654">Central A</option>
        <option value="655">Central B</option>
    </select>
    </td>
    <th scope="row">CCP F/B Code</th>
    <td>
    <select class="multy_select w100p" multiple="multiple" id="_reasonCode" name="calReason"></select>
    </td>
    <th scope="row">Last Update User</th>
    <td><input type="text" title="" placeholder="" class="w100p" name="calUpdator"/></td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
<dl class="link_list">
    <dt>Link</dt>
    <dd>
    <ul class="btns">
        <c:if test="${PAGE_AUTH.funcUserDefine3 == 'Y'}">
        <li><p class="link_btn"><a href="#" onclick="javascript : popup('listing')">Listing</a></p></li>
        </c:if>
        <c:if test="${PAGE_AUTH.funcUserDefine3 == 'Y'}">
        <li><p class="link_btn"><a href="#" onclick="javascript : popup('rawData')">RAW Data</a></p></li>
        </c:if>
        <c:if test="${PAGE_AUTH.funcUserDefine3 == 'Y'}">
        <li><p class="link_btn"><a href="#" onclick="javascript : popup('performance')">Performance</a></p></li>
        </c:if>
    </ul>
    <ul class="btns">
    </ul>
    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
    </dd>
</dl>
</aside><!-- link_btns_wrap end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<!-- <ul class="right_btns">
    <li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
    <li><p class="btn_grid"><a href="#">DEL</a></p></li>
    <li><p class="btn_grid"><a href="#">INS</a></p></li>
    <li><p class="btn_grid"><a href="#">ADD</a></p></li>
</ul> -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="cal_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->
</body>
</html>