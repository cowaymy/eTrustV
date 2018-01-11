<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">

$(document).ready(function() {
	// AUIGrid 그리드를 생성합니다.
    createAUIGrid();
    
    AUIGrid.setSelectionMode(myGridID, "singleRow");
    
    AUIGrid.bind(myGridID, "cellClick", function(event) {
        //code =  AUIGrid.getCellValue(myGridID, event.rowIndex, "code");
    });
});

function createAUIGrid() {
    //AUIGrid 칼럼 설정
    var columnLayout = [ {
        dataField : "bsno",
        //headerText : "No.",
        headerText : '<spring:message code="service.grid.BSNo" />',
        editable : true,
        width : 100
    }, {
        dataField : "bsDate",
        headerText : "Type",
        headerText : '<spring:message code="service.grid.BSDate" />',
        editable : false,
        width : 120
    }, {
        dataField : "memType",
        //headerText : "install No",
        headerText : '<spring:message code="service.grid.Type" />',
        editable : false,
        width : 130
    }, {
        dataField : "memStatus",
        //headerText : "Order No",
        headerText : '<spring:message code="service.grid.Status" />',
        editable : false,
        width : 130
    }, {
        dataField : "bsrNo",
        //headerText : "App Date",
        headerText : '<spring:message code="service.grid.BSRNo" />',
        editable : false,
        style : "my-column",
        width : 130
    }, {
        dataField : "setlDt",
        //headerText : "Product",
        headerText : '<spring:message code="service.grid.SettleDate" />',
        editable : false,
        width : 130
    }, {
        dataField : "codyCode",
        //headerText : "Custermer",
        headerText : '<spring:message code="service.grid.CodyCode" />',
        editable : false,
        width : 130

    },
    {
        dataField : "failResn",
        //headerText : "App Type",
        headerText : '<spring:message code="service.grid.FailReason" />',
        editable : false,
        width : 150

    },
    {
        dataField : "collResn",
        //headerText : "Status",
        headerText : '<spring:message code="service.grid.CollectionReason" />',
        width : 150
    },
    {
        dataField : "hasFilter",
        //headerText : "installentryid",
        headerText : '<spring:message code="service.grid.HasFilter" />',
        width : 100
    }    
    ];


     // 그리드 속성 설정
    var gridPros = {

             usePaging           : false,         //페이징 사용
             pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)
             editable            : false,
             fixedColumnCount    : 1,
             showStateColumn     : false,
             displayTreeOpen     : false,
             selectionMode       : "singleRow",  //"multipleCells",
             headerHeight        : 20,
             useGroupingPanel    : false,        //그룹핑 패널 사용
             skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
             wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
             showRowNumColumn    : false       //줄번호 칼럼 렌더러 출력
    };

    //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
    myGridID = AUIGrid.create("#grid_wrap_memList", columnLayout, gridPros);
}

var gridPros = {

    // 페이징 사용
    usePaging : true,

    // 한 화면에 출력되는 행 개수 20(기본값:20)
    pageRowCount : 20,

    editable : true,

    fixedColumnCount : 1,

    showStateColumn : true,

    displayTreeOpen : true,

    selectionMode : "singleRow",

    headerHeight : 30,

    // 그룹핑 패널 사용
    useGroupingPanel : true,

    // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
    skipReadonlyColumns : true,

    // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
    wrapSelectionMove : true,

    // 줄번호 칼럼 렌더러 출력
    showRowNumColumn : false

};

function fn_orderSearch(){
    Common.ajax("GET", "/services/bs/bsHistorySearch", $("#searchForm").serialize(), function(orderList) {
        console.log("성공.");
        //console.log("data : " + orderList);
        AUIGrid.setGridData(myGridID, orderList);
        
        $("#name").text(orderList.name);
        $("#orderNumber").text(orderList.salesOrdNo);
        $("#orderNumber2").text(orderList.salesOrdNo);
        $("#product").text("("+orderList.stockCode+") "+orderList.stockDesc);
        $("#installationDate").text(orderList.installDate);
        $("#customerAddress").text(orderList.customerAddress);
        $("#installationAddress").text(orderList.installAddress);
        $("#mobile").text(orderList.mailCntTelM);
        $("#residence").text(orderList.mailCntTelR);
        $("#office").text(orderList.mailCntTelO);
        $("#fax").text(orderList.mailCntTelF);
        $("#bankAccount").text(orderList.jomPayRef);
        $("#customerType").text(orderList.custType);
        $("#orderId").val(orderList.salesOrdId);
    });

}

function fn_filterInfo(){
	var orderId = $("#orderId").val();
	console.log(orderId);
	if(orderId!=null ||orderId!=""||orderId!=" "){
	 Common.popupDiv("/services/bs/filterInfoPop2.do?orderId="+orderId );
	}else{
		return;
	}
}

</script>

<section id="content"><!-- content start -->
<ul class="path">
    <!-- <li><img src="../images/common/path_home.gif" alt="Home" /></li> -->
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Sales</li>
    <li>Order list</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2><spring:message code='service.title.HsHistory'/></h2>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form action="searchForm" id="searchForm" method="post">
    
    <aside class="link_btns_wrap">
    <div id="divErrorMessage" style="width: 100%; height: 20px; margin: 0 auto;">
        <span style="color: #CC0000" ID="lblErrorMessage"></span>
    </div>
    </aside><!-- grid_wrap end -->
    
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:100px" />
    <col style="width:*" />
</colgroup>
<tbody>

<tr>
    <th scope="row"><spring:message code='service.title.OrderNo'/></th>
    <td><input type="text" title="" id="orderNumber" name="orderNumber" placeholder="" class="" />
        <!-- <a href="javascript:fn_orderSearch();" class="search_btn"><img src="../images/common/normal_search.gif" alt="search" /></a> -->
        <p class="btn_grid"><a href="javascript:fn_orderSearch();"><span class="search"></span><spring:message code='sys.btn.search'/></a></p>
        
    </td>
</tr>
</tbody>
</table><!-- table end -->
<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_wrap_memList" style="width: 100%; height: 60px; margin: 0 auto;"></div>
</article><!-- grid_wrap end -->
<!-- <p class="btn_grid"><a href="javascript:fn_filterInfo();"><span class="search"></span><spring:message code='service.btn.FilterInfo'/></a></p> -->
<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
<dl class="link_list">
    <dt>Link</dt>
    <dd>
    <ul class="btns">
        <li><p class="link_btn"><a href="javascript:fn_filterInfo()" id="filterInfo"><spring:message code='service.btn.FilterInfo'/></a></p></li>
    </ul>
    </dd>
</dl>
</aside><!-- link_btns_wrap end -->
    
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:170px" />
    <col style="width:*" />
    
</colgroup>
<tbody>
<tr>
    <th colspan="2" scope="row"><spring:message code='service.title.Name'/></th>
    <td colspan="2"><span id="name"></span></td>
    <th colspan="2" scope="row"><spring:message code='service.title.OrderNumber'/></th>
    <td colspan="2"><span id="orderNumber2"></span></td>
</tr>

<tr>
    <th colspan="2" scope="row"><spring:message code='service.title.Product'/></th>
    <td colspan="2"><span id="product"></span></td>
    <th colspan="2" scope="row"><spring:message code='service.title.InstallationDate'/></th>
    <td colspan="2"><span id="installationDate"></span></td>
</tr>

<tr>
    <th colspan="2" scope="row"><spring:message code='service.title.CustomerAddress'/></th>
    <td colspan="2"><span id="customerAddress"></span></td>
    <th colspan="2" scope="row"><spring:message code='service.title.InstallationAddress'/></th>
    <td colspan="2"><span id="installationAddress"></span></td>
</tr>

<tr>
    <th scope="row"><spring:message code='service.title.MobileNo'/></th>
    <td><span id="mobile"></span></td>
    
    <th scope="row"><spring:message code='service.title.ResidenceNo'/></th>
    <td><span id="residence"></span></td>
    
    <th scope="row"><spring:message code='service.title.Bank'/></th>
    <td><span id="bankAccount"></span></td>
    
    <th scope="row"><spring:message code='service.title.JomPayRef1'/></th>
    <td><span id="jomPayRef1"></span></td>
</tr>

<tr>
    <th colspan="2" scope="row"><spring:message code='service.title.OfficeNo'/></th>
    <td colspan="2"><span id="office"></span></td>
    <th scope="row"><spring:message code='service.title.FaxNo'/></th>
    <td><span id="fax"></span></td>
    <th scope="row"><spring:message code='service.title.CustomerType'/></th>
    <td><span id="customerType"></span></td>
    
</tr>

</tbody>
</table>
<input type="hidden" name="orderId"  id="orderId"/>
</form>
</section><!-- search_table end -->
    


</section><!-- content end -->