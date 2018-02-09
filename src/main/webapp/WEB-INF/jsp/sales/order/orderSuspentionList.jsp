<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">

	//AUIGrid 생성 후 반환 ID
	var myGridID;
	
	$(document).ready(function(){
	    
		
	    // AUIGrid 그리드를 생성합니다.
	    createAUIGrid();
	    
	  //AUIGrid.setSelectionMode(myGridID, "singleRow");
	    
	    // 셀 더블클릭 이벤트 바인딩
	    AUIGrid.bind(myGridID, "cellDoubleClick", function(event){
	        $("#salesOrdId").val(event.item.salesOrdId);
	        $("#susId").val(event.item.susId);
	        Common.popupDiv("/sales/order/orderSuspensionDetailPop.do", $("#detailForm").serializeJSON());
	    });
	    // 셀 클릭 이벤트 바인딩
	    AUIGrid.bind(myGridID, "cellClick", function(event){
            $("#salesOrdId").val(event.item.salesOrdId);
            $("#susId").val(event.item.susId);
//            Common.popupDiv("/sales/order/orderSuspendNewResultPop.do", $("#detailForm").serializeJSON());
            gridValue =  AUIGrid.getCellValue(myGridID, event.rowIndex, $("#detailForm").serializeJSON());
        });
	});
	
	function createAUIGrid() {
        // AUIGrid 칼럼 설정
        
        // 데이터 형태는 다음과 같은 형태임,
        //[{"id":"#Cust0","date":"2014-09-03","name":"Han","country":"USA","product":"Apple","color":"Red","price":746400}, { .....} ];
        var columnLayout = [ {
                dataField : "susNo",
                headerText : '<spring:message code="sal.title.text.suspendNumber" />',
                width : 220,
                editable : false
            }, {
                dataField : "name",
                headerText : '<spring:message code="sal.title.status" />',
                width : 140,
                editable : false
            }, {
                dataField : "salesOrdNo",
                headerText : '<spring:message code="sal.title.ordNo" />',
                width : 150,
                editable : false
            }, {
                dataField : "susCrtDt",
                headerText : '<spring:message code="sal.title.crtDate" />',
                width : 150,
                editable : false
            }, {
                dataField : "susCrtUserName",
                headerText : '<spring:message code="sal.text.creator" />',
                width : 180,
                editable : false
            },{
                dataField : "invNo",
                headerText : '<spring:message code="sal.title.text.investigateNumber" />',
                editable : false
            },{
                dataField : "salesOrdId",
                visible : false
            },{
                dataField : "susId",
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
	
	function fn_searchListAjax(){
        Common.ajax("GET", "/sales/order/orderSuspensionJsonList", $("#searchForm").serialize(), function(result) {
            AUIGrid.setGridData(myGridID, result);
        });
    }
	
	function fn_newSuspend(){
		if(detailForm.susId.value == ""){
            Common.alert('<spring:message code="sal.alert.msg.noSuspendRecordSelected" />');
            return false;
        }else{
            Common.popupDiv("/sales/order/orderSuspendNewResultPop.do", $("#detailForm").serializeJSON(), null, true, 'savePop');
        }
	}
	
	function fn_assignIncharge(){
//		Common.alert('The program is under development.');
		if(detailForm.susId.value == ""){
            Common.alert('<spring:message code="sal.alert.msg.noSuspendRecordSelected" />');
            return false;
        }else{
        	if(searchForm.susStusId.value == "33" || searchForm.susStusId.value == "2"){
        		Common.popupDiv("/sales/order/inchargePersonPop.do", $("#detailForm").serializeJSON(), null, true, 'savePop');
        	}else{
        		Common.alert('<spring:message code="sal.alert.msg.reassignInchargePersonDisallow" />');
        		return false;
          	}
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
<h2><spring:message code="sal.title.text.suspendList" /></h2>
<ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
    <li><p class="btn_blue"><a href="#" onClick="fn_newSuspend()"><spring:message code="sal.btn.new" /></a></p></li>
    </c:if>
    <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
    <li><p class="btn_blue"><a href="#" onClick="fn_assignIncharge()"><spring:message code="sal.title.text.reAssignIncharge" /></a></p></li>
    </c:if>
    <li><p class="btn_blue"><a href="#" onClick="fn_searchListAjax()"><span class="search"></span><spring:message code="sal.btn.search" /></a></p></li>
    <!-- <li><p class="btn_blue"><a href="#"><span class="clear"></span>Clear</a></p></li> -->
</ul>
</aside><!-- title_line end -->

<form id="detailForm" name="detailForm" method="GET">
    <input type="hidden" id="susId" name="susId">
    <input type="hidden" id="salesOrdId" name="salesOrdId">
</form>

<section class="search_table"><!-- search_table start -->
<form id="searchForm" name="searchForm" method="post">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:120px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.title.text.suspendNumber" /></th>
    <td>
    <input type="text" title="" id="susNo" name="susNo" placeholder="Suspend Number" class="w100p" />
    </td>
    <th scope="row"><spring:message code="sal.text.ordNum" /></th>
    <td>
    <input type="text" title="" id="salesOrdNo" name="salesOrdNo" placeholder="Order Number" class="w100p" />
    </td>
    <th scope="row"><spring:message code="sal.text.creator" /></th>
    <td>
    <input type="text" title="" id="susCrtUserName" name="susCrtUserName" placeholder="Creator (Username)" class="w100p" />
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.status" /></th>
    <td>
    <select class="multy_select w100p" id="susStusId" name="susStusId" multiple="multiple">
        <option value="33" selected><spring:message code="sal.title.text.new" /></option>
        <option value="2" selected><spring:message code="sal.combo.text.supend" /></option>
        <option value="28"><spring:message code="sal.combo.text.regular" /></option>
        <option value="69"><spring:message code="sal.combo.text.writeOff" /></option>
    </select>
    </td>
    <th scope="row"><spring:message code="sal.title.text.investigateNumber" /></th>
    <td>
    <input type="text" id="invNo" name="invNo" title="" placeholder="Investigate Number" class="w100p" />
    </td>
    <th scope="row"><spring:message code="sal.text.createDate" /></th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input type="text" id="startCrtDt" name="startCrtDt" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
    <span><spring:message code="sal.title.to" /></span>
    <p><input type="text" id="endCrtDt" name="endCrtDt" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
    </div><!-- date_set end -->
    </td>
</tr>
</tbody>
</table><!-- table end -->
<!-- link_btns_wrap start 
<aside class="link_btns_wrap">
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
