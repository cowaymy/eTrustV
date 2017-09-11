<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">
    
  	//AUIGrid 생성 후 반환 ID
	var myGridID;

    $(document).ready(function(){

        //AUIGrid 그리드를 생성합니다.
        createAUIGrid();

        doGetCombo('/common/selectCodeList.do', '${gubun}' == 'stocklist' ? '11' : '63', '', 'stkCtgryId', 'S'); //Category
        doGetCombo('/common/selectCodeList.do', '15', '', 'stkTypeId',  'S'); //Type
        
        if('${gubun}' != 'stocklist') $('#stkTypeId').prop("disabled", true);
    });

    function createAUIGrid() {
        
    	//AUIGrid 칼럼 설정
        var columnLayout1 = [
            { dataField : "itemcode",   headerText : "Stock Code", editable : false, width : 120 }
          , { dataField : "itemname",   headerText : "Name",       editable : false }
          , { dataField : "catename",   headerText : "Category",   editable : false, width : 150 }
          , { dataField : "typename",   headerText : "Type",       editable : false, width : 120 }
          , { dataField : "statusname", headerText : "Status",     editable : false, width : 80  }
          , { dataField : "itemid",     headerText : "itemid",     visible  : false }
          ];

    	//AUIGrid 칼럼 설정
        var columnLayout2 = [
            { dataField : "itemcode",   headerText : "Stock Code", editable : false, width : 120 }
          , { dataField : "itemname",   headerText : "Name",       editable : false }
          , { dataField : "catename",   headerText : "Category",   editable : false, width : 150 }
          , { dataField : "statusname", headerText : "Status",     editable : false, width : 80  }
          , { dataField : "itemid",     headerText : "itemid",     visible  : false }
          ];

        //그리드 속성 설정
        var gridPros = {
            usePaging           : true,         //페이징 사용
            pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)            
            editable            : false,            
            fixedColumnCount    : 1,            
            showStateColumn     : false,             
            displayTreeOpen     : false,            
            selectionMode       : "singleRow",  //"multipleCells", 
            showRowCheckColumn  : true,
            headerHeight        : 30,       
            useGroupingPanel    : false,        //그룹핑 패널 사용
            skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력    
            noDataMessage       : "No order found.",
            groupingMessage     : "Here groupping"
        };
        
        var columnLayout = '${gubun}' == 'stocklist' ? columnLayout1 : columnLayout2;
        
        myGridID = GridCommon.createAUIGrid("pop_grid_wrap", columnLayout, "", gridPros);
    }

    $(function(){
        $('#btnProductSearch').click(function() {
        	fn_selectPrdListAjax();
        });
        $('#btnApply').click(function() {
        	var selectedItems = AUIGrid.getCheckedRowItems(myGridID);
        	fn_addItems(selectedItems, '${gubun}');
        });
    });
	    // 리스트 조회.
    function fn_selectPrdListAjax() {        
        Common.ajax("POST", "/logistics/material/materialcdsearch.do", $("#popSearchForm").serializeJSON(), function(result) {
            AUIGrid.setGridData(myGridID, result.data);
        });
    }
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Product / Free gift Search</h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<ul class="right_btns">
	<li><p class="btn_blue"><a id="btnProductSearch" href="#"><span class="search"></span>Search</a></p></li>
</ul>
<form id="popSearchForm" name="popSearchForm" action="#" method="post">
    <input id="gubun" name="gubun" value="${gubun}" type="hidden" />
    
<table class="type1 mt10"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:110px" />
	<col style="width:*" />
	<col style="width:80px" />
	<col style="width:*" />
	<col style="width:110px" />
	<col style="width:*" />
	<col style="width:120px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Category<span class="must">*</span></th>
	<td>
	<select id="stkCtgryId" name="cateid" class="w100p"></select>
	</td>
	<th scope="row">Type<span class="must">*</span></th>
	<td>
	<select id="stkTypeId" name="typeid" class="w100p"></select>
	</td>
	<th scope="row">Stock Code</th>
	<td><input id="stkCode" name="scode" type="text" title="" placeholder="" class="w100p" /></td>
	<th scope="row">Stock Name</th>
	<td><input id="stkNm" name="sname" type="text" title="" placeholder="" class="w100p" /></td>
</tr>
</tbody>
</table><!-- table end -->
</form>
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
<article class="grid_wrap mt10"><!-- grid_wrap start -->
<div id="pop_grid_wrap" style="width:100%; height:240px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

<ul class="center_btns">
	<li><p class="btn_blue2 big"><a id="btnApply" href="#">Apply</a></p></li>
</ul>

</section><!-- pop_body end -->\

</div><!-- popup_wrap end -->