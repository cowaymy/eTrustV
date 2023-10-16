<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">
	var itemGridID;

	$(document).ready(function(){
	    createAUIitemGrid();
	    fn_getCnvrItmJsonAjax();

	});

	function createAUIitemGrid() {
        var columnLayout = [ {
                dataField : "payCnvrOrderNo",
                headerText : "<spring:message code='sal.text.ordNo' />",
                width : "10%",
                editable : false,
                style: 'left_style'
            }, {
                dataField : "status",
                headerText : "<spring:message code='sal.text.status' />",
                width : "10%",
                editable : false,
                style: 'left_style'
            }, {
                dataField : "payCnvrItmCardNo",
                headerText : "Card No",
                width : "25%",
                editable : false,
                style: 'left_style'
            }, {
                dataField : "payCnvrItmRem",
                headerText : "Remark",
                width : "20%",
                editable : false,
                style: 'left_style'
            }, {
                dataField : "payCnvrItmCrtDt",
                headerText : "Convert Date",
                width : "15%",
                editable : false,
                style: 'left_style'
            }, {
            	dataField : "payCnvrItmValidRem",
                headerText : "Valid Remark",
                width : "20%",
                editable : false,
                style: 'left_style'
            }];

        var gridPros = {
            usePaging : true,
            pageRowCount : 10,
            editable : false,
            fixedColumnCount : 1,
            showStateColumn : false,
            displayTreeOpen : true,
            selectionMode : "multipleCells",
            headerHeight : 30,
            useGroupingPanel : false,
            skipReadonlyColumns : true,
            wrapSelectionMove : true,
            showRowNumColumn : true,
            groupingMessage : "Here groupping"
        };

        itemGridID = AUIGrid.create("#dt_grid_wrap", columnLayout, gridPros);
    }

    function fn_getCnvrItmJsonAjax(){
        Common.ajax("GET", "/sales/order/paymodeConvertViewItmJsonList",{payCnvrId :'${cnvrInfo.payCnvrId}'}, function(result) {
            AUIGrid.setGridData(itemGridID, result);
        });
    }
</script>

<div id="popup_wrap" class="popup_wrap">

<header class="pop_header">
<h1><spring:message code="sal.page.title.conversionViewConfirm" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="_close"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header>

<section class="pop_body">

<aside class="title_line">
<h3><spring:message code="sal.page.title.conversionBatchInfo" /></h3>

</aside>

<table class="type1">
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Batch No</th>
    <td><span>${cnvrInfo.payCnvrNo }</span></td>
    <th scope="row"><spring:message code="sal.text.createAt" /></th>
    <td><span>${cnvrInfo.payCnvrCrtDt }</span></td>
    <th scope="row"><spring:message code="sal.text.createBy" /></th>
    <td><span>${cnvrInfo.username1 }</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.batchStus" /></th>
    <td><span>${cnvrInfo.name3 }</span></td>
    <th scope="row"><spring:message code="sal.title.text.statusFrom" /></th>
    <td><span>${cnvrInfo.payCnvrStusFrom }</span></td>
    <th scope="row"><spring:message code="sal.title.text.statusTo" /></th>
    <td><span>${cnvrInfo.payCnvrStusTo }</span></td>
</tr>


<tr>
    <th scope="row"><spring:message code="sal.title.text.totItem" /></th>
    <td><span>${cnvrInfo.payCnvrTotalItm }</span></td>

</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.remark" /></th>
    <td colspan="5"><span>${cnvrInfo.payCnvrRem }</span></td>
</tr>
</tbody>
</table>


<aside class="title_line">
<h3><spring:message code="sal.title.text.batchItem" /></h3>
</aside>



<article class="grid_wrap">
    <div id="dt_grid_wrap" style="width:100%; height:280px; margin:0 auto;"></div>
</article>

</section>

</div>

