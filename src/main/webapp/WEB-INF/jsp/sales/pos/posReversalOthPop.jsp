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

//Ajax Async
var ajaxOpt= {
		async : false
};

//Doc Ready Func
$(document).ready(function() {
    
    /*#######  Init Field ########*/
    
    //1. POS MASTER
    //PosModuleTypeComboBox
    var moduleParam = {groupCode : 143, codeIn : [2390, 2391, 2392]};
    var moduleSelVal = $("#_rePosModuleTypeId").val();
    CommonCombo.make('_reversalPosModuleTypeId', "/sales/pos/selectPosModuleCodeList", moduleParam , moduleSelVal, optionModule);
    
    //PosSystemTypeComboBox
    var systemParam = {groupCode : 140 , codeIn : [1352, 1353, 1357]};
    var systemSelVal = $("#_rePosSysTypeId").val();
    CommonCombo.make('_reversalPosTypeId', "/sales/pos/selectPosModuleCodeList", systemParam , systemSelVal, optionSystem);
    
    var magicAddrParam = { areaId : $("#_getAreaId").val()};
    var mArea;
    var mCity;
    var mPostCd;
    var mState;
    
    Common.ajax("GET", "/sales/pos/getAddressDetails", magicAddrParam, function (result){
    	
    	/* console.log("result.area : " + result.area);
    	console.log("result.city : " + result.city);
    	console.log("result.postcode : " + result.postcode);
    	console.log("result.state : " + result.state); */
        $("#mArea").val(result.area);
    	$("#mCity").val(result.city);
    	$("#mPostCd").val(result.postcode);
    	$("#mState").val(result.state);
    	
    });
    
    
  /*   //branch List(Warehouse)
    var whbrnchSelVal = $("#_rePosWhBrnchId").val();
    if(moduleSelVal == 2392){
        $("#_reversalPosWhBrnchId").val('');
        $("#_reversalPosWhBrnchId").attr({"class" : "disabled"});
    }else{
        CommonCombo.make('_reversalPosWhBrnchId', "/sales/pos/selectWhBrnchList", '' , whbrnchSelVal , optionModule);
    } */
    
    
    
    /* //Get Wharehouse`s Desc
    var paramObj = {brnchId : whbrnchSelVal};
    Common.ajax('GET', "/sales/pos/selectWarehouse", paramObj,function(result){
        if(result != null){
            $("#_reversalPosWhDesc").val(result.whLocDesc);    
        }else{
            $("#_reversalPosWhDesc").val('');
        }
    }); */
    
    
    //2. POS DETAIL - GRID
    createPurchaseGridID();
    
    //Mybatis Separate Param
    var filterType = '';
    var itembankType = '';
    if($("#_rePosSysTypeId").val() == 1352){   //filter
        //파라미터 주기
        filterType = $("#_rePosSysTypeId").val();
    }
    if($("#_rePosSysTypeId").val() == 1353 || $("#_rePosSysTypeId").val() == 1357){   //item bank
        // 파라미터 주기
        itembankType = $("#_rePosSysTypeId").val();
    }
    
    //파라미터 세팅
    var detailParam = {filterType : filterType , itembankType : itembankType , rePosId : $("#_rePosId").val()};
    //Ajax
    Common.ajax("GET", "/sales/pos/getPosDetailList", detailParam, function(result){
        AUIGrid.setGridData(posChargeBalGridID, result);
    });    
    
    
    //Save
    $("#_confirmReversalBtn").click(function() {
        
        console.log("rem : " + $("#_reversalRem").val());
        //Validation
        if ($("#_reversalRem").val() == null || $("#_reversalRem").val().trim() == "") {
            Common.alert("* Reversal Remark can not be Empty!.");
            return;
        }
        
        //Param Setting
      //   $("#_rePosRcvDt").val($("#_recevDateOri").val());
         Common.ajax("POST", "/sales/pos/insertPosReversal.do", $("#_revForm").serializeJSON(), function(result){
             
             if(result == null){
                 Common.alert("<b>Failed to reverse. Please try again later.</b>");
             }else{
                 //console.log("result : "+result);
                 //console.log("result.posRefNo : " + result.posRefNo); 
                 Common.alert("POS Reverse successfully. <br />  POS Ref No. : " + result.posRefNo + " <br />" , fn_popClose());
             }
         });
    });
    
})//Doc Ready Func End


function fn_popClose(){
    $("#_reversalClose").click();
}

function createPurchaseGridID(){
    
    
    var posColumnLayout =  [ 
                            {dataField : "stkCode", headerText : "Item Code", width : '10%'}, 
                            {dataField : "stkDesc", headerText : "Item Description", width : '30%'},
                            {dataField : "qty", headerText : "Qty", width : '12%'},
                            {dataField : "amt", headerText : "Unit Price", width : '12%' , dataType : "numeric", formatString : "#,##0.00"}, 
                            {dataField : "chrg", headerText : "Sub Total(Exclude GST)", width : '12%', dataType : "numeric", formatString : "#,##0.00"},
                            {dataField : "txs", headerText : "GST(6%)", width : '12%', dataType : "numeric", formatString : "#,##0.00"},
                            {dataField : "tot", headerText : "Total Amount", width : '12%', dataType : "numeric", formatString : "#,##0.00"}
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
            showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력
            noDataMessage       : "No Item found.",
            groupingMessage     : "Here groupping"
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

</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
<form id="_revForm">
<!--Hidden Value  -->
<input type="hidden" id="_rePosCustName" name="rePosCustName" value="${revDetailMap.posCustName}">
<input type="hidden" id="_rePosModuleTypeId" name="rePosModuleTypeId" value="${revDetailMap.posModuleTypeId}">
<input type="hidden" id="_rePosWhId" name="rePosWhId" value="${revDetailMap.posWhId}">
<input type="hidden" id="_rePosId" name="rePosId" value="${revDetailMap.posId}">
<input type="hidden" id="_rePosMemId" name="rePosMemId" value="${revDetailMap.posMemId}">
<input type="hidden" id="_rePosCrAccId" name="rePosCrAccId" value="${revDetailMap.crAccId}"> 
<input type="hidden" id="_rePosDrAccId" name="rePosDrAccId" value="${revDetailMap.drAccId}">
<input type="hidden" id="_rePosStusId" name="rePosStusId" value="${revDetailMap.stusId}">  
<input type="hidden" id="_rePosResnId" name="rePosResnId" value="${revDetailMap.posResnId}">
<input type="hidden" id="_rePosBrnchId" name="rePosBrnchId" value="${revDetailMap.brnchId}">

<input type="hidden" id="_rePosRcvDt" name="rePosRcvDt" > <!-- from Display  --> 

<!-- Price and Tax  -->
<input type="hidden" id="_rePosTotAmt" name="rePosTotAmt" value="${revDetailMap.posTotAmt}">
<input type="hidden" id="_rePosTotChrg" name="rePosTotChrg" value="${revDetailMap.posTotChrg}">
<input type="hidden" id="_rePosTotTxs" name="rePosTotTxs" value="${revDetailMap.posTotTxs}">
<input type="hidden" id="_rePosTotDscnt" name="rePosTotDscnt" value="${revDetailMap.posTotDscnt}">

<input type="hidden" id="_rePosSysTypeId" name="rePosSysTypeId" value="${revDetailMap.posTypeId}">
<input type="hidden" id="_rePosBillId" name="rePosBillId" value="${revDetailMap.posBillId}">
<input type="hidden" id="_rePosNo" name="rePosNo" value="${revDetailMap.posNo}">  <!-- PNS00.... -->
<%-- <input type="hidden" id="_salesmanPopCd" name="salesmanPopCd" value="${revDetailMap.memCode}"> --%>

<!-- Magic Address  -->
<input type="hidden" id="_getAreaId"  name="getAreaId" value="${revDetailMap.areaId }">
<input type="hidden"  placeholder="DD/MM/YYYY" class="j_date" value="${revDetailMap.posDt}"   id="_getRcvDt" name="rePosRcvDt"/>
 
<header class="pop_header"><!-- pop_header start -->
<h1>POS Reversal</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a id="_reversalClose">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<ul class="right_btns">
    <li><p class="btn_blue2"><a href="#">Save</a></p></li>
</ul>

<aside class="title_line"><!-- title_line start -->
<h2>POS Information</h2>
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
    <th scope="row">POS Type<span class="must">*</span></th>
    <td>
    <select class="w100p disabled" id="_reversalPosModuleTypeId" disabled="disabled"></select>
    </td>
    <th scope="row">POS Sales Type<span class="must">*</span></th>
    <td>
    <select class="w100p disabled" id="_reversalPosTypeId" disabled="disabled"></select>
    </td>
</tr>
</tbody>
</table><!-- table end -->


<aside class="title_line"><!-- title_line start -->
<h2>Particular Information</h2>
</aside><!-- title_line end -->


<!-- MAGIC ADDRESS PARTS  -->
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
     <th scope="row">Customer Name</th>
     <td colspan="3">
        <input type="text" title="" placeholder="CustomerName" class="w100p readonly"  value="${revDetailMap.posCustName}" name="insPosCustName" readonly="readonly"/>
    </td>   
</tr>
<tr>
    <th scope="row">Address Detail</th>
    <td colspan="3">
        <input type="text" title="" id="addrDtl" name="addrDtl" placeholder="Detail Address" class="w100p readonly"  value="${revDetailMap.addrDtl}"  readonly="readonly"/>
    </td>
</tr>
<tr>
    <th scope="row">Street</th>
    <td colspan="3">
        <input type="text" title="" id="streetDtl" name="streetDtl" placeholder="Detail Street" class="w100p readonly"  value="${revDetailMap.street}" readonly="readonly"/>
    </td>
</tr>
<tr>  
    <th scope="row">Area(4)<span class="must">*</span></th>
    <td colspan="3">
        <input type="text" title="" id="mArea"  class="w100p readonly"  readonly="readonly"/>
    </td>
</tr>
<tr>
    <th scope="row">City(2)<span class="must">*</span></th>
    <td>
    <input type="text" title="" id="mCity"  class="w100p readonly"  readonly="readonly"/>  
    </td>
    <th scope="row">PostCode(3)<span class="must">*</span></th>
    <td>
    <input type="text" title="" id="mPostCd"  class="w100p readonly"  readonly="readonly"/>
    </td>
</tr>
<tr>
    <th scope="row">State(1)<span class="must">*</span></th>
    <td>
    <input type="text" title="" id="mState"  class="w100p readonly"  readonly="readonly"/>
    </td>
    <th scope="row">Country<span class="must">*</span></th>
    <td>
    <input type="text" title="" id="mCountry" name="mCountry" placeholder="" class="w100p readonly" readonly="readonly" value="Malaysia"/>
    </td>
</tr>
<tr>
    <th scope="row">Remark</th>
    <td colspan="3">
        <input type="text" title="" placeholder="" class="w100p readonly"  id="_posRemark" name="posRemark" value="${revDetailMap.posRem}" readonly="readonly"/> 
    </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>Charges Balance</h2>
</aside><!-- title_line end -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="item_grid_wrap" style="width:100%; height:300px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

<aside class="title_line"><!-- title_line start -->
<h2>Reversal Details</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Reversal Remark</th>
    <td>
        <input type="text" title="" placeholder="" class="w100p"  id="_reversalRem" name="reversalRem"/>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a id="_confirmReversalBtn">Confirm to Reversal</a></p></li>
</ul>
</section><!-- pop_body end -->
</form>
</div><!-- popup_wrap end -->