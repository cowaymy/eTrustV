<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">

	var listGridID;
	var keyValueList = [];
	
    $(document).ready(function(){
        
        //AUIGrid 그리드를 생성합니다.
        createAUIGrid();

        // 셀 더블클릭 이벤트 바인딩
        AUIGrid.bind(listGridID, "cellDoubleClick", function(event) {
            //fn_setDetail(listMyGridID, event.rowIndex);
        });
        
        doGetComboOrder('/common/selectCodeList.do', '10', 'CODE_ID', '', '_appTypeId', 'M', 'fn_multiCombo'); //Common Code
        doGetComboData('/status/selectStatusCategoryCdList.do', {selCategoryId : 14, parmDisab : 0}, '', '_stusId', 'M', 'fn_multiCombo');
        doGetComboSepa('/common/selectBranchCodeList.do',  '1', ' - ', '', '_brnchId', 'M', 'fn_multiCombo'); //Branch Code
        doGetComboOrder('/common/selectCodeList.do', '8', 'CODE_ID', '', '_typeId', 'M', 'fn_multiCombo'); //Common Code
    });
    
    function createAUIGrid() {
        
    	//AUIGrid 칼럼 설정
        var columnLayout = [
            { headerText : "Channel",         dataField : "channel",    editable : false, width : 60  }
          , { headerText : "SOF No.",         dataField : "sofNo",      editable : false, width : 100 }
          , { headerText : "App Type",        dataField : "appType",    editable : false, width : 80  }
          , { headerText : "Pre-Order Date",  dataField : "requestDt",  editable : false, width : 100 }
          , { headerText : "Product",         dataField : "product",    editable : false}
          , { headerText : "Customer Name",   dataField : "custNm",     editable : false, width : 80  }
          , { headerText : "Customer Type",   dataField : "custType",   editable : false, width : 80  }
          , { headerText : "NRIC/Company No", dataField : "nric",       editable : false, width : 100 }
          , { headerText : "Creator",         dataField : "userName",   editable : false, width : 100 }
          , { headerText : "Status",          dataField : "stusName",   editable : true,  width : 60  ,
                    labelFunction : function(  rowIndex, columnIndex, value, headerText, item ) {
                    var retStr = value;
                    for(var i=0,len=keyValueList.length; i<len; i++) {
                        if(keyValueList[i]["stateId"] == value) {
                            retStr = keyValueList[i]["name"];
                            break;
                        }
                    }
                    return retStr;
                },
                editRenderer : {
                    type       : "DropDownListRenderer",
                    list       : keyValueList, //key-value Object 로 구성된 리스트
                    keyField   : "stateId", //key 에 해당되는 필드명
                    valueField : "name"        //value 에 해당되는 필드명
                }
            }
          , { headerText : "preOrdId",        dataField : "preOrdId",   visible  : false}
            ];

        //그리드 속성 설정
        var gridPros = {
            usePaging           : true,         //페이징 사용
            pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)            
            editable            : true,            
            fixedColumnCount    : 1,            
            showStateColumn     : false,             
            displayTreeOpen     : false,            
            selectionMode       : "singleRow",  //"multipleCells",            
            headerHeight        : 30,       
            useGroupingPanel    : false,        //그룹핑 패널 사용
            skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력    
            noDataMessage       : "No order found.",
            groupingMessage     : "Here groupping"
        };
        
        listGridID = GridCommon.createAUIGrid("list_grid_wrap", columnLayout, "", gridPros);
    }

    $(function(){
        $('#_btnNew').click(function() {
            Common.popupDiv("/sales/order/preOrderRegisterPop.do", null, null, true, '_divPreOrdRegPop');
        });
        $('#_btnClear').click(function() {
        	$('#_frmPreOrdSrch').clearForm();
        });
        $('#_btnSearch').click(function() {
        	fn_getPreOrderList();
        });
        $('#_btnConvOrder').click(function() {
            fn_convToOrderPop();
        });
    });

    function fn_convToOrderPop() {
        var selIdx = AUIGrid.getSelectedIndex(listGridID)[0];
        if(selIdx > -1) {
            Common.popupDiv("/sales/order/convertToOrderPop.do", { preOrdId : AUIGrid.getCellValue(listGridID, selIdx, "preOrdId") }, null , true);
        }
        else {
            Common.alert("Pre-Order Missing" + DEFAULT_DELIMITER + "<b>No pre-order selected.</b>");
        }
    }
    
    function fn_statusCodeSearch(){
        Common.ajaxSync("GET", "/status/selectStatusCategoryCdList.do", {selCategoryId : 14, parmDisab : 0}, function(result) {
/*
            for(var i = result.length - 1; i >= 0; var i++) {
                if('${isAdmin}' == 'true' && (result.stusCodeId == '1' || result.stusCodeId == '10')) {
                    result.remove();
                }
            }
*/
            keyValueList = result;
        });
    }
    
    function fn_getPreOrderList() {
        Common.ajax("GET", "/sales/order/selectPreOrderList.do", $("#_frmPreOrdSrch").serialize(), function(result) {
            AUIGrid.setGridData(listGridID, result);
        });
    }

    function fn_calcGst(amt) {
        var gstAmt = 0;
        if(FormUtil.isNotEmpty(amt) || amt != 0) {
            gstAmt = Math.floor(amt*(1/1.06));
        }
        return gstAmt;
    }
    
    function fn_multiCombo(){
        $('#_appTypeId').change(function() {
            //console.log($(this).val());
        }).multipleSelect({
            selectAll: true, // 전체선택 
            width: '100%'
        });
        $('#_appTypeId').multipleSelect("checkAll");
        $('#_stusId').change(function() {
            //console.log($(this).val());
        }).multipleSelect({
            selectAll: true, // 전체선택 
            width: '100%'
        });
        $('#_stusId').multipleSelect("checkAll");
        $('#_brnchId').change(function() {
            //console.log($(this).val());
        }).multipleSelect({
            selectAll: true, // 전체선택 
            width: '100%'
        });
        $('#_brnchId').multipleSelect("checkAll");
        $('#_typeId').change(function() {
            //console.log($(this).val());
        }).multipleSelect({
            selectAll: true, // 전체선택 
            width: '100%'
        });
        $('#_typeId').multipleSelect("checkAll");

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
                this.selectedIndex = 0;
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
<h2>Pre-Order Management</h2>
<ul class="right_btns">
	<li><p class="btn_blue"><a id="_btnConvOrder" href="#">Convert Order</a></p></li>
	<li><p class="btn_blue"><a id="_btnNew" href="#">NEW</a></p></li>
	<li><p class="btn_blue"><a id="_btnSave" href="#">SAVE</a></p></li>
	<li><p class="btn_blue"><a id="_btnSearch" href="#"><span class="search"></span>Search</a></p></li>
	<li><p class="btn_blue"><a id="_btnClear" href="#"><span class="clear"></span>Clear</a></p></li>
</ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form id="_frmPreOrdSrch" name="_frmPreOrdSrch" action="#" method="post">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:160px" />
	<col style="width:*" />
	<col style="width:160px" />
	<col style="width:*" />
	<col style="width:160px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">SalesMan Code</th>
	<td>
		<div class="search_100p"><!-- search_100p start -->
		<input id="_memCode" name="_memCode" type="text" title="" placeholder="" class="w100p" />
		<a href="#" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
		</div><!-- search_100p end -->
	</td>
	<th scope="row">Application Type</th>
	<td><select id="_appTypeId" name="_appTypeId" class="multy_select w100p" multiple="multiple"></select></td>
	<th scope="row">Pre-Order date</th>
	<td><input id="_reqstDt" name="_reqstDt" type="text" value="${toDay}" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" /></td>
</tr>
<tr>
	<th scope="row">Pre-Order Status</th>
	<td><select id="_stusId" name="_stusId" class="multy_select w100p" multiple="multiple"></td>
	<th scope="row">Key-In Branch</th>
	<td><select id="_brnchId" name="_brnchId" class="multy_select w100p" multiple="multiple"></select></td>
	<th scope="row">NRIC/Company No</th>
	<td><input id="_nric" name="_nric" type="text" title="" placeholder="" class="w100p" /></td>
</tr>
<tr>
	<th scope="row">SOF No.</th>
	<td><input id="_sofNo" name="_sofNo" type="text" title="" placeholder="" class="w100p" /></td>
	<th scope="row">Customer Type</th>
	<td><select id="_typeId" name="_typeId" class="multy_select w100p" multiple="multiple"></select></td>
	<th scope="row">Customer Name</th>
	<td><input id="_name" name="_name" type="text" title="" placeholder="" class="w100p" /></td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="list_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- content end -->
