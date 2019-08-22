<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">

//Create and Return Grid ID
var posChargeBalGridID;

//Combo Options
var optionModule = {
        type: "S",
        isShowChoose: false
};
var optionSystem = {
        type: "S",
        isShowChoose: false
};

//Doc Ready Func
$(document).ready(function() {

    //1. POS MASTER
    //PosModuleTypeComboBox
    var moduleParam = {groupCode : 143, codeIn : [2390]};
    var moduleSelVal = $("#_PosFlexiModuleTypeId").val();
    CommonCombo.make('_confirmPosModuleTypeId', "/sales/pos/selectPosModuleCodeList", moduleParam , moduleSelVal, optionModule);

    //PosSystemTypeComboBox
    var systemParam = {groupCode : 140 , codeIn : [5570]};
    var systemSelVal = $("#_PosFlexiSysTypeId").val();
    CommonCombo.make('_confirmPosTypeId', "/sales/pos/selectPosModuleCodeList", systemParam , systemSelVal, optionSystem);

    //branch List(Warehouse)
    var whbrnchSelVal = $("#_PosFlexiBrnchId").val();
    console.log("whbrnchSelVal : " + whbrnchSelVal);
    CommonCombo.make('_confirmPosWhBrnchId', "/sales/pos/selectWhBrnchList", '' , whbrnchSelVal , optionModule);

    //Get Wharehouse`s Desc
    var paramObj = {brnchId : whbrnchSelVal};
    Common.ajax('GET', "/sales/pos/selectWarehouse", paramObj,function(result){
        if(result != null){
            $("#_confirmPosWhDesc").val(result.whLocDesc);
        }else{
            $("#_confirmPosWhDesc").val('');
        }
    });


    //2. POS DETAIL - GRID
    createPurchaseGridID();

    //파라미터 세팅
    var detailParam = {rePosId : $("#_PosFlexiId").val()};
    //Ajax
    Common.ajax("GET", "/sales/pos/getPosDetailList", detailParam, function(result){
        AUIGrid.setGridData(posChargeBalGridID, result);
    });





})//Doc Ready Func End


function fn_popClose(){
    $("#_confirmClose").click();
}

function createPurchaseGridID(){


    var posColumnLayout =  [
                            {dataField : "stkCode", headerText : '<spring:message code="sal.title.itemCode" />', width : '10%'},
                            {dataField : "stkDesc", headerText : '<spring:message code="sal.title.itemDesc" />', width : '30%'},
                            {dataField : "qty", headerText : '<spring:message code="sal.title.qty" />', width : '12%'},
                            {dataField : "amt", headerText : '<spring:message code="sal.title.unitPrice" />', width : '12%' , dataType : "numeric", formatString : "#,##0.00"},
                            {dataField : "chrg", headerText : '<spring:message code="sal.title.subTotalExclGST" />', width : '12%', dataType : "numeric", formatString : "#,##0.00"},
                            {dataField : "txs", headerText : '<spring:message code="sal.title.gstSixPerc" />', width : '12%', dataType : "numeric", formatString : "#,##0.00"},
                            {dataField : "tot", headerText : '<spring:message code="sal.text.totAmt" />', width : '12%', dataType : "numeric", formatString : "#,##0.00"}
                           ];

    //그리드 속성 설정
    var gridPros = {
            showFooter : true,
            usePaging           : true,         //페이징 사용
            pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)
            editable            : false,
            fixedColumnCount    : 1,
            showStateColumn     : false,
            displayTreeOpen     : false,
   //         selectionMode       : "singleRow",  //"multipleCells",
            headerHeight        : 30,
            useGroupingPanel    : false,        //그룹핑 패널 사용
            skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            showRowNumColumn    : true
    };

    posChargeBalGridID = GridCommon.createAUIGrid("#item_grid_wrap", posColumnLayout,'', gridPros);  // address list
    AUIGrid.resize(posChargeBalGridID , 960, 300);

    //
    var footerLayout = [ {
        labelText : "Total(RM)",
        positionField : "#base"
      },{
        dataField : "chrg",
        positionField : "chrg",
        operation : "SUM",
        formatString : "#,##0.00",
        style : "aui-grid-my-footer-sum-total2"
      }, {
        dataField : "txs",
        positionField : "txs",
        operation : "SUM",
        formatString : "#,##0.00",
        style : "aui-grid-my-footer-sum-total2"
       },{
           dataField : "tot",
           positionField : "tot",
           operation : "SUM",
           formatString : "#,##0.00",
           style : "aui-grid-my-footer-sum-total2"
      }];
//
   // 푸터 레이아웃 그리드에 설정
   AUIGrid.setFooter(posChargeBalGridID, footerLayout);
}



function fn_reSizeAllGrid(){
    AUIGrid.resize(posChargeBalGridID , 960, 300);
}

function fn_UpdatePosFlexiStatusApprove(){
	var posFlexiRemark = $("#_confirmRem").val();

/* 	   if (posFlexiRemark == null || posFlexiRemark == ""){
	        Common.alert("* Please fill in the Remark.");
	        return false;
	    } */

var params =  {"posFlexiId" : '${posDetailMap.posId}', "posFlexiNo" : '${posDetailMap.posNo}' , "posFlexiRemark" : $("#_confirmRem").val()};

    Common.ajax("POST", "/sales/pos/confirmPosFlexi.do", params  , function(result) {
        Common.alert(result.message, fn_parentReload);
        $("#_confirmClose").click();
      });

}

function fn_UpdatePosFlexiStatusReject(){
    var posFlexiRemark = $("#_confirmRem").val();

  /*      if (posFlexiRemark == null || posFlexiRemark == ""){
            Common.alert("* Please fill in the Remark.");
            return false;
        } */
var params =  {"posFlexiId" : '${posDetailMap.posId}', "posFlexiNo" : '${posDetailMap.posNo}' , "posFlexiRemark" : $("#_confirmRem").val()};

    Common.ajax("POST", "/sales/pos/rejectPosFlexi.do", params , function(result) {
        Common.alert(result.message, fn_parentReload);
        $("#_confirmClose").click();
      });

}


function fn_parentReload() {
	fn_getPosListAjax();//parent Method (Reload)
  }

</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
<form id="posFlexiForm">
<!--Hidden Value  -->
<input type="hidden" id="_PosFlexiCustName" name="PosFlexiCustName" value="${posDetailMap.posCustName}">
<input type="hidden" id="_PosFlexiModuleTypeId" name="PosFlexiModuleTypeId" value="${posDetailMap.posModuleTypeId}">
<input type="hidden" id="_PosFlexiWhId" name="PosFlexiWhId" value="${posDetailMap.posWhId}">
<input type="hidden" id="_PosFlexiId" name="PosFlexiId" value="${posDetailMap.posId}">
<input type="hidden" id="_PosFlexiMemId" name="PosFlexiMemId" value="${posDetailMap.posMemId}">
<input type="hidden" id="_PosFlexiCrAccId" name="PosFlexiCrAccId" value="${posDetailMap.crAccId}">
<input type="hidden" id="_PosFlexiDrAccId" name="PosFlexiDrAccId" value="${posDetailMap.drAccId}">
<input type="hidden" id="_PosFlexiStusId" name="PosFlexiStusId" value="${posDetailMap.stusId}">
<input type="hidden" id="_PosFlexiResnId" name="PosFlexiResnId" value="${posDetailMap.posResnId}">
<input type="hidden" id="_PosFlexiBrnchId" name="PosFlexiBrnchId" value="${posDetailMap.brnchId}">



<input type="hidden" id="_PosFlexiRcvDt" name="PosFlexiRcvDt" > <!-- from Display  -->

<!-- Price and Tax  -->
<input type="hidden" id="_PosFlexiTotAmt" name="PosFlexiTotAmt" value="${posDetailMap.posTotAmt}">
<input type="hidden" id="_PosFlexiTotChrg" name="PosFlexiTotChrg" value="${posDetailMap.posTotChrg}">
<input type="hidden" id="_PosFlexiTotTxs" name="PosFlexiTotTxs" value="${posDetailMap.posTotTxs}">
<input type="hidden" id="_PosFlexiTotDscnt" name="PosFlexiTotDscnt" value="${posDetailMap.posTotDscnt}">

<input type="hidden" id="_PosFlexiSysTypeId" name="PosFlexiSysTypeId" value="${posDetailMap.posTypeId}">
<input type="hidden" id="_PosFlexiBillId" name="PosFlexiBillId" value="${posDetailMap.posBillId}">
<input type="hidden" id="_PosFlexiNo" name="PosFlexiNo" value="${posDetailMap.posNo}">  <!-- PNS00.... -->



<header class="pop_header"><!-- pop_header start -->
<h1>POS - Flexi Point Convert</h1>
<ul class="right_opt">

    <li><p class="btn_blue2"><a id="_rejectBtn" onclick="fn_UpdatePosFlexiStatusReject()">REJECT</a></p></li>

    <li><p class="btn_blue2"><a id="_approveBtn" onclick="fn_UpdatePosFlexiStatusApprove()">APPROVE</a></p></li>

    <li><p class="btn_blue2"><a id="_confirmClose"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<!-- <ul class="right_btns">
    <li><p class="btn_blue2"><a href="#">Save</a></p></li>
</ul> -->

<section class="tap_wrap"><!-- tap_wrap start -->
<ul class="tap_type1">
    <li><a href="#" class="on" onclick="javascript: fn_reSizeAllGrid()"><spring:message code="sal.title.text.purcInfo" /></a></li>
</ul>

<article class="tap_area"><!-- tap_area start -->
<aside class="title_line"><!-- title_line start -->
<h2><spring:message code="sal.title.text.posInfo" /></h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.title.posType" /><span class="must">*</span></th>
    <td>
    <select class="w100p disabled" id="_confirmPosModuleTypeId" disabled="disabled"></select>
    </td>
    <th scope="row"><spring:message code="sal.title.text.posSalesType" /><span class="must">*</span></th>
    <td>
    <select class="w100p disabled" id="_confirmPosTypeId" disabled="disabled"></select>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2><spring:message code="sal.title.text.particInfo" /></h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:160px" />
    <col style="width:230px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.memberCode" /><span class="must">*</span></th>
    <td colspan="2">
        <input type="text" title="" placeholder="" class="w100p disabled"  value="${posDetailMap.memCode}" disabled="disabled" /><!-- <a href="#" class="search_btn"><img src="../images/common/normal_search.gif" alt="search" /></a> -->
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.brnchWarehouse" /><span class="must">*</span></th>
    <td>
        <select  id="_confirmPosWhBrnchId" disabled="disabled" class="disabled w100p"></select>
    </td>
    <td style="padding-left:0">
        <input type="text" disabled="disabled" id="_confirmPosWhDesc" >
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.recvDate" /><span class="must">*</span></th>
    <td>
        <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" value="${posDetailMap.posDt}" disabled="disabled"  id="_recevDateOri"/>
    </td>
    <td></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.remarks" /></th>
    <td colspan="2">
        <input type="text" title="" placeholder="" class="w100p disabled" value="${posDetailMap.posRem}" disabled="disabled"/>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2><spring:message code="sal.title.text.chargeBal" /></h2>
</aside><!-- title_line end -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="item_grid_wrap" style="width:100%; height:300px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->
</article><!-- tap_area end -->

</section><!-- tap_wrap end -->

<aside class="title_line"><!-- title_line start -->
<h2>POS - Flexi Point Convert Remark </h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Remark</th>
    <td>
        <input type="text" title="" placeholder="" class="w100p"  id="_confirmRem" name="confirmRem"/>
    </td>
</tr>
</tbody>
</table><!-- table end -->

</section><!-- pop_body end -->
</form>
</div><!-- popup_wrap end -->