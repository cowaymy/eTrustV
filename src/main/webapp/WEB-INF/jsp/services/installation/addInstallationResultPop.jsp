<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
$(document).ready(function() {
    var myGridID_view;

    createInstallationViewAUIGrid();
    fn_viewInstallResultSearch();

    var callType = "${callType.typeId}";
    console.log(callType);
    if(callType == 0){
        $(".red_text").text( "* Installation information data error. Please contact to IT Department.");
    }else{
        if(callType == 258){
            //$(".tap_type1").li[1].text("Product Exchange Info");
        }else{

        }
        if("${orderInfo.c9}" == 21){
            $(".red_text").text( "* This installation status is failed. Please do the call log process again.");
        }else if("${orderInfo.c9}" == 4){
            $(".red_text").text( "* This installation status is completed.<br />  To reverse this order installation result, please proceed to order installation result reverse.");
        }else{

        }
    }


    if("${stock}"  != null){

    	$("#hidActualCTMemCode").val("${stock.memCode}");
    	$("#hidActualCTId").val("${stock.movToLocId}");
    }else{
    	$("#hidActualCTMemCode").val("0");
        $("#hidActualCTId").val("0");
    }

    if("${orderInfo}" != null){
    	$("#hidCategoryId").val("${orderInfo.stkCtgryId}");
    	if(callType == 258){
    		$("#hidPromotionId").val("${orderInfo.c8}");
    		$("#hidPriceId").val("${orderInfo.c11}");
    		$("#hiddenOriPriceId").val("${orderInfo.c11}");
    		$("#hiddenOriPrice").val("${orderInfo.c12}");
    		$("#hiddenOriPV").val("${orderInfo.c13}");
    		$("#hiddenProductItem").val("${orderInfo.c7}");
    		$("#hidPERentAmt").val("${orderInfo.c17}");
    		$("#hidPEDefRentAmt").val("${orderInfo.c18}");
    		$("#hidInstallStatusCodeId").val("${orderInfo.c19}");
    		$("#hidPEPreviousStatus").val("${orderInfo.c20}");
    		$("#hidDocId").val("${orderInfo.docId}");
    		$("#hidOldPrice").val("${orderInfo.c15}");
    		$("#hidExchangeAppTypeId").val("${orderInfo.c21}");
    	}else{
    		$("#hidPromotionId").val("${orderInfo.c2 }");
    		$("#hidPriceId").val("${orderInfo.itmPrcId}");
    		$("#hiddenOriPriceId").val("${orderInfo.itmPrcId}");
    		$("#hiddenOriPrice").val("${orderInfo.c5}");
    		$("#hiddenOriPV").val("${orderInfo.c6}");
    		$("#hiddenCatogory").val("${orderInfo.codename1}");
    		$("#hiddenProductItem").val("${orderInfo.stkDesc}");
    		$("#hidPERentAmt").val("${orderInfo.c7}");
    		$("#hidPEDefRentAmt").val("${orderInfo.c8}");
    		$("#hidInstallStatusCodeId").val("${orderInfo.c9}");
    	}

    }
    $("#hiddenCustomerType").val("${customerContractInfo.typeId}");
/*     ("#hiddenPostCode").val("${customerAddress.typeId}");
    ("#hiddenStateName").val("${customerAddress.typeId}");
    ("#hiddenCountryName").val("${customerAddress.typeId}"); */

    $("#installStatus").change(function (){
        console.log($("#installStatus").val());
        if($("#installStatus").val() == 4){
            $("#completedHide").show();
            $("#completedHide1").show();
            $("#completedHide2").show();
        }
    });

});

function fn_saveInstall(){
	Common.ajax("POST", "/services/addInstallation.do", $("#addInstallForm").serializeJSON(), function(result) {
        console.log("성공.");
        console.log("data : " + result);
        Common.alert(result.message);
    });
}
function fn_viewInstallResultSearch(){
    var jsonObj = {
            installEntryId : $("#installEntryId").val()
       };
   Common.ajax("GET", "/services/viewInstallationSearch.do", jsonObj, function(result) {
       console.log("성공.");
       console.log("data : " + result);
       AUIGrid.setGridData(myGridID_view, result);
   });

}

function createInstallationViewAUIGrid() {
    //AUIGrid 칼럼 설정
    var columnLayout = [ {
        dataField : "resultId",
        headerText : "ID",
        editable : false,
        width : 130
    }, {
        dataField : "code",
        headerText : "Status",
        editable : false,
        width : 180
    }, {
        dataField : "installDt",
        headerText : "Install Date",
        editable : false,
        width : 180
    }, {
        dataField : "memCode",
        headerText : "CT Code",
        editable : false,
        width : 250
    }, {
        dataField : "name",
        headerText : "CT Name",
        editable : false,
        width : 180
    }];
     // 그리드 속성 설정
    var gridPros = {

        // 페이징 사용
        usePaging : true,

        // 한 화면에 출력되는 행 개수 20(기본값:20)
        pageRowCount : 20,

        editable : true,

        showStateColumn : true,

        displayTreeOpen : true,


        headerHeight : 30,

        // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
        skipReadonlyColumns : true,

        // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
        wrapSelectionMove : true,

        // 줄번호 칼럼 렌더러 출력
        showRowNumColumn : false

    };

    //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
    myGridID_view = AUIGrid.create("#grid_wrap_view", columnLayout, gridPros);
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
</script>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
<header class="pop_header"><!-- pop_header start -->
<h1>Add Installation Result</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="tap_wrap"><!-- tap_wrap start -->
<ul class="tap_type1">
    <li><a href="#" class="on">Order Info</a></li>
    <li><a href="#">Customer Info</a></li>
    <li><a href="#">Installation Info</a></li>
    <li><a href="#">HP Info</a></li>
</ul>

<article class="tap_area"><!-- tap_area start -->

<aside class="title_line"><!-- title_line start -->
<h2>Order Information</h2>
</aside><!-- title_line end -->

<input type="hidden" value="<c:out value="${installResult.installEntryId}"/>" id="installEntryId"/>
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:120px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Type</th>
    <td>
    <span><c:out value="${installResult.codename1}"/></span>
    </td>
    <th scope="row">Install No.</th>
    <td>
    <span><c:out value="${installResult.installEntryNo}"/></span>
    </td>
    <th scope="row">Order No.</th>
    <td>
    <span><c:out value="${installResult.salesOrdNo}"/></span>
    </td>
</tr>
<tr>
    <th scope="row">Ref No.</th>
    <td>
    <span><c:out value="${installResult.refNo}"/></span>
    </td>
    <th scope="row">Order Date</th>
    <td>
    <span><c:out value="${installResult.salesDt}"/></span>
    </td>
    <th scope="row">Application Type</th>
    <c:if test="${installResult.codeid1  == '257' }">
        <td>
        <span><c:out value="${orderInfo.codeName}"/></span>
        </td>
    </c:if>
    <c:if test="${installResult.codeid1  == '258' }">
        <td>
        <span><c:out value="${orderInfo.c5}"/></span>
        </td>
    </c:if>
</tr>
<tr>
    <th scope="row">Remark</th>
    <td colspan="5">
    <span><c:out value="${orderInfo.rem}"/></span>
    </td>
</tr>
<tr>
    <th scope="row">Last updated by</th>
        <td>
        <span><c:out value="${installResult.userName}"/></span>
        </td>
    <th scope="row">Product</th>
    <c:if test="${installResult.codeid1  == '257' }">
        <td>
        <span><c:out value="${orderInfo.stkCode} - ${orderInfo.stkDesc} " /></span>
        </td>
    </c:if>
    <c:if test="${installResult.codeid1  == '258' }">
        <td>
        <span><c:out value="${orderInfo.c6} - ${orderInfo.c7} " /></span>
        </td>
    </c:if>
    <th scope="row">Promotion</th>
    <c:if test="${installResult.codeid1  == '257' }">
        <td>
        <span><c:out value="${orderInfo.c3} - ${orderInfo.c4} " /></span>
        </td>
    </c:if>
    <c:if test="${installResult.codeid1  == '258' }">
         <td>
        <span><c:out value="${orderInfo.c9} - ${orderInfo.c10} " /></span>
        </td>
    </c:if>
</tr>
<tr>
    <th scope="row">Price</th>
    <c:if test="${installResult.codeid1  == '257' }">
        <td>
        <span><c:out value="${orderInfo.c5}"/></span>
        </td>
    </c:if>
    <c:if test="${installResult.codeid1  == '258' }">
        <td>
        <span><c:out value="${orderInfo.c12}"/></span>
        </td>
    </c:if>
    <th scope="row">PV</th>
    <c:if test="${installResult.codeid1  == '257' }">
        <td>
        <span><c:out value="${orderInfo.c6}"/></span>
        </td>
    </c:if>
    <c:if test="${installResult.codeid1  == '258' }">
        <td>
        <span><c:out value="${orderInfo.c13}"/></span>
        </td>
    </c:if>
    <th scope="row"></th>
    <td>
    </td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<aside class="title_line"><!-- title_line start -->
<h2>Customer Information</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Customer Name</th>
    <td>
   <span><c:out value="${customerInfo.name}"/></span>
    </td>
    <th scope="row">Customer NRIC</th>
    <td>
    <span><c:out value="${customerInfo.nric}"/></span>
    </td>
    <th scope="row">Gender</th>
    <td>
    <span><c:out value="${customerInfo.gender}"/></span>
    </td>
</tr>
<tr>
    <th scope="row" rowspan="4">Mailing Address</th>
    <td colspan="5">
    <span></span>
    </td>
</tr>
<tr>
    <td colspan="5">
    <span></span>
    </td>
</tr>
<tr>
    <td colspan="5">
    <span></span>
    </td>
</tr>
<tr>
    <td colspan="5">
    <span></span>
    </td>
</tr>
<tr>
    <th scope="row">Contact Person</th>
    <td>
    <span><c:out value="${customerContractInfo.name}"/></span>
    </td>
    <th scope="row">Gender</th>
    <td>
    <span><c:out value="${customerContractInfo.gender}"/></span>
    </td>
    <th scope="row">Residence No.</th>
    <td>
    <span><c:out value="${customerContractInfo.telR}"/></span>
    </td>
</tr>
<tr>
    <th scope="row">Mobile No.</th>
    <td>
    <span><c:out value="${customerContractInfo.telM1}"/></span>
    </td>
    <th scope="row">Office No.</th>
    <td>
    <span><c:out value="${customerContractInfo.telO}"/></span>
    </td>
    <th scope="row">Fax No.</th>
    <td>
    <span><c:out value="${customerContractInfo.telF}"/></span>
    </td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<aside class="title_line"><!-- title_line start -->
<h2>Installation Information</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Request Install Date</th>
    <td>
    <span><c:out value="${installResult.c1}"/></span>
    </td>
    <th scope="row">Assigned CT</th>
    <td colspan="3">
        <span><c:out value="(${stock.memCode}) ${stock.name}"/></span>
    </td>
</tr>
<tr>
    <th scope="row" rowspan="4">Installation Address</th>
    <td colspan="5">
    <span><c:out value="${installation.Address}"/></span>
    </td>
</tr>
<tr>
    <td colspan="5">
    <span></span>
    </td>
</tr>
<tr>
    <td colspan="5">
    <span></span>
    </td>
</tr>
<tr>
    <td colspan="5">
    <span></span>
    </td>
</tr>
<tr>
    <th scope="row">Special Instruction</th>
    <td>
    <span><c:out value="${installation.instct}"/> </span>
    </td>
    <th scope="row">Preferred Date</th>
    <td>
    </td>
    <th scope="row">Preferred Time  </th>
    <td>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>Installation Contact Person:</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Name</th>
    <td>
    <span><c:out value="${installationContract.name}"/></span>
    </td>
    <th scope="row">Gender</th>
    <td>
    </td>
    <th scope="row">Residence No.</th>
    <td>
    <span><c:out value="${installationContract.telR}"/></span>
    </td>
</tr>
<tr>
    <th scope="row">Mobile No.  </th>
    <td>
    <span><c:out value="${installationContract.telM1}"/></span>
    </td>
    <th scope="row">Office No.</th>
    <td>
    <span><c:out value="${installationContract.telO}"/></span>
    </td>
    <th scope="row">Fax No.</th>
    <td>
    <span><c:out value="${installationContract.telF}"/></span>
    </td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<aside class="title_line"><!-- title_line start -->
<h2>HP Information</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:135px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">HP/Cody Code</th>
    <td>
    <span><c:out value="${hpMember.memCode}"/></span>
    </td>
    <th scope="row">HP/Cody Name</th>
    <td>
    <span><c:out value="${hpMember.name1}"/></span>
    </td>
    <th scope="row">HP/Cody NRIC</th>
    <td>
    <span><c:out value="${hpMember.nric}"/></span>
    </td>
</tr>
<tr>
    <th scope="row">Mobile No.</th>
    <td>
    <span><c:out value="${hpMember.telMobile}"/></span>
    </td>
    <th scope="row">House No.</th>
    <td>
    <span><c:out value="${hpMember.telHuse}"/></span>
    </td>
    <th scope="row">Office No.</th>
    <td>
    <span><c:out value="${hpMember.telOffice}"/></span>
    </td>
</tr>
<tr>
    <th scope="row">Department Code</th>
    <td>
    <span><c:out value="${salseOrder.deptCode}"/></span>
    </td>
    <th scope="row">Group Code</th>
    <td>
    <span><c:out value="${salseOrder.grpCode}"/></span>
    </td>
    <th scope="row">Organization Code</th>
    <td>
    <span><c:out value="${salseOrder.orgCode}"/></span>
    </td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

</section><!-- tap_wrap end -->

<aside class="title_line mt30"><!-- title_line start -->
<h2>View Installation Result</h2>
</aside><!-- title_line end -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_wrap_view" style="width: 100%; height:100px; margin: 0 auto;"></div>
</article><!-- grid_wrap end -->

<aside class="title_line"><!-- title_line start -->
<h2>Add Installation Result</h2>
</aside><!-- title_line end -->

<form action="#" id="addInstallForm" method="post">
<input type="hidden" value="${callType.typeId}" id="hidCallType" name="hidCallType"/>
<input type="hidden" value="${installResult.installEntryId}" id="hidEntryId" name="hidEntryId"/>
<input type="hidden" value="${installResult.custId}" id="hidCustomerId" name="hidCustomerId" />
<input type="hidden" value="${installResult.salesOrdId}" id="hidSalesOrderId" name="hidSalesOrderId" />
<input type="hidden" value="${installResult.sirimNo}" id="hidSirimNo" name="hidSirimNo" />
<input type="hidden" value="${installResult.serialNo}" id="hidSerialNo" name="hidSerialNo" />
<input type="hidden" value="${installResult.isSirim}" id="hidStockIsSirim" name="hidStockIsSirim" />
<input type="hidden" value="${installResult.stkGrad}" id="hidStockGrade" name="hidStockGrade" />
<input type="hidden" value="${installResult.stkCtgryId}" id="hidSirimTypeId" name="hidSirimTypeId" />
<input type="hidden" value="${installResult.codeId}" id="hidAppTypeId" name="hidAppTypeId" />
<input type="hidden" value="${installResult.installStkId}" id="hidProductId" name="hidProductId" />
<input type="hidden" value="${installResult.custAddId}" id="hidCustAddressId" name="hidCustAddressId" />
<input type="hidden" value="${installResult.custCntId}" id="hidCustContactId" name="hidCustContactId" />
<input type="hidden" value="${installResult.custBillId}" id="hiddenBillId" name="hiddenBillId" />
<input type="hidden" value="${installResult.codeName}" id="hiddenCustomerPayMode" name="hiddenCustomerPayMode" />
<input type="hidden" value="${installResult.installEntryNo}" id="hiddeninstallEntryNo" name="hiddeninstallEntryNo" />
<input type="hidden" value="" id="hidActualCTMemCode" name="hidActualCTMemCode" />
<input type="hidden" value="" id="hidActualCTId" name="hidActualCTId" />
<input type="hidden" value="${sirimLoc.whLocCode}" id="hidSirimLoc" name="hidSirimLoc" />
<input type="hidden" value="" id="hidCategoryId" name="hidCategoryId" />
<input type="hidden" value="" id="hidPromotionId" name="hidPromotionId" />
<input type="hidden" value="" id="hidPriceId" name="hidPriceId" />
<input type="hidden" value="" id="hiddenOriPriceId" name="hiddenOriPriceId" />
<input type="hidden" value="${orderInfo.c5}" id="hiddenOriPrice" name="hiddenOriPrice" />
<input type="hidden" value="" id="hiddenOriPV" name="hiddenOriPV" />
<input type="hidden" value="" id="hiddenCatogory" name="hiddenCatogory" />
<input type="hidden" value="" id="hiddenProductItem" name="hiddenProductItem" />
<input type="hidden" value="" id="hidPERentAmt" name="hidPERentAmt" />
<input type="hidden" value="" id="hidPEDefRentAmt" name="hidPEDefRentAmt" />
<input type="hidden" value="" id="hidInstallStatusCodeId" name="hidInstallStatusCodeId" />
<input type="hidden" value="" id="hidPEPreviousStatus" name="hidPEPreviousStatus" />
<input type="hidden" value="" id="hidDocId" name="hidDocId" />
<input type="hidden" value="" id="hidOldPrice" name="hidOldPrice" />
<input type="hidden" value="" id="hidExchangeAppTypeId" name="hidExchangeAppTypeId" />
<input type="hidden" value="" id="hiddenCustomerType" name="hiddenCustomerType" />
<input type="hidden" value="" id="hiddenPostCode" name="hiddenPostCode" />
<input type="hidden" value="" id="hiddenCountryName" name="hiddenCountryName" />
<input type="hidden" value="" id="hiddenStateName" name="hiddenStateName" />
<input type="hidden" value="${promotionView.promoId}" id="hidPromoId" name="hidPromoId" />
<input type="hidden" value="${promotionView.promoPrice}" id="hidPromoPrice" name="hidPromoPrice" />
<input type="hidden" value="${promotionView.promoPV}" id="hidPromoPV" name="hidPromoPV" />
<input type="hidden" value="${promotionView.swapPromoId}" id="hidSwapPromoId" name="hidSwapPromoId" />
<input type="hidden" value="${promotionView.swapPormoPrice}" id="hidSwapPromoPrice" name="hidSwapPromoPrice" />
<input type="hidden" value="${promotionView.swapPromoPV}" id="hidSwapPromoPV" name="hidSwapPromoPV" />
<input type="hidden" value="" id="hiddenInstallPostcode" name="hiddenInstallPostcode" />
<input type="hidden" value="" id="hiddenInstallPostcode" name="hiddenInstallPostcode" />
<input type="hidden" value="" id="hiddenInstallStateName" name="hiddenInstallStateName" />

<input type="hidden" value="${customerInfo.name}" id="hidCustomerName" name="hidCustomerName"  />
<input type="hidden" value="${customerContractInfo.telM1}" id="hidCustomerContact" name="hidCustomerContact"  />
<input type="hidden" value="${installResult.salesOrdNo}" id="hidTaxInvDSalesOrderNo" name="hidTaxInvDSalesOrderNo"  />
<input type="hidden" value="${installResult.installEntryNo}" id="hidTradeLedger_InstallNo" name="hidTradeLedger_InstallNo"  />
 <c:if test="${installResult.codeid1  == '257' }">
      <input type="hidden" value="${orderInfo.c5}" id = "hidOutright_Price" name = "hidOutright_Price" />
 </c:if>
 <c:if test="${installResult.codeid1  == '258' }">
<input type="hidden" value=" ${orderInfo.c12}" id = "hidOutright_Price" name = "hidOutright_Price" />
 </c:if>
 <input type="hidden" value="${installation.Address}" id="hidInstallation_AddDtl" name = "hidInstallation_AddDtl" />
<input type="hidden" value="${installation.areaId}" id = "hidInstallation_AreaID" name = "hidInstallation_AreaID"/>
<input type="hidden" value="${customerContractInfo.name}" id = "hidInatallation_ContactPerson" name = "hidInatallation_ContactPerson"/>


<table class="type1 mb1m"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:350px" />
    <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Install Status</th>
    <td>
    <select class="w100p" id="installStatus" name="installStatus">
        <c:forEach var="list" items="${installStatus }" varStatus="status">
           <option value="${list.codeId}">${list.codeName}</option>
        </c:forEach>
    </select>
    </td>
    <th scope="row">Actual Install Date</th>
    <td><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p"  id="installDate" name="installDate"/></td>
</tr>
<tr>
    <th scope="row">CT Code</th>
    <td><input type="text" title="" placeholder="" class="" style="width:200px;" id="ctCode" name="ctCode" />
    <input type="hidden" title="" value="16495" placeholder="" class="" style="width:200px;" id="CTID" name="CTID" />
    <p class="btn_sky"><a href="#">Search</a></p></td>
    <th scope="row">CT Name</th>
    <td><input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="ctName" name="ctName"/></td>
</tr>
</tbody>
</table><!-- table end -->

<table class="type1" id="completedHide"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:130px" />
    <col style="width:110px" />
    <col style="width:110px" />
    <col style="width:110px" />
    <col style="width:*" />
    <col style="width:110px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">SIRIM No.</th>
    <td><input type="text" title="" placeholder="" class="w100p" id="sirimNo" name="sirimNo" /></td>
    <th scope="row">Serial No.</th>
    <td><input type="text" title="" placeholder="" class="w100p" id="serialNo" name="serialNo"/></td>
    <th scope="row">Ref No. (1)</th>
    <td><input type="text" title="" placeholder="" class="w100p" id="refNo1" name="refNo1"/></td>
    <th scope="row">Ref No. (2)</th>
    <td><input type="text" title="" placeholder="" class="w100p" id="refNo2" name="refNo2"/></td>
</tr>
<tr>
    <td colspan="8">
    <label><input type="checkbox" id="checkCommission" name="checkCommission"/><span>Allow Commission ?</span></label>
    <label><input type="checkbox" id="checkTrade" name="checkTrade"/><span>Is trade in ?</span></label>
    <label><input type="checkbox" id="checkSms" name="checkSms"/><span>Require SMS ?</span></label>
    </td>
</tr>
</tbody>
</table><!-- table end -->



<aside class="title_line" id="completedHide1"><!-- title_line start -->
<h2>SMSInfo</h2>
</aside><!-- title_line end -->

<table class="type1" id="completedHide2"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:110px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <td colspan="2">
    <label><input type="checkbox" id="checkSend" name="checkSend" /><span>Send SMS to Sales Person?</span></label>
    </td>
</tr>
<tr>
    <th scope="row" rowspan="2">Message</th>
    <td>
    <textarea cols="20" rows="5" readonly="readonly" class="readonly" id="msg" name="msg">
RM0.00 COWAY DSC
Install Status: Completed
Order No: 0805892
Name: HM MUHAMMAD IMRAN - ROADSHOW</textarea>
    </td>
</tr>
<tr>
    <td><input type="text" title="" placeholder="" class="w100p" value="Remark:" id="msgRemark" name="msgRemark"/></td>
</tr>
</tbody>
</table><!-- table end -->
<table class="type1" id="failHide3"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:110px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Failed Reason</th>
    <td>
        <select class="w100p" id="failReason" name="failReason">
	        <c:forEach var="list" items="${failReason }" varStatus="status">
	            <option value="0">Failed Reason</option>
	           <option value="${list.resnId}">${list.c1}</option>
	        </c:forEach>
    </select>
    </td>
    <th scope="row">Next Call Date</th>
    <td>
        <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p"  id="nextCallDate" name="nextCallDate"/>
    </td>
</tr>
</tbody>
</table><!-- table end -->
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:110px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Remark</th>
    <td><input type="text" title="" placeholder="" class="w100p" id="remark" name="remark" /></td>
</tr>
</tbody>
</table><!-- table end -->
</form>
<ul class="center_btns">
    <li><p class="btn_blue2"><a href="#" onclick="fn_saveInstall()">Save Installation Result</a></p></li>
</ul>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
