<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<!-- char js -->
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/Chart.min.js"></script>
<!-- <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.6.0/Chart.min.js"></script>-->

<script type="text/javaScript" language="javascript">

    var wpSalesFigGrid;

    $(document).ready(function () {
        console.log("wpSalesFigurePop");
        fn_setWPGrid();
    });

    function fn_setWPGrid() {
        var salesFigColumnLayout = [
            {
                dataField : "product",
                headerText : "Product Type",
                width : 239,
                style : "aui-grid-user-custom-left"
            }, {
                dataField : "salesCnt",
                headerText : "Sales Key In",
                dataType : "numeric",
                width : 100,
                style : "aui-grid-user-custom-right"
            }, {
                dataField : "netCnt",
                headerText : "Net Sales",
                dataType : "numeric",
                width : 100,
                style : "aui-grid-user-custom-right"
            }
        ];

        var salesFigGridPros = {
                usePaging : false,
                editable : false,
                pageRowCount : 30,
                showRowCheckColumn : false,
                showRowAllCheckBox : false
        };

        wpSalesFigGrid = AUIGrid.create("#wpSalesGrid", salesFigColumnLayout, salesFigGridPros);

        Common.ajax("GET", "/chart/getSalesMonth.do", "", function(result) {
            console.log(result);
            var h = "WP Sales Key In - " + result[0].salesMth;
            $("#wpHeader").append(h);

            Common.ajax("GET", "/chart/getWpSales.do", "", function(result1) {
                AUIGrid.setGridData(wpSalesFigGrid, result1);
            });
        });
    }


</script>
<style>
.popup_wrap{position:absolute; top:20px; left:50%; z-index:1001; margin-left:-477px; width:950px; background:#fff; border:1px solid #ccc;}
.popup_wrap:after{content:""; display:block; position:fixed; top:0; left:0; z-index:-1; width:100%; height:100%;  background:rgba(0,0,0,0.6);}
.popup_wrap.size_small{width:500px!important; margin-left:-250px!important; height:400px}

.pop_body{height: 370px; padding:10px; background:#fff; overflow-y:auto;}

.grid_wrap{margin:0px 0 10px 0; height:350px}
.grid_wrap table{table-layout: auto}
.grid_wrap.h220{height:220px;}
</style>
<div id="popup_wrap" class="popup_wrap size_small"><!-- popup_wrap start -->

    <header class="pop_header"><!-- pop_header start -->
        <h1 id="wpHeader"></h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#"><spring:message code="newWebInvoice.btn.close" /></a></p></li>
        </ul>
    </header><!-- pop_header end -->

    <section class="pop_body" style="max-height: 680px"><!-- pop_body start -->
        <article class="grid_wrap" id="wpSalesGrid" style="height:350px"><!-- grid_wrap start -->
        </article><!-- grid_wrap end -->
    </section><!-- pop_body end -->

</div>
<!-- popup_wrap end -->