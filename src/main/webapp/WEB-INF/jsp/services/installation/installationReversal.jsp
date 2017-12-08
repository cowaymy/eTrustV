<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">

$(document).ready(function() {
	// AUIGrid 그리드를 생성합니다.
    createAUIGrid();
	
    AUIGrid.setSelectionMode(myGridID, "singleRow");
    
    AUIGrid.bind(myGridID, "cellClick", function(event) {
        //alert(event.rowIndex+ " -cellClick : " + event.value + " - rowValue : " + AUIGrid.getCellValue(myGridID, event.rowIndex, "memberid"));
        code =  AUIGrid.getCellValue(myGridID, event.rowIndex, "code");
        installEntryNo = AUIGrid.getCellValue(myGridID, event.rowIndex, "installEntryNo");
        salesOrdNo = AUIGrid.getCellValue(myGridID, event.rowIndex, "salesOrdNo");
        salesDt = AUIGrid.getCellValue(myGridID, event.rowIndex, "salesDt");
        stkDesc = AUIGrid.getCellValue(myGridID, event.rowIndex, "stkDesc");
        name = AUIGrid.getCellValue(myGridID, event.rowIndex, "name");
        code1 = AUIGrid.getCellValue(myGridID, event.rowIndex, "code1");
        installEntryId = AUIGrid.getCellValue(myGridID, event.rowIndex, "installEntryId");
        salesOrdId = AUIGrid.getCellValue(myGridID, event.rowIndex, "salesOrdId");
        //Common.popupDiv("/organization/requestTerminateResign.do?isPop=true&MemberID=" + AUIGrid.getCellValue(myGridID, event.rowIndex, "memberid")+"&MemberType=" + AUIGrid.getCellValue(myGridID, event.rowIndex, "membertype"), "");
        
        selectrow(installEntryNo,salesOrdNo,installEntryId);
    });
    
});

function selectrow(installEntryNo,salesOrdNo){
	$("#installEntryNo").val(installEntryNo);
	$("#salesOrdNo").val(salesOrdNo);
	$("#installEntryId").val(installEntryId);
	$("#salesOrdId").val(salesOrdId);
    
	   Common.ajax("POST", "/services/installationReversalSearchDetail", $("#searchForm").serializeJSON() , function(result) {
	        
	        //console.log(result);
	        
	        fn_setdetail(result);

	     }, function(jqXHR, textStatus, errorThrown) {
	         
	         console.log("실패하였습니다.");
	         console.log("error : " + jqXHR + " \n " + textStatus + "\n" + errorThrown);

	         console.log("jqXHR.responseJSON.message" + jqXHR.responseJSON.message);
	         
	     });

}
function fn_setdetail(result){
	
	
	$("#spanOrdNo").text(result.list1.salesOrdNo);
	$("#spanAppType").text(result.list1.codeName2);
	$("#spanCustomerId").text(result.list1.custId);
	$("#spanCustomerName").text(result.list1.name);
	$("#spanNric").text(result.list1.nric);
	$("#spanInstallationNo").text(result.list1.installEntryNo);
	$("#spanInstallationType").text(result.list1.codeName1);
	$("#spanInstallationStatus").text(result.list1.name1);
	$("#spanActInsDate").html(result.list1.c1);
	$("#spanInCharedCt").text(result.list1.name2);
	$("#spanInstallProduct").text(result.list1.stkDesc);
	$("#spanDoWarehouse").text(result.list1.brnchId);
	$("#spanDoDate").text(result.list1.InstallDt);
	$("#spanSirimNo").text(result.list1.sirimNo);
	$("#spanSerialNo").text(result.list1.serialNo);
	$("#spanRefNo1").text(result.list1.docRefNo1);
	$("#spanRefNo2").text(result.list1.docRefNo2);
	$("#spanRemark").text(result.list1.rem);
	$("#spanResultKeyBy").text(result.list1.memCode);
	$("#spanResultKeyAt").text(result.list1.c3);
    
	if(result.list1.allowComm==1){
		$("#allowCom").prop("checked",true);	
	}
	
	if(result.list1.isTradeIn==1){
        $("#isTrade").prop("checked",true);    
    }
	
	if(result.list1.requireSms==1){
        $("#reqSms").prop("checked",true);    
    }
	
	if(result.list1.stusCodeId==4){
		if(result.list1.c3==null){
			$("#lblErrorMessage").text(result.list1.salesOrdNo);		
		}
		if(result.list1.c9==result.list1.c8){
			$("#lblErrorMessage").text("");
		}else{
			$("#lblErrorMessage").text("* This installation is past day. Reversal is disallowed.");
		}
	}else{
		$("#lblErrorMessage").text("* Only installation complete result can be reverse.");
	}
}

function createAUIGrid() {
    //AUIGrid 칼럼 설정
    var columnLayout = [ {
        dataField : "rnum",
        headerText : "No.",
        editable : true,
        width : 50
    }, {
        dataField : "code",
        headerText : "Type",
        editable : false,
        width : 120
    }, {
        dataField : "installEntryNo",
        headerText : "install No",
        editable : false,
        width : 130
    }, {
        dataField : "salesOrdNo",
        headerText : "Order No",
        editable : false,
        width : 130
    }, {
        dataField : "salesDt",
        headerText : "App Date",
        editable : false,
        style : "my-column",
        width : 130
    }, {
        dataField : "stkDesc",
        headerText : "Product",
        editable : false,
        width : 130
    }, {
        dataField : "name",
        headerText : "Custermer",
        editable : false,
        width : 130

    },
    {
        dataField : "codeName",
        headerText : "App Type",
        editable : false,
        width : 120

    },
    {
        dataField : "code1",
        headerText : "Status",
        width : 120
    },
    {
        dataField : "installEntryId",
        headerText : "installentryid",
        width : 0
    },    
    {
        dataField : "salesOrdId",
        headerText : "salesOrdId",
        width : 0
    }];


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
    Common.ajax("GET", "/services/installationReversalSearch", $("#searchForm").serialize(), function(orderList) {
        console.log("성공.");
        //console.log("data : " + orderList);
        AUIGrid.setGridData(myGridID, orderList);
    });

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
<h2>Installation Result Reversal List</h2>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form action="searchForm" id="searchForm" method="post">
    <input type="hidden"  id="installEntryNo" name="installEntryNo"/>
    <input type="hidden"  id="salesOrdNo" name="salesOrdNo"/>
    <input type="hidden"  id="installEntryId" name="installEntryId"/>
    <input type="hidden"  id="salesOrdId" name="salesOrdId"/>
    
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
    <th scope="row">Order No.</th>
    <td><input type="text" title="" id="orderNo" name="orderNo" placeholder="" class="" />
        <!-- <a href="javascript:fn_orderSearch();" class="search_btn"><img src="../images/common/normal_search.gif" alt="search" /></a> -->
        <p class="btn_grid"><a href="javascript:fn_orderSearch();">search</a></p>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<!-- 
<p class="show_btn"><a href="#"><img src="../images/common/btn_link.gif" alt="link show" /></a></p>
<dl class="link_list">
    <dt>Link</dt>
    <dd>
    <ul class="btns">
        <li><p class="link_btn"><a href="#">menu1</a></p></li>
        <li><p class="link_btn"><a href="#">menu2</a></p></li>
        <li><p class="link_btn"><a href="#">menu3</a></p></li>
        <li><p class="link_btn"><a href="#">menu4</a></p></li>
        <li><p class="link_btn"><a href="#">Search Payment</a></p></li>
        <li><p class="link_btn"><a href="#">menu6</a></p></li>
        <li><p class="link_btn"><a href="#">menu7</a></p></li>
        <li><p class="link_btn"><a href="#">menu8</a></p></li>
    </ul>
    <ul class="btns">
        <li><p class="link_btn type2"><a href="#">menu1</a></p></li>
        <li><p class="link_btn type2"><a href="#">Search Payment</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu3</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu4</a></p></li>
        <li><p class="link_btn type2"><a href="#">Search Payment</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu6</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu7</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu8</a></p></li>
    </ul>
    <p class="hide_btn"><a href="#"><img src="../images/common/btn_link_close.gif" alt="hide" /></a></p>
    </dd>
</dl>
</aside> -->
<!-- link_btns_wrap end -->

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
<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_wrap_memList" style="width: 100%; height: 60px; margin: 0 auto;"></div>
</article><!-- grid_wrap end -->
<aside class="title_line"><!-- title_line start -->
    <span></span>
</aside><!-- title_line end -->
</form>
</section><!-- search_table end -->

<aside class="link_btns_wrap">
    <div  style="width: 100%; height: 20px;text-align:right;color:darkblue;">
        Only the latest installation result will display.
    </div>
</aside><!-- grid_wrap end -->
    
<aside class="title_line"><!-- title_line start -->
<h3>Details</h3>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:170px" />
    <col style="width:*" />
    <col style="width:190px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Order No.</th>
    <td><span id="spanOrdNo"></span></td>
    <th scope="row">App. Type</th>
    <td><span id="spanAppType"></span></td>
    <th scope="row">Customer ID</th>
    <td><span id="spanCustomerId"></span></td>
</tr>
<tr>
    <th scope="row">Customer Name</th>
    <td><span id="spanCustomerName"></span></td>
    <th scope="row">NRIC/Comp. No</th>
    <td><span id="spanNric"></span></td>
    <th scope="row">Installation No.</th>
    <td><span id="spanInstallationNo"></span></td>
</tr>
<tr>
    <th scope="row">Installation Type</th>
    <td><span id="spanInstallationType"></span></td>
    <th scope="row">Installation Status</th>
    <td><span id="spanInstallationStatus"></span></td>
    <th scope="row">Actual Installed Date</th>
    <td><span id="spanActInsDate"></span></td>
</tr>
<tr>
    <th scope="row">In-Charged CT</th>
    <td><span id="spanInCharedCt"></span></td>
    <th scope="row">Install Product</th>
    <td><span id="spanInstallProduct"></span></td>
    <th scope="row">DO Warehouse</th>
    <td><span id="spanDoWarehouse"></span></td>
</tr>
<tr>
    <th scope="row">DO Date</th>
    <td><span id="spanDoDate"></span></td>
    <th scope="row">SIRIM No.</th>
    <td><span id="spanSirimNo"></span></td>
    <th scope="row">Serial No.</th>
    <td><span id="spanSerialNo"></span></td>
</tr>
<tr>
    <th scope="row">Ref No.(1)</th>
    <td><span id="spanRefNo1"></span></td>
    <th scope="row">Ref No.(2)</th>
    <td colspan="3"><span id="spanRefNo2"></span></td>
</tr>
<tr>
    <th scope="row">Remark</th>
    <td colspan="5"><span id="spanRemark"></span></td>
</tr>
<tr>
    <td colspan="6">
    <label><input type="checkbox" id="allowComm"/><span>Allow Commission ?</span></label>
    <label><input type="checkbox" id="isTrade"/><span>Is trade in ?</span></label>
    <label><input type="checkbox" id="reqSms"/><span>Require SMS ?</span></label>
    </td>
</tr>
<tr>
    <th scope="row">Result Key By</th>
    <td><span id="spanResultKeyBy"></span></td>
    <th scope="row">Result Key At</th>
    <td colspan="3"><span id="spanResultKeyAt"></span></td>
</tr>
</tbody>
</table><!-- table end -->

</section><!-- content end -->