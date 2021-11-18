<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javaScript">
var itemGridID;
    $(document).ready(function() {
        createAUIGrid();
        fn_itemDetailSearch('');
    });

    function createAUIGrid() {
        var columnLayout = [
         {
            dataField : "lotyMemberStatusCode",
            headerText : "Status",
            style : "my-column",
            editable : false
        },{
            dataField : "pax",
            headerText : "Pax",
            style : "my-column",
            editable : false
        }
        ];

        var gridPros = {
            usePaging : true,
            pageRowCount : 20,
            skipReadonlyColumns : true,
            wrapSelectionMove : true,
            showRowNumColumn : true,
            height : 280

        };

        itemGridID = AUIGrid.create("#grid_wrap_confirm", columnLayout,gridPros);
   }

    function fn_itemDetailSearch(type){
    	 Common.ajax("GET", "/organization/selectLoyaltyHPUploadMemberStatusList?uploadId="+"${uploadId}", $("#conForm").serializeJSON(), function(result) {
             AUIGrid.setGridData(itemGridID, result);
         });
    }



</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>LOYALTY HP PROGRAM UPLOAD</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="clearComfirm"><spring:message code='sys.btn.close'/></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->


<form id="conForm" name="conForm">
</form>

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="grid_wrap_confirm" style="width: 100%; height: 280px; margin: 0 auto;"></div>
</article><!-- grid_wrap end -->



</section><!-- pop_body end -->

</div><!-- popup_wrap end -->