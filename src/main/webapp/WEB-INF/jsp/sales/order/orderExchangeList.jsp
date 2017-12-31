<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">

	//AUIGrid 생성 후 반환 ID
	var myGridID;
	var basicAuth = false;
	
    $(document).ready(function(){
        
        // AUIGrid 그리드를 생성합니다.
        createAUIGrid();
        
        AUIGrid.setSelectionMode(myGridID, "singleRow");
        
        // 셀 더블클릭 이벤트 바인딩
        AUIGrid.bind(myGridID, "cellDoubleClick", function(event){
            $("#soExchgId").val(event.item.soExchgId);
            $("#exchgType").val(event.item.soExchgTypeId);
            $("#exchgStus").val(event.item.soExchgStusId);
            $("#exchgCurStusId").val(event.item.soCurStusId);
            $("#salesOrderNo").val(event.item.salesOrdNo);
            $("#salesOrderId").val(event.item.soId);
            Common.popupDiv("/sales/order/orderExchangeDetailPop.do", $("#detailForm").serializeJSON());
        });
        // 셀 클릭 이벤트 바인딩
    
      //Basic Auth (update Btn)
        if('${PAGE_AUTH.funcChange}' == 'Y'){
            basicAuth = true;
        }
    });
    
    function createAUIGrid() {
        // AUIGrid 칼럼 설정
        
        // 데이터 형태는 다음과 같은 형태임,
        //[{"id":"#Cust0","date":"2014-09-03","name":"Han","country":"USA","product":"Apple","color":"Red","price":746400}, { .....} ];
        var columnLayout = [ {
                dataField : "codeName",
                headerText : "Type",
                width : 160,
                editable : false
            }, {
                dataField : "code",
                headerText : "Status",
                width : 100,
                editable : false
            }, {
                dataField : "salesOrdNo",
                headerText : "Order No",
                width : 120,
                editable : false
            }, {
                dataField : "salesDt",
                headerText : "Order Date",
                dataType : "date",
                formatString : "dd/mm/yyyy" ,
                width : 130,
                editable : false
            }, {
                dataField : "name",
                headerText : "Customer Name",
                editable : false
            },{
            	dataField : "nric1",
            	headerText : "NRIC/Company No",
            	width : 170,
            	editable : false
            },{
            	dataField : "soExchgCrtDt",
            	headerText : "Create Date",
            	width : 130,
            	editable : false
            },{
                dataField : "crtUserName",
                headerText : "Cearator",
                width : 140,
                editable : false
           },{
               dataField : "soExchgId",
               visible : false
           },{
               dataField : "soExchgTypeId",
               visible : false
           },{
               dataField : "soExchgStusId",
               visible : false
           },{
               dataField : "soCurStusId",
               visible : false
           },{
               dataField : "soId",
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
    
    //f_multiCombo 함수 호출이 되어야만 multi combo 화면이 안깨짐.
    doGetCombo('/common/selectCodeList.do', '56', '','cmbExcType', 'M' , 'f_multiCombo');    // Exchange Type Combo Box
    doGetCombo('/common/selectCodeList.do', '10', '','cmbAppType', 'M' , 'f_multiCombo');   // Application Type Combo Box
    
    // 조회조건 combo box
    function f_multiCombo(){
        $(function() {
            $('#cmbExcType').change(function() {
            
            }).multipleSelect({
                selectAll: true, // 전체선택 
                width: '80%'
            });
            $('#cmbAppType').change(function() {
                
            }).multipleSelect({
                selectAll: true, // 전체선택 
                width: '80%'
            });
           
            $('#cmbExcType').multipleSelect("checkAll");
            $('#cmbAppType').multipleSelect("checkAll");
        });
    }
    
    function fn_searchListAjax(){
    	Common.ajax("GET", "/sales/order/orderExchangeJsonList", $("#searchForm").serialize(), function(result) {
            AUIGrid.setGridData(myGridID, result);
        });
    }
    
    function fn_rawData(){
    	Common.popupDiv("/sales/order/orderExchangeRawDataPop.do", null, null, true);
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
<h2>Exchange List</h2>
<ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcView == 'Y'}">
    <li><p class="btn_blue"><a href="#" onClick="fn_searchListAjax()"><span class="search"></span>Search</a></p></li>
    </c:if>
    <li><p class="btn_blue"><a href="#" onclick="javascript:$('#searchForm').clearForm();"><span class="clear"></span>Clear</a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form id="detailForm" name="detailForm" method="post">
    <input type="hidden" id="soExchgId" name="soExchgId">
    <input type="hidden" id="exchgType" name="exchgType">
    <input type="hidden" id="exchgStus" name="exchgStus">
    <input type="hidden" id="exchgCurStusId" name="exchgCurStusId">
<!--     <input type="hidden" id="salesOrdNo" name="salesOrdNo"> -->
    <input type="hidden" id="salesOrderId" name="salesOrderId">
</form>
<form id="searchForm" name="searchForm" method="post">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Exchange Type</th>
    <td>
    <select id="cmbExcType" name="cmbExcType" class="multy_select w100p" multiple="multiple">
    </select>
    </td>
    <th scope="row">Exchange Status</th>
    <td>
    <select id="cmbExcStatus" name="cmbExcStatus" class="multy_select w100p" multiple="multiple">
        <option value="1" selected>Active</option>
        <option value="4">Complete</option>
        <option value="10">Cancel</option>
    </select>
    </td>
    <th scope="row">Request Date</th>
    <td>

    <div class="date_set w100p"><!-- date_set start -->
    <p><input type="text" id="startCrtDt" name="startCrtDt" title="Create start Date" value="${bfDay}" placeholder="DD/MM/YYYY" class="j_date" /></p>
    <span>To</span>
    <p><input type="text" id="endCrtDt" name="endCrtDt" title="Create end Date" value="${toDay}" placeholder="DD/MM/YYYY" class="j_date" /></p>
    </div><!-- date_set end -->

    </td>
</tr>
<tr>
    <th scope="row">Order Number</th>
    <td>
    <input type="text" id="salesOrdNo" name="salesOrdNo" title="" placeholder="Order Number" class="w100p" />
    </td>
    <th scope="row">Application Type</th>
    <td>
    <select id="cmbAppType" name="cmbAppType" class="multy_select w100p" multiple="multiple">
    </select>
    </td>
    <th scope="row">Requestor</th>
    <td>
    <input type="text" title="" id="crtUserName" name="crtUserName" placeholder="Requestor (Username)" class="w100p" />
    </td>
</tr>
<tr>
    <th scope="row">Customer ID</th>
    <td>
    <input type="text" title="" id="custId" name="custId" placeholder="Customer ID (Number Only)" class="w100p" />
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
</tbody>
</table><!-- table end -->

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
<dl class="link_list">
    <dt>Link</dt>
    <dd>
    <ul class="btns">
        <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
        <li><p class="link_btn type2"><a href="#" onClick="fn_rawData()">Exchange Raw Data</a></p></li>
        </c:if>
    </ul>
    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
    </dd>
</dl>
</aside><!-- link_btns_wrap end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start 

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
    <div id="list_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->
        
