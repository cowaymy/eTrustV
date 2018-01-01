<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<style type="text/css">

/* 커스텀 행 스타일 */
.my-yellow-style {
    background:#FFE400;
    font-weight:bold;
    color:#22741C;
}

.my-pink-style {
    background:#FFA7A7;
    font-weight:bold;
    color:#22741C;
}

.my-green-style {
    background:#86E57F;
    font-weight:bold;
    color:#22741C;
}
</style>
<script type="text/javaScript">
	//AUIGrid 생성 후 반환 ID
	var myGridID;
	
	$(document).ready(function() {

        // AUIGrid 그리드를 생성합니다.
        createAUIGrid();

      //AUIGrid.setSelectionMode(myGridID, "singleRow");
        
        // 셀 더블클릭 이벤트 바인딩
        AUIGrid.bind(myGridID, "cellDoubleClick", function(event) {
            $("#salesOrderId").val(event.item.ordId);
            Common.popupDiv("/sales/order/orderDetailPop.do", $("#searchForm").serializeJSON(), null, true, 'dtPop');
        });
        // 셀 클릭 이벤트 바인딩
        
        if($("#memType").val() == 1){
            $("#grpCode").removeAttr("readonly");
        }else if($("#memType").val() == 2){
            $("#grpCode").attr("readonly");
            $("#grpCode").val($("#initGrpCode").val());
            $("#grpCode").attr("class", "w100p readonly");
        }
        
        CommonCombo.make('cmbAppType', '/common/selectCodeList.do', {groupCode : 10} , '', {type: 'M'});
    });
	
	function createAUIGrid() {
        // AUIGrid 칼럼 설정
        
        // 데이터 형태는 다음과 같은 형태임,
        //[{"id":"#Cust0","date":"2014-09-03","name":"Han","country":"USA","product":"Apple","color":"Red","price":746400}, { .....} ];
        var columnLayout = [ {
                dataField : "ordNo",
                headerText : "Order No",
                width : 80,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "ordDt",
                headerText : "Order Date",
                width : 90,
                dataType : "date",
                formatString : "dd/mm/yyyy" ,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "stusCode",
                headerText : "Order Status",
                width : 100,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "appTypeCode",
                headerText : "App Type",
                width : 80,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "custName",
                headerText : "Customer Name",
                width : 120,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "stkCode",
                headerText : "Product",
                width : 150,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "salesmanCode",
                headerText : "Salesman",
                width : 100,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "installStus",
                headerText : "Install </br>Status",
                width : 100,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "installFailResn",
                headerText : "Fail </br> Reason",
                width : 140,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "rsCnvrCnfmDt",
                headerText : "Net </br>Month",
                width : 100,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "orgCode",
                headerText : "Org Code",
                width : 100,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "grpCode",
                headerText : "Grp Code",
                width : 100,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "deptCode",
                headerText : "Dept</br>Code",
                width : 100,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "comDt",
                headerText : "Com Date",
                width : 90,
                dataType : "date",
                formatString : "dd/mm/yyyy" ,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "payComDt",
                headerText : "Pay Date",
                width : 90,
                dataType : "date",
                formatString : "dd/mm/yyyy" ,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "ordId",
                visible : false
            }];

     // 그리드 속성 설정
        var gridPros = {
            
            // 페이징 사용       
            usePaging : true,
            // 한 화면에 출력되는 행 개수 20(기본값:20)
            pageRowCount : 20,
            editable : true,
            fixedColumnCount : 1,
            showStateColumn : false, 
            displayTreeOpen : true,
            selectionMode : "multipleCells",
            headerHeight : 30,
            // 그룹핑 패널 사용
            useGroupingPanel : false,
            // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            skipReadonlyColumns : true,
            // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            wrapSelectionMove : true,
            // 줄번호 칼럼 렌더러 출력
            showRowNumColumn : false,
        
            groupingMessage : "Here groupping"
        };
        
        //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
        myGridID = AUIGrid.create("#list_grid_wrap", columnLayout, gridPros);
    }
    
    function fn_searchListAjax(){
        if( $("#netSalesMonth").val() ==""  &&  $("#createStDate").val() ==""  &&  $("#createEnDate").val() ==""  ){
            Common.alert("You must key-in at least one of Order Date / Net Sales Month");
             return ;
         }
         
        Common.ajax("GET", "/sales/order/orderColorGridJsonList", $("#searchForm").serialize(), function(result) {
            AUIGrid.setGridData(myGridID, result);
            
            AUIGrid.setProp(myGridID, "rowStyleFunction", function(rowIndex, item) {
                if(item.stusId == 4) {
                	if(item.isNet == 1){
                		return "my-green-style";
                	}else{
                		return "my-yellow-style";
                	}
                       
                }else if(item.stusId == 10){
                	return "my-pink-style";
                }else{
                	return "";
                }

             }); 

             // 변경된 rowStyleFunction 이 적용되도록 그리드 업데이트
             AUIGrid.update(myGridID);
        });
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

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Sales</li>
    <li>Order list</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Color Grid</h2>
<ul class="right_btns">
    <li><p class="btn_blue"><a href="#" onClick="fn_searchListAjax()"><span class="search"></span>Search</a></p></li>
    <li><p class="btn_blue"><a href="#" onclick="javascript:$('#searchForm').clearForm();"><span class="clear"></span>Clear</a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form id="searchForm" name="searchForm" method="post">
    <input type="hidden" id="salesOrderId" name="salesOrderId">
    <input type="hidden" name="memType" id="memType" value="${memType }"/>
    <input type="hidden" name="initGrpCode" id="initGrpCode" value="${grpCode }"/>
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:170px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Organization Code</th>
    <td>
    <input type="text" title="" id="orgCode" name="orgCode" value="${orgCode }" placeholder="Organization Code" class="w100p readonly" />
    </td>
    <th scope="row">Group Code</th>
    <td>
    <input type="text" title="" id="grpCode" name="grpCode" placeholder="Group Code" class="w100p" />
    </td>
    <th scope="row">Department Code</th>
    <td>
    <input type="text" title="" id="deptCode" name="deptCode" placeholder="Department Code" class="w100p" />
    </td>
</tr>
<tr>
    <th scope="row">Order No</th>
    <td>
    <input type="text" title="" id="ordNo" name="ordNo" placeholder="Order Number" class="w100p" />
    </td>
    <th scope="row">Customer Name</th>
    <td>
    <input type="text" title="" id="custName" name="custName" placeholder="Customer Name" class="w100p" />
    </td>
    <th scope="row">NRIC/Company No</th>
    <td>
    <input type="text" title="" id="custIc" name="custIc" placeholder="NRIC/Company Number" class="w100p" />
    </td>
</tr>
<tr>
    <th scope="row">Application Type</th>
    <td>
    <select class="multy_select w100p" id="cmbAppType" name="cmbAppType" multiple="multiple">
    </select>
    </td>
    <th scope="row">Order Date</th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input type="text" title="Create start Date" id="createStDate" name="createStDate" placeholder="DD/MM/YYYY" class="j_date" /></p>
    <span>To</span>
    <p><input type="text" title="Create end Date" id="createEnDate" name="createEnDate" placeholder="DD/MM/YYYY" class="j_date" /></p>
    </div><!-- date_set end -->
    </td>
    <th scope="row">Product</th>
    <td>
    <select class="w100p" id="cmbProduct" name="cmbProduct">
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Net Sales Month</th>
    <td><input type="text" title="기준년월" id="netSalesMonth" name="netSalesMonth" placeholder="MM/YYYY" class="j_date2 w100p" /></td>
    <th scope="row">Salesman Code</th>
    <td>
    <input type="text" title="" id="salesmanCode" name="salesmanCode" placeholder="Salesman (Member Code)" class="w100p" />
    </td>
    <th scope="row">Contact Number</th>
    <td>
    <input type="text" title="" id="contactNum" name="contactNum" placeholder="Contact Number" class="w100p" />
    </td>
</tr>
<tr>
    <th scope="row">Condition</th>
    <td>
    <select class="w100p" id="cmbCondition" name="cmbCondition">
        <option value="">Choose One</option>
        <option value="1">Active</option>
        <option value="2">Cancel</option>
        <option value="3">Net Sales</option>
        <option value="4">Yellow Sheet</option>
        <option value="5">Install Failed</option>
        <option value="6">Install Active</option>
    </select>
    </td>
    <th scope="row">Promotion Code</th>
    <td>
    <input type="text" title="" id="promoCode" name="promoCode" placeholder="Promotion Code" class="w100p" />
    </td>
    <th scope="row"></th>
    <td></td>
</tr>
<tr>
    <th scope="row" colspan="6" ><span class="must"> You must key-in at least one of Order Date / Net Sales Month</span>  </th>
</tr>
</tbody>
</table><!-- table end -->

<aside class="link_btns_wrap"><!-- link_btns_wrap start --
<p class="show_btn"><a href="#"><img src="../images/common/btn_link.gif" alt="link show" /></a></p>
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
    <p class="hide_btn"><a href="#"><img src="../images/common/btn_link_close.gif" alt="hide" /></a></p>
    </dd>
</dl>
</aside> link_btns_wrap end -->

</form>
</section><!-- search_table end -->

<ul class="left_btns">
    <li><span class="green_text">Net Sales</span></li>
    <li><span class="pink_text">Cancel</span></li>
    <li><span class="yellow_text">Complete With Unnet</span></li>
    <li><span class="black_text">Active</span></li>
</ul>

<section class="search_result"><!-- search_result start -->
<!-- 
<ul class="right_btns">
    <li><p class="btn_grid"><a href="#">EDIT</a></p></li>
    <li><p class="btn_grid"><a href="#">NEW</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
    <li><p class="btn_grid"><a href="#">DEL</a></p></li>
    <li><p class="btn_grid"><a href="#">INS</a></p></li>
    <li><p class="btn_grid"><a href="#">ADD</a></p></li>
</ul>
 -->
<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="list_grid_wrap" style="width: 100%; height: 480px; margin: 0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->