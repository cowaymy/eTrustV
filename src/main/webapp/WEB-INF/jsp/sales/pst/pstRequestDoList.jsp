<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">

var optionUnit = { 
		id: "stusCodeId",              // 콤보박스 value 에 지정할 필드명.
        name: "codeName",
		isShowChoose: false,
		type : 'M'
};

var optionUnitS = { 
isSelectChoose: true,
type : 'S'
};


    //AUIGrid 생성 후 반환 ID
    var myGridID;
    
    var gridValue;
    
    $(document).ready(function(){
    
        // AUIGrid 그리드를 생성합니다.
        createAUIGrid();
        
        AUIGrid.setSelectionMode(myGridID, "singleRow");
        
        // 셀 더블클릭 이벤트 바인딩
        AUIGrid.bind(myGridID, "cellDoubleClick", function(event) {
        	$("#pstSalesOrdIdParam").val(event.item.pstSalesOrdId);
        	$("#pstDealerDelvryCntId").val(event.item.pstDealerDelvryCntId);
        	$("#pstDealerMailCntId").val(event.item.pstDealerMailCntId);
        	$("#pstDealerDelvryAddId").val(event.item.pstDealerDelvryAddId);
            $("#pstDealerMailAddId").val(event.item.pstDealerMailAddId);
        	$("#pstStusIdParam").val(event.item.pstStusId);
            Common.popupDiv("/sales/pst/getPstRequestDODetailPop.do", $("#searchForm").serializeJSON());
        });
        
        CommonCombo.make('pstStusIds', "/status/selectStatusCategoryCdList.do", {selCategoryId : '20'} , '', optionUnit);
        
        $('#pstStusId').multipleSelect("checkAll");
        
     // 셀 더블클릭 이벤트 바인딩
//        AUIGrid.bind(myGridID, "cellClick", function(event) {
//            gridValue =  AUIGrid.getCellValue(myGridID, event.rowIndex, "pstSalesOrdId");
//        });
    
    });
    
    doGetCombo('/common/selectCodeList.do', '357', '','cmbDealerType', 'S' , '');     // Dealer Type Combo Box
    
//    doGetCombo('/status/selectStatusCategoryCdList.do', '20', '','pstStusIds', 'S' , ''); 

    // 조회조건 combo box
    function f_multiCombo(){
        $(function() {
            $('#cmbDealerType').change(function() {
            
            }).multipleSelect({
               selectAll: true, // 전체선택 
                width: '80%'
            });
            $('#cmbDealerType').multipleSelect("checkAll");
        });
    }
    
    function createAUIGrid() {
    	// AUIGrid 칼럼 설정
    	
        // 데이터 형태는 다음과 같은 형태임,
        //[{"id":"#Cust0","date":"2014-09-03","name":"Han","country":"USA","product":"Apple","color":"Red","price":746400}, { .....} ];
        var columnLayout = [ {
                dataField : "pstRefNo",
                headerText : "PSO No",
                width : 140,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "dealerName",
                headerText : "Dealer Name",
                editable : false,
                style: 'left_style'
            }, {
                dataField : "pstCustPo",
                headerText : "Customer PO",
                width : 170,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "crtDt",
                headerText : "PSO Date",
                width : 160,
                dataType : "date",
                formatString : "dd/mm/yyyy" ,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "code1",
                headerText : "PSO Status",
                width : 170,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "pstSalesOrdId",
                visible : false
            }, {
                dataField : "pstStusId",
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
    
    
    // 리스트 조회.
    function fn_selectPstRequestDOListAjax() {        
        Common.ajax("GET", "/sales/pst/selectPstRequestDOJsonList", $("#searchForm").serialize(), function(result) {
            AUIGrid.setGridData(myGridID, result);
        }
        );
    }
    
//    function fn_goPstInfoEdit(){
//    	Common.popupWin("searchForm", "/sales/pst/getPstRequestDOEditPop.do?isPop=true&pstSalesOrdId=" + gridValue, option);
//    }
    
    function fn_insertPstRequestDOReq(){
    	$("#dealerTypeFlag").val('REQ');
    	Common.popupDiv("/sales/pst/insertPstRequestDOPop.do", $("#searchForm").serializeJSON(), null , true, '_newDiv');
    }
    
    function fn_insertPstRequestDORet(){
    	$("#dealerTypeFlag").val('RET');
        Common.popupDiv("/sales/pst/insertPstRequestDOPop.do", $("#searchForm").serializeJSON(), null , true, '_newDiv');
    }
    
    function fn_pstReport(){
        Common.alert('The program is under development.');
        //Common.popupDiv("/sales/pst/reportPstRequestDOPop.do", $("#searchForm").serializeJSON(), null , true, '_newDiv');
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
    
    function fn_dealerToPst(){
    	
    	if(searchForm.cmbDealerType.value == 0){
    		return false;
    	}
    	
//    	doGetCombo('/common/selectCodeList.do', '358', $("#cmbDealerType").val(),'cmbPstType', 'M' , '');         // PST Type Combo Box
//    	CommonCombo.make('cmbPstType', '/common/selectCodeList.do', {codeId : $("#cmbDealerType").val()} , '', {type: 'M'});
    	CommonCombo.make("cmbPstType", "/sales/pst/pstTypeCmbJsonList", {groupCode : $("#cmbDealerType").val()} , '' , optionUnit); //Status
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
<h2>PST Request Do List</h2>
<ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_insertPstRequestDOReq()">NEW PST Request</a></p></li>
    </c:if>
    <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_insertPstRequestDORet()">NEW PST Return</a></p></li>
    </c:if>
    <c:if test="${PAGE_AUTH.funcView == 'Y'}">
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_selectPstRequestDOListAjax()"><span class="search"></span>Search</a></p></li>
    </c:if>
    <li><p class="btn_blue"><a href="#" onclick="javascript:$('#searchForm').clearForm();"><span class="clear"></span>Clear</a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form id="popForm" name="popForm" method="post">
    <input type="hidden" name="dealerId"  id="_dealerId"/>  <!-- Cust Id  -->
    <input type="hidden" name="dealerAddId"   id="_dealerAddId"/><!-- Address Id  -->
    <input type="hidden" name="dealerCntId"   id="_dealerCntId"> <!--Contact Id  -->
</form>
<form id="searchForm" name="searchForm" action="#" method="get">
    <input type="hidden" id="pstSalesOrdIdParam" name="pstSalesOrdIdParam" >
    <input type="hidden" id="pstDealerDelvryCntId" name="pstDealerDelvryCntId" >
    <input type="hidden" id="pstDealerMailCntId" name="pstDealerMailCntId" >
    <input type="hidden" id="pstDealerDelvryAddId" name="pstDealerDelvryAddId" >
    <input type="hidden" id="pstDealerMailAddId" name="pstDealerMailAddId" >
    <input type="hidden" id="pstStusIdParam" name="pstStusIdParam" >
    <input type="hidden" id="dealerTypeFlag" name="dealerTypeFlag" >
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
    <th scope="row">PSO No</th>
    <td><input type="text" title="" id=pstRefNo name="pstRefNo" placeholder="PSO Number" class="w100p" /></td>
    <th scope="row">PSO Status</th>
    <td>
    <select class="multy_select w100p" id="pstStusIds" name="pstStusId" multiple="multiple">
    </select>
    </td>
    <th scope="row">Create Date</th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input type="text" id="createStDate" name="createStDate" title="Create start Date" value="${toDay}" placeholder="DD/MM/YYYY" class="j_date" /></p>
    <span>To</span>
    <p><input type="text" id="createEnDate" name="createEnDate" title="Create end Date" value="${toDay}" placeholder="DD/MM/YYYY" class="j_date" /></p>
    </div><!-- date_set end -->
    </td>
</tr>
<tr>
    <th scope="row">Dealer ID</th>
    <td><input type="text" title="" id="pstDealerId" name="pstDealerId" placeholder="Dealer ID (Number Only)" class="w100p" /></td>
    <th scope="row">Dealer Name</th>
    <td><input type="text" title="" id="dealerName" name="dealerName" placeholder="Dealer Name" class="w100p" /></td>
    <th scope="row">NRIC/Company No</th>
    <td><input type="text" title="" id="pstNric" name="pstNric" placeholder="NRIC/Company Number" class="w100p" /></td>
</tr>
<tr>
    <th scope="row">Dealer Type</th>
    <td>
        <select class="select w100p" id="cmbDealerType" name="cmbDealerType" onchange="fn_dealerToPst()"></select>
    </td>
    <th scope="row">PST Type</th>
    <td>
        <select class="multy_select w100p" multiple="multiple" id="cmbPstType" name="cmbPstType" ></select>
    </td>
    <th scope="row"></th>
    <td></td>
</tr>
<tr>
    <th scope="row">Customer PO</th>
    <td><input type="text" title="" id="pstCustPo" name="pstCustPo" placeholder="PO Number" class="w100p" /></td>
    <th scope="row">Person In Charge</th>
    <td><input type="text" title="" id="pInCharge" name="pInCharge" placeholder="Person In Charge" class="w100p" /></td>
    <th scope="row"></th>
    <td></td>
</tr>
</tbody>
</table><!-- table end -->
</form>

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
<dl class="link_list">
    <dt>Link</dt>
    <dd>
    <ul class="btns">
        <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
        <li><p class="link_btn"><a href="#" onClick="fn_pstReport()">PST Report</a></p></li>
        </c:if>
    </ul>
    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
    </dd>
</dl>
</aside><!-- link_btns_wrap end -->

</section><!-- search_table end -->

<section class="search_result"><!-- search_result start 

<ul class="right_btns">
    <li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
    <li><p class="btn_grid"><a href="#">DEL</a></p></li>
    <li><p class="btn_grid"><a href="#">INS</a></p></li>
    <li><p class="btn_grid"><a href="#">ADD</a></p></li>
</ul>
-->
<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="list_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->