<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">

//isPay Tab Check
var isPayChk = '${isPayed}';


//Create and Return Grid ID
var posChargeBalGridID;
var posRePayGridID;

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
	
	/*#######  Init Field ########*/
	//is Pay Check
	if(isPayChk == "0"){
		$("#_isPayTab").css("display" , "none");
	}else{
		$("#_isPayTab").css("display" , "");
		//Pay Grid Create
		createRePayGrid();
		fn_setPayGridData();
		
	}
	
	
	//1. POS MASTER
	//PosModuleTypeComboBox
    var moduleParam = {groupCode : 143, codeIn : [2390, 2391, 2392]};
	var moduleSelVal = $("#_rePosModuleTypeId").val();
    CommonCombo.make('_reversalPosModuleTypeId', "/sales/pos/selectPosModuleCodeList", moduleParam , moduleSelVal, optionModule);
    
    //PosSystemTypeComboBox
    var systemParam = {groupCode : 140 , codeIn : [1352, 1353, 1357, 1358]};
    var systemSelVal = $("#_rePosSysTypeId").val();
    CommonCombo.make('_reversalPosTypeId', "/sales/pos/selectPosModuleCodeList", systemParam , systemSelVal, optionSystem);
	
    //branch List(Warehouse)
    var whbrnchSelVal = $("#_rePosBrnchId").val();
    console.log("whbrnchSelVal : " + whbrnchSelVal);
    if(moduleSelVal == 2392 && systemSelVal == 1357){
    	console.log("2392 && 1357");
    	$("#_reversalPosWhBrnchId").val('');
    	$("#_reversalPosWhBrnchId").attr({"class" : "disabled"});
    }else{
    	console.log("else~");
    	CommonCombo.make('_reversalPosWhBrnchId', "/sales/pos/selectWhBrnchList", '' , whbrnchSelVal , optionModule);
    }
    
    
	
    //Get Wharehouse`s Desc
    var paramObj = {brnchId : whbrnchSelVal};
    Common.ajax('GET', "/sales/pos/selectWarehouse", paramObj,function(result){
        if(result != null){
            $("#_reversalPosWhDesc").val(result.whLocDesc);    
        }else{
            $("#_reversalPosWhDesc").val('');
        }
    });
    
    
    //2. POS DETAIL - GRID
    createPurchaseGridID();
    
    //Mybatis Separate Param
  /*   var filterType = '';
    var itembankType = '';
    if($("#_rePosSysTypeId").val() == 1352){   //filter
    	//파라미터 주기
    	filterType = $("#_rePosSysTypeId").val();
    }
    if($("#_rePosSysTypeId").val() == 1353 || $("#_rePosSysTypeId").val() == 1357){   //item bank
    	// 파라미터 주기
    	itembankType = $("#_rePosSysTypeId").val();
    } */
    
    //파라미터 세팅
    var detailParam = {rePosId : $("#_rePosId").val()};
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
    	 $("#_rePosRcvDt").val($("#_recevDateOri").val());
    	 Common.ajax("POST", "/sales/pos/insertPosReversal.do", $("#_revForm").serializeJSON(), function(result){
    		 
    		 var returnMsg = "POS Reverse successfully. <br /> ";
    		 
    		 if(result == null){
    			 Common.alert("<b>Failed to reverse. Please try again later.</b>");
    		 }else{
    			 //console.log("result : "+result);
                 //console.log("result.posRefNo : " + result.posRefNo);
                 
                 if(result.posWorNo != null && result.posWorNo != ''){
                	 returnMsg += "POS Ref No. : " + result.posRefNo + " <br />";	 
                 }
                 if(result.posWorNo != null && result.posWorNo != ''){
                	 returnMsg += "POS Ref No. : " + result.posWorNo + " <br />";
                 }
                 Common.alert(returnMsg , fn_popClose());
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
            selectionMode       : "singleRow",  //"multipleCells",            
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

function createRePayGrid(){
	
	var paymentColumnLayout =  [ 
                                {dataField : "codeName" , headerText : "Mode", width : "10%",  editable : false },
                                {dataField : "payItmRefNo" , headerText : "Ref No", width : "10%",  editable : false },
                                {dataField : "payItmAmt" , headerText : "Amount", width : "10%",  editable : false, dataType : "numeric", formatString : "#,##0.00" },
                                {dataField : "payItmOriCcNo" , headerText : "C.Card", width : "10%",  editable : false },
                                {dataField : "payItmAppvNo" , headerText : "Aproval No", width : "10%",  editable : false },
                                {dataField : "payItmCardModeCode" , headerText : "CRC Mode", width : "10%",  editable : false }, 
                                {dataField : "name" , headerText : "Issued Bank", width : "8%",  editable : false },
                                {dataField : "accDesc" , headerText : "Bank Acc", width : "10%",  editable : false },
                                {dataField : "payItmRefDt" , headerText : "Ref Date", width : "10%",  editable : false }, 
                                {dataField : "payItmRem" , headerText : "Remark", width : "10%",  editable : false }
                                
                            ];
    
var payGridPros = {
            
            usePaging           : true,         //페이징 사용
            pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)            
            fixedColumnCount    : 1,            
            showStateColumn     : false,             
            displayTreeOpen     : false, 
            editable : false,
            selectionMode       : "singleRow",  //"multipleCells",            
            headerHeight        : 30,       
            useGroupingPanel    : false,        //그룹핑 패널 사용
            skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력
            softRemoveRowMode : false,
            showRowCheckColumn : false, //checkBox
            noDataMessage       : "No Item found.",
            groupingMessage     : "Here groupping"
    };
    
    posRePayGridID = GridCommon.createAUIGrid("#rePay_grid_wrap", paymentColumnLayout,'', payGridPros);  // address list
    AUIGrid.resize(posRePayGridID , 960, 300);
}

function fn_reSizeAllGrid(){
    AUIGrid.resize(posChargeBalGridID , 960, 300);
    AUIGrid.resize(posRePayGridID , 960, 300);
}

function fn_setPayGridData(){
	
	var payParam = {rePayId : $("#_rePayId").val()};
	Common.ajax("GET", "/sales/pos/getPayDetailList", payParam, function(result) {
		
		AUIGrid.setGridData(posRePayGridID, result);
		
	});
	
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

<!--Pay Id  --> 
<input type="hidden" id="_rePayId" name="rePayId" value="${payDetailMap.payId}">

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

<section class="tap_wrap"><!-- tap_wrap start -->
<ul class="tap_type1">
    <li><a href="#" class="on" onclick="javascript: fn_reSizeAllGrid()">purchase info</a></li>
    <li id="_isPayTab"><a onclick="javascript: fn_reSizeAllGrid()">payment mode</a></li>
</ul>

<article class="tap_area"><!-- tap_area start -->
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

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:160px" />
    <col style="width:230px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Member Code<span class="must">*</span></th>
    <td colspan="2">
        <input type="text" title="" placeholder="" class="w100p disabled"  value="${revDetailMap.memCode}" disabled="disabled" /><!-- <a href="#" class="search_btn"><img src="../images/common/normal_search.gif" alt="search" /></a> -->
    </td>
</tr>
<tr>
    <th scope="row">Branch / Warehouse<span class="must">*</span></th>
    <td>
        <select  id="_reversalPosWhBrnchId" disabled="disabled" class="disabled w100p"></select>
    </td>
    <td style="padding-left:0">
        <input type="text" disabled="disabled" id="_reversalPosWhDesc" >
    </td>
</tr>
<tr>
    <th scope="row">Receive Date<span class="must">*</span></th>
    <td>
        <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" value="${revDetailMap.posDt}" disabled="disabled"  id="_recevDateOri"/>
    </td>
    <td></td>
</tr>
<tr>
    <th scope="row">Remark</th>
    <td colspan="2">
        <input type="text" title="" placeholder="" class="w100p disabled" value="${revDetailMap.posRem}" disabled="disabled"/>
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
</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<aside class="title_line"><!-- title_line start -->
<h2>Payment Information</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Total Charges</th>
    <td>${payDetailMap.posTotAmt}</td>
    <th scope="row">Receipt No</th>
    <td>${payDetailMap.orNo}</td>
    <th scope="row">Debtor Acc</th>
    <td>${payDetailMap.accCode} - ${payDetailMap.accDesc}</td>
</tr>
<tr>
    <th scope="row">Branch Code</th>
    <td>${payDetailMap.code} - ${payDetailMap.name1}</td>
    <th scope="row">TR Ref No</th>
    <td>${payDetailMap.trNo}</td>
    <th scope="row">TR Issued Date</th>
    <td>${payDetailMap.trIssuDt}</td>
</tr>
</tbody>
</table><!-- table end -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="rePay_grid_wrap" style="width:100%; height:300px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

</section><!-- tap_wrap end -->

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