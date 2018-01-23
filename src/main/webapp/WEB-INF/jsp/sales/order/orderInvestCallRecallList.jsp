<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
    //AUIGrid 생성 후 반환 ID
	var myGridID;
	var basicAuth = false;
	
	$(document).ready(function(){
	    
	    // AUIGrid 그리드를 생성합니다.
	    createAUIGrid();
	    
	    //AUIGrid.setSelectionMode(myGridID, "singleRow");
	    
	    // 셀 더블클릭 이벤트 바인딩
	    AUIGrid.bind(myGridID, "cellDoubleClick", function(event){
	        $("#invId").val(event.item.invId);
	        Common.popupDiv("/sales/order/orderInvestCallResultDtPop.do", $("#detailForm").serializeJSON(), null, true, 'savePop');
	    });
	    

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
	            dataField : "invNo",
	            headerText : "Investigate No.",
	            editable : false
	        }, {
	            dataField : "name",
	            headerText : "Investigate Status",
	            width : 200,
	            editable : false
	        }, {
	            dataField : "salesOrdNo",
	            headerText : "Order No.",
	            width : 200,
	            editable : false
	        }, {
	            dataField : "userName",
	            headerText : "Investigate By",
	            width : 200,
	            editable : false
	        }, {
	            dataField : "invCrtDt",
	            headerText : "Investigate At",
	            dataType : "date",
                formatString : "dd-mm-yyyy" ,
	            width : 200,
	            editable : false
	        }, {
                dataField : "invId",
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
	        showStateColumn : true, 
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
	    myGridID = AUIGrid.create("#list_grid_wrap", columnLayout,"", gridPros);
	}
	
	// 리스트 조회.
    function fn_investCallResultListAjax() {        
        Common.ajax("GET", "/sales/order/investCallResultJsonList", $("#searchForm").serialize(), function(result) {
            AUIGrid.setGridData(myGridID, result);
        }
        );
    }
	
    function fn_rawData(){
        Common.alert('The program is under development.');
    }
	
    $.fn.clearForm = function() {
        return this.each(function() {
            var type = this.type, tag = this.tagName.toLowerCase();
            if (tag === 'form'){
                return $(':input',this).clearForm();
            }
            if (type === 'text' || type === 'password' || type === 'hidden' || tag === 'textarea'){
                this.value = '';
                this.text='';
            }else if (type === 'checkbox' || type === 'radio'){
                this.checked = false;
                this.text='';
            }else if (tag === 'select'){
                this.selectedIndex = -1;
                this.text='';
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
<h2>Order Investigation Call/Result Search</h2>
<ul class="right_opt">
    <!-- <li><p class="btn_blue"><a href="#">Call/Result Detail</a></p></li> -->
    <li><p class="btn_blue"><a href="#" onClick="fn_investCallResultListAjax()"><span class="search"></span>Search</a></p></li>
    <li><p class="btn_blue"><a href="#" onclick="javascript:$('#searchForm').clearForm();"><span class="clear"></span>Clear</a></p></li>
</ul>
</aside><!-- title_line end -->

<form id="detailForm" name="detailForm" method="post">
    <input type="hidden" id="invId" name="invId">
</form>
<section class="search_table"><!-- search_table start -->
<form id="searchForm" name="searchForm" method="post">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:190px" />
    <col style="width:*" />
    <col style="width:190px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Investigate No.</th>
    <td>
    <input type="text" id="invNo" name="invNo" title="" placeholder="" class="" />
    </td>
    <th scope="row">Investigate Date</th>
    <td>
    <div class="date_set"><!-- date_set start -->
    <p><input type="text" id="startCrtDt" name="startCrtDt" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
    <span>To</span>
    <p><input type="text" id="endCrtDt" name="endCrtDt" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
    </div><!-- date_set end -->
    </td>
</tr>
<tr>
    <th scope="row">Order No.</th>
    <td>
    <input type="text" id="salesOrdNo" name="salesOrdNo" title="" placeholder="" class="" />
    </td>
    <th scope="row">Investigate Status</th>
    <td>
    <select class="multy_select" id="invStusId" name="invStusId" multiple="multiple">
        <option value="1">Active</option>
        <option value="29">Investigate</option>
        <option value="28">Regular</option>
        <option value="2">Suspend</option>
    </select>
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
        <li><p class="link_btn type2"><a href="#"  onClick="fn_rawData()">Application Form</a></p></li>
        <li><p class="link_btn type2"><a href="#"  onClick="fn_rawData()">HP Applicant List</a></p></li>
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