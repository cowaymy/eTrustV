<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">

    //AUIGrid 생성 후 반환 ID
    var listGridID;
    var listPromoGridID;
    var ynData = [{"codeId": "1","codeName": "Yes"},{"codeId": "0","codeName": "No"}];

    var timerId = null;

    var stkId = null;

    var AUTH_CHNG = "${PAGE_AUTH.funcChange}";

    $(document).ready(function(){

        createAUIGrid();
        createAUIGridPromo();

        AUIGrid.bind(listGridID, "cellDoubleClick", function(event) {
            Common.popupDiv("/sales/productMgmt/productMgmtModifyPop.do", {stkId:stkId}, null, true);
        });

        AUIGrid.bind(listGridID, "cellClick", function(event) {
        	stkId = event.item.stkId;
        });

        AUIGrid.bind(listGridID, "selectionChange", auiGridSelectionChangeHandler);

        doDefCombo(ynData, '' ,'cmbControl', 'S', '');
    });

    function auiGridSelectionChangeHandler(event) {

        if(timerId) {
            clearTimeout(timerId);
        }

        timerId = setTimeout(function() {
            var selectedItems = event.selectedItems;
            if(selectedItems.length <= 0)
                return;

            var rowItem = selectedItems[0].item;
            stkId = rowItem.stkId;

            fn_selectPromotionListByStkSettingOn(stkId);

        }, 200);
    };

    function createAUIGrid() {

        var columnLayout = [
            { headerText : "<spring:message code='sales.title.stkCtrl'/>"  , dataField : "control",       editable : false,   width : '10%' }
          , { headerText : "<spring:message code='sal.title.DISCONTINUE'/>", dataField : "discontinued",  editable : false,   width : '10%'
        	  ,renderer : { type : "CheckBoxEditRenderer",checkValue : "1",unCheckValue : "0" } }
          , { headerText : "<spring:message code='sal.title.productId'/>",   dataField : "stkId",         editable : false,   width : '10%' }
          , { headerText : "<spring:message code='sal.title.productCode'/>", dataField : "stkCode",       editable : false,   width : '10%' }
          , { headerText : "<spring:message code='sal.title.productName'/>", dataField : "stkDesc",       editable : false,   width : '20%' }
          , { headerText : "<spring:message code='sales.StartDate'/>",       dataField : "startDate",     editable : false,   width : '10%' }
          , { headerText : "<spring:message code='sales.StartTime'/>",       dataField : "startTime",     editable : false,   width : '10%' }
          , { headerText : "<spring:message code='sales.EndDate'/>",         dataField : "endDate",       editable : false,   width : '10%' }
          , { headerText : "<spring:message code='sales.EndTime'/>",         dataField : "endTime",       editable : false,   width : '10%' }
          ];

        //그리드 속성 설정
        var gridPros = {
            usePaging           : true,
            pageRowCount        : 20,
            editable            : true,
            showStateColumn     : false,
            headerHeight        : 30,
            showRowNumColumn    : true,
            noDataMessage       : "No order found.",
            groupingMessage     : "Here groupping"
        };

        listGridID = GridCommon.createAUIGrid("list_promo_grid_wrap", columnLayout, "", gridPros);
    }

    function createAUIGridPromo() {

        //AUIGrid 칼럼 설정
        var columnLayoutPrd = [
            { headerText : "<spring:message code='sales.promo.promoCd'/>", dataField : "promoCode",   width :'20%' }
          , { headerText : "<spring:message code='sales.promo.promoNm'/>", dataField : "promoDesc", width :'40%' }
          , { headerText : "<spring:message code='sal.text.quota'/>"        , dataField : "ctrlQuota", width :'40%' }
          ];

        var listGridPros = {
            usePaging           : true,
            pageRowCount        : 10,
            editable            : false,
            fixedColumnCount    : 1,
            showStateColumn     : false,
            displayTreeOpen     : false,
            softRemoveRowMode   : false,
            headerHeight        : 30,
            useGroupingPanel    : false,
            skipReadonlyColumns : true,
            wrapSelectionMove   : true,
            showRowNumColumn    : true,
            noDataMessage       : "No promotion found.",
            groupingMessage     : "Here groupping"
        };

        listPromoGridID = GridCommon.createAUIGrid("pop_list_stck_grid_wrap", columnLayoutPrd, "", listGridPros);
    }

    function fn_selectProductMgmtListAjax() {
    	if($("#effectTm").val() != "" && $("#effectDt").val() == ""){
    		Common.alert("<spring:message code='sys.msg.necessary' arguments='Effective Date' htmlEscape='false'/>");
    		return;
        }

        Common.ajax("GET", "/sales/productMgmt/selectProductMgmtList.do", $("#listSearchForm").serialize(), function(result) {
            AUIGrid.setGridData(listGridID, result);
        });
    }

    $(function(){
        $('#btnSrch').click(function() {
            fn_selectProductMgmtListAjax();
        });
        $('#btnClear').click(function() {
            $('#listSearchForm').clearForm();
        });
    });

    function fn_selectPromotionListByStkSettingOn(stkId) {
        Common.ajax("GET", "/sales/productMgmt/selectPromotionListByStkId.do", {stkId : stkId, ctrlFlag : 1}, function(result) {
            AUIGrid.setGridData(listPromoGridID, result);
        });
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

<section id="content">
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
	<li><spring:message code='sales.path.sales'/></li>
	<li><spring:message code='sales.path.Promotion'/></li>
    <li><spring:message code='sales.title.productMaintenance'/></li>
</ul>

<aside class="title_line">
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2><spring:message code='sales.title.productMaintenance'/></h2>
<ul class="right_btns">
    <li><p class="btn_blue"><a id="btnSrch" href="#"><span class="search"></span><spring:message code='sales.btn.search'/></a></p></li>
    <li><p class="btn_blue"><a id="btnClear" href="#"><span class="clear"></span><spring:message code='sales.btn.clear'/></a></p></li>
</ul>
</aside>


<section class="search_table"><!-- search_table start -->
<form id="listSearchForm" name="listSearchForm" action="#" method="post">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Stock Control</th>
    <td><select id="cmbControl" name="cmbControl" class="w100p"></select></td>
    <th scope="row"><spring:message code='sal.title.productCode'/></th>
    <td><input id="productCode" name="productCode" type="text" class="w100p" /></td>
    <th scope="row"><spring:message code='sales.EffectDate'/></th>
    <td><input id="effectDt" name="effectDt" type="text" placeholder="DD/MM/YYYY" class="j_date w100p" readonly/></td>
</tr>
<tr>
    <th></th>
    <td></td>
    <th scope="row"><spring:message code='sal.title.productName'/></th>
    <td><input id="productName" name="productName" type="text" class="w100p" /></td>
    <th scope="row"><spring:message code="sales.EffectTime" /></th>
    <td>
    <div class="w100p time_picker"><!-- time_picker start -->
    <input id="effectTm" name="effectTm" type="text" class="time_date" readonly/>
    <ul>
        <li>Time Picker</li>
        <li><a href="#">12:00 AM</a></li>
        <li><a href="#">01:00 AM</a></li>
        <li><a href="#">02:00 AM</a></li>
        <li><a href="#">03:00 AM</a></li>
        <li><a href="#">04:00 AM</a></li>
        <li><a href="#">05:00 AM</a></li>
        <li><a href="#">06:00 AM</a></li>
        <li><a href="#">07:00 AM</a></li>
        <li><a href="#">08:00 AM</a></li>
        <li><a href="#">09:00 AM</a></li>
        <li><a href="#">10:00 AM</a></li>
        <li><a href="#">11:00 AM</a></li>
        <li><a href="#">12:00 PM</a></li>
        <li><a href="#">01:00 PM</a></li>
        <li><a href="#">02:00 PM</a></li>
        <li><a href="#">03:00 PM</a></li>
        <li><a href="#">04:00 PM</a></li>
        <li><a href="#">05:00 PM</a></li>
        <li><a href="#">06:00 PM</a></li>
        <li><a href="#">07:00 PM</a></li>
        <li><a href="#">08:00 PM</a></li>
        <li><a href="#">09:00 PM</a></li>
        <li><a href="#">10:00 PM</a></li>
        <li><a href="#">11:00 PM</a></li>
    </ul>
    </div><!-- time_picker end -->
    </td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="list_promo_grid_wrap" style="width:100%; height:480; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

<aside class="title_line"><!-- title_line start -->
<h2><spring:message code='sales.title.promoList4'/></h2>
</aside><!-- title_line end -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="pop_list_stck_grid_wrap" style="width:100%; height:240px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->
