<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">

var optionUnit = {
	id: "stusCodeId",              // 콤보박스 value 에 지정할 필드명.
    name: "codeName",
    isShowChoose: false,
    type : 'M'
};

	//AUIGrid 생성 후 반환 ID
	var myGridID;

	$(document).ready(function(){
		
		// AUIGrid 그리드를 생성합니다.
        createAUIGrid();
        
      //AUIGrid.setSelectionMode(myGridID, "singleRow");
        
        // 셀 더블클릭 이벤트 바인딩
        AUIGrid.bind(myGridID, "cellDoubleClick", function(event) {
            $("#paramDealerId").val(event.item.dealerId);
            Common.popupDiv("/sales/pst/pstDealerDetailPop.do", $("#searchForm").serializeJSON());
        });
 
        CommonCombo.make('cmbDealerStus', "/status/selectStatusCategoryCdList.do", {selCategoryId : 21} , '', optionUnit);
        $('#cmbDealerStus').multipleSelect("checkAll");
 
	});
	
	doGetCombo('/common/selectCodeList.do', '357', '','cmbDealerType', 'M' , 'f_multiCombo');     // Dealer Type Combo Box
	
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
        var columnLayout = [ {
                dataField : "dealerName",
                headerText : "Dealer Name",
                editable : false,
                style: 'left_style'
            }, {
                dataField : "code2",
                headerText : "Status",
                width : 140,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "cntName",
                headerText : "Contact Name",
                width : 230,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "telM1",
                headerText : "Contact No",
                width : 160,
                editable : false,
                style: 'left_style'
            },{
                dataField : "dealerId",
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
            showRowNumColumn : true,
        
            groupingMessage : "Here groupping"
        };
        
        //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
        myGridID = AUIGrid.create("#list_grid_wrap", columnLayout, gridPros);
    }
	
	// 리스트 조회.
    function fn_pstDealerListAjax() {        
        Common.ajax("GET", "/sales/pst/pstDealerJsonList", $("#searchForm").serialize(), function(result) {
            AUIGrid.setGridData(myGridID, result);
        }
        );
    }
	
	function fn_new(){
        Common.popupDiv("/sales/pst/pstDealerNewPop.do", $("#searchForm").serializeJSON(), null, true, 'newPop');
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
<h2>PST Dealer View</h2>
<ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
    <li><p class="btn_blue"><a href="#" onclick="fn_new();"><span class="new"></span>New</a></p></li>
    </c:if>
    <c:if test="${PAGE_AUTH.funcView == 'Y'}">
    <li><p class="btn_blue"><a href="#" onclick="fn_pstDealerListAjax();"><span class="search"></span>Search</a></p></li>
    </c:if>
    <li><p class="btn_blue"><a href="#"><span class="clear"></span>Clear</a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form id="popForm" name="popForm" method="post">
    <input type="hidden" name="dealerId"  id="_dealerId"/>  <!-- Cust Id  -->
    <input type="hidden" name="dealerAddId"   id="_dealerAddId"/><!-- Address Id  -->
    <input type="hidden" name="dealerCntId"   id="_dealerCntId"> <!--Contact Id  -->
</form>
<form id="searchForm" name="searchForm" method="post">
<input type="hidden" id="paramDealerId" name="paramDealerId">
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
    <th scope="row">Dealer ID</th>
    <td><input type="text" id="pstDealerId" name="pstDealerId" title="" placeholder="" class="w100p" /></td>
    <th scope="row">Dealer Name</th>
    <td><input type="text" id="pstDealerName" name="pstDealerName" title="" placeholder="" class="w100p" /></td>
    <th scope="row">Contact Name</th>
    <td><input type="text" id="pstCntName" name="pstCntName" title="" placeholder="" class="w100p" /></td>
</tr>
<tr>
    <th scope="row">Dealer Type</th>
    <td>
        <select class="multy_select w100p" id="cmbDealerType" name="cmbDealerType" multiple="multiple"></select>
    </td>
    <th scope="row">Status</th>
    <td>
	    <select class="multy_select w100p" id="cmbDealerStus" name="cmbDealerStus" multiple="multiple">
	    </select>
    </td>
    <th scope="row"></th>
    <td></td>
</tr>
</tbody>
</table><!-- table end -->
</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->
<!-- 
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