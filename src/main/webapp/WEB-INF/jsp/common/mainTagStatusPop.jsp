<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script type="text/javaScript">
/********************************Global Variable Start***********************************/
/********************************Global Variable End************************************/
/********************************Function  Start***************************************
 *
 */
/****************************Function  End***********************************
 *
 */
/****************************Transaction Start********************************/

    var popTagStatusColumnLayout =
    [
        {
            dataField: "customer",
            headerText: "Customer",
            width: "8%"
        },
        {
            dataField: "mainInquiry",
            headerText: "Main Inquiry",
            width: "13%"
        },
        {
            dataField: "subInquiry",
            headerText: "Sub Inquiry",
            style: "aui-grid-user-custom-left ",
            width: "13%"
        },
        {
            dataField: "salesOrder",
            headerText: "Sales Order",
            width: "10%"
        },
        {
            dataField: "mainDepartment",
            headerText: "Main Department",
            style: "aui-grid-user-custom-left ",
            width: "13%"
        },
        {
            dataField: "subDepartment",
            headerText: "Sub Department",
            style: "aui-grid-user-custom-left ",
            width: "15%"
        },
        {
            dataField: "claimNote",
            headerText: "Caim Note",
            style: "aui-grid-user-custom-left ",
            width: "18%"
        },
        {
            dataField: "status",
            headerText: "Status"
        }
    ];

	var popStatusCodeOptions =
	{
	    usePaging: true,
	    useGroupingPanel: false,
	    editable: false,
	    showRowNumColumn: false  // 그리드 넘버링
	};


// Tag Status 리스트 조회.
function fn_selectPopTagStatusListAjax(_initYn) {
    Common.ajax("GET", "/common/getTagStatus.do", {initYn:_initYn}, function (result) {
        AUIGrid.setGridData(statusCodeGridID, result);
    });
}

/****************************Transaction End********************************/
/**************************** Grid setting Start ******************************/
/****************************Program Init Start********************************/
$(document).ready(function(){
    // AUIGrid 그리드를 생성
    // detailGrid 생성
    statusCodeGridID = GridCommon.createAUIGrid("popTagStatusGrid", popTagStatusColumnLayout, "", popStatusCodeOptions);
    fn_selectPopTagStatusListAjax();
});
/****************************Program Init End********************************/
</script>
<div id="popup_wrap" class="popup_wrap size_middle"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Tag Status</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

	<article class="grid_wrap"><!-- grid_wrap start -->
	    <!-- 그리드 영역2 -->
	    <div id="popTagStatusGrid" style="height:400px;"></div>
	</article><!-- grid_wrap end -->
<!-- <div class="search_100p select">
<select id="select_myMenu" class="w100p">
</select>
<p class="btn_sky"><a onclick="">Select</a></p>
</div> -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->