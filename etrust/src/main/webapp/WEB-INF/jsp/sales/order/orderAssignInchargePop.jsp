<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">

    //AUIGrid 생성 후 반환 ID
	var inchargeGridID;
	
	$(document).ready(function(){
	    
	    
	    // AUIGrid 그리드를 생성합니다.
	    createInchargeGrid();
	    
	    fn_getInchargeAjax();
	    
	});
	
	function createInchargeGrid() {
        // AUIGrid 칼럼 설정
        
        // 데이터 형태는 다음과 같은 형태임,
        //[{"id":"#Cust0","date":"2014-09-03","name":"Han","country":"USA","product":"Apple","color":"Red","price":746400}, { .....} ];
        var inchargeColumnLayout = [{
                dataField : "userName",
                headerText : "Username",
                width : 160,
                editable : false
            }, {
                dataField : "userFullName",
                headerText : "Name",
                editable : false
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
            useGroupingPanel : true,
            // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            skipReadonlyColumns : true,
            // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            wrapSelectionMove : true,
            // 줄번호 칼럼 렌더러 출력
            showRowNumColumn : true,
            groupingMessage : "Here groupping"
        };
        
        inchargeGridID = GridCommon.createAUIGrid("#incharge_grid_wrap", inchargeColumnLayout, gridPros);
    }
	
    function fn_getInchargeAjax(){
        Common.ajax("GET", "/sales/order/inchargePersonList.do",$("#getParamForm").serialize(), function(result) {
            AUIGrid.setGridData(inchargeGridID, result);
        });
    }
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Suspend incharge person Maintenance</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<form id="getParamForm" name="getParamForm" method="GET">
    <input type="hidden" id="susId" name="susId" value="${susId }">

	<table class="type1 mt10"><!-- table start -->
	<caption>table</caption>
	<colgroup>
	    <col style="width:180px" />
	    <col style="width:*" />
	</colgroup>
	<tbody>
		<tr>
		    <th scope="row">Current incharge person</th>
		    <td>
		    
		    <article class="grid_wrap" style="width:100%; height:200px;"><!-- grid_wrap start -->
		        <div id="incharge_grid_wrap" style="width:100%; height:200px; margin:0 auto;"></div>
		    </article><!-- grid_wrap end -->
		
		    </td>
		</tr>
		<tr>
		    <th scope="row">New incharge person</th>
		    <td>
		    <select>
		        <option value="">Incharge Person Type</option>
		        <option value="56">Credit Recovery Team</option>
		        <option value="133">Credit Recovery 3rd Party</option>
		    </select>
		    <select class="ml10">
		        <option value=""></option>
		    </select>
		    </td>
		</tr>
	</tbody>
	</table><!-- table end -->
</form>

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#">Save</a></p></li>
</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
