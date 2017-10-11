<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">
	//AUIGrid 생성 후 반환 ID
	var addrGridID;
	
	$(document).ready(function(){
	    
	    // AUIGrid 그리드를 생성합니다.
	    createEditAUIGrid();
	
	    //Call Ajax
	    fn_getAddrListAjax();
	  
//	    doGetCombo('/sales/pst/getInchargeList', '', $("#editInchargeSelect").val(),'editIncharge', 'S' , ''); //Incharge Person
	});
	
	function createEditAUIGrid() {
	    // AUIGrid 칼럼 설정
	    
	    // 데이터 형태는 다음과 같은 형태임,
	    //[{"id":"#Cust0","date":"2014-09-03","name":"Han","country":"USA","product":"Apple","color":"Red","price":746400}, { .....} ];
	    var columnLayout = [{
	            dataField : "code",
	            headerText : "Status",
	            width : 120,
	            editable : false
	        }, {
	            dataField : "fullAddr",
	            headerText : "Full Address",
	            editable : false
	        }, {
	        	dataField : "setMain", 
	            headerText : "Set As Main", 
	            width:'10%', 
	            renderer : { 
	                type : "TemplateRenderer", 
	                editable : true // 체크박스 편집 활성화 여부(기본값 : false)
	            }, 
	            // dataField 로 정의된 필드 값이 HTML 이라면 labelFunction 으로 처리할 필요 없음. 
	            labelFunction : function (rowIndex, columnIndex, value, headerText, item ) { // HTML 템플릿 작성 
	                var html = '';
	            
	                html += '<label><input type="radio" name="setmain"  onclick="javascript: fn_setMain(' + item.custAddId + ','+item.custId+')"';
	                
	                if(item.stusCodeId == 9){
	                    html+= ' checked = "checked"';
	                    html+= ' disabled = "disabled"';
	                }
	                
	                html += '/></label>'; 
	                
	                return html;
	            } 
	        }];
	   
	    // 그리드 속성 설정
	    var gridPros = {
	        // 페이징 사용       
	        usePaging : true,
	        // 한 화면에 출력되는 행 개수 20(기본값:20)
	        pageRowCount : 10,
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
	    
	    addrGridID = GridCommon.createAUIGrid("#address_grid_wrap", columnLayout, gridPros);
	}
	
	function fn_getAddrListAjax(){
	    Common.ajax("GET", "/sales/pst/getAddrJsonListPop",$("#paramForm").serialize(), function(result) {
	        AUIGrid.setGridData(addrGridID, result);
	    });
	}
	
	// set Main Func (Confirm)
    function fn_setMain(dealerAddId, dealerId){ 
        $("#tempDealerId").val(dealerId);
        $("#tempDealerAddr").val(dealerAddId);  
        Common.confirm("Are you sure want to set this address as main address ?", fn_changeMainAddr, fn_reloadPage);
        
    }
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>EDIT PST DEALER ADDRESS</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<aside class="title_line"><!-- title_line start -->
<h2>Dealer Main Adderss</h2>
</aside><!-- title_line end -->

<form id="paramForm" name="paramForm" method="GET">
    <input type="hidden" id="dealerId" name="dealerId" value="${dealerId}">
</form>

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:100px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Full Address</th>
    <td><span>${pstMailAddrMain.fullAddr }</span></td>
</tr>
<tr>
    <th scope="row">Remark</th>
    <td><span>${pstMailAddrMain.rem }</span></td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>Dealer Address List</h2>
</aside><!-- title_line end -->

<ul class="right_btns">
    <li><p class="btn_grid"><a href="#">Add New Address</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="address_grid_wrap" style="width:100%; height:250px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->