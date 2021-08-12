<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<head>
<script type="text/javaScript" language="javascript">

	//AUIGrid 생성 후 반환 ID
	var schemPopGridID;

	$(document).ready(function(){
	    //AUIGrid 그리드를 생성합니다.
	    schemPopAUIGrid();
	    
        Common.ajaxSync("GET", "/sales/order/selectSchemePriceSettingByPromoCode.do", {schemePromoId : PROMO_ID, schemeStockId : STOCK_ID}, function(result) {
            if(result != null) {                
                $('#_spRpf').text(result.schemeRpf);
                $('#_spRen').text(result.schemePrc);
                $('#_spPv').text(result.schemePv);
                $('#_spSvcInt').text(result.schemeSvcFreq);
                
                fn_getSchemePartSettingBySchemeIDList(result.schemeId, result.schemeStockId);
            }
        }); 
	    
	});

	$(function(){
	    $('#btnSchemConv').click(function() {
            fn_doSaveReqSchm();
            $('#btnSchemConvPopClose').click();
	    });
	});
	
    function schemPopAUIGrid() {
        
        //AUIGrid 칼럼 설정
        var schemConvColumnLayout = [
            { headerText : "Filter Code",            dataField : "custId",    width : 120 }
          , { headerText : "Name",                   dataField : "codeName1", width : 120 }
          , { headerText : "Change Period (Months)", dataField : "codeName"}
          ];

        //그리드 속성 설정
        var schemPopGridPros = {
            usePaging           : true,         //페이징 사용
            pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)            
            editable            : false,            
            fixedColumnCount    : 1,            
            showStateColumn     : false,             
            displayTreeOpen     : false,            
          //selectionMode       : "singleRow",  //"multipleCells",            
            headerHeight        : 30,       
            useGroupingPanel    : false,        //그룹핑 패널 사용
            skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력    
            noDataMessage       : "No order found.",
            groupingMessage     : "Here groupping"
        };
        
        schemPopGridID = GridCommon.createAUIGrid("grid_schem_pop_wrap", schemConvColumnLayout, "", schemPopGridPros);
    }

    // 리스트 조회.
    function fn_getSchemePartSettingBySchemeIDList(schemeId, schemeStockId) {
        Common.ajax("GET", "/sales/order/selectSchemePartSettingBySchemeIDList.do", {cmbScheme : schemeId , schemeStockId : schemeStockId}, function(result) {
            AUIGrid.setGridData(schemPopGridID, result);
        });
    }

</script>
</head>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Search Customer</h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a id="btnSchemConvPopClose" href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->
<form id="frmSchemConvPop" action="#" method="post">
    
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:160px" />
	<col style="width:*" />
	<col style="width:210px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">RPF</th>
	<td><span id="_spRpf"></span></td>
	<th scope="row">Rental</th>
	<td><span id="_spRen"></span></td>
</tr>
<tr>
	<th scope="row">PV</th>
	<td><span id="_spPv"></span></td>
	<th scope="row">Service Interval</th>
	<td><span id="_spSvcInt"></span></td>
</tr>
</tbody>
</table><!-- table end -->
</form>
<section class="search_result"><!-- search_result start -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_schem_pop_wrap" style="width:100%; height:180px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->
<ul class="left_opt">
    <li><span class="red_text">**</span> <span class="brown_text">Do you confirm with the conversion info?</span></li>
</ul>
<ul class="center_btns">
	<li><p class="btn_blue2 big"><a id="btnSchemConv" href="#">Ok</a></p></li>
</ul>

</section><!-- search_result end -->

</section><!-- search_table end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->